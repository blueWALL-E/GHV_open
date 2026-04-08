%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-03-31 21:11:21
 * @LastEditTime: 2026-04-06 23:12:46
 * @FilePath: \GHV_open\RL_control\data\6DOF\new_anaylze_6DOF_490s.m
 * @Description: 完整仿真分析作图
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

% 获取当前脚本所在路径
script_path = fileparts(mfilename('fullpath'));

% 拼接子文件夹 new_data 保存图片的路径
folder = fullfile(script_path, 'new_data');

% 如果不存在就创建
if ~exist(folder, 'dir')
    mkdir(folder);
end

load("RL_control\data\6DOF\new_data\wide490s_all.mat");
load("RL_control\data\6DOF\new_data\wide_range_490s_command.mat");
data_all = wide490s_all;
data_command = wide_range_490s_command;

ds_GS_neg = data_all.get('GS_SMC_negative20');
ds_GS_norm = data_all.get('GS_SMC_normal');
ds_GS_pos = data_all.get('GS_SMC_positive20');

ds_TD3_neg = data_all.get('TD3_SMC_negative20');
ds_TD3_norm = data_all.get('TD3_SMC_normal');
ds_TD3_pos = data_all.get('TD3_SMC_positive20');

ds_GS_rand = data_all.get('GS_SMC_rand');
ds_TD3_rand = data_all.get('TD3_SMC_rand');

%% ===== 高度 马赫数 动压 图 =====
labels = {'Altitude', 'Mach', ['Dynamic' newline 'pressure']};
unitStrs = {'m', 'n.d.', 'Pa'};
H_command = data_command.get('h').Values.Data;
Ma_command = data_command.get('Ma').Values.Data;
Q_command = data_command.get('Q').Values.Data;
t = data_command.get('h').Values.Time;

