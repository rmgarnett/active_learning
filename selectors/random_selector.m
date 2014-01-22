% selects a random subset of points.
%
% function test_ind = random_selector(problem, num_test)
%
% inputs:
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%              points: an (n x d) data matrix for the avilable points
%
%   num_test: the number of test points to select
%
%                    Note: this input is ignored by random_selector.
%                    If desired, it can be replaced by an empty
%                    matrix.
%
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: this input is ignored by random_selector.
%                    If desired, it can be replaced by an empty
%                    matrix.
%
%          num_test: the number of test points to select
%
% output:
%    test_ind: a list of indices into problem.points indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2013

function test_ind = random_selector(problem, num_test)

  test_ind = randperm(size(problem.points, 1), num_test);

end