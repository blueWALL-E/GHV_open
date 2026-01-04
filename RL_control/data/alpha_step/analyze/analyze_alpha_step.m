%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-01-04 16:43:25
 * @LastEditTime: 2026-01-04 22:48:10
 * @FilePath: \GHV_open\RL_control\data\alpha_step\analyze\analyze_alpha_step.m
 * @Description:  分析不同高度下的攻角阶跃响应情况
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
load('RL_alpha_out_15s.mat');
load('SMC_alpha_out_15s.mat');
H_sample = 1.0e+04 * ...
    [2.4000; 2.4273; 2.4545; 2.4818; 2.5091; 2.5364; 2.5636; 2.5909; 2.6182; 2.6455; ...
     2.6727; 2.7000; 2.7273; 2.7545; 2.7818; 2.8091; 2.8364; 2.8636; 2.8909; 2.9182; ...
     2.9455; 2.9727; 3.0000; 3.0273; 3.0545; 3.0818; 3.1091; 3.1364; 3.1636; 3.1909; ...
     3.2182; 3.2455; 3.2727; 3.3000; 3.3273; 3.3545; 3.3818; 3.4091; 3.4364; 3.4636; ...
     3.4909; 3.5182; 3.5455; 3.5727; 3.6000; 3.6273; 3.6545; 3.6818; 3.7091; 3.7364; ...
     3.7636; 3.7909; 3.8182; 3.8455; 3.8727; 3.9000; 3.9273; 3.9545; 3.9818; 4.0091; ...
     4.0364; 4.0636; 4.0909; 4.1182; 4.1455; 4.1727; 4.2000; 4.2273; 4.2545; 4.2818; ...
     4.3091; 4.3364; 4.3636; 4.3909; 4.4182; 4.4455; 4.4727; 4.5000; 4.5273; 4.5545; ...
     4.5818; 4.6091; 4.6364; 4.6636; 4.6909; 4.7182; 4.7455; 4.7727; 4.8000; 4.8273; ...
     4.8545; 4.8818; 4.9091; 4.9364; 4.9636; 4.9909; 5.0182; 5.0455; 5.0727; 5.1000; ...
 ];

Mach_sample = ...
    [7.6629; 7.6485; 7.6342; 7.6198; 7.6054; 7.5911; 7.5770; 7.5634; 7.5499; 7.5369; ...
     7.5239; 7.5113; 7.4987; 7.4865; 7.4743; 7.4624; 7.4507; 7.4391; 7.4277; 7.4163; ...
     7.4053; 7.3942; 7.3833; 7.3725; 7.3618; 7.3512; 7.3407; 7.3304; 7.3202; 7.3104; ...
     7.3006; 7.2836; 7.2665; 7.2496; 7.2327; 7.2160; 7.1994; 7.1830; 7.1666; 7.1503; ...
     7.1341; 7.1180; 7.1021; 7.0862; 7.0704; 7.0546; 7.0390; 7.0234; 7.0079; 6.9924; ...
     6.9769; 6.9615; 6.9463; 6.9311; 6.9161; 6.9011; 6.8862; 6.8713; 6.8566; 6.8419; ...
     6.8274; 6.8128; 6.7983; 6.7840; 6.7697; 6.7554; 6.7412; 6.7271; 6.7131; 6.6991; ...
     6.6852; 6.6713; 6.6575; 6.6438; 6.6302; 6.6166; 6.6030; 6.5895; 6.5760; 6.5627; ...
     6.5494; 6.5361; 6.5229; 6.5096; 6.4965; 6.4842; 6.4738; 6.4697; 6.4657; 6.4616; ...
     6.4576; 6.4536; 6.4496; 6.4456; 6.4415; 6.4374; 6.4332; 6.4291; 6.4249; 6.4207; ...
 ];
% -------------------- 基本量 --------------------
H = H_sample(:);
N = length(H);

A = 5; % 阶跃目标值
ST = 0.02; % 调节时间阈值 2 %

% -------------------- 归一化综合指标参数 --------------------
OS_ref = 5; % 5 %
Ts_ref = 2; % 2 s
e_ref = 0.05; % 0.05（按你的alpha单位）

