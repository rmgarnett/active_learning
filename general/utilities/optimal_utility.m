function utilities = optimal_utility(data, responses, test, all_data, ...
          probability_function, proportion_estimation_function)

  probabilities = probability_function(data, responses, test);

  parfor i = 1:size(test, 1)
    this_probability = probabilities(i);
    
    fake_data = [data; test(i, :)];

    fake_responses = [responses; 1];
    [~, proportion_variance_true] = ...
        proportion_estimation_function(fake_data, fake_responses, all_data);
    
    fake_responses(end) = -1;
    [~, proportion_variance_false] = ...
        proportion_estimation_function(fake_data, fake_responses, all_data);

    utilities(i) = -( ...
             this_probability  * sqrt(proportion_variance_true)  + ...
        (1 - this_probability) * sqrt(proportion_variance_false)  ...
        );
  end

end
