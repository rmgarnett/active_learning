% KNN_MODEL binary weighted k-NN classifier.
%
% Assuming the problem has n points, and W is an (n x n) matrix of
% pairwise weights, the probability of observing a "1" at y, given
% observations D = {(x, y)} is given by:
%
%   p(y = 1 | x, D, \alpha, \beta) = ...
%                            E[ Beta(\alpha + S, \beta + F) ],
%
% where Beta(., .) is the beta distribution, \alpha and \beta are
% specified hyperparameters, and S/F (for "successes"/"failures") are
% defined as:
%
%   S = \sum_{x' \in D, y'   =  1} W(x, x');
%   F = \sum_{x' \in D, y' \neq 1} W(x, x').
%
% Usage:
%
%   probabilities = knn_model(problem, train_ind, observed_labels, ...
%                             test_ind, weights, prior_alpha, prior_beta)
%
% Inputs:
%
%           problem: a struct describing the problem, containing the
%                    field:
%
%              points: an (n x d) data matrix for the avilable points
%
%                    Note: this input, part of the standard
%                    probability model API, is ignored by
%                    knn_model. If desired, for standalone use it can
%                    be replaced by an empty matrix.
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%           weights: an (n x n) matrix of weights
%       prior_alpha: the prior value for \alpha
%        prior_beta: the prior value for \beta
%
% Output:
%
%   probabilities: a matrix of posterior probabilities. The first
%                  column gives p(y = 1 | x, D) for each of the
%                  indicated test points; the second column gives
%                  p(y \neq 1 | x, D).
%
% See also MODELS.

% Copyright (c) 2011--2014 Roman Garnett.

function probabilities = knn_model(~, train_ind, observed_labels, ...
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
