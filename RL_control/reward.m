%{
*
 * @Author: blueWALL-E
 * @Date: 2025-12-07 17:40:06
 * @LastEditTime: 2025-12-07 17:40:12
 * @FilePath: \GHV_open\RL_control\reward.m
 * @Description: 强化学习奖励函数设计
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%强化学习奖励函数设计
%俯仰通道
%input:
% aero_ang_e: 单位 rad    姿态角误差向量
% w:         单位 rad/s  机体转动角速度 p,q,r 1*3
% LE:      单位 deg     机翼升降舵偏角
%output:
% r:       单位 n.d.     奖励值
function r = reward(aero_ang_e, w, LE, d_LE)
    %权重系数
    alpha_e = rad2deg(aero_ang_e(2, 1)); %读取俯仰角误差
    q = rad2deg(w(2, 1)); %读取y轴机体角速度 即俯仰角速度
    c1 = 100; % 俯仰角误差权重
    c2 = 10; % 俯仰角速度权重
    c3 = 0.1; % 升降舵偏角权重
    c4 = 0; % 升降舵偏角变化率权重

    %奖励函数计算
    r =- (c1 * alpha_e ^ 2 + c2 * q ^ 2 + c3 * LE ^ 2 + c4 * d_LE ^ 2);
end
