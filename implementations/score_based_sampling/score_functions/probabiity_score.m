function scores = probabiity_score(data, labels, train_ind, ...
          probability_function)

  test_ind = identity_selector(labels, train_ind);
  scores = probability_function(data, labels, train_ind, test_ind);
  scores = scores(:, 1);
  
end