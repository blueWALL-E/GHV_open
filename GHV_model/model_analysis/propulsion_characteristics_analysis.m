%% ------------ Global Settings ------------
PLA_in_percent = false; % true if input 0~100, false if 0~1
PLA_fixed = 1.0; % Fixed throttle for certain maps

%% ------------ 1) Turbojet: T(Ma,H | PLA) ------------
Ma1 = linspace(0.01, 2.0, 250); % 0 < Ma < 2
H1 = linspace(0, 173700, 250); % km
[MaG1, HG1] = meshgrid(Ma1, H1);
T_tj = T_turbojet(MaG1, HG1, PLA_fixed);

figure('Name', 'Turbojet: T(Ma,H)', 'Color', 'w');

% === 1. 彩色等高面 ===
contourf(MaG1, HG1, T_tj, 30, 'LineStyle', 'none');
colormap(turbo); % 你也可以换成 'parula', 'turbo', 'hot' 等
colorbar;

hold on;

% === 2. 黑色等高线 (数量稀疏一点，比如每隔 5~8 个等级) ===
[C, h] = contour(MaG1, HG1, T_tj, 8, 'LineColor', 'k', 'LineWidth', 0.8);

% === 3. 在部分线条上加标签 (自动分布, 字体小一点) ===
clabel(C, h, 'Color', 'k', 'FontSize', 8, 'LabelSpacing', 500);

hold off;

xlabel('Mach number (Ma)');
ylabel('Altitude H (km)');
title(sprintf('Turbojet Thrust (PLA = %.0f%%)', PLA_fixed * 100));
set(gca, 'FontName', 'Times New Roman');
grid on;

%% ------------ 2) Scramjet: T(Ma,PLA) ------------
Ma2 = linspace(2.0, 6.0, 300);
[MaG2, PLAG2] = meshgrid(Ma2, PLA_fixed);
T_scram = T_scramjet(MaG2, PLAG2);

figure('Name', 'Scramjet: T(Ma,PLA)', 'Color', 'w');
plot(Ma2, T_scram, 'b-', 'LineWidth', 1.5);
xlabel('Mach number (Ma)');
ylabel('Thrust (N)');
title(sprintf('Scramjet Thrust (PLA = %.0f%%)', PLA_fixed * 100));
set(gca, 'FontName', 'Times New Roman');
grid on;

%% ------------ 3) Rocket: T(H,PLA) ------------
H3 = linspace(0, 30 * 1000, 300);
PLA3 = linspace(0, 1, 300);
[HG3, PLAG3] = meshgrid(H3, PLA3);
T_rocket_map = T_rocket(HG3, PLAG3);

figure('Name', 'Rocket: T(H,PLA)', 'Color', 'w');

% === 1. 彩色等高面 ===
contourf(HG3, PLAG3 * 100, T_rocket_map, 30, 'LineStyle', 'none');
colormap(turbo); % 你也可以换成 'parula', 'turbo', 'hot' 等
colorbar;

hold on;

% === 2. 黑色等高线 (数量稀疏一点，比如每隔 5~8 个等级) ===
[C, h] = contour(HG3, PLAG3 * 100, T_rocket_map, 8, 'LineColor', 'k', 'LineWidth', 0.8);

% === 3. 在部分线条上加标签 (自动分布, 字体小一点) ===
clabel(C, h, 'Color', 'k', 'FontSize', 8, 'LabelSpacing', 500);

hold off;
xlabel('Altitude H (km)');
ylabel('PLA (%)');
title('Rocket Thrust (6 < Ma < 24)');
set(gca, 'FontName', 'Times New Roman');
grid on;

%% ============================================================
%  Local Function Definitions
% ============================================================

function T = T_turbojet(Ma, H, PLA)
    % Turbojet thrust model (0 < Ma < 2)
    T = PLA .* (1.33e6 - 4.45 .* H +5.92e-4 .* H .^ 2 -2.88e-9 .* H .^ 3 +1.67e4 .* Ma .^ 3);
    T(Ma <= 0 | Ma >= 2) = NaN;
end

function T = T_scramjet(Ma, PLA)
    % Scramjet thrust model (2 < Ma < 6)
    poly = 3.35e3 .* Ma .^ 7 ...
        -6.68e4 .* Ma .^ 6 ...
        +5.16e5 .* Ma .^ 5 ...
        -1.94e6 .* Ma .^ 4 ...
        +3.59e6 .* Ma .^ 3 ...
        -3.10e6 .* Ma .^ 2 ...
        +1.75e6 .* Ma ...
        +1.75e+7;
    T = PLA .* poly;
    T(Ma <= 2 | Ma >= 6) = NaN;
end

function T = T_rocket(H, PLA)
    % Rocket thrust model (6 < Ma < 24)
    T = nan(size(H));
    idx1 = H < 17.37e3;
    % T(idx1) = -2.42e5 + 2.95 .* H(idx1) +1.44e6 .* PLA(idx1) + 1.66 .* H(idx1) .* PLA(idx1);
    T(idx1) = 2.95 .* H(idx1) +1.44e6 .* PLA(idx1) +1.66 .* H(idx1) .* PLA(idx1);
    idx2 = H >= 17.37e3;
    % T(idx2) = -7.30e4 + (1.44e5 +9.75e4) .* PLA(idx2);
    T(idx2) = 2.41e6 .* PLA(idx2);
end
