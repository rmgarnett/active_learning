% a selection function considers the current labeled dataset and
% indicates which of the unlabeld points should be considered for
% addition at this time.  selection functions have the interface:
%
% test_ind = selection_function(data, responses, train_ind)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses indicating the
%              training points
%
% outputs:
%    test_ind: an list of indices into data/responses indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2012