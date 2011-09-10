function hypersamples = find_ccd_points(prior_means, prior_variances)

  dimension = length(prior_means);

  hypersamples = ccdesign(dimension, 'center', 1);
  hypersamples = hypersamples .* repmat(sqrt(prior_variances(:)'), size(hypersamples, 1), 1);
  hypersamples = hypersamples  + repmat(prior_means(:)', size(hypersamples, 1), 1);

end
