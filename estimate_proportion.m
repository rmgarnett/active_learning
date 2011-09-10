function [expected_proportion proportion_variance] = ...
    estimate_proportion(latent_means, latent_covariances, weights, num_samples)

  [dimension, num_components] = size(latent_means);
  
  components = randsample(num_components, num_samples, true, weights);
  latent_samples = zeros(num_samples, dimension);
  
  for i = 1:num_components
    latent_samples(components == i, :) = ...
      randnorm(sum(components == i), latent_means(:, i), ...
        [], latent_covariances(:, :, i) + 1e-5 * eye(dimension))';
  end
  
  trial_probabilities = normcdf(latent_samples);
  
  expected_proportion = mean(mean(trial_probabilities));
  proportion_variance = mean(mean(trial_probabilities .* (1 - trial_probabilities), 2));

end