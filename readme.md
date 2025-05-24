<!--
 * @Author: blueWALL-E
 * @Date: 2024-10-31 22:45:46
 * @LastEditTime: 2025-05-25 00:11:10
 * @FilePath: \GHV_open\readme.md
 * @Description: AHV文件的相关说明
 * @Wearing:  Read only, do not modify place!!! 
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
-->

# 1. 项目介绍

&emsp;&emsp;一切高超声速飞行器（GHV）飞控的设计与研究都离不开气动参数模型。现有GHV气动参数普遍存在保密级别高，数据稀缺且不完整等缺点。为避免相关研究者因GHV气动模型参数问题影响科研进度或重复造轮子，故创建此项目。  
&emsp;&emsp;本项目为NASA于20世纪90年代公开的高超声速飞行器（Winged—cone）的完整的动力学模型。  
&emsp;&emsp;目前滑翔段6自由度模型已经完成建模，相关技术文档和全过程动力学模型会在后续更新中提供。并欢迎所有人参与到此项目中。

# 2. 环境要求

- MATLAB2023b及其以上版本

# 3. 运行方法

1. 克隆项目到本地

   ``` bash
   git clone https://github.com/blueWALL-E/GHV_open.git
   ```

2. 在MATLAB命令行窗口中 运行init.m文件 完成路径加载
3. 在MATLAB/Simulink中 运行GHV_open.slx文件 开始属于你的仿真
4. 在MATLAB/Simulink中 运行GHV_open_blocks.slx文件(使用航天航天工具包搭建的仿真平台)

# 4. 功能简介

等待完善 端午假期结束之前一定完成此部分内容

# 5. 文件树

``` bash
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
│  ├─ Get_Aerodynamic.m -GHV气动参数（实际仿真使用版本）
│  ├─ Get_Aerodynamic_copy.m -GHV气动参数备份文件
│  ├─ Get_Aerodynamic_ident.m -GHV气动参数仅用于参数分析（完整实现气动参数的矩阵运算）
│  ├─ Get_Aerodynamic_Simplified.m -GHV气动参数简化版（暂未实现仅保留接口）
│  ├─ rot_dyn.m -转动动力学
│  ├─ rot_kin.m -转动运动学
│  ├─ tra_dyn.m -平动运动学
│  └─ tra_kin.m -平动动力学
├─ GHV_Configuration.m -飞行器初始化文件
├─ GHV_open.slx -GHV飞行器simulink仿真文件
├─ GHV_open_blocks.slx -GHV飞行器simulink仿真文件，使用simulink航天航天工具包搭建
├─ init.m -初始化加载文件
├─ LICENSE -许可证
└─ readme.md -项目说明文档
```

# 6. LICENSE

&emsp;&emsp;**GPL-2.0 license**&emsp;&emsp;许可证详细信息参考[LICENSE](./LICENSE)

## 6.1. 许可证概要

&emsp;&emsp;**GNU GPL v2** 是最广泛使用的自由软件许可证之一，具有强制的**传染性条款**（copyleft）。该协议要求，当你分发修改过的作品时，必须在相同的许可证下公开源代码。以下是该许可证的主要特点：

## 6.2. **许可的内容**

GNU GPLv2 许可授予你以下自由：

- **商业使用**：你可以将软件用于商业目的。
- **分发**：你可以自由分发原始或修改过的软件版本。
- **修改**：你可以自由修改源代码，以适应自己的需求。
- **私用**：你可以在个人环境中使用软件，无需公开。

## 6.3. **附加条件**

GNU GPLv2 附加了以下条件：

- **公开源代码**：当你分发修改过的作品时，必须提供源代码，或者提供如何获得源代码的说明。
- **许可证和版权声明**：你必须在分发的软件中保留原作者的版权声明，并且附上该许可证。
- **相同许可证**：任何基于该软件的衍生作品也必须在相同的 GPLv2 许可证下发布。
- **声明变更**：如果你修改了软件，必须明确说明你做了哪些改动。

## 6.4. **限制**

GNU GPLv2 也对软件使用设置了限制：

- **责任限制**：软件按“现有状态”提供，开发者不对软件的使用或分发过程中的任何问题负责。
- **无担保**：该协议明确表示软件没有任何明示或暗示的担保，开发者不对软件的性能或适用性负责。
