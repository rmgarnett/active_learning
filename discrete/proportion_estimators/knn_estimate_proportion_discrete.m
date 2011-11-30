function [expected_proportion proportion_variance] = ...
      knn_estimate_proportion_discrete(data, responses, in_train, ...
          probability_function, num_replications)

  num_train = nnz(in_train);
  num_test = nnz(~in_train);
  total = num_train + num_test;

  probabilities = probability_function(data, responses, in_train, ...
          ~in_train);

  expected_proportion = ...
      (num_train / total)   * mean(responses(in_train)) + ...
      (num_test  / total)   * mean(probabilities(:));

  trial_estimates = zeros(num_replications, 1);
  
  parfor i = 1:num_replications
    r = randperm(num_train);
    trial_estimates(i) = mean(probability_function(data, responses, ...
            logical_ind(in_train, r(1:(floor(num_train / 2)))), ~in_train));
  end

  proportion_variance = ...
      (num_test  / total)^2 * var(trial_estimates);

end
