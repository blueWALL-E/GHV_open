%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-04-09 22:24:39
 * @LastEditTime: 2026-04-11 16:17:23
 * @FilePath: \GHV_open\GHV_control_parameter_optimization\math\objfun_control_param.m
 * @Description: 目标函数构造
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
 %}
function J = objfun_control_param(control_param, model, blk_control_param)

    % 1) 整个控制参数向量直接写入 Simulink

    in = Simulink.SimulationInput(model);
    in = in.setBlockParameter(blk_control_param, 'Value', mat2str(control_param));
    in = in.setModelParameter('StopTime', '10');

    % 2) 运行仿真
    simOut = sim(in);

    % 3) 读取输出信号
    logs = simOut.logsout;
    aero_ang = logs.get('aero_ang');
    aero_ang_data = reshape_to_n3(aero_ang.Values.Data);
    alpha_data = aero_ang_data(:, 2);
    t = aero_ang.Values.Time;

    % 4) 目标函数

    S = stepinfo(alpha_data, t, 5);
    J_IAE = trapz(t, abs(alpha_data - 5));
    J_IAEref = 1.094496772711917;
    J_int = J_IAE / J_IAEref;
    J_signal = S.Overshoot;
    J_tss = S.SettlingTime;
    J_tp = S.PeakTime;
    J_ess = abs(alpha_data(end) - 5);
    % J = 1 * J_int + 1 * J_signal + 1 * J_tss + 3 * J_tp + 20 * J_ess;
    J = 1 * J_int + 1 * J_signal + 10 * J_tss;

end
