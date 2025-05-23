%{
/*
* @Author:blueWALL - E
* @Date:2025 - 05 - 23 21:43:50
 * @LastEditTime: 2025-05-23 22:05:23
 * @FilePath: \GHV_open\GHV_Configuration.m
* @Description: 飞行器基本参数信息
* @Wearing:Read only, do not modify place ! !!
* @Shortcut keys:ctrl + alt +/ ctrl + alt + z
*/
%}

%常用的单位换算常数
d2r = pi / 180; % Conversion Deg to Rad
g = 9.81; % Gravity [m/s/s]
m2ft = 3.28084; % meter to feet
Kg2slug = 0.0685218; % Kg to slug
Kg2lb = 2.20462; % Kg to lb

% 飞行器基本参数
% 需要使用的飞行器自身的参数-标准单位制 米 牛顿
%数字代表米 实际参与计算的时候换算成英制单位 避免混乱
b_ref = 18.29 / m2ft; %机翼翼展 单位 m
c_ref = 24.38 / m2ft; %平均几何弦长 单位 m
s_ref = 334.73 / m2ft ^ 2; %机翼参考面积 单位 m2
x_cg = 2.9 / m2ft; %单位 m 力矩中心到质心的距离
mass_full = 136077 / Kg2lb; %单位 kg 飞行器最大质量
Jx = 1.36 * 10 ^ 6; %单位 kg*m^2 机体x轴的转动惯量
Jy = 1.5 * 10 ^ 7; %单位 kg*m^2 机体x轴的转动惯量
Jz = 1.36 * 10 ^ 7; %单位 kg*m^2 机体x轴的转动惯量
