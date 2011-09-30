function utilities = uncertainty_utility(data, responses, in_train, ...
          probability_function)

  probabilities = probability_function(data, responses, in_train);
  utilities = -abs(probabilities - (1 / 2)); 

end
