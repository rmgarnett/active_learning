% copyright (c) roman garnett, 2011--2012

function probabilities = segmented_probability_function(data, ...
          responses, train_ind, test_ind, classifier_ind, probability_function)

  num_test = numel(test_ind);
  num_classes = max(responses);

  probabilities = zeros(num_test, num_classes);

  classifiers = unique(classifier_ind);
  num_classifiers = numel(classifiers);

  for i = 1:num_classifiers
    ind = find(classifier_ind == classifiers(i));

    this_data = data(ind, :);
    this_responses = responses(ind, :);
    [~, ~, this_train_ind] = intersect(train_ind, ind);
    [~, result_ind, this_test_ind] = intersect(test_ind, ind);

    probabilities(result_ind, :) = probability_function(this_data, ...
            this_responses, this_train_ind, this_test_ind);
  end

end