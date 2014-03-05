function expected_utility = expected_accuracy(problem, train_ind, ...
          observed_labels, test_ind, model)

  probabilities = model(problem, train_ind, observed_labels, test_ind);
  expected_utility = mean(max(probabilities, [], 2));

end