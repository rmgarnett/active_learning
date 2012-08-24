function [expected_count, count_variance] = sampling_count_estimator(data, ...
          labels, train_ind, num_samples, label_sampler)

  test_ind = identity_selector(labels, train_ind);

  num_train = numel(train_ind);
  num_test  = numel(test_ind);
  total     = num_train + num_test;

  labels(labels ~= 1) = -1;
  
  hyperparameters.full_covariance = true;
  [~, ~, latent_mean, latent_covariance] = gp_test(hyperparameters, ...
          inference_method, mean_function, covariance_function, ...
          likelihood, data(train_ind, :), labels(train_ind), ...
          data(test_ind, :));

  latent_mean       = latent_mean';
  latent_covariance = latent_covariance + jitter * eye(num_test);
  
  latent_samples = mvnrnd(latent_mean, latent_covariance, num_samples);

  trial_probabilities = ...
      reshape(exp(likelihood([], num_samples, latent_samples(:), [])), ...
              num_samples, num_test);
  
  expected_proportion = ...
      (num_train / total)   * mean(labels(train_ind) == 1) + ...
      (num_test  / total)   * mean(trial_probabilities(:));
  proportion_variance = ...
      (num_test  / total)^2 * var(mean(trial_probabilities, 2));

end
