% QUERY_BY_COMMITTEE queries the point with highest disagreement.
%
% This is an implementation of "query by committee" using vote entropy
% to measure disagreement by models. The query by committee query
% strategy maintains an ensemble of models M and successively queries
% the point about which the ensemble members disagree the most. The
% idea is to greedily cut down the version space as quickly as
% possible.
%
% The disagreement between ensemble members can be measured in various
% ways, but the most popular method (and the one we implement here) is
% the so-called "vote entropy." Let M = {M_j} be a set of probability
% models, and let a point x and a set of observations D = (X, Y) be
% given. The ensemble probabilities are given by
%
%   p(y = i | x, D) = \sum_j w_j(D) p(y = i | x, D, M_j)
%                   / \sum_j w_j(D),
%
% where w(D) is a (possibly data-dependent) weight vector of length
% |M|.
%
% We may alternatively use so-called "hard" voting by the ensemble
% members, where in the above the posterior probabilities
%
%   p(y | x, D, M_j)
%
% are replaced by a Kronecker \delta distribution on the
% most-confident label according to model M_j:
%
%   \delta[ \argmax_i p(y = i | x, D, M_j) ].
%
% Finally, the vote entropy of M on x is the entropy of this marginal
% distribution:
%
%   H[y | x, D] = -\sum_i p(y = i | x, D) \log p(y = i | x, D).
%
% Traditionally, query by committee uses the "hard" voting strategy,
% but we support either here.
%
% Usage:
%
%    query_ind = query_by_committee(problem, train_ind, observed_labels, ...
%            test_ind, models, weights, hard_votes)
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
%                    in ensemble.m for details).
%                    (default: ones(1, |M|) / |M|)
%        hard_votes: a boolean indicating whether to use "hard" voting
%                    (default: false)
%
% Output:
%
%   query_ind: an index into problem.points indicating the point to
%              query next
%
% See also ENSEMBLE, MODELS.

% Copyright (c) 2014 Roman Garnett.

function query_ind = query_by_committee(problem, train_ind, ...
          observed_labels, test_ind, models, varargin)

  % query by committee is simply uncertainty sampling using an
  % ensemble prediction
  model = get_model(@ensemble, models, varargin{:});

  query_ind = uncertainty_sampling(problem, train_ind, observed_labels, ...
          test_ind, model);

end