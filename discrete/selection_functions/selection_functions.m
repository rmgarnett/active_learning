% a selection function considers the current labeled dataset and
% indicates which of the unlabeld points should be considered for
% addition at this time.  selection functions have the interface:
%
% test_ind = selection_function(data, responses, train_ind);
%
% where
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: an index into data/responses indicating the
%              training points
%
%    test_ind: an index into data/responses indicating the
%              points to test
%
% copyright (c) roman garnett, 2011