function K = wl_kernel(graphs, h)

  num_graphs = numel(graphs);
  K = zeros(num_graphs, num_graphs);

  for i = 1:h
    % perform one more step of the WL transformation process
    [graphs, feature_vectors] = wl_transformation(graphs);

    K = K + feature_vectors * feature_vectors';
  end

end