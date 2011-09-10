function hypersample_weights = hypersample_weights(hypersamples)

  [quad_noise_sd, quad_input_scales, quad_output_scale] = ...
      hp_heuristics(hypersamples.values, hypersamples.log_likelihoods, 100);

  quad_gp.quad_noise_sd = quad_noise_sd;
  quad_gp.quad_input_scales = quad_input_scales;
  quad_gp.quad_output_scale = quad_output_scale;
  
  [num_hypersamples, num_hyperparameters] = size(hypersamples.values);
  
  for i = 1:num_hypersamples
    gp.hypersamples(i).hyperparameters = hypersamples.values(i, :);
  end
  
  for i = 1:num_hyperparameters
    gp.hyperparams(i).priorMean = hypersamples.prior_means(i);
    gp.hyperparams(i).priorSD = sqrt(hypersamples.prior_variances(i));
  end
  
  weights_mat = bq_params(gp, quad_gp);
  
  for i = 1:num_hypersamples
    gp.hypersamples(i).logL = hypersamples.log_likelihoods(i);
  end
  
  hypersample_weights = weights(gp, weights_mat);

end