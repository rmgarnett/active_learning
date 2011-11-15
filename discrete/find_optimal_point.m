% function [best_utility best_ind] = find_optimal_point(data, responses, ...
%          train_ind, selection_function, probability_function, ...
%          expected_utility_function, lookahead)
%
% finds the optimal next point to add to a dataset for active learning
% on a set of discrete points for a particular utility function and
% lookahead.  this function supports using user-defined:
%
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated.
% - probability functions, which assign probabilities to indicated
%   test data from the current training set
% - expected utility functions, which calculate the expected
%   utility of the dataset after adding one of a specified set of
%   points
%
% inputs:
%                        data: an (n x d) matrix of input data
%                   responses: an (n x 1) vector of 0 / 1 responses
%                   train_ind: an index into data/responses
%                              indicating the starting labeled points
%          selection_function: the selection function to use
%        probability_function: the probability function to use
%   expected_utility_function: the expected utility function to use
%                   lookahead: the number of steps to look ahead
%
% outputs:
%   best_utility: the expected utility of the best point found
%       best_ind: the index of the best point found
%
% copyright (c) roman garnett, 2011

function [best_utility best_ind] = find_optimal_point(data, responses, ...
          train_ind, selection_function, probability_function, ...
          expected_utility_function, lookahead)

  % base of the recursion, simply calculate expected utilities and
  % return best point
  if (lookahead == 1)
    % limit search to specified test points
    test_ind = selection_function(data, responses, train_ind);
    expected_utilities = expected_utility_function(data, responses, ...
            train_ind, test_ind);

    % return best point
    [best_utility best_ind] = max(expected_utilities);
    best_ind = test_ind(best_ind);
    return;
  end

  % limit search to specified test points
  test_ind = selection_function(data, responses, train_ind);
  num_test = length(test_ind);

  % calculate the current posterior probabilities
  probabilities = probability_function(data, responses, train_ind, test_ind);
  expected_utilities = zeros(num_test, 1);
  
  parfor j = 1:num_test
    fake_train_ind = train_ind;
    fake_train_ind(test_ind(j)) = true;
    
    fake_responses = responses;
    
    % add a fake "true" observation for this test point and
    % calculate the expected utility, calling this function
    % recursively with new point and (lookahead - 1)
    fake_responses(test_ind(j)) = true;
    utility_true = find_optimal_point(data, fake_responses, ...
            fake_train_ind, selection_function, probability_function, ...
            expected_utility_function, lookahead - 1);
    
    % add a fake "false" observation for this test point and
    % calculate the expected utility, calling this function
    % recursively with new point and (lookahead - 1)
    fake_responses(test_ind(j)) = false;
    utility_false = find_optimal_point(data, fake_responses, ...
            fake_train_ind, selection_function, probability_function, ...
            expected_utility_function, lookahead - 1);
    
    % calculate the overall expected utility
    expected_utilities(j) = probabilities(j)  * utility_true + ...
                       (1 - probabilities(j)) * utility_false;
  end

  [best_utility best_ind] = max(expected_utilities);
  best_ind = test_ind(best_ind);
end