%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-12-23 10:40:15
 * @LastEditTime: 2024-12-27 22:45:49
 * @FilePath: \GHV_open\GHV_control\Sliding_mode.m
 * @Description: 俯仰通道滑模控制器
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%俯仰通道滑模控制器
%input:
% d_air_ang:    单位rad/s   飞行器气流角的角加速度
% air_ang:      单位 rad    气流角 alpha攻角 beta侧滑角
% E_alpha:      单位 rad    期望的攻角状态
%output:
% U_delta_LE:   单位deg     左升降舵偏转角度
% U_delta_RE:   单位deg     右升降舵偏转角度

function [U_delta_LE, U_delta_RE] = Sliding_mode(d_air_ang, air_ang, E_alpha)
    %输出矩阵大小定义
    U_delta_LE = zeros(1, 1); %#ok<PREALL>
    U_delta_RE = zeros(1, 1); %#ok<PREALL>
    %输入变量赋值
    %气流角角速度
    d_alpha = d_air_ang(1, 1);
    %d_beta = d_air_ang(2, 1); %#ok<NASGU>
    %气流角角度
    alpha = air_ang(1, 1);
    %beta = air_ang(2, 1); %#ok<NASGU>

    %滑模控制率设计
    S = 1 * (alpha - E_alpha) + d_alpha; %定义滑模面

    U_delta_RE = 20 * sign(S); %正舵引起负偏转 所以前面没有负号
    U_delta_LE = 20 * sign(S);

end
