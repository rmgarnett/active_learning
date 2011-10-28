function utility = proportion_variance_utility_discrete(data, ...
          responses, in_train, proportion_estimation_function)

  [~, proportion_variance] = proportion_estimation_function(data, ...
          responses, in_train);
  utility = -proportion_variance;

end
