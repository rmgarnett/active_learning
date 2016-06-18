% ARGMAX queries the point(s) that maximizes a score function.
%
% This is a trivial query strategy that calls a user-provided score
% function on each of the points available for labeling and selects
% the point(s) with the maximum score.
%
% Several popular score functions are included in this software
% package; see score_functions.m for more information.
%
% Usage:
%
%   query_ind = argmax(problem, train_ind, observed_labels, test_ind, ...
%                      score_function, num_points)
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
%        num_points: (optional) the number of points to return
%                    (default: 1)
%
% Output:
%
%   query_ind: an index into problem.points indicating the point(s) to
%              query next
%
% See also ARGMIN, SCORE_FUNCTIONS, QUERY_STRATEGIES.

% Copyright (c) 2013--2014 Roman Garnett.

function query_ind = argmax(problem, train_ind, observed_labels, ...
          test_ind, score_function, num_points)

  % by default query a single point
  if (nargin < 6)
    num_points = 1;
  end

  scores = score_function(problem, train_ind, observed_labels, test_ind);

  % only call sort if needed
  if (num_points == 1)
    [~, best_ind] = max(scores);
  else
    [~, best_ind] = sort(scores, 'descend');
    best_ind = best_ind(1:num_points);
  end

  query_ind = test_ind(best_ind);

end