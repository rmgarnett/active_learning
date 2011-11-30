% function expected_utilities = ...
%       expected_proportion_variance_utility_discrete(data, responses, ...
%           train_ind, test_ind, probability_function)
%
% calculates expected utilities for the "active surveying" utillity
% function
%
% u(D) = var[ \sum_i y_i | D ]
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
%              train_ind: an index into data/responses indicating
%                         the training data
%               test_ind: an index into data/responses indicating
%                         the test data
%   probability_function: a handle to a probability function
%
% outputs:
%     expected_utilities: a vector indicating the expected utility of
%                         adding each indicated test point to the
%                         dataset
%
% copyright (c) roman garnett, 2011

function expected_utilities = ...
      expected_proportion_variance_utility_discrete(data, responses, ...
          train_ind, test_ind, probability_function)

  probabilities = 

  expected_utilities = nnz(responses(train_ind)) + ...
      probability_function(data, responses, train_ind, test_ind);

end