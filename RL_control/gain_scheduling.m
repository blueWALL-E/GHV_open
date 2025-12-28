%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-20 21:38:10
 * @LastEditTime: 2025-12-26 20:01:40
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
% lambad_p_alpha    单位 n.d.  比例增益
% lambad_I_alpha    单位 n.d.  积分增益
% k_alpha          单位 n.d.  趋近率增益
% epsilon_alpha    单位 n.d.  滑模面宽度
% gamma_rho_alpha  单位 n.d.  自适应增益
function [lambad_p_alpha, lambad_I_alpha, k_alpha, epsilon_alpha, gamma_rho_alpha] = gain_scheduling(H)

    % ================== 离散高度点 ==================
    H_data = [25000; 30000; 35000; 40000; 45000; 50000; 55000];

    % ================== 对应参数 ==================
    % lambad_p_data = [5; 3; 2.1; 1.4; 0.7; 0.6; 0.25];
    % lambad_I_data = [0.1; 0.1; 0.1; 0.1; 0.1; 0.05; 0.001];
    % k_data = [200; 300; 600; 850; 1250; 1900; 2500];
    % epsilon_data = [0.005; 0.005; 0.005; 0.005; 0.005; 0.001; 0.0001];
    % gamma_rho_data = [100; 100; 150; 150; 150; 120; 120];

    lambad_p_data = [5; 3; 2; 1.5; 1; 0.8; 0.5];
    lambad_I_data = [0.1; 0.2; 0.2; 0.05; 0.05; 0.01; 0.005];
    k_data = [300; 500; 800; 170; 2500; 3500; 4000];
    epsilon_data = [0.001; 0.001; 0.001; 0.001; 0.001; 0.001; 0.001];
    gamma_rho_data = [100; 180; 150; 230; 130; 230; 250];

    % ================== 插值设置 ==================
    method = 'linear';

    % ================== 范围检查（安全） ==================
    % Hmin = 15000;
    % Hmax = 70000;

    % if any(H < Hmin | H > Hmax)
    %     error('H exceeds the interpolation range [15000 70000]');
    % end

    % ================== 线性插值 ==================
    lambad_p_alpha = interp1(H_data, lambad_p_data, H, method, 'extrap');
    lambad_I_alpha = interp1(H_data, lambad_I_data, H, method, 'extrap');
    k_alpha = interp1(H_data, k_data, H, method, 'extrap');
    epsilon_alpha = interp1(H_data, epsilon_data, H, method, 'extrap');
    gamma_rho_alpha = interp1(H_data, gamma_rho_data, H, method, 'extrap');

    if H > 55000
        lambad_p_alpha = 0.5;
        lambad_I_alpha = 0.005;
        k_alpha = 4500;
        epsilon_alpha = 0.001;
        gamma_rho_alpha = 250;
    end

end
