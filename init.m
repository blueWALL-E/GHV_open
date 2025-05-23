%{
/*
 * @Author: blueWALL-E
 * @Date: 2024-11-01 17:21:49
 * @LastEditTime: 2025-05-23 22:22:03
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

% 调用其他初始化脚本（如参数、仿真配置等）
try
    GHV_Configuration(); % 替换为你的初始化脚本名（无需加 .m）
    disp('✅ 参数初始化脚本 GHV_Configuration.m 已执行');
catch ME
    warning('init_aircraft_params.m 执行失败');

end

% 显示结果
disp(['已完成工作区文件加载: ', currentFolder]);

% 飞行器基本参数设置并未实现统一全局变量接口 请务必注意最大质量和最小质量带来的相关参数变化
% FBL_M (J) 转动惯量
% tra_dyn (m) 质量
% Get_Aerodynamic (x_cg) 力矩中心到质心的距离 注意单位制
% rot_dyn (J) 转动惯量
