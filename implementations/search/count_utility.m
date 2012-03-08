% simple "battleship" utility function.
%
%   u(D) = \sum_i \chi(y_i = 1)
%
% function utility = count_utility(responses, train_ind)
%
% inputs:
%   responses: an (n x 1) vector of responses (class 1 is
%              treated as "interesting")
%   train_ind: a list of indices into responses indicating
%              the training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012

function utility = count_utility(responses, train_ind)

  utility = nnz(responses(train_ind) == 1);

end
