% A score function computes an arbitrary score for each given test
% point that is in some way related to its influence or suitability
% for making an observation there. Score functions are typically
% converted into query strategies by either maximization (e.g. argmax)
% or minimization (e.g. argmin) over the points eligible for
% observation.
%
% Score function must satisfy the following interface:
%
%   scores = score_function(problem, train_ind, observed_labels, test_ind)
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
%                    the points eligible for observation
%
% Output:
%
%   scores: a vector of real-valued scores; one for each point
%           specified by test_ind
%
% The following score functions are provided in this toolbox:
%
%   expected_loss_lookahead: multiple-step lookahead expected loss
%                            arbitrary loss functions
%       expected_loss_naive: one-step lookahead expected loss for
%                            arbitrary loss functions
%                    margin: the predictive margin
%          marginal_entropy: the predictive entropy
%
% See also ARGMIN, ARGMAX.

% Copyright (c) 2014 Roman Garnett.
