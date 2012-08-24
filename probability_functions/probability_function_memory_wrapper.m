function probabilities = probability_function_memory_wrapper(data, ...
          labels, train_ind, test_ind, probability_function)

  persistent last_train_ind last_test_ind last_probabilities;
  
  if (isequal(train_ind, last_train_ind) && ...
      isequal(test_ind,  last_test_ind ))

    probabilities = last_probabilities;
    return;
  end

  probabilities = probability_function(data, labels, train_ind, test_ind);

  last_train_ind     = train_ind;
  last_test_ind      = test_ind;
  last_probabilities = probabilities;
  
end