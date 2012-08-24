function entropies = calculate_entropies(data, labels, train_ind, ...
          probability_function)

  test_ind = identity_selector(labels, train_ind);
  probabilities = probability_function(data, labels, train_ind, test_ind);
  entropies = -sum(probabilities .* log(probabilities), 2);
  
end