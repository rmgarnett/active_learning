function utility = optimal_utility(data, responses, test, ...
          proportion_estimation_function)
  
  [~, proportion_variance] = ...
      proportion_estimation_function(data, responses, test);
  
  utility = -proportion_variance;

end
