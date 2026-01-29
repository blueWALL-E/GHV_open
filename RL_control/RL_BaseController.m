%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-07 17:51:00
 * @LastEditTime: 2026-01-21 11:26:22
 * @FilePath: \GHV_open\RL_control\RL_BaseController.m
 * @Description: 强化学习基础控制器 俯仰通道自适应滑模控制
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
 %}
%attitude_adaptive_smc MIMO非仿射自适应姿态控制
%input
% dd_aero_ang_d 单位 rad/s^2    期望姿态控制角度二阶导向量 3*1
% aero_ang_e    单位 rad        姿态控制角度误差向量 3*1
% d_aero_ang_e  单位 rad/s      姿态控制角度误差一阶导向量 3*1
% i_aero_ang_e  单位 rad*s      姿态控制角度误差积分向量 3*1
% rho_smc       单位 n.d.       自适应权重向量 3*1
% t             单位 s          当前时间
% control_param 单位 n.d.      控制参数向量 5*1
%                             control_param = [lambad_p_alpha; lambad_I_alpha; k_alpha; epsilon_alpha; gamma_rho_alpha];

% mu = aero_ang(1, 1); %#ok<NASGU>
% alpha = aero_ang(2, 1);
% beta = aero_ang(3, 1); %#ok<NASGU>

