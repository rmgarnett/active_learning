% function [best_utility, best_ind] = find_optimal_point(data, responses, ...
%           train_ind, selection_functions, probability_function, ...
%           expected_utility_function, lookahead)
%
% finds the optimal next point to add to a dataset for active learning
% on a set of discrete points for a particular utility function and
% lookahead.  this function supports using user-defined:
%
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated. this
%   implementation allows multiple selection functions to be used,
%   should different ones be desired for different lookaheads.
% - probability functions, which assign probabilities to indicated
%   test data from the current training set
% - expected utility functions, which calculate the expected
%   utility of the dataset after adding one of a specified set of
%   points
%
% function [best_utility best_ind] = find_optimal_point(data, responses, ...
%          train_ind, selection_functions, probability_function, ...
%          expected_utility_function, lookahead)
%
% inputs:
%                        data: an (n x d) matrix of input data
%                   responses: an (n x 1) vector of responses
%                   train_ind: a list of indices into data/responses
%                              indicating the labeled points
%         selection_functions: a cell array of selection functions
%                              to use. if lookahead = k, then the
%                              min(k, numel(selection_functions))th
%                              element of this array will be used.
%        probability_function: the probability function to use
%   expected_utility_function: the expected utility function to use
%                   lookahead: the number of steps to look ahead
%
% outputs:
%   best_utility: the expected utility of the best point found
%       best_ind: the index of the best point found
%
% copyright (c) roman garnett, 2011--2012

function [best_utility, best_ind] = find_optimal_point(data, responses, ...
          train_ind, selection_functions, probability_function, ...
          expected_utility_function, lookahead)

  % allow array of selection functions and fall back if no entry
  % for current lookahead
  selection_function = ...
      selection_functions{min(lookahead, numel(selection_functions))};

  % base of the recursion, simply calculate expected utilities and
  % return best point
  if (lookahead == 1)
    % limit search to specified test points
    test_ind = selection_function(data, responses, train_ind);

    expected_utilities = expected_utility_function(data, responses, ...
            train_ind, test_ind);

    % return best point
    [best_utility, best_ind] = max(expected_utilities);
    best_ind = test_ind(best_ind);
    return;
  end

  % limit search to specified test points
  test_ind = selection_function(data, responses, train_ind);
  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = probability_function(data, responses, train_ind, test_ind);
  expected_utilities = zeros(num_test, 1);

  num_classes = max(responses);

  for i = 1:num_test
    fake_train_ind = [train_ind; test_ind(i)];
    fake_responses = responses;

    fake_utilities = zeros(num_classes, 1);

    for fake_response = 1:num_classes
      % add a fake observation for this test point and calculate the
      % expected utility, calling this function recursively with new
      % point and (lookahead - 1)
      fake_responses(test_ind(i)) = fake_response;

      fake_utilities(fake_response) = find_optimal_point(data, ...
              fake_responses, fake_train_ind, selection_functions, ...
              probability_function, expected_utility_function, lookahead - 1);
    end

    expected_utilities(i) = probabilities(i, :) * fake_utilities;
  end

  [best_utility best_ind] = max(expected_utilities);
  best_ind = test_ind(best_ind);
end