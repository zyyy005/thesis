clear;
L = 1;
Ne = 2;
h = L/Ne;
x = 0:h:L;
figure('Position', [100, 100, 600, 400]);
hold on;
colors = lines(Ne+1);  % 生成 Ne+1 种不同颜色
for i = 1:Ne+1
    if i == 1
        x_plot = [x(1), x(2)];
        y = [1, 0];
    elseif i == Ne+1
        x_plot = [x(Ne), x(Ne+1)];
        y = [0, 1];
    else
        x_plot = [x(i-1), x(i), x(i+1)];
        y = [0, 1, 0];
    end
    % 绘制基函数曲线，并设置图例条目
    plot(x_plot, y, 'Color', colors(i, :), 'LineWidth', 2, 'DisplayName', sprintf('\\phi_%d', i));
    
end
legend('show', 'Location', 'best');
xlim([0, L]);       
ylim([0, 1]);
set(gca,'FontSize',12);  
xlabel('x');
ylabel('\phi_i(x)');
title(sprintf('一维线性有限元基函数 (Ne=%d)', Ne));
grid off;
hold off;
set(gca,'LooseInset',get(gca,'TightInset'));
% 导出为无白边PDF
exportgraphics(gcf,'jihanshu.png','Resolution',300);
