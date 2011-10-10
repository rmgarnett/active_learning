function utilities = optimal_utility(data, responses, test, all_data, ...
          probability_function, proportion_estimation_function)

  num_test = size(test, 1);
  utilities = -Inf(num_test, 1);

  probabilities = probability_function(data, responses, test);

  parfor i = 1:num_test
    this_probability = probabilities(i);
    
    fake_data = [data; test(i, :)];

    fake_responses = [responses; 1];
    [~, proportion_variance_true] = ...
        proportion_estimation_function(fake_data, fake_responses, all_data);
    
    fake_responses(end) = -1;
    [~, proportion_variance_false] = ...
        proportion_estimation_function(fake_data, fake_responses, all_data);
    
    small_utilities(i) = -( ...
             this_probability  * proportion_variance_true + ...
        (1 - this_probability) * proportion_variance_false  ...
        );
  end

end
