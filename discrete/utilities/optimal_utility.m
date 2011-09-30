function utilities = optimal_utility(data, responses, ...
          in_train, probability_function, proportion_estimation_function)

  probabilities = probability_function(data, responses, in_train);

  test_ind = find(~in_train);
  num_test = numel(test_ind);

  utilities = zeros(num_test, 1);

  parfor i = 1:num_test
    this_probability = probabilities(i);
    
    fake_in_train = in_train;
    fake_in_train(test_ind(i)) = true;
    
    fake_responses = responses;

    fake_responses(test_ind(i)) = 1;
    [~, proportion_variance_true] = proportion_estimation_function(data, ...
            fake_responses, fake_in_train);
    
    fake_responses(test_ind(i)) = -1;
    [~, proportion_variance_false] = proportion_estimation_function(data, ...
            fake_responses, fake_in_train);
    
    utilities(i) = -( ...
             this_probability  * proportion_variance_true + ...
        (1 - this_probability) * proportion_variance_false  ...
        );
  end

end
