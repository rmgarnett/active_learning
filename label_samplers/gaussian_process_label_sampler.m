function label_samples = gaussian_process_label_sampler(data, labels, ...
          train_ind, num_samples, hyperparameters, inference_method, ...
          mean_function, covariance_function, likelihood)

  jitter = 1e-4;
  
  test_ind = identity_selector(labels, train_ind);
  num_test = numel(test_ind);
  
  labels(labels ~= 1) = -1;
  
  hyperparameters.full_covariance = true;
  [~, ~, latent_mean, latent_covariance] = gp_test(hyperparameters, ...
          inference_method, mean_function, covariance_function, ...
          likelihood, data(train_ind, :), labels(train_ind), ...
          data(test_ind, :));

  latent_mean       = latent_mean';
  latent_covariance = latent_covariance + jitter * eye(num_test);
  latent_covariance = (latent_covariance + latent_covariance') / 2;
  
  latent_samples = mvnrnd(latent_mean, latent_covariance, num_samples);
  
  trial_probabilities = ...
      reshape(exp(likelihood([], num_samples, latent_samples(:), [])), ...
              num_samples, num_test)';

  label_samples = rand(size(trial_probabilities)) < trial_probabilities;

end
