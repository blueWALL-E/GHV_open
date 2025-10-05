%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-09-22 10:10:22
 * @LastEditTime: 2025-09-22 23:59:27
 * @FilePath: \GHV_open\GHV_model\cg_inertia_variation.m
 * @Description: 质心位置变化与转动惯量变化计算
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%cg_inertia_variation 质心位置变化与转动惯量变化计算
%input
% mass    单位 kg 飞行器当前质量

%output
% CG        单位 m 质心位置
% I         单位 kg*m^2 转动惯量矩阵 3*3
% dI_dmass  单位 ? 转动惯量对质量的导数矩阵 3*3

function [x_cg, I, dI_dmass] = cg_inertia_variation(mass)
    % 惯性矩
    Ixx = -7.1e-5 * mass ^ 2 + 19.91 * mass -5.9430e4;
    Iyy = -8.03e-4 * mass ^ 2 + 219.74 * mass -1.69e6;
    Izz = -8.03e-4 * mass ^ 2 + 219.74 * mass -1.69e6;
    I = diag([Ixx, Iyy, Izz]);

    % 重心位置
    x_cg_element = 1.65e-10 * mass ^ 2 -5.57e-5 * mass + 7.37;
    x_cg = [-x_cg_element; 0; 0];

    % 转动惯量对质量的导数
    dIxx_dmass = 1991/100 - (5238875316933513 * mass) / 36893488147419103232;
    dIyy_dmass = 10987/50 - (7406367745594385 * mass) / 4611686018427387904;
    dIzz_dmass = 10987/50 - (7406367745594385 * mass) / 4611686018427387904;
    dI_dmass = diag([dIxx_dmass; dIyy_dmass; dIzz_dmass]);

end
