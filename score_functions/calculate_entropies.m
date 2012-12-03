function entropies = calculate_entropies(data, labels, train_ind, test_ind, ...
          probability_function)

  probabilities = probability_function(data, labels, train_ind, test_ind);
  entropies = -sum(probabilities .* log(probabilities), 2);
  
end