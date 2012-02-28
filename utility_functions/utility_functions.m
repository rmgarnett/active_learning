% utility functions measure the utility of a given dataest.  utility
% functions have the interface:
%
% utility = utility_function(data, responses, train_ind)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses indicating the
%              training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012