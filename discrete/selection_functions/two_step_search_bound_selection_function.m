% function test_ind = two_step_search_bound_selection_function(data, ...
%           responses, train_ind, probability_function, probability_bound)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
%              train_ind: an index into data/responses indicating
%                         the training points
%   probability_function: a function handle providing a probability function 
%      probability_bound: a function handle probiding a probability bound
%
% outputs:
%    test_ind: an list of indices into data/responses
%              indicating the points to test
%
% copyright (c) roman garnett, 2011

function test_ind = two_step_search_bound_selection_function(data, ...
          responses, train_ind, probability_function, probability_bound)

  test_ind = identity_selection_function(responses, train_ind);

  one_step_bound = ...
      probability_bound(data, responses, train_ind, test_ind);

  probabilities = ...
      probability_function(data, responses, train_ind, test_ind);
  [p_star, one_step_optimal_ind] = max(probabilities);

  one_step_optimal_ind = test_ind(one_step_optimal_ind);
  
  fake_train_ind = [train_ind; one_step_optimal_ind];
  fake_test_ind  = setdiff(test_ind, one_step_optimal_ind);
  fake_responses = responses;
  
  fake_responses(one_step_optimal_ind) = false;
  one_step_utilities_false = ...
      probability_function(data, fake_responses, fake_train_ind, fake_test_ind);
  p_star_false = max(one_step_utilities_false);

  fake_responses(one_step_optimal_ind) = true;
  one_step_utilities_true = ...
      probability_function(data, fake_responses, fake_train_ind, fake_test_ind);
  p_star_true = max(one_step_utilities_true);

  optimal_lower_bound = (p_star_false + p_star * (p_star_true - p_star_false)) / ...
                        (1 + one_step_bound - p_star);

  test_ind = unique([one_step_optimal_ind; ...
                     test_ind(probabilities >= optimal_lower_bound)]);

end