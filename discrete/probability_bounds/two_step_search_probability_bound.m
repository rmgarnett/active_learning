% general upper bound for minimal probability for a point to be the
% two-step optimal search action
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

function bound = two_step_search_probability_bound(data, ...
          responses, train_ind, test_ind, probability_function, ...
          probability_bound)

  one_step_utilities = ...
      probability_function(data, responses, train_ind, test_ind);
  [p_star, one_step_optimal_ind] = max(one_step_utilities);

  one_step_optimal_ind = logical_ind(test_ind, one_step_optimal_ind);
  
  fake_train_ind = train_ind;
  fake_test_ind  = test_ind;
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
      probability_bound(data, responses, train_ind, test_ind);

  bound = (p_star_false + p_star * (p_star_true - p_star_false)) / ...
          (1 + one_step_bound - p_star);
  
end