% utility function emphasizing few remaining "interesting" points.
%
% u(D) = E[#found - #interesting]
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
% copyright (c) roman garnett, 2012

function utility = expected_remaining_utility(data, labels, train_ind, ...
          probability_function)

  test_ind = identity_selector(labels, train_ind);
  probabilities = probability_function(data, labels, train_ind, test_ind);
  
  utility = -sum(probabilities(:, 1));

end
