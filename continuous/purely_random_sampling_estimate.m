function [estimated_proportion proportion_variance chosen_points] = ...
      purely_random_sampling_estimate(sampling_function, response_function, ...
      num_evaluations)

  chosen_points = sampling_function(num_evaluations);
  
  estimated_proportion = mean((response_function(chosen_points) + ...
                               1) / 2);
  proportion_variance = 0;
end