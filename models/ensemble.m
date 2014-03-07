% ENSEMBLE makes predictions using a weighted ensemble of models.
%
% This is an implementation of a weighted ensemble of models. Let M =
% {M_j} be a set of probability models, and let a point x and a set of
% observations D = (X, Y) be given. The ensemble probabilities are
% given by
%
%   p(y = i | x, D) = \sum_j w_j(D) p(y = i | x, D, M_j)
%                   / \sum_j w_j(D),
%
% where w(D) is a (possibly data-dependent) weight vector of length
% |M|.
%
% This implementation also supports so-called "hard" voting by the
% ensemble members, where in the above the posterior probabilities
%
%   p(y | x, D, M_j)
%
% are replaced by a Kronecker \delta distribution on the
% most-confident label according to model M_j:
%
%   \delta[ \argmax_i p(y = i | x, D, M_j) ].
%
% Usage:
%
%   probabilities = ensemble(problem, train_ind, observed_labels, ...
%                            test_ind, models, weights, hard_votes)
%
% Required Inputs:
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
%            models: a cell array of handles to probability models
%
% Optional Inputs:
%
%           weights: either a length-|M| vector of model weights or a
%                    function handle returning such a vector (see note
%                    below for details).
%                    (default: ones(1, |M|) / |M|)
%        hard_votes: a boolean indicating whether to use "hard" voting
%                    (default: false)
%
% Output:
%
%   probabilities: a matrix of posterior probabilities. The ith
%                  column gives p(y = i | x, D) for each of the
%                  indicated test points.
%
% Note on Model Weights:
%
% This implementation supports both fixed and data-dependent model
% weights w(D). The latter might be useful to, for example, weight
% ensemble members by an estimate of their accuracy or by an estimate
% of their posterior probabilities in a Bayesian fashion.
% Data-dependent weights are implemented by providing a function
% handle to a weight function which will be called as
%
%   weights = weight_function(problem, train_ind, observed_labels, models),
%
% and must return a length-|M| vector of weights corresponding to the
% models in models.
%
% See also MODELS, QUERY_BY_COMMITTEE.

% Copyright (c) 2014 Roman Garnett.

function probabilities = ensemble(problem, train_ind, observed_labels, ...
          test_ind, models, weights, hard_votes)

  num_test   = numel(test_ind);
  num_models = numel(models);

  % default to uniform model weights
  if ((nargin < 6) || isempty(weights))
    weights = (1 / num_models) + zeros(1, num_models);
  end

  % default to "soft" votes
  if (nargin < 7)
    hard_votes = false;
  end

  % determine weight vector if weight function is provided
  if (isa(weights, 'function_handle'))
    weights = weights(problem, train_ind, observed_labels, models);
  end

  votes = zeros(num_test, problem.num_classes);

  for i = 1:num_models
    probabilities = models{i}(problem, train_ind, observed_labels, test_ind);

    if (hard_votes)
      % "hard" votes: each model votes only for its most-confident
      % prediction
      [~, this_votes] = max(probabilities, [], 2);

      votes = votes + weights(i) * ...
              accumarray([(1:num_test)', this_votes], 1, ...
                         [num_test, problem.num_classes]);

    else
      % "soft" votes: each model votes for each label with a weight equal to
      % its posterior probability
      votes = votes + weights(i) * probabilities;
    end
  end

  % normalize probabilities
  probabilities = bsxfun(@times, votes, 1 ./ sum(votes, 2));

end