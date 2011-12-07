% probability bound for a k-nearest-neighbor classifier. this
% function provides a bound for
%
% \max_i p(y_i | x_i, D)
%
% after adding one additional point to the current training set,
% perhaps for use with probability_threshold_selection_function.
%
% inputs:
%          data: an (n x d) matrix of input data
%     responses: an (n x 1) vector of 0 / 1 responses
%     train_ind: an index into data/responses indicating
%                the training points
%      test_ind: an index into data/responses indicating
%                the test points
%       weights: an (n x n) matrix of weights
%   max_weights: precomputed max(weights)
%   pseudocount: a value in [0, 1] to use as a "pseudocount"
%
% outputs:
%   bound: an upper bound for the probabilities of the test data
%
% copyright (c) roman garnett, 2011

function bound = knn_probability_bound_discrete(responses, train_ind, ...
          test_ind, weights, max_weights, pseudocount)

  this_weights = weights(test_ind, train_ind);
  total_weight = sum(this_weights, 2);

  max_weight = max(max_weights(test_ind));
  
  bound = max( ...
        (pseudocount + max_weight + this_weights * responses(train_ind)) ./ ...
                  (1 + max_weight + total_weight) ...
      );

end