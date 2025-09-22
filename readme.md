<!--
 * @Author: blueWALL-E
 * @Date: 2024-10-31 22:45:46
 * @LastEditTime: 2025-09-22 10:01:56
 * @FilePath: \GHV_open\readme.md
 * @Description: GHV文件的相关说明
 * @Wearing:  Read only, do not modify place!!! 
 * @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
-->

# 说明文档

## 项目介绍

&emsp;&emsp;一切高超声速飞行器（Generic Hypersonic Vehicle）飞控的设计与研究都离不开气动参数模型。现有GHV气动参数普遍存在保密级别高，数据稀缺且不完整等缺点。为避免相关研究者因GHV气动模型参数问题影响科研进度或重复造轮子，故创建此项目。  
&emsp;&emsp;本项目为NASA于20世纪90年代公开的高超声速飞行器（Winged—cone）的完整动力学模型。包含两个仿真平台，一个是用matlab function纯公式构建（GHV_open_equation.slx），一个是使用航空航天工具包构建（GHV_open_equation.slx），用户可根据自身需要选择合适的平台，建议新手使用GHV_open_equation.slx仿真平台。  
&emsp;&emsp;已完成无动力滑翔段6自由度模型建模，相关技术文档和全过程动力学模型会在后续更新中提供。并欢迎所有人参与到此项目中并寻找bug。  

## 环境要求

- MATLAB2023b及其以上版本

## 运行方法

1. 克隆项目到本地

   ``` bash
   git clone https://github.com/blueWALL-E/GHV_open.git
   ```

2. 运行init.m文件，完成路径加载。
3. 运行GHV_open_equation.slx文件:直接运行即可。

## 功能简介

本项目提供以下核心功能：

1. **完整的6自由度动力学建模**  
   - 实现了高超声速飞行器在无动力滑翔段的完整动力学建模，包括平动和转动的动力学与运动学。
   - 支持基于气动参数的精确仿真，适用于飞控算法验证和性能分析。

2. **多种仿真平台支持**  
   - **GHV_open_equation.slx**：基于MATLAB函数的纯公式构建，适合对动力学方程的深入研究。
   - **GHV_open_toolbox.slx**：基于Simulink航空航天工具包构建，适合快速搭建和扩展仿真环境。

3. **控制算法实现**  
   - 提供多种控制算法示例以供参考
     - **自适应模糊滑模控制（AFSMC）**：适用于高超声速飞行器的自适应滑模控制设计（GHV_toolbox_adaptive_fuzzy.slx）。
     - **自适应滑模控制（ASMC）**：相比于AFSMS结构更简单（GHV_toolbox_adaptive_sliding.slx）。

4. **模块化设计**  
   - 动力学模型、气动参数和控制算法均采用模块化设计，便于扩展和替换。
   - 提供多种气动参数实现版本（如简化版、矩阵运算版），满足不同仿真需求。

5. **技术文档支持**  
   - 提供详细的技术文档，包括：(相关内容会尽快完善)
     - 飞行器说明文档。
     - 气动参数数据库。
     - 动力学建模过程和控制算法说明。
   - 帮助用户快速上手并理解模型的实现细节。

## 文件树

``` bash
GHV_open
├─ .vscode - VS Code 配置文件夹
├─ adaptive fuzzy control - 自适应模糊控制文件夹
│  └─ GHV_toolbox_adaptive_fuzzy.slxc - 自适应模糊控制的 Simulink 编译文件
├─ cache - 缓存文件夹
│  └─ .gitkeep - 保留空文件夹的 Git 文件
├─ Control_Schemes - 控制方案文件夹
│  └─ GHV_toolbox_adaptive_fuzzy.slx - 自适应模糊控制的 Simulink 仿真文件
├─ doc - 飞行器说明文档文件夹
│  ├─ Development of an Aerodynamic Database for a generic Hypersonic Air Vehicle.pdf
│  ├─ Hypersonic vehicle simulation model Winged-cone configuration.pdf
│  ├─ 正文-高超声速飞行器动力学建模.docx
│  └─ 高超声速飞行器动力学模型.docx
├─ GHV_control - 控制算法文件夹
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
├─ draft.m - 草稿文件
├─ GHV_Configuration.m - 飞行器基本参数配置文件
├─ GHV_open_equation.slx - GHV 飞行器 Simulink 仿真文件（纯公式构建）
├─ GHV_open_toolbox.slx - GHV 飞行器 Simulink 仿真文件（工具包构建）
├─ init.m - 初始化加载文件
├─ LICENSE - 许可证
└─ readme.md - 项目说明文档
```

## LICENSE

&emsp;&emsp;**GPL-2.0 license**&emsp;&emsp;许可证详细信息参考[LICENSE](./LICENSE)

### 许可证概要

&emsp;&emsp;**GNU GPL v2** 是最广泛使用的自由软件许可证之一，具有强制的**传染性条款**（copyleft）。该协议要求，当你分发修改过的作品时，必须在相同的许可证下公开源代码。以下是该许可证的主要特点：

### **许可的内容**

GNU GPLv2 许可授予你以下自由：

- **商业使用**：你可以将软件用于商业目的。
- **分发**：你可以自由分发原始或修改过的软件版本。
- **修改**：你可以自由修改源代码，以适应自己的需求。
- **私用**：你可以在个人环境中使用软件，无需公开。

### **附加条件**

GNU GPLv2 附加了以下条件：

- **公开源代码**：当你分发修改过的作品时，必须提供源代码，或者提供如何获得源代码的说明。
- **许可证和版权声明**：你必须在分发的软件中保留原作者的版权声明，并且附上该许可证。
- **相同许可证**：任何基于该软件的衍生作品也必须在相同的 GPLv2 许可证下发布。
- **声明变更**：如果你修改了软件，必须明确说明你做了哪些改动。

### **限制**

GNU GPLv2 也对软件使用设置了限制：

- **责任限制**：软件按“现有状态”提供，开发者不对软件的使用或分发过程中的任何问题负责。
- **无担保**：该协议明确表示软件没有任何明示或暗示的担保，开发者不对软件的性能或适用性负责。

## 备注

&emsp;&emsp;请忽略头部注释中的此行代码：

``` C
    @Shortcut keys:  ctrl+alt+/ ctrl+alt+z
```

&emsp;&emsp;此为原作者编辑器自定义快捷键，与本项目无关。

