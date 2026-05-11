function[U_all,time]=time_marching_BDF2_two(M,A_mat,free_nodes,Nn,Nt,tau,alpha)
N_free=length(free_nodes);
u_now=zeros(N_free,1);  %u^{m}
u_pre=zeros(N_free,1);  %u^{m-1}
u_pre2=zeros(N_free,1); %u^{m-2}
U_all=zeros(N_free,Nt+1);
x_nodes=linspace(0,1,Nn)';
x_free=x_nodes(free_nodes);
u0_free=sin(pi*x_free);
u_pre=u0_free;          %u^{0}
U_all(:,1)=u_pre;
BDF2_matrix=(3/(2*tau))*M+A_mat;
[L_mat,U_mat]=lu(BDF2_matrix);
%BDF1系统矩阵（第一步使用）
BDF1_matrix=(1/tau)*M+A_mat;
[L_be,U_be]=lu(BDF1_matrix);
for m=1:Nt
if m==1
b=(1/tau)*M*u_pre;
u_now=U_be\(L_be\b);
else
b=(2/tau)*M*u_pre-(1/(2*tau))*M*u_pre2;
u_now=U_mat\(L_mat\b);
end
u_pre2=u_pre;
u_pre=u_now;
U_all(:,m+1)=u_now;
end
time=linspace(0,Nt*tau,Nt+1);
end