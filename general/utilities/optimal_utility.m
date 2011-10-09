function utilities = optimal_utility(data, responses, test, ...
          probability_function, proportion_estimation_function)

  probabilities = probability_function(data, responses, test);

  num_test = size(test, 1);
  utilities = zeros(num_test, 1);

  parfor i = 1:num_test
    this_probability = probabilities(i);
    
    fake_data = [data; test(i, :)];

    fake_responses = [responses; 1];
    [~, proportion_variance_true] = proportion_estimation_function(data, ...
            fake_responses, test(i, :));
    
    fake_responses(end) = -1;
    [~, proportion_variance_false] = proportion_estimation_function(data, ...
            fake_responses, test(i, :));
    
    utilities(i) = -( ...
             this_probability  * proportion_variance_true + ...
        (1 - this_probability) * proportion_variance_false  ...
        );
  end

end
