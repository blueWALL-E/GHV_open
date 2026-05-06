%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-04-09 21:07:37
 * @LastEditTime: 2026-04-09 21:08:18
 * @FilePath: \GHV_open\GHV_control_parameter_optimization\reshape_to_n3.m
 * @Description: 格式转换函数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
function y = reshape_to_n3(data)
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
