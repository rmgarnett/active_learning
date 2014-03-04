% UNION_SELECTOR takes the union of the output of selectors.
%
% This provides a meta-selector that returns the union of the test
% points returned from each of a set of selectors.
%
% Usage:
%
%   test_ind = union_selector(problem, train_ind, observed_labels, selectors)
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
%         selectors: a cell array of function handles to selectors
%                    to combine
%
% Output:
%
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling. Each index in test_ind
%             was selected by at least one of the provided selectors.
%
% See also SELECTORS.

% Copyright (c) 2014 Roman Garnett.

function test_ind = union_selector(problem, train_ind, observed_labels, ...
          selectors)

  test_ind = selectors{1}(problem, train_ind, observed_labels);
  for i = 2:numel(selectors)
    test_ind = union(test_ind, selectors{i}(problem, train_ind, observed_labels));
  end

end