%output
% LE         单位 deg   左舵偏转角度
% RE         单位 deg   右舵偏转角度
% RUD        单位 deg   方向舵偏转角度
% d_rho_smc  单位 n.d.  自适应权重更新向量 3*1
% S          单位 n.d.  滑模面向量 3*1
function [LE, RE, RUD, d_rho_smc, S] = RL_BaseController(dd_aero_ang_d, aero_ang_e, d_aero_ang_e, i_aero_ang_e, rho_smc, control_param_alpha, control_param_bate, control_param_mu)
    %输出变量初始化
    d_rho_smc = zeros(3, 1);
    S = zeros(3, 1);
    %输入变量赋值

    lambad_p_mu = control_param_mu(1, 1); %滑模面权重-比例项
    lambad_I_mu = control_param_mu(2, 1); %滑模面
    k_mu = control_param_mu(3, 1); %趋近率权重
    epsilon_mu = control_param_mu(4, 1); %滑模面宽度
    gamma_rho_mu = control_param_mu(5, 1); %自适应增益

    lambad_p_alpha = control_param_alpha(1, 1); %滑模面权重-比例项
    lambad_I_alpha = control_param_alpha(2, 1); %滑模面权重-积分项
    k_alpha = control_param_alpha(3, 1); %趋近率权重
    epsilon_alpha = control_param_alpha(4, 1); %滑模面宽度
    gamma_rho_alpha = control_param_alpha(5, 1); %自适应增益

    lambad_p_beta = control_param_bate(1, 1); %滑模面权重-比例项
    lambad_I_beta = control_param_bate(2, 1); %滑模面权重-积分项
    k_beta = control_param_bate(3, 1); %趋近率权重
    epsilon_beta = control_param_bate(4, 1); %滑模面宽度
    gamma_rho_beta = control_param_bate(5, 1); %自适应增益

    %期望姿态控制角度二阶导
    dd_mu_d = dd_aero_ang_d(1, 1);
    dd_alpha_d = dd_aero_ang_d(2, 1);
    dd_beta_d = dd_aero_ang_d(3, 1);
    %姿态控制角度误差
    mu_e = aero_ang_e(1, 1);
    alpha_e = aero_ang_e(2, 1);
    beta_e = aero_ang_e(3, 1);
    %姿态控制角度误差一阶导
    d_mu_e = d_aero_ang_e(1, 1);
    d_alpha_e = d_aero_ang_e(2, 1);
    d_beta_e = d_aero_ang_e(3, 1);
    %姿态控制角度误差积分
    i_mu_e = i_aero_ang_e(1, 1);
    i_alpha_e = i_aero_ang_e(2, 1);
    i_beta_e = i_aero_ang_e(3, 1);
    %自适应权重
    rho_mu = rho_smc(1, 1);
    rho_alpha = rho_smc(2, 1);
    rho_beta = rho_smc(3, 1);

    %控制参数

    a_mu = 0.0001; %Lyapunov设计项
    a_alpha = 0.0001; %Lyapunov设计项
    a_beta = 0.0001; %Lyapunov设计项

    %滑模面计算
    S_mu = d_mu_e ...
        + lambad_p_mu * mu_e ...
        + lambad_I_mu * i_mu_e;
    S_alpha = d_alpha_e ...
        + lambad_p_alpha * alpha_e ...
        + lambad_I_alpha * i_alpha_e;
    S_beta = d_beta_e ...
        + lambad_p_beta * beta_e ...
        + lambad_I_beta * i_beta_e;

    %mu通道控制律
    u_eq_mu = dd_mu_d + lambad_p_mu * d_mu_e + lambad_I_mu * mu_e + k_mu * S_mu; %等效控制律
    % u_eq_mu = dd_mu_d + lambad_p_mu * d_mu_e + lambad_I_mu * mu_e - F_mu + k_mu * S_mu; %等效控制律
    u_ro_mu = rho_mu * tanh(S_mu / epsilon_mu); %鲁棒控制律
    u_mu = u_eq_mu + u_ro_mu; %#ok<NASGU> %总控制律
    % u_mu = 0;
    d_rho_smc_mu = gamma_rho_mu * (abs(S_mu) - 0.2785 * epsilon_mu - a_mu * rho_mu); %自适应律

    %alpha通道控制律
    u_eq_alpha = dd_alpha_d + lambad_p_alpha * d_alpha_e + lambad_I_alpha * alpha_e + k_alpha * S_alpha; %等效控制律
    % u_eq_alpha = dd_alpha_d + lambad_p_alpha * d_alpha_e + lambad_I_alpha * alpha_e - F_alpha + k_alpha * S_alpha; %等效控制律
    u_ro_alpha = rho_alpha * tanh(S_alpha / epsilon_alpha); %鲁棒控制律
    u_alpha = u_eq_alpha + u_ro_alpha; %#ok<NASGU> %总控制律
    % u_alpha = 0;
    d_rho_smc_alpha = gamma_rho_alpha * (abs(S_alpha) - 0.2785 * epsilon_alpha - a_alpha * rho_alpha); %自适应律

    %beta通道控制律
    u_eq_beta = dd_beta_d + lambad_p_beta * d_beta_e + lambad_I_beta * beta_e + k_beta * S_beta; %等效控制律
    % u_eq_beta = dd_beta_d + lambad_p_beta * d_beta_e + lambad_I_beta * beta_e - F_beta + k_beta * S_beta; %等效控制律
    u_ro_beta = rho_beta * tanh(S_beta / epsilon_beta); %鲁棒控制律
    u_beta = u_eq_beta + u_ro_beta; %#ok<NASGU> %总控制律
    % u_beta = 0;
    d_rho_smc_beta = gamma_rho_beta * (abs(S_beta) - 0.2785 * epsilon_beta - a_beta * rho_beta); %自适应律

    %输出
    %舵面计算
    LE = u_alpha - u_mu; %左舵偏转角度

    RE = u_alpha + u_mu; %右舵偏转角度

    RUD = u_beta; %方向舵偏转角度

    if LE > 30
        LE = 30;
    elseif LE < -30
        LE = -30;
    end

    if RE > 30
        RE = 30;
    elseif RE < -30
        RE = -30;
    end

    if RUD > 30
        RUD = 30;
    elseif RUD < -30
        RUD = -30;

        d_rho_smc = [d_rho_smc_mu; d_rho_smc_alpha; d_rho_smc_beta]; %自适应权重更新向量
        S = [S_mu; S_alpha; S_beta]; %滑模面向量
    end
