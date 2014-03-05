function loss = expected_log_loss(problem, train_ind, ...
          observed_labels, test_ind, model)

  marginal_entropies = marginal_entropy(problem, train_ind, ...
          observed_labels, test_ind, model);

  loss = sum(marginal_entropies);

end