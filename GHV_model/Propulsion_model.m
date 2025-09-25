%{
/*
* @Author:blueWALL-E
* @Date:2025-09-15 14:33:57
 * @LastEditTime: 2025-09-26 00:23:29
 * @FilePath: \GHV_open\GHV_model\Propulsion_model.m
* @Description: 组合发动机推力模型
* @Wearing:Read only, do not modify place !!!
* @Shortcut keys:ctrl+alt+/ ctrl+alt+z
*/
%}

%Propulsion_model 组合发动机推力模型
%input
% PLA    单位 [%] 油门开度
% H     单位 m 飞行高度
% Ma    单位 n.d. 马赫数
% delta_y 单位 deg 矢量发动机偏转角
% delta_z 单位 deg 矢量发动机偏转角
% GHV_cfg 飞行器基本参数结构体

%output
% F_T     单位 N 发动机推力 3*1向量
% M_T     单位 N*m 发动机力矩 3*1向量
% Isp   单位 s 比冲
% dmass 单位 kg/s 燃料消耗率
%//TODO Ma＞6 油门为0时推力为负数 Ma5左右 推力为负数 文献就这样写的 但感觉是个bug
function [F_T, M_T, Isp, dmass] = Propulsion_model(PLA, H, Ma, delta_y, delta_z, GHV_cfg, x_cg)
    %输出矩阵定义
    F_T = zeros(1, 3); %#ok<PREALL>
    M_T = zeros(1, 3); %#ok<PREALL>
    %输入参数提取
    x_cT = GHV_cfg.x_cT;
    x_cg_element = x_cg(1, 1);
    %输入检查
    if Ma < 0 || Ma > 24 %马赫数检查
        error(' Mach number input error, should be between 0 and 24');
    elseif PLA < 0 || PLA > 1 %油门开度检查
        error(' PLA input error, should be between 0 and 1');
    elseif PLA == 0 %油门为0时直接返回0
        T_norm = 0;
    elseif Ma <= 2 %涡轮发动机
        T_norm = PLA * (2.99e-8 -32.81 * H +1.43e-3 * H ^ 2 -2.59e-8 * H ^ 3 +3.75e3 * Ma);
    elseif Ma <= 6 %冲压发动机
        T_norm = PLA * (3.93e-8 ...
            +3.94e5 * Ma ...
            -6.97e5 * Ma .^ 2 ...
            +8.07e5 * Ma .^ 3 ...
            -4.36e5 * Ma .^ 4 ...
            +1.16e5 * Ma .^ 5 ...
            -1.50e4 * Ma .^ 6 ...
            +7.53e2 * Ma .^ 7);
    else %火箭发动机
        %//TODO 油门为0时推力为负数 文献就这样写的 但感觉是个bug
        if H < 17373.6
            T_norm = -5.43e4 + 2.178 * H +3.24e5 * PLA + 0.374 * H * PLA;
        else
            T_norm = -1.64e4 +6.69295e5 * PLA;
        end

    end

    %推力矢量分解
    %这个地方的分解不同于球面坐标系
    Tx = T_norm * cosd(delta_y) * cosd(delta_z);
    Ty = T_norm * cosd(delta_z) * sind(delta_y);
    Tz = T_norm * sind(delta_z);
    F_T = [-Tx, Ty, Tz];
    %力矩计算
    l = 0; %滚转力矩
    m = (x_cT - x_cg_element) * Tz; %俯仰力矩
    n =- (x_cT - x_cg_element) * Ty; %偏航力矩
    M_T = [l, m, n];

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
    dmass = -T_norm / (Isp * g0); %燃料消耗率

end
