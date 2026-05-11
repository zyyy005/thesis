polygon = [0, 0; 1, 0; 1, 1; 0, 1];
[nodes_tri, elem_tri] = triangle_mesh_polygon(polygon, 0.1);
figure('Position', [100 100 600 600]);  % 固定窗口大小
triplot(elem_tri, nodes_tri(:,1), nodes_tri(:,2), 'k');
axis equal;
xlim([0, 1]);
ylim([0, 1]);
xlabel('X');      
ylabel('Y');      
title('三角形剖分');
exportgraphics(gcf, 'triangle_mesh.png', 'Resolution', 300);
[nodes_quad, elem_quad] = quad_mesh_rectangle(0, 1, 0, 1, 10, 10);
figure('Position', [100 100 600 600]);  % 相同窗口大小
patch('Faces', elem_quad, 'Vertices', nodes_quad, 'FaceColor', 'none', 'EdgeColor', 'k');
axis equal;
xlim([0, 1]);
ylim([0, 1]);
xlabel('X');      
ylabel('Y');     
title('四边形剖分');
exportgraphics(gcf, 'quad_mesh.png', 'Resolution', 300);