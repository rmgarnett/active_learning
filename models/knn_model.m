% binary k-nn classifier.  assuming the problem has n points, and W
% is an (n x n) matrix of pairwise weights, the probability of
% observing a "1" at y, given observations D = {(x, y)}:
%
%   p(y = 1 | x, D, \alpha, \beta) = ...
%                            E[ Beta(\alpha + S, \beta + F) ],
%
% where Beta(., .) is the beta distribution, \alpha and \beta are
% specified hyperparameters, and S/F are defined as:
%
%   S = \sum_{x' \in D, y'   =  1} W(x, x'),
%   F = \sum_{x' \in D, y' \neq 1} W(x, x').
%
% function probabilities = knn_probability(train_ind, observed_labels, ...
%           test_ind, weights, prior_alpha, prior_beta)
%
% inputs:
%         train_ind: a list of indices into weights indicating
%                    the training points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into weights indicating
%                    the test points
%           weights: an n x n matrix of weights
%       prior_alpha: the prior value for \alpha
%        prior_beta: the prior value for \beta
%
% outputs:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2012

function probabilities = knn_probability(train_ind, observed_labels, ...
          test_ind, weights, prior_alpha, prior_beta)

  % transform observed_labels to handle multi-class
  positive_ind = (observed_labels == 1);

  successes = sum(weights(test_ind, train_ind( positive_ind)), 2);
  failures  = sum(weights(test_ind, train_ind(~positive_ind)), 2);

  alpha = (prior_alpha + successes);
  beta  = (prior_beta  + failures);

  probabilities = alpha ./ (alpha + beta);

  % return probabilities for "class 1" and "not class 1"
  probabilities = [probabilities, (1 - probabilities)];

end