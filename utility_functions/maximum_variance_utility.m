% maximum variance loss function used by uncertainty sampling.
%
% u(D) = -\max_i (1 - p(argmax_y y_i = y | x_i, D))
%
% function utility = maximum_variance_utility(data, responses, train_ind, ...
%           probability_function)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses
%              train_ind: a list of indices into data/responses
%                         indicating the training points
%   probability_function: a handle to a probability function
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012

function utility = maximum_variance_utility(data, responses, train_ind, ...
          probability_function)

  test_ind = identity_selection_function(responses, train_ind);
  probabilities = probability_function(data, responses, train_ind, test_ind);
  utility = -max(abs(probabilities - (1 / 2)));

end
