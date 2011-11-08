% function utility = count_utility_discrete(responses, train_ind)
%
% an implementation of the utility function interface for the
% simple "battleship" utility function
%
% u(D) = \sum_i y_i
%
% inputs:
%   responses: an (n x 1) vector of 0 / 1 responses
%   train_ind: an index into responses indicating the training points
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011

function utility = count_utility_discrete(responses, train_ind)

  utility = nnz(responses(train_ind));

end
