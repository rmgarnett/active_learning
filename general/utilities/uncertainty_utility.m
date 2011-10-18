function utility = uncertainty_utility(data, responses, test, ...
          probability_function)

  probabilities = probability_function(data, responses, test);
  utility = min(abs(probabilities - (1 / 2)));

end
