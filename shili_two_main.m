clear;
alpha=0.01;
L=1;
T_final=2;
%离散参数
Nx=50;
h=L/Nx;
Nt=200;
tau=T_final/Nt;
verbose=true;%显示详细信息
plot_results=true;%绘制结果
[solution,errors]=solve_BDF2_P1_two(alpha,L,T_final,Nx,Nt);
%显示结果
if verbose
fprintf('==========================================\n');
fprintf('数值求解结果\n');
fprintf('==========================================\n');
fprintf('扩散系数:%.2f\n',alpha);
fprintf('区间长度:%.2f\n',L);
fprintf('终时:%.2f\n',T_final);
fprintf('空间单元数:%d,节点数:%d\n',Nx,solution.Nn);
fprintf('时间步数:%d\n',Nt);
fprintf('空间步长:h=%.4f\n',h);
fprintf('时间步长:τ=%.4f\n',tau);
fprintf('------------------------------------------\n');
fprintf('L2误差:%.6e\n',errors.L2);
fprintf('最大误差:%.6e\n',errors.max);
fprintf('==========================================\n');
end
if plot_results&&isfield(solution,'x_nodes')&&isfield(solution,'u_numerical')
figure('Position',[100,100,1000,400]);
plot(solution.x_nodes,solution.u_exact,'b-','LineWidth',2.5);
hold on;
plot(solution.x_nodes,solution.u_numerical_full,'r--','LineWidth',1.8);
xlabel('$x$','Interpreter','latex','FontSize',14);
ylabel('$u(x,t)$','Interpreter','latex','FontSize',14);
title(sprintf('BDF2-P1有限元数值解(Nx=%d,Nt=%d)',Nx,Nt),...
'FontSize',14,'FontWeight','bold');
xticks(0:0.2:1);
yticks(0:0.2:1);
xlim([0,1]);
ylim([0,0.9]);
set(gca,'FontSize',12);
legend({'解析解','数值解(BDF2-P1)'},...
'FontSize',12,'Location','northwest','Box','off');
set(gca,'LooseInset',get(gca,'TightInset'));

exportgraphics(gcf,'shili-two.png','Resolution',300);

hold off;
end
