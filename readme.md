<!--
 * @Author: blueWALL-E
 * @Date: 2024-10-31 22:45:46
 * @LastEditTime: 2025-04-07 21:11:19
 * @FilePath: \GHV_open\readme.md
 * @Description: AHV文件的相关说明
 * @Wearing:  Read only, do not modify place!!! 
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
-->

# 项目介绍

&emsp;&emsp;一切高超声速飞行器（GHV）飞控的设计与研究都离不开气动参数模型。现有GHV气动参数普遍存在保密级别高，数据稀缺且不完整等缺点。为避免相关研究者因GHV气动模型参数问题影响科研进度或重复造轮子，故创建此项目。  
&emsp;&emsp;本项目为NASA于20世纪90年代公开的高超声速飞行器（Winged—cone）的完整的动力学模型。  
&emsp;&emsp;目前滑翔段6自由度模型已经完成建模，相关技术文档和全过程动力学模型会在后续更新中提供。并欢迎所有人参与到此项目中。

## 环境要求

- MATLAB2023b及其以上版本

## 运行方法

1. 运行init.m文件 完成路径加载
2. 运行GHV_open.slx文件 开始属于你的仿真

## 项目文件树

```
GHV_open
├─ doc -飞行器说明文档文件夹
│  ├─ Development of an Aerodynamic Database for a generic Hypersonic Air Vehicle.pdf
│  ├─ Hypersonic vehicle simulation model Winged-cone configuration.pdf
│  ├─ 正文-高超声速飞行器动力学建模.docx
│  └─ 高超声速飞行器动力学模型.docx
├─ GHV_control  -控制算法文件夹
│  ├─ FBL_M.m -反馈线性化控制
│  ├─ lie_solving.m -反馈线性化中lie导数求解过程
│  └─ Sliding_mode.m  -滑模控制
├─ GHV_modle -飞行器动力学模型文件夹
│  ├─ EarthEnvironment.m -地球环境
│  ├─ Get_Aerodynamic.m -GHV气动参数
│  ├─ Get_Aerodynamic_copy.m -GHV气动参数备份文件
│  ├─ Get_Aerodynamic_ident.m -GHV气动参数仅用于参数分析
│  ├─ Get_Aerodynamic_Simplified.m -GHV气动参数简化版（暂未实现）
│  ├─ rot_dyn.m -转动动力学
│  ├─ rot_kin.m -转动运动学
│  ├─ tra_dyn.m -平动运动学
│  └─ tra_kin.m -平动动力学
├─ GHV_open.slx -GHV飞行器simulink仿真文件
├─ GHV_open.slxc -simulink缓存文件
├─ init.m -初始化加载文件
├─ LICENSE -许可证
├─ readme.md -项目说明文档
└─ slprj -MATLAB/Simulink相关配置文件夹
   
```

## LICENSE

&emsp;&emsp;**GPL-2.0 license**&emsp;&emsp;许可证详细信息参考LICENSE文件

