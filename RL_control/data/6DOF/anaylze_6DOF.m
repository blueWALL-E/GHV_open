%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-28 14:50:46
 * @LastEditTime: 2026-01-28 16:19:25
 * @FilePath: \GHV_open\RL_control\data\6DOF\anaylze_6DOF.m
 * @Description: 标准工况六自由度仿真结果对比分析脚本
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
%% ========== 导入数据 ==========
load("data_6DOF/H25469m_6DOF_RLvsSMC.mat");
load("data_6DOF/H30980m_6DOF_RLvsSMC.mat");
load("data_6DOF/H35388m_6DOF_RLvsSMC.mat");
load("data_6DOF/H40163m_6DOF_RLvsSMC.mat");

%% ========== 0) 工况列表 ==========
cases = {
         H25469m_6DOF_RLvsSMC, 'H=25.469 km';
         H30980m_6DOF_RLvsSMC, 'H=30.980 km';
         H35388m_6DOF_RLvsSMC, 'H=35.388 km';
         H40163m_6DOF_RLvsSMC, 'H=40.163 km'
         };

%% ========== 1) 作图参数 ==========
sigName = 'aero_ang';

labels = {'\mu', '\alpha', '\beta'};
refVal = [3, 5, 0];
unitStr = '°';

lw_main = 2;
lw_ref = 1.5;

fs_ylabel = 15;
fs_title = 18;

ylim_mu = [0, 4.5];
ylim_alpha = [0, 6.5];

% 图例参数（每个子图一份）
legendLoc = 'southoutside'; % 可改：'best','northeast', 'southeast'等
legendFS = 13; % 图例字号（每子图不宜太大）
legendBox = 'on'; % 'off'也可以，更干净

%综合控制能力指标参数
OS_ref = 5; % 5 %
Ts_ref = 2; % 2 s
e_ref = 0.05; % 0.05（按你的alpha单位）

wOS = 1;
wT = 1;
we = 1;

%% ========== 2) 建立图窗与外层布局 ==========
figure('Color', 'w');
set(gcf, 'Position', [100 100 1400 800]);

% TL = tiledlayout(2, 2, 'TileSpacing', 'none', 'Padding', 'compact');
TL = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'none');
TL.InnerPosition = [0.01 0.015 0.98 0.97];
TL.OuterPosition = [0 0 1 1];

%% ========== 3) 循环画四个工况 ==========
for k = 1:size(cases, 1)

    ds = cases{k, 1};
    titleStr = cases{k, 2};

    data_smc = ds{1};
    data_rl = ds{2};

    sig_smc = data_smc.get(sigName);
    sig_rl = data_rl.get(sigName);

    t = sig_smc.Values.Time;

    % 3×1×N -> N×3
    y_smc = squeeze(permute(sig_smc.Values.Data, [3 1 2]));
    y_rl = squeeze(permute(sig_rl.Values.Data, [3 1 2]));

    % --- 占位tile -> panel ---
    axTile = nexttile(TL, k);
    pos = axTile.Position;
    delete(axTile);

    pan = uipanel('Parent', gcf, ...
        'Units', 'normalized', ...
        'Position', pos, ...
        'BorderType', 'line', ...
        'BackgroundColor', 'w'); % panel 白底

    TLin = tiledlayout(pan, 3, 1, ...
        'TileSpacing', 'compact', ...
        'Padding', 'none');
    title(TLin, titleStr, 'FontWeight', 'bold', 'FontSize', fs_title);

    for i = 1:3
        ax = nexttile(TLin, i);
        ax.Color = 'w'; % 子图白底

        % --- 画线（给DisplayName，legend就不用写字符串重复了）---
        p1 = plot(ax, t, y_smc(:, i), 'g', 'LineWidth', lw_main); hold(ax, 'on');
        p1.DisplayName = 'SMC';

        p2 = plot(ax, t, y_rl(:, i), 'b', 'LineWidth', lw_main);
        p2.DisplayName = 'TD3-SMC';

        p3 = yline(ax, refVal(i), 'r--', 'LineWidth', lw_ref);
        p3.DisplayName = 'Command';

        grid(ax, 'on'); box(ax, 'on');

        % --- y标签（水平 + 加粗 + 单位）---
        ylabel(ax, sprintf('%s (%s)', labels{i}, unitStr), ...
            'Rotation', 0, ...
            'HorizontalAlignment', 'right', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', fs_ylabel, ...
            'FontWeight', 'bold');

        % --- y轴范围：mu/alpha固定，beta自适应 ---
        if i == 1
            ylim(ax, ylim_mu);
        elseif i == 2
            ylim(ax, ylim_alpha);
        end

        % --- x轴标签：每组仅最下方显示 ---
        if i == 3
            xlabel(ax, 'Time (s)');
        else
            ax.XTickLabel = [];
        end

        % 统一刻度字体
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 15);

        % 避免挡曲线：可以让图例稍微透明（新版本支持）
        % lgd.Color = 'none';

        %计算超调量 调节时间 稳态误差等数值
        yR = y_rl(:, i);
        yS = y_smc(:, i);
        r = refVal(i);

        if i <= 2
            info_rl = stepinfo(yR, t, r);
            info_smc = stepinfo(yS, t, r);

            S_rl = wOS * (info_rl.Overshoot / OS_ref) + ...
                wT * (info_rl.SettlingTime / Ts_ref) + ...
                we * (abs(r - yR(end)) / e_ref);
            S_smc = wOS * (info_smc.Overshoot / OS_ref) + ...
                wT * (info_smc.SettlingTime / Ts_ref) + ...
                we * (abs(r - yS(end)) / e_ref);

            fprintf('%s:\n', labels{i});
            fprintf('  TD3-SMC: OS = %.2f%%, ts = %.2f s, ess = %.4e , S-rl = %.2f \n', ...
                info_rl.Overshoot, ...
                info_rl.SettlingTime, ...
                r - yR(end), ...
                S_rl);

            fprintf('  SMC    : OS = %.2f%%, ts = %.2f s, ess = %.4e , S-smc = %.2f \n', ...
                info_smc.Overshoot, ...
                info_smc.SettlingTime, ...
                r - yS(end), ...
                S_smc);
        else
            e_rl = yR;
            e_smc = yS;

            fprintf('%s:\n', labels{i});
            fprintf('  TD3-SMC: |e|max = %.4f, ess = %.4e, IAE = %.4f\n', ...
                abs(max(e_rl)), 0 - e_rl(end), trapz(t, abs(e_rl)));

            fprintf('  SMC    : |e|max = %.4f, ess = %.4e, IAE = %.4f\n', ...
                abs(max(e_smc)), 0 - e_smc(end), trapz(t, abs(e_smc)));
        end

    end

    % --- 每个子图都加 legend ---
    lgd = legend(ax, 'Location', legendLoc);
    lgd.FontSize = legendFS;
    lgd.Box = legendBox;
    lgd.Orientation = 'horizontal';
end
