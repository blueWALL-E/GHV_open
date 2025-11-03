%{
/*
 * @Author:blueWALL-E
 * @Date:2025-10-18 20:22:45
 * @LastEditTime: 2025-10-18 20:35:42
 * @FilePath: \GHV_open\GHV_model\EulerRate2BodyRate.m
 * @Description:
 * @Wearing:Read only, do not modify place !!!
 * @Shortcut keys:ctrl+alt+/ ctrl+alt+z
 */
%}

%姿态角速率与角速度分量转换
%input:
%d_att_ang: 单位 rad/s  姿态角速度 1*3

%output:
%w:         单位 rad/s  机体转动角速度 wx,wy,wz 1*3 pqr
function w = EulerRate2BodyRate(d_att_ang, att_ang)
    w = zeros(3, 1); %#ok<PREALL>
    %输入变量赋值
    d_phi = d_att_ang(1, 1); %读取滚转角数据φ
    d_theta = d_att_ang(2, 1); %读取俯仰角数据θ
    d_psi = d_att_ang(3, 1); %读取偏航角数据ψ
    phi = att_ang(1, 1); %读取滚转角数据φ
    theta = att_ang(2, 1); %读取俯仰角数据
    % psi = att_ang(3, 1); %读取偏航角数据ψ
    %计算机体角速度
    p = d_phi - sin(theta) * d_psi; %计算机体绕x轴角速度分量
    q = cos(phi) * d_theta + sin(phi) * cos(theta) * d_psi; %计算机体绕y轴角速度分量
    r = -sin(phi) * d_theta + cos(phi) * cos(theta) * d_psi; %计算机体绕z轴角速度分量
    %输出变量赋值
    w = [p; q; r];
end
