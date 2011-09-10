function [latent_means latent_covariances hypersample_weights] = ...
      estimate_latent_posterior (data, responses, in_train, ...
                                 inference_method, mean_function, ...
                                 covariance_function, likelihood, ...
                                 hypersamples, full_covariance)

  num_hypersamples = size(hypersamples.values, 1);

  train_x = data(in_train, :);
  train_y = responses(in_train, :);
  
  test_x = data(~in_train, :);
  num_test = size(test_x, 1);

  latent_means = zeros(num_test, num_hypersamples);
  if (full_covariance)
    latent_covariances = zeros(num_test, num_test, num_hypersamples);
  else
    latent_covariances = zeros(num_test, 1, num_hypersamples);
  end
  log_likelihoods = zeros(num_hypersamples, 1);

  %parfor i = 1:num_hypersamples
  for i = 1:num_hypersamples
    
    hyp.lik = hypersamples.values(i, hypersamples.likelihood_ind);
    hyp.mean = hypersamples.values(i, hypersamples.mean_ind);
    hyp.cov = hypersamples.values(i, hypersamples.covariance_ind);
   
    if (full_covariance)
      [~, ~, latent_means(:, i), latent_covariances(:, :, i), ~, log_likelihoods(i)] = ...
          gp_test_full_covariance(hyp, inference_method, ...
                  mean_function, covariance_function, likelihood, ...
                  train_x, train_y, test_x);
    else
      [~, ~, latent_means(:, i), latent_covariances(:, :, i), ~, log_likelihoods(i)] = ...
          gp_test(hyp, inference_method, ...
                  mean_function, covariance_function, likelihood, ...
                  train_x, train_y, test_x);
    end

    if (full_covariance)
      latent_covariances(:, :, i) = ...
          (latent_covariances(:, :, i) + latent_covariances(:, :, i)') / 2;
    end

  end
    
  hypersamples.log_likelihoods = -log_likelihoods;
  hypersample_weights = calculate_hypersample_weights(hypersamples);

  latent_covariances = squeeze(latent_covariances);

end