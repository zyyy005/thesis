function u = exact_nonlinear(x, t, nu, k)
% Burgers 方程精确解 (Cole-Hopf)
% u_t + u u_x = nu u_xx, u(x,0)=sin(pi*x)
    orig_size = size(x);
    x = x(:)';
    % 常数项
    xi = besseli(0, 1/(2*pi*nu));
    % 级数索引
    j = (1:k)';                 % 列向量 N×1
    arg = 1/(2*pi*nu);
    Ij = besseli(j, arg);       % N×1
    exp_term = exp(-j.^2 * pi^2 * nu * t);  % N×1
    
    % 构造 sin(jπx) 和 cos(jπx) 矩阵 (N × length(x))
    sin_mat = sin(pi * (j * x));
    cos_mat = cos(pi * (j * x));
    
    % 分子: ∑ j * Ij * exp_term * sin(jπx)
    coeff_num = (j .* Ij .* exp_term)';   % 1×N
    numerator = coeff_num * sin_mat;       % 1×M
    
    % 分母: I0 + ∑ Ij * exp_term * cos(jπx)
    coeff_den = (Ij .* exp_term)';         % 1×N
    denominator = xi + coeff_den * cos_mat; % 1×M
    
    % 最终解
    u = 2 * pi * nu * (numerator ./ denominator);
    
    % 转回原形状并强制边界条件
    u = reshape(u, orig_size);
    u(x(:)==0 | x(:)==1) = 0;
end