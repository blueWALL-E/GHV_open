%{
/*
 * @Author:blueWALL-E
 * @Date:2025-09-15 14:33:57
 * @LastEditTime: 2026-02-05 18:12:23
 * @FilePath: \GHV_open\GHV_model\Propulsion_model.m
 * @Description: 组合发动机推力模型
 * @Wearing:Read only, do not modify place !!!
 * @Shortcut keys: ctrl+alt+/ ctrl+alt+z
 */
%}

%Propulsion_model 组合发动机推力模型
%input
% PLA       单位 [%]    油门开度
% H         单位 m      飞行高度
% Ma        单位 n.d.   马赫数
% delta_y   单位 deg    矢量发动机偏转角y方向
% delta_z   单位 deg    矢量发动机偏转角x方向
% GHV_cfg   单位 NaN    飞行器基本参数结构体
% x_cg      单位 m      飞行器质心位置

%output
% F_T       单位 N      发动机推力 3*1向量
% M_T       单位 N*m    发动机力矩 3*1向量
% Isp       单位 s      比冲
% d_mass    单位 kg/s   燃料消耗率
%//TODO Ma＞6 油门为0时推力为负数 Ma5左右 推力为负数 文献就这样写的 但感觉是个bug
function [F_T, M_T, Isp, d_mass] = Propulsion_model(PLA, H, Ma, delta_y, delta_z, GHV_cfg, x_cg)
    %输出矩阵定义
    F_T = zeros(3, 1); %#ok<PREALL>
    M_T = zeros(3, 1); %#ok<PREALL>
    %输入参数提取
    x_cT = GHV_cfg.x_cT;
    x_cg_element = x_cg;
    %输入检查
    % 输入检查
    if Ma < 0 % 马赫数小于0
        error('Mach number input error: Ma should not be less than 0');
    elseif Ma > 24 % 马赫数大于24
        error('Mach number input error: Ma should not exceed 24');
    end

    if PLA < 0 % 油门开度小于0
        error('PLA input error: PLA should not be less than 0');
    elseif PLA > 1 % 油门开度大于1
        error('PLA input error: PLA should not exceed 1');
    end

    if PLA == 0 %油门为0时直接返回0
        T_norm = 0;
    elseif Ma <= 2 %涡轮发动机
        T_norm = PLA .* (1.33e6 - 4.45 .* H +5.92e-4 .* H .^ 2 -2.88e-9 .* H .^ 3 +1.67e4 .* Ma .^ 3);
    elseif Ma <= 6 %冲压发动机
        T_norm = PLA * ( ...
            3.35e3 .* Ma .^ 7 ...
            -6.68e4 .* Ma .^ 6 ...
            +5.16e5 .* Ma .^ 5 ...
            -1.94e6 .* Ma .^ 4 ...
            +3.59e6 .* Ma .^ 3 ...
            -3.10e6 .* Ma .^ 2 ...
            +1.75e6 .* Ma ...
            +1.75e+7);
    else %火箭发动机
        %//TODO 油门为0时推力为负数 文献就这样写的 但感觉是个bug
        if H < 17373.6
            T_norm = 2.95 .* H +1.44e6 .* PLA + 1.66 .* H .* PLA;
        else
            T_norm = 2.41e6 .* PLA;
        end

    end

    %推力矢量分解
    %这个地方的分解不同于球面坐标系
    Tx = T_norm * cosd(delta_y) * cosd(delta_z);
    Ty = T_norm * cosd(delta_z) * sind(delta_y);
    Tz = T_norm * sind(delta_z);
    F_T = [Tx; Ty; Tz];
    %力矩计算
    l = 0; %滚转力矩
    m = (x_cT - x_cg_element) * Tz; %俯仰力矩
    n =- (x_cT - x_cg_element) * Ty; %偏航力矩
    M_T = [l; m; n];

    %比冲模型
    Isp = 1867 ...
        + 1454 * Ma ...
        - 406.2 * Ma .^ 2 ...
        + 44.49 * Ma .^ 3 ...
        - 2.453 * Ma .^ 4 ...
        + 0.06806 * Ma .^ 5 ...
        - 0.0007576 * Ma .^ 6;
    %燃料消耗率
    g0 = 9.80665; %标准重力加速度 单位 m/s^2
    d_mass = -T_norm / (Isp * g0); %燃料消耗率

end
