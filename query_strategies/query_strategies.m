% Query strategies select which of the points currently eligible for
% labeling (returned by a selector) should be observed next.
%
% Query strategies must satisfy the following interface:
%
%   query_ind = query_strategy(problem, train_ind, observed_labels, test_ind)
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
%
% Output:
%
%   query_ind: an index into problem.points indicating the point(s) to
%              query next (every entry in query_ind will always be
%              a member of the set of points in test_ind)
%
% The following query strategies are provided in this toolbox:
%
%                     argmax: samples the point(s) maximizing a given
%                             score function
%                     argmin: samples the point(s) minimizing a given
%                             score function
%   expected_error_reduction: samples the point giving lowest
%                             expected loss on unlabeled points
%            margin_sampling: samples the point with the smallest
%                             margin
%         query_by_committee: samples the point with the highest
%                             disagreement between models
%       uncertainty_sampling: samples the most uncertain point

% Copyright (c) 2014 Roman Garnett.
