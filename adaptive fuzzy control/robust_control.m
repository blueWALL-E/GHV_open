%{
/*
* @Author:blueWALL-E
* @Date:2025-06-17 09:58:51
 * @LastEditTime: 2025-08-31 21:44:28
 * @FilePath: \GHV_open\adaptive fuzzy control\robust_control.m
* @Description: 鲁棒控制模块
* @Wearing:Read only, do not modify place !!!
* @Shortcut keys: ctrl+alt+/ ctrl+alt+z
*/
%}
%鲁棒控制模块
%input:
% s:        单位 n.d.     控制滑模面
% rho:      单位 n.d.     自适应权重
%output:
% d_rho:    单位 n.d.     自适应权重更新
% uro:      单位 n.d.     鲁棒控制输出

function [d_rho, uro] = robust_control(s, rho)
    epsilon = 0.005; % 滑模面宽度
    gamma_rho = 100; % 自适应增益
    a = 0.001; % Lyapunov方程计算得到所需项

    % 鲁棒控制律
    uro = rho * (tanh(s / epsilon)); % 饱和函数代替符号函数，减小抖振
    % 自适应律
    d_rho = gamma_rho * (abs(s) - 0.2785 * epsilon - a * rho);

end
