%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-03-16 22:57:18
 * @LastEditTime: 2026-03-19 22:57:55
 * @FilePath: \GHV_open\RL_control\data\6DOF\anaylze_6DOF_490s.m
 * @Description: 飞行器490s仿真结果分析脚本
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%% ===== Load =====
load("RL_control\data\6DOF\data_6DOF\wide_range_490s.mat");
load("RL_control\data\6DOF\data_6DOF\wide_range_490s_command.mat");
data_all = wide_range_490s;
data_command = wide_range_490s_command;
labels = {'\mu', '\alpha', '\beta'};
unitStr = 'deg';

%% ===== 从顶层 Dataset 中取出 6 组数据 =====
ds_GS_neg = data_all.get('GS_SMC_negative');
ds_GS_norm = data_all.get('GS_SMC_normal');
ds_GS_pos = data_all.get('GS_SMC_positive');

ds_TD3_neg = data_all.get('TD3_SMC_negative');
ds_TD3_norm = data_all.get('TD3_SMC_normal');
ds_TD3_pos = data_all.get('TD3_SMC_positive');

%% ===== 计算性能指标 =====
calculate_performance_metrics( ...
    ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
    ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
'aero_ang_e');

% %% ===== 画三维弹道图 =====
% plot_trajectory_3d( ...
%     ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
%     ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, data_command);

% %% ===== 环境图 =====
% plot_additional_signals( ...
%     ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
%     ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
%     3, data_command); % 指定 LLA 的第 3 列信号

% %% ===== 姿态角图 =====
% plot_aero_ang( ...
%     ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
%     ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
%     labels, unitStr);

%% ===== 姿态角误差图 =====
plot_aero_ang_e( ...
    ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
    ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
    labels, unitStr);

