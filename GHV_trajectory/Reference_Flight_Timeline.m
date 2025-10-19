%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-19 14:52:06
 * @LastEditTime: 2025-10-19 15:13:36
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
    %爬升阶段
    if t < 50
        %程序转弯
        theta = deg2rad(t); %俯仰角匀速增加到50度
    elseif t >= 50 && t < 150
        %固定姿态飞行
        theta = deg2rad(50); %保持50度俯仰角
    else
        theta = deg2rad(50); %保持50度俯仰角
    end

    att_ang = [0; theta; 0]; %滚转角为0，偏航角为0

end
