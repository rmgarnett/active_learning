% 
%
% function bound = two_step_search_probability_bound(data, ...
%           responses, train_ind, test_ind, probability_function, ...
%           probability_bound)
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
%              train_ind: an index into data/responses indicating
%                         the training points
%               test_ind: an index into data/responses indicating
%                         the test points
%   probability_function: a function handle providing a probability function 
%      probability_bound: a function handle probiding a probability bound
%
% outputs:
%   bound: an upper bound for the probabilities of the test data
%
% copyright (c) roman garnett, 2011

function test_ind = two_step_search_bound_selection_function(data, ...
          responses, train_ind, probability_function, probability_bound)

  probabilities = ...
      probability_function(data, responses, train_ind, ~train_ind);
  [p_star, one_step_optimal_ind] = max(probabilities);

  one_step_optimal_ind = logical_ind(~train_ind, one_step_optimal_ind);
  
  fake_train_ind = train_ind;
  fake_test_ind  = ~train_ind;
  fake_responses = responses;
  
  fake_train_ind(one_step_optimal_ind) = true;
  fake_test_ind (one_step_optimal_ind) = false;
  
  fake_responses(one_step_optimal_ind) = false;
  one_step_utilities_false = ...
      probability_function(data, fake_responses, fake_train_ind, fake_test_ind);
  p_star_false = max(one_step_utilities_false);

  fake_responses(one_step_optimal_ind) = true;
  one_step_utilities_true = ...
      probability_function(data, fake_responses, fake_train_ind, fake_test_ind);
  p_star_true = max(one_step_utilities_true);

  one_step_bound = ...
      probability_bound(data, responses, train_ind, ~train_ind);

  optimal_lower_bound = (p_star_false + p_star * (p_star_true - p_star_false)) / ...
                        (1 + one_step_bound - p_star);

  test_ind = logical_ind(~train_ind, ...
                         unique([one_step_optimal_ind; ...
                                 find(probabilities >= optimal_lower_bound)]));
  
end