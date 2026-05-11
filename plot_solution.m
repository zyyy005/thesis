function plot_solution(solution, errors, params)
% 绘制数值解和解析解对比图
x = solution.x;
u_exact = solution.u_exact;
u_numerical = solution.U_all(:, end);

figure('Position', [100, 100, 1200, 500]);

% 子图1：解对比
subplot(1,2,1);
plot(x, u_exact, 'b-', 'LineWidth', 2, 'DisplayName', '解析解');
hold on;
plot(x, u_numerical, 'ro--', 'LineWidth', 1.5, 'MarkerSize', 6, ...
     'DisplayName', '数值解 (BDF2-P1)');
grid on; box on;
xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$u(x,t)$', 'Interpreter', 'latex', 'FontSize', 14);
title(sprintf('t = %.2f 时刻的解', params.T_final), ...
      'Interpreter', 'latex', 'FontSize', 16);
legend('Location', 'northeast', 'FontSize', 12);
set(gca, 'FontSize', 12);
% 误差分布
subplot(1,2,2);
error = u_numerical - u_exact;
plot(x, error, 'k-', 'LineWidth', 2);
grid on; box on;
xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('误差u_h - u', 'Interpreter', 'latex', 'FontSize', 14);
title(sprintf('误差分布 (L2=%.2e, Max=%.2e)', errors.L2, errors.max), ...
      'FontSize', 16);
set(gca, 'FontSize', 12);

% 总标题
sgtitle(sprintf('BDF2-P1有限元数值解 (Nx=%d, Nt=%d)', params.Nx, params.Nt), ...
        'FontSize', 18);
% （时间演化）
if true  % 设为true可显示时间演化
    figure;
    for i = 1:5:size(solution.U_all, 2)
        plot(x, solution.U_all(:, i), 'b-', 'LineWidth', 2);
        hold on;
        plot(x, compute_exact_solution(x, solution.time(i), params.A, params.alpha), 'r--', 'LineWidth', 1.5);
        hold off;
        title(sprintf('t = %.3f', solution.time(i)));
        xlabel('x'); ylabel('u');
        legend('数值解', '解析解');
        grid on;
        drawnow;
        pause(0.05);
    end
end
end