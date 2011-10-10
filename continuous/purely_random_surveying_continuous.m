function [estimated_proportion proportion_variance chosen_points responses] = ...
      purely_random_surveying_continuous(sampling_function, response_function, ...
          num_evaluations)

  chosen_points = sampling_function(num_evaluations);
  responses = response_function(chosen_points);

  estimated_proportion = mean(responses);
  proportion_variance = 0;
end