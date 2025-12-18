%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-19 14:52:06
 * @LastEditTime: 2025-12-18 11:09:11
 * @FilePath: \GHV_open\GHV_trajectory\Reference_Flight_Timeline.m
 * @Description: 参考飞行时序
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%参考飞行时序设计
%机体坐标系下 输入输出向量均为列向量
%input:
%t:        单位 s       时间
%Ma:       单位 n.d.    马赫数

%output:
%d_aero_ang: 单位 deg/s    期望气流角 3*1 （航迹滚转角 攻角 侧滑角）
%Control_Propulsion:  单位 n.d. rad/s  发动机油门量与矢量控制角度 3*1
function [d_aero_ang, Control_Propulsion] = Reference_Flight_Timeline(t, Ma)

    % 多项式系数
    p1 = -5.447e-05;
    p2 = 0.003999;
    p3 = -0.1117;
    p4 = 1.475;
    p5 = -9.176;
    p6 = 25.62;

    % 计算最佳升阻比对应攻角
    alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

    % 过渡时间（秒）
    transition_time = 5; % 增加过渡时间以平滑变化

    t1 = 60; % 发动机关机时间

    if t < t1
        alpha = 6;

    elseif t < t1 + transition_time %过渡过程
        alpha_start = 6;
        alpha_end = alpha_best;
        alpha = alpha_start + (alpha_end - alpha_start) * (t - t1) / transition_time;
    else %最佳升阻比对应攻角
        alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

    end

    % 发动机推力控制规律
    if t <= t1
        % 阶段 1：PLA = 1
        PLA = 1;
    else
        PLA = 0;
    end

    d_aero_ang = [0; alpha; 0]; %气流攻角与侧滑角
    Control_Propulsion = [PLA; 0; 0]; %发动机推
end
