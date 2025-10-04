<!--
 * @Author: blueWALL-E
 * @Date: 2024-10-31 22:45:46
 * @LastEditTime: 2025-10-04 18:52:40
 * @FilePath: \GHV_open\readme.md
 * @Description: GHV文件的相关说明
 * @Wearing:  Read only, do not modify place!!! 
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
-->

# GHV_open

[![License: GPL‑2.0](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)

## 简介

&emsp;&emsp;**GHV_open** 是一个面向高超声速飞行器（Generic Hypersonic Vehicle）的开源动力学与 GNC（制导、导航与控制）仿真研究平台。项目包含完整的 6 自由度动力学模型、气动力模型、发动机模型、地球环境以及多种控制算法示例，旨在为研究人员和飞控工程师提供一个可扩展、可复现的高超声速飞行器 GNC 仿真平台。  
&emsp;&emsp;下图为高超声速飞行器动力学仿真平台截图
![GHV 模型结构](docs/仿真平台截图.jpg)

## 背景与依据

&emsp;&emsp;高超声速飞行器的气动参数通常处于保密状态，公开资料相对稀缺且不完整。为避免研究者重复造轮子，并促进社区协作，本平台参考 NASA 于 20 世纪 90 年代公开的 Winged-Cone 高超声速飞行器参数进行构建。

## 项目特点

- 完整高超声速飞行器6自由度动力学模型
- 提供多种仿真平台和工况支持：
  - `GHV_open_equation.slx`：基于 MATLAB 纯公式实现动力学仿真平台
  - `GHV_open_toolbox.slx`：基于 Simulink / Aerospace Toolbox 动力学仿真平台
  - `GHV_open_VarialbeMass_toolbox.slx`：考虑发动机推力模型的变质量动力学仿真平台
  - `GHV_open_VarialbeMass_elliposid_toolbox.slx`：考虑椭球地球的变质量动力学仿真平台
- 多种控制算法示例：如自适应滑模控制，自适应模糊滑模控制算法等
- 模块化设计：动力学、气动力、控制算法、发动机推力、地球环境等可替换扩展

## 目录结构

``` bash
GHV_open
├─ .vscode/ - VS Code 配置文件夹
├─ cache/ - 缓存文件夹
│  └─ .gitkeep - 保留空文件夹的 Git 文件
├─ Control_Schemes/ - 控制方案文件夹
│  ├─GHV_open_VarialbeMass_toolbox_adaptive_fuzzy.slx
│  ├─GHV_toolbox_adaptive_fuzzy.slx
│  └─GHV_toolbox_adaptive_sliding.slx - 自适应模糊控制的 Simulink 仿真文件
├─ docs/ - 飞行器说明文档文件夹
├─ GHV_control/ - 控制算法文件夹
│  ├─ adaptive fuzzy control/ - 自适应模糊控制算法文件夹
│  ├─ FBL_M.m - 反馈线性化控制
│  ├─ lie_solving.m - 反馈线性化中 Lie 导数求解过程
│  └─ Sliding_mode.m - 滑模控制
├─ GHV_model - 飞行器动力学模型文件夹
│  ├─ Aerodynamic_coefficients.m - GHV 气动参数（工具包仿真版本）
│  ├─ EarthEnvironment.m - 地球环境
│  ├─ Get_Aerodynamic.m - GHV 气动参数（纯公式仿真版本）
│  ├─ Get_Aerodynamic_copy.m - GHV 气动参数备份文件
│  ├─ Get_Aerodynamic_ident.m - GHV 气动参数（矩阵运算版本，用于参数分析）
│  ├─ Get_Aerodynamic_Simplified.m - GHV 气动参数简化版（暂未实现，仅保留接口）
│  ├─ rot_dyn.m - 转动动力学
│  ├─ rot_kin.m - 转动运动学
│  ├─ tra_dyn.m - 平动动力学
│  └─ tra_kin.m - 平动运动学
├─ .gitignore - Git 忽略文件
├─ draft.m - 草稿文件（git未跟踪 可自行建立）
├─ GHV_Configuration.m - 飞行器基本参数配置文件
├─ GHV_open_equation.slx - 基于 MATLAB 纯公式实现动力学仿真平台
├─ GHV_open_toolbox.slx - 基于 Simulink/Aerospace Toolbox 动力学仿真平台
├─ GHV_open_VarialbeMass_toolbox.slx - 考虑发动机推力模型的变质量动力学仿真平台
├─ GHV_open_VarialbeMass_elliposid_toolbox.slx - 考虑椭球地球的变质量动力学仿真平台
├─ init.m - 初始化加载文件
├─ LICENSE - 许可证
└─ readme.md - 项目说明文档
```

## 安装与使用

### 环境要求

- MATLAB 2023b+

### 快速开始（3 步）

#### **Step1**—克隆工程

```bash
git clone https://github.com/blueWALL-E/GHV_open.git
cd GHV_open
```

#### **Step2** — 设置飞行器初始配置并初始化路径

编辑 `GHV_Configuration.m`（飞行器基本参数配置文件），完成后在 MATLAB 中执行：

```bash
init;  % 加载项目路径与默认配置
```

#### Step 3 — 运行仿真平台

根据需求选择以下仿真平台：

- `GHV_open_equation.slx`：基于 MATLAB 纯公式实现动力学仿真平台  
- `GHV_open_toolbox.slx`：基于 Simulink / Aerospace Toolbox 动力学仿真平台  
- `GHV_open_VarialbeMass_toolbox.slx`：考虑发动机推力模型的变质量动力学仿真平台  
- `GHV_open_VarialbeMass_elliposid_toolbox.slx`：考虑椭球地球的变质量动力学仿真平台  

💡 建议新手从 `GHV_open_toolbox.slx` 入手；更多控制方法示例见 `Control_Schemes/`。

## 贡献指南

欢迎任何贡献，包括但不限于：

- 🛠️  修复各种 bug
- 📚  完善说明文档
- 📈  丰富控制算法
- ✈️  设计高超声速飞行器飞行轨迹
- 🌡️  建立热相关模型
- 🚀  完善发动机模型数据
- 🌐  增加英文版文档

流程：

1. Fork 本仓库
2. 新建分支 `feature/xxx`
3. 提交修改并运行测试
4. 提交 Pull Request

## 许可证

本项目采用 **GPL‑2.0** 许可证。详见 [LICENSE](LICENSE)。

## 致谢

- 美国国家航空航天局兰利研究中心提供的winged-cone高超声速飞行器数据
- 项目作者：**blueWALL-E**（我自己）

## 备注

&emsp;&emsp;请忽略头部注释中的此行代码：

``` C
    @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
```

&emsp;&emsp;此为原作者编辑器自定义快捷键，与本项目无关。
