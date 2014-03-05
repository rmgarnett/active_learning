function expected_utilities = expected_utility_naive(problem, ...
          train_ind, observed_labels, test_ind, model, utility)

  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = model(problem, train_ind, observed_labels, test_ind);

  expected_utilities = zeros(num_test, 1);
  parfor i = 1:num_test
    fake_train_ind = [train_ind; test_ind(i)];

    % sample over labels
    fake_utilities = zeros(problem.num_classes, 1);
    for fake_label = 1:problem.num_classes
      fake_observed_labels = [observed_labels; fake_label];
      fake_utilities(fake_label) = ...
          utility(problem, fake_train_ind, fake_observed_labels);
    end

    % calculate expectation using current probabilities
    expected_utilities(i) = probabilities(i, :) * fake_utilities;
  end

end