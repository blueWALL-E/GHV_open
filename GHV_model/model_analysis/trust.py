import numpy as np
import matplotlib.pyplot as plt

# 参数设置
PLA = 1.0
Ma = np.linspace(2, 6, 500)

# Scramjet 推力多项式
T = PLA * (
    7.53e2 * Ma**7
    - 1.50e4 * Ma**6
    + 1.16e5 * Ma**5
    - 4.36e5 * Ma**4
    + 8.07e5 * Ma**3
    - 6.97e5 * Ma**2
    + 3.94e5 * Ma
    # + 3.93e-8
    + 3.93e+6
)

# 绘图
plt.figure(figsize=(8, 5), facecolor="white")
plt.plot(Ma, T, 'b', linewidth=2)
# plt.axhline(0, color='k', linestyle='--', linewidth=1)
plt.title('Scramjet Thrust (PLA = 100%)', fontsize=14)
plt.xlabel('Mach number (Ma)')
plt.ylabel('Thrust (lb)')
plt.grid(True)

# 标出峰值点
imax = np.argmax(T)
plt.scatter(Ma[imax], T[imax], color='r', zorder=5)
plt.text(Ma[imax], T[imax]*1.02,
         f'Peak: {T[imax]:.2e} N at Ma={Ma[imax]:.2f}',
         color='r', ha='center', fontsize=9)

plt.show()
