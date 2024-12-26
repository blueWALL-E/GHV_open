%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-11-03 10:35:01
 * @LastEditTime: 2024-12-22 20:03:17
 * @FilePath: \AHV\AHV_control\FBL_M.m
 * @Description: 利用力矩实现三个姿态角的反馈线性化
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%反馈线性化1-利用力矩实现三个姿态角的反馈线性化
%input:
%att_ang:   单位 rad    机体对大地的欧拉角 姿态角 phi滚转角 theta俯仰角 psi偏航角
%w:         单位 rad/s  机体转动角速度 wx,wy,wz 1*3
%d_att_ang  单位 rad/s  姿态角速度 1*3
%u          单位 rad     反馈线性化的输入量=期望的姿态角度
%output:
%U1:        单位 N*m  反馈线性化后输出的力矩
function U1 = FBL_M(w, att_ang, d_att_ang, u)
    %代码中只展示必要的计算过程和最终结果，不涉及完整公式的推导
    %输出矩阵大小定义
    U1 = zeros(3, 1); %#ok<*PREALL>
    %反馈系数 暂时将极点配置在-2
    k_phi_1 = 4;
    k_theta_1 = 4;
    k_psi_1 = 4;
    k_phi_2 = 4;
    k_theta_2 = 4;
    k_psi_2 = 4;

    %机体的三轴转动惯量
    %最小转动惯量
    % Jx = 637234;
    % Jy = 6101181;
    % Jz = 6101181;

    %最大转动惯量
    Jx = 1.36 * 10 ^ 6;
    Jy = 1.5 * 10 ^ 7;
    Jz = 1.36 * 10 ^ 7;

    %输入变量赋值
    wx = w(1, 1); %机体转动角速度
    wy = w(2, 1);
    wz = w(3, 1);

    phi = att_ang(1, 1); %读取滚转角数据
    theta = att_ang(2, 1); %读取俯仰角数据
    psi = att_ang(3, 1); %偏航角不影响姿态角速度和机体转动角速度之间的转换

    d_phi = d_att_ang(1, 1); %姿态角速度
    d_theta = d_att_ang(2, 1);
    d_psi = d_att_ang(3, 1);

    %期望角度
    u_phi = u(1, 1);
    u_theta = u(2, 1);
    u_psi = u(3, 1);
    %反馈线性化求解输出结果
    f1 = ((wy * wz) / Jx) * (Jy - Jz);
    f2 = ((wz * wx) / Jy) * (Jz - Jx);
    f3 = ((wx * wy) / Jz) * (Jx - Jy);

    f4 = wx + (wz * cos(phi) + wy * sin(phi)) * tan(theta);
    f5 = wy * cos(phi) - wz * sin(phi);
    f6 = (1 / cos(theta)) * (wz * cos(phi) + wy * sin(phi)); %#ok<NASGU>

    p_Lh1_f456_px = [1, sin(phi) * tan(theta), cos(phi) * tan(theta), tan(theta) * (wy * cos(phi) - wz * sin(phi)), (wz * cos(phi) + wy * sin(phi)) / cos(theta) ^ 2; ...
                         0, cos(phi), -sin(phi), - wz * cos(phi) - wy * sin(phi), 0; ...
                         0, sin(phi) / cos(theta), cos(phi) / cos(theta), (wy * cos(phi) - wz * sin(phi)) / cos(theta), (sin(theta) * (wz * cos(phi) + wy * sin(phi))) / cos(theta) ^ 2];

    F1 = p_Lh1_f456_px * [f1; f2; f3; f4; f5];
    B1 = p_Lh1_f456_px(:, 1:3) * [1 / Jx, 0, 0; 0, 1 / Jy, 0; 0, 0, 1 / Jz];

    u1_phi = -k_phi_1 * phi - k_phi_2 * d_phi +k_phi_1 * u_phi;
    u1_theta = -k_theta_1 * theta - k_theta_2 * d_theta +k_theta_1 * u_theta;
    u1_psi = -k_psi_1 * psi - k_psi_2 * d_psi +k_psi_1 * u_psi;
    %这里的输出 是包含气动参数的影响 U1 = Mair + U
    U1 = inv(B1) * (-F1 + [u1_phi; u1_theta; u1_psi]); %#ok<MINV>
end
