% implementation of the probability function interface for a
% k-nearest-neighbor classifier.
%
% function probabilities = knn_probability_discrete(responses, train_ind, ...
%           test_ind, nearest_neighbors, weights, pseudocount)
%
% inputs:
%               data: an (n x d) matrix of input data
%          responses: an (n x 1) vector of 0/1 responses
%          train_ind: an index into data/responses indicating
%                     the training points
%           test_ind: an index into data/responses indicating
%                     the test points
%  nearest_neighbors: an (n x n) logical matrix indicating nearest
%                     neighbors
%  nearest_neighbors: an (n x n) matrix of weights
%        pseudocount: a value in [0, 1] to use as a "pseudocount"
%
% outputs:
%   probabilities: a vector of posterior probabilities for the test data
%
% copyright (c) roman garnett, 2011

function probabilities = knn_probability_discrete(responses, train_ind, ...
          test_ind, nearest_neighbors, weights, pseudocount)
  
  this_weights = nearest_neighbors(test_ind, train_ind) .* ...
                           weights(test_ind, train_ind);

  total_weight = sum(this_weights, 2);
  
  probabilities = ...
      (this_weights * responses(train_ind) + pseudocount) ./ (total_weight + 1);
  
end