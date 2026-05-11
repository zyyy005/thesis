function u = exact_solution_heat(x, t, nu, N)
% 计算热传导方程的无穷级数精确解
% 输入:
%   x: 空间坐标 (可以是标量/向量)
%   t: 时间 (标量)
%   nu: 热扩散系数 (ν)
%   N: 级数截断项数 (取足够大的数保证精度，如 N=50)
% 输出:
%   u: 精确解 u(x,t)

    % 初始化各项
    omega = 0;
    eta   = 0;
    xi    = besseli(0, 2*pi*nu);  % I_0(2πν) 是常数项

    % 循环计算级数 (j从1到N)
    for j = 1:N
        arg = 1/(2*pi*nu);
        Ij  = besseli(j, arg);  % 第一类j阶修正Bessel函数 I_j(1/(2πν))
        exp_term = exp(-j^2 * pi^2 * nu * t);
        
        omega = omega + j * Ij * sin(j*pi*x) * exp_term;
        eta   = eta   + 2 * Ij * cos(j*pi*x) * exp_term;
    end

    % 计算最终解
    u = 4 * pi * nu * (omega ./ (eta + xi));
end