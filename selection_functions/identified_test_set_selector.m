% selects all points besides those in an identified test set.
%
% function test_ind = identity_selector(labels, train_ind, test_ind)
%
% inputs:
%      labels: an (n x 1) vector of labels
%   train_ind: a list of indices into data/labels indicating the
%              labeled points
%
% outputs:
%    test_ind: a list of indices into data/labels indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2012

function test_ind = identified_test_set_selector(problem, test_set_ind)

  num_points = size(problem.points, 1);

  test_ind = (1:num_points)';
  test_ind(test_set_ind)) = [];

end