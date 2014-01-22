% A selector that selects all points besides those in an identified
% test set.
%
% function test_ind = fixed_test_set_selector(problem, train_ind, ...
%           observed_labels, test_set_ind)
%
% inputs:
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%              points: an (n x d) data matrix for the avilable points
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%
%                    Note: this input is ignored by fixed_test_set_selector.
%                    If desired, it can be replaced by an empty matrix.
%
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: this input is ignored by fixed_test_set_selector.
%                    If desired, it can be replaced by an empty matrix.
%
%      test_set_ind: a list of indicies into problem.points
%                    indicating the test set
%
% output:
%    test_ind: a list of indices into problem.points indicating the
%              points to consider for labeling
%
% Copyright (c) Roman Garnett, 2011--2014

function test_ind = fixed_test_set_selector(problem, ~, ~, test_set_ind)

  test_ind = identity_selector(problem, [], []);
  test_ind(test_set_ind) = [];

end