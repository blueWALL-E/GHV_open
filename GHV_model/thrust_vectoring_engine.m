%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-07-22 11:40:06
 * @LastEditTime: 2026-07-23 17:19:52
 * @FilePath: \GHV_open\GHV_model\thrust_vectoring_engine.m
 * @Description: 推力矢量发动机模型
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

% thrust_vectoring_engine 推力矢量发动机模型
%
% 参考文献：
% Raney D L, Phillips M R, Person Jr L H.
% Investigation of piloting aids for manual control of
% hypersonic maneuvers[R]. 1995.
%
% 输入（标准 SI 单位制）：
% engine_enable  -       发动机使能：
%                           0：发动机彻底关闭
%                           非0：发动机正常工作
% WF             kg/s    实际燃料质量流率，必须为非负值
% Q              Pa      动压
% Ma             -       马赫数
% delta_y        deg     推力矢量横向偏转角
% delta_z        deg     推力矢量纵向偏转角
% GHV_cfg        struct  飞行器参数
% x_cg           m       飞行器质心位置
%
% 输出（标准 SI 单位制）：
% F_T            N       发动机推力矢量
% M_T            N*m     发动机力矩
% Isp            s       比冲；发动机关闭时为 0
% d_mass         kg/s    飞行器质量变化率；消耗燃料时为负

function [F_T, M_T, Isp, d_mass] = thrust_vectoring_engine( ...
        engine_enable, WF, Q, Ma, delta_y, delta_z, GHV_cfg, x_cg)

    %% 输出初始化

    F_T = zeros(3, 1);
    M_T = zeros(3, 1);
    Isp = 0.0;
    d_mass = 0.0;

    %% 发动机硬使能模块

    % engine_enable 可以是 logical，也可以是数值 0/1。
    % 这里将所有非零值视为发动机开启。
    engine_on = (engine_enable ~= 0);

    % 发动机关闭时，所有发动机输出严格为零。
    % 使用提前返回可避免最小燃料流量、当量比限幅以及插值计算
    % 产生任何非零推力或燃料消耗。
    if ~engine_on
        return;
    end

    %% 输入限制

    % 论文模型适用范围：0.3 <= Ma <= 25
    Ma_model = min(max(Ma, 0.3), 25.0);
    % 防止出现负动压和负燃料质量流率
    Q_SI = max(Q, 0.0); % Pa
    WF_SI = max(WF, 0.0); % kg/s

    %% 将 SI 输入转换为英制单位

    q_psf = Q_SI * UnitConst.Pa2psf; % lbf/ft^2
    WF_lbm_s = WF_SI * UnitConst.kg2lbm; % lbm/s

    %% 发动机安装位置

    % GHV_cfg.x_cT 和 x_cg 均使用 SI 单位 m
    x_cT = GHV_cfg.x_cT;
    dx = x_cT - x_cg;

    %% 当量比计算

    % 原论文关系：
    %
    % WF_eta1 [lbm/s]
    %     = q [lbf/ft^2] * exp(f1(Ma))
    %
    % f1(Ma) 是基于原英制数据库建立的经验函数。

    WF_eta1_lbm_s = q_psf * exp(f1_fun(Ma_model));
    % 处理零动压情况
    if WF_eta1_lbm_s > 0.0
        eta = WF_lbm_s / WF_eta1_lbm_s;
    elseif WF_lbm_s > 0.0
        % 有燃料流量但参考流量为零，当量比趋于无穷
        eta = Inf;
    else
        % 发动机虽然处于使能状态，但输入燃料流量为零
        eta = 0.0;
    end

    % 图 A1 中用于比冲限制支路的当量比范围
    eta_limited = min(max(eta, 0.1), 10.0);

    %% 比冲模型

    Isp_nominal = ISP1_fun(Ma_model); % s
    Isp_max = f2_fun(Ma_model) ...
        / eta_limited; % s

    Isp = min(Isp_nominal, Isp_max); % s

    %% 英制推力计算

    % 严格关系：
    %
    % T[lbf] =
    % Isp[s] * WF[lbm/s] * g0_US / gc_US
    %
    % g0_US/gc_US 数值为 1，但保留该项以明确 lbm 和 lbf
    % 的量纲转换关系。

    T_lbf = Isp ...
        * WF_lbm_s ...
        * (UnitConst.g0_US / UnitConst.gc_US); % lbf

    %% 推力转换回 SI

    T_norm = T_lbf * UnitConst.lbf2N; % N

    %% 推力矢量分解

    % 保留原有参数化和正负号约定
    Tx = T_norm * cosd(delta_y) * cosd(delta_z);
    Ty = T_norm * sind(delta_y) * cosd(delta_z);
    Tz = T_norm * sind(delta_z);

    F_T = [Tx; Ty; Tz];

    %% 推力力矩

    % 保留原有力矩正负号约定
    l = 0.0;
    m = dx * Tz;
    n = -dx * Ty;

    M_T = [l; m; n];

    %% 飞行器质量状态导数

    % 发动机开启时，根据实际燃料流量扣除质量
    d_mass_lbm_s = -WF_lbm_s; % lbm/s
    d_mass = d_mass_lbm_s * UnitConst.lbm2kg; % kg/s

end

function f1 = f1_fun(Ma)
    %F1_FUN 图 A2 中的 f1(Ma) 插值函数

    Ma = min(max(Ma, 0.3), 25.0);
    xData = [-1.20000; -0.15065; 3.20000];
    fData = [0.14207; -1.61141; -3.16976];
    x = log(Ma);

    % 图中端点是近似值，需对 ln(Ma) 再做端点限幅，
    % 防止 Ma=0.3 或 Ma=25 时 interp1 返回 NaN。
    x = min(max(x, xData(1)), xData(end));
    f1 = interp1(xData, fData, x, 'linear');

end

function ISP1 = ISP1_fun(Ma)
    %ISP1_FUN 图 A3 中 eta=1 时的比冲函数

    Ma = min(max(Ma, 0.3), 25.0);
    xData = [0.00; 0.90; 1.50; 2.00; 4.28];
    fData = [1300; 3100; 3100; 3600; 3600];

    if Ma <= 4.28
        ISP1 = interp1(xData, fData, Ma, 'linear');
    else
        ISP1 = 1.0 ...
            / (0.000077 + 0.00004688 * Ma);

    end

end

function f2 = f2_fun(Ma)
    %F2_FUN 图 A4 中的比冲限制函数

    Ma = min(max(Ma, 0.3), 25.0);
    xData = [0; 4; 8; 25];
    fData = [3118; 4089; 2868; 2530];
    f2 = interp1(xData, fData, Ma, 'linear');

end
