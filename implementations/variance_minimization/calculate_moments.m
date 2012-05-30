function [means, variances] = calculate_moments(f, samples)

  num_samples = size(samples, 2);

  % initialize sums and sum_squares with a single sample
  values = f(samples(:, 1));
  sum_values  = values;
  sum_squares = values.^2;

  for i = 2:num_samples
    values = f(samples(:, i));
    sum_values  = sum_values  + values;
    sum_squares = sum_squares + values.^2;
  end

  means =     sum_values  / num_samples;
  variances = sum_squares / num_samples - means.^2;

  variances = max(variances, 0);
  
end
