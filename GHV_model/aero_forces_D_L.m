%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-22 15:15:40
 * @LastEditTime: 2025-10-22 17:36:30
 * @FilePath: \GHV_open\GHV_model\aero_forces_D_L.m
 * @Description: 根据气动参数计算在机体坐标系下所受的气动力和气动力矩
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
function [D, L] = aero_forces_D_L(Coef, q, GHV_cfg)
    %输出变量大小定义
    D = zeros(1, 1); %#ok<PREALL> %阻力
    L = zeros(1, 1); %#ok<PREALL> %升力
    %输入变量赋值
    CD = Coef(1, 1); %阻力系数

    CL = Coef(3, 1); %升力系数

    s = GHV_cfg.s_ref; %机翼参考面积

    %计算气动力
    D = q * s * CD; %阻力

    L = q * s * CL; %升力

end
