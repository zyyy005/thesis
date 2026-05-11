function [nodes, elements] = triangle_mesh_polygon(polygon, hmax)
% 对多边形区域生成三角形网格（线性单元）
% 输入:
%   polygon: N×2 矩阵，多边形顶点坐标（按顺序，首尾闭合）
%   hmax:    最大单元边长（可选，默认自动）
% 输出:
%   nodes:   M×2 节点坐标矩阵
%   elements: K×3 单元节点编号矩阵（每个三角形三个节点）

    if nargin < 2
        hmax = [];
    end

    % 创建 PDE 模型
    model = createpde();

    % 将多边形转换为 PDE 工具箱的几何描述
    gd = [2; size(polygon,1); polygon(:)];
    sf = 'P1';
    ns = char('P1')';
    g = decsg(gd, sf, ns);
    geometryFromEdges(model, g);

    % 生成线性三角形网格
    if isempty(hmax)
        mesh = generateMesh(model, 'GeometricOrder', 'linear');
    else
        mesh = generateMesh(model, 'GeometricOrder', 'linear', 'Hmax', hmax);
    end

    nodes = mesh.Nodes';
    elements = mesh.Elements';
end