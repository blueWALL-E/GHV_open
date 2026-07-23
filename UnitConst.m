%{
/*
 * @Author: blueWALL-E
 * @Date: 2026-07-23 21:50:22
 * @LastEditTime: 2026-07-23 22:25:31
 * @FilePath: \GHV_open\UnitConst.m
 * @Description: 单位制换算常数
 * @Wearing:  Read only, do not modify place!!!
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
 */
%}
classdef UnitConst

    properties (Constant)
        % 质量
        lbm2kg = 0.45359237; % kg/lbm
        kg2lbm = 1.0/0.45359237; % lbm/kg
        % 力
        lbf2N = 4.4482216152605; % N/lbf

        % 动压
        psf2Pa = 47.8802589803358; % Pa/(lbf/ft^2)
        Pa2psf = 1.0/47.8802589803358; % (lbf/ft^2)/Pa

        % 美制工程单位中的标准重力和质量—力转换常数
        g0_US = 32.1740485564304; % ft/s^2
        gc_US = 32.1740485564304; % lbm*ft/(lbf*s^2)
    end

end
