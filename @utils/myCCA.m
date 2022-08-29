function [outputArg] = myCCA(X,varargin)
%MYCCA implements basic CCA
%   Assume X is a cell array of length 2, each element is a dataset.
%   Detailed explanation goes here

if ~isempty(varargin)
    num_sources = varargin{1};
end

Rxx = corr(X{1}',X{2}');
% Rxx = (X{1}*X{2}')./(size(X{1},2)-1); % This is PLS?
num_sources = min(num_sources,rank(Rxx));
sub_dim = min(rank(Rxx), 5*num_sources);
[u,~,v] = svds(Rxx, num_sources, 'largest', ...
        'Tolerance', 1e-14, 'MaxIterations', 1000);
%         'SubspaceDimension', sub_dim, 'Tolerance', 1e-14, 'MaxIterations', 1000);

outputArg{1} = u';
outputArg{2} = v';
end

