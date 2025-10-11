%{
/*
 * @Author:blueWALL-E
 * @Date:2025-05-23 21:43:50
 * @LastEditTime: 2025-10-11 22:14:53
 * @FilePath: \GHV_open\GHV_Configuration.m
 * @Description: 飞行器基本参数信息
 * @Wearing:Read only, do not modify place !!!
 * @Shortcut keys: ctrl+alt+/ ctrl+alt+z
 */
%}

%单位换算常数 尽量避免使用吧 但保留这个接口
d2r = pi / 180; % Conversion Deg to Rad
m2ft = 3.28084; % meter to feet
Kg2slug = 0.0685218; % Kg to slug
Kg2lb = 2.20462; % Kg to lb

% 飞行器基本参数
% 需要使用的飞行器自身的参数-标准单位制 米 牛顿
GHV_cfg = struct();
GHV_cfg.c_ref = 24.38; %单位 m 机翼平均弦长
GHV_cfg.b_ref = 18.29; %单位 m 机翼展长
GHV_cfg.s_ref = 334.73; %单位 m2 机翼参考面积
GHV_cfg.x_cg = 2.9; %单位 m 力矩中心到质心的距离
GHV_cfg.x_cT = 23.16; %单位 m 发动机到参考力矩中心的距离
GHV_cfg.mass_full = 136077; %单位 kg 飞行器最大质量
GHV_cfg.Ix = -7.1e-5 * GHV_cfg.mass_full ^ 2 + 19.91 * GHV_cfg.mass_full -5.943e4; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.Iy = -8.03e-4 * GHV_cfg.mass_full ^ 2 + 219.74 * GHV_cfg.mass_full -1.69e6; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.Iz = -8.03e-4 * GHV_cfg.mass_full ^ 2 + 219.74 * GHV_cfg.mass_full -1.69e6; %单位 kg*m^2 机体x轴的转动惯量
GHV_cfg.I = diag([GHV_cfg.Ix, GHV_cfg.Iy, GHV_cfg.Iz]); %单位 kg*m^2 机体转动惯量矩阵
Simulink.Bus.createObject(GHV_cfg); %名字是slBus1 作为总线信号 方便simulink调用

%飞行器初始状态
Ma = 5; %初始马赫数 7
altitude = 20000; %初始高度 单位 m 10000
[~, vc, ~, ~, ~] = EarthEnvironment(altitude); %获取大气参数
Position_init = [0; 0; -altitude]; % 初始位置 大地坐标系ned 北东地
LLA_init = [19.6144722; 110.9510972; altitude]; %初始位置 大地坐标系 纬度 经度 高度
LLA_aim = [38.87099; -77.05596; 0]; %目标位置 大地坐标系 纬度 经度 高度
Euler_init = [0; 0; 0]; %初始姿态 欧拉角 机体坐标系相对于大地坐标系ned的角度
Omega_init = [0; 0; 0]; %初始角速度 机体坐标系
Speed_init = [Ma * vc; 0; 0]; %初始速度 机体坐标系
