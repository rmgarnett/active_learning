% performs sampling by iteratively selecting points maximizing a
% heuristic score function.
%
% function [chosen_ind, utilitiesm statistics] = uncertainty_sampling(data, ...
%           labels, train_ind, utility_function, probability_function, ...
%           num_evaluations, verbose)
%
% inputs:
%                data: an (n x d) matrix of input data
%              labels: an (n x 1) vector of labels
%           train_ind: an index into data/labels indicating the
%                      training points
%    utility_function: the utility function to use
%     num_evaluations: the number of points to select
%             verbose: a boolean, true to print status after each
%                      evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%   statistics: an array of structures containing performance
%               statistics after each point chosen
%
% copyright (c) roman garnett, 2012

function [chosen_ind, utilities, statistics] = uncertainty_sampling(data, ...
          labels, train_ind, utility_function, probability_function, ...
          base_selection_function, num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  score_function = @(data, labels, train_ind, test_ind) ...
      calculate_entropies(data, labels, train_ind, test_ind, ...
                          probability_function);
  selection_functions{1} = @(data, labels, train_ind) ...
      maximum_score_selector(data, labels, train_ind, ...
                             base_selection_function, score_function);
  lookahead = 0;
  
  [chosen_ind, utilities, statistics] = optimal_learning(data, labels, ...
          train_ind, utility_function, probability_function, ...
          selection_functions, lookahead, num_evaluations, verbose);
  
end