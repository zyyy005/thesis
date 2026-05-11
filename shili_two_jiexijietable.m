alpha=0.01;
x=0:0.1:1;
t=0:0.2:2;
u=zeros(length(t),length(x));
for i=1:length(t)
for j=1:length(x)
u(i,j)=sin(pi*x(j))*exp(-alpha*pi^2*t(i));
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
figure;
surf(X,T,u);
xlabel('x');
ylabel('t');
zlabel('u(x,t)');
title('解析解u(x,t)=sin(πx)e^{-0.01π²x}');
colorbar;