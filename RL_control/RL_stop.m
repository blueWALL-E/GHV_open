%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-08 11:46:54
 * @LastEditTime: 2025-12-08 23:56:44
 * @FilePath: \GHV_open\RL_control\RL_stop.m
 * @Description: 强化学习回合停止条件
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%RL_stop 强化学习回合停止条件
%input:
% air_ang:  单位 rad    气流角 alpha攻角 beta侧滑角
% w:        单位 rad/s  机体转动角速度 p,q,r 1*3
% Ma:     单位 n.d.     马赫数
%output:
% flag_stop: 单位 n.d.   停止标志位 true-停止 false-继续
function flag_stop = RL_stop(Ma, w, air_ang)
    %默认不停止

    alpha = rad2deg(air_ang(1, 1)); %读取攻角数据
    q = rad2deg(w(2, 1)); %读取y轴机体角速度 即俯仰角速度

    flag_stop = false;
    %停止条件
    if ((Ma <= 4.1) || (alpha <= -10) || (alpha >= 30) || (q >= 100))
        flag_stop = true;
    end

end
