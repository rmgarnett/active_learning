% selects all points.
%
% function test_ind = identity_selector(problem)
%
% inputs:
%           problem: a struct describing the problem, containing the field:
%
%              points: an (n x d) data matrix for the avilable points
%
% outputs:
%    test_ind: a list of indices into problem.points indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2012

function test_ind = identity_selector(problem)

  test_ind = (1:size(problem.points, 1))';

end