alpha=1;
A=2;
L=1;
T_final=1;
Nx=10;
Nt=10;
[solution,errors]=solve_BDF2_P1(alpha,A,L,T_final,Nx,Nt);
x_table=0:0.1:1;  %表格中的x点
t_table=0:0.1:1;  %表格中的t点
t_indices=zeros(size(t_table));
for i=1:length(t_table)
[~,t_indices(i)]=min(abs(solution.time-t_table(i)));
end
x_indices=zeros(size(x_table));
for j=1:length(x_table)
[~,x_indices(j)]=min(abs(solution.x_nodes-x_table(j)));
end
u_numerical_table=zeros(length(t_table),length(x_table));
for i=1:length(t_table)
for j=1:length(x_table)
t_idx=t_indices(i);
x_idx=x_indices(j);
%注意：U_all是(Nn×Nt+1)矩阵，每列是一个时间步
u_numerical_table(i,j)=solution.U_all(x_idx,t_idx);
end
end
%显示数值解表格
disp('数值解表格(BDF2-P1)');
fprintf('%-7s','t');
for j=1:length(x_table)
fprintf('%-10s',sprintf('x=%.1f',x_table(j)));
end
fprintf('\n');
fprintf('%s\n',repmat('-',1,7+10*length(x_table)));
for i=1:length(t_table)
fprintf('%-7.3f',solution.time(t_indices(i)));
for j=1:length(x_table)
fprintf('%-10.4f',u_numerical_table(i,j));
end
fprintf('\n');
end
%数值解曲面图-使用U_all绘制所有时间步
[X_num,T_num]=meshgrid(solution.x_nodes,solution.time);

figure('Position',[100 100 600 400]); 
%注意：U_all是空间×时间，绘图时需要转置
surf(X_num,T_num,solution.U_all');
xlabel('x');
ylabel('t');
zlabel('u(x,t)');
title('数值解(BDF2-P1,Nx=10,Nt=10)');
colorbar;
view(45, 30);     
zlim([0, 0.25]);   
colormap('jet'); 

set(gca,'LooseInset',get(gca,'TightInset'));
% 导出为无白边PDF
exportgraphics(gcf,'shuzhijie.png','Resolution',300);
