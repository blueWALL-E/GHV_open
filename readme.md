# GHV_open
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](./LICENSE)
[![MATLAB >= 2023b](https://img.shields.io/badge/MATLAB-2023b%2B-orange.svg)](#environment)

开源的 Generic Hypersonic Vehicle（GHV）动力学与控制研究平台，基于 NASA 公开的 Winged‑cone 模型。项目提供完整的 6 自由度无动力滑翔段建模、气动数据库及多种控制算法示例，旨在为高超声速飞行器研究提供可复现的基准环境。

## Table of Contents
- [Features](#features)
- [Environment](#environment)
- [Quick Start](#quick-start)
- [Directory Structure](#directory-structure)
- [Usage Examples](#usage-examples)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [License](#license)
- [References](#references)

## Features
- **6-DOF Dynamics** – 完整的平动与转动动力学/运动学建模，支持多版本气动参数。
- **Multiple Simulink Platforms** – 提供纯公式版 (`GHV_open_equation.slx`) 与航空航天工具包版 (`GHV_open_toolbox.slx`)。
- **Control Algorithms** – 自适应模糊滑模控制、自适应滑模控制、滑模控制、反馈线性化等。
- **Modular Design** – 动力学、气动与控制模块互相独立，便于扩展与替换。
- **Technical Docs** – 附带建模说明与气动数据库，持续更新中。

## Environment
- MATLAB **R2023b** 或更高版本  
- Simulink 航空航天工具包（使用 `GHV_open_toolbox.slx` 时需要）

## Quick Start
```bash
# 克隆仓库
git clone https://github.com/blueWALL-E/GHV_open.git
cd GHV_open

# 在 MATLAB 中运行初始化脚本
init   % 加载路径
```

打开并运行所需仿真平台：

- `GHV_open_equation.slx`：纯公式仿真，适合深入研究动力学方程；
- `GHV_open_toolbox.slx`：工具包仿真，适合快速搭建测试环境。

根据需求选择控制方案或自行实现新控制算法。

## Directory Structure
```text
GHV_open/
├── Control_Schemes/      # 控制方案示例（AFSMC、ASMC 等）
├── GHV_control/          # 控制算法 MATLAB 实现
├── GHV_model/            # 动力学与气动模型
├── doc/                  # 技术文档与气动数据库
├── init.m                # 环境初始化脚本
├── GHV_open_equation.slx # 纯公式仿真模型
└── GHV_open_toolbox.slx  # 航空航天工具包仿真模型
```

## Usage Examples

### 运行纯公式仿真并调用控制器
```matlab
% 初始化环境
init;

% 运行仿真
sim('GHV_open_equation.slx');

% 调用滑模控制
u = Sliding_mode(state_vector);
```

### 自定义气动参数
```matlab
coeff = Get_Aerodynamic(current_state, config);
% 根据需求修改 coeff 后重新仿真
```

## Contributing
欢迎通过 Issue 或 Pull Request 参与贡献：

- 修复 bug、补充功能或完善文档
- 在 `doc/` 中新增参考资料或教程

在提交之前，请遵循以下准则：

- Fork 仓库并创建新分支（勿在 main 上直接提交）。
- 确保代码风格与现有项目保持一致。
- 附带必要注释与文档更新。

## Roadmap
- [x] 6-DOF 无动力滑翔段模型
- [x] AFSMC、ASMC 等控制方案示例
- [ ] 完整动力段模型与再入控制
- [ ] 自动化测试与 CI 配置
- [ ] 文档与教程进一步完善

## License
本项目采用 GPL-2.0 许可证。衍生作品需在相同许可证下开源。详情见 [LICENSE](./LICENSE)。

## References
- *Development of an Aerodynamic Database for a Generic Hypersonic Air Vehicle*
- *Hypersonic Vehicle Simulation Model Winged-cone Configuration*

