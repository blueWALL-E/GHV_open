%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-10-11 20:59:54
 * @LastEditTime: 2024-12-27 22:46:33
 * @FilePath: \GHV_open\GHV_modle\rot_dyn.m
 * @Description: 转动动力学方程 第一组方程
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%转动动力学方程 第一组方程
%机体坐标系下 输入输出向量均为列向量
%input:
%Mb:    单位 N*m     合外力矩 1*3
%w:     单位 rad/s   机体转动角速度 wx,wy,wz 1*3
%J:     单位 kg*m^2  机体的转动惯量 Jx,Jy,Jz 1*3
%output:
%d_w:   单位 rad/s^2 机体转动角加速度 1*3
function [d_w] = rot_dyn(Mb, w)
    %输出矩阵大小定义
    d_w = zeros(3, 1); %#ok<*PREALL>
    %输入变量赋值
    Mx = Mb(1, 1);
    My = Mb(2, 1);
    Mz = Mb(3, 1);
    wx = w(1, 1);
    wy = w(2, 1);
    wz = w(3, 1);
    %机体的三轴转动惯量
    %最小转动惯量 质量最小时
    % Jx = 637234;
    % Jy = 6101181;
    % Jz = 6101181;

    %最大转动惯量 质量最大时
    Jx = 1.36 * 10 ^ 6;
    Jy = 1.5 * 10 ^ 7;
    Jz = 1.36 * 10 ^ 7;
    %计算
    d_wx = ((wy * wz) / Jx) * (Jy - Jz) + Mx / Jx;
    d_wy = ((wz * wx) / Jy) * (Jz - Jx) + My / Jy;
    d_wz = ((wx * wy) / Jz) * (Jx - Jy) + Mz / Jz;
    %输出变量赋值
    d_w = [d_wx; d_wy; d_wz];
end
