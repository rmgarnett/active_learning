% selects a random subset of points.
%
% function test_ind = random_selector(labels, train_ind, num_test_points)
%
% inputs:
%         labels: an (n x 1) vector of labels
%         train_ind: a list of indices into data/labels indicating the
%                    training points
%   num_test_points: the number of test points to select
%
% outputs:
%    test_ind: a list of indices into data/labels indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2012

function test_ind = random_selector(labels, train_ind, num_test_points)

  test_ind = identity_selector(labels, train_ind);
  num_test = numel(test_ind);
  r = randperm(num_test);

  % ensure we don't try to select more points than are available
  test_ind = test_ind(1:min(num_test, num_test_points));

end