function [estimated_proportions proportion_variances data responses] ...
      = iterative_surveying_continuous(data, responses, label_function, ...
          optimization_function, utility_function, ...
          proportion_estimation_function, num_evaluations, verbose)
  
  if (nargin < 8)
    verbose = false;
  end

  estimated_proportions = zeros(num_evaluations, 1);
  proportion_variances = zeros(num_evaluations, 1);
  
  [num_points, dimension] = size(data);

  data = [data; zeros(num_evaluations, dimension)];
  responses = [responses; zeros(num_evaluations, 1)];
    
  for i = 1:num_evaluations
    if (verbose)
      tic;
    end
    
    range = 1:(num_points + (i - 1));
    objective_function = @(x) -utility_function(data(range, :), ...
            responses(range), x);

    best_point = optimization_function(objective_function);
    
    data(num_points + i, :) = best_point;
    responses(num_points + i) = label_function(best_point);
    
    [estimated_proportions(i) proportion_variances(i)] = ...
        proportion_estimation_function(data(range, :), responses(range));
   
    if (verbose)
      elapsed = toc;
      disp(['point ' num2str(i) ...
            ' of ' num2str(num_evaluations) ...
            ', current estimate: ' num2str(estimated_proportions(i)) ...
            ' +/- ' num2str(sqrt(proportion_variances(i))) ...
            ', took: ' num2str(elapsed) 's.']);
    end
  end

end