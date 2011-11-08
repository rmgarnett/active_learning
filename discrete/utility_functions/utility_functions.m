% utility functions measure the utility of a given dataest.
% utility functions have the interface:
%
% utility = utility_function(data, responses, train_ind)
%
% where:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: an index into responses indicating the training points
%
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011
