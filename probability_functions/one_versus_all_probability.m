function probabilities = one_versus_all_probability(data, labels, ...
          train_ind, test_ind, probability_function)

  num_test = numel(test_ind);
  num_classes = max(labels);

  probabilities = zeros(num_test, num_classes);
  
  for i = 1:num_classes
    this_labels = zeros(size(labels));
    this_labels(labels == i) = 1;
    this_labels(labels ~= i) = 2;

    this_probabilities = probability_function(data, this_labels, ...
            train_ind, test_ind);

    probabilities(:, i) = this_probabilities(:, 1);
  end

  probabilities = bsxfun(@times, 1 ./ sum(probabilities, 2), probabilities);
  
end