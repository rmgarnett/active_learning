function utility = sum_top_lcb_utility(data, responses, train_ind, ...
          response_sampling_function, f, num_samples, sigma_multiplier, k)

  [means, variances] = calculate_moments(data, responses, train_ind, ...
          response_sampling_function, f, num_samples);

  lcbs = means - sigma_multiplier * sqrt(variances);
  sorted_lcbs = sort(lcbs, 'descend');

  utility = sum(sorted_lcbs(1:k));

end