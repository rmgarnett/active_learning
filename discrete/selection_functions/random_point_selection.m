% selection function to select a random subset of points
%
% function test_ind = random_point_selection(train_ind, num_test_points)
%
% inputs:
%         train_ind: an index into data/responses indicating the 
%                    training points
%   num_test_points: the number of test points to select
%
% outputs:
%    test_ind: an index into data/responses indicating the test
%              points to use
%
% copyright (c) roman garnett, 2011

function test_ind = random_point_selection(train_ind, num_test_points)
  
  test_ind = find(~train_ind);
  num_test = nnz(test_ind);
  r = randperm(num_test);
  
  % ensure we don't try to select more points than are available
  test_ind = test_ind(r(1:min(num_test, num_test_points)));

end