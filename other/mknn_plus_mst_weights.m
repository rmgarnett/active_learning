function weights = mknn_plus_mst_weights(data, k, weight_function)

  num_observations = size(data, 1);

  [nearest_neighbors, distances] = knnsearch(data, data, 'k', k + 1);
  nearest_neighbors = nearest_neighbors(:, 2:end)';
  distances = distances(:, 2:end)';

  row_index = kron((1:num_observations)', ones(k, 1));
  distances = sparse(row_index, nearest_neighbors(:), distances(:), ...
                     num_observations, num_observations);
  weights = weight_function(distances);
  
  mst = logical(graphminspantree(weights > 0));
  mst = (mst | mst');

  mst_weights = weights(mst);
  weights = min(weights, weights');
  weights(mst) = mst_weights;
 
end