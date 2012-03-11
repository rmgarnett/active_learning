function [means, variances] = calculate_moments(data, responses, ...
          train_ind, response_sampling_function, f, num_samples)

  response_samples = response_sampling_function(data, responses, ...
          train_ind, num_samples);

  % initialize sums and sum_squares with a single sample
  values = f(data, response_samples(:, 1));
  sum_values  = values;
  sum_squares = values.^2;

  for i = 2:num_samples
    values = f(data, response_samples(:, i));
    sum_values  = sum_values  + values;
    sum_squares = sum_squares + values.^2;
  end

  means =     sum_values  / num_samples;
  variances = sum_squares / num_samples - means.^2;

end
