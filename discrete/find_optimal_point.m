function [best_utility best_ind] = find_optimal_point(data, responses, ...
          in_train, selection_function, probability_function, ...
          expected_utility_function, lookahead)

  if (lookahead == 1)
    test_ind = selection_function(data, responses, in_train);
    expected_utilities = expected_utility_function(data, responses, ...
            in_train, test_ind);

    [best_utility best_ind] = max(expected_utilities);
    best_ind = test_ind(best_ind);
    return;
  end

  test_ind = selection_function(data, responses, in_train);
  num_test = length(test_ind);

  probabilities = probability_function(data, responses, in_train, test_ind);
  expected_utilities = zeros(num_test, 1);
  
  parfor j = 1:num_test
    fake_in_train = in_train;
    fake_in_train(test_ind(j)) = true;
    
    fake_responses = responses;
    
    fake_responses(test_ind(j)) = true;
    utility_true = find_optimal_point(data, fake_responses, ...
            fake_in_train, selection_function, probability_function, ...
            expected_utility_function, lookahead - 1);
    
    fake_in_train(test_ind(j)) = false;
    utility_false = find_optimal_point(data, fake_responses, ...
            fake_in_train, selection_function, probability_function, ...
            expected_utility_function, lookahead - 1);
    
    expected_utilities(j) = probabilities(j)  * utility_true + ...
                       (1 - probabilities(j)) * utility_false;
  end

  [best_utility best_ind] = max(expected_utilities);
  best_ind = test_ind(best_ind);
end