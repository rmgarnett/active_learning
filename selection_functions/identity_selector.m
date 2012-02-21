% select all points.
%
% function test_ind = identity_selector(responses, train_ind)
%
% inputs:
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses
%              indicating the labeled points
%
% outputs:
%    test_ind: a list of into data/responses indicating
%              the points to test
%
% copyright (c) roman garnett, 2011--2012

function test_ind = identity_selector(responses, train_ind)

  test_ind = (1:numel(responses))';
  test_ind(train_ind) = [];

end