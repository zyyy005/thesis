function u_exact=compute_exact_solution(x,t,A,alpha)
u_exact=(A/(pi^2*alpha)*(1-exp(-pi^2*alpha*t)))*sin(pi*x);
end