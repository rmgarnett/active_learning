% performs optimal active learning on a set of discrete points for a
% particular utility function and lookahead.  this function supports
% using user-defined:
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
% function [chosen_ind, utilities] = optimal_learning(data, responses, ...
%           train_ind, utility_function, probability_function, ...
%           selection_functions, lookahead, num_evaluations, verbose)
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
%              lookahead: the number of steps to look ahead at each step
%        num_evaluations: the number of points to select
%                verbose: a boolean, true to print status after
%                         each evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%
% copyright (c) roman garnett, 2011--2012

function [chosen_ind, utilities] = optimal_learning(data, responses, ...
          train_ind, utility_function, probability_function, ...
          selection_functions, lookahead, num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  chosen_ind = zeros(num_evaluations, 1);
  utilities  = zeros(num_evaluations, 1);

  for i = 1:num_evaluations
    if (verbose)
      tic();
      fprintf('point %i: ', i);
    end

    % do not look past the maximum number of evaluations
    lookahead = min(lookahead, num_evaluations - i + 1);

    % find the optimal next point to add given the current training set
    % and chosen utility function
    [~, best_ind] = find_optimal_point(data, responses, ...
            train_ind, utility_function, probability_function, ...
            selection_functions, lookahead);

    % add the selected point and measure our current success
    chosen_ind(i) = best_ind;
    train_ind = [train_ind; best_ind];
    utilities(i) = utility_function(data, responses, train_ind);

    if (verbose)
      elapsed = toc();
      fprintf(['lookahead: %i, ' ...
               'utility: %.2f, ' ...
               'distribution: (%i / %i), ' ...
               'took: %.2fs.\n'], ...
              lookahead, ...
              utilities(i), ...
              nnz(responses(train_ind) == 1), ...
              numel(train_ind), ...
              elapsed ...
             );
    end
  end
end