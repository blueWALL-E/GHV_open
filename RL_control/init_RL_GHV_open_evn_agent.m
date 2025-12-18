%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-09 10:34:50
 * @LastEditTime: 2025-12-14 15:24:00
 * @FilePath: \GHV_open\RL_control\init_RL_GHV_open_evn_agent.m
 * @Description: 强化学习环境与智能体初始化脚本
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
% 指定仿真平台路径
evn_path = 'RL_GHV_open_smc';
% 打开仿真平台
open_system(evn_path);

% 创建状态规定（Observation Specification）
obsInfo = rlNumericSpec([3, 1]); % 定义观测值为2维向量
% Name和Description是可选的，仅用于标识
obsInfo.Name = "observations";
obsInfo.Description = "altitude, Mach number, Expected attack";

% 创建动作规定（Action Specification）
actInfo = rlNumericSpec([5 1], ...
    'LowerLimit', [-4; -0.2; -10; -0.0005; -50], ...
    'UpperLimit', [4; 0.2; 10; 0.0005; 100]); % 定义动作为5维标量
actInfo.Name = "control_param"; % 动作名称为“control_param”
actInfo.Description = "lambad_p_alpha, lambad_I_alpha, k_alpha, epsilon_alpha, gamma_rho_alpha ";
%滑模面权重-比例项 滑模面权重-积分项 趋近率权重 滑模面宽度 自适应增益

% 指定强化学习Agent在Simulink中的位置
agent_path = [evn_path '/RL Agent'];

% 创建强化学习环境
env = rlSimulinkEnv(evn_path, agent_path, obsInfo, actInfo);
% 设置环境的重置函数
env.ResetFcn = @(in)localResetFcn(in);

% 状态重置函数
function in = localResetFcn(in)

    % 设置飞行器期望攻角
    % alpha_d = 3 + (8 - 3) * rand;
    alpha_d = randi([3, 7]);
    aero_ang_d = [0; alpha_d; 0]; % 期望气动角设定为随机攻角
    blk = sprintf("RL_GHV_open_smc/aero_ang_D");
    in = setBlockParameter(in, blk, Value = mat2str(aero_ang_d));

    % 设置飞行器初始位置
    h_0 = randi([17, 30]) * 1000; % 初始高度在17000到68000米之间随机
    pos_0 = [0; 0; h_0]; % 初始位置向量
    blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/xg_0");
    % blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/Vm_0");
    in = setBlockParameter(in, blk, Value = mat2str(pos_0));

    % 设置飞行器初始速度
    v_candidates = 1388:60:2588; % 所有允许的速度点
    speed_0 = v_candidates(randi(numel(v_candidates))); %速度在1388到2588m/s之间随机选择 间隔60m/s
    Vm_0 = [speed_0; 0; 0]; % 初始速度向量
    blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/Vm_0");
    in = setBlockParameter(in, blk, Value = mat2str(Vm_0));

end
