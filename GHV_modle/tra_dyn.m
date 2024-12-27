%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-10-15 20:26:14
 * @LastEditTime: 2024-12-27 22:47:15
 * @FilePath: \GHV_open\GHV_modle\tra_dyn.m
 * @Description: 平动动力学 第三组方程
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%平动动力学方程 第三组方程
%气流标系下 输入输出向量均为列向量
%input:
% Fair:     单位 N      气动力 在速度坐标系中 D Y L 表示大小 符合和方向无关
% g:        单位 m/s^2  飞行器所在位置的重力加速度
% V:        单位 m/s    飞行器的空速 简化认为空速和低速相等
% air_ang:  单位 rad    气流角 alpha攻角 beta侧滑角
% att_ang:  单位 rad    机体对大地的欧拉角 姿态角 phi滚转角 theta俯仰角 psi偏航角
% w:        单位 rad/s  机体转动角速度 wx,wy,wz 1*3
%output:
% d_V:      单位m/s^2   飞行器的加速度
% d_air_ang:单位rad/s    飞行器气流角的角加速度
function [d_V, d_air_ang] = tra_dyn(Fair, g, V, air_ang, att_ang, w)
    %输出矩阵大小定义
    d_V = zeros(1, 1); %#ok<PREALL>
    d_air_ang = zeros(2, 1);

    % m = 63500; %飞行器最小质量 单位 kg
    m = 136077; %飞行器最大质量 单位 kg
    %输入变量赋值
    %三轴气动力 D Y L只表示大小 不表示方向
    D = Fair(1, 1); %读取阻力数据
    Y = Fair(2, 1); %读取侧向力数据
    L = Fair(3, 1); %读取升力数据
    T = 0; %发动机推力 在这里简单理解为方向为机体系x轴负方向 大小为0 方便计算
    phi = wrapToPi(att_ang(1, 1)); %读取滚转角数据
    theta = wrapToPi(att_ang(2, 1)); %读取俯仰角数据
    % psi = att_ang(3, 1); %偏航角不影响姿态角速度和机体转动角速度之间的转换

    alpha = air_ang(1, 1); %读取攻角数据
    beta = air_ang(2, 1); %读取侧滑角数据

    wx = w(1, 1); %读取x轴机体角速度
    wy = w(2, 1); %读取y轴机体角速度
    wz = w(3, 1); %读取z轴机体角速度

    %计算
    if (V ~= 0) %速度正常情况
        gxa = g * (-cos(alpha) * cos(beta) * sin(theta) + sin(beta) * sin(phi) * cos(theta) ...
            +sin(alpha) * cos(beta) * cos(phi) * cos(theta));
        gya = g * (cos(alpha) * sin(beta) * sin(theta) + cos(beta) * sin(phi) * cos(theta) ...
            - sin(alpha) * sin(beta) * cos(phi) * cos(theta));
        gza = g * (sin(alpha) * sin(theta) + cos(alpha) * cos(phi) * cos(theta));

        d_V = (1 / m) * (T * cos(alpha) * cos(beta) - D) + gxa;
        d_beta = (1 / V * m) * (-T * cos(alpha) * sin(beta) + Y) ...
            - (-wx * sin(alpha) + wz * cos(alpha)) + (1 / V) * gya;
        d_alpha = (1 / (m * V * cos(beta))) * (-T * sin(alpha) - L) ...
            + (1 / cos(beta)) * (-wx * cos(alpha) * sin(beta) + wy * cos(beta) - wz * sin(alpha) * sin(beta)) ...
            + (1 / (V * cos(beta))) * gza;

    else %避免速度为0的奇异情况
        alpha = 0;
        beta = 0;

        gxa = g * (-cos(alpha) * cos(beta) * sin(theta) + sin(beta) * sin(phi) * cos(theta) ...
            +sin(alpha) * cos(beta) * cos(phi) * cos(theta));

        d_V = (1 / m) * (T * cos(alpha) * cos(beta) - D) + gxa;
        d_alpha = 0;
        d_beta = 0;

    end

    %输出
    d_air_ang(1, 1) = d_alpha;
    d_air_ang(2, 1) = d_beta;
end
