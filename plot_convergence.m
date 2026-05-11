function plot_convergence(results)
% 绘制收敛性分析图
figure('Position', [100, 100, 1000, 400]);

% ========== 子图1：误差随网格尺寸变化 ==========
subplot(1, 2, 1);

% 绘制L2误差曲线（黑色）
loglog(results.h_list, results.L2_errors, 'ko-', ...
       'LineWidth', 2, ...
       'MarkerSize', 8, ...
       'MarkerFaceColor', 'k', ...
       'DisplayName', 'L2误差');
hold on;



% 绘制参考线（二阶收敛）- 灰色虚线
ref_slope = results.h_list.^2;
if results.L2_errors(1) > 0
    scale_factor = results.L2_errors(1) / ref_slope(1);
    loglog(results.h_list, scale_factor * ref_slope, ...
           'Color', [0.5 0.5 0.5], ...  % 灰色
           'LineStyle', '--', ...
           'LineWidth', 2, ...
           'DisplayName', 'O(h^2)参考线');
end

grid on; box on;

% ========== 横纵坐标说明 ==========
% 横坐标：网格尺寸 h
xlabel('网格尺寸 $h$', ...
       'Interpreter', 'latex', ...
       'FontSize', 14, ...
       'FontWeight', 'bold');

% 纵坐标：误差
ylabel('误差', ...
       'FontSize', 14, ...
       'FontWeight', 'bold');

title('(a) 误差收敛性', 'FontSize', 16, 'FontWeight', 'bold');
legend('Location', 'southwest', 'FontSize', 12, 'Box', 'off');
set(gca, 'FontSize', 12, 'TickDir', 'out');

% ========== 子图2：收敛阶分析 ==========
subplot(1, 2, 2);

if length(results.h_list) > 2
    % 计算收敛阶
    h_ratios = results.h_list(1:end-1) ./ results.h_list(2:end);
    L2_orders = log(results.L2_errors(1:end-1) ./ results.L2_errors(2:end)) ./ log(h_ratios);
  
    % 创建细化级别标签
    refinement_labels = cell(1, length(L2_orders));
    for i = 1:length(L2_orders)
        refinement_labels{i} = sprintf('%d→%d', i, i+1);
    end
    
    % 绘制L2收敛阶（黑色实线带圆形标记）
    plot(1:length(L2_orders), L2_orders, 'ko-', ...
         'LineWidth', 2, ...
         'MarkerSize', 8, ...
         'MarkerFaceColor', 'k', ...
         'DisplayName', 'L2收敛阶');
    hold on;
 
    
    % 绘制期望收敛阶线（灰色虚线）
    plot([0.5, length(L2_orders)+0.5], [2, 2], ...
         'Color', [0.5 0.5 0.5], ...  % 灰色
         'LineStyle', '--', ...
         'LineWidth', 2, ...
         'DisplayName', '期望阶数(2)');
    
    grid on; box on;
    
    % ========== 横纵坐标说明 ==========
    % 横坐标：网格细化级别
    xlabel('网格细化级别', ...
           'FontSize', 14, ...
           'FontWeight', 'bold');
    
    % 纵坐标：收敛阶
    ylabel('收敛阶', ...
           'FontSize', 14, ...
           'FontWeight', 'bold');
    
    title('(b) 收敛阶分析', 'FontSize', 16, 'FontWeight', 'bold');
    
    % 设置图例
    if exist('max_orders', 'var')
        legend('Location', 'best', 'FontSize', 12, 'Box', 'off');
    else
        legend('Location', 'best', 'FontSize', 12, 'Box', 'off');
    end
    
    % 设置坐标轴
    set(gca, 'FontSize', 12, ...
             'TickDir', 'out', ...
             'XTick', 1:length(L2_orders), ...
             'XTickLabel', refinement_labels, ...
             'YGrid', 'on');
    
    ylim([0, 3]);
    xlim([0.5, length(L2_orders)+0.5]);

    
    % 在图上标注实际收敛阶数值
    for i = 1:length(L2_orders)
        text(i, L2_orders(i) + 0.1, ...
             sprintf('%.2f', L2_orders(i)), ...
             'HorizontalAlignment', 'center', ...
             'FontSize', 10, ...
             'BackgroundColor', 'w');
    end
    
else
    % 数据不足时的提示
    text(0.5, 0.5, '数据不足，无法计算收敛阶', ...
         'HorizontalAlignment', 'center', ...
         'FontSize', 14);
    xlabel('网格细化级别', 'FontSize', 14);
    ylabel('收敛阶', 'FontSize', 14);
    title('(b) 收敛阶分析', 'FontSize', 16);
end

% 总标题
sgtitle('BDF2-P1有限元收敛性分析', ...
        'FontSize', 18, ...
        'FontWeight', 'bold');


end