figure('Color', 'w', 'Position', [100 100 1600 900]);
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 1:3
    ax = nexttile(TL);
    hold(ax, 'on');

    % ===== 根据信号选择数据 =====
    switch k
        case 1
            y_command = H_command;
        case 2
            y_command = Ma_command;
        case 3
            y_command = Q_command;
    end

    h_command = plot(t, y_command, 'r', 'LineWidth', 1.8);
    % ===== 坐标轴 =====
    ylabel(sprintf('%s\n(%s)', labels{k}, unitStrs{k}), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', 'FontSize', 20, 'FontWeight', 'bold');
    xlim([0, 500]);
    xticks(0:100:500);

    if k == 3
        xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
    end

    grid on;
    box on;
    set(gca, 'FontSize', 15, 'LineWidth', 1.1);

end

% 输出路径
output_path = fullfile(folder, '4.0_H_Ma_Q.jpg');

% 保存图片
exportgraphics(gcf, output_path, 'Resolution', 600);

% ===== 理想工况下的 =====
labels = {'\mu', '\alpha', '\beta'};
unitStr = 'deg';
sigName = 'aero_ang_e';

% ===== 取信号 =====
sig_GS_norm = ds_GS_norm.get(sigName);
sig_TD3_norm = ds_TD3_norm.get(sigName);

% ===== 时间轴 =====
t = sig_GS_norm.Values.Time;
y_GS_norm = local_format_aero_ang(sig_GS_norm.Values.Data);
y_TD3_norm = local_format_aero_ang(sig_TD3_norm.Values.Data);

figure('Color', 'w', 'Position', [100 100 1600 900]);
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 1:3
    ax = nexttile(TL);
    hold(ax, 'on');

    % ===== GS：绿色 =====
    h1 = plot(t, y_GS_norm(:, k), 'r', 'LineWidth', 1.8);
    max_abs_GS_neg = max(abs(y_GS_norm(:, k)));
    sum_abs_GS_neg = sum(abs(y_GS_norm(:, k)));
    mean_abs_GS_neg = mean(abs(y_GS_norm(:, k)));
    fprintf('GS-normal: Max = %.4f, Sum = %.4f, Mean = %.4f\n', ...
        max_abs_GS_neg, sum_abs_GS_neg, mean_abs_GS_neg);
    % ===== TD3：蓝色 =====
    h4 = plot(t, y_TD3_norm(:, k), 'b', 'LineWidth', 1.8);
    max_abs_TD3_neg = max(abs(y_TD3_norm(:, k)));
    sum_abs_TD3_neg = sum(abs(y_TD3_norm(:, k)));
    mean_abs_TD3_neg = mean(abs(y_TD3_norm(:, k)));
    fprintf('TD3-normal: Max = %.4f, Sum = %.4f, Mean = %.4f\n', ...
        max_abs_TD3_neg, sum_abs_TD3_neg, mean_abs_TD3_neg);

    % ===== 坐标轴 =====
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', 'FontSize', 14, 'FontWeight', 'bold');

    if k == 3
        xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
        ylim([-0.08, 0.15]);
    end

    if k == 2
        ylim([-0.3, 0.2]);
    end

    title(sprintf('(%c) %s channel', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

    % % ===== 总图例 =====
    if k == 3
        legend( ...
            [h1, h4], ... % 第3行：TD3-SMC
            { ...
             'GS-SMC (nominal)', ...
         'TD3-SMC (nominal)'}, ...
            'NumColumns', 2, ...
            'Location', 'southoutside', ...
            'FontSize', 15);
    end

    grid on;
    box on;
    set(gca, 'FontSize', 15, 'LineWidth', 1.1);

    % ===== 局部放大图 =====
    if k == 1
        % ---- mu 通道: k = 1 ----
        ax_in1 = axes('Position', [0.24 0.86 0.22 0.11]); % 可再微调
        hold(ax_in1, 'on');

        plot(t, y_GS_norm(:, k), 'r', 'LineWidth', 1.8);
        plot(t, y_TD3_norm(:, k), 'b', 'LineWidth', 1.8);

        xlim([62 80]);
        ylim([-0.00055 0.00005]);
        grid on;
        box on;
        set(ax_in1, 'FontSize', 15, 'LineWidth', 0.8);

        % 主图上标出放大区域
        rectangle(ax, ...
            'Position', [62, -0.00055, 18, 0.00060], ...
            'EdgeColor', 'k', ...
            'LineStyle', '--', ...
            'LineWidth', 1.0);
    elseif k == 3
        % ---- beta 通道: k = 3 ----
        ax_in2 = axes('Position', [0.6 0.26 0.22 0.11]); % 可再微调
        hold(ax_in2, 'on');

        plot(t, y_GS_norm(:, k), 'r', 'LineWidth', 1.8);
        plot(t, y_TD3_norm(:, k), 'b', 'LineWidth', 1.8);

        xlim([252 257]);
        ylim([-0.001 0.0006]);
        grid on;
        box on;
        set(ax_in2, 'FontSize', 15, 'LineWidth', 0.8);

        % 主图上标出放大区域
        rectangle(ax, ...
            'Position', [252, -0.001, 5, 0.0016], ...
            'EdgeColor', 'k', ...
            'LineStyle', '--', ...
            'LineWidth', 1.0);
    end

end

% 输出路径
output_path = fullfile(folder, '4.1_aero_ang_e_normal.jpg');

% 保存图片
exportgraphics(gcf, output_path, 'Resolution', 600);

% ===== 气动系数拉偏下 =====
labels = {'\mu', '\alpha', '\beta'};
unitStr = 'deg';
sigName = 'aero_ang_e';

% ===== 取信号 =====
sig_GS_neg = ds_GS_neg.get(sigName);
sig_GS_pos = ds_GS_pos.get(sigName);

sig_TD3_neg = ds_TD3_neg.get(sigName);
sig_TD3_pos = ds_TD3_pos.get(sigName);

% ===== 时间轴 =====
t = sig_GS_neg.Values.Time;
% ===== 数据整理 =====
y_GS_neg = local_format_aero_ang(sig_GS_neg.Values.Data);
y_GS_pos = local_format_aero_ang(sig_GS_pos.Values.Data);

y_TD3_neg = local_format_aero_ang(sig_TD3_neg.Values.Data);
y_TD3_pos = local_format_aero_ang(sig_TD3_pos.Values.Data);

figure('Color', 'w', 'Position', [100 100 1600 900]);
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

idx = 1:500:length(t);

for k = 1:3
    ax = nexttile(TL);
    hold(ax, 'on');

    % ===== GS：绿色 =====

    h2 = plot(t, y_GS_neg(:, k), 'r:', 'LineWidth', 1.8, ...
        'Marker', 'o', 'MarkerIndices', 1:2000:length(t), 'MarkerSize', 5);
    h3 = plot(t, y_GS_pos(:, k), 'r-.', 'LineWidth', 1.8, ...
        'Marker', 'x', 'MarkerIndices', 500:2000:length(t), 'MarkerSize', 8);

    % ===== TD3：蓝色 =====

    h5 = plot(t, y_TD3_neg(:, k), 'b:', 'LineWidth', 1.8, ...
        'Marker', 'o', 'MarkerIndices', 1000:2000:length(t), 'MarkerSize', 5);
    h6 = plot(t, y_TD3_pos(:, k), 'b-.', 'LineWidth', 1.8, ...
        'Marker', 'x', 'MarkerIndices', 1500:2000:length(t), 'MarkerSize', 8);

    % ===== 坐标轴 =====
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', 'FontSize', 14, 'FontWeight', 'bold');

    if k == 3
        xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
        ylim([-0.08, 0.15]);
    end

    if k == 2
        ylim([-0.5, 1.3]);
    end

    title(sprintf('(%c) %s channel', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

    % % ===== 总图例 =====
    if k == 3
        legend( ...
            [h2, h5, h3, h6], ... % 第3行：TD3-SMC
            { ...
             'GS-SMC (-20%)', 'TD3-SMC (-20%)', 'GS-SMC (+20%)', 'TD3-SMC (+20%)'}, ...
            'NumColumns', 4, ...
            'Location', 'southoutside', ...
            'FontSize', 15);

    end

    grid on;
    box on;
    set(gca, 'FontSize', 15, 'LineWidth', 1.1);

    % ===== 局部放大图 =====
    if k == 1
        % ---- mu 通道: k = 1 ----
        ax_in1 = axes('Position', [0.20 0.885 0.22 0.11]); % 可再微调
        hold(ax_in1, 'on');

        plot(t, y_GS_neg(:, k), ...
            'r:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1:200:length(t), 'MarkerSize', 3);
        plot(t, y_GS_pos(:, k), ...
            'r-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 50:200:length(t), 'MarkerSize', 4);

        plot(t, y_TD3_neg(:, k), ...
            'b:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 100:200:length(t), 'MarkerSize', 3);
        plot(t, y_TD3_pos(:, k), ...
            'b-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 150:200:length(t), 'MarkerSize', 4);

        xlim([6 20]);
        ylim([-0.4 0.3]);
        grid on;
        box on;
        set(ax_in1, 'FontSize', 15, 'LineWidth', 0.8);

        % 主图上标出放大区域
        rectangle(ax, ...
            'Position', [62, -0.00055, 18, 0.00060], ...
            'EdgeColor', 'k', ...
            'LineStyle', '--', ...
            'LineWidth', 1.0);
    elseif k == 3
        % ---- beta 通道: k = 3 ----
        ax_in2 = axes('Position', [0.6 0.26 0.22 0.11]); % 可再微调
        hold(ax_in2, 'on');

        plot(t, y_GS_neg(:, k), ...
            'r:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1:80:length(t), 'MarkerSize', 3);
        plot(t, y_GS_pos(:, k), ...
            'r-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 20:80:length(t), 'MarkerSize', 4);

        plot(t, y_TD3_neg(:, k), ...
            'b:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 40:80:length(t), 'MarkerSize', 3);
        plot(t, y_TD3_pos(:, k), ...
            'b-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 60:80:length(t), 'MarkerSize', 4);

        xlim([252 257]);
        ylim([-0.001 0.001]);
        grid on;
        box on;
        set(ax_in2, 'FontSize', 15, 'LineWidth', 0.8);

        % 主图上标出放大区域
        rectangle(ax, ...
            'Position', [252, -0.001, 5, 0.0016], ...
            'EdgeColor', 'k', ...
            'LineStyle', '--', ...
            'LineWidth', 1.0);
    end

end

% 输出路径
output_path = fullfile(folder, '4.2_aero_ang_e_bias.jpg');

% 保存图片
exportgraphics(gcf, output_path, 'Resolution', 600);

%% ===== 外界扰动 =====
labels = {'\mu', '\alpha', '\beta'};
unitStr = 'deg';
sigName = 'aero_ang_e';

% ===== 取信号 =====
sig_GS_rand = ds_GS_rand.get(sigName);
sig_TD3_rand = ds_TD3_rand.get(sigName);

% ===== 时间轴 =====
t = sig_GS_rand.Values.Time;
% ===== 数据整理 =====
y_GS_rand = local_format_aero_ang(sig_GS_rand.Values.Data);
y_TD3_rand = local_format_aero_ang(sig_TD3_rand.Values.Data);

figure('Color', 'w', 'Position', [100 100 1600 900]);
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 1:3
    ax = nexttile(TL);
    hold(ax, 'on');

    % ===== GS：绿色 =====
    h1 = plot(t, y_GS_rand(:, k), 'r', 'LineWidth', 1.8);

    % ===== TD3：蓝色 =====
    h4 = plot(t, y_TD3_rand(:, k), 'b', 'LineWidth', 1.8);

    % ===== 坐标轴 =====
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', 'FontSize', 14, 'FontWeight', 'bold');

    if k == 2
        ylim([-0.19, 0.05]);
    end

    if k == 3
        xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
        ylim([-0.1, 0.1]);
    end

    title(sprintf('(%c) %s channel', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

    % % ===== 总图例 =====
    if k == 3
        legend( ...
            [h1, h4], ... % 第3行：TD3-SMC
            { ...
             'GS-SMC (torque noise)', 'TD3-SMC (torque noise)'}, ...
            'NumColumns', 2, ...
            'Location', 'southoutside', ...
            'FontSize', 15);
    end

    grid on;
    box on;
    set(gca, 'FontSize', 15, 'LineWidth', 1.1);
end

% 输出路径
output_path = fullfile(folder, '4.2_aero_ang_e_rand.jpg');

% 保存图片
exportgraphics(gcf, output_path, 'Resolution', 600);
%% ===== 局部函数：把三通道数据整理成 N×3 =====
function y = local_format_aero_ang(data)
    % 常见情况 1：1×3×N  -> N×3
    if ndims(data) == 3 && size(data, 1) == 1 && size(data, 2) == 3
        y = squeeze(permute(data, [3 2 1]));
        return;
    end

    % 常见情况 2：3×1×N -> N×3
    if ndims(data) == 3 && size(data, 1) == 3 && size(data, 2) == 1
        y = squeeze(permute(data, [3 1 2]));
        return;
    end

    % 常见情况 3：N×3
    if ismatrix(data) && size(data, 2) == 3
        y = data;
        return;
    end

    % 常见情况 4：3×N -> N×3
    if ismatrix(data) && size(data, 1) == 3
        y = data.';
        return;
    end

    error('数据维度不符合预期，当前 size = [%s]', num2str(size(data)));
end
