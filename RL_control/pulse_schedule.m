%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-21 23:00:51
 * @LastEditTime: 2026-01-05 11:52:17
 * @FilePath: \GHV_open\RL_control\pulse_schedule.m
 * @Description: 触发脉冲信号的时间调度函数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
function pulse = pulse_schedule(t)
    % pulse_schedule
    % 在指定时刻产生高度=1、宽度=1s 的方波
    % 其余时间输出 -1
    %
    % 适合放在 Simulink 的 MATLAB Function 模块中

    % ===== 脉冲起始时刻（秒）=====
    % 根据你手写图整理的完整时间点
    t0 = ...
        [270, 280, 290,...
        430, 440, 450, ...
     ];

    % ===== 脉冲参数 =====
    width = 1.0; % 方波宽度 1 s
    high = 1; % 脉冲期间
    low = -1; % 其他时间

    % ===== 默认输出 =====
    pulse = low;

    % ===== 判断是否落入任意一个脉冲区间 =====
    if any(t >= t0 & t < (t0 + width))
        pulse = high;
    end

end
