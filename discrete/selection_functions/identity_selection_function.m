% select all points.
%
% function test_ind = ...
%       identity_point_selection(responses, train_ind)
%
% inputs:
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: a list of indices into data/responses
%              indicating the labeled points
%
% outputs:
%    test_ind: a list of into data/responses indicating
%              the points to test
%
% copyright (c) roman garnett, 2011

function test_ind = ...
      identity_selection_function(responses, train_ind)

  test_ind = setdiff((1:numel(responses))', train_ind);

end