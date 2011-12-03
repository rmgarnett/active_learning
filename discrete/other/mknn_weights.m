function weights = mknn_weights(data, k, weight_function)

  num_observations = size(data, 1);

  [nearest_neighbors, distances] = knnsearch(data, data, 'k', k + 1);
  nearest_neighbors = nearest_neighbors(:, 2:end)';
  distances = distances(:, 2:end)';

  row_index = kron((1:num_observations)', ones(k, 1));
  distances = sparse(row_index, nearest_neighbors(:), distances(:), ...
                     num_observations, num_observations);
  weights = weight_function(distances);

  weights = min(weights, weights');

end