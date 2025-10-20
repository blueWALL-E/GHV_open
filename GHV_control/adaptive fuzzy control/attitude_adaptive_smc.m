%{
/*
 * @Author:blueWALL-E
 * @Date:2025-10-12 19:46:57
 * @LastEditTime: 2025-10-20 12:04:20
 * @FilePath: \GHV_open\GHV_control\adaptive fuzzy control\attitude_adaptive_smc.m
 * @Description:MIMO非仿射自适应姿态控制
 * @Wearing:Read only, do not modify place !!!
 * @Shortcut keys:ctrl+alt+/ ctrl+alt+z
 */
%}
%attitude_adaptive_smc MIMO非仿射自适应姿态控制
%input
% I             单位 kg*m^2     转动惯量矩阵 3*3
% w             单位 rad/s      机体转动角速度向量 p q r 3*1
% aero_ang      单位 rad        姿态控制角度向量 mu alpha beta 3*1 //这个说法不太严谨 mu是航迹滚转角 和气动无关 但先这样命名
% dd_aero_ang_d 单位 rad/s^2    期望姿态控制角度二阶导向量 3*1
% aero_ang_e    单位 rad        姿态控制角度误差向量 3*1
% d_aero_ang_e  单位 rad/s      姿态控制角度误差一阶导向量 3*1
% i_aero_ang_e  单位 rad*s      姿态控制角度误差积分向量 3*1
% rho_smc       单位 n.d.       自适应权重向量 3*1
% M_F           单位 N*m        仿射气动项产生的力矩向量 3*1

%output
% LE         单位 deg   左舵偏转角度
% RE         单位 deg   右舵偏转角度
% RUD        单位 deg   方向舵偏转角度
% d_rho_smc  单位 n.d.  自适应权重更新向量 3*1
% S          单位 n.d.  滑模面向量 3*1
function [LE, RE, RUD, d_rho_smc, S] = attitude_adaptive_smc(I, w, aero_ang, dd_aero_ang_d, aero_ang_e, d_aero_ang_e, i_aero_ang_e, rho_smc, M_F)
    %输出变量初始化
    d_rho_smc = zeros(3, 1); %#ok<PREALL>
    S = zeros(3, 1); %#ok<PREALL>
    %输入变量赋值
    %转动惯量矩阵对角线元素
    Ix = I(1, 1);
    Iy = I(2, 2);
    Iz = I(3, 3);
    %机体转动角速度
    p = w(1, 1);
    q = w(2, 1);
    r = w(3, 1);
    %姿态控制角度
    mu = aero_ang(1, 1); %#ok<NASGU>
    alpha = aero_ang(2, 1);
    beta = aero_ang(3, 1); %#ok<NASGU>
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
    %仿射气动项产生的力矩
    l_F = M_F(1, 1);
    m_F = M_F(2, 1);
    n_F = M_F(3, 1);

    %控制参数
    %滑模面权重-比例项
    lambad_p_mu = 0;
    lambad_p_alpha = 5;
    lambad_p_beta = 0;
    %滑模面权重-比例项
    lambad_I_mu = 0;
    lambad_I_alpha = 0;
    lambad_I_beta = 0;
    %趋近率权重
    k_mu = 0;
    k_alpha = 0.1;
    k_beta = 0;
    %滑模面宽度
    epsilon_mu = 0.005;
    epsilon_alpha = 0.005;
    epsilon_beta = 0.005;
    %自适应增益
    gamma_rho_mu = 0;
    gamma_rho_alpha = 90;
    gamma_rho_beta = 0;
    %Lyapunov设计项
    a_mu = 0;
    a_alpha = 0.001;
    a_beta = 0;

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

    %仿射项计算
    F_mu = ((Ix - Iy - Iz) / Iz) * p * q * sin(alpha) + ((Ix + Iy - Iz) / Ix) * q * r * cos(alpha) ...
        + (cos(alpha) / Ix) * l_F + (sin(alpha) / Iz) * n_F;
    F_alpha = ((Iz - Ix) / Iy) * p * r + (1 / Iy) + m_F;
    F_beta = ((Iz - Ix - Iy) / Iz) * p * q * cos(alpha) + ((Ix + Iy - Iz) / Ix) * q * r * sin(alpha) ...
        + (sin(alpha) / Ix) * l_F - (cos(alpha) / Iz) * n_F;

    %mu通道控制律
    u_eq_mu = dd_mu_d + lambad_p_mu * d_mu_e + lambad_I_mu * mu_e - F_mu + k_mu * S_mu; %等效控制律
    u_ro_mu = rho_mu * tanh(S_mu / epsilon_mu); %鲁棒控制律
    % u_mu = u_eq_mu + u_ro_mu; %总控制律
    u_mu = 0; %总控制律
    d_rho_smc_mu = gamma_rho_mu * (abs(S_mu) - 0.2785 * epsilon_mu - a_mu * rho_mu); %自适应律

    %alpha通道控制律
    u_eq_alpha = dd_alpha_d + lambad_p_alpha * d_alpha_e + lambad_I_alpha * alpha_e + k_alpha * S_alpha; %等效控制律
    % u_eq_alpha = dd_alpha_d + lambad_p_alpha * d_alpha_e + lambad_I_alpha * alpha_e - F_alpha + k_alpha * S_alpha; %等效控制律
    u_ro_alpha = rho_alpha * tanh(S_alpha / epsilon_alpha); %鲁棒控制律
    u_alpha = u_eq_alpha + u_ro_alpha; %总控制律
    d_rho_smc_alpha = gamma_rho_alpha * (abs(S_alpha) - 0.2785 * epsilon_alpha - a_alpha * rho_alpha); %自适应律

    %beta通道控制律
    u_eq_beta = dd_beta_d + lambad_p_beta * d_beta_e + lambad_I_beta * beta_e - F_beta + k_beta * S_beta; %等效控制律
    u_ro_beta = rho_beta * tanh(S_beta / epsilon_beta); %鲁棒控制律
    % u_beta = u_eq_beta + u_ro_beta; %总控制律
    u_beta = 0; %总控制律
    d_rho_smc_beta = gamma_rho_beta * (abs(S_beta) - 0.2785 * epsilon_beta - a_beta * rho_beta); %自适应律

    %输出
    %舵面计算
    LE = u_alpha; %左舵偏转角度
    % LE = u_alpha - u_beta; %左舵偏转角度
    RE = u_alpha; %右舵偏转角度
    % RE = u_alpha + u_beta; %右舵偏转角度
    RUD = 0; %方向舵偏转角度
    % RUD = u_mu; %方向舵偏转角度
    d_rho_smc = [d_rho_smc_mu; d_rho_smc_alpha; d_rho_smc_beta]; %自适应权重更新向量
    S = [S_mu; S_alpha; S_beta]; %滑模面向量
end
