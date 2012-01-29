function [kernel_matrix, new_responses] = wl_subtree_kernel(data, ...
          responses, graph_ind)

  num_nodes = size(data, 1);
  num_graphs = max(graph_ind);

  label_set = unique(responses);
  num_labels = numel(label_set);

  signatures = zeros(num_nodes, num_labels + 1);
  signatures(:, 1) = responses;
  for i = 1:num_graphs
    ind = (graph_ind == i);
    labels = responses(ind);
    A = full(data(ind, ind));

    signatures(ind, 2:end) = ...
        histc(bsxfun(@times, A, labels), label_set)';
  end

  [~, ~, new_responses] = unique(signatures, 'rows');
  new_responses = new_responses + max(label_set);

  new_label_set = unique(new_responses);
  num_new_labels = numel(new_label_set);

  feature_vectors = zeros(num_graphs, num_labels + num_new_labels);
  for i = 1:num_graphs
    ind = (graph_ind == i);
    old_labels =     responses(ind);
    new_labels = new_responses(ind);

    feature_vectors(i, :) = histc([old_labels; new_labels], ...
                                  union(label_set, new_label_set));
  end

  kernel_matrix = feature_vectors * feature_vectors';
end
