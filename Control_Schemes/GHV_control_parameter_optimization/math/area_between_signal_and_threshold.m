%{
/*
* @Author:blueWALL - E
* @Date:2026 - 04 - 09 21:21:17
 * @LastEditTime: 2026-04-09 21:21:37
 * @FilePath: \GHV_open\GHV_control_parameter_optimization\math\area_between_signal_and_threshold.m
* @Description:
* @Wearing:Read only, do not modify place ! !!
* @Shortcut keys:ctrl + alt +/ ctrl + alt + z
*/
%}
function J = area_between_signal_and_threshold(t, y, threshold)
    % 计算从 t=0 到第一次穿过 threshold 为止，
    % 信号 y(t) 与水平线 threshold 之间围成的面积

    t = t(:);
    y = y(:);

    assert(length(t) == length(y), 't 和 y 长度不一致');

    if length(t) < 2
        J = 0;
        return;
    end

    % 相对阈值的信号
    z = y - threshold;

    % 找第一次穿过 threshold 的区间
    idx = find(z(1:end - 1) .* z(2:end) <= 0, 1, 'first');

    % 如果从来没穿过，就积分全程与 threshold 的面积
    if isempty(idx)
        J = trapz(t, abs(y - threshold));
        return;
    end

    % 如果起点就在 threshold 上，面积为 0
    if z(1) == 0
        J = 0;
        return;
    end

    % 线性插值求交点时刻
    t1 = t(idx);
    t2 = t(idx + 1);
    z1 = z(idx);
    z2 = z(idx + 1);

    if z2 == z1
        J = trapz(t(1:idx), abs(y(1:idx) - threshold));
        return;
    end

    t_cross = t1 - z1 * (t2 - t1) / (z2 - z1);

    % 交点处 y = threshold
    t_new = [t(1:idx); t_cross];
    y_new = [y(1:idx); threshold];

    % 关键：积的是 |y - threshold|
    J = trapz(t_new, abs(y_new - threshold));
end
