%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-02 23:56:40
 * @LastEditTime: 2025-10-02 23:57:47
 * @FilePath: \GHV_open\GHV_model\geometric2geopotential.m
 * @Description: 几何高度转等势高度
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%几何高度转等势高度

%input:

%H_geom: 几何高度 单位 m
%output:
%H_geo: 等势高度 单位 m
function H_geo = geometric2geopotential(H_geom)
    % 几何高度转等势高度
    % 输入: H_geom 几何高度 单位 m
    % 输出: H_geo 等势高度 单位 m
    Re = 6371000; % 地球平均半径 单位 m
    H_geo = (Re * H_geom) ./ (Re + H_geom);
end
