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
%                         indicating the test points
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

    fake_responses(test_ind(i)) = true;
    fake_utility_true = utility_function(data, fake_responses, fake_train_ind);

    fake_responses(test_ind(i)) = false;
    fake_utility_false = utility_function(data, fake_responses, fake_train_ind);

    expected_utilities(i) = ...
             probabilities(i)  * fake_utility_true + ...
        (1 - probabilities(i)) * fake_utility_false;
  end

end