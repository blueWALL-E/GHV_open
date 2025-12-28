%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-25 22:23:57
 * @LastEditTime: 2025-12-25 22:25:31
 * @FilePath: \GHV_open\RL_control\data\analyze_alpha_reward.m
 * @Description: 特征点的攻角变化规律和奖励计算
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
load('reference_alpha.mat')
alpha_25_value = alpha_25.Data;
alpha_30_value = alpha_30.Data;
alpha_35_value = alpha_35.Data;
alpha_40_value = alpha_40.Data;
alpha_45_value = alpha_45.Data;
alpha_50_value = alpha_50.Data;
alpha_55_value = alpha_55.Data;

figure(1);

hold on;
plot(alpha_25_value, 'LineWidth', 1.8);
plot(alpha_30_value, 'LineWidth', 1.8);
plot(alpha_35_value, 'LineWidth', 1.8);
plot(alpha_40_value, 'LineWidth', 1.8);
plot(alpha_45_value, 'LineWidth', 1.8);
plot(alpha_50_value, 'LineWidth', 1.8);
plot(alpha_55_value, 'LineWidth', 1.8);

grid on;
xlabel('Sample Index');
ylabel('\alpha');
title('不同 H 取值下的数据对比');

legend({'H = 25km', 'H = 30km', 'H = 35km', ...
            'H = 40km', 'H = 45km', 'H = 50km', 'H = 55km'}, ...
    'Location', 'best');

hold off;

gamma = 0.99;
T = length(alpha_55_value);

r_25 = 5 - alpha_25_value(:); % 确保是列向量
% G_25 = sum((gamma .^ (0:T - 1))' .* r_25);
G_25 = sum(r_25 .^ 2); % 不使用折扣因子时的计算

r_30 = 5 - alpha_30_value(:); % 确保是列向量
% G_30 = sum((gamma .^ (0:T - 1))' .* r_30);
G_30 = sum(r_30 .^ 2); % 不使用折扣因子时的计算

r_35 = 5 - alpha_35_value(:); % 确保是列向量
% G_35 = sum((gamma .^ (0:T - 1))' .* r_35);
G_35 = sum(r_35 .^ 2); % 不使用折扣因子时的计算

r_40 = 5 - alpha_40_value(:); % 确保是列向量
% G_40 = sum((gamma .^ (0:T - 1))' .* r_40);
G_40 = sum(r_40 .^ 2); % 不使用折扣因子时的计算

r_45 = 5 - alpha_45_value(:); % 确保是列向量
% G_45 = sum((gamma .^ (0:T - 1))' .* r_45);
G_45 = sum(r_45 .^ 2); % 不使用折扣因子时的计算

r_50 = 5 - alpha_50_value(:); % 确保是列向量
% G_50 = sum((gamma .^ (0:T - 1))' .* r_50);
G_50 = sum(r_50 .^ 2); % 不使用折扣因子时的计算

r_55 = 5 - alpha_55_value(:); % 确保是列向量
% G_55 = sum((gamma .^ (0:T - 1))' .* r_55);
G_55 = sum(r_55 .^ 2); % 不使用折扣因子时的计算

G_values = [G_25, G_30, G_35, G_40, G_45, G_50, G_55];
H = [25, 30, 35, 40, 45, 50, 55];
H1000 = H * 1000;

figure(2);
hold on;
plot(H, G_values, '-o', 'LineWidth', 1.8);
grid on;
xlabel('H');
ylabel('G');
hold off;
