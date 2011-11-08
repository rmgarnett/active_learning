% maximum variance loss function used by uncertainty sampling
%
% u(D) = -\max_i var p(y_i = 1 | x_i, D)
%
% function utility = maximum_variance_utility_discrete(data, responses, ...
%           train_ind, probability_function)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: an index into responses indicating the training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011

function utility = maximum_variance_utility_discrete(data, responses, ...
          train_ind, probability_function)

  probabilities = probability_function(data, responses, train_ind, ~train_ind);
  utility = min(abs(probabilities - (1 / 2)));

end
