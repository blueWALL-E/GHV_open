%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-10-11 21:36:21
 * @LastEditTime: 2025-10-21 10:25:47
 * @FilePath: \GHV_open\GHV_model\rot_kin.m
 * @Description: 转动运动学方程 第二组方程
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%转动运动学方程 第二组方程
%机体坐标系下 输入输出向量均为列向量
%input:
%att_ang:   单位 rad    机体对大地的欧拉角 姿态角 phi滚转角 theta俯仰角 psi偏航角
%w:         单位 rad/s  机体转动角速度 wx,wy,wz 3*1

%output:
%d_att_ang: 单位 rad/s  姿态角速度 3*1
function d_att_ang = rot_kin(att_ang, w)
    d_att_ang = zeros(3, 1); %#ok<PREALL>
    %输入变量赋值
    wx = w(1, 1);
    wy = w(2, 1);
    wz = w(3, 1);
    phi = att_ang(1, 1); %读取滚转角数据
    theta = att_ang(2, 1); %读取俯仰角数据
    % psi = att_ang(3, 1); %偏航角不影响姿态角速度和机体转动角速度之间的转换
    %奇异点判断报错
    if theta == pi / 2
        error('theta == pi / 2; MY ERROR !The input data is incorrect!');
    end

    % if ((phi > pi / 2) || (phi <- pi / 2))
    %     error('phi > pi / 2; MY ERROR !The input data is incorrect!');
    % end

    %计算
    d_phi = wx + (wz * cos(phi) + wy * sin(phi)) * tan(theta);
    d_theta = wy * cos(phi) - wz * sin(phi);
    d_psi = (1 / cos(theta)) * (wz * cos(phi) + wy * sin(phi));

    %输出
    d_att_ang = [d_phi; d_theta; d_psi];

end
