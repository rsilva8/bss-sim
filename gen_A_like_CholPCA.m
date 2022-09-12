function A = gen_A_like_CholPCA(X, num_sources)

total_datasets = length(X);
data_dim = [];
for dd = 1:total_datasets
    data_dim = [data_dim size(X{dd},1)];
end

% Apply Cholesky decomposition/factorization:
di_M = cell(1, total_datasets);
for dd = 1:total_datasets
    R = chol(cov(X{dd}'),'lower');
    di_M{dd} = inv(R);
end

% These are the PCA-like variances:
% for dd = 1:total_datasets
mix_std{1} = diag(2.^[linspace(-2.5,2.5,num_sources(1))]');
mix_std{2} = diag(2.^[linspace(3,-2,num_sources(2))]');
% end

% Rotation (ortogonal) matrix: R3
% This will be used to mix the signals further
R3 = cell(1, total_datasets);
for dd = 1:total_datasets
    tmp_rnd = randn(data_dim(dd), num_sources(dd));
    [u,s,v] = svds(tmp_rnd, num_sources(dd), 'largest', ...
        'SubspaceDimension', 5*num_sources(dd), 'Tolerance', 1e-14, 'MaxIterations', 1000);
    R3{dd} = u*v';
end

% The combined transformation:
A = cellfun(@(r3,s,d) r3*s*d, R3, mix_std, di_M, 'Un', 0);

