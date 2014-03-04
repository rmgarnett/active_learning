% A selector considers the current labeled dataset and indicates which
% of the unlabeled points should be considered for observation at this
% time.
%
% Selectors must satisfy the following interface:
%
%   test_ind = selector(problem, train_ind, observed_labels)
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
%
% Output:
%
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling
%
% The following general-purpose selectors are provided in this
% toolbox:
%
%   fixed_test_set_selector: selects all points besides a given test
%                            set
%       graph_walk_selector: confines an experiment to follow a path
%                            on a graph
%         identity_selector: selects all points
%           random_selector: selects a random subset of points
%        unlabeled_selector: selects points not yet observed
%
% In addition, the following "meta" selectors are provided, which
% combine or modify the outputs of other selectors:
%
%     complement_selector: takes the complement of a selector's output
%   intersection_selector: takes the intersection of the outputs of selectors
%          union_selector: takes the union of the outputs of selectors

% Copyright (c) 2011--2014 Roman Garnett.