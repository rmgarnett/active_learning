% RANDOM_SELECTOR selects a random subset of points.
%
%   test_ind = random_selector(problem, train_ind, observed_labels, ...
%                              num_test)
%
% Inputs:
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%              points: an (n x d) data matrix for the avilable points
%
%   num_test: the number of test points to select
%
%                    Note: this input is ignored by random_selector.
%                    If desired, it can be replaced by an empty matrix.
%
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: this input is ignored by random_selector.
%                    If desired, it can be replaced by an empty matrix.
%
%          num_test: the number of test points to select
%
% Output:
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling
%
% See also SELECTORS.

% Copyright (c) Roman Garnett, 2011--2014

function test_ind = random_selector(problem, num_test)

  test_ind = randperm(size(problem.points, 1), num_test);

end