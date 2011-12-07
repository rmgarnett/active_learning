% select a random subset of points.
%
% function test_ind = ...
%       random_selection_function(train_ind, num_test_points)
%
% inputs:
%         responses: an (n x 1) vector of 0 / 1 responses
%         train_ind: a list of indices into data/responses
%                    indicating the training points
%   num_test_points: the number of test points to select
%
% outputs:
%    test_ind: a list of indices into data/responses
%              indicating the points to test
%
% copyright (c) roman garnett, 2011

function test_ind = ...
      random_selection_function(responses, train_ind, num_test_points)
  
  test_ind = identity_selection_function(responses, train_ind);
  num_test = numel(test_ind);
  r = randperm(num_test);
  
  % ensure we don't try to select more points than are available
  test_ind = r(1:min(num_test, num_test_points));

end