wOS = 0.5;
wT = 0.25;
we = 0.25;

% -------------------- 预分配（新增J字段） --------------------
RL_info = repmat(struct('H', [], 'Overshoot', [], 'SettlingTime', [], 'ess', [], 'J', []), N, 1);
SMC_info = repmat(struct('H', [], 'Overshoot', [], 'SettlingTime', [], 'ess', [], 'J', []), N, 1);

% -------------------- 计算 stepinfo + ess + J --------------------
for i = 1:N
    % ===== RL =====
    t = RL_alpha_out_15s(i).t(:);
    y = RL_alpha_out_15s(i).alpha(:);

    S = stepinfo(y, t, A, 'SettlingTimeThreshold', ST);

    RL_info(i).H = H(i);
    RL_info(i).Overshoot = S.Overshoot; % %
    RL_info(i).SettlingTime = S.SettlingTime; % s
    RL_info(i).ess = A - y(end); % 最后一点稳态误差（你要求）
    RL_info(i).J = wOS * (RL_info(i).Overshoot / OS_ref) + ...
        wT * (RL_info(i).SettlingTime / Ts_ref) + ...
        we * (abs(RL_info(i).ess) / e_ref);

    % ===== SMC =====
    t = SMC_alpha_out_15s(i).t(:);
    y = SMC_alpha_out_15s(i).alpha(:);

    S = stepinfo(y, t, A, 'SettlingTimeThreshold', ST);

    SMC_info(i).H = H(i);
    SMC_info(i).Overshoot = S.Overshoot;
    SMC_info(i).SettlingTime = S.SettlingTime;
    SMC_info(i).ess = A - y(end);
    SMC_info(i).J = wOS * (SMC_info(i).Overshoot / OS_ref) + ...
        wT * (SMC_info(i).SettlingTime / Ts_ref) + ...
        we * (abs(SMC_info(i).ess) / e_ref);
end

% -------------------- 画每个高度的响应 + 右下角标注 --------------------
plotsPerFig = 20;

for i = 1:N

    if mod(i - 1, plotsPerFig) == 0
        figure;
    end

    subplot(4, 5, mod(i - 1, plotsPerFig) + 1)

    plot(RL_alpha_out_15s(i).t, RL_alpha_out_15s(i).alpha, 'LineWidth', 1.2, 'Color', 'b');
    hold on
    plot(SMC_alpha_out_15s(i).t, SMC_alpha_out_15s(i).alpha, 'LineWidth', 1.2, 'Color', 'g');

    yline(5, 'r', 'LineWidth', 1.5);
    grid on;
    ylim([0 7]);
    xlim([0 15]);

    title(sprintf('H = %.1f m', H(i)));
    xlabel('Time step');
    ylabel('\alpha');

    % ===== 右下角标注：OS/Ts/ess + J =====
    txt = {
           sprintf('RL : OS=%.2f%%, Ts=%.2fs, e_{ss}=%.3f', RL_info(i).Overshoot, RL_info(i).SettlingTime, RL_info(i).ess)
           sprintf('SMC: OS=%.2f%%, Ts=%.2fs, e_{ss}=%.3f', SMC_info(i).Overshoot, SMC_info(i).SettlingTime, SMC_info(i).ess)
           sprintf('J_{RL}=%.3f,  J_{SMC}=%.3f', RL_info(i).J, SMC_info(i).J)
           };

    text(0.98, 0.02, txt, ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 7, ...
        'BackgroundColor', 'w', ...
        'EdgeColor', [0.6 0.6 0.6]);

    hold off
end

% -------------------- 单独画：H - J 离散点图 --------------------
J_RL = [RL_info.J]';
J_SMC = [SMC_info.J]';

figure; grid on; hold on;
scatter(H, J_RL, 20, 'b', 'filled');
scatter(H, J_SMC, 20, 'g', 'filled');
xlabel('H (m)');
ylabel('J (normalized score)');
title('Comprehensive metric J vs H (smaller is better)');
legend('RL', 'SMC', 'Location', 'best');
