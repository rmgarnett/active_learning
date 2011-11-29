% a probability bound provides a bound for what the maximum
% posterior probability
%
% \max_i p(y_i | x_i, D)
%
% after adding one additional point to the current training set. these
% can be combined with probability_threshold_selection_function.
% probability bounds provide the interface:
%
% bound = probability_bound(data, responses, train_ind, test_ind)
%
% where
%
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: an index into data/responses indicating the
%              training points
%    test_ind: an index into data/responses indicating the
%              points to test
%
%       bound: an upper bound for the probabilities of the test data
%
% copyright (c) roman garnett, 2011
