function A = get_tril_matrix(num_sources)

A = randn(num_sources);
A = tril(A);
diag_indices = sub2ind(size(A),1:num_sources,1:num_sources);
A(diag_indices) = 1;

end
