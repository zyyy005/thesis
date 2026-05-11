function [M,A_mat,F,free_nodes]=assemble_matrix(x_nodes,elements,alpha,A,h)
Nn=length(x_nodes);
Nx=size(elements,1);
M_global=sparse(Nn,Nn);
A_global=sparse(Nn,Nn);
F_global=zeros(Nn,1);
M_elem=h/6*[2,1;1,2];    %单元质量矩阵
A_elem=(1/h)*[1,-1;-1,1];  %单元刚度矩阵
for e=1:Nx   %遍历单元
nodes=elements(e,:);
x1=x_nodes(nodes(1));
x2=x_nodes(nodes(2));
M_global(nodes,nodes)=M_global(nodes,nodes)+M_elem;
A_global(nodes,nodes)=A_global(nodes,nodes)+alpha*A_elem;
F_global(nodes)=F_global(nodes)+compute_element_load(x1,x2,A,h);%组装载荷向量（使用区间[-1,1]上的高斯积分）
end
%处理边界条件u(0)=0,u(L)=0
bdry_nodes=[1,Nn];
free_nodes=setdiff(1:Nn,bdry_nodes);
%提取自由节点对应的子矩阵
M=M_global(free_nodes,free_nodes);
A_mat=A_global(free_nodes,free_nodes);
F=F_global(free_nodes);
end