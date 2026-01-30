%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-29 11:43:32
 * @LastEditTime: 2026-01-30 17:12:45
 * @FilePath: \GHV_open\RL_control\data\6DOF\anaylze_6DOF_robust.m
 * @Description: 40km下鲁棒性能分析（3通道合并：从上到下排列）
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%% Load
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

%% ===== 取数据（3个mat文件里结构一致，取一次即可）=====
% 约定：data{1:6} 分别是 SMC nominal/pos/neg, TD3-SMC nominal/pos/neg
data = cases{1, 1}; % 用第一个case取时间轴等（若三者time一致）
data_smc = data{1};
t = data_smc.get(sigName).Values.Time;

%% ===== 新建一个图：3×1 从上到下排列 =====
figure('Color', 'w');
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% marker 稀疏程度
idx = 1:25:length(t);

%% ===== 依次画 μ / α / β =====
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

    % Time（以本case为准，更稳）
    t = sig_smc.Values.Time;

    % 3×1×N -> N×3
    y_smc = squeeze(permute(sig_smc.Values.Data, [3 1 2]));
    y_smc_pos = squeeze(permute(sig_smc_pos.Values.Data, [3 1 2]));
    y_smc_neg = squeeze(permute(sig_smc_neg.Values.Data, [3 1 2]));
    y_rl = squeeze(permute(sig_rl.Values.Data, [3 1 2]));
    y_rl_pos = squeeze(permute(sig_rl_pos.Values.Data, [3 1 2]));
    y_rl_neg = squeeze(permute(sig_rl_neg.Values.Data, [3 1 2]));

    % 你原来的特殊处理：alpha case 对 rl_neg 做比例修正
    if k == 2
        y_rl_neg = y_rl_neg .* (5.01/5.056);
    end

    % ===== 子图 =====
    ax = nexttile(TL); %#ok<NASGU>
    hold on;

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

    % ===== TD3-SMC =====
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

    % ===== Command =====
    href = yline(sig_ref.Values.Data(k), 'r--', 'LineWidth', 1.6);

    % ===== 轴标签 =====
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), ...
        'Rotation', 0, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 15, ...
        'FontWeight', 'bold');

    % 只给最后一个子图加 xlabel（更干净）
    if k == 3
        xlabel('Time (s)', 'FontSize', 15);
    end

    % ===== 子图标题：期刊常用 (a)(b)(c) =====
    title(sprintf('(%c) %s channel', 'a'+k - 1, labels{k}), ...
        'FontSize', 25, 'FontWeight', 'bold');

    % ===== Legend（按气动系数类型自适应；只放在第1幅子图）=====
    switch sigLabel
        case 'mu'
            pertStr = '20% C_l';
        case 'alpha'
            pertStr = '10% C_m';
        case 'beta'
            pertStr = '10% C_n';
        otherwise
            pertStr = 'Pert.';
    end

    % ===== Legend 占位句柄（不可见，用于三行排版）=====
    hdum1 = plot(nan, nan, 'w'); % 白色不可见
    hdum2 = plot(nan, nan, 'w'); % 白色不可见

    % ===== 三行 legend：Command / SMC / TD3-SMC =====
    lgd = legend( ...
        [href, hdum1, hdum2, ... % 第1行：Command
         h1, h2, h3, ... % 第2行：SMC
         h4, h5, h6], ... % 第3行：TD3-SMC
        { ...
         'Command', '', '', ...
         'SMC (nominal)', ['SMC (+' pertStr ')'], ['SMC (-' pertStr ')'], ...
         'TD3-SMC (nominal)', ['TD3-SMC (+' pertStr ')'], ['TD3-SMC (-' pertStr ')'] ...
     }, ...
        'NumColumns', 3, ...
        'Location', 'southeast', ...
        'FontSize', 13);

    % ===== Style =====
    grid on; box on;
    set(gca, 'FontSize', 11, 'LineWidth', 1.0);

end

% ===== 总标题（可选）=====
% sgtitle('H = 40 km Robustness under Aerodynamic Coefficient Perturbations', ...
%     'FontSize', 13, 'FontWeight', 'bold');
