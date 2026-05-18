%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-03-07 16:29:17
 * @LastEditTime: 2026-03-07 21:35:31
 * @FilePath: \GHV_open\RL_control\data\6DOF\anaylze_6DOF_wide.m
 * @Description: 宽域飞行性能测试
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
%% Load
load("data_6DOF/wide_range_490s.mat");

GS_SMC = wide_range_490s.get("SMC");
GS_SMC{23}.Name = 'V';

TD3_SMC = wide_range_490s.get("TD3-SMC");
TD3_SMC{23}.Name = 'V';

sigName = 'aero_ang';
labels = {'\mu', '\alpha', '\beta'};
unitStr = 'deg'; % 也可以写成 '°'

%% ===== 取时间 =====
sig_gs = GS_SMC.get(sigName);
sig_td3 = TD3_SMC.get(sigName);

t = sig_gs.Values.Time;

%% ===== 取数据 =====
data_gs = sig_gs.Values.Data;
data_td3 = sig_td3.Values.Data;
data_command = GS_SMC.get("aero_ang_d").Values.Data; % 取命令数据（假设GS_SMC和TD3_SMC的命令数据相同）

% ===== 数据维度兼容处理 =====
% 若数据是 3x1xN，则转成 Nx3
% 若数据已经是 Nx3，则直接使用
if ndims(data_gs) == 3
    y_gs = squeeze(permute(data_gs, [3 1 2]));
elseif ismatrix(data_gs) && size(data_gs, 2) == 3
    y_gs = data_gs;
else
    error('GS_SMC 中 aero_ang 的数据维度不符合预期。');
end

if ndims(data_td3) == 3
    y_td3 = squeeze(permute(data_td3, [3 1 2]));
elseif ismatrix(data_td3) && size(data_td3, 2) == 3
    y_td3 = data_td3;
else
    error('TD3_SMC 中 aero_ang 的数据维度不符合预期。');
end

if ndims(data_command) == 3
    y_command = squeeze(permute(data_command, [3 1 2]));
elseif ismatrix(data_command) && size(data_command, 2) == 3
    y_command = data_command;
else
    error('command 的数据维度不符合预期。');
end

%% ===== 新建一个图：3×1 从上到下排列 =====
figure('Color', 'w', 'Position', [200 100 800 700]);
TL = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 1:3

    ax = nexttile(TL);
    hold on;

    % ===== GS_SMC =====
    h1 = plot(t, y_gs(:, k), ...
        'g-', 'LineWidth', 1.4);

    % ===== TD3_SMC =====
    h2 = plot(t, y_td3(:, k), ...
        'b-', 'LineWidth', 1.4);

    % ===== Command =====
    h3 = plot(t, y_command(:, k), ...
        'r--', 'LineWidth', 1.4);

    % ===== 轴标签 =====
    ylabel(sprintf('%s (%s)', labels{k}, unitStr), ...
        'Rotation', 0, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 14, ...
        'FontWeight', 'bold');

    % 只给最后一个子图加 xlabel
    if k == 3
        xlabel('Time (s)', 'FontSize', 15, 'FontWeight', 'bold');
    end

    % ===== 子图标题 =====
    title(sprintf('(%c) %s channel', 'a'+k - 1, labels{k}), ...
        'FontSize', 18, 'FontWeight', 'bold');

    % % ===== 图例只放第一个子图 =====
    % if k == 1
    %     legend([h1, h2], ...
    %         {'GS-SMC', 'TD3-SMC'}, ...
    %         'NumColumns', 2, ...
    %         'Location', 'best', ...
    %         'FontSize', 12);
    % end

    % ===== Style =====
    grid on;
    box on;
    set(ax, 'FontSize', 12, 'LineWidth', 1.0);

end

% ===== 图例放在整个图的最下面 =====
lgd = legend([h3, h1, h2], ...
    {'Command', 'GS-SMC', 'TD3-SMC'}, ...
    'NumColumns', 3, ...
    'Location', 'southoutside', ...
    'FontSize', 12);
lgd.Layout.Tile = 'south';
% ===== 总标题（可选）=====
% sgtitle('Comparison of aero\_ang between GS\_SMC and TD3\_SMC', ...
%     'FontSize', 16, 'FontWeight', 'bold');

