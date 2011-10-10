function [expected_proportion proportion_variance] = ...
      gp_estimate_proportion(data, responses, test, inference_method, ...
                             mean_function, covariance_function, ...
                             likelihood, hypersamples, num_samples)
  
  jitter = 1e-5;

  [latent_means latent_covariances hypersample_weights] = ...
      estimate_latent_posterior(data, responses, test, inference_method, ...
                                mean_function, covariance_function, ...
                                likelihood, hypersamples, true);
  
  [dimension num_components] = size(latent_means);
  
  components = randsample(num_components, num_samples, true, hypersample_weights);
  latent_samples = zeros(num_samples, dimension);
  
  for i = 1:num_components
    latent_samples(components == i, :) = ...
        randnorm(sum(components == i), latent_means(:, i), ...
                 [], latent_covariances(:, :, i) + jitter * eye(dimension))';
  end
  
  trial_probabilities = normcdf(latent_samples);
  
  expected_proportion = mean(trial_probabilities(:));
  proportion_variance = var(mean(trial_probabilities, 2));

end
