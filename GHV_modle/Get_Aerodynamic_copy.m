%{
/*
* @Author:blueWALL - E
* @Date:2024 - 10 - 12 20:27:01
 * @LastEditTime: 2024-12-27 22:46:14
 * @FilePath: \GHV_open\GHV_modle\Get_Aerodynamic_copy.m
* @Description: 高超声速飞行器气动力分析
* @Wearing:Read only, do not modify place ! !!
* @Shortcut keys:ctrl + alt +/ ctrl + alt + z
*/
%}

%Get_Aerodynamic 计算GHV的气动参数
%input
% LE    单位 度 左舵角度
% RE    单位 度 右舵角度
% RUD   单位 度 方向舵角度
% air_ang 单位 弧度 气流角 alpha beta
% w     单位 rad/s飞行器转动角速度
% v     单位 m/s 飞行器速度标量
% vc    单位 m/s GHV所处高度的声速
% rho   单位 kg/m3 大气密度

%output
% Fair  单位 N 气动力 在速度坐标系中
% Mair  单位 N 气动力矩 在机体坐标系中
% C     单位n.d.气动参数矩阵
function [M, Fair, Mair, Q, C] = Get_Aerodynamic_copy(LE, RE, RUD, air_ang, v, w, vc, rho)
    %//TODO 可能涉及到单位换算问题所有输入输出的数据均为国际标准单位制 或者无量纲单位
    % 内部计算使用了一部分英制单位参与计算，请一定注意单位制之间的不同
    % 气动参数并非特别理想，当飞行器攻角大于12度 小于0度 马赫数大于24时 参数失效
    % 且在马赫数分段点，气动参数并不连续
    Fair = zeros(3, 1);
    Mair = zeros(3, 1); %#ok<*PREALL>
    C = zeros(6, 1);

    % % 需要使用的飞行器自身的参数-标准单位制 米 牛顿
    % b = 18.29; %机翼翼展 单位 m
    % c = 24.38; %平均几何弦长 单位 m
    % s = 334.73; %机翼参考面积 单位 m2
    % x_cg = 4.467; %单位 m 力矩中心到质心的距离

    % 需要使用的飞行器自身的参数-英制单位单位制 英尺 磅
    b = 60; %机翼翼展 单位 ft
    c = 80; %平均几何弦长 单位 ft
    s = 3603; %机翼参考面积 单位 ft^2
    x_cg = 14.6; % 力矩中心到质心的距离 单位 ft

    M = v / vc; %求解飞行器此时马赫数 无量纲单位 不需要换算

    Q = 0.5 * rho * v ^ 2; %飞行器的动压 单位 帕斯卡
    Q_iu = 0.0209 * Q; %飞行器动压 单位 lb/ft^2

    %匹配 AIAA 命名规则
    p = w(1, 1); %单位 rad/s 机体旋转角速度在x轴方向的分量 滚转角速度
    q = w(2, 1); %单位 rad/s 机体旋转角速度在y轴方向的分量 偏航角速度
    r = w(3, 1); %单位 rad/s 机体旋转角速度在z轴方向的分量 俯仰角速度
    alpha = air_ang(1, 1); %读取攻角数据
    beta = air_ang(2, 1); %读取侧滑角数据
    ALPHA = rad2deg(alpha); %转化为角度
    BETA = beta; %保持弧度不变

    %一下数据赖在AIAA 文献 dio 10.2514/6.2007-6626

    if (M <= 1.25)
        CLbv = -5.2491e-004 + ALPHA .* 1.5746e-002 + (ALPHA .* M) .* 6.0213e-03 ...
            -3.4437e-004 * ALPHA .^ 2 + ((ALPHA .* M) .^ 2) .* 1.4471E-04 ...
            -5.1952E-05 * ALPHA .^ 3 +3.4771E-05 * ALPHA .^ 4 ...
            +2.7717E-03 * M ^ 4 -2.3034E-06 * ALPHA .^ 5;
        CL_RE = -5.119E-04 +1.000E-03 * ALPHA -1.406E-04 * (ALPHA * RE) ...
            +1.313E-03 * (ALPHA * M) -8.584E-04 * (M * RE) ...
            +8.879E-05 * (ALPHA * M) * RE -1.604E-04 * M ^ 2 ...
            -3.477E-04 * ALPHA ^ 2 -9.788E-05 * (ALPHA * M) ^ 2 ...
            -1.703E-06 * (M * RE) ^ 2 +2.532E-05 * ALPHA ^ 3 -3.727E-05 * RE ^ 3 ...
            +1.781E-07 * RE ^ 2 +7.912E-07 * ((ALPHA * M) * RE) ^ 2 ...
            +2.465E-08 * (ALPHA * RE) ^ 2 -9.788E-05 * (ALPHA * M) ^ 2 ...
            -5.942E-09 * ((ALPHA * M) * RE) ^ 3 -7.377E-08 * ALPHA ^ 4 ...
            +2.672E-08 * RE ^ 4 -1.610E-11 * ((ALPHA * M) * RE) ^ 4 ...
            -3.273E-08 * ALPHA ^ 5 +7.624E-08 * RE ^ 5 ...
            +1.388E-13 * ((ALPHA * M) * RE) ^ 5;
        CL_LE = -5.119E-04 +1.000E-03 * ALPHA -1.406E-04 * (ALPHA * LE) ...
            +1.313E-03 * (ALPHA * M) -8.584E-04 * (M * LE) ...
            +8.879E-05 * (ALPHA * M) * LE -1.604E-04 * M ^ 2 ...
            -3.477E-04 * ALPHA ^ 2 -9.788E-05 * (ALPHA * M) ^ 2 ...
            -1.703E-06 * (M * LE) ^ 2 +2.532E-05 * ALPHA ^ 3 ...
            -3.727E-05 * LE ^ 3 +1.781E-07 * LE ^ 2 ...
            +7.912E-07 * ((ALPHA * M) * LE) ^ 2 +2.465E-08 * (ALPHA * LE) ^ 2 ...
            -9.788E-05 * (ALPHA * M) ^ 2 -5.942E-09 * ((ALPHA * M) * LE) ^ 3 ...
            -7.377E-08 * ALPHA ^ 4 +2.672E-08 * LE ^ 4 ...
            -1.610E-11 * ((ALPHA * M) * LE) ^ 4 -3.273E-08 * ALPHA ^ 5 ...
            +7.624E-08 * LE ^ 5 +1.388E-13 * ((ALPHA * M) * LE) ^ 5;

        CDbv = +1.1457e-002 + CLbv .* (-2.4645e-002) +M .* (0) ...
            + (CLbv .* M) .* (4.9698e-002) + ((CLbv) .^ 2) .* (-1.9112e+000) ...
            + ((M) .^ 2) .* (0) + ((CLbv .* M) .^ 2) .* (3.5404e+000) ...
            + ((CLbv) .^ 3) .* (4.4334e+001) + ((M) .^ 3) .* (0) ...
            + ((CLbv .* M) .^ 3) .* (-7.0367e+001) ...
            + ((CLbv) .^ 4) .* (-2.3841e+002) + ((M) .^ 4) .* (0) ...
            + ((CLbv .* M) .^ 4) .* (4.1750e+002) + ((CLbv) .^ 5) .* (4.1734e+002) ...
            + ((M) .^ 5) .* (5.4910e-002) ...
            + ((CLbv .* M) .^ 5) .* (-7.9055e+002);
        CD_RE = -5.184e-04 +1.100e-03 * ALPHA +3.38e-07 * (ALPHA * RE) ...
            -1.36e-03 * (ALPHA * M) -2.79e-04 * (M * RE) ...
            -1.53e-04 * (ALPHA * M) * RE +1.29e-03 * (M ^ 2) ...
            -1.02e-04 * (ALPHA ^ 2) +9.39E-08 * RE ^ 2 ...
            -5.69E-07 * ((ALPHA * M) * RE) ^ 2 +4.14E-07 * (ALPHA * RE) ^ 2 ...
            +1.81E-04 * (ALPHA * M) ^ 2 -1.68E-05 * (M * RE) ^ 2 ...
            -1.84E-06 * RE ^ 3 +6.40E-08 * ALPHA ^ 4 +5.76E-08 * RE ^ 4 ...
            +5.71E-09 * RE ^ 5 -8.93E-15 * ((ALPHA * M) * RE) ^ 5 ...
            -7.58E-12 * ((ALPHA * M) * RE) ^ 4 -3.94E-10 * ((ALPHA * M) * RE) ^ 3;
        CD_LE = -5.184E-04 +1.100E-03 * ALPHA +3.38E-07 * (ALPHA * LE) ...
            -1.36E-03 * (ALPHA * M) -2.79E-04 * (M * LE) ...
            -1.53E-04 * (ALPHA * M) * LE +1.29E-03 * M ^ 2 ...
            -1.02E-04 * ALPHA ^ 2 +9.39E-08 * LE ^ 2 ...
            -5.69E-07 * ((ALPHA * M) * LE) ^ 2 +4.14E-07 * (ALPHA * LE) ^ 2 ...
            +1.81E-04 * (ALPHA * M) ^ 2 -1.68E-05 * (M * LE) ^ 2 ...
            -1.84E-06 * LE ^ 3 +6.40E-08 * ALPHA ^ 4 ...
            +5.76E-08 * LE ^ 4 +5.71E-09 * LE ^ 5 -8.93E-15 * ((ALPHA * M) * LE) ^ 5 ...
            -7.58E-12 * ((ALPHA * M) * LE) ^ 4 -3.94E-10 * ((ALPHA * M) * LE) ^ 3;
        CD_RUD = +2.47E-04 -1.93E-04 * ALPHA +7.27E-05 * (ALPHA * M) ...
            +4.73E-05 * M ^ 2 +1.50E-05 * ALPHA ^ 2 +5.03E-06 * RUD ^ 2 ...
            -1.30E-07 * ((ALPHA * M) * RUD) ^ 2 -3.50E-08 * (ALPHA * RUD) ^ 2 ...
            -1.68E-06 * (ALPHA * M) ^ 2 +4.53E-06 * (M * RUD) ^ 2 ...
            -1.98E-11 * ALPHA ^ 3 -2.63E-08 * ALPHA ^ 4 +7.54E-09 * RUD ^ 4 ...
            +3.12E-12 * ((ALPHA * M) * RUD) ^ 4;

        CYB = -4.750E-01 -5.000E-02 * M;
        CY_RE = -1.845E-04 * M -2.13E-07 * (ALPHA * RE) ...
            +3.740E-05 * (ALPHA * M) +1.990E-05 * (M * RE) ...
            +6.17E-08 * (ALPHA * M) * RE +3.39E-06 * ALPHA ^ 2 ...
            +1.37E-07 * RE ^ 2 -2.14E-06 * (ALPHA * M) ^ 2 -1.11E-06 * ALPHA ^ 3 ...
            -3.40E-07 * RE ^ 3 +1.09E-07 * ALPHA ^ 4 ...
            +3.53E-09 * ((ALPHA * M) * RE) ^ 2 -2.66E-09 * (ALPHA * RE) ^ 2 ...
            +3.92E-08 * (M * RE) ^ 2 +5.42E-11 * ((ALPHA * M) * RE) ^ 3 ...
            -4.73E-10 * RE ^ 4 +7.35E-14 * ((ALPHA * M) * RE) ^ 4 ...
            -3.45E-09 * ALPHA ^ 5 +6.53E-10 * RE ^ 5 ...
            -1.11E-15 * ((ALPHA * M) * RE) ^ 5;
        CY_LE =- (-1.845E-04 * M -2.13E-07 * (ALPHA * LE) ...
            +3.740E-05 * (ALPHA * M) +1.990E-05 * (M * LE) ...
            +6.17E-08 * (ALPHA * M) * LE +3.39E-06 * ALPHA ^ 2 ...
            +1.37E-07 * LE ^ 2 -2.14E-06 * (ALPHA * M) ^ 2 -1.11E-06 * ALPHA ^ 3 ...
            -3.40E-07 * LE ^ 3 +1.09E-07 * ALPHA ^ 4 ...
            +3.53E-09 * ((ALPHA * M) * LE) ^ 2 -2.66E-09 * (ALPHA * LE) ^ 2 ...
            +3.92E-08 * (M * LE) ^ 2 +5.42E-11 * ((ALPHA * M) * LE) ^ 3 ...
            -4.73E-10 * LE ^ 4 +7.35E-14 * ((ALPHA * M) * LE) ^ 4 ...
            -3.45E-09 * ALPHA ^ 5 +6.53E-10 * LE ^ 5 ...
            -1.11E-15 * ((ALPHA * M) * LE) ^ 5);
        CY_RUD = +2.440E-03 * RUD;

        Cllbv = -9.380E-02 -1.250E-02 * M;
        Cll_RE = +5.310E-05 -5.272E-04 * ALPHA +3.690E-05 * (ALPHA * RE) ...
            +2.680E-05 * (ALPHA * M) +1.926E-04 * (M * RE) ...
            -8.500E-06 * (ALPHA * M) * RE -4.097E-04 * M ^ 2 ...
            +1.258E-04 * ALPHA ^ 2 +3.762E-06 * RE ^ 2 ...
            -5.302E-08 * ((ALPHA * M) * RE) ^ 2 +5.100E-06 * (ALPHA * M) ^ 2 ...
            +2.100E-06 * (M * RE) ^ 2 -8.700E-06 * ALPHA ^ 3 ...
            +8.400E-06 * RE ^ 3 +1.153E-09 * ((ALPHA * M) * RE) ^ 3 ...
            -3.576E-08 * (ALPHA * RE) ^ 2 +1.384E-08 * ALPHA ^ 4 -1.137E-08 * RE ^ 4 ...
            +1.011E-12 * ((ALPHA * M) * RE) ^ 4 +1.381E-08 * ALPHA ^ 5 ...
            -1.676E-08 * RE ^ 5 -2.984E-14 * ((ALPHA * M) * RE) ^ 5;
        Cll_LE =- (5.310E-05 -5.272E-04 * ALPHA +3.690E-05 * (ALPHA * LE) ...
            +2.680E-05 * (ALPHA * M) +1.926E-04 * (M * LE) ...
            -8.500E-06 * (ALPHA * M) * LE -4.097E-04 * M ^ 2 ...
            +1.258E-04 * ALPHA ^ 2 +3.762E-06 * LE ^ 2 ...
            -5.302E-08 * ((ALPHA * M) * LE) ^ 2 +5.100E-06 * (ALPHA * M) ^ 2 ...
            +2.100E-06 * (M * LE) ^ 2 -8.700E-06 * ALPHA ^ 3 +8.400E-06 * LE ^ 3 ...
            +1.153E-09 * ((ALPHA * M) * LE) ^ 3 -3.576E-08 * (ALPHA * LE) ^ 2 ...
            +1.384E-08 * ALPHA ^ 4 -1.137E-08 * LE ^ 4 ...
            +1.011E-12 * ((ALPHA * M) * LE) ^ 4 +1.381E-08 * ALPHA ^ 5 ...
            -1.676E-08 * LE ^ 5 -2.984E-14 * ((ALPHA * M) * LE) ^ 5);
        Cll_RUD = +7.000000E-04 * RUD;
        Cllr = +2.625000E-01 +2.50E-02 * (M);
        Cllp = -1.337500E-01 -1.250000E-02 * (M);
        Cmbv =+ (-1.8316e-003) + CLbv .* (-1.0306e-001) +M .* (0) ...
            + (CLbv .* M) .* (-1.8335e-001) + ((CLbv) .^ 2) .* (-1.1839e+000) ...
            + ((M) .^ 2) .* (-2.8113e-03) ...
            + ((CLbv .* M) .^ 2) .* (-1.3362e+00) + ((CLbv) .^ 3) .* (9.0641e+00) ...
            + ((M) .^ 3) .* (0) + ((CLbv .* M) .^ 3) .* (2.6964e+001) ...
            + ((CLbv) .^ 4) .* (-6.3590e+01) + ((M) .^ 4) .* (0) ...
            + ((CLbv .* M) .^ 4) .* (-8.0921e+01) ...
            + ((CLbv) .^ 5) .* (1.6885e+02) + ((M) .^ 5) .* (0) ...
            + ((CLbv .* M) .^ 5) .* (-4.2209e+00);

        Cm_RE = +2.880000E-04 -5.351000E-04 * ALPHA +4.550000E-05 * (ALPHA * RE) ...
            +3.379000E-04 * (ALPHA * M) +6.665E-04 * (M * RE) ...
            -2.770E-05 * (ALPHA * M) * RE ...
            -6.027E-04 * M ^ 2 +2.660E-05 * ALPHA ^ 2 -1.600E-06 * RE ^ 2 ...
            -1.000E-07 * ((ALPHA * M) * RE) ^ 2 -1.910E-05 * (ALPHA * M) ^ 2 ...
            +2.300E-06 * (M * RE) ^ 2 +1.300E-05 * ALPHA ^ 3 +1.920E-05 * RE ^ 3 ...
            +1.90E-09 * ((ALPHA * M) * RE) ^ 3 -1.861200E-06 * ALPHA ^ 4 ...
            -4.69E-10 * RE ^ 4 +1.29E-12 * ((ALPHA * M) * RE) ^ 4 ...
            +7.29E-08 * ALPHA ^ 5 -3.87E-08 * RE ^ 5 ...
            -4.67E-14 * ((ALPHA * M) * RE) ^ 5;
        Cm_LE = +2.880000E-04 -5.351000E-04 * ALPHA +4.550000E-05 * (ALPHA * LE) ...
            +3.379000E-04 * (ALPHA * M) +6.665E-04 * (M * LE) ...
            -2.770E-05 * (ALPHA * M) * LE -6.027E-04 * M ^ 2 ...
            +2.660E-05 * ALPHA ^ 2 -1.600E-06 * LE ^ 2 ...
            -1.000E-07 * ((ALPHA * M) * LE) ^ 2 -1.910E-05 * (ALPHA * M) ^ 2 ...
            +2.300E-06 * (M * LE) ^ 2 +1.300E-05 * ALPHA ^ 3 +1.920E-05 * LE ^ 3 ...
            +1.90E-09 * ((ALPHA * M) * LE) ^ 3 -1.861200E-06 * ALPHA ^ 4 ...
            -4.69E-10 * LE ^ 4 +1.29E-12 * ((ALPHA * M) * LE) ^ 4 ...
            +7.29E-08 * ALPHA ^ 5 -3.87E-08 * LE ^ 5 ...
            -4.67E-14 * ((ALPHA * M) * LE) ^ 5;
        Cm_RUD = -1.841E-04 +3.5E-06 * ALPHA +2.762E-04 * M -1.0E-07 * RUD ...
            -4.0E-07 * ALPHA ^ 2 +5.8E-06 * RUD ^ 2 ...
            +6.482E-09 * ((ALPHA * M) * RUD) ^ 2;
        Cm_q =- 1.0313 -3.125000E-01 * M;

        Cnbv = +1.062E-01 +6.250E-02 * M;
        Cn_RE =- 0.00000027 * (ALPHA * RE) -1.008E-05 * (M * RE) ...
            +3.564E-07 * (ALPHA * M) * RE + 0.00000011 * RE ^ 3 +1.11E-07 * RE ^ 3 ...
            -9.32E-12 * ((ALPHA * M) * RE) ^ 3 -1.9910e-021 * ALPHA ^ 4 ...
            +2.89E-25 * RE ^ 4 +1.82E-28 * ((ALPHA * M) * RE) ^ 4 ...
            +6.95E-23 * ALPHA ^ 5 ...
            -2.2046e-010 * RE ^ 5 +2.22E-16 * ((ALPHA * M) * RE) ^ 5;
        Cn_LE =- (- 0.00000027 * (ALPHA * LE) -1.008E-05 * (M * LE) ...
            +3.564E-07 * (ALPHA * M) * LE + 0.00000011 * LE ^ 3 +1.11E-07 * LE ^ 3 ...
            -9.32E-12 * ((ALPHA * M) * LE) ^ 3 -1.9910e-021 * ALPHA ^ 4 ...
            +2.89E-25 * LE ^ 4 +1.82E-28 * ((ALPHA * M) * LE) ^ 4 ...
            +6.95E-23 * ALPHA ^ 5 -2.2046e-010 * LE ^ 5 ...
            +2.22E-16 * ((ALPHA * M) * LE) ^ 5);
        Cn_RUD = -3.000E-03 * RUD;
        Cnp = +1.790E-01 +2.000E-02 * M;
        Cnr =- 1.2787 -1.375e-001 * M;

    elseif (M <= 4.00)
        CLbv = +1.9920e-001 + M * (2.3402e-001) + ALPHA .* (3.8202e-002) ...
            + (ALPHA .* M) .* (-2.4626e-003) + (M .^ 2) .* (-6.4872e-001) ...
            + (ALPHA .^ 2) .* (-6.9523e-003) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (4.5735e-006) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (2.1241e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-1.0521e-004) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (-9.5825e-009) ...
            + (M .^ 3) .* (3.9121e-001) ...
            + (ALPHA .^ 3) .* (1.0295e-003) + (M .^ 4) .* (-9.1356e-002) ...
            + (ALPHA .^ 4) .* (-5.7398e-005) + (M .^ 5) .* (7.4089e-003) ...
            + (ALPHA .^ 5) .* (1.0934e-006);
        CL_RE =+ (0) * 1 + M .* (0) + ALPHA .* (0) + RE .* (0) ...
            + (ALPHA .* RE) .* (-3.3093e-005) + (ALPHA .* M) .* (0) ...
            + (M .* RE) .* (-1.4287e-004) ...
            + ((ALPHA .* M) .* RE) .* (6.1071e-006) ...
            + (M .^ 2) .* (0) + (ALPHA .^ 2) .* (0) + (RE .^ 2) .* (2.7242e-004) ...
            + (((ALPHA .* M) .* RE) .^ 2) .* (-9.1890e-008) ...
            + ((ALPHA .* RE) .^ 2) .* (3.4060e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-6.5093e-006) ...
            + ((M .* RE) .^ 2) .* (-6.3863e-006) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (1.4092e-004) ...
            + (RE .^ 3) .* (3.8067e-006) ...
            + (((ALPHA .* M) .* RE) .^ 3) .* (2.3165e-011) ...
            + (M .^ 4) .* (-1.0680e-003) ...
            + (ALPHA .^ 4) .* (-2.1893e-005) + (RE .^ 4) .* (-3.7716e-007) ...
            + (((ALPHA .* M) .* RE) .^ 4) .* (7.9006e-014) ...
            + (M .^ 5) .* (2.6056e-004) ...
            + (ALPHA .^ 5) .* (9.2099e-007) + (RE .^ 5) .* (-8.5345e-009) ...
            + (((ALPHA .* M) .* RE) .^ 5) .* (-2.5698e-017);
        CL_LE =+ (0) * 1 + M .* (0) + ALPHA .* (0) + LE .* (0) ...
            + (ALPHA .* LE) .* (-3.3093e-005) + (ALPHA .* M) .* (0) ...
            + (M .* LE) .* (-1.4287e-004) ...
            + ((ALPHA .* M) .* LE) .* (6.1071e-006) ...
            + (M .^ 2) .* (0) + (ALPHA .^ 2) .* (0) + (LE .^ 2) .* (2.7242e-004) ...
            + (((ALPHA .* M) .* LE) .^ 2) .* (-9.1890e-008) ...
            + ((ALPHA .* LE) .^ 2) .* (3.4060e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-6.5093e-006) ...
            + ((M .* LE) .^ 2) .* (-6.3863e-006) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (1.4092e-004) ...
            + (LE .^ 3) .* (3.8067e-006) ...
            + (((ALPHA .* M) .* LE) .^ 3) .* (2.3165e-011) ...
            + (M .^ 4) .* (-1.0680e-003) ...
            + (ALPHA .^ 4) .* (-2.1893e-005) + (LE .^ 4) .* (-3.7716e-007) ...
            + (((ALPHA .* M) .* LE) .^ 4) .* (7.9006e-014) ...
            + (M .^ 5) .* (2.6056e-004) ...
            + (ALPHA .^ 5) .* (9.2099e-007) + (LE .^ 5) .* (-8.5345e-009) ...
            + (((ALPHA .* M) .* LE) .^ 5) .* (-2.5698e-017);

        CDbv =+ (-8.2073e-002) + CLbv .* (-9.1273e-002) ...
            + M .* (2.1845e-001) ...
            + (CLbv .* M) .* (3.2202e-002) + ((CLbv) .^ 2) .* (1.6325e+000) ...
            + ((M) .^ 2) .* (-1.3680e-001) ...
            + ((CLbv .* M) .^ 2) .* (5.7526e-002) ...
            + ((CLbv) .^ 3) .* (-1.1575e+000) + ((M) .^ 3) .* (3.8791e-002) ...
            + ((CLbv .* M) .^ 3) .* (-2.4002e-001) ...
            + ((CLbv) .^ 4) .* (-8.5306e+000) ...
            + ((M) .^ 4) .* (-5.2527e-003) ...
            + ((CLbv .* M) .^ 4) .* (3.5543e-001) ...
            + ((CLbv) .^ 5) .* (1.7259e+001) + ((M) .^ 5) .* (2.7435e-004) ...
            + ((CLbv .* M) .^ 5) .* (-1.4983e-001);
        CD_RE =+ (0) * 1 + M .* (0) + ALPHA .* (0) + RE .* (0) ...
            + (ALPHA .* RE) .* (-3.6923e-005) + (ALPHA .* M) .* (1.5100e-005) ...
            + (M .* RE) .* (1.3641e-007) ...
            + ((ALPHA .* M) .* RE) .* (5.1142e-006) ...
            + (M .^ 2) .* (0) + (ALPHA .^ 2) .* (0) + (RE .^ 2) .* (1.2125e-005) ...
            + (((ALPHA .* M) .* RE) .^ 2) .* (3.5662e-009) ...
            + ((ALPHA .* RE) .^ 2) .* (-1.3848e-008) ...
            + ((ALPHA .* M) .^ 2) .* (-4.7972e-007) ...
            + ((M .* RE) .^ 2) .* (-3.3763e-007) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-4.6045e-008) ...
            + (RE .^ 3) .* (3.9119e-008) ...
            + (((ALPHA .* M) .* RE) .^ 3) .* (-9.7714e-013) ...
            + (M .^ 4) .* (9.6475e-007) ...
            + (ALPHA .^ 4) .* (1.5015e-008) + (RE .^ 4) .* (4.5137e-009) ...
            + (((ALPHA .* M) .* RE) .^ 4) .* (-6.6207e-016) ...
            + (M .^ 5) .* (-3.2682e-007) ...
            + (ALPHA .^ 5) .* (-3.5360e-010) + (RE .^ 5) .* (-1.1538e-010) ...
            + (((ALPHA .* M) .* RE) .^ 5) .* (4.1917e-019);
        CD_LE =+ (0) * 1 + M .* (0) + ALPHA .* (0) + LE .* (0) ...
            + (ALPHA .* LE) .* (-3.6923e-005) + (ALPHA .* M) .* (1.5100e-005) ...
            + (M .* LE) .* (1.3641e-007) ...
            + ((ALPHA .* M) .* LE) .* (5.1142e-006) ...
            + (M .^ 2) .* (0) + (ALPHA .^ 2) .* (0) + (LE .^ 2) .* (1.2125e-005) ...
            + (((ALPHA .* M) .* LE) .^ 2) .* (3.5662e-009) ...
            + ((ALPHA .* LE) .^ 2) .* (-1.3848e-008) ...
            + ((ALPHA .* M) .^ 2) .* (-4.7972e-007) ...
            + ((M .* LE) .^ 2) .* (-3.3763e-007) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-4.6045e-008) ...
            + (LE .^ 3) .* (3.9119e-008) ...
            + (((ALPHA .* M) .* LE) .^ 3) .* (-9.7714e-013) ...
            + (M .^ 4) .* (9.6475e-007) ...
            + (ALPHA .^ 4) .* (1.5015e-008) + (LE .^ 4) .* (4.5137e-009) ...
            + (((ALPHA .* M) .* LE) .^ 4) .* (-6.6207e-016) ...
            + (M .^ 5) .* (-3.2682e-007) ...
            + (ALPHA .^ 5) .* (-3.5360e-010) + (LE .^ 5) .* (-1.1538e-010) ...
            + (((ALPHA .* M) .* LE) .^ 5) .* (4.1917e-019);
        CD_RUD =+ (0) * 1 + M .* (0) + ALPHA .* (0) + RUD .* (0) ...
            + (ALPHA .* RUD) .* (2.6425e-021) ...
            + (ALPHA .* M) .* (-9.8380e-006) ...
            + (M .* RUD) .* (1.8193e-020) ...
            + ((ALPHA .* M) .* RUD) .* (1.0319e-021) ...
            + (M .^ 2) .* (0) + (ALPHA .^ 2) .* (0) + (RUD .^ 2) .* (8.7608e-006) ...
            + (((ALPHA .* M) .* RUD) .^ 2) .* (5.4045e-010) ...
            + ((ALPHA .* RUD) .^ 2) .* (-2.8939e-008) ...
            + ((ALPHA .* M) .^ 2) .* (2.1842e-007) ...
            + ((M .* RUD) .^ 2) .* (-2.9646e-007) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-9.0067e-007) ...
            + (RUD .^ 3) .* (-8.8556e-022) ...
            + (((ALPHA .* M) .* RUD) .^ 3) .* (-5.2022e-027) ...
            + (M .^ 4) .* (1.3388e-006) + (ALPHA .^ 4) .* (1.6460e-007) ...
            + (RUD .^ 4) .* (4.6754e-010) ...
            + (((ALPHA .* M) .* RUD) .^ 4) .* (2.6560e-016) ...
            + (M .^ 5) .* (-2.5185e-007) ...
            + (ALPHA .^ 5) .* (-7.2766e-009) + (RUD .^ 5) .* (1.5611e-024) ...
            + (((ALPHA .* M) .* RUD) .^ 5) .* (5.4442e-033);

        CYB =+ (0) + M * (0) + ALPHA .* (-1.1185e-002) ...
            + (ALPHA .* M) .* (3.0432e-003) + (M .^ 2) .* (-3.7586e-001) ...
            + (ALPHA .^ 2) .* (3.4004e-003) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-2.4047e-006) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (3.6104e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-8.7176e-005) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (-5.3622e-010) + (M .^ 3) .* (0) ...
            + (ALPHA .^ 3) .* (-5.8160e-004) + (M .^ 4) .* (9.4289e-002) ...
            + (ALPHA .^ 4) .* (4.4848e-005) + (M .^ 5) .* (-1.8384e-002) ...
            + (ALPHA .^ 5) .* (-1.3021e-006);
        CY_RE = -1.02E-06 -1.12E-07 * ALPHA +4.48E-07 * M +2.27E-07 * RE ...
            +4.11E-09 * (ALPHA * M) * RE +2.82E-09 * ALPHA ^ 2 ...
            -2.36E-08 * M ^ 2 -5.04E-08 * RE ^ 2 ...
            +4.50E-14 * ((ALPHA * M) * RE) ^ 2;
        CY_LE =- (-1.02E-06 -1.12E-07 * ALPHA +4.48E-07 * M +2.27E-07 * LE ...
            +4.11E-09 * (ALPHA * M) * LE +2.82E-09 * ALPHA ^ 2 ...
            -2.36E-08 * M ^ 2 -5.04E-08 * LE ^ 2 ...
            +4.50E-14 * ((ALPHA * M) * LE) ^ 2);
        CY_RUD =+ (0) * 1 + M .* (0) + ALPHA .* (0) + RUD .* (0) ...
            + (ALPHA .* RUD) .* (2.0067e-005) ...
            + (ALPHA .* M) .* (0) + (M .* RUD) .* (-5.7185e-004) ...
            + ((ALPHA .* M) .* RUD) .* (-1.5307e-005) + (M .^ 2) .* (0) ...
            + (ALPHA .^ 2) .* (0) + (RUD .^ 2) .* (1.9243e-019) ...
            + (((ALPHA .* M) .* RUD) .^ 2) .* (2.8011e-022) ...
            + ((ALPHA .* RUD) .^ 2) .* (-2.0404e-021) ...
            + ((ALPHA .* M) .^ 2) .* (-1.2673e-020) ...
            + ((M .* RUD) .^ 2) .* (-1.7950e-020) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-9.9873e-019) ...
            + (RUD .^ 3) .* (3.2768e-005) ...
            + (((ALPHA .* M) .* RUD) .^ 3) .* (1.2674e-012) ...
            + (M .^ 4) .* (-3.8438e-020) ...
            + (ALPHA .^ 4) .* (1.9239e-019) + (RUD .^ 4) .* (7.7275e-023) ...
            + (((ALPHA .* M) .* RUD) .^ 4) .* (-3.2592e-029) ...
            + (M .^ 5) .* (3.1048e-020) ...
            + (ALPHA .^ 5) .* (-9.0794e-021) + (RUD .^ 5) .* (-6.5825e-008) ...
            + (((ALPHA .* M) .* RUD) .^ 5) .* (1.2684e-017);

        Cllbv =+ (0) + M * (0) + ALPHA .* (5.9211e-004) ...
            + (ALPHA .* M) .* (-3.1579e-004) + (M .^ 2) .* (-8.7296e-002) ...
            + (ALPHA .^ 2) .* (-5.7398e-005) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-1.1037e-006) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (-6.8068e-008) ...
            + ((ALPHA .* M) .^ 2) .* (2.0549e-005) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (3.6561e-009) + (M .^ 3) .* (0) ...
            + (ALPHA .^ 3) .* (-2.8226e-016) + (M .^ 4) .* (2.0334e-002) ...
            + (ALPHA .^ 4) .* (1.9013e-007) + (M .^ 5) .* (-3.7733e-003) ...
            + (ALPHA .^ 5) .* (-9.6648e-019);

        Cll_RE = +3.570E-04 -9.569E-05 * ALPHA -3.598E-05 * M +1.170E-04 * RE ...
            +2.794E-08 * (ALPHA * M) * RE +4.950E-06 * ALPHA ^ 2 ...
            +1.411E-06 * M ^ 2 ...
            -1.160E-06 * RE ^ 2 -4.641E-11 * ((ALPHA * M) * RE) ^ 2;
        Cll_LE =- (3.570E-04 -9.569E-05 * ALPHA -3.598E-05 * M +1.170E-04 * LE ...
            +2.794E-08 * (ALPHA * M) * LE +4.950E-06 * ALPHA ^ 2 ...
            +1.411E-06 * M ^ 2 -1.160E-06 * LE ^ 2 ...
            -4.641E-11 * ((ALPHA * M) * LE) ^ 2);
        Cll_RUD = -5.0103E-19 +6.2723E-20 * ALPHA +2.3418E-20 * M ...
            + 0.00011441 * RUD -2.6824E-06 * (ALPHA * RUD) ...
            -3.4201E-21 * (ALPHA * M) -3.5496E-06 * (M * RUD) ...
            +5.5547E-08 * (ALPHA * M) * RUD;
        Cllr = +3.82E-01 -1.06E-01 * M ...
            +1.94E-03 * ALPHA -8.15E-05 * (ALPHA * M) ...
            +1.45E-02 * M ^ 2 -9.76E-06 * ALPHA ^ 2 ...
            +4.49E-08 * (ALPHA * M) ^ 2 ...
            -1.02E-03 * M ^ 3 -2.70E-07 * ALPHA ^ 3 +3.56E-05 * M ^ 4 ...
            +3.19E-08 * ALPHA ^ 4 ...
            -4.81E-07 * M ^ 5 -1.06E-09 * ALPHA ^ 5;
        Cllp =+ (0) + M * (0) + ALPHA .* (-1.2668e-005) ...
            + (ALPHA .* M) .* (1.7282e-005) + (M .^ 2) .* (-1.0966e-001) ...
            + (ALPHA .^ 2) .* (1.0751e-005) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-1.0989e-006) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (6.1850e-009) ...
            + ((ALPHA .* M) .^ 2) .* (8.6481e-006) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (-4.3707e-010) ...
            + (M .^ 3) .* (0) ...
            + (ALPHA .^ 3) .* (-1.1567e-005) + (M .^ 4) .* (2.6725e-002) ...
            + (ALPHA .^ 4) .* (1.5082e-006) + (M .^ 5) .* (-5.0800e-003) ...
            + (ALPHA .^ 5) .* (-6.1276e-008);

        Cmbv =+ (-5.7643e-001) + M * (1.0553e+000) + CLbv .* (-3.7951e-001) ...
            + (CLbv .* M) .* (1.0483e-001) + (M .^ 2) .* (-7.4344e-001) ...
            + (CLbv .^ 2) .* (-1.5412e-001) ...
            + ((CLbv .* M .^ 2) .^ 2) .* (-2.1133e-003) ...
            + (((CLbv .^ 2) .* M) .^ 2) .* (-1.7858e-001) ...
            + ((CLbv .* M) .^ 2) .* (5.7805e-002) ...
            + (((CLbv .^ 2) .* M .^ 2) .^ 2) .* (-3.8875e-003) ...
            + (M .^ 3) .* (2.5341e-001) ...
            + (CLbv .^ 3) .* (-4.9731e-001) + (M .^ 4) .* (-4.1938e-002) ...
            + (CLbv .^ 4) .* (7.1784e+000) + (M .^ 5) .* (2.7017e-003) ...
            + (CLbv .^ 5) .* (-1.0331e+001);
        Cm_RE = -5.67E-05 -6.59E-05 * ALPHA -1.51E-06 * M +2.89E-04 * RE ...
            +4.48E-06 * (ALPHA * RE) -4.46E-06 * (ALPHA * M) ...
            -5.87E-06 * (M * RE) +9.72E-08 * (ALPHA * M) * RE;
        Cm_LE = -5.67E-05 -6.59E-05 * ALPHA -1.51E-06 * M +2.89E-04 * LE ...
            +4.48E-06 * (ALPHA * LE) -4.46E-06 * (ALPHA * M) ...
            -5.87E-06 * (M * LE) +9.72E-08 * (ALPHA * M) * LE;
        Cm_RUD = -2.79E-05 * ALPHA -5.89E-08 * (ALPHA) ^ 2 +1.58E-03 * (M) ^ 2 ...
            +6.42E-08 * (ALPHA) ^ 3 -6.69E-04 * (M) ^ 3 -2.10E-08 * (ALPHA) ^ 4 ...
            +1.05E-04 * (M) ^ 4 +1.43E-07 * (RUD) ^ 4 +3.14E-09 * (ALPHA) ^ 5 ...
            -7.74E-06 * (M) ^ 5 -4.77E-22 * (RUD) ^ 5 -2.18E-10 * (ALPHA) ^ 6 ...
            +2.70E-07 * (M) ^ 6 -3.38E-10 * (RUD) ^ 6 +5.74E-12 * (ALPHA) ^ 7 ...
            -3.58E-09 * (M) ^ 7 +2.63E-24 * (RUD) ^ 7;
        Cm_q =+ (0) + M * (0) + ALPHA .* (-1.0828e-002) ...
            + (ALPHA .* M) .* (4.2311e-003) ...
            + (M .^ 2) .* (-6.1171e-001) ...
            + (ALPHA .^ 2) .* (4.6974e-003) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-1.1593e-005) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (2.5378e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-7.0964e-005) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (4.1284e-008) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-1.1414e-003) ...
            + (M .^ 4) .* (1.5903e-001) ...
            + (ALPHA .^ 4) .* (1.1176e-004) + (M .^ 5) .* (-3.0665e-002) ...
            + (ALPHA .^ 5) .* (-3.8123e-006);

        Cnbv =+ (0) + M * (0) + ALPHA .* (-2.3745e-003) ...
            + (ALPHA .* M) .* (8.5307e-004) ...
            + (M .^ 2) .* (1.4474e-001) ...
            + (ALPHA .^ 2) .* (5.3105e-004) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-8.3462e-007) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (1.3335e-007) ...
            + ((ALPHA .* M) .^ 2) .* (-2.7081e-005) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (-1.3450e-009) ...
            + (M .^ 3) .* (0) + (ALPHA .^ 3) .* (-4.1046e-005) ...
            + (M .^ 4) .* (-3.9519e-002) + (ALPHA .^ 4) .* (-1.5141e-006) ...
            + (M .^ 5) .* (7.7646e-003) + (ALPHA .^ 5) .* (1.7278e-007);
        Cn_RE = +2.10E-04 +1.83E-05 * ALPHA -3.56E-05 * M -1.30E-05 * RE ...
            -8.93E-08 * (ALPHA * M) * RE -6.39E-07 * ALPHA ^ 2 ...
            +8.16E-07 * M ^ 2 +1.97E-06 * RE ^ 2 ...
            +1.41E-11 * ((ALPHA * M) * RE) ^ 2;
        Cn_LE =- (2.10E-04 +1.83E-05 * ALPHA -3.56E-05 * M -1.30E-05 * LE ...
            -8.93E-08 * (ALPHA * M) * LE -6.39E-07 * ALPHA ^ 2 ...
            +8.16E-07 * M ^ 2 +1.97E-06 * LE ^ 2 ...
            +1.41E-11 * ((ALPHA * M) * LE) ^ 2);
        Cn_RUD = +2.85E-18 -3.59E-19 * ALPHA -1.26E-19 * M -5.28E-04 * RUD ...
            +1.39E-05 * (ALPHA * RUD) +1.57E-20 * (ALPHA * M) ...
            +1.65E-05 * (M * RUD) -3.13E-07 * (ALPHA * M) * RUD;
        Cnp =+ (1.7000e-001) + ALPHA .* (-6.4056e-018) ...
            + M .* (1.1333e-002) + (ALPHA .* M) .* (2.3467e-018) ...
            + ((ALPHA) .^ 2) .* (2.0917e-019) ...
            + ((M) .^ 2) .* (-5.3333e-003) ...
            + ((ALPHA .* M) .^ 2) .* (-5.0665e-020);
        Cnr =+ (0) + M * (0) + ALPHA .* (-1.3332e-003) ...
            + (ALPHA .* M) .* (6.6899e-004) ...
            + (M .^ 2) .* (-1.0842e+000) ...
            + (ALPHA .^ 2) .* (1.6434e-003) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-4.4258e-006) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (1.2017e-007) ...
            + ((ALPHA .* M) .^ 2) .* (1.0819e-005) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (-2.8899e-009) + (M .^ 3) .* (0) ...
            + (ALPHA .^ 3) .* (-5.8118e-004) + (M .^ 4) .* (2.7379e-001) ...
            + (ALPHA .^ 4) .* (6.7994e-005) + (M .^ 5) .* (-5.2435e-002) ...
            + (ALPHA .^ 5) .* (-2.5848e-006);
    else %M>=4
        CLbv = -8.19E-02 +4.70E-02 * M +1.86E-02 * ALPHA ...
            -4.73E-04 * (ALPHA * M) -9.19E-03 * M ^ 2 -1.52E-04 * ALPHA ^ 2 ...
            +5.99E-07 * (ALPHA * M) ^ 2 +7.74E-04 * M ^ 3 ...
            +4.08E-06 * ALPHA ^ 3 -2.93E-05 * M ^ 4 -3.91E-07 * ALPHA ^ 4 ...
            +4.12E-07 * M ^ 5 +1.30E-08 * ALPHA ^ 5;
        CL_RE = -1.45E-05 +1.01E-04 * ALPHA +7.10E-06 * M -4.14E-04 * RE ...
            -3.51E-06 * (ALPHA * RE) +4.70E-06 * (ALPHA * M) ...
            +8.72E-06 * (M * RE) -1.70E-07 * (ALPHA * M) * RE;
        CL_LE = -1.45E-05 +1.01E-04 * ALPHA +7.10E-06 * M -4.14E-04 * LE ...
            -3.51E-06 * (ALPHA * LE) +4.70E-06 * (ALPHA * M) ...
            +8.72E-06 * (M * LE) -1.70E-07 * (ALPHA * M) * LE;

        CDbv = +8.717E-02 -3.307E-02 * M +3.179E-03 * ALPHA ...
            -1.250E-04 * (ALPHA * M) +5.036E-03 * M ^ 2 ...
            -1.100E-03 * ALPHA ^ 2 +1.405E-07 * (ALPHA * M) ^ 2 ...
            -3.658E-04 * M ^ 3 +3.175E-04 * ALPHA ^ 3 +1.274E-05 * M ^ 4 ...
            -2.985E-05 * ALPHA ^ 4 -1.705E-07 * M ^ 5 +9.766E-07 * ALPHA ^ 5;
        CD_RE =+ 1 * (4.5548e-004) + ALPHA .* (2.5411e-005) + M .* (-1.1436e-004) ...
            + RE .* (-3.6417e-005) + ((ALPHA .* M) .* RE) .* (-5.3015e-007) ...
            + (ALPHA .^ 2) .* (3.2187e-006) + (M .^ 2) .* (3.0140e-006) ...
            + (RE .^ 2) .* (6.9629e-006) ...
            + (((ALPHA .* M) .* RE) .^ 2) .* (2.1026e-012);
        CD_LE =+ 1 * (4.5548e-004) + ALPHA .* (2.5411e-005) + M .* (-1.1436e-004) ...
            + LE .* (-3.6417e-005) + ((ALPHA .* M) .* LE) .* (-5.3015e-007) ...
            + (ALPHA .^ 2) .* (3.2187e-006) + (M .^ 2) .* (3.0140e-006) ...
            + (LE .^ 2) .* (6.9629e-006) ...
            + (((ALPHA .* M) .* LE) .^ 2) .* (2.1026e-012);
        CD_RUD = +7.50E-04 -2.29E-05 * ALPHA -9.69E-05 * M -1.83E-06 * RUD ...
            +9.13E-09 * (ALPHA * M) * RUD +8.76E-07 * ALPHA ^ 2 ...
            +2.70E-06 * M ^ 2 +1.97E-06 * RUD ^ 2 ...
            -1.77E-11 * ((ALPHA * M) * RUD) ^ 2;

        CYB =+ (0) + M * (-2.9253e-001) + ALPHA .* (2.8803e-003) ...
            + (ALPHA .* M) .* (-2.8943e-004) + (M .^ 2) .* (5.4822e-002) ...
            + (ALPHA .^ 2) .* (7.3535e-004) ...
            + ((ALPHA .* M .^ 2) .^ 2) .* (-4.6490e-009) ...
            + (((ALPHA .^ 2) .* M) .^ 2) .* (-2.0675e-008) ...
            + ((ALPHA .* M) .^ 2) .* (4.6205e-006) ...
            + (((ALPHA .^ 2) .* M .^ 2) .^ 2) .* (2.6144e-011) ...
            + (M .^ 3) .* (-4.3203e-003) ...
            + (ALPHA .^ 3) .* (-3.7405e-004) + (M .^ 4) .* (1.5495e-004) ...
            + (ALPHA .^ 4) .* (2.8183e-005) + (M .^ 5) .* (-2.0829e-006) ...
            + (ALPHA .^ 5) .* (-5.2083e-007);
        CY_RE = -1.02E-06 -1.12E-07 * ALPHA +4.48E-07 * M +2.27E-07 * RE ...
            +4.11E-09 * (ALPHA * M) * RE +2.82E-09 * ALPHA ^ 2 ...
            -2.36E-08 * M ^ 2 -5.04E-08 * RE ^ 2 ...
            +4.50E-14 * ((ALPHA * M) * RE) ^ 2;
        CY_LE =- (-1.02E-06 -1.12E-07 * ALPHA +4.48E-07 * M +2.27E-07 * LE ...
            +4.11E-09 * (ALPHA * M) * LE +2.82E-09 * ALPHA ^ 2 ...
            -2.36E-08 * M ^ 2 ...
            -5.04E-08 * LE ^ 2 +4.50E-14 * ((ALPHA * M) * LE) ^ 2);
        CY_RUD = -1.43E-18 +4.86E-20 * ALPHA +1.86E-19 * M +3.84E-04 * RUD ...
            -1.17E-05 * (ALPHA * RUD) -1.07E-05 * (M * RUD) ...
            +2.60E-07 * (ALPHA * M) * RUD;

        Cllbv = -1.402E-01 +3.326E-02 * M -7.590E-04 * ALPHA ...
            +8.596E-06 * (ALPHA * M) -3.794E-03 * M ^ 2 ...
            +2.354E-06 * ALPHA ^ 2 -1.044E-08 * (ALPHA * M) ^ 2 ...
            +2.219E-04 * M ^ 3 -8.964E-18 * ALPHA ^ 3 -6.462E-06 * M ^ 4 ...
            +3.803E-19 * ALPHA ^ 4 +7.419E-08 * M ^ 5 -3.353E-21 * ALPHA ^ 5;
        Cll_RE = +3.570E-04 -9.569E-05 * ALPHA -3.598E-05 * M +1.170E-04 * RE ...
            +2.794E-08 * (ALPHA * M) * RE +4.950E-06 * ALPHA ^ 2 ...
            +1.411E-06 * M ^ 2 -1.160E-06 * RE ^ 2 ...
            -4.641E-11 * ((ALPHA * M) * RE) ^ 2;
        Cll_LE =- (3.570E-04 -9.569E-05 * ALPHA -3.598E-05 * M +1.170E-04 * LE ...
            +2.794E-08 * (ALPHA * M) * LE +4.950E-06 * ALPHA ^ 2 ...
            +1.411E-06 * M ^ 2 -1.160E-06 * LE ^ 2 ...
            -4.641E-11 * ((ALPHA * M) * LE) ^ 2);
        Cll_RUD = -5.0103E-19 +6.2723E-20 * ALPHA +2.3418E-20 * M ...
            + 0.00011441 * RUD -2.6824E-06 * (ALPHA * RUD) ...
            -3.4201E-21 * (ALPHA * M) -3.5496E-06 * (M * RUD) ...
            +5.5547E-08 * (ALPHA * M) * RUD;
        Cllr = +3.82E-01 -1.06E-01 * M +1.94E-03 * ALPHA ...
            -8.15E-05 * (ALPHA * M) +1.45E-02 * M ^ 2 -9.76E-06 * ALPHA ^ 2 ...
            +4.49E-08 * (ALPHA * M) ^ 2 -1.02E-03 * M ^ 3 ...
            -2.70E-07 * ALPHA ^ 3 +3.56E-05 * M ^ 4 +3.19E-08 * ALPHA ^ 4 ...
            -4.81E-07 * M ^ 5 -1.06E-09 * ALPHA ^ 5;
        Cllp = -2.99E-01 +7.47E-02 * M +1.38E-03 * ALPHA ...
            -8.78E-05 * (ALPHA * M) -9.13E-03 * M ^ 2 -2.04E-04 * ALPHA ^ 2 ...
            -1.52E-07 * (ALPHA * M) ^ 2 +5.73E-04 * M ^ 3 ...
            -3.86E-05 * ALPHA ^ 3 -1.79E-05 * M ^ 4 +4.21E-06 * ALPHA ^ 4 ...
            +2.20E-07 * M ^ 5 -1.15E-07 * ALPHA ^ 5;

        Cmbv = -2.192E-02 +7.739E-03 * M -2.260E-03 * ALPHA ...
            +1.808E-04 * (ALPHA * M) -8.849E-04 * M ^ 2 ...
            +2.616E-04 * ALPHA ^ 2 -2.880E-07 * (ALPHA * M) ^ 2 ...
            +4.617E-05 * M ^ 3 -7.887E-05 * ALPHA ^ 3 -1.143E-06 * M ^ 4 ...
            +8.288E-06 * ALPHA ^ 4 +1.082E-08 * M ^ 5 -2.789E-07 * ALPHA ^ 5;
        Cm_RE = -5.67E-05 -6.59E-05 * ALPHA -1.51E-06 * M +2.89E-04 * RE ...
            +4.48E-06 * (ALPHA * RE) -4.46E-06 * (ALPHA * M) ...
            -5.87E-06 * (M * RE) ...
            +9.72E-08 * (ALPHA * M) * RE;
        Cm_LE = -5.67E-05 -6.59E-05 * ALPHA -1.51E-06 * M +2.89E-04 * LE ...
            +4.48E-06 * (ALPHA * LE) -4.46E-06 * (ALPHA * M) ...
            -5.87E-06 * (M * LE) ...
            +9.72E-08 * (ALPHA * M) * LE;
        Cm_RUD = -2.79E-05 * ALPHA -5.89E-08 * (ALPHA) ^ 2 +1.58E-03 * (M) ^ 2 ...
            +6.42E-08 * (ALPHA) ^ 3 -6.69E-04 * (M) ^ 3 -2.10E-08 * (ALPHA) ^ 4 ...
            +1.05E-04 * (M) ^ 4 +1.43E-07 * (RUD) ^ 4 +3.14E-09 * (ALPHA) ^ 5 ...
            -7.74E-06 * (M) ^ 5 -4.77E-22 * (RUD) ^ 5 -2.18E-10 * (ALPHA) ^ 6 ...
            +2.70E-07 * (M) ^ 6 -3.38E-10 * (RUD) ^ 6 +5.74E-12 * (ALPHA) ^ 7 ...
            -3.58E-09 * (M) ^ 7 +2.63E-24 * (RUD) ^ 7;
        Cm_q = -1.36E+00 +3.86E-01 * M +7.85E-04 * ALPHA ...
            +1.40E-04 * (ALPHA * M) -5.42E-02 * M ^ 2 ...
            +2.36E-03 * ALPHA ^ 2 -1.95E-06 * (ALPHA * M) ^ 2 ...
            +3.80E-03 * M ^ 3 -1.48E-03 * ALPHA ^ 3 -1.30E-04 * M ^ 4 ...
            +1.69E-04 * ALPHA ^ 4 +1.71E-06 * M ^ 5 -5.93E-06 * ALPHA ^ 5;

        Cnbv =+ (0) + ALPHA .* (6.9980e-004) +M .* (5.9115e-002) ...
            + (ALPHA .* M) .* (-7.5250e-005) + ((ALPHA) .^ 2) .* (2.5160e-004) ...
            + ((M) .^ 2) .* (-1.4824e-002) ...
            + ((ALPHA .* M) .^ 2) .* (-2.1924e-007) ...
            + ((ALPHA) .^ 3) .* (-1.0777e-004) + ((M) .^ 3) .* (1.2692e-003) ...
            + ((ALPHA .* M) .^ 3) .* (1.0707e-008) ...
            + ((ALPHA) .^ 4) .* (9.4989e-006) + ((M) .^ 4) .* (-4.7098e-005) ...
            + ((ALPHA .* M) .^ 4) .* (-5.5472e-011) ...
            + ((ALPHA) .^ 5) .* (-2.5953e-007) + ((M) .^ 5) .* (6.4284e-007) ...
            + ((ALPHA .* M) .^ 5) .* (8.5863e-014);
        Cn_RE = +2.10E-04 +1.83E-05 * ALPHA -3.56E-05 * M -1.30E-05 * RE ...
            -8.93E-08 * (ALPHA * M) * RE -6.39E-07 * ALPHA ^ 2 +8.16E-07 * M ^ 2 ...
            +1.97E-06 * RE ^ 2 +1.41E-11 * ((ALPHA * M) * RE) ^ 2;
        Cn_LE =- (2.10E-04 +1.83E-05 * ALPHA -3.56E-05 * M -1.30E-05 * LE ...
            -8.93E-08 * (ALPHA * M) * LE -6.39E-07 * ALPHA ^ 2 +8.16E-07 * M ^ 2 ...
            +1.97E-06 * LE ^ 2 +1.41E-11 * ((ALPHA * M) * LE) ^ 2);
        Cn_RUD = +2.85E-18 -3.59E-19 * ALPHA -1.26E-19 * M -5.28E-04 * RUD ...
            +1.39E-05 * (ALPHA * RUD) +1.57E-20 * (ALPHA * M) ...
            +1.65E-05 * (M * RUD) ...
            -3.13E-07 * (ALPHA * M) * RUD;
        Cnp = +3.68E-01 -9.79E-02 * M +7.61E-16 * ALPHA +1.24E-02 * M ^ 2 ...
            -4.64E-16 * ALPHA ^ 2 -8.05E-04 * M ^ 3 +1.01E-16 * ALPHA ^ 3 ...
            +2.57E-05 * M ^ 4 ...
            -9.18E-18 * ALPHA ^ 4 -3.20E-07 * M ^ 5 +2.96E-19 * ALPHA ^ 5;
        Cnr = -2.41E+00 +5.96E-01 * M -2.74E-03 * ALPHA ...
            +2.09E-04 * (ALPHA * M) -7.57E-02 * M ^ 2 ...
            +1.15E-03 * ALPHA ^ 2 -6.53E-08 * (ALPHA * M) ^ 2 ...
            +4.90E-03 * M ^ 3 -3.87E-04 * ALPHA ^ 3 -1.57E-04 * M ^ 4 ...
            +3.60E-05 * ALPHA ^ 4 +1.96E-06 * M ^ 5 -1.18E-06 * ALPHA ^ 5;
    end

    CL = CLbv + CL_RE + CL_LE; %CL     单位 n.d. 升力系数
    CD = CDbv + CD_RE + CD_LE + CD_RUD; %CD     单位 n.d. 阻力系数
    CY = CYB * BETA + CY_RE + CY_LE + CY_RUD; %CY     单位 n.d. 侧向力系数

    Cl = Cllbv * BETA + Cll_RE + Cll_LE + Cll_RUD ...
        + Cllr * ((r * b) / (2 * v)) + Cllp * ((p * b) / (2 * v)); %Cl     单位 n.d. 滚转通道的气动力矩系数
    Cm = Cmbv + Cm_RE + Cm_LE + Cm_RUD ...
        + Cm_q * ((q * c) / (2 * v)); %Cm     单位 n.d. 俯仰通道的气动力矩系数
    Cn = Cnbv * BETA + Cn_RE + Cn_LE + Cn_RUD ...
        + Cnr * ((r * b) / (2 * v)) + Cnp * ((p * b) / (2 * v)); %Cn      单位 n.d. 偏航通道的气动力矩系数

    %气动力定义在速度坐标系下的表达式 系数为单位换算 1lb=4,44822N
    D = 4.44822 * Q_iu * s * CD; %阻力Xv
    L = 4.44822 * Q_iu * s * CL; %升力Zv
    Y = 4.44822 * Q_iu * s * CY; %侧向力Yv

    %气动力矩定义在机体坐标系下的表达式
    l = 4.44822 * Q_iu * b * s * Cl; %滚转力矩 Xb
    n = 4.44822 * Q_iu * b * s * Cn; %偏航力矩Zb
    m = 4.44822 * Q_iu * c * s * Cm; %俯仰力矩 Yb

    %统一成向量形式输出
    Fair = [D; Y; L]; %速度坐标系
    Mair = [l; m + x_cg * (D * sin(alpha) + L * cos(alpha)); n + x_cg * Y]; %机体坐标系 公式的算法由NASA文档给出
    C = [CD; CY; CL; Cl; Cm; Cn]; %输出气动参数
end
