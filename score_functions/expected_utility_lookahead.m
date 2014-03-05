% EXPECTED_UTILITY_LOOKAHEAD calculates "lookahed" expected utilities.
%
% This is an implementation of a score function that calculates the
% k-step-lookahead expected utilities of adding each of a given set of
% points to a dataset for a particular utility function and
% lookahead horizon k.
%
% This function supports using user-defined:
%
% - _Utility functions,_ which calculate the utility of a selected set
%   of points,
% - _Models,_ which assign probabilities to indicated test data from
%   the current training set, and
% - _Selectors_ which specify which among the unlabeled points should
%   have their expected utilities evaluated. This implementation
%   allows multiple selectors to be used, should different ones be
%   desired for different lookaheads.
%
% Note on utility functions:
%
% This function requires as an input a function, expected_utility,
% that will return the one-step-lookahead expected utilities of adding
% each of a given set of points to a dataset for the chosen utility
% function. That is, given a utility function u(D) for a dataset D =
% (X, Y) and a point x, this function should return
%
%   E_y[ u(D U {(x, y)}) | x, D] = ...
%                   \sum_{i = 1}^D p(y = i | x, D) u(D U {(x, i)})
%
% The API for this expected utility function is the same as for any
% score function:
%
%   expected_utilities = expected_utility(problem, train_ind, ...
%           observed_labels, test_ind)
%
% Sometimes this expectation over y may be calculated directly without
% enumerating all cases for y. If that is not possible, the function
% expected_utility_naive may be used with any arbitrary utility
% function to calculate this expectation naively (by augmenting the
% dataset D with (x, i) for each class i and weigting the resulting
% utilities by the probabiliy that y = i).
%%
% Usage:
%
%   expected_utilities = expected_utility_lookahead(problem, train_ind, ...
%           observed_labels, test_ind, model, expected_utility, ...
%           selectors, lookahead)
%
% Inputs:
%
%            problem: a struct describing the problem, containing fields:
%
%                   points: an n x d matrix describing the avilable points
%              num_classes: the number of classes
%              num_queries: the number of queries to make
%
%          train_ind: a list of indices into problem.points
%                     indicating the thus-far observed points
%    observed_labels: a list of labels corresponding to the
%                     observations in train_ind
%              model: a handle to probability model to use
%   expected_utility: a handle to the one-step expected utility
%                     function to use (see note above)
%          selectors: a cell array of selectors to use. If lookahead == k,
%                     then the min(k, numel(selection_functions))th
%                     element of this array will be used.
%          lookahead: the number of steps to look ahead. If
%                     lookahead == 0, then random expected utilities
%                     are returned.
%
% Output:
%
%   expected_utilities: the lookahead-step expected utilities for the
%                       points in test_ind
%
% See also UTILITIES, EXPECTED_UTILITY_NAIVE, SELECTORS, MODELS, SCORE_FUNCTIONS.

% Copyright (c) 2011--2014 Roman Garnett.

function expected_utilities = expected_utility_lookahead(problem, ...
          train_ind, observed_labels, test_ind, model, expected_utility, ...
          selectors, lookahead)

  num_test = numel(test_ind);

  % for zero-step lookahead, return random expected utilities
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

  % Used to recursively select test points. Allow array of selector and
  % fall back if no entry for current lookahead.
  selector = selectors{min(lookahead - 1, numel(selectors))};

  % Given one additional new point, we will always select the remaining
  % points by maximizing the (lookahead - 1) expected utility.
  lookahead_utility = @(problem, train_ind, observed_labels) ...
      max(expected_utility_lookahead(problem, train_ind, observed_labels, ...
          selector(problem, train_ind, observed_labels), model, ...
          expected_utility, selectors, lookahead - 1));

  % Use expected_utility_naive to evaluate the expected utility of the
  % given points.
  expected_utilities = expected_utility_naive(problem, train_ind, ...
          observed_labels, test_ind, model, lookahead_utility);

end