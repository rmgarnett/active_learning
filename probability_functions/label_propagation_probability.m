% copyright (c) roman garnett, 2011--2012

function probabilities = label_propagation_probability(A, node_labels, ...
          train_ind, test_ind, num_iterations)

  num_points  = size(A, 1);
  num_train   = numel(train_ind);
  num_classes = max(node_labels);

  % preallocate the rows in the label probability matrix for the
  % labeled nodes
  train_rows = zeros(num_train, num_classes);
  for i = 1:numel(train_ind)
    ind = train_ind(i);
    train_rows(i, node_labels(ind)) = 1;
  end

  probabilities = repmat(mean(train_rows), [num_points, 1]);

  for i = 1:num_iterations;
    % "pull-back" known labels
    probabilities(train_ind, :) = train_rows;
    probabilities = A * probabilities;
  end

  probabilities = probabilities(test_ind, :);
end