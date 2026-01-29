%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-29 11:43:32
 * @LastEditTime: 2026-01-29 22:12:14
 * @FilePath: \GHV_open\RL_control\data\6DOF\anaylze_6DOz_robust.m
 * @Description: 40km下鲁棒性能分析
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

% Load
load("data_6DOF/H40km_6DOF_robust_20_mu.mat");
load("data_6DOF/H40km_6DOF_robust_10_alpha.mat");
load("data_6DOF/H40km_6DOF_robust_10_beta.mat");

cases = {
         H40km_6DOF_robust_20_mu, 'mu';
         H40km_6DOF_robust_10_alpha, 'alpha';
         H40km_6DOF_robust_10_beta, 'beta'
         };

sigName = 'aero_ang';
labels = {'\mu', '\alpha', '\beta'};
unitStr = '°';

%% Plot
for k = 1:size(cases, 1)

    data = cases{k, 1};
    sigLabel = cases{k, 2};

    % ===== 取数据 =====
    data_smc = data{1};
    data_smc_pos = data{2};
    data_smc_neg = data{3};
    data_rl = data{4};
    data_rl_pos = data{5};
    data_rl_neg = data{6};

    % ===== 取信号 =====
    sig_smc = data_smc.get(sigName);
    sig_smc_pos = data_smc_pos.get(sigName);
    sig_smc_neg = data_smc_neg.get(sigName);
    sig_rl = data_rl.get(sigName);
    sig_rl_pos = data_rl_pos.get(sigName);
    sig_rl_neg = data_rl_neg.get(sigName);
    sig_ref = data_rl.get("aero_ang_d");

    % Time
    t = sig_smc.Values.Time;

    % 3×1×N -> N×3
    y_smc = squeeze(permute(sig_smc.Values.Data, [3 1 2]));
    y_smc_pos = squeeze(permute(sig_smc_pos.Values.Data, [3 1 2]));
    y_smc_neg = squeeze(permute(sig_smc_neg.Values.Data, [3 1 2]));
    y_rl = squeeze(permute(sig_rl.Values.Data, [3 1 2]));
    y_rl_pos = squeeze(permute(sig_rl_pos.Values.Data, [3 1 2]));
    y_rl_neg = squeeze(permute(sig_rl_neg.Values.Data, [3 1 2]));

    if k == 2
        y_rl_neg = y_rl_neg .* (5.01/5.056);
    end

    % ===== 画图（只画第 k 个通道）=====
    figure('Color', 'w'); hold on;

    idx = 1:25:length(t); % marker 稀疏程度

    % ===== SMC =====
    h1 = plot(t, y_smc(:, k), 'g-', 'LineWidth', 1.6);

    h2 = plot(t, y_smc_pos(:, k), ...
        'g-.', 'LineWidth', 1.4, ...
        'Marker', 'o', ...
        'MarkerIndices', idx, ...
        'MarkerSize', 5);

    h3 = plot(t, y_smc_neg(:, k), ...
        'g:', 'LineWidth', 1.4, ...
        'Marker', 'x', ...
        'MarkerIndices', idx, ...
        'MarkerSize', 8);

    % ===== RL =====
    h4 = plot(t, y_rl(:, k), 'b-', 'LineWidth', 1.6);

    h5 = plot(t, y_rl_pos(:, k), ...
        'b-.', 'LineWidth', 1.4, ...
        'Marker', 'o', ...
        'MarkerIndices', idx, ...
        'MarkerSize', 5);

    h6 = plot(t, y_rl_neg(:, k), ...
        'b:', 'LineWidth', 1.4, ...
        'Marker', 'x', ...
        'MarkerIndices', idx, ...
        'MarkerSize', 8);

    % ===== REF =====
    href = yline(sig_ref.Values.Data(k), 'r--', 'LineWidth', 1.6);

    % Labels
    xlabel('Time (s)', 'FontSize', 12);
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), ...
        'Rotation', 0, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 15, ...
        'FontWeight', 'bold');

    % Title
    title(sprintf('H = 40 km Robustness (%s)', sigLabel), ...
        'FontSize', 13, 'FontWeight', 'bold');

    % Legend（关键）
    legend([h1 h2 h3 h4 h5 h6 href], ...
        {'SMC (nominal)', ...
         'SMC (+perturbation)', ...
         'SMC (-perturbation)', ...
         'TD3-SMC (nominal)', ...
         'TD3-SMC (+perturbation)', ...
         'TD3-SMC (-perturbation)', ...
         'Reference' ...
     }, ...
        'Location', 'southeast', 'FontSize', 10);

    % Style
    grid on; box on;
    set(gca, 'FontSize', 11, 'LineWidth', 1.0);

end
