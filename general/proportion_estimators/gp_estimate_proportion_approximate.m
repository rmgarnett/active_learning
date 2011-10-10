function [expected_proportion proportion_variance] = ...
      gp_estimate_proportion_approximate(data, responses, test, ...
          inference_method, mean_function, covariance_function, ...
          likelihood, hypersamples, num_samples, num_test_points, num_trials)

  expected_proportions = zeros(num_trials, 1);
  proportion_variances = zeros(num_trials, 1);

  num_test = size(test, 1);

  for i = 1:num_trials

    r = randperm(num_test);
    trial_test = test(r(1:num_test_points), :);
  
    [latent_means latent_covariances hypersample_weights] = ...
        estimate_latent_posterior(data, responses, trial_test, ...
                                  inference_method, mean_function, ...
                                  covariance_function, likelihood, ...
                                  hypersamples, true);
    
    [dimension, num_components] = size(latent_means);
    
    components = randsample(num_components, num_samples, true, hypersample_weights);
    latent_samples = zeros(num_samples, dimension);
    
    for j = 1:num_components
      latent_samples(components == j, :) = ...
          randnorm(sum(components == j), latent_means(:, j), ...
                   [], latent_covariances(:, :, j) + 1e-5 * eye(dimension))';
    end
    
    trial_probabilities = normcdf(latent_samples);
    
    expected_proportions(i) = mean(trial_probabilities(:));
    proportion_variances(i) = var(mean(trial_probabilities, 2));
  
  end

  expected_proportion = mean(expected_proportions);
  proportion_variance = mean(proportion_variances);

end
