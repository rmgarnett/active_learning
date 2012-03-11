function utility = negative_maximum_std_utility(data, responses, ...
          train_ind, response_sampling_function, f, num_samples)

  [~, variances] = calculate_moments(data, responses, train_ind, ...
          response_sampling_function, f, num_samples);
  utility = -max(sqrt(variances(:)));

end