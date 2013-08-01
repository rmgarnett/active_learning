function probabilities = probability_memory_wrapper(train_ind, ...
                                                    observed_labels, ...
                                                    test_ind, probability)

  persistent last_train_ind last_observed_labels last_test_ind last_probabilities;

  if (isequal(train_ind,       last_train_ind)      && ...
      isequal(observed_labels, last_observed_labels) && ...
      isequal(test_ind,        last_test_ind))

    probabilities = last_probabilities;
    return;
  end

  probabilities = probability(train_ind, observed_labels, test_ind);

  last_train_ind       = train_ind;
  last_observed_labels = observed_labels;
  last_test_ind        = test_ind;
  last_probabilities   = probabilities;

end