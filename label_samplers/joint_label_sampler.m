function samples = joint_label_sampler(data, labels, train_ind, ...
          probability_function, num_samples)

  test_ind = identity_selector(labels, train_ind);

  num_points = size(data, 1);
  num_labels = max(labels);
  num_train  = numel(train_ind);
  num_test   = numel(test_ind);

  samples = zeros(num_points, num_samples);
  parfor i = 1:num_samples
    this_labels    = labels;
    this_train_ind = train_ind;

    permutation = randperm(num_test);
    for j = 1:num_test
      ind = test_ind(permutation(j));

      probabilities = ...
          probability_function(data, this_labels, this_train_ind, ind);

      this_labels(ind) = randsample(num_labels, 1, true, probabilities);
      this_train_ind = [this_train_ind; ind];
    end

    samples(:, i) = this_labels;
  end
  
end
