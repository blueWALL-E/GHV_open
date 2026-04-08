%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-02-04 16:43:58
 * @LastEditTime: 2026-03-16 14:11:54
 * @FilePath: \GHV_open\RL_control\gain_scheduling_control_param_6dof.m
 * @Description: 控制参数关于高度和马赫数的二维增益调度函数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
%gain_scheduling_control_param_6dof  三通道六自由度增益调度函数（高度 + 马赫数，二维线性插值）
%input
% H          单位 m    海拔高度
% Ma         单位 n.d.  马赫数
%output
% control_param_mu      单位 n.d.  控制参数 mu
% control_param_alpha   单位 n.d.  控制参数 alpha
% control_param_beta    单位 n.d.  控制参数 beta
function [control_param_mu, control_param_alpha, control_param_beta] = gain_scheduling_control_param_6dof(H, Ma)
    % 三通道六自由度增益调度：H + Ma 二维散点线性插值，nearest 外推
    % 适合 Simulink 反复调用：插值器只初始化一次（persistent）
    coder.extrinsic('scatteredInterpolant');
    persistent F_mu_lp F_mu_lI F_mu_k F_mu_eps F_mu_gr
    persistent F_al_lp F_al_lI F_al_k F_al_eps F_al_gr
    persistent F_be_lp F_be_lI F_be_k F_be_eps F_be_gr
    H = H / 1000;

    if isempty(F_mu_lp)
        % ================== 数据（22 点） ==================
        h = [20; 20; 20; 20; 25; 25; 25; 25; 30; 30; 30; 30; 35; 35; 35; 35; 40; 40; 40; 40; 45; 45];
        ma = [7; 6.55; 5.88; 5.36; 6.72; 6.51; 5.59; 5.33; 6.51; 6.40; 5.37; 5.23; 6.27; 6.20; 5.12; 5.05; 5.99; 5.96; 4.86; 4.83; 5.75; 5.73];

        % ---- mu ----
        % mu_lp = [9; 9; 8; 7.5; 8; 8; 9; 9; 8; 8; 7; 7; 6; 6; 5; 5; 6.5; 6.5; 4.5; 4.5; 4; 4];
        mu_lp = [9; 9; 8; 7.5; 8; 8; 9; 9; 8; 8; 7; 7; 6; 6; 5; 5; 6.5; 6.5; 4.5; 4.5; 2; 2];

        mu_lI = 0.1 * ones(22, 1);
        mu_k = [400; 400; 400; 400; 400; 400; 400; 400; 500; 500; 500; 500; 600; 600; 600; 600; 600; 600; 600; 600; 600; 600];
        mu_eps = 0.001 * ones(22, 1);
        mu_gr = [300; 300; 300; 300; 300; 300; 300; 300; 210; 210; 210; 210; 210; 210; 210; 210; 210; 210; 210; 210; 210; 210];

        % ---- alpha ----
        % al_lp = [7; 7; 6; 5.5; 4.5; 4.5; 4; 4; 3; 3; 2; 2; 1.5; 1.5; 1; 1; 1; 1; 0.7; 0.7; 0.7; 0.7];
        al_lp = [7; 7; 6; 5.5; 4.5; 4.5; 4; 4; 3; 3; 2; 2; 1.5; 1.5; 1; 1; 1; 1; 0.7; 0.7; 0.7; 0.7] .* 2;

        al_lI = [0.2; 0.2; 0.2; 0.2; 0.1; 0.1; 0.1; 0.1; 0.2; 0.2; 0.2; 0.2; 0.3; 0.3; 0.3; 0.3; 0.1; 0.1; 0.1; 0.1; 0.02; 0.02];
        al_k = [300; 300; 300; 300; 300; 300; 200; 200; 500; 500; 500; 500; 800; 800; 800; 800; 1700; 1700; 2100; 2100; 2100; 2100];
        al_eps = 0.001 * ones(22, 1);
        al_gr = [100; 100; 100; 100; 100; 100; 100; 100; 180; 180; 180; 180; 150; 150; 150; 150; 150; 150; 150; 150; 150; 150];

        % ---- beta ----
        % be_lp = [10; 10; 7; 7; 8; 8; 8; 8; 10; 10; 13; 13; 20; 20; 15; 15; 15; 15; 15; 15; 20; 20];
        be_lp = [10; 10; 7; 7; 8; 8; 8; 8; 10; 10; 13; 13; 20; 20; 15; 15; 15; 15; 15; 15; 25; 25];

        be_lI = 0.1 * ones(22, 1);
        be_k = [200; 200; 200; 200; 200; 200; 200; 200; 200; 200; 200; 200; 300; 300; 300; 300; 300; 300; 300; 300; 1000; 1000];
        be_eps = 0.001 * ones(22, 1);
        be_gr = [100; 100; 100; 100; 100; 100; 100; 100; 130; 130; 130; 130; 130; 130; 130; 130; 130; 130; 130; 130; 130; 130];

        % ================== 构建插值器（只做一次） ==================
        F_mu_lp = scatteredInterpolant(h, ma, mu_lp, 'linear', 'nearest');
        F_mu_lI = scatteredInterpolant(h, ma, mu_lI, 'linear', 'nearest');
        F_mu_k = scatteredInterpolant(h, ma, mu_k, 'linear', 'nearest');
        F_mu_eps = scatteredInterpolant(h, ma, mu_eps, 'linear', 'nearest');
        F_mu_gr = scatteredInterpolant(h, ma, mu_gr, 'linear', 'nearest');

        F_al_lp = scatteredInterpolant(h, ma, al_lp, 'linear', 'nearest');
        F_al_lI = scatteredInterpolant(h, ma, al_lI, 'linear', 'nearest');
        F_al_k = scatteredInterpolant(h, ma, al_k, 'linear', 'nearest');
        F_al_eps = scatteredInterpolant(h, ma, al_eps, 'linear', 'nearest');
        F_al_gr = scatteredInterpolant(h, ma, al_gr, 'linear', 'nearest');

        F_be_lp = scatteredInterpolant(h, ma, be_lp, 'linear', 'nearest');
        F_be_lI = scatteredInterpolant(h, ma, be_lI, 'linear', 'nearest');
        F_be_k = scatteredInterpolant(h, ma, be_k, 'linear', 'nearest');
        F_be_eps = scatteredInterpolant(h, ma, be_eps, 'linear', 'nearest');
        F_be_gr = scatteredInterpolant(h, ma, be_gr, 'linear', 'nearest');
    end

    % ================== 每次调用：只查询 + 拼向量 ==================
    control_param_mu = [ ...
                            F_mu_lp(H, Ma); ...
                            F_mu_lI(H, Ma); ...
                            F_mu_k(H, Ma); ...
                            F_mu_eps(H, Ma); ...
                            F_mu_gr(H, Ma) ...
                        ];

    control_param_alpha = [ ...
                               F_al_lp(H, Ma); ...
                               F_al_lI(H, Ma); ...
                               F_al_k(H, Ma); ...
                               F_al_eps(H, Ma); ...
                               F_al_gr(H, Ma) ...
                           ];

    control_param_beta = [ ...
                              F_be_lp(H, Ma); ...
                              F_be_lI(H, Ma); ...
                              F_be_k(H, Ma); ...
                              F_be_eps(H, Ma); ...
                              F_be_gr(H, Ma) ...
                          ];
end
