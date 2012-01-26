% calculates expected utilities for the simple "battleship" utillity
% function
%
% u(D) = \sum_i \chi(y_i = 1)
%
% function expected_utilities = expected_count_utility(data, responses, ...
%           train_ind, test_ind, probability_function)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses (class 1
%                         indicates "interesting")
%              train_ind: an index into data/responses
%                         indicating the training points
%               test_ind: a list of indices into data/responses
%                         indicating the test points
%   probability_function: a handle to a probability function
%
% outputs:
%   expected_utilities: a vector indicating the expected utility of
%                       adding each indicated test point to the
%                       dataset
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = expected_count_utility(data, responses, ...
          train_ind, test_ind, probability_function)

  probabilities = probability_function(data, responses, train_ind, test_ind);

  % expected utility is # ones in training set + p(y = 1 | x, D)
  expected_utilities = nnz(responses(train_ind) == 1) + probabilities(:, 1);

end