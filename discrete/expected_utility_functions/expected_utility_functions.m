% expected utility functions calculate the expected utility of adding
% a point to the dataset.  expected utility functions have the
% interface:
%
% expected_utilites = ...
%     expected_utility_function(data, responses, train_ind, test_ind)
%
% where
%                 data: an (n x d) matrix of input data
%            responses: an (n x 1) vector of 0 / 1 responses
%            train_ind: an index into data/responses indicating
%                       the training points
%             test_ind: an index into data/responses indicating
%                       the test points
%
%   expected_utilities: the expected utility of adding each of the
%                       test points to the dataset
%
% copyright (c) roman garnett, 2011