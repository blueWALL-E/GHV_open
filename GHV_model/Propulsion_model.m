%{
/*
* @Author:blueWALL-E
* @Date:2025-09-15 14:33:57
 * @LastEditTime: 2025-09-21 23:30:22
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

%output
% T     单位 N 推力
% Isp   单位 s 比冲

function [T, Isp] = Propulsion_model(PLA, H, Ma, delta_y, delta_z)
    %输出矩阵定义
    T = zeros(3, 1); %#ok<PREALL>
    %输入检查
    if Ma < 0 || Ma > 24
        error(' Mach number input error, should be between 0 and 24');
    end

    if Ma <= 2 %涡轮发动机
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

        if H < 17373.6
            T_norm = -5.43e4 + 2.178 * H +3.24e5 * PLA + 0.374 * H * PLA;
        else
            T_norm = -1.64e4 +6.69295e5 * PLA;
        end

    end

    %推力矢量分解 //TODO 力矩的计算还没有解决
    Tx = T_norm * cosd(delta_y) * cosd(delta_z);
    Ty = T_norm * cosd(delta_z) * sind(delta_y);
    Tz = T_norm * sind(delta_z);
    T = [Tx; Ty; Tz];

    %比冲模型
    Isp = 1867 ...
        + 1454 * Ma ...
        - 406.2 * Ma .^ 2 ...
        + 44.49 * Ma .^ 3 ...
        - 2.453 * Ma .^ 4 ...
        + 0.06806 * Ma .^ 5 ...
        - 0.0007576 * Ma .^ 6;

end
