% a selection function considers the current labeled dataset and
% indicates which of the unlabeld points should be considered for
% addition at this time.  selection functions have the interface:
%
% test_ind = selection_function(problem, train_ind, observed_labels)
%
% inputs:
%           problem: a struct describing the problem, containing fields:
%
%                   points: an n x d matrix describing the avilable points
%              num_classes: the number of classes
%              num_queries: the number of queries to make
%
%         train_ind: a list of indices into problem.points
%                    indicating the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
% outputs:
%    test_ind: an list of indices into problem.points indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2013
