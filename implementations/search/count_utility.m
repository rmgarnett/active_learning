% simple "battleship" utility function:
%
% u(D) = \sum_i \chi(y_i = 1)
%
% function utility = count_utility(labels, train_ind)
%
% inputs:
%      labels: an (n x 1) vector of labels (class 1 is
%              treated as "interesting")
%   train_ind: a list of indices into labels indicating
%              the training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012

function utility = count_utility(labels, train_ind)

  utility = nnz(labels(train_ind) == 1);

end
