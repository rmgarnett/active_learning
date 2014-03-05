function utility = expected_accuracy(problem, train_ind, observed_labels, ...
          test_ind, model)

  probabilities = model(problem, train_ind, observed_labels, test_ind);
  utility = mean(max(probabilities, [], 2));

end