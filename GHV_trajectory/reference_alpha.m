%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-23 22:15:21
 * @LastEditTime: 2025-10-27 12:00:28
 * @FilePath: \GHV_open\GHV_trajectory\reference_alpha.m
 * @Description: 参考攻角变化规律
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
 %}
function alpha = reference_alpha(t, Ma)
    p1 = -5.447e-05;
    p2 = 0.003999;
    p3 = -0.1117;
    p4 = 1.475;
    p5 = -9.176;
    p6 = 25.62;

    transition_time = 5; % 过渡时间（秒）
    t1 = 140; % 起始时间点 130
    t2 = 1840; % 结束时间点 1873

    if t < t1
        alpha = 7;
    elseif t < t1 + transition_time
        % 平滑过渡：从 alpha = 7 到多项式计算值
        alpha_start = 7;
        alpha_end = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
        alpha = alpha_start + (alpha_end - alpha_start) * (t - t1) / transition_time;
    elseif t <= t2
        alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
    elseif t <= t2 + transition_time * 2
        % 平滑过渡：从多项式计算值到 alpha = 0.1
        alpha_start = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
        alpha_end = 0.1;
        alpha = alpha_start + (alpha_end - alpha_start) * (t - t2) / (transition_time * 2);
    else
        alpha = 0.1;
    end

end
