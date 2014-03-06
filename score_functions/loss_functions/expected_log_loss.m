% EXPECTED_LOG_LOSS calcluates expected log loss given a training set.
%
% This function computes the expected total log loss on a set of
% points given a training set D = (X, Y):
%
%   \sum_{x \in U} H[y | x, D],
%
% where H[y | x, D] is the marginal entropy of the predictive
% distribution p(y | x, D) and U is the set of points whose labels
% are to be predicted.
%
% Usage:
%
%   loss = expected_log_loss(problem, train_ind, observed_labels, ...
%                            test_ind, model)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%             model: a handle to a probability model
%
% Output:
%
%   loss: the expected total log loss on the points in test_ind
%
% See also EXPECTED_ERROR_REDUCTION, MARGINAL_ENTROPY.

% Copyright (c) 2014 Roman Garnett.

function loss = expected_log_loss(problem, train_ind, observed_labels, ...
          test_ind, model)

  marginal_entropies = marginal_entropy(problem, train_ind, ...
          observed_labels, test_ind, model);

  loss = sum(marginal_entropies);

end