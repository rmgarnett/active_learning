% probability bound for a k-nearest-neighbor classifier. this
% function provides a bound for
%
% \max_i p(y_i | x_i, D)
%
% after adding additional points to the current training set,
% perhaps for use with probability_threshold_selection_function.
%
% function bound = knn_probability_bound(responses, train_ind, test_ind, ...
%           weights, max_weights, pseudocount, num_positives)
%
% inputs:
%            data: an (n x d) matrix of input data
%       responses: an (n x 1) vector of responses (class 1 is
%                  tested against "any other class")
%       train_ind: an index into data/responses indicating
%                  the training points
%        test_ind: an index into data/responses indicating
%                  the test points
%         weights: an (n x n) matrix of weights
%     max_weights: precomputed max(weights)
%     pseudocount: a value in [0, 1] to use as a "pseudocount"
%   num_positives: the number of additional positive responeses to
%                  consider
%
% outputs:
%   bound: an upper bound for the probabilities of the test data
%
% copyright (c) roman garnett, 2011--2012

function bound = knn_probability_bound(responses, train_ind, test_ind, ...
          weights, max_weights, pseudocount, num_positives)

  % given nothing else, consider having added one new positive observation
  if (nargin < 7)
    num_positives = 1;
  end

  % this method is limited to only binary classification
  if (any(responses > 2))
    warning('optimal_learning:multi_class_not_supported', ...
            ['svm_probability can only be used for binary problems! ' ...
             'will test class 1 vs "any other class."']);
  end
  
  % transform responses for knn classifier
  responses(responses ~= 1) = 0;

  this_weights = weights(test_ind, train_ind);
  total_weight = full(sum(this_weights, 2));

  max_weight = max(max_weights(test_ind));

  bound = max( ...
        (pseudocount + num_positives * max_weight + this_weights * responses(train_ind)) ./ ...
                  (1 + num_positives * max_weight + total_weight) ...
      );

end