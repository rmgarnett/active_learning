% UNCERTAINTY_SAMPLING queries the most uncertain point.
%
% This is an implementation of uncertainty sampling, a simple and
% popular query strategy. Uncertainty sampling successively queries
% the point with the highest marginal entropy:
%
%   x* = argmax H[y | x, D],
%
% where H[y | x, D] is the entropy of the marginal label
% distribution  p(y | x, D):
%
%   H[y | x, D] = -\sum_i p(y = i | x, D) \log(p(y = i | x, D)).
%
% Usage:
%
%   query_ind = uncertainty_sampling(problem, train_ind, observed_labels, ...
%           test_ind, model)
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
%             model: a function handle to a probability model
%
% Output:
%
%   query_ind: an index into test_ind indicating the point to query
%              next
%
% See also MODELS, MARGINAL_ENTROPY, QUERY_STRATEGIES.

% Copyright (c) 2014 Roman Garnett.

function query_ind = uncertainty_sampling(problem, train_ind, ...
          observed_labels, test_ind, model)

  score_function = get_score_function(@marginal_entropy, model);

  query_ind = argmax(problem, train_ind, observed_labels, test_ind, ...
                     score_function);

end