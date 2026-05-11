function [nodes, elements] = quad_mesh_rectangle(xmin, xmax, ymin, ymax, nx, ny)
% 生成矩形区域的结构化四边形网格（线性单元）
% 输入:
%   xmin, xmax: x 方向范围
%   ymin, ymax: y 方向范围
%   nx, ny:     在 x、y 方向上的单元数
% 输出:
%   nodes:   M×2 节点坐标矩阵
%   elements: K×4 单元节点编号矩阵（每个四边形四个节点，按逆时针顺序）

    % 生成节点坐标
    x = linspace(xmin, xmax, nx+1);
    y = linspace(ymin, ymax, ny+1);
    [X, Y] = meshgrid(x, y);
    nodes = [X(:), Y(:)];

    % 单元连接关系
    elements = zeros(nx*ny, 4);
    for j = 1:ny
        for i = 1:nx
            idx = (j-1)*(nx+1) + i;
            elements((j-1)*nx + i, :) = [idx, idx+1, idx+nx+2, idx+nx+1];
        end
    end
end