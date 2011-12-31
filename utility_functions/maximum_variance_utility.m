% maximum variance loss function used by uncertainty sampling
%
% u(D) = -\max_i var p(y_i = 1 | x_i, D)
%
% function utility = maximum_variance_utility(data, responses, train_ind, ...
%           probability_function)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: a list of indices into data/responses
%              indicating the training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011

function utility = maximum_variance_utility(data, responses, train_ind, ...
          probability_function)

  test_ind = identity_selection_function(responses, train_ind);
  probabilities = probability_function(data, responses, train_ind, test_ind);
  utility = min(abs(probabilities - (1 / 2)));

end
