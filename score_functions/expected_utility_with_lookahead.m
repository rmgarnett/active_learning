% finds the optimal next point to add to a dataset for active learning
% on a set of discrete points for a particular utility function and
% lookahead.  this function supports using user-defined:
%
% - utility functions, which calculate the utility of a selected set
%   of points,
% - probability functions, which assign probabilities to indicated
%   test data from the current training set, and
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated. this
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
% outputs:
%   best_utility: the expected utility of the best point found
%       best_ind: the index of the best point found
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = ...
      expected_utility_with_lookahead(problem, train_ind, observed_labels, ...
                                      test_ind, probability, expected_utility, ...
                                      selectors, lookahead)

  num_test = numel(test_ind);

  % if lookahead = 0, pick a random point
  if (lookahead == 0)
    best_utility = inf;
    best_ind = test_ind(randi(num_test));
    return;
  end

  % calculate the current posterior probabilities
  probabilities = probability(problem, train_ind, observed_labels, test_ind);

  % we will calculate the expected utility of adding each dataset to the
  % training set by sampling over labels to create ficticious datasets
  % and measuring the expected utility of each.  we accomplish
  % lookahead by calling this function recursively to calculate the
  % expected utility at later levels.
  if (lookahead == 1)
    expected_utilities = expected_utility(problem, train_ind, ...
                                          observed_labels, test_ind);
    return;
  else

    % used to recursively select test points.  allow array of selector and fall
    % back if no entry for current lookahead.
    selector = selectors{min(max(1, lookahead), numel(selectors))};

    fake_observed_labels    = [observed_labels; nan];
    fake_train_ind          = [train_ind; nan];
    fake_expected_utilities = zeros(problem.num_classes, 1);

    expected_utilities = zeros(num_test, 1);
    for i = 1:num_test
      fake_train_ind(end) = test_ind(i);

      % sample over labels
      for fake_label = 1:problem.num_classes
        fake_observed_labels(end) = fake_label;

        fake_test_ind = selector(problem, fake_train_ind, fake_observed_labels);

        % recursive call
        fake_utilities(fake_label) = ...
            expected_utility_with_lookahead(problem, fake_train_ind, fake_observed_labels, ...
                                            fake_test_ind, probability, expected_utility, ...
                                            selectors, lookahead - 1);
      end

      % calculate expectation using current probabilities
      expected_utilities(i) = probabilities(i, :) * fake_utilities;
    end

  end

end