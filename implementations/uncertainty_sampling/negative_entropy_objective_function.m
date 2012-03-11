function values = negative_entropy_objective_function(data, responses, ...
          train_ind, probability_function)

  test_ind = identity_selector(responses, train_ind);

  probabilities = probability_function(data, responses, train_ind, test_ind);
  values = -sum(probabilities .* log(probabilities), 2);

end