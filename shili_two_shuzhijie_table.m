alpha=0.01;
L=1;
T_final=2;
Nx=50;
Nt=200;
[solution,errors]=solve_BDF2_P1_two(alpha,L,T_final,Nx,Nt);
%重建全节点的数值解矩阵(Nn×Nt+1)
%首先计算Nt值
solution_Nt=length(solution.time)-1;%从时间序列计算Nt
solution_Nn=solution.Nn;
%使用计算得到的Nt和Nn创建全节点矩阵
U_all_full=zeros(solution_Nn,solution_Nt+1);
for n=1:solution_Nt+1
U_all_full(solution.free_nodes,n)=solution.U_all(:,n);
U_all_full(1,n)=0;%x=0
U_all_full(end,n)=0;%x=1
end
solution.U_all_full=U_all_full;
x_table=0:0.1:1;%表格中的x点
t_table=0:0.2:2;%表格中的t点
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
%使用全节点数值解
u_numerical_table(i,j)=U_all_full(x_idx,t_idx);
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
figure('Position',[100,100,1200,500]);
%使用全节点解绘图
[X_num,T_num]=meshgrid(solution.x_nodes,solution.time);
%检查维度是否匹配
if size(X_num,1)==size(U_all_full,2)&&size(X_num,2)==size(U_all_full,1)
%U_all_full'是(Nt+1)×Nn
surf(X_num,T_num,U_all_full');
else
%如果维度不匹配，尝试调整
fprintf('维度不匹配，尝试调整...\n');
%确保X_num和T_num的维度与U_all_full'匹配
[X_num,T_num]=meshgrid(solution.x_nodes,solution.time);
surf(X_num,T_num,U_all_full');
end