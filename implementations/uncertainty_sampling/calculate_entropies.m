function entropies = calculate_entropies(data, responses, train_ind, ...
          test_ind, probability_function)

  unlabeled_ind = identity_selector(responses, train_ind);
  entropies = zeros(size(data, 1), 1);
  
  probabilities = probability_function(data, responses, train_ind, test_ind);
  entropies(test_ind) = -sum(probabilities .* log(probabilities), 2);
  entropies = entropies(unlabeled_ind);
  
end