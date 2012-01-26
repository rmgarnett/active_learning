% calculates expected utilities for any arbitrary utility function
%
% function expected_utilities = general_expected_utility(data, responses, ...
%           train_ind, test_ind, probability_function, utility_function)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses
%              train_ind: a list of indices into data/responses
%                         indicating the training points
%               test_ind: a list of indices into data/responses
%                         the test points
%   probability_function: a handle to a probability function
%       utility_function: a handle to a utility function
%
% outputs:
%   expected_utilities: a vector indicating the expected utility of
%                       adding each indicated test point to the
%                       dataset
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = general_expected_utility(data, responses, ...
          train_ind, test_ind, probability_function, utility_function)

  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = probability_function(data, responses, train_ind, test_ind);
  expected_utilities = zeros(num_test, 1);

  for i = 1:num_test
    fake_train_ind = [train_ind; test_ind(i)];
    fake_responses = responses;

    num_classes = max(responses);
    fake_utilities = zeros(num_classes, 1);

    for fake_response = 1:num_classes
      % add a fake observation for this test point and calculate the
      % expected utility, calling this function recursively with new
      % point and (lookahead - 1)
      fake_responses(test_ind(i)) = fake_response;

      fake_utilities(test_ind(i)) = ...
          utility_function(data, fake_responses, fake_train_ind);
    end

    expected_utilities(i) = probabilities(i, :) * fake_utilities;
  end

end