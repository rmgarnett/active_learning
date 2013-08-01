% meta probability that implements a 1-vs-all strategy for
% multiclass classification given a binary probability model.

function probabilities = one_versus_all_probability(problem, train_ind, ...
          observed_labels, test_ind, probability)

  num_test = numel(test_ind);

  probabilities = zeros(num_test, problem.num_classes);

  for i = 1:problem.num_classes
    this_observed_labels = zeros(size(observed_labels));
    this_observed_labels(observed_labels == i) = 1;
    this_observed_labels(observed_labels ~= i) = 2;

    this_probabilities = probability(problem, train_ind, ...
            this_observed_labels, test_ind);

    probabilities(:, i) = this_probabilities(:, 1);
  end

  probabilities = bsxfun(@times, 1 ./ sum(probabilities, 2), probabilities);

end