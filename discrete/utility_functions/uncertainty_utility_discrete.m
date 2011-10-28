function utility = uncertainty_utility_discrete(data, responses, ...
          in_train, probability_function)

  probabilities = probability_function(data, responses, in_train);
  utility = min(abs(probabilities - (1 / 2)));

end
