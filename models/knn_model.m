% KNN_MODEL weighted k-NN classifier.
%
% Suppose the problem has n points, and W is an (n x n) matrix of
% pairwise weights. We assume the marginal label distribution at a
% point x is a categorical distribution with probability vector p(x):
%
%   p(y | x) = Categorical(p(x)).
%
% We place identical Dirichlet priors on the p(x) vectors with
% hyperparameter vector \alpha:
%
%   p(p(x) | x, \alpha) = Dirichlet(\alpha).
%
% Finally, given observations D = {(X, Y)} and a point x, we update
% the posterior probability vector p(x) by accumulating weighted
% counts of the observations near x (where "near" is defined by the
% weight matrix W):
%
%   p(p(x) | x, D, \alpha) = Dirichlet(\alpha + C(x)),
%
% where
%
%   C_i(x) = \sum_{x' \in D, y' = i} W(x, x').
%
% Now, given x and D, we output the Categorical distribution with
% the posterior mean of p(x) given D:
%
%   p(y | x, D, \alpha) = Categorical( E[p(x) | x, D, \alpha] ).
%
% Usage:
%
%   probabilities = knn_model(problem, train_ind, observed_labels, ...
%                             test_ind, weights, alpha)
%
% Inputs:
%
%           problem: a struct describing the problem, containing the
%                    fields:
%
%                  points: an (n x d) data matrix for the avilable points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%           weights: an (n x n) matrix of weights
%             alpha: the hyperparameter vector \alpha
%                    (1 x problem.num_classes)
%
% Output:
%
%   probabilities: a matrix of posterior probabilities. The ith
%                  column gives p(y = i | x, D) for each of the
%                  indicated test points.
%
% See also MODELS.

% Copyright (c) 2011--2014 Roman Garnett.

function probabilities = knn_model(problem, train_ind, observed_labels, ...
          test_ind, weights, alpha)

  num_test = numel(test_ind);
  probabilities = zeros(num_test, problem.num_classes);

  % accumulate weighted number of successes for each class
  for i = 1:problem.num_classes
    probabilities(:, i) = alpha(i) + ...
        sum(weights(test_ind, train_ind(observed_labels == i)), 2);
  end

  % normalize probabilities
  probabilities = bsxfun(@times, probabilities, 1 ./ sum(probabilities, 2));

end
