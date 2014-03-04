% INTERSECTION_SELECTOR takes the intersection of the outputs of selectors.
%
% This provides a meta-selector that returns the intersection of the
% test points returned from each of a set of selectors. Note that this
% intersection may be empty!
%
% Usage:
%
%   test_ind = intersection_selector(problem, train_ind, observed_labels, ...
%           selectors)
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
%                    to intersect
%
% Output:
%
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling. Each index in test_ind
%             was selected by every provided selector.
%
% See also SELECTORS.

% Copyright (c) 2013--2014 Roman Garnett.

function test_ind = intersection_selector(problem, train_ind, ...
          observed_labels, selectors)

  test_ind = selectors{1}(problem, train_ind, observed_labels);
  for i = 2:numel(selectors)
    test_ind = intersect(test_ind, selectors{i}(problem, train_ind, observed_labels));
  end

end