% performs an active scanning experiment.
%
% function [chosen_ind, utilities] = active_scanning(data, labels, ...
%           train_ind, probability_function, lookahead, num_evaluations, verbose)
%
% inputs:
%                   data: an (n x d) matrix of input data
%                 labels: an (n x 1) vector of labels (class 1 is
%                         treated as "interesting")
%              train_ind: an index into data/labels indicating the
%                         training points
%   probability_function: a function handle providing a probability function
%              lookahead: the number of steps of lookahead to consider
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

function [chosen_ind, utilities] = active_scanning(data, labels, ...
          train_ind, probability_function, lookahead, num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  utility_function = @(data, labels, train_ind) ...
      expected_remaining_utility(data, labels, train_ind, ...
          probability_function);

  selection_functions{1} = @(data, labels, train_ind) ...
      identity_selector(labels, train_ind);

  [chosen_ind, utilities] = optimal_learning(data, labels, train_ind, ...
          utility_function, probability_function, selection_functions, ...
          lookahead, num_evaluations, verbose);

end