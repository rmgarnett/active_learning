% calculates the k-step expected utilities of adding each of a
% given set of points to a dataset for active learning on a set
% of discrete points for a particular utility function and
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
% inputs:
%           problem: a struct describing the problem, containing fields:
%
%                   points: an n x d matrix describing the avilable points
%              num_classes: the number of classes
%              num_queries: the number of queries to make
%
%         train_ind: a list of indices into problem.points
%                    indicating the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%           utility: a handle to the utility to use
%       probability: a handle to probability to use
%         selectors: a cell array of selectors to use. if lookahead == k,
%                    then the min(k, numel(selection_functions))th
%                    element of this array will be used.
%         lookahead: the number of steps to look ahead. if
%                    lookahead == 0, then random expected utilities
%                    are returned.
%
% outputs:
%   expected_utilities: the lookahead-step expected utilities for
%                       the points in test_ind
%
% copyright (c) roman garnett, 2011--2012

function expected_utilities = expected_utility(problem, train_ind, ...
          observed_labels, test_ind, probability, utility, selectors, ...
          lookahead)

  num_test = numel(test_ind);

  % for zero-step lookahead, return random expected utilities
  if (lookahead == 0)
    expected_utilities = rand(num_test, 1);
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
    this_expected_utility = @(train_ind, observed_labels) ...
        utility(problem, train_ind, observed_labels);
  else
    % used to recursively select test points.  allow array of selector and fall
    % back if no entry for current lookahead.
    selector = selectors{min(lookahead, numel(selectors))};

    this_expected_utility = @(train_ind, observed_labels) ...
        expected_utility(problem, train_ind, observed_labels, ...
                         selector(problem, train_ind, observed_labels), ...
                         probability, utility, selectors, lookahead - 1);
  end

  fake_observed_labels    = [observed_labels; nan];
  fake_train_ind          = [train_ind; nan];
  fake_expected_utilities = zeros(problem.num_classes, 1);

  expected_utilities = zeros(num_test, 1);
  for i = 1:num_test
    fake_train_ind(end) = test_ind(i);

    % sample over labels
    for fake_label = 1:problem.num_classes
      fake_observed_labels(end) = fake_label;

      fake_expected_utilities(fake_label) = ...
          this_expected_utility(fake_train_ind, fake_observed_labels);
    end

    % calculate expectation using current probabilities
    expected_utilities(i) = probabilities(i, :) * fake_expected_utilities;
  end

end