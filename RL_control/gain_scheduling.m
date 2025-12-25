%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-20 21:38:10
 * @LastEditTime: 2025-12-22 14:16:14
 * @FilePath: \GHV_open\RL_control\gain_scheduling.m
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
    H_data = [25000; 30000; 35000; 40000; 45000; 50000; 55000];

    % ================== 对应参数 ==================
    lambda_p_data = [5; 3; 2.1; 1.4; 0.7; 0.6; 0.25];
    lambda_I_data = [0.1; 0.1; 0.1; 0.1; 0.1; 0.05; 0.001];
    k_data = [200; 300; 600; 850; 1250; 1900; 2500];
    epsilon_data = [0.005; 0.005; 0.005; 0.005; 0.005; 0.001; 0.0001];
    gamma_rho_data = [100; 100; 150; 150; 150; 120; 120];

    % ================== 插值设置 ==================
    method = 'linear';

    % ================== 范围检查（安全） ==================
    % Hmin = 15000;
    % Hmax = 70000;

    % if any(H < Hmin | H > Hmax)
    %     error('H exceeds the interpolation range [15000 70000]');
    % end

    % ================== 线性插值 ==================
    lambda_p_alpha = interp1(H_data, lambda_p_data, H, method, 'extrap');
    lambda_I_alpha = interp1(H_data, lambda_I_data, H, method, 'extrap');
    k_alpha = interp1(H_data, k_data, H, method, 'extrap');
    epsilon_alpha = interp1(H_data, epsilon_data, H, method, 'extrap');
    gamma_rho_alpha = interp1(H_data, gamma_rho_data, H, method, 'extrap');

    if H > 55000
        lambda_p_alpha = 0.25;
        lambda_I_alpha = 0.001;
        k_alpha = 2500;
        epsilon_alpha = 0.0001;
        gamma_rho_alpha = 100;
    end

end
