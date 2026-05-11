function results = convergence_analysis(base_params, Nx_list)
% 收敛性分析：在不同网格密度下计算误差
results.Nx_list = Nx_list;
results.h_list = base_params.L ./ Nx_list;
results.L2_errors = zeros(size(Nx_list));

fprintf('\n正在进行收敛性分析...\n');
fprintf('Nx    h        L2误差        收敛阶\n');
fprintf('-------------------------------    \n');

for idx = 1:length(Nx_list)
    % 更新参数
    params = base_params;
    params.Nx = Nx_list(idx);
    params.h = results.h_list(idx);
    
    % 调整时间步数以保持稳定性
    params.Nt = max(100, 2*params.Nx);  % 确保时间离散足够精细
    
    % 求解
    options.verbose = false;
    options.plot_results = false;
    [solution, errors] = solve_heat_BDF2_P1(params, options);
    
    % 存储结果
    results.L2_errors(idx) = errors.L2;
    
    % 计算收敛阶
    if idx > 1
        log_ratio = log(results.h_list(idx-1)/results.h_list(idx));
        L2_order = log(results.L2_errors(idx-1)/results.L2_errors(idx)) / log_ratio;
        fprintf('%3d  %.4f  %.3e  %.3f\n', ...
                Nx_list(idx), results.h_list(idx), ...
                results.L2_errors(idx), L2_order);
    else
        fprintf('%3d  %.4f  %.3e\n', ...
                Nx_list(idx), results.h_list(idx), ...
                results.L2_errors(idx));
    end
end
end

