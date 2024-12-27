%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-10-16 21:15:44
 * @LastEditTime: 2024-12-27 22:47:24
 * @FilePath: \GHV_open\GHV_modle\tra_kin.m
 * @Description: 平动运动学 第四组方程
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%平动运动学方程 第四组方程

%input:
% V:        单位 m/s    飞行器的空速 简化认为空速和低速相等
% air_ang:  单位rad     气流角 alpha攻角 beta侧滑角
% att_ang:  单位 rad    机体对大地的欧拉角 姿态角 phi滚转角 theta俯仰角 psi偏航角
% w:        单位 rad/s  机体转动角速度 wx,wy,wz 1*3
%output:
% d_position:      单位m/s   飞行器对地的三轴速度分量 d_x d_y d_h 其中 d_h取向上为正 和大地坐标系定义相反

function [d_x, d_y, d_h] = tra_kin(V, air_ang, att_ang)
    d_x = zeros(1, 1); %#ok<PREALL>
    d_y = zeros(1, 1); %#ok<PREALL>
    d_h = zeros(1, 1); %#ok<PREALL>
    %输入赋值
    phi = att_ang(1, 1); %读取滚转角数据
    theta = att_ang(2, 1); %读取俯仰角数据
    psi = att_ang(3, 1); %读取偏航角数据

    alpha = air_ang(1, 1); %读取攻角数据
    beta = air_ang(2, 1); %读取侧滑角数据
    %计算
    u = V * cos(alpha) * cos(beta);
    v = V * sin(beta);
    w = V * sin(alpha) * cos(beta);
    d_x = u * cos(theta) * cos(psi) ...
        + v * (sin(phi) * sin(theta) * cos(psi) - cos(phi) * sin(psi)) ...
        + w * (sin(phi) * sin(psi) + cos(phi) * sin(theta) * cos(psi));
    d_y = u * cos(theta) * sin(psi) ...
        + v * (sin(phi) * sin(theta) * sin(psi) + cos(phi) * cos(psi)) ...
        + w * (-sin(phi) * cos(psi) + cos(phi) * sin(theta) * sin(psi));
    d_h = u * sin(theta) - v * sin(phi) * cos(theta) - w * cos(phi) * cos(theta);
    %输出

end
