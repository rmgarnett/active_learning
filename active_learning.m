% performs optimal active learning on a set of discrete points for a
% particular utility function and lookahead.  this function supports
% using user-defined:
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
% function [chosen_ind, utilities, statistics] = optimal_learning(data, ...
%           labels, train_ind, utility_function, probability_function, ...
%           selection_functions, lookahead, num_evaluations, verbose)
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
%              lookahead: the number of steps to look ahead at each step
%        num_evaluations: the number of points to select
%                verbose: a boolean, true to print status after
%                         each evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%   statistics: an array of structures containing performance
%               statistics after each point chosen
%
% copyright (c) roman garnett, 2011--2012

function [chosen_ind, statistics] = active_learning(problem)

  % set verbose to false if not defined
    problemverbose = exist('verbose', 'var') && verbose;

  % wrap the user-provided probability function in a wrapper to
  % keep already calculated probabilities persistent
  if (isa(probability_function, 'function_handle') && ...
      ~strcmp(func2str(probability_function), ...
              'probability_function_memory_wrapper'))
    probability_function = @(data, labels, train_ind, test_ind) ...
        probability_function_memory_wrapper(data, labels, train_ind, ...
            test_ind, probability_function);
  end
  
  chosen_ind = zeros(num_evaluations, 1);
  
  for i = 1:num_evaluations
    if (verbose)
      tic();
      fprintf('point %i: ', i);
    end

    test_ind = selection_function(data, labels, train_ind);
    
    scores = score_function(data, labels, train_ind, 

    % find the optimal next point to add given the current training set
    % and chosen utility function
    [~, best_ind] = find_optimal_point(data, labels, train_ind, ...
            utility_function, probability_function, selection_functions, ...
            lookahead);

    % add the selected point and measure our current success
    chosen_ind(i) = best_ind;
    train_ind     = [train_ind; best_ind];
    statistics(i) = calculate_statistics(data, labels, train_ind, ...
                                         probability_function);

    if (verbose)
      elapsed = toc();
      fprintf(['lookahead: %i, ' ...
               'accuracy: %.2f, ' ...
               'took: %.2fs.\n'], ...
              lookahead, ...
              statistics(i).total_accuracy, ...
              elapsed ...
             );
    end
  end
end