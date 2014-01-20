% Calculates the k-step expected utilities of adding each of a
% given set of points to a dataset for active learning on a set
% of discrete points for a particular utility function and
% lookahead.  This function supports using user-defined:
%
% - utility functions, which calculate the utility of a selected set
%   of points,
% - models, which assign probabilities to indicated test data from the
%   current training set, and
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated. This
%   implementation allows multiple selection functions to be used,
%   should different ones be desired for different lookaheads.
%
% function [best_utility, best_ind] = find_optimal_point(data, labels, ...
%           train_ind, utility_function, probability_function, ...
%           selection_functions, lookahead)
%
% inputs:
%                   data: an (n x d) matrix of input data
%                 labels: an (n x 1) vector of labels
%              train_ind: a list of indices into data/labels
%                         indicating the starting labeled points
%       utility_function: the utility function to use
%   probability_function: the probability function to use
%    selection_functions: a cell array of selection functions to
%                         use. if lookahead = k, then the
%                         min(k, numel(selection_functions))th
%                         element of this array will be used.
%              lookahead: the number of steps to look ahead. if
%                         lookahead = 0, a random point is selected.
%
% output:
%   expected_utilities: the lookahead-step expected utilities for the
%                       points in test_ind
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = ...
      expected_utility_with_lookahead(problem, train_ind, observed_labels, ...
                                      test_ind, probability, expected_utility, ...
                                      selectors, lookahead)

  num_test = numel(test_ind);

  % if lookahead = 0, pick a random point
  if (lookahead == 0)
    expected_utilities = rand(num_test, 1);
    return;

  % for one-step lookahead, return values from base expected utility
  elseif (lookahead == 1)
    expected_utilities = expected_utility(problem, train_ind, ...
            observed_labels, test_ind);
    return;
  end

  % We will calculate the expected utility of adding each dataset to the
  % training set by sampling over labels to create ficticious datasets
  % and measuring the expected utility of each. We accomplish
  % lookahead by calling this function recursively to calculate the
  % expected utility at later levels.
  if (lookahead == 1)
    expected_utilities = expected_utility(problem, train_ind, ...
                                          observed_labels, test_ind);
    return;
  else

  % Used to recursively select test points. Allow array of selector and
  % fall back if no entry for current lookahead.
  selector = selectors{min(lookahead - 1, numel(selectors))};

  % Given one additional new point, we will always select the remaining
  % points by maximizing the (lookahead - 1) expected utility.
  lookahead_utility = @(problem, train_ind, observed_labels) ...
      max(expected_utility_with_lookahead(problem, train_ind, ...
          observed_labels, selector(problem, train_ind, observed_labels), ...
          probability, expected_utility, selectors, lookahead - 1));

  % Use expected_utility_naive to evaluate the expected utility of the
  % given points.
  expected_utilities = expected_utility_naive(problem, train_ind, ...
          observed_labels, test_ind, probability, lookahead_utility);

end