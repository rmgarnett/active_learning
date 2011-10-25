function probabilities = knn_probability_discrete(responses, in_train, ...
          test_ind, nearest_neighbors, weights, pseudocount)
  
  this_weights = nearest_neighbors(test_ind, in_train) .* ...
                 weights(test_ind, in_train);

  totals = sum(this_weights, 2) + 1;
  
  probabilities = ...
      (this_weights * responses(in_train) + pseudocount) ./ totals;
  
end