% 参数设置
nu = 0.1;          % 热扩散系数 ν
tau = 0.004;       % 时间步长 (示例)
h = 0.01;          % 空间步长 (示例)
N = 50;            % 级数截断项数
x = 0:h:1;         % 空间网格 [0,1]
t = 0:tau:0.1;     % 时间序列

% 计算不同时刻的精确解
u_mat = zeros(length(x), length(t));
for k = 1:length(t)
    u_mat(:,k) = exact_nonlinear(x, t(k), nu, N);
end

% 绘图展示
figure;
plot(x, u_mat(:,1), 'r-', 'LineWidth', 1.5, 'DisplayName', 't=0');
hold on;
plot(x, u_mat(:,end), 'b--', 'LineWidth', 1.5, 'DisplayName', ['t=',num2str(t(end))]);
xlabel('x'); ylabel('u(x,t)');
title('热传导方程无穷级数精确解');
legend('Location','best');
grid on;