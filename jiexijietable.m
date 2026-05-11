alpha=1;
A=2;
x=0:0.1:1;
t=0:0.1:1;
u=zeros(length(t),length(x));
for i=1:length(t)
for j=1:length(x)
u(i,j)=(A/pi^2)*(1-exp(-pi^2*t(i)))*sin(pi*x(j));
end
end
%显示结果表格
disp('解析解表格');
fprintf('%-7s','t');
for j=1:length(x)
fprintf('%-10s',sprintf('x=%.1f',x(j)));
end
fprintf('\n');
fprintf('%s\n',repmat('-',1,7+10*length(x)));
for i=1:length(t)
fprintf('%-7.3f',t(i));
for j=1:length(x)
fprintf('%-10.4f',u(i,j));
end
fprintf('\n');
end
[X,T]=meshgrid(x,t);
% figure;
figure('Position',[100 100 600 400]); 
surf(X,T,u);
xlabel('x');
ylabel('t');
zlabel('u(x,t)');
title('解析解u(x,t)=(2/π²)(1-e^{-π²t})sin(πx)');
colorbar;
view(45, 30);                     % 设置视角
zlim([0, 0.25]);                  % 固定垂直范围
colormap('jet');
set(gca,'LooseInset',get(gca,'TightInset'));
exportgraphics(gcf,'jiexijie.png','Resolution',300);