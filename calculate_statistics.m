function statistics = calculate_statistics(data, labels, train_ind, ...
          probability_function)

  test_ind = identity_selector(labels, train_ind);
  
  num_train   = numel(train_ind);
  num_test    = numel(test_ind);
  num_classes = max(labels);

  probabilities = probability_function(data, labels, train_ind, test_ind);
  [max_probabilities, predictions] = max(probabilities, [], 2);

  statistics.confusion_matrix      = accumarray([predictions, labels(test_ind)], 1, ...
                                                [num_classes, num_classes]);

  statistics.accuracy              = sum(diag(statistics.confusion_matrix)) / num_test;
  statistics.expected_accuracy     = mean(max_probabilities);
  statistics.total_accuracy        = num_train / (num_train + num_test) + ...
                                     num_test  / (num_train + num_test) * ...
                                     statistics.accuracy;
  
  statistics.marginal_entropy_sum  = sum(-sum(probabilities .* log(probabilities), 2));
  statistics.marginal_entropy_mean = statistics.marginal_entropy_sum / num_test;

  statistics.marginal_likelihood_sum  = ...
      sum(log(probabilities(sub2ind(size(probabilities), (1:num_test)', labels(test_ind)))));
  statistics.marginal_likelihood_mean = statistics.marginal_likelihood_sum / num_test;

  statistics.train_counts          = accumarray(labels(train_ind), 1, [num_classes, 1])';
  statistics.test_counts           = accumarray(labels(test_ind), 1, [num_classes, 1])';
  statistics.expected_counts       = sum(probabilities);
  statistics.count_errors          = (statistics.expected_counts - statistics.test_counts).^2;
  statistics.count_rmse            = sqrt(mean(statistics.count_errors));

  statistics.train_proportions     = statistics.train_counts    / num_train;
  statistics.test_proportions      = statistics.test_counts     / num_test;
  statistics.expected_proportions  = statistics.expected_counts / num_test;
  statistics.proportion_errors     = statistics.count_errors    / num_test^2;
  statistics.proportion_rmse       = statistics.count_rmse      / num_test;
  
end