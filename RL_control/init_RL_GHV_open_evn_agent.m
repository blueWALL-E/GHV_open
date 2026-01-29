%{
/*
 * @Author: blueWALL-E
 * @Date: 2025-12-09 10:34:50
 * @LastEditTime: 2025-12-27 14:38:32
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
obsInfo = rlNumericSpec([3, 1]); % 定义观测值为3维向量
% Name和Description是可选的，仅用于标识
obsInfo.Name = "observations";
obsInfo.Description = "altitude, Mach number, attack error";

% 创建动作规定（Action Specification）
actInfo = rlNumericSpec([5 1], ...
    'LowerLimit', [-0.4; -0.1; 0; -9e-5; -50], ...
    'UpperLimit', [0; 0; 500; 0; 50]); % 定义动作为5维标量
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
    alpha_d = 5;
    aero_ang_d = [0; alpha_d; 0]; % 期望气动角设定为随机攻角
    blk = sprintf("RL_GHV_open_smc/aero_ang_D");
    in = setBlockParameter(in, blk, Value = mat2str(aero_ang_d));
    % 设置飞行器初始随机高度和马赫数
    [H_0, mach_0] = mach_h_sample(randi(52)); % 随机选择高度马赫数查表索引
    [~, vc, ~, ~, ~] = EarthEnvironment(H_0); %获取大气参数

    pos_0 = [0; 0; H_0]; % 初始位置向量
    blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/xg_0");
    % blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/Vm_0");
    in = setBlockParameter(in, blk, Value = mat2str(pos_0));

    % 设置飞行器初始速度
    speed_0 = mach_0 * vc;
    Vm_0 = [speed_0; 0; 0]; % 初始速度向量
    blk = sprintf("RL_GHV_open_smc/6DOF dynamic equation self/Vm_0");
    in = setBlockParameter(in, blk, Value = mat2str(Vm_0));

    % 设置基准控制参数
    [lambad_p_alpha, lambad_I_alpha, k_alpha, epsilon_alpha, gamma_rho_alpha] = gain_scheduling(H_0);
    control_param_0 = [lambad_p_alpha; lambad_I_alpha; k_alpha; epsilon_alpha; gamma_rho_alpha];
    blk = sprintf("RL_GHV_open_smc/control_param");
    in = setBlockParameter(in, blk, Value = mat2str(control_param_0));

    % 设置增益归一化系数
    reward_base = 1/(reward_base_fit(H_0));
    blk = sprintf("RL_GHV_open_smc/reward_Gain");
    in = setBlockParameter(in, blk, Gain = num2str(reward_base));
end
