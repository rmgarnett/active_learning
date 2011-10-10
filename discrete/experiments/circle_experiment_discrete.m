initialize;
set_circle_experiment_discrete_parameters;

for experiment = 1:num_experiments

  data = rand(num_observations, dimension);
  responses = false(num_observations, 1);

  for i = 1:size(centers, 1)
    responses = responses | ...
                (sum((data - repmat(centers(i, :), num_observations, 1)).^2, 2) ...
                 < radius^2);
  end

  actual_proportion = pi / 8;
  responses = 2 * responses - 1;

  in_train = false(num_observations, 1);
  in_train(1) = true;

  log_input_scale_prior_mean = -1.5;
  log_input_scale_prior_variance = 0.25;

  log_output_scale_prior_mean = 0;
  log_output_scale_prior_variance = 1;

  latent_prior_mean_prior_mean = 0;
  latent_prior_mean_prior_variance = 1;

  hypersamples.prior_means = ...
      [latent_prior_mean_prior_mean ...
       log_input_scale_prior_mean ...
       log_output_scale_prior_mean];

  hypersamples.prior_variances = ...
      [latent_prior_mean_prior_variance ...
       log_input_scale_prior_variance ...
       log_output_scale_prior_variance];

  hypersamples.values = find_ccd_points(hypersamples.prior_means, ...
          hypersamples.prior_variances);

  hypersamples.mean_ind = 1;
  hypersamples.covariance_ind = 2:3;
  hypersamples.likelihood_ind = [];
  hypersamples.marginal_ind = 1:3;

  hyperparameters.lik = hypersamples.values(1, hypersamples.likelihood_ind);
  hyperparameters.mean = hypersamples.values(1, hypersamples.mean_ind);
  hyperparameters.cov = hypersamples.values(1, hypersamples.covariance_ind);

  inference_method = @infEP;
  mean_function = @meanConst;
  covariance_function = @covSEiso;
  likelihood = @likErf;

  active_estimation_discrete;

  save([results_directory '/' num2str(experiment)]);

end