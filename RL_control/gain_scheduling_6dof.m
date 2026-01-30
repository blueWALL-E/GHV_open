%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-27 20:17:32
 * @LastEditTime: 2026-01-30 23:31:50
 * @FilePath: \GHV_open\RL_control\gain_scheduling_6dof.m
 * @Description: 三通道六自由度增益调度函数 线性插值
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
%gain_scheduling_6dof  三通道六自由度增益调度函数 线性插值
%input
% H          单位 m    海拔高度
%output
% control_param_mu      单位 n.d.  控制参数 mu
% control_param_alpha   单位 n.d.  控制参数 alpha
% control_param_beta    单位 n.d.  控制参数 beta
function [control_param_mu, control_param_alpha, control_param_beta] = gain_scheduling_6dof(H)

    if H < 25000
        H = 25000;
    elseif H > 40000
        H = 40000;
    end

    H_sample = [25000; 30000; 35000; 40000];
    method = 'linear';
    % ================== mu ==================
    mu_lambad_p_data = [8; 8; 5; 5];
    mu_lambad_I_data = [0.1; 0.1; 0.2; 0.1];
    mu_k_data = [400; 500; 600; 600];
    mu_epsilon_data = [0.001; 0.001; 0.001; 0.001];
    mu_gamma_rho_data = [300; 210; 210; 210];

    mu_lambad_p = interp1(H_sample, mu_lambad_p_data, H, method, 'extrap');
    mu_lambad_I = interp1(H_sample, mu_lambad_I_data, H, method, 'extrap');
    mu_k = interp1(H_sample, mu_k_data, H, method, 'extrap');
    mu_epsilon = interp1(H_sample, mu_epsilon_data, H, method, 'extrap');
    mu_gamma_rho = interp1(H_sample, mu_gamma_rho_data, H, method, 'extrap');

    % ================== alpha ==================
    alpha_lambad_p_data = [5; 3; 2; 1.5];
    alpha_lambad_I_data = [0.1; 0.2; 0.2; 0.1];
    alpha_k_data = [300; 500; 800; 1700];
    alpha_epsilon_data = [0.0001; 0.0001; 0.0001; 0.0001];
    alpha_gamma_rho_data = [100; 180; 150; 230];

    alpha_lambad_p = interp1(H_sample, alpha_lambad_p_data, H, method, 'extrap');
    alpha_lambad_I = interp1(H_sample, alpha_lambad_I_data, H, method, 'extrap');
    alpha_k = interp1(H_sample, alpha_k_data, H, method, 'extrap');
    alpha_epsilon = interp1(H_sample, alpha_epsilon_data, H, method, 'extrap');
    alpha_gamma_rho = interp1(H_sample, alpha_gamma_rho_data, H, method, 'extrap');

    % ================== beta ==================
    beta_lambad_p_data = [10; 10; 10; 10];
    beta_lambad_I_data = [0.1; 0.1; 0.1; 0.1];
    beta_k_data = [200; 200; 200; 200];
    beta_epsilon_data = [0.001; 0.001; 0.001; 0.001];
    beta_gamma_rho_data = [100; 130; 100; 100];

    beta_lambad_p = interp1(H_sample, beta_lambad_p_data, H, method, 'extrap');
    beta_lambad_I = interp1(H_sample, beta_lambad_I_data, H, method, 'extrap');
    beta_k = interp1(H_sample, beta_k_data, H, method, 'extrap');
    beta_epsilon = interp1(H_sample, beta_epsilon_data, H, method, 'extrap');
    beta_gamma_rho = interp1(H_sample, beta_gamma_rho_data, H, method, 'extrap');

    % ================== 输出 ==================
    control_param_mu = [mu_lambad_p; mu_lambad_I; mu_k; mu_epsilon; mu_gamma_rho];
    control_param_alpha = [alpha_lambad_p; alpha_lambad_I; alpha_k; alpha_epsilon; alpha_gamma_rho];
    control_param_beta = [beta_lambad_p; beta_lambad_I; beta_k; beta_epsilon; beta_gamma_rho];

end
