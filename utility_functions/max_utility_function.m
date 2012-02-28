% a simple utility function that is the max of the values returned by
% a user-defined auxillary function defined on the test points.
%
% function utility = max_utility_function(data, responses, train_ind, ...
%           objective_function)
%
% where
%                 data: an (n x d) matrix of input data
%            responses: an (n x 1) vector of responses
%            train_ind: a list of indices into data/responses
%                       indicating the training points
%   objective_function: a function handle providing a function with
%                       the interface
%
%                       values = objective_function(data, responses, ...
%                                                   train_ind)
%
%                       this function is expected to retrun a value
%                       for every data point not in train_ind, and
%                       ultimately the currently unlabeled point that
%                       maximizes this function will be chosen.
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2012

function utility = max_utility_function(data, responses, train_ind, ...
          objective_function)

  values = objective_function(data, responses, train_ind);
  utility = max(values);

end