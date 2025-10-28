%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-21 10:18:50
 * @LastEditTime: 2025-10-25 16:48:47
 * @FilePath: \GHV_open\GHV_trajectory\three_dof_sphere_trajectory.m
 * @Description: 垂直平面内三自由度轨迹方程-球面地球
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
%d_tau:    单位 s       绕地球中心角变化率
function [d_V, d_gamma, d_x, d_h, d_tau] = three_dof_sphere_trajectory(T, D, L, alpha, m, g, V, gamma)
    R = 6378137; %地球赤道半径，单位m
    d_V = ((T * cos(alpha) - D) / m) - g * sin(gamma);
    d_gamma = ((T * sin(alpha) + L) / (m * V)) + (((V / R) - (g / V)) * cos(gamma));
    d_h = V * sin(gamma);
    d_tau = (V * cos(gamma)) / R;
    d_x = R * d_tau;

end
