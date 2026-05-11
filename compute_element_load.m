function F_elem=compute_element_load(x1, x2, A, h)
F_elem=zeros(2, 1);
xi_gauss=[-1/sqrt(3); 1/sqrt(3)];  
w_gauss=[1; 1];                    
for g=1:2
    xi=xi_gauss(g);      % 参考坐标 ξ ∈ [-1, 1]
    w=w_gauss(g);        % 权重
    x_phys=x1+(h/2)*(xi+1);
    phi=[(1-xi)/2; (1+xi)/2];
    f=A*sin(pi*x_phys);
    F_elem=F_elem+(h/2)*w*phi*f;
end
end