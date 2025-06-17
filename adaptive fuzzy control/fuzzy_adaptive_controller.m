%{
/*
* @Author:blueWALL-E
* @Date:2025-06-16 20:43:30
 * @LastEditTime: 2025-06-17 10:46:57
 * @FilePath: \GHV_open\adaptive fuzzy control\fuzzy_adaptive_controller.m
* @Description: 自适应模糊控制模块
* @Wearing:Read only, do not modify place !!!
* @Shortcut keys:ctrl+alt+/ ctrl+alt+z
*/
%}
%自适应模糊控制模块
%input:
% air_ang:    单位 rad      气流角 alpha攻角 beta侧滑角
% w:          单位 rad/s    机体转动角速度 wx,wy,wz 1*3
% V:          单位 m/s      飞行器的空速 简化认为空速和低速相等
% fuzzy_theta: 27x1         自适应权重
% s:          单位 n.d.     控制滑模面
%output:
% ufz:       单位 n.d.     模糊控制输出
% d_fuzzy_theta: 27x1      自适应权重更新(导数)
function [ufz, d_fuzzy_theta] = fuzzy_adaptive_controller(air_ang, w, V, fuzzy_theta, s)
    alpha = air_ang(1, 1); %读取攻角数据
    wy = w(2, 1); %读取y轴机体角速度

    gamma_theta = 100; % 学习率
    sigma = 0.3; % 正则因子

    % Step 1: 定义所有隶属度函数
    z1 = alpha; z2 = wy; z3 = V;

    % z1 的3个MF
    mu1 = [
           1 / (1 + exp(100 * (z1 - 0.05)));
           exp(- (((z1 - 0.0873) / 0.04) ^ 2));
           1 / (1 + exp(-100 * (z1 - 0.1246)))
           ];

    % z2 的3个MF
    mu2 = [
           1 / (1 + exp(60 * (z2 + 0.05)));
           exp(- (z2 ^ 2) / (0.05 ^ 2));
           1 / (1 + exp(-60 * (z2 - 0.05)))
           ];

    % z3 的3个MF
    mu3 = [
           1 / (1 + exp(0.2 * (z3 + 10)));
           exp(- (z3 / 12) ^ 2);
           1 / (1 + exp(-0.2 * (z3 - 10)))
           ];

    % Step 2: 生成所有组合规则的 w_i
    % 假设 mu1, mu2, mu3 均为 3x1 向量
    mu1 = mu1(:); mu2 = mu2(:); mu3 = mu3(:); % 保证列向量

    % 构造所有组合索引（笛卡尔积）
    [I, J, K] = ndgrid(1:3, 1:3, 1:3);

    % 提取对应隶属函数值
    fuzzy_Basis = mu1(I(:)) .* mu2(J(:)) .* mu3(K(:)); % 27×1 向量
    ufz = fuzzy_theta' * fuzzy_Basis; % 计算模糊控制输出

    d_fuzzy_theta =- gamma_theta * (s * fuzzy_Basis + sigma * abs(s) * fuzzy_theta); % 更新权重

end
