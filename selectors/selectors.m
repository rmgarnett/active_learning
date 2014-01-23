% A selector considers the current labeled dataset and indicates which
% of the unlabeled points should be considered for observation at this
% time.
%
% Selectors have the following interface:
%
%   test_ind = selector(problem, train_ind, observed_labels)
%
% Inputs:
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
%
% Output:
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling

% Copyright (c) Roman Garnett, 2011--2014