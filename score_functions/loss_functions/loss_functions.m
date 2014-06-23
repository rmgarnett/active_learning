% Loss functions (also utility functions) compute the loss (or
% utility) associated with a given set of observations. These are
% typically used in active learning to, e.g., sample the point that,
% after being incorporated into the current set of observations,
% minimizes the expected final loss. Loss functions will typically not
% be used directly but rather by a score function computing expected
% losses (e.g., expected_loss_naive, expected_loss_lookahead) or
% expected utilities (e.g., expected_loss_naive,
% expected_loss_lookahead).
%
% Loss and utility functions must satisfy the following interface:
%
%      loss = loss_function(problem, train_ind, observed_labels)
%
% or
%
%   utility = utility_function(problem, train_ind, observed_labels)
%
% The only difference between the two is the semantic interpretation
% of the output: losses are typically to be minimized (e.g., with
% argmin) and utilities are typically to be maximized (e.g., with
% argmax).
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
%
% Output:
%
%      loss: the loss associated with the given set of observations
%
% or
%
%   utility: the utility associated with the given set of observations
%
% See also EXPECTED_LOSS_NAIVE, EXPECTED_LOSS_LOOKAHEAD,
% EXPECTED_UTILITY_NAIVE, EXPECTED_UTILITY_LOOKAHEAD.

% Copyright (c) 2014 Roman Garnett.
