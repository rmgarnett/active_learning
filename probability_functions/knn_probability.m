% binary k-nearest-neighbor classifier.
%
% function probabilities = knn_probability(responses, train_ind, ...
%           test_ind, weights, pseudocount)
%
% inputs:
%          data: an (n x d) matrix of input data
%     responses: an (n x 1) vector of responses (class 1 is tested
%                against "any other class")
%     train_ind: a list of indices into data/responses indicating
%                the training points
%      test_ind: a list of indices into data/responses indicating
%                the test points
%       weights: an (n x n) matrix of weights
%   pseudocount: a value in [0, 1] to use as a "pseudocount"
%
% outputs:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2012

function probabilities = knn_probability(responses, train_ind, ...
          test_ind, weights, pseudocount)

  this_weights = weights(test_ind, train_ind);
  total_weight = sum(this_weights, 2);

  probabilities = ...
      (pseudocount + this_weights * responses(train_ind)) ./ ...
                (1 + total_weight);

end