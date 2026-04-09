%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-04-08 22:56:57
 * @LastEditTime: 2026-04-10 00:10:30
 * @FilePath: \GHV_open\GHV_control_parameter_optimization\sqp.m
 * @Description: sqp优化控制参数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}

%% 1) 模型名

model = 'GHV_open_smc_sqp'; %仿真平台名称
load_system(model);

%% 2) 控制参数块路径
blk_control_param = 'GHV_open_smc_sqp/control_param_alpha'; % 控制参数路径

%% 3) 读取当前初始控制参数
control_param = str2num(get_param(blk_control_param, 'Value')); %#ok<ST2NM>
x0 = control_param;
disp('初始控制参数 = ');
disp(control_param);

%% 4) 初值、上下界

% 这里先给一个示例边界，你后面按工程实际改
lb = [0.1; 0.01; 100; 0; 100];
ub = [15; 3; 2000; 0.02; 500];

%% 5) SQP 选项
opts = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter', ...
    'MaxIterations', 30, ...
    'MaxFunctionEvaluations', 300, ...
    'StepTolerance', 1e-6, ...
    'OptimalityTolerance', 1e-4, ...
    'ConstraintTolerance', 1e-4);

%% 6) 执行优化
[control_param_opt, J_opt, exitflag, output] = fmincon( ...
    @(control_param)objfun_control_param(control_param, model, blk_control_param), ...
    x0, ...
    [], [], [], [], ...
    lb, ub, ...
    @(control_param)nonlcon_control_param(control_param, model, blk_control_param), ...
    opts);

%% 7) 显示结果
disp('========== 优化完成 ==========');
disp('最优控制参数 = ');
disp(control_param_opt);

disp('最优目标值 = ');
disp(J_opt);

disp('exitflag = ');
disp(exitflag);

disp('output = ');
disp(output);

%% 8) 把最优控制参数写回模型并再仿真一次
in = Simulink.SimulationInput(model);
in = in.setBlockParameter(blk_control_param, 'Value', mat2str(control_param_opt));
in = in.setModelParameter('StopTime', '10');

simOut = sim(in);

disp('最优控制参数已写回并完成仿真。');
