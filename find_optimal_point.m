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
% function [best_utility, best_ind] = find_optimal_point(data, responses, ...
%           train_ind, problem, lookahead)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses indicating the
%              starting labeled points
%     problem: a structure defining the active learning problem,
%              with fields:
%
%           selection_functions: a cell array of selection functions
%                                to use. if lookahead = k, then the
%                                min(k, numel(selection_functions))th
%                                element of this array will be used.
%          probability_function: the probability function to use
%     expected_utility_function: the expected utility function to use
%              utility_function: the utility function to use
%
%   lookahead: the number of steps to look ahead
%
% outputs:
%   best_utility: the expected utility of the best point found
%       best_ind: the index of the best point found
%
% copyright (c) roman garnett, 2011--2012

function [best_utility, best_ind] = find_optimal_point(data, responses, ...
          train_ind, problem, lookahead)

  % allow array of selection functions and fall back if no entry
  % for current lookahead
  selection_function = ...
      problem.selection_functions{min(lookahead, numel(selection_functions))};

  % limit search to specified test points
  test_ind = selection_function(data, responses, train_ind);

  if (lookahead == 1)
    % base of the recursion, simply calculate expected utilities and
    % return best point
    expected_utilities = ...
        problem.expected_utility_function(data, responses, train_ind, test_ind);
  else
    % otherwise, look ahead. we will use the general expected utility
    % function for this purpose, with a utility function that is a
    % recursive call of this function.
    lookahead_problem = problem;
    lookahead_problem.utility_function = @(data, responses, train_ind) ...
        find_optimal_point(data, responses, train_ind, problem, lookahead - 1);

    expected_utilities = general_expected_utility(data, responses, ...
            train_ind, test_ind, lookahead_problem);
  end

  [best_utility, best_ind] = max(expected_utilities);
  best_ind = test_ind(best_ind);
end