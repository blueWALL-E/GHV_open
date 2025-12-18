%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-23 22:15:21
 * @LastEditTime: 2025-12-18 11:08:45
 * @FilePath: \GHV_open\GHV_trajectory\reference_alpha.m
 * @Description: 参考攻角变化规律
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
function alpha = reference_alpha(t, Ma)

    % 多项式系数
    p1 = -5.447e-05;
    p2 = 0.003999;
    p3 = -0.1117;
    p4 = 1.475;
    p5 = -9.176;
    p6 = 25.62;

    % 计算最佳升阻比对应攻角
    alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

    % 过渡时间（秒）
    transition_time = 5; % 增加过渡时间以平滑变化

    t1 = 60; % 发动机关机时间

    if t < t1
        alpha = 6;

    elseif t < t1 + transition_time %过渡过程
        alpha_start = 6;
        alpha_end = alpha_best;
        alpha = alpha_start + (alpha_end - alpha_start) * (t - t1) / transition_time;
    else %最佳升阻比对应攻角
        alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

    end

end
