function[M,A_mat,free_nodes]=assemble_matrix_two(x_nodes,elements,alpha,h)
Nn=length(x_nodes);
Nx=size(elements,1);
M_global=sparse(Nn,Nn);
A_global=sparse(Nn,Nn);
M_elem=h/6*[2,1;1,2];      %单元质量矩阵
A_elem=(1/h)*[1,-1;-1,1];  %单元刚度矩阵
for e=1:Nx                %遍历单元
nodes=elements(e,:);
M_global(nodes,nodes)=M_global(nodes,nodes)+M_elem;
A_global(nodes,nodes)=A_global(nodes,nodes)+alpha*A_elem;
end
%处理边界条件u(0)=0,u(L)=0
bdry_nodes=[1,Nn];
free_nodes=setdiff(1:Nn,bdry_nodes);
%提取自由节点对应的子矩阵
M=M_global(free_nodes,free_nodes);
A_mat=A_global(free_nodes,free_nodes);
end