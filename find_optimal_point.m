% finds the optimal next point to add to a dataset for active learning
% on a set of discrete points for a particular utility function and
% lookahead.  this function supports using user-defined:
%
% - utility functions, which calculate the utility of a selected set
%   of points
% - probability functions, which assign probabilities to indicated
%   test data from the current training set
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated. this
%   implementation allows multiple selection functions to be used,
%   should different ones be desired for different lookaheads.
%
% function [best_utility, best_ind] = find_optimal_point(data, responses, ...
%           train_ind, utility_function, probability_function, ...
%           selection_functions, lookahead)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses
%              train_ind: a list of indices into data/responses
%                         indicating the starting labeled points
%    selection_functions: a cell array of selection functions to
%                         use. if lookahead = k, then the
%                         min(k, numel(selection_functions))th
%                         element of this array will be used.
%   probability_function: the probability function to use
%       utility_function: the utility function to use
%              lookahead: the number of steps to look ahead
%
% outputs:
%   best_utility: the expected utility of the best point found
%       best_ind: the index of the best point found
%
% copyright (c) roman garnett, 2011--2012

function [best_utility, best_ind] = find_optimal_point(data, responses, ...
          train_ind, utility_function, probability_function, ...
          selection_functions, lookahead)

  num_classes = max(responses);

  % select test points.  allow array of selection functions and fall
  % back if no entry for current lookahead.
  selection_function = ...
      selection_functions{min(lookahead, numel(selection_functions))};
  test_ind = selection_function(data, responses, train_ind);
  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = probability_function(data, responses, train_ind, test_ind);

  % we will calculate the expected utility of adding each dataset to the
  % training set by sampling over labels to create ficticious datasets
  % and measuring the expected utility of each.  we accomplish
  % lookahead by calling this function recursively to calculate the
  % expected utility at later levels.
  if (lookahead == 1)
    expected_utility_function = utility_function;
  else
    expected_utility_function = @(data, responses, train_ind) ...
        find_optimal_point(data, responses, train_ind, utility_function, ...
                           probability_function, selection_functions, ...
                           lookahead - 1);
  end

  % vectors to represent ficticious datasets, created once to avoid
  % overhead.
  fake_train_ind = [train_ind; nan];
  fake_responses = responses;
  fake_utilities = zeros(num_classes, 1);

  expected_utilities = zeros(num_test, 1);
  for i = 1:num_test
    ind = test_ind(i);

    % add this point to the dataset
    fake_train_ind(end) = ind;

    % sample over labels
    for fake_response = 1:num_classes
      fake_responses(ind) = fake_response;
      fake_utilities(fake_response) = ...
          expected_utility_function(data, fake_responses, fake_train_ind);
    end

    % calculate expectation using current probabilities
    expected_utilities(i) = probabilities(i, :) * fake_utilities;

    % put back real response into fake_responses for next point
    fake_responses(ind) = responses(ind);
  end

  % return the best point found from among the points tested
  [best_utility, best_ind] = max(expected_utilities);
  best_ind = test_ind(best_ind);
end