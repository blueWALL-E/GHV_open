%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-25 22:40:42
 * @LastEditTime: 2025-12-27 14:36:35
 * @FilePath: \GHV_open\RL_control\math\reward_base_fit.m
 * @Description: 基准奖励值拟合
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%reward_fit  基准奖励值拟合
%input
% H          单位 m    海拔高度

%output
% reward_base    单位 n.d.  基准奖励值
function reward_base = reward_base_fit(H)

    p1 = -0.00117;
    p2 = 0.222;
    p3 = -11.67;
    p4 = 295.4;
    p5 = -2438;
    x = H / 1000;
    reward_base = p1 * x ^ 4 + p2 * x ^ 3 + p3 * x ^ 2 + p4 * x + p5;

end
