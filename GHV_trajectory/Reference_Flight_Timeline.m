%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-19 14:52:06
 * @LastEditTime: 2025-10-20 11:34:58
 * @FilePath: \GHV_open\GHV_trajectory\Reference_Flight_Timeline.m
 * @Description: 参考飞行时序
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%参考飞行时序设计
%机体坐标系下 输入输出向量均为列向量
%input:
%t:        单位 s      时间

%output:
%att_ang: 单位 rad/s  姿态角 3*1
function att_ang = Reference_Flight_Timeline(t)

    %输出变量初始化
    att_ang = zeros(3, 1); %#ok<PREALL>
    % %爬升阶段
    % if t < 50
    %     %程序转弯
    %     theta = deg2rad(t * 0.4); %俯仰角匀速增加到50度
    % elseif t >= 50 && t < 90
    %     %固定姿态飞行
    %     theta = deg2rad(20); %保持50度俯仰角
    % elseif t >= 90 && t < 150
    %     %程序转弯
    %     theta = deg2rad(20 - (t - 90) * (1/3)); %俯仰角匀速减小到0度
    % else
    %     theta = 0; %水平飞行
    % end
    if t <= 130 %上升段
        p1 = 4.873e-09;
        p2 = -2.341e-06;
        p3 = 0.0004286;
        p4 = -0.03711;
        p5 = 1.377;
        p6 = 5.928;

        theta_deg = p1 * t ^ 5 + p2 * t ^ 4 + p3 * t ^ 3 + p4 * t ^ 2 + p5 * t + p6;
        theta = deg2rad(theta_deg); %转换为弧度制
    else
        error('Time exceeds the reference flight timing design(t>=130s)');
    end

    att_ang = [0; theta; 0]; %滚转角为0，偏航角为0

end
