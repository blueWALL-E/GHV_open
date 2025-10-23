%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-23 22:15:21
 * @LastEditTime: 2025-10-23 23:22:05
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

    if t < 130
        alpha = 7;
    else
        alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
        % alpha = 0.5;
    end

end
