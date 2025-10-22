%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-21 10:18:50
 * @LastEditTime: 2025-10-21 11:05:37
 * @FilePath: \GHV_open\GHV_trajectory\three_dof_trajectory.m
 * @Description: 垂直平面内三自由度轨迹方程
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
%垂直平面内三自由度轨迹方程
%input:
%T:      单位 N       推力
%D:      单位 N       阻力（在机体坐标系下）
%L:      单位 N       升力（在机体坐标系下）
%alpha:  单位 rad     攻角
%m:      单位 kg      质量
%g:      单位 m/s^2   重力加速度
%V:      单位 m/s     速度
%gamma:  单位 rad     航迹倾角

%output:
%d_V:      单位 m/s^2   速度变化率
%d_gamma:  单位 rad/s   航迹倾角变化率
%d_x:      单位 m/s     水平位置变化率
%d_h:      单位 m/s     垂直位置变化率
function [d_V, d_gamma, d_x, d_h] = three_dof_trajectory(T, D, L, alpha, m, g, V, gamma)

    d_V = ((T * cos(alpha) - D) / m )- g * sin(gamma);
    d_gamma = ((T * sin(alpha) + L) / m - g * cos(gamma)) / V;
    d_x = V * cos(gamma);
    d_h = V * sin(gamma);

end
