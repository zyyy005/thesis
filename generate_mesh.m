function [x_nodes,elements]=generate_mesh(L,Nx)
% 生成一维均匀网格
x_nodes=linspace(0,L,Nx+1)';  % 节点坐标
elements=[(1:Nx)',(2:Nx+1)'];  % 单元连接矩阵
end