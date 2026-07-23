%{
/*
* @Author:blueWALL - E
* @Date:2026 - 07 - 23 11:41:52
 * @LastEditTime: 2026-07-23 22:18:22
 * @FilePath: \GHV_open\GHV_model\throttle_lever_model.m
* @Description: 油门推杆角度—燃油流量指令模型
* @Wearing:Read only, do not modify place ! !!
* @Shortcut keys:ctrl + alt +/ ctrl + alt + z
*/
%}

% throttle_lever_model 油门推杆角度—燃油流量指令模型
%
% 参考：
% 推杆总行程为 52.5 deg；
% 推杆最后位置对应 10 lbm/s；
% 推杆最前位置对应 200 lbm/s。
%
% 假设：
% 在两个端点之间采用线性插值。
%
% 输入：
% engine_enable      -       发动机使能
%                               0：发动机关闭
%                               非0：发动机开启
% throttle_angle     rad     油门推杆角度
%                               0 rad：最后位置
%                               0.9163 rad：最前位置
%
% 输出：
% WF_cmd             kg/s    燃油质量流率指令

function WF_cmd = throttle_lever_model(engine_enable, throttle_angle)

    %% 输出初始化

    WF_cmd = 0.0;

    %% 发动机关闭

    if engine_enable == 0
        return;
    end

    %% 参数定义

    % lbm2kg = 0.45359237;

    % 推杆角度范围
    throttle_angle_min = 0.0; % rad
    throttle_angle_max = deg2rad(52.5); % rad

    % 燃油流量范围
    WF_min = 10.0 * UnitConst.lbm2kg; % kg/s
    WF_max = 200.0 * UnitConst.lbm2kg; % kg/s

    %% 推杆角度限幅

    throttle_angle_limited = min( ...
        max(throttle_angle, throttle_angle_min), ...
        throttle_angle_max);

    %% 线性角度—流量映射

    throttle_ratio = ...
        (throttle_angle_limited - throttle_angle_min) ...
        / (throttle_angle_max - throttle_angle_min);

    WF_cmd = WF_min ...
        + throttle_ratio * (WF_max - WF_min);

end
