% COMPLEMENT_SELECTOR takes the complement of a selector's output.
%
% This provides a meta-selector that returns the complement of
% the test points returned by another selector. Note: this set can
% be empty!
%
% Usage:
%
%   test_ind = complement_selector(problem, train_ind, observed_labels, selector)
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
%          selector: a function handle to a selector
%
% Output:
%
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling. Each index in test_ind
%             was not selected by the given selector.
%
% See also SELECTORS.

% Copyright (c) 2014 Roman Garnett.

function test_ind = complement_selector(problem, train_ind, observed_labels, ...
          selector)

  test_ind = identity_selector(problem, [], []);
  test_ind(selector(problem, train_ind, observed_labels)) = [];

end