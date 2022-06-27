function sim1 = sim_basic_ICA(seed,C,V,N,Acond,SNR)
%FUNCTION SIM1 = SIM_BASIC_ICA(SEED,SOURCE_NUM,FINAL_DIM,NUM_OBS,COND_NUM_MIXING,SNR)
% 
% Wrapper for generation of synthetic data according to ICA model.
%
% Arguments
% ----------
% seed : positive int, or empty array []
%     The random seed used for replication.
% source_num : positive int
%     The number of sources.
% final_dim : positive int
%     The final data (intrinsic) dimensionality.
% num_obs : positive int
%     The number of observations.
% cond_num_mixing : positive double >= 1
%     The condition number of the mixing matrix A.
%     1 yieds orthogonal mixing matrix.
%     Large values yield more ill-conditioned mixing matrices.
% snr : positive double
%     The signal-to-noise ratio.
%     Here, it is the noisy-data power divided by the noise power:
%       (data power + noise power) / noise power
%       e.g., (999+1)/1 = 1000 corresponds to 30dB
% 
% Returns
% -------
% sim1 : gsd object
%     A @gsd object containing all information about the generated.
% 
% Notes
% -----
% The @gsd object does NOT contain the final mixed data in order to save memory.
% The data can be generated using data = sim1.genX();

% Simplified assignment matrix:
S_      = mat2cell((1:C)', ones(C,1));
% Number of subspaces and datasets infered from S_:
[K, M_Tot] = size(S_);
% Number of sources per dataset:
C = [];
for mm = 1:M_Tot
    C = [C sum([S_{:,mm}] ~= 0)];
end
% Source distribution name and parameters:
for kk = 1:K
    dist_params(kk).name = 'mvl';
    dist_params(kk).mu   = zeros(sum([S_{kk,:}] ~= 0),1);
    dist_params(kk).CORR = 0.5; % Ignored for ICA
end
% Mixing matrix type
Atype   = 'Generated';
% Mixing matrix
A       = {}; % Empty singe Atype = 'Generated';
% UNUSED OPTIONS %%%%%%%%
predictors = 3:4;%{1:2, [], 1:2};
regtype = 'LS';
%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate synthetic data object
sim1    = gsd(seed, N, M_Tot, K, C, S_, dist_params, ...
    V, Atype, Acond, A, SNR, predictors, regtype);
