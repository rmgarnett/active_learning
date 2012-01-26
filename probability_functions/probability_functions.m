% a probability function calculates the posterior probabilites for a
% selected set of test points given the current labeled training
% data. probability functions have the interface:
%
% probabilities = ...
%     probability_function(data, responses, train_ind, test_ind);
%
% inputs:
%           data: an (n x d) matrix of input data
%      responses: an (n x 1) vector of responses
%      train_ind: a list of indices into data/responses
%                 indicating the training points
%       test_ind: a list of indices into data/responses
%                 indicating the test points
%
% outputs:
%   probabilites: a matrix of posterior probabilities.  the kth
%                 column gives the posterior probabilities
%                 p(y = k | x, D) for reach of the indicated
%                 test points
%
% copyright (c) roman garnett, 2011--2012
