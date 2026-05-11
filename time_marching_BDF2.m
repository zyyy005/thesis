function [U_all, time]=time_marching_BDF2(M, A_mat, F, free_nodes, Nn, Nt, tau)
N_free=length(free_nodes);%自由节点的总数
% 初始化解向量
u_now=zeros(N_free, 1);   % u^{m}
u_pre=zeros(N_free, 1);   % u^{m-1}
u_pre2=zeros(N_free, 1);  % u^{m-2}
U_all=zeros(Nn, Nt+1);
U_all(free_nodes, 1)=u_now;
time=linspace(0, Nt*tau, Nt+1);
% BDF2系统矩阵
BDF2_matrix=(3/(2*tau))*M+A_mat;
[L_mat, U_mat]=lu(BDF2_matrix);
% 向后欧拉系统矩阵（第一步使用）
BDF1_matrix=(1/tau)*M + A_mat;
[L_be, U_be]=lu(BDF1_matrix);
for m=1:Nt
    if m==1
        b=M*(1/tau*u_pre)+F;
        u_now=U_be\(L_be\b);
    else
        b=M*((4/(2*tau))*u_pre-(1/(2*tau))*u_pre2)+F;
        u_now=U_mat\(L_mat\b);
    end
    u_pre2=u_pre;
    u_pre=u_now;
    U_all(free_nodes, m+1)=u_now;
end
end
