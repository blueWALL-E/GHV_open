%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-11-01 17:21:49
 * @LastEditTime: 2024-12-27 20:06:37
 * @FilePath: \GHV_open\init.m
 * @Description: 完成工作区文件夹加载工作
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
 %}

% 获取当前文件夹路径

currentFolder = pwd;

% 生成包含所有子文件夹的路径
addpath(genpath(currentFolder));

% 显示结果
disp(['已完成工作区文件加载: ', currentFolder]);

% 飞行器基本参数设置并未实现统一全局变量接口 请务必注意最大质量和最小质量带来的相关参数变化
% FBL_M (J) 转动惯量
% tra_dyn (m) 质量
% Get_Aerodynamic (x_cg) 力矩中心到质心的距离 注意单位制
% rot_dyn (J) 转动惯量
