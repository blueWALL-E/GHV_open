%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-10-22 15:15:40
 * @LastEditTime: 2025-10-22 16:48:35
 * @FilePath: \GHV_open\GHV_model\aero_forces_moments.m
 * @Description: 根据气动参数计算在机体坐标系下所受的气动力和气动力矩
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
function [Fair_body, Mair_body] = aero_forces_moments(Coef, q, GHV_cfg, x_cg, air_ang)
    %输出变量大小定义
    Fair_body = zeros(3, 1); %#ok<PREALL>
    Mair_body = zeros(3, 1); %#ok<PREALL>

    %输入变量赋值
    CD = Coef(1, 1); %阻力系数
    CY = Coef(2, 1); %侧向力系数
    CL = Coef(3, 1); %升力系数
    Cl = Coef(4, 1); %滚转力矩系数
    Cm = Coef(5, 1); %俯仰力矩系数
    Cn = Coef(6, 1); %偏航力矩系数
    s = GHV_cfg.s_ref; %机翼参考面积
    b = GHV_cfg.b_ref; %机翼展长
    c = GHV_cfg.c_ref; %机翼平均弦长
    alpha = air_ang(1, 1); %迎角
    beta = air_ang(2, 1); %侧滑角

    %计算气动力
    D = q * s * CD; %阻力
    Y = q * s * CY; %侧向力
    L = q * s * CL; %升力
    D_body =- D * cos(alpha) * cos(beta) - Y * cos(alpha) * sin(beta) + L * sin(alpha);
    % D_body =- D * cos(alpha) + L * sin(alpha);
    Y_body = Y * cos(beta) - D * sin(beta);
    % Y_body = Y;
    L_body = -L * cos(alpha) -Y * sin(alpha) * sin(beta) - D * sin(alpha) * cos(beta);
    % L_body = -L * cos(alpha)  - D * sin(alpha) ;
    %计算气动力矩
    l = q * b * s * Cl; %滚转力矩 Xb
    m = q * c * s * Cm; %俯仰力矩 Yb
    n = q * b * s * Cn; %偏航力矩Zb
    l_body = l;
    % m_body = m + x_cg * (D * sin(alpha) + L * cos(alpha));
    m_body = m - x_cg * L_body;
    % n_body = n - x_cg * Y;
    n_body = n - x_cg * Y_body;
    %输出机体坐标系下气动力和气动力矩
    Fair_body = [D_body; Y_body; L_body];
    % Fair_body = [-D; Y; -L];
    Mair_body = [l_body; m_body; n_body];

end
