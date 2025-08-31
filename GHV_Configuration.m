%{
/*
* @Author:blueWALL - E
* @Date:2025 - 05 - 23 21:43:50
 * @LastEditTime: 2025-08-31 23:48:15
 * @FilePath: \GHV_open\GHV_Configuration.m
* @Description: 飞行器基本参数信息
* @Wearing:Read only, do not modify place !!!
* @Shortcut keys: ctrl+alt+/ ctrl+alt+z
* @Wearing:Read only, do not modify place !!!
* @Shortcut keys:ctrl + alt +/ ctrl + alt + z
*/
%}

%单位换算常数 尽量避免使用吧 但保留这个接口
d2r = pi / 180; % Conversion Deg to Rad
g = 9.81; % Gravity [m/s/s]
m2ft = 3.28084; % meter to feet
Kg2slug = 0.0685218; % Kg to slug
Kg2lb = 2.20462; % Kg to lb

% 飞行器基本参数
% 需要使用的飞行器自身的参数-标准单位制 米 牛顿
GHV_cfg = struct();
GHV_cfg.c_ref = 24.38; %单位 m 机翼平均弦长
GHV_cfg.b_ref = 18.29; %单位 m 机翼展长
GHV_cfg.s_ref = 334.73; %机翼参考面积 单位 m2
GHV_cfg.x_cg = 2.9; %单位 m 力矩中心到质心的距离
GHV_cfg.mass_full = 136077; %单位 kg 飞行器最大质量
GHV_cfg.Jx = -7.1e-5 * GHV_cfg.mass_full ^ 2 + 19.91 * GHV_cfg.mass_full -5.943e4; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.Jy = -8.03e-4 * GHV_cfg.mass_full ^ 2 + 219.74 * GHV_cfg.mass_full -1.69e6; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.Jz = -8.03e-4 * GHV_cfg.mass_full ^ 2 + 219.74 * GHV_cfg.mass_full -1.69e6; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.J = diag([GHV_cfg.Jx, GHV_cfg.Jy, GHV_cfg.Jz]); %单位 kg*m^2 机体转动惯量矩阵
Simulink.Bus.createObject(GHV_cfg); %名字是slBus1 作为总线信号 方便simulink调用

%飞行器初始状态
Ma = 6; %初始马赫数
altitude = 10000; %初始高度 单位 m
[~, vc, ~, ~, ~] = EarthEnvironment(altitude); %获取大气参数
Position_init = [0; 0; -altitude]; % 初始位置 大地坐标系
Euler_init = [0; 0; 0]; %初始姿态 欧拉角 机体坐标系
Omega_init = [0; 0; 0]; %初始角速度 机体坐标系
Speed_init = [Ma * vc; 0; 0]; %初始速度 机体坐标系