%% ===== 第二个图：aero_ang_e（无 command）=====
sigName2 = 'aero_ang_e';

% ===== 取时间 =====
sig_gs_e = GS_SMC.get(sigName2);
sig_td3_e = TD3_SMC.get(sigName2);

t2 = sig_gs_e.Values.Time;

% ===== 取数据 =====
data_gs_e = sig_gs_e.Values.Data;
data_td3_e = sig_td3_e.Values.Data;

% ===== 数据维度兼容处理 =====
if ndims(data_gs_e) == 3
    y_gs_e = squeeze(permute(data_gs_e, [3 1 2]));
elseif ismatrix(data_gs_e) && size(data_gs_e, 2) == 3
    y_gs_e = data_gs_e;
else
    error('GS_SMC 中 aero_ang_e 的数据维度不符合预期。');
end

if ndims(data_td3_e) == 3
    y_td3_e = squeeze(permute(data_td3_e, [3 1 2]));
elseif ismatrix(data_td3_e) && size(data_td3_e, 2) == 3
    y_td3_e = data_td3_e;
else
    error('TD3_SMC 中 aero_ang_e 的数据维度不符合预期。');
end

%% ===== 第二个图：aero_ang_e（无 command，带局部放大图）=====
sigName2 = 'aero_ang_e';

% ===== 取时间 =====
sig_gs_e = GS_SMC.get(sigName2);
sig_td3_e = TD3_SMC.get(sigName2);

t2 = sig_gs_e.Values.Time;

% ===== 取数据 =====
data_gs_e = sig_gs_e.Values.Data;
data_td3_e = sig_td3_e.Values.Data;

% ===== 数据维度兼容处理 =====
if ndims(data_gs_e) == 3
    y_gs_e = squeeze(permute(data_gs_e, [3 1 2]));
elseif ismatrix(data_gs_e) && size(data_gs_e, 2) == 3
    y_gs_e = data_gs_e;
else
    error('GS_SMC 中 aero_ang_e 的数据维度不符合预期。');
end

if ndims(data_td3_e) == 3
    y_td3_e = squeeze(permute(data_td3_e, [3 1 2]));
elseif ismatrix(data_td3_e) && size(data_td3_e, 2) == 3
    y_td3_e = data_td3_e;
else
    error('TD3_SMC 中 aero_ang_e 的数据维度不符合预期。');
end

%% ===== 新建第二个图：3×1 从上到下排列 =====
figure('Color', 'w', 'Position', [250 120 900 760]);
TL2 = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

ax_list = gobjects(3, 1);

for k = 1:3

    ax = nexttile(TL2);
    ax_list(k) = ax;
    hold(ax, 'on');

    % ===== GS_SMC =====
    h1 = plot(ax, t2, y_gs_e(:, k), ...
        'g-', 'LineWidth', 1.4);

    % ===== TD3_SMC =====
    h2 = plot(ax, t2, y_td3_e(:, k), ...
        'b-', 'LineWidth', 1.4);

    % ===== 轴标签 =====
    ylabel(ax, sprintf('%s (%s)', labels{k}, unitStr), ...
        'Rotation', 0, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 14, ...
        'FontWeight', 'bold');

    if k == 3
        xlabel(ax, 'Time (s)', 'FontSize', 15, 'FontWeight', 'bold');
    end

    title(ax, sprintf('(%c) %s error channel', 'a'+k - 1, labels{k}), ...
        'FontSize', 18, 'FontWeight', 'bold');

    grid(ax, 'on');
    box(ax, 'on');
    set(ax, 'FontSize', 12, 'LineWidth', 1.0);

end

% ===== 图例放在整个图的最下面 =====
lgd2 = legend([h1, h2], ...
    {'GS-SMC', 'TD3-SMC'}, ...
    'NumColumns', 2, ...
    'Location', 'southoutside', ...
    'FontSize', 12);
lgd2.Layout.Tile = 'south';

%% ===== 添加局部放大图 =====

% ---------- mu 通道 inset ----------
ax_mu = ax_list(1);
pos_mu = ax_mu.Position;

