%{
/*
* @Author:blueWALL-E
* @Date:2025-09-15 14:33:57
 * @LastEditTime: 2025-09-20 22:35:24
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

%output
% T     单位 N 推力

function T = Propulsion_model(PLA, H, Ma)

    if Ma < 0 || Ma > 24
        error(' Mach number input error, should be between 0 and 24');
    end

    if Ma <= 2 % (1)涡轮发动机
        T = PLA * (2.99e-8 -32.81 * H +1.43e-3 * H ^ 2 -2.59e-8 * H ^ 3 +3.75e3 * Ma);

    elseif Ma <= 6 % (2) 冲压发动机
        T = PLA * (3.93e-8 ...
            +3.94e5 * Ma ...
            -6.97e5 * Ma .^ 2 ...
            +8.07e5 * Ma .^ 3 ...
            -4.36e5 * Ma .^ 4 ...
            +1.16e5 * Ma .^ 5 ...
            -1.50e4 * Ma .^ 6 ...
            +7.53e2 * Ma .^ 7);

    else % (3) 火箭发动机

        if H < 17373.6
            T = -5.43e4 + 2.178 * H +3.24e5 * PLA + 0.374 * H * PLA;
        else
            T = -1.64e4 +6.69295e5 * PLA;
        end

    end

end
