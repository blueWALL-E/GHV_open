%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-29 23:27:53
 * @LastEditTime: 2026-01-30 00:49:57
 * @FilePath: \GHV_open\RL_control\ref_aero_ang_dDOF.m
 * @Description: 6DOF参考气动角度飞行时序
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

function aero_ang_ref = ref_aero_ang_dDOF(t, Ma)
    % ===== alpha_best(Ma) =====
    p1 = -5.447e-05; p2 = 0.003999; p3 = -0.1117;
    p4 = 1.475; p5 = -9.176; p6 = 25.62;
    alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + ...
        p4 * Ma ^ 2 + p5 * Ma + p6;

    % % ===== 回合时间窗 =====
    % round1_begin = 5; round1_end = 25; % doublet
    % round2_begin = 160; round2_end = 180; % doublet
    % 
    % % ===== doublet 参数 =====
    % A3 = 0.8;
    % T = 10;
    % gap = 20;
    % cycle = 2 * T + gap;
    % 
    % % ===== 默认：其他时间点为最佳攻角（兜底）=====
    % alpha = 4;
    % 
    % % ===== 回合1：doublet（修正 tau）=====
    % if t >= round1_begin && t < round1_end
    %     tau = t - round1_begin; % ✅ 关键修正：用 round1_begin
    %     k = mod(tau, cycle);
    % 
    %     if k < T
    %         delta = +A3;
    %     elseif k < 2 * T
    %         delta = -A3;
    %     else
    %         delta = 0;
    %     end
    % 
    %     alpha = 4 + delta; % 覆盖默认值
    % end
    % 
    % % ===== 回合2：doublet =====
    % if t >= round2_begin && t < round2_end
    %     tau = t - round2_begin; % round2 本来就是对的
    %     k = mod(tau, cycle);
    % 
    %     if k < T
    %         delta = +A3;
    %     elseif k < 2 * T
    %         delta = -A3;
    %     else
    %         delta = 0;
    %     end
    % 
    %     alpha = 4 + delta; % 覆盖默认值
    % end

    aero_ang_ref = [0; alpha_best; 0];
end
