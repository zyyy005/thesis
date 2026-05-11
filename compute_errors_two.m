function errors=compute_errors_two(u_numerical,u_exact,h)
error_vector=u_numerical-u_exact;
errors.L2=sqrt(h)*norm(error_vector);
errors.max=max(abs(error_vector));
errors.RMS=sqrt(mean(error_vector.^2));
errors.L1=h*sum(abs(error_vector));
end