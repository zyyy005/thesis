function [F, J] = getResJac(u, coeff_M, rhs, M, A, elements, freeMap, nu)
% 计算残差 F 和雅可比矩阵 J
%   u       - 当前解向量 (自由度)
%   coeff_M - 时间项系数 (如 1/dt 或 3/(2dt))
%   rhs     - 右端项 (来自之前时间层的贡献)
%   M, A    - 质量矩阵、刚度矩阵
%   elements,freeMap - 有限元网格信息
%   nu      - 粘性系数
    nDof=length(u);
    F=coeff_M*(M*u)+nu*(A*u)-rhs;
    J=coeff_M*M+nu*A;
    % 单元循环，添加非线性对流项及其雅可比
    N=size(elements, 1);
    for e=1:N
        n1=elements(e,1);
        n2=elements(e,2);
        g1=freeMap(n1);
        g2=freeMap(n2);
        u1=0; 
        u2=0;
        if g1 ~=0, u1=u(g1); 
        end
        if g2 ~=0, u2=u(g2);
        end
        % 局部对流残差向量 (2x1)
        du=u2-u1;
        c1=du*(u1/3+u2/6);
        c2=du*(u1/6+u2/3);
        c_loc=[c1; c2];
        % 局部对流雅可比矩阵 (2x2)
        Jc_loc=[-2/3*u1+1/6*u2,1/6*u1+1/3*u2;
                -1/3*u1-1/6*u2,-1/6*u1+2/3*u2];
        
        % 组装到全局
        % 残差
        if g1 ~=0, F(g1)=F(g1)+c_loc(1); 
        end
        if g2 ~=0, F(g2)=F(g2)+c_loc(2); 
        end
        % 雅可比
        for l=1:2
            gl=[g1, g2];
            gl=gl(l);
            if gl==0, continue;
            end
            for r= 1:2
                gr=[g1, g2];
                gr=gr(r);
                if gr==0, continue; 
                end
                J(gl, gr)=J(gl, gr)+Jc_loc(l, r);
            end
        end
    end
end