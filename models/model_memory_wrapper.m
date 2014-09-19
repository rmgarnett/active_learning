function probabilities = model_memory_wrapper(problem, train_ind, ...
          observed_labels, test_ind, model)

  persistent last_train_ind last_observed_labels last_test_ind last_probabilities;

  if (isequal(train_ind,       last_train_ind)      && ...
      isequal(observed_labels, last_observed_labels) && ...
      isequal(test_ind,        last_test_ind))

    probabilities = last_probabilities;
    return;
  end

  probabilities = model(problem, train_ind, observed_labels, test_ind);

  last_train_ind       = train_ind;
  last_observed_labels = observed_labels;
  last_test_ind        = test_ind;
  last_probabilities   = probabilities;

end