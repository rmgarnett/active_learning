% function expected_utilities = general_expected_utility(data, responses, ...
%           train_ind, test_ind, probability_function, ...
%           utility_function)
%
% calculates expected utilities for any arbitrary utility function
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
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
% copyright (c) roman garnett, 2011

function expected_utilities = general_expected_utility(data, responses, ...
          train_ind, test_ind, probability_function, utility_function)

  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = probability_function(data, responses, train_ind, test_ind);
  expected_utilities = zeros(num_test, 1);

  parfor j = 1:num_test
    fake_train_ind = [train_ind; test_ind(j)];

    fake_responses = responses;

    % add a fake "truee" observation for this test point and calculate the
    % utility
    fake_responses(test_ind(j)) = true;
    utility_true =  utility_function(data, fake_responses, fake_train_ind);

    % add a fake "false" observation for this test point and calculate the
    % utility
    fake_responses(test_ind(j)) = false;
    utility_false = utility_function(data, fake_responses, fake_train_ind);

    % calculate the overall expected utility
    expected_utilities(j) = probabilities(j)  * utility_true + ...
                       (1 - probabilities(j)) * utility_false;
  end

end