%% ===== 性能指标计算函数 =====
function calculate_performance_metrics( ...
        ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
        ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
        sigName)

    sig_GS_neg = ds_GS_neg.get(sigName);
    sig_GS_norm = ds_GS_norm.get(sigName);
    sig_GS_pos = ds_GS_pos.get(sigName);

    sig_TD3_neg = ds_TD3_neg.get(sigName);
    sig_TD3_norm = ds_TD3_norm.get(sigName);
    sig_TD3_pos = ds_TD3_pos.get(sigName);

    y_GS_neg = local_format_aero_ang(sig_GS_neg.Values.Data);
    y_GS_norm = local_format_aero_ang(sig_GS_norm.Values.Data);
    y_GS_pos = local_format_aero_ang(sig_GS_pos.Values.Data);

    y_TD3_neg = local_format_aero_ang(sig_TD3_neg.Values.Data);
    y_TD3_norm = local_format_aero_ang(sig_TD3_norm.Values.Data);
    y_TD3_pos = local_format_aero_ang(sig_TD3_pos.Values.Data);

    if strcmp(sigName, 'aero_ang_e')
        alpha_idx = 2;

        max_abs_GS_neg = max(abs(y_GS_neg(:, alpha_idx)));
        max_abs_GS_norm = max(abs(y_GS_norm(:, alpha_idx)));
        max_abs_GS_pos = max(abs(y_GS_pos(:, alpha_idx)));

        max_abs_TD3_neg = max(abs(y_TD3_neg(:, alpha_idx)));
        max_abs_TD3_norm = max(abs(y_TD3_norm(:, alpha_idx)));
        max_abs_TD3_pos = max(abs(y_TD3_pos(:, alpha_idx)));

        sum_abs_GS_neg = sum(abs(y_GS_neg(:, alpha_idx)));
        sum_abs_GS_norm = sum(abs(y_GS_norm(:, alpha_idx)));
        sum_abs_GS_pos = sum(abs(y_GS_pos(:, alpha_idx)));

        sum_abs_TD3_neg = sum(abs(y_TD3_neg(:, alpha_idx)));
        sum_abs_TD3_norm = sum(abs(y_TD3_norm(:, alpha_idx)));
        sum_abs_TD3_pos = sum(abs(y_TD3_pos(:, alpha_idx)));

        fprintf('Performance metrics for alpha channel (aero_ang_e):\n');
        fprintf('GS-negative: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_GS_neg, sum_abs_GS_neg);
        fprintf('GS-normal: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_GS_norm, sum_abs_GS_norm);
        fprintf('GS-positive: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_GS_pos, sum_abs_GS_pos);
        fprintf('TD3-negative: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_TD3_neg, sum_abs_TD3_neg);
        fprintf('TD3-normal: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_TD3_norm, sum_abs_TD3_norm);
        fprintf('TD3-positive: Max Abs = %.4f, Sum Abs = %.4f\n', max_abs_TD3_pos, sum_abs_TD3_pos);
    end

end

%% ===== 画 aero_ang 的函数 =====
function plot_aero_ang( ...
        ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
        ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
        labels, unitStr)

    sigName = 'aero_ang';

    % ===== 取信号 =====
    sig_GS_neg = ds_GS_neg.get(sigName);
    sig_GS_norm = ds_GS_norm.get(sigName);
    sig_GS_pos = ds_GS_pos.get(sigName);

    sig_TD3_neg = ds_TD3_neg.get(sigName);
    sig_TD3_norm = ds_TD3_norm.get(sigName);
    sig_TD3_pos = ds_TD3_pos.get(sigName);
    sig_command = ds_TD3_norm.get('aero_ang_d');

    % ===== 时间轴 =====
    t = sig_GS_norm.Values.Time;

    % ===== 数据整理 =====
    y_GS_neg = local_format_aero_ang(sig_GS_neg.Values.Data);
    y_GS_norm = local_format_aero_ang(sig_GS_norm.Values.Data);
    y_GS_pos = local_format_aero_ang(sig_GS_pos.Values.Data);

    y_TD3_neg = local_format_aero_ang(sig_TD3_neg.Values.Data);
    y_TD3_norm = local_format_aero_ang(sig_TD3_norm.Values.Data);
    y_TD3_pos = local_format_aero_ang(sig_TD3_pos.Values.Data);
    y_command = local_format_aero_ang(sig_command.Values.Data);

    % ===== 作图 =====
    figure('Color', 'w', 'Position', [100, 80, 900, 900]);
    TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

    % idx = 1:500:length(t);

    for k = 1:3
        ax = nexttile(TL);
        hold(ax, 'on');

        % ===== GS：绿色 =====
        h1 = plot(t, y_GS_norm(:, k), 'g-', 'LineWidth', 1.8);
        h2 = plot(t, y_GS_neg(:, k), 'g:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1:2000:length(t), 'MarkerSize', 5);
        h3 = plot(t, y_GS_pos(:, k), 'g-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 500:2000:length(t), 'MarkerSize', 8);

        % ===== TD3：蓝色 =====
        h4 = plot(t, y_TD3_norm(:, k), 'b-', 'LineWidth', 1.8);
        h5 = plot(t, y_TD3_neg(:, k), 'b:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1000:2000:length(t), 'MarkerSize', 5);
        h6 = plot(t, y_TD3_pos(:, k), 'b-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 1500:2000:length(t), 'MarkerSize', 8);

        % ===== Command：红色虚线 =====
        h_command = plot(t, y_command(:, k), 'r--', 'LineWidth', 1.8);

        % ===== 坐标轴 =====
        ylabel(sprintf('%s (%s)', labels{k}, unitStr), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
            'VerticalAlignment', 'middle', 'FontSize', 20, 'FontWeight', 'bold');

        if k == 3
            xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
        end

        title(sprintf('(%c) %s channel', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

        grid on;
        box on;
        set(gca, 'FontSize', 15, 'LineWidth', 1.1);

        % ===== Legend（仅在第1幅子图中显示）=====
        if k == 3

            % ===== 三行 legend：Command / SMC / TD3-SMC =====
            legend( ...
                [h_command, h1, h2, h3, h4, h5, h6], ... % 第3行：TD3-SMC
                {'command sign' ...
                 'GS-SMC (nominal)', 'GS-SMC (-10%)', 'SMC (+10%)', ...
                 'TD3-SMC (nominal)', 'TD3-SMC (-10%)', 'TD3-SMC (+10%)'}, ...
                'NumColumns', 7, ...
                'Location', 'southoutside', ...
                'FontSize', 15);
        end

    end

end

%% ===== 画 aero_ang_e 的函数 =====
function plot_aero_ang_e( ...
        ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
        ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
        labels, unitStr)

    sigName = 'aero_ang_e';

    % ===== 取信号 =====
    sig_GS_neg = ds_GS_neg.get(sigName);
    sig_GS_norm = ds_GS_norm.get(sigName);
    sig_GS_pos = ds_GS_pos.get(sigName);

    sig_TD3_neg = ds_TD3_neg.get(sigName);
    sig_TD3_norm = ds_TD3_norm.get(sigName);
    sig_TD3_pos = ds_TD3_pos.get(sigName);

    % ===== 时间轴 =====
    t = sig_GS_norm.Values.Time;

    % ===== 数据整理 =====
    y_GS_neg = local_format_aero_ang(sig_GS_neg.Values.Data);
    y_GS_norm = local_format_aero_ang(sig_GS_norm.Values.Data);
    y_GS_pos = local_format_aero_ang(sig_GS_pos.Values.Data);

    y_TD3_neg = local_format_aero_ang(sig_TD3_neg.Values.Data);
    y_TD3_norm = local_format_aero_ang(sig_TD3_norm.Values.Data);
    y_TD3_pos = local_format_aero_ang(sig_TD3_pos.Values.Data);

    % ===== 作图 =====
    figure('Color', 'w', 'Position', [100, 80, 900, 900]);
    TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

    idx = 1:500:length(t);

    for k = 1:3
        ax = nexttile(TL);
        hold(ax, 'on');

        % ===== GS：绿色 =====
        h1 = plot(t, y_GS_norm(:, k), 'g-', 'LineWidth', 1.8);
        h2 = plot(t, y_GS_neg(:, k), 'g:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1:2000:length(t), 'MarkerSize', 5);
        h3 = plot(t, y_GS_pos(:, k), 'g-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 500:2000:length(t), 'MarkerSize', 8);

        % ===== TD3：蓝色 =====
        h4 = plot(t, y_TD3_norm(:, k), 'b-', 'LineWidth', 1.8);
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
            ylim([-0.3, 0.2]);
        end

        title(sprintf('(%c) %s channel', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

        % % ===== 总图例 =====
        if k == 3
            legend( ...
                [h1, h2, h3, h4, h5, h6], ... % 第3行：TD3-SMC
                { ...
                 'GS-SMC (nominal)', 'GS-SMC (-10%)', 'SMC (+10%)', ...
                 'TD3-SMC (nominal)', 'TD3-SMC (-10%)', 'TD3-SMC (+10%)'}, ...
                'NumColumns', 6, ...
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

            plot(t, y_GS_norm(:, k), 'g-', 'LineWidth', 1.8);
            plot(t, y_GS_neg(:, k), ...
                'g:', 'LineWidth', 1.8, ...
                'Marker', 'o', 'MarkerIndices', 1:2000:length(t), 'MarkerSize', 3);
            plot(t, y_GS_pos(:, k), ...
                'g-.', 'LineWidth', 1.8, ...
                'Marker', 'x', 'MarkerIndices', 500:2000:length(t), 'MarkerSize', 4);

            plot(t, y_TD3_norm(:, k), 'b-', 'LineWidth', 1.8);
            plot(t, y_TD3_neg(:, k), ...
                'b:', 'LineWidth', 1.8, ...
                'Marker', 'o', 'MarkerIndices', 1000:2000:length(t), 'MarkerSize', 3);
            plot(t, y_TD3_pos(:, k), ...
                'b-.', 'LineWidth', 1.8, ...
                'Marker', 'x', 'MarkerIndices', 1500:2000:length(t), 'MarkerSize', 4);

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

            plot(t, y_GS_norm(:, k), 'g-', 'LineWidth', 1.8);
            plot(t, y_GS_neg(:, k), ...
                'g:', 'LineWidth', 1.8, ...
                'Marker', 'o', 'MarkerIndices', idx, 'MarkerSize', 3);
            plot(t, y_GS_pos(:, k), ...
                'g-.', 'LineWidth', 1.8, ...
                'Marker', 'x', 'MarkerIndices', idx, 'MarkerSize', 4);

            plot(t, y_TD3_norm(:, k), 'b-', 'LineWidth', 1.8);
            plot(t, y_TD3_neg(:, k), ...
                'b:', 'LineWidth', 1.8, ...
                'Marker', 'o', 'MarkerIndices', idx, 'MarkerSize', 3);
            plot(t, y_TD3_pos(:, k), ...
                'b-.', 'LineWidth', 1.8, ...
                'Marker', 'x', 'MarkerIndices', idx, 'MarkerSize', 4);

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

end

%% ===== 绘制附加信号的函数 =====
function plot_additional_signals( ...
        ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
        ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ...
        lla_col, ds_command)

    % ===== 信号名称 =====
    labels = {'Altitude', 'Mach', 'dynamic pressure'};
    unitStrs = {'m', 'n.d.', 'Pa'};

    % ===== 取信号 =====
    y_LLA_GS_neg = ds_GS_neg.get('LLA').Values.Data(:, lla_col); % LLA 的第 lla_col 列
    y_LLA_GS_norm = ds_GS_norm.get('LLA').Values.Data(:, lla_col);
    y_LLA_GS_pos = ds_GS_pos.get('LLA').Values.Data(:, lla_col);

    y_LLA_TD3_neg = ds_TD3_neg.get('LLA').Values.Data(:, lla_col);
    y_LLA_TD3_norm = ds_TD3_norm.get('LLA').Values.Data(:, lla_col);
    y_LLA_TD3_pos = ds_TD3_pos.get('LLA').Values.Data(:, lla_col);
    y_LLA_command = ds_command.get('h').Values.Data;

    y_Mach_GS_neg = ds_GS_neg.get('Mach').Values.Data; % 一维信号
    y_Mach_GS_norm = ds_GS_norm.get('Mach').Values.Data;
    y_Mach_GS_pos = ds_GS_pos.get('Mach').Values.Data;

    y_Mach_TD3_neg = ds_TD3_neg.get('Mach').Values.Data;
    y_Mach_TD3_norm = ds_TD3_norm.get('Mach').Values.Data;
    y_Mach_TD3_pos = ds_TD3_pos.get('Mach').Values.Data;
    y_Mach_command = ds_command.get('Ma').Values.Data; % 修正为 Values

    y_Qbar_GS_neg = ds_GS_neg.get('Qbar').Values.Data; % 一维信号
    y_Qbar_GS_norm = ds_GS_norm.get('Qbar').Values.Data;
    y_Qbar_GS_pos = ds_GS_pos.get('Qbar').Values.Data;

    y_Qbar_TD3_neg = ds_TD3_neg.get('Qbar').Values.Data;
    y_Qbar_TD3_norm = ds_TD3_norm.get('Qbar').Values.Data;
    y_Qbar_TD3_pos = ds_TD3_pos.get('Qbar').Values.Data;
    y_Qbar_command = ds_command.get('Q').Values.Data; % 修正为 Values
    % ===== 时间轴 =====
    t = ds_GS_norm.get('LLA').Values.Time;

    % ===== 作图 =====
    figure('Color', 'w', 'Position', [100, 80, 900, 900]);
    TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

    for k = 1:3
        ax = nexttile(TL);
        hold(ax, 'on');

        % ===== 根据信号选择数据 =====
        switch k
            case 1
                y_GS_neg = y_LLA_GS_neg;
                y_GS_norm = y_LLA_GS_norm;
                y_GS_pos = y_LLA_GS_pos;

                y_TD3_neg = y_LLA_TD3_neg;
                y_TD3_norm = y_LLA_TD3_norm;
                y_TD3_pos = y_LLA_TD3_pos;
                y_command = y_LLA_command;
            case 2
                y_GS_neg = y_Mach_GS_neg;
                y_GS_norm = y_Mach_GS_norm;
                y_GS_pos = y_Mach_GS_pos;

                y_TD3_neg = y_Mach_TD3_neg;
                y_TD3_norm = y_Mach_TD3_norm;
                y_TD3_pos = y_Mach_TD3_pos;

                y_command = y_Mach_command;
            case 3
                y_GS_neg = y_Qbar_GS_neg;
                y_GS_norm = y_Qbar_GS_norm;
                y_GS_pos = y_Qbar_GS_pos;

                y_TD3_neg = y_Qbar_TD3_neg;
                y_TD3_norm = y_Qbar_TD3_norm;
                y_TD3_pos = y_Qbar_TD3_pos;

                y_command = y_Qbar_command;
        end

        % ===== GS：绿色 =====
        h1 = plot(t, y_GS_norm, 'g-', 'LineWidth', 1.8);
        h2 = plot(t, y_GS_neg, 'g:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1:2000:length(t), 'MarkerSize', 5);
        h3 = plot(t, y_GS_pos, 'g-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 500:2000:length(t), 'MarkerSize', 8);

        % ===== TD3：蓝色 =====
        h4 = plot(t, y_TD3_norm, 'b-', 'LineWidth', 1.8);
        h5 = plot(t, y_TD3_neg, 'b:', 'LineWidth', 1.8, ...
            'Marker', 'o', 'MarkerIndices', 1000:2000:length(t), 'MarkerSize', 5);
        h6 = plot(t, y_TD3_pos, 'b-.', 'LineWidth', 1.8, ...
            'Marker', 'x', 'MarkerIndices', 1500:2000:length(t), 'MarkerSize', 8);

        % ===== Command：红色虚线 =====
        h_command = plot(t, y_command, 'r--', 'LineWidth', 1.8);

        % ===== 坐标轴 =====
        ylabel(sprintf('%s (%s)', labels{k}, unitStrs{k}), 'Rotation', 0, 'HorizontalAlignment', 'right', ...
            'VerticalAlignment', 'middle', 'FontSize', 20, 'FontWeight', 'bold');

        if k == 3
            xlabel('Time (s)', 'FontSize', 20, 'FontWeight', 'bold');
        end

        title(sprintf('(%c) %s', 'a' + k - 1, labels{k}), 'FontSize', 20, 'FontWeight', 'bold');

        grid on;
        box on;
        set(gca, 'FontSize', 15, 'LineWidth', 1.1);

        % ===== Legend（仅在第1幅子图中显示）=====
        if k == 3
            legend( ...
                [h_command, h1, h2, h3, h4, h5, h6], ... % 第3行：TD3-SMC
                {'nominal signal' ...
                 'GS-SMC (nominal)', 'GS-SMC (-10%)', 'SMC (+10%)', ...
                 'TD3-SMC (nominal)', 'TD3-SMC (-10%)', 'TD3-SMC (+10%)'}, ...
                'NumColumns', 7, ...
                'Location', 'southoutside', ...
                'FontSize', 15);
        end

    end

end

%% ===== 绘制三维弹道图的函数 =====
function plot_trajectory_3d( ...
        ds_GS_neg, ds_GS_norm, ds_GS_pos, ...
        ds_TD3_neg, ds_TD3_norm, ds_TD3_pos, ds_command)

    % ===== 取 LLA 信号 =====
    lla_GS_neg = ds_GS_neg.get('LLA').Values.Data; % LLA: 纬度、经度、海拔
    lla_GS_norm = ds_GS_norm.get('LLA').Values.Data;
    lla_GS_pos = ds_GS_pos.get('LLA').Values.Data;

    lla_TD3_neg = ds_TD3_neg.get('LLA').Values.Data;
    lla_TD3_norm = ds_TD3_norm.get('LLA').Values.Data;
    lla_TD3_pos = ds_TD3_pos.get('LLA').Values.Data;

    % ===== 转换为三轴距离 =====
    [x_GS_neg, y_GS_neg, z_GS_neg] = lla_to_xyz(lla_GS_neg);
    [x_GS_norm, y_GS_norm, z_GS_norm] = lla_to_xyz(lla_GS_norm);
    [x_GS_pos, y_GS_pos, z_GS_pos] = lla_to_xyz(lla_GS_pos);

    [x_TD3_neg, y_TD3_neg, z_TD3_neg] = lla_to_xyz(lla_TD3_neg);
    [x_TD3_norm, y_TD3_norm, z_TD3_norm] = lla_to_xyz(lla_TD3_norm);
    [x_TD3_pos, y_TD3_pos, z_TD3_pos] = lla_to_xyz(lla_TD3_pos);

    % ===== 作图 =====
    figure('Color', 'w', 'Position', [100, 80, 900, 900]);
    hold on;
    grid on;
    box on;

    % ===== GS：绿色 =====
    h1 = plot3(x_GS_norm, y_GS_norm, z_GS_norm, ...
        'g-', 'LineWidth', 2.2, ...
        'DisplayName', 'GS-normal');

    h2 = plot3(x_GS_neg, y_GS_neg, z_GS_neg, ...
        'g:', 'LineWidth', 1.8, ...
        'Marker', 'o', 'MarkerIndices', 1:2000:length(x_GS_neg), 'MarkerSize', 5, ...
        'DisplayName', 'GS-negative'); % 修改间距为 1500

    h3 = plot3(x_GS_pos, y_GS_pos, z_GS_pos, ...
        'g-.', 'LineWidth', 2.0, ...
        'Marker', 'x', 'MarkerIndices', 500:2000:length(x_GS_pos), 'MarkerSize', 8, ...
        'DisplayName', 'GS-positive'); % 修改间距为 1500，偏移 750

    % ===== TD3：蓝色 =====
    h4 = plot3(x_TD3_norm, y_TD3_norm, z_TD3_norm, ...
        'b-', 'LineWidth', 2.2, ...
        'DisplayName', 'TD3-normal');

    h5 = plot3(x_TD3_neg, y_TD3_neg, z_TD3_neg, ...
        'b:', 'LineWidth', 1.8, ...
        'Marker', 'o', 'MarkerIndices', 1000:2000:length(x_TD3_neg), 'MarkerSize', 5, ...
        'DisplayName', 'TD3-negative'); % 修改间距为 1500，偏移 500

    h6 = plot3(x_TD3_pos, y_TD3_pos, z_TD3_pos, ...
        'b-.', 'LineWidth', 2.0, ...
        'Marker', 'x', 'MarkerIndices', 1500:2000:length(x_TD3_pos), 'MarkerSize', 8, ...
        'DisplayName', 'TD3-positive'); % 修改间距为 1500，偏移 1000

    x_command = (x_TD3_norm + x_GS_norm + x_TD3_pos + x_GS_pos + x_TD3_neg + x_GS_neg) ./ 6;
    y_command = (y_TD3_norm + y_GS_norm + y_TD3_pos + y_GS_pos + y_TD3_neg + y_GS_neg) ./ 6;
    z_command = ds_command.get('h').Values.Data;
    h_command = plot3(x_command, y_command, z_command, ...
        'r--', 'LineWidth', 2.0, ...
        'DisplayName', 'Command');

    % ===== 坐标轴 =====
    xlabel('X (m)', 'FontSize', 20, 'FontWeight', 'bold');
    ylabel('Y (m)', 'FontSize', 20, 'FontWeight', 'bold');
    zlabel('Altitude (m)', 'FontSize', 20, 'FontWeight', 'bold', 'Rotation', 0);
    set(gca, 'FontSize', 15); % 控制刻度数字大小
    % title('3D Trajectories', 'FontSize', 18, 'FontWeight', 'bold');

    % ===== 图例 =====
    legend( ...
        [h_command, h1, h2, h3, h4, h5, h6], ... % 第3行：TD3-SMC
        {'command' ...
         'GS-SMC (nominal)', 'GS-SMC (-10%)', 'SMC (+10%)', ...
         'TD3-SMC (nominal)', 'TD3-SMC (-10%)', 'TD3-SMC (+10%)'}, ...
        'NumColumns', 1, ...
        'Location', 'southoutside', ...
        'FontSize', 15);

    view(3); % 设置为 3D 视图
end

%% ===== LLA 转换为三轴距离的函数 =====
function [x, y, z] = lla_to_xyz(lla)
    % 假设地球为球体，使用 WGS-84 椭球体参数
    R_earth = 6378137; % 地球半径 (m)

    lat = deg2rad(lla(:, 1)); % 纬度 (弧度)
    lon = deg2rad(lla(:, 2)); % 经度 (弧度)
    alt = lla(:, 3); % 海拔高度 (m)

    % 计算参考点（第一个点）
    lat0 = lat(1);
    lon0 = lon(1);

    % 转换为平面距离（以第一个点为原点）
    x = R_earth * (lon - lon0) .* cos(lat0); % 经度转距离
    y = R_earth * (lat - lat0); % 纬度转距离
    z = alt; % 高度保持不变
end

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
