% A selector that selects those points not yet observed.
%
% function test_ind = unlabeled_selector(problem, train_ind, observed_labels)
%
% inputs:
%    problem: a struct describing the problem, containing the field:
%
%       points: an (n x d) data matrix for the avilable points
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: this input is ignored by unlabeled_selector.
%                    If desired, it can be replaced by an empty matrix.
%
% output:
%    test_ind: a list of indices into problem.points indicating the
%              points to consider for labeling
%
% Copyright (c) Roman Garnett, 2013--2014

function test_ind = unlabeled_selector(problem, train_ind, ~)

  test_ind = identity_selector(problem, [], []);
  test_ind(train_ind) = [];

end