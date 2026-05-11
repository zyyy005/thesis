clear; clc;

nu = 0.1;      % 粘性系数
T = 1.0;      
N = 100;        
dt = 0.004;     
tol = 1e-8;     
maxIter = 20;      
Nt = ceil(T / dt);   
dt = T / Nt;         
x = linspace(0, 1, N+1)';      
h = 1 / N;                       

% 自由度映射
freeMap = zeros(N+1, 1);
freeMap(2:N) = (1:N-1)';
nfree = N - 1;  

% 单元定义
elements = [(1:N)', (2:N+1)'];   

% 组装质量矩阵 M 和刚度矩阵 A
M = sparse(nfree, nfree);
A = sparse(nfree, nfree);
Mloc = h/6 * [2, 1; 1, 2];
Aloc = 1/h * [1, -1; -1, 1];

for e = 1:N
    n1 = elements(e,1);
    n2 = elements(e,2);
    g1 = freeMap(n1);
    g2 = freeMap(n2);
    for l = 1:2
        gl = [g1, g2];
        gl = gl(l);
        if gl == 0, continue; end
        for r = 1:2
            gr = [g1, g2];
            gr = gr(r);
            if gr == 0, continue; end
            M(gl, gr) = M(gl, gr) + Mloc(l, r);
            A(gl, gr) = A(gl, gr) + Aloc(l, r);
        end
    end
end

% 初始条件
u0 = sin(pi * x(2:N));  
u_all = zeros(nfree, Nt+1);
u_all(:,1) = u0;

% 计时开始
tic;

% ---------- 向后 Euler (BDF1) 得到 u1 ----------
rhs_IE = (1/dt) * (M * u0);
coeff_M_IE = 1/dt;
u = u0;  
for iter = 1:maxIter
    [F, J] = getResJac(u, coeff_M_IE, rhs_IE, M, A, elements, freeMap, nu);
    if norm(F, inf) < tol
        break;
    end
    delta = J \ (-F);
    u = u + delta;
end
u1 = u;
u_all(:,2) = u1;

% ---------- BDF2 循环 ----------
u_nm1 = u0;
u_n = u1;
for n = 2:Nt
    rhs_BDF2 = (2/dt) * (M * u_n) - (1/(2*dt)) * (M * u_nm1);
    coeff_M_BDF2 = 3/(2*dt);
    u = 2*u_n - u_nm1;
    for iter = 1:maxIter
        [F, J] = getResJac(u, coeff_M_BDF2, rhs_BDF2, M, A, elements, freeMap, nu);
        if norm(F, inf) < tol
            break;
        end
        delta = J \ (-F);
        u = u + delta;
    end
    u_np1 = u;
    u_all(:, n+1) = u_np1;
    u_nm1 = u_n;
    u_n = u_np1;
end

% 计时结束
elapsed_time = toc;

% 提取 t=0.1 时刻指定节点的数值解
t_target = 0.1;
idx_time = round(t_target / dt) + 1;
x_targets = [0.1, 0.2, 0.3, 0.4, 0.5];
fprintf('\n===== 计算结果 =====\n');
fprintf('计算耗时: %.4f 秒\n', elapsed_time);
fprintf('t = %.1f 时刻数值解:\n', t_target);
for i = 1:length(x_targets)
    x_val = x_targets(i);
    dof_idx = round(x_val / h);
    if dof_idx < 1 || dof_idx > nfree
        error('x = %.1f 不在内部节点上（请检查网格步长）', x_val);
    end
    u_val = u_all(dof_idx, idx_time);
    fprintf('x = %.1f, u = %.8f\n', x_val, u_val);
end