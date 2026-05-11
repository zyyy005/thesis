nu=0.1;      % 粘性系数
T=1.0;      
N=100;        
dt=0.004;     
tol=1e-8;     
maxIter=20;      
Nt=ceil(T/dt);%向正无穷取整
Nt=T/dt;
dt=T/Nt;%重新调整时间步长，避免累积误差
x=linspace(0, 1, N+1)';      
h=1/N;                       
% 自由度映射：内部节点编号 -> 自由度编号 (1..N-1)
freeMap=zeros(N+1,1);
freeMap(2:N)=(1:N-1)';%边界节点（1 和 N+1）的自由度编号为0，内部节点（2 到 N）依次映射到1到 N-1
nfree=N-1;  
elements=[(1:N)', (2:N+1)'];   %全局编号
M=sparse(nfree, nfree);
A=sparse(nfree, nfree);
Mloc=h/6*[2, 1; 1, 2];
Aloc=1/h*[1, -1; -1, 1];
for e=1:N
    n1=elements(e,1);
    n2=elements(e,2);
    g1=freeMap(n1);
    g2=freeMap(n2);%全局自由度编号
    for l=1:2
        gl=[g1, g2];
        gl=gl(l);
        if gl==0, continue;
        end
        for r=1:2
            gr=[g1, g2]; 
            gr=gr(r);
            if gr==0, continue; 
            end
            M(gl, gr)=M(gl, gr)+Mloc(l, r);
            A(gl, gr)=A(gl, gr)+Aloc(l, r);
        end
    end
end
u0=sin(pi * x(2:N));  
u_all=zeros(nfree, Nt+1);
u_all(:,1)=u0;
% 向后Euler (BDF1) 得到 u1
rhs_IE=(1/dt)*(M*u0);
coeff_M_IE=1/dt;
u=u0;  
for iter=1:maxIter
    [F,J]=getResJac(u, coeff_M_IE, rhs_IE, M, A, elements, freeMap, nu);
    if norm(F, inf) < tol
        break;
    end
    delta=J\(-F);
    u=u+delta;
end
u1=u;
u_all(:,2)=u1;
% BDF2 循环
u_nm1=u0;   % u^{n-1}
u_n=u1;   % u^{n}
for n=2:Nt
    % BDF2 右端项
    rhs_BDF2=(2/dt)*(M*u_n)-(1/(2*dt))*(M*u_nm1);
    coeff_M_BDF2=3/(2*dt);
    % 初始猜测: 外推 u_{n+1}^{0} = 2*u_n - u_{n-1}
    u=2*u_n-u_nm1;
    for iter=1:maxIter
        [F, J]=getResJac(u, coeff_M_BDF2, rhs_BDF2, M, A, elements, freeMap, nu);
        if norm(F, inf) < tol
            break;
        end
        delta=J\(-F);
        u=u+delta;
    end
    u_np1=u;
    u_all(:, n+1)=u_np1;
    u_nm1=u_n;
    u_n=u_np1;
    if mod(n, 10)==0
        fprintf('t=%.3f 完成\n', n*dt);
    end
end
t_plot=[0, 0.1, 0.3, 0.6, 1.0];
figure; hold on;
for i=1:length(t_plot)
    idx=round(t_plot(i)/dt)+1;
    u_node=zeros(N+1,1);
    u_node(2:N)=u_all(:, idx);
    plot(x, u_node, 'LineWidth', 1.5, 'DisplayName', sprintf('t=%.1f', t_plot(i)));
end
xlabel('x'); ylabel('u(x,t)');
title(sprintf('BDF2-P1数值解, \\nu=%.3f', nu));
legend show;  hold off;
set(gca,'LooseInset',get(gca,'TightInset'));
% 导出为无白边PDF
exportgraphics(gcf,'nonlinear.png','Resolution',300);
