%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-20 21:38:10
 * @LastEditTime: 2025-12-20 22:50:11
 * @FilePath: \GHV_open\RL_control\data\gain_scheduling.m
 * @Description: alpha 通道增益调度函数 线性插值
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%gain_scheduling  alpha 通道增益调度函数 线性插值
%input
% H          单位 m    海拔高度

%output
% lambda_p_alpha    单位 n.d.  比例增益
% lambda_I_alpha    单位 n.d.  积分增益
% k_alpha          单位 n.d.  趋近率增益
% epsilon_alpha    单位 n.d.  滑模面宽度
% gamma_rho_alpha  单位 n.d.  自适应增益
function [lambda_p_alpha, lambda_I_alpha, k_alpha, epsilon_alpha, gamma_rho_alpha] = gain_scheduling(H)

    % ================== 离散高度点 ==================
    H_data = [15000; 20000; 30000; 40000; 50000; 60000];

    % ================== 对应参数 ==================
    lambda_p_data = [3.1; 5; 3; 1.3; 0.7; 0.35];
    lambda_I_data = [0.3; 0.25; 0; 0; 0; 0.001];
    k_data = [10; 10; 1; 5; 1; 1];
    epsilon_data = [0.001; 0.005; 0.005; 0.005; 0.001; 0.0005];
    gamma_rho_data = [200; 100; 270; 300; 800; 1500];

    % ================== 插值设置 ==================
    method = 'linear';

    % ================== 范围检查（安全） ==================
    Hmin = 15000;
    Hmax = 70000;

    if any(H < Hmin | H > Hmax)
        error('H 超出插值范围 [%.0f, %.0f] m', Hmin, Hmax);
    end

    % ================== 线性插值 ==================
    lambda_p_alpha = interp1(H_data, lambda_p_data, H, method, 'extrap');
    lambda_I_alpha = interp1(H_data, lambda_I_data, H, method, 'extrap');
    k_alpha = interp1(H_data, k_data, H, method, 'extrap');
    epsilon_alpha = interp1(H_data, epsilon_data, H, method, 'extrap');
    gamma_rho_alpha = interp1(H_data, gamma_rho_data, H, method, 'extrap');

end
