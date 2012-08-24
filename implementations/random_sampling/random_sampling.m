% performs random sampling given an arbitrary utility function.
%
% function [chosen_ind, utilities] = random_sampling(data, labels, ...
%           train_ind, utility_function, num_evaluations, verbose)
%
% inputs:
%                  data: an (n x d) matrix of input data
%                labels: an (n x 1) vector of labels
%             train_ind: an index into data/labels indicating the
%                        training points
%      utility_function: the utility function to use
%   selection_functions: a cell array of selection functions to
%                        use. only selection_functions{1} will be
%                        used.
%       num_evaluations: the number of points to select
%               verbose: a boolean, true to print status after
%                        each evaluation (default: false)
%
% outputs:
%   chosen_ind: a list of indices of the chosen datapoints, in order
%    utilities: the utility of the dataset after adding each
%               successive point in chosen_ind
%
% copyright (c) roman garnett, 2012

function [chosen_ind, utilities] = random_sampling(data, labels, ...
          train_ind, utility_function, selection_functions, ...
          num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  probability_function = [];
  lookahead = 0;

  [chosen_ind, utilities] = optimal_learning(data, labels, train_ind, ...
          utility_function, probability_function, selection_functions, ...
          lookahead, num_evaluations, verbose);

end
