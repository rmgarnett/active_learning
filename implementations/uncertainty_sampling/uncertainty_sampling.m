% performs sampling by iteratively selecting points maximizing a
% heuristic score function.
%
% function [chosen_ind, utilities] = score_based_sampling(data, labels, ...
%           train_ind, utility_function, score_function, num_evaluations, ...
%           verbose)
%
% inputs:
%               data: an (n x d) matrix of input data
%             labels: an (n x 1) vector of labels
%          train_ind: an index into data/labels indicating the
%                     training points
%   utility_function: the utility function to use
%    num_evaluations: the number of points to select
%            verbose: a boolean, true to print status after each
%                     evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%
% copyright (c) roman garnett, 2012

function [chosen_ind, utilities] = uncertainty_sampling(data, labels, ...
          train_ind, utility_function, probability_function, ...
          num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  score_function = @(data, labels, train_ind) entropy_score(data, ...
          labels, train_ind, probability_function);
  
  [chosen_ind, utilities] = score_based_sampling(data, labels, ...
          train_ind, utility_function, score_function, num_evaluations, ...
          verbose);
  
end