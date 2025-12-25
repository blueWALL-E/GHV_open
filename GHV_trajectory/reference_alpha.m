%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-23 22:15:21
 * @LastEditTime: 2025-12-22 00:04:55
 * @FilePath: \GHV_open\GHV_trajectory\reference_alpha.m
 * @Description: 参考攻角变化规律
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
% function alpha = reference_alpha(t, Ma)

%     % 多项式系数
%     p1 = -5.447e-05;
%     p2 = 0.003999;
%     p3 = -0.1117;
%     p4 = 1.475;
%     p5 = -9.176;
%     p6 = 25.62;

%     % 计算最佳升阻比对应攻角
%     alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

%     % 过渡时间（秒）
%     transition_time = 5; % 增加过渡时间以平滑变化

%     t1 = 60; % 发动机关机时间
%     t2_begin = 200; % 第一次机动开始时间
%     t2_end = 240; %  第一次机动结束时间

%     if t < t1
%         alpha = 6;

%     elseif t < t1 + transition_time %过渡过程
%         alpha_start = 6;
%         alpha_end = alpha_best;
%         alpha = alpha_start + (alpha_end - alpha_start) * (t - t1) / transition_time;
%     elseif t < t2_begin
%         alpha = alpha_best;
%     elseif t < t2_end %机动过程
%         % 添加方波逻辑
%         period = 40; % 周期
%         amplitude_max = 5; % 最大值
%         amplitude_min = 3; % 最小值
%         % 计算当前时间在周期内的位置
%         t_mod = mod(t - t2_begin, period);

%         if t_mod < period / 2
%             alpha = amplitude_max;
%         else
%             alpha = amplitude_min;
%         end

%     else %最佳升阻比对应攻角
%         alpha = alpha_best;

%     end

% end

function alpha = reference_alpha(t, Ma)

    % ===== alpha_best(Ma) =====
    p1 = -5.447e-05; p2 = 0.003999; p3 = -0.1117;
    p4 = 1.475; p5 = -9.176; p6 = 25.62;
    alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + ...
        p4 * Ma ^ 2 + p5 * Ma + p6;

    % ===== 起始段 =====
    transition_time = 5;
    t1 = 60;

    % ===== 回合时间窗 =====
    round2_begin = 200; round2_end = 240; % 阶跃保持
    round3_begin = 270; round3_end = 450; % doublet
    round4_begin = 560; round4_end = 820; % chirp

    % ===== 幅值调度 =====
    A2 = 1.0 * 1;
    A3 = 0.8 * 1;
    A4 = 0.2 * 1;

    % ===== 默认扰动 =====
    delta = 0;

    % ===== 起始与过渡 =====
    if t < t1
        alpha = 6;
        return;
    elseif t < t1 + transition_time
        alpha = 6 + (alpha_best - 6) * (t - t1) / transition_time;
        return;
    end

    % ===== 回合2：阶跃保持 =====
    if t >= round2_begin && t < round2_end
        tau = t - round2_begin;

        if tau < 30
            delta = +A2;
        elseif tau < 50
            delta = 0;
        elseif tau < 80
            delta = -A2;
        else
            delta = 0;
        end

        alpha = 4 + delta;
        return;
    end

    % ===== 回合3：doublet =====
    if t >= round3_begin && t < round3_end
        tau = t - round3_begin;

        T = 10;
        gap = 20;
        cycle = 2 * T + gap;
        k = mod(tau, cycle);

        if k < T
            delta = +A3;
        elseif k < 2 * T
            delta = -A3;
        else
            delta = 0;
        end

        alpha = 4 + delta;
        return;
    end

    % ===== 回合4：chirp =====
    if t >= round4_begin && t < round4_end
        tau = t - round4_begin;
        dur = round4_end - round4_begin;

        f0 = 1/50;
        f1 = 1/30;
        f = f0 + (f1 - f0) * (tau / dur);

        delta = A4 * sin(2 * pi * f * tau);

        alpha = alpha_best + delta;
        return;
    end

    % ===== 其它时间 =====
    alpha = alpha_best;

end
