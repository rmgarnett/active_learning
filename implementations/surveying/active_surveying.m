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
%   statistics: an array of structures containing performance
%               statistics after each point chosen
%
% copyright (c) roman garnett, 2012

function [chosen_ind, utilities, statistics] = active_surveying(data, ...
        labels, train_ind, probability_function, count_estimator, ...
        num_evaluations, lookahead, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  utility_function = @(data, labels, train_ind) ...
      negative_count_variance_utility(data, labels, train_ind, count_estimator);

  selection_functions{1} = @(data, labels, train_ind) ...
      identity_selector(labels, train_ind);
  
  [chosen_ind, utilities, statistics] = optimal_learning(data, labels, ...
          train_ind, utility_function, probability_function, ...
          selection_functions, lookahead, num_evaluations, verbose);
  
end
