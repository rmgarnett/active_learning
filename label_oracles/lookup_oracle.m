% A trivial lookup-table label oracle. Given a query point, returns
% the corresponding label fromn a given list of fixed ground truth
% labels.
%
% function label = lookup_oracle(problem, query_ind, labels)
%
% inputs:
%     problem: a struct describing the problem, containing the fields:
%
%            points: an (n x d) data matrix for the available points
%       num_classes: the number of classes
%
%              Note: the first input is ignored by this function. If
%              desired, it can be replaced with an empty matrix. The
%              struct is documented only for reference below.
%
%   query_ind: an index into problem.points specifying the point to be
%              queried
%      labels: a length-n vector of ground-truth class labels for
%              each point in problem.points
%
% output:
%     label: an integer between 1 and problem.num_classes indicating
%            the observed label
%
% Copyright (c) Roman Garnett 2013--2014

function label = lookup_oracle(~, query_ind, labels)

  label = labels(query_ind);

end