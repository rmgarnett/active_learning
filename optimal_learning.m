% performs optimal active learning on a set of discrete points for a
% particular utility function and lookahead.  this function supports
% using user-defined:
%
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated. this
%   implementation allows multiple selection functions to be used,
%   should different ones be desired for different lookaheads.
% - probability functions, which assign probabilities to indicated
%   test data from the current training set
% - expected utility functions, which calculate the expected utility
%   of the dataset after adding one of a specified set of points
% - utility functions, which calculate the utility of a selected set
%   of points
%
% function [chosen_ind, utilities] = optimal_learning(data, responses, ...
%           train_ind, problem, num_evaluations, lookahead, verbose)
%
% inputs:
%              data: an (n x d) matrix of input data
%         responses: an (n x 1) vector of responses
%         train_ind: a list of indices into data/responses indicating the
%                    starting labeled points
%           problem: a structure defining the active learning problem,
%                    with fields:
%
%           selection_functions: a cell array of selection functions
%                                to use. if lookahead = k, then the
%                                min(k, numel(selection_functions))th
%                                element of this array will be used.
%          probability_function: the probability function to use
%     expected_utility_function: the expected utility function to use
%              utility_function: the utility function to use
%                   num_classes: the number of classes in the
%                                classification problem
%
%   num_evaluations: the number of points to select
%         lookahead: the number of steps to look ahead
%           verbose: true to print status after each evaluation
%                    (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%
% copyright (c) roman garnett, 2011--2012

function [chosen_ind, utilities] = optimal_learning(data, responses, ...
          train_ind, problem, num_evaluations, lookahead, verbose)

  verbose = (nargin == 7) && verbose;

  chosen_ind = zeros(num_evaluations, 1);
  utilities = zeros(num_evaluations, 1);

  for i = 1:num_evaluations
    if (verbose)
      start = tic;
      fprintf('point %i: ', i);
    end

    % do not look past the maximum number of evaluations
    lookahead = min(lookahead, num_evaluations - i + 1);

    % find the optimal next point to add given the current training set
    % and chosen utility function
    [~, best_ind] = find_optimal_point(data, responses, ...
            train_ind, problem, lookahead);

    % add the selected point and measure our current success
    chosen_ind(i) = best_ind;
    train_ind = [train_ind; best_ind];

    utilities(i) = problem.utility_function(data, responses, train_ind);

    if (verbose)
      elapsed = toc(start);
      fprintf(['lookahead: %i, ' ...
               'true utility: %.2f, ' ...
               'took: %.2fs.\n'], ...
              lookahead, ...
              utilities(i), ...
              elapsed ...
             );
    end
  end
end