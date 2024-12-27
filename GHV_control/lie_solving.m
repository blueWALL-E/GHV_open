%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-11-01 17:09:49
 * @LastEditTime: 2024-12-27 22:45:40
 * @FilePath: \GHV_open\GHV_control\lie_solving.m
 * @Description: 李式导数的求解 为控制器设计做准备
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
clear
clc
syms wx wy wz phi theta

f4 = wx + (wz * cos(phi) + wy * sin(phi)) * tan(theta);
f5 = wy * cos(phi) - wz * sin(phi);
f6 = (1 / cos(theta)) * (wz * cos(phi) + wy * sin(phi));

f4_wx = simplify(diff(f4, wx));
f4_wy = simplify(diff(f4, wy));
f4_wz = simplify(diff(f4, wz));
f4_phi = simplify(diff(f4, phi));
f4_theta = simplify(diff(f4, theta));

f5_wx = simplify(diff(f5, wx));
f5_wy = simplify(diff(f5, wy));
f5_wz = simplify(diff(f5, wz));
f5_phi = simplify(diff(f5, phi));
f5_theta = simplify(diff(f5, theta));

f6_wx = simplify(diff(f6, wx));
f6_wy = simplify(diff(f6, wy));
f6_wz = simplify(diff(f6, wz));
f6_phi = simplify(diff(f6, phi));
f6_theta = simplify(diff(f6, theta));
F = [f4_wx, f4_wy, f4_wz, f4_phi, f4_theta; ...
         f5_wx, f5_wy, f5_wz, f5_phi, f5_theta; ...
         f6_wx, f6_wy, f6_wz, f6_phi, f6_theta];
disp(F);
