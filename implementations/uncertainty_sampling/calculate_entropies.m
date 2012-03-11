function entropies = calculate_entropies(data, responses, train_ind, ...
          probability_function)

  test_ind = identity_selector(responses, train_ind);

  probabilities = probability_function(data, responses, train_ind, test_ind);
  entropies = sum(probabilities .* log(probabilities), 2);

end