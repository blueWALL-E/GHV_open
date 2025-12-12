%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-19 14:52:06
 * @LastEditTime: 2025-12-10 16:04:52
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

    % 攻角变化规律
    % 多项式系数
    p1 = -5.447e-05;
    p2 = 0.003999;
    p3 = -0.1117;
    p4 = 1.475;
    p5 = -9.176;
    p6 = 25.62;

    % 计算最佳升阻比对应攻角
    alpha_best = p1 * Ma ^ 5 + p2 * Ma ^ 4 + p3 * Ma ^ 3 + p4 * Ma ^ 2 + p5 * Ma + p6;

    % 阶段时间点
    t1 = 60; % 阶段 1 结束时间
    t2 = 120; % 阶段 2 结束时间
    t3 = 180; % 阶段 3 结束时间

    % 方波参数
    max_value = 5; % 方波最大值
    min_value = 3; % 方波最小值
    period = 60; % 方波周期

    if t <= t1
        % 阶段 1：alpha = 6
        alpha = 6;
    else
        alpha = alpha_best;
        % elseif t <= t2
        %     % 阶段 2：最佳升阻比对应攻角
        %     alpha = alpha_best;
        % elseif t <= t3
        %     % 阶段 3：方波
        %     % 计算方波值
        %     phase = mod(t - t2, period); % 当前时间点在周期内的位置

        %     if phase < period / 2
        %         alpha = max_value; % 方波高值
        %     else
        %         alpha = min_value; % 方波低值
        %     end

        % else
        %     % 阶段 4：alpha = alpha_best
        %     alpha = alpha_best;
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
