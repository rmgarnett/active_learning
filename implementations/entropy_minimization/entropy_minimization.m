% selects points so as to actively attempt to reduce the total
% entropy on the remaining unlabeled points.
%
% function [chosen_ind, utilities] = entropy_minimization(data, labels, ...
%           train_ind, probability_function, num_evaluations, lookahead, verbose)
%
% inputs:
%                   data: an (n x d) matrix of input data
%                 labels: an (n x 1) vector of labels
%              train_ind: an index into data/labels indicating the
%                         training points
%   probability_function: the probability function to use
%        num_evaluations: the number of points to select
%              lookahead: the number of setps to look ahead at each step
%                verbose: a boolean, true to print status after each
%                         evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%
% copyright (c) roman garnett, 2012

function [chosen_ind, utilities] = entropy_minimization(data, labels, ...
          train_ind, probability_function, num_evaluations, lookahead, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  score_function = @(data, labels, train_ind) -calculate_entropies(data, ...
          labels, train_ind, probability_function);
  utility_function = @(data, labels, train_ind) sum_utility(data, ...
          labels, train_ind, score_function);

  selection_functions{1} = @(data, labels, train_ind) ...
      identity_selector(labels, train_ind);
  
  [chosen_ind, utilities] = optimal_learning(data, labels, train_ind, ...
          utility_function, probability_function, selection_functions, ...
          lookahead, num_evaluations, verbose);
  
end
