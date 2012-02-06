% calculates expected utilities for the maximum variance loss
% function used by uncertainty sampling.
%
% u(D) = -\max_i (1 - p(argmax_y y_i = y | x_i, D))
%
% function expected_utilities = expected_maximum_variance_utility(data, ...
%           responses, train_ind, test_ind, probability_function)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses
%              train_ind: a list of indices into data/responses
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

function expected_utilities = expected_maximum_variance_utility(data, ...
          responses, train_ind, test_ind, probability_function)

  probabilities = probability_function(data, responses, train_ind, test_ind);
  expected_utilities = -abs(probabilities - (1 / 2));

end