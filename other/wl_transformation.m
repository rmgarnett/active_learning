function [new_graphs, feature_vectors] = wl_transformation(graphs)

  new_graphs = graphs;
  num_graphs = numel(graphs);

  total_nodes = 0;
  ranges = cell(num_graphs, 1);

  current_index = 0;
  for i = 1:num_graphs
    num_nodes = numel(graphs(i).labels);
    total_nodes = total_nodes + num_nodes;

    end_index = current_index + num_nodes;
    ranges{i} = (current_index + 1):(end_index);
    current_index = end_index;
  end

  all_labels = zeros(total_nodes, 1);
  for i = 1:num_graphs
    all_labels(ranges{i}) = graphs(i).labels;
  end

  labels = unique(all_labels);
  num_labels = numel(labels);
  label_counts = zeros(num_graphs, num_labels);

  signatures = zeros(total_nodes, num_labels + 1);
  signatures(:, 1) = all_labels;

  for i = 1:num_graphs
    this_labels = graphs(i).labels;
    this_A = graphs(i).A;
    range = ranges{i};

    label_counts(i, :) = histc(this_labels, labels);

    for j = 1:num_nodes
      neighbors = (this_A(j, :) > 0);
      signatures(range(j), 2:end) = histc(this_labels(neighbors), labels);
    end
  end

  [unique_signatures, blah, new_labels] = unique(signatures, 'rows');
  num_new_labels = size(unique_signatures, 1);

  feature_vectors = zeros(num_graphs, num_labels + num_new_labels);

  for i = 1:num_graphs
    this_new_labels = new_labels(ranges{i});

    new_graphs(i).labels = max(labels) + this_new_labels;
    feature_vectors(i, :) = ...
        [ ...
         label_counts(i, :) ...
         histc(this_new_labels, 1:num_new_labels)'
        ];
  end

end
