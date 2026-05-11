clear; close all; clc;
base_params.alpha = 1.0;      % 扩散系数
base_params.A = 2.0;          % 源项振幅
base_params.L = 1.0;          % 区间长度
base_params.T_final = 1.0;    % 终时
fprintf('开始生成收敛性分析表格...\n');
fprintf('===============================================================\n');
fprintf('基础参数: α = %.1f, A = %.1f, L = %.1f, T = %.1f\n\n', ...
        base_params.alpha, base_params.A, base_params.L, base_params.T_final);

fprintf('表 1  BDF2-P1有限元方法空间收敛性分析\n');
fprintf('====================================================================\n');
fprintf('N_x    h        N_t    τ        CPU时间(s)    L^2误差        L^2收敛阶\n');
fprintf('====================================================================\n');
Nx_list = [10,20, 40, 60,80];
Nt_fixed = 1000;  % 固定时间步数（确保时间误差不影响空间收敛性）
results_space = struct();
results_space.Nx_list = Nx_list;
results_space.h_list = base_params.L ./ Nx_list;
results_space.L2_errors = zeros(size(Nx_list));
results_space.cpu_times = zeros(size(Nx_list));
results_space.L2_orders = zeros(size(Nx_list));

for idx = 1:length(Nx_list)
    params = base_params;
    params.Nx = Nx_list(idx);
    params.h = results_space.h_list(idx);
    params.Nt = Nt_fixed;
    params.tau = params.T_final / params.Nt;
    options.verbose = false;
    options.plot_results = false;
    t_start = tic;
    [solution, errors] = solve_BDF2_P1(params.alpha, params.A, params.L, ...
                                       params.T_final, params.Nx, params.Nt);
    cpu_time = toc(t_start);
    results_space.L2_errors(idx) = errors.L2;
    results_space.cpu_times(idx) = cpu_time;
    if idx > 1
        h_ratio = log(results_space.h_list(idx-1)/results_space.h_list(idx));
        results_space.L2_orders(idx) = ...
            log(results_space.L2_errors(idx-1)/results_space.L2_errors(idx)) / h_ratio;
    end
    if idx == 1
        fprintf('%4d  %7.5f  %4d  %7.5f  %10.3f  %12.3e      -\n', ...
                params.Nx, params.h, params.Nt, params.tau, ...
                cpu_time, errors.L2);
    else
        fprintf('%4d  %7.5f  %4d  %7.5f  %10.3f  %12.3e  %10.3f\n', ...
                params.Nx, params.h, params.Nt, params.tau, ...
                cpu_time, errors.L2, results_space.L2_orders(idx));
    end
end
fprintf('\n\n表 2  BDF2-P1有限元方法时间收敛性分析\n');
fprintf('========================================================\n');
fprintf('N_t    τ        CPU时间(s)    L^2误差        L^2收敛阶\n');
fprintf('========================================================\n');
Nt_list = [16, 32, 64, 128,256];
Nx_fixed = 200;  % 固定空间网格（确保空间误差不影响时间收敛性）
results_time = struct();
results_time.Nt_list = Nt_list;
results_time.tau_list = base_params.T_final ./ Nt_list;
results_time.L2_errors = zeros(size(Nt_list));
results_time.cpu_times = zeros(size(Nt_list));
results_time.L2_orders = zeros(size(Nt_list));
for idx = 1:length(Nt_list)
    params = base_params;
    params.Nx = Nx_fixed;
    params.h = params.L / params.Nx;
    params.Nt = Nt_list(idx);
    params.tau = results_time.tau_list(idx);
    options.verbose = false;
    options.plot_results = false;
    
    t_start = tic;
    [solution, errors] = solve_BDF2_P1(params.alpha, params.A, params.L, ...
                                       params.T_final, params.Nx, params.Nt);
    cpu_time = toc(t_start);
    results_time.L2_errors(idx) = errors.L2;
    results_time.cpu_times(idx) = cpu_time;
    
    % 计算收敛阶（从第二个时间步开始）
    if idx > 1
        tau_ratio = log(results_time.tau_list(idx-1)/results_time.tau_list(idx));
        results_time.L2_orders(idx) = ...
            log(results_time.L2_errors(idx-1)/results_time.L2_errors(idx)) / tau_ratio;
    end
    if idx == 1
        fprintf('%4d  %7.5f  %10.3f  %12.3e      -\n', ...
                params.Nt, params.tau, cpu_time, errors.L2);
    else
        fprintf('%4d  %7.5f  %10.3f  %12.3e  %10.3f\n', ...
                params.Nt, params.tau, cpu_time, errors.L2, ...
                results_time.L2_orders(idx));
    end
end