inset_mu = axes('Position', [ ...
                        pos_mu(1) + 0.2 * pos_mu(3), ...
                        pos_mu(2) + 0.55 * pos_mu(4), ...
                        0.26 * pos_mu(3), ...
                        0.37 * pos_mu(4)]);

hold(inset_mu, 'on');
plot(inset_mu, t2, y_gs_e(:, 1), 'g-', 'LineWidth', 1.0);
plot(inset_mu, t2, y_td3_e(:, 1), 'b-', 'LineWidth', 1.0);
xlim(inset_mu, [63 80]);
ylim(inset_mu, [-0.0005 0.0002]);
grid(inset_mu, 'on');
box(inset_mu, 'on');
set(inset_mu, 'FontSize', 8, 'LineWidth', 0.8, ...
    'Color', 'w'); % 白底

% ---------- beta 通道 inset ----------
ax_beta = ax_list(3);
pos_beta = ax_beta.Position;

inset_beta = axes('Position', [ ...
                          pos_beta(1) + 0.2 * pos_beta(3), ...
                          pos_beta(2) + 0.52 * pos_beta(4), ...
                          0.26 * pos_beta(3), ...
                          0.37 * pos_beta(4)]);

hold(inset_beta, 'on');
plot(inset_beta, t2, y_gs_e(:, 3), 'g-', 'LineWidth', 1.0);
plot(inset_beta, t2, y_td3_e(:, 3), 'b-', 'LineWidth', 1.0);
xlim(inset_beta, [252 270]);
ylim(inset_beta, [-0.001 0.0005]);
grid(inset_beta, 'on');
box(inset_beta, 'on');
set(inset_beta, 'FontSize', 8, 'LineWidth', 0.8, ...
    'Color', 'w'); % 白底

%% ===== 第三个图：飞行状态量 =====

figure('Color', 'w', 'Position', [220 120 800 850]);
TL3 = tiledlayout(4, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% ===== 取时间 =====
t3 = TD3_SMC.get("Mach").Values.Time;

%% ===== 取数据 =====

% LLA
data_LLA = TD3_SMC.get("LLA").Values.Data;

if ndims(data_LLA) == 3
    LLA = squeeze(permute(data_LLA, [3 1 2]));
else
    LLA = data_LLA;
end

h = LLA(:, 3); % 高度

% Mach
Mach = TD3_SMC.get("Mach").Values.Data;

% V
V = TD3_SMC.get("V").Values.Data;

% Qbar
Qbar = TD3_SMC.get("Qbar").Values.Data;

%% ===== (a) Height =====
ax = nexttile(TL3);
plot(t3, h, 'b-', 'LineWidth', 1.4);

ylabel('Height (m)', ...
    'FontSize', 14, ...
    'FontWeight', 'bold');

title('(a) Altitude', 'FontSize', 18, 'FontWeight', 'bold');

grid on
box on
set(ax, 'FontSize', 12, 'LineWidth', 1.0)

%% ===== (b) Mach =====
ax = nexttile(TL3);
plot(t3, Mach, 'b-', 'LineWidth', 1.4);

ylabel('Mach', ...
    'FontSize', 14, ...
    'FontWeight', 'bold');

title('(b) Mach Number', 'FontSize', 18, 'FontWeight', 'bold');

grid on
box on
set(ax, 'FontSize', 12, 'LineWidth', 1.0)

%% ===== (c) Velocity =====
ax = nexttile(TL3);
plot(t3, V, 'b-', 'LineWidth', 1.4);

ylabel('V (m/s)', ...
    'FontSize', 14, ...
    'FontWeight', 'bold');

title('(c) Velocity', 'FontSize', 18, 'FontWeight', 'bold');

grid on
box on
set(ax, 'FontSize', 12, 'LineWidth', 1.0)

%% ===== (d) Dynamic Pressure =====
ax = nexttile(TL3);
plot(t3, Qbar, 'b-', 'LineWidth', 1.4);

ylabel('Qbar (Pa)', ...
    'FontSize', 14, ...
    'FontWeight', 'bold');

title('(d) Dynamic Pressure', 'FontSize', 18, 'FontWeight', 'bold');

xlabel('Time (s)', 'FontSize', 15, 'FontWeight', 'bold');

grid on
box on
set(ax, 'FontSize', 12, 'LineWidth', 1.0)
