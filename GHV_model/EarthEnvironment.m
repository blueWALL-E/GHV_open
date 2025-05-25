%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-10-16 16:57:42
 * @LastEditTime: 2024-12-27 22:46:02
 * @FilePath: \GHV_open\GHV_modle\EarthEnvironment.m
 * @Description: 获得地球大气USSA76和重力参数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%EarthEnvironment 获得地球大气USSA76和重力参数
%重力参数不考虑摄动影响
%输入变量
% H 单位 m  海拔高度 位势高度和海报高度的关系matlab自带函数解决

%输出变量
% T   单位 开尔文 温度
% vc  单位 m/s 声速
% P   单位 帕斯卡 大气压强
% rho 单位 kg/m3  大气密度
% g   单位 m/s2  重力加速度
function [T, vc, P, rho, g] = EarthEnvironment(H)
    coder.extrinsic('atmoscoesa'); %声明要用到的外部函数
    T = 1; %#ok<*NASGU>
    vc = 1;
    P = 1;
    rho = 1;
    [T, vc, P, rho] = atmoscoesa(H); %计算标准大气参数 其输出结果中大气密度单位为kg/m3 其他单位与输出结果单位一致

    g = 9.8 * (6356.766 / (6356.766 + (H / 1000))) ^ 2; %简单计算所在海拔高度的重力加速度

end
