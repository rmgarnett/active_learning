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

function utility = top_probabilities_utility(data, responses, ...
          train_ind, probability_function, num_evaluations)

  num_train = numel(train_ind);

  test_ind = identity_selector(responses, train_ind);
  probabilities = ...
      probability_function(data, responses, train_ind, test_ind);

  sorted_probabilities = sort(probabilities(:, 1), 'descend');
  
  utility = nnz(responses(train_ind) == 1) + ...
            sum(sorted_probabilities(1:(num_evaluations - num_train)));

end