%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-19 14:52:06
 * @LastEditTime: 2025-11-03 13:47:06
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
%aero_ang: 单位 deg/s    气流角 3*1 （航迹滚转角 攻角 侧滑角）
%Control_Propulsion:  单位 n.d. rad/s  发动机油门量与矢量控制角度 3*1
function [aero_ang, Control_Propulsion] = Reference_Flight_Timeline(t, Ma)

    %Ma4-24最佳升阻比对应攻角多项式系数
    p1 = -5.447e-05;
    p2 = 0.003999;
    p3 = -0.1117;
    p4 = 1.475;
    p5 = -9.176;
    p6 = 25.62;

    % if t <= 140 %时间小于130s 时 维持高攻角爬升
    %     alpha = 6;
    %     PLA = 1;
    % elseif t <= 2500 % 时间在130s到2500s之间 时 采用最佳升阻比攻角 跳跃滑翔
    %     alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
    %     PLA = 0;
    % else % 时间大于1873s 时 俯冲
    %     alpha = 0.1;
    %     PLA = 0;
    % end

    % if t <= 60
    %     alpha = 6;
    %     PLA = 1;
    % else
    %     alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
    %     PLA = 0;
    % end

    transition_time = 2; % 过渡时间（秒）
    t1 = 60; % 起始时间点 130

    if t < t1
        alpha = 6;
        PLA = 1;
    elseif t < t1 + transition_time
        % 平滑过渡：从 alpha = 6 到多项式计算值
        alpha_start = 6;
        alpha_end = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
        alpha = alpha_start + (alpha_end - alpha_start) * (t - t1) / transition_time;
        PLA = 0;
    else
        alpha = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;
        PLA = 0;
    end

    aero_ang = [0; alpha; 0]; %气流攻角与侧滑角
    Control_Propulsion = [PLA; 0; 0]; %发动机推
end
