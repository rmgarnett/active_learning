% calculates expected utilities for any arbitrary utility function
% that does not have a nice form.
%
% function expected_utilities = general_expected_utility(data, responses, ...
%           train_ind, test_ind, problem)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses indicating the
%              training points
%    test_ind: a list of indices into data/responses indicating the
%              test points
%     problem: a structure defining the active learning problem,
%              with fields:
%
%     probability_function: the probability function to use
%         utility_function: the utility function to use
%
% outputs:
%   expected_utilities: a vector indicating the expected utility of
%                       adding each indicated test point to the
%                       dataset
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = general_expected_utility(data, responses, ...
          train_ind, test_ind, problem)

  num_test = numel(test_ind);
  num_classes = max(responses);

  % calculate the current posterior probabilities
  probabilities = problem.probability_function(data, responses, train_ind, test_ind);

  expected_utilities = zeros(num_test, 1);
  for i = 1:num_test
    fake_train_ind = [train_ind; test_ind(i)];
    fake_responses = responses;

    fake_utilities = zeros(num_classes, 1);

    % add a fake observation for this test point with each class and
    % calculate the expected utility, calling this function
    % recursively with new point and (lookahead - 1)
    for fake_response = 1:num_classes
      fake_responses(test_ind(i)) = fake_response;

      fake_utilities(fake_response) = ...
          problem.utility_function(data, fake_responses, fake_train_ind);
    end

    expected_utilities(i) = probabilities(i, :) * fake_utilities;
  end

end