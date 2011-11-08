% select all points.
%
% function test_ind = identity_point_selection(train_ind)
%
% inputs:
%   train_ind: an index into data/responses indicating the 
%              training points
%
% outputs:
%    test_ind: an index into data/responses indicating the test
%              points to use
%
% copyright (c) roman garnett, 2011

function test_ind = identity_point_selection(in_train)
  
  test_ind = find(~in_train);

end