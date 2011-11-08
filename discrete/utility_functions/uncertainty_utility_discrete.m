function utility = uncertainty_utility_discrete(data, responses, ...
          train_ind, probability_function)

  probabilities = probability_function(data, responses, train_ind);
  utility = min(abs(probabilities - (1 / 2)));

end
