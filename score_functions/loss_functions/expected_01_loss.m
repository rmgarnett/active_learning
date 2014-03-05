function loss = expected_01_loss(problem, train_ind, observed_labels, ...
          test_ind, model)

  probabilities = model(problem, train_ind, observed_labels, test_ind);

  loss = sum(1 - max(probabilities, [], 2));

end