% a probability function calculates the posterior probabilites for a
% selected set of test points given the current labeled training
% data. probability functions have the interface:
%
% probabilities = ...
%     probability_function(data, responses, train_ind, test_ind);
%
% where
%
%           data: an (n x d) matrix of input data
%      responses: an (n x 1) vector of 0 / 1 responses
%      train_ind: an index into data/responses indicating the
%                 training points
%       test_ind: an index into data/responses indicating the
%                 points to test
%
%   probabilites: the posterior probabilities p(y = 1 | x, D) for
%                 each of the indicated test points
%
% copyright (c) roman garnett, 2011
