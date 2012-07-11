% a simple utility function that is the sum of the top values returned
% by a user-defined auxillary function.
%
% function utility = sum_top_scores_utility(data, labels, train_ind, ...
%           score_function, k)
%
% where
%             data: an (n x d) matrix of input data
%           labels: an (n x 1) vector of labels
%        train_ind: a list of indices into data/labels indicating the
%                   training points
%   score_function: a function handle providing a function with the
%                   interface
%
%                   scores = score_function(data, labels, train_ind)
%
%                   the sum of the top k returned scores is the utility.
%                k: the number of top scores to sum
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2012

function utility = sum_top_scores_utility(data, labels, train_ind, ...
          score_function, k)

  scores = sort(score_function(data, labels, train_ind), 'descend');

  utility = sum(scores(1:k));

end