% 参数设置
nu = 0.1;      % 粘性系数
k= 100;       % 截断项数（足够保证精度）
t = 0.1;       % 时刻
x = linspace(0, 1, 200)';   % 空间网格

% 计算精确解
u_exact = exact_nonlinear(x, t, nu, k);

% 绘图
figure('Color','white');
plot(x, u_exact, 'b-', 'LineWidth', 2);
xlabel('x', 'FontSize',12);
ylabel('u(x,t)', 'FontSize',12);
title(sprintf('Burgers方程精确解, \\nu=%.3f, t=%.1f', nu, t), 'FontSize',14);
