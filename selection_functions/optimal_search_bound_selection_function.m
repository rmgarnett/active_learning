% function test_ind = optimal_search_bound_selection_function(data, ...
%           responses, train_ind, probability_function, utility_bound, ...
%           lookahead)
%
% selection function to pick out only those points that could have
% optimal l-step lookahead expected utility for the active search
% problem (corresponding to count_utility).
%
% inputs:
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
%              train_ind: an index into data/responses indicating
%                         the training points
%   probability_function: a function handle providing a probability function
%      probability_bound: a function handle probiding a probability
%                         bound (see expected_count_utility_bound)
%              lookahead: the number of steps of lookahead to consider
%
% outputs:
%    test_ind: an list of indices into data/responses
%              indicating the points to test
%
% copyright (c) roman garnett, 2011

function test_ind = optimal_search_bound_selection_function(data, ...
          responses, train_ind, probability_function, probability_bound, ...
          lookahead)

  test_ind = identity_selection_function(responses, train_ind);

  % find point with current maximum posterior probability
  probabilities = ...
      probability_function(data, responses, train_ind, test_ind);
  [p_star, one_step_optimal_ind] = max(probabilities);
  one_step_optimal_ind = test_ind(one_step_optimal_ind);

  % if we only look ahead one step, we only need to consider the
  % point with the maximum probability
  if (lookahead == 1)
    test_ind = one_step_optimal_ind;
    return;
  end

  % we will need to calculate the expected l-step utility for two
  % points. we create the necessary selection functions by using
  % this selection function recursively.
  selection_functions = cell(lookahead, 1);
  for i = 1:(lookahead - 1)
    selection_functions{i} = @(data, responses, train_ind) ...
        optimal_search_bound_selection_function(data, responses, ...
            train_ind, probability_function, probability_bound, i);
  end
  selection_functions{lookahead} = @(data, responses, train_ind) ...
      (one_step_optimal_ind);

  % expected utility function for these calculations
  expected_utility_function = @(data, responses, train_ind, test_ind) ...
      expected_count_utility(data, responses, train_ind, test_ind, ...
                             probability_function);

  % find the l-step expected utility of the point with current maximum
  % posterior probability
  p_star_expected_utility = find_optimal_point(data, responses, ...
          train_ind, selection_functions, probability_function, ...
          expected_utility_function, lookahead) - ...
      count_utility(responses, train_ind);

  % find the maximum (l-1)-step expected utility among the
  % currently unlabeled points
  one_fewer_step_optimal_utility = find_optimal_point(data, responses, ...
          train_ind, selection_functions, probability_function, ...
          expected_utility_function, lookahead - 1) - ...
      count_utility(responses, train_ind);

  % find a bound on the maximum (l-1)-step expected utility after
  % one more positive observation
  one_fewer_step_utility_bound = ...
      expected_count_utility_bound(data, responses, train_ind, ...
          test_ind, probability_bound, lookahead - 1, 1);

  % now a point with probability p can have l-step utility at most
  %
  %        p  * (1 + one_fewer_step_utility_bound   ) +
  %   (1 - p) *      one_fewer_step_optimal_utility
  %
  % and we use this to find a lower bound on p by asserting this
  % quantity must be greater than the l-step expected utility of
  % the point with current maximum probability.
  optimal_lower_bound = ...
      (p_star_expected_utility - one_fewer_step_optimal_utility) / ...
      (1 + one_fewer_step_utility_bound - one_fewer_step_optimal_utility);

  test_ind = test_ind(probabilities >= min(optimal_lower_bound, p_star));

end