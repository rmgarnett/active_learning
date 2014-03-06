% ARGMIN queries the point that minimizes a score function.
%
% This is a trivial query strategy that calls a user-provided score
% function on each of the points available for labeling and selects
% the point with the minimum score.
%
% Several popular score functions are included in this software
% package; see score_functions.m for more information.
%
% Usage:
%
%   query_ind = argmin(problem, train_ind, observed_labels, test_ind, ...
%                      score_function)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%             num_queries: the number of queries to make
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the points eligible for observation
%    score_function: a handle to a score function (see
%                    score_functions.m for interface)
%
% Output:
%
%   query_ind: an index into problem.points indicating the point to
%              query next
%
% See also ARGMAX, SCORE_FUNCTIONS, QUERY_STRATEGIES.

% Copyright (c) 2014 Roman Garnett.

function query_ind = argmin(problem, train_ind, observed_labels, ...
          test_ind, score_function)

  scores = score_function(problem, train_ind, observed_labels, test_ind);

  [~, best_ind] = min(scores);
  query_ind = test_ind(best_ind);

end