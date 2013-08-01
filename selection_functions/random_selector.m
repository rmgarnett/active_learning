% selects a random subset of points.
%
% function test_ind = random_selector(problem, num_test)
%
% inputs:
%    problem: a struct describing the problem, containing the field:
%
%      points: an n x d matrix describing the avilable points
%
%   num_test: the number of test points to select
%
% outputs:
%    test_ind: a list of indices into problem.points indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2013

function test_ind = random_selector(problem, num_test)

  test_ind = randperm(size(problem.points, 1), num_test);

end