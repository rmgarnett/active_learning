% calculates the weisfeiler--lehman subtree graph kernel as
% described in
%
% Shervashidze, N., Schweitzer, P., Jan van Leeuwen, E., Mehlhorn, K.,
% and Borgwardt, K.M. (2010).  Weisfeiler--Lehman graph kernels.
% The Journal of Machine Learning Research, vol. 11, pp. 1--48.
%
% function kernel_matrix = wl_subtree_kernel(data, responses, graph_ind, h)
%
% inputs:
%
%        data: an (n x n) matrix where n is the total number of
%              nodes appearing in all graphs.  data should be a
%              block-diagonal matrix where the ith block
%              corresponds to the adjacency matrix of the ith
%              graph.  the graph_ind argument, below, provides an
%              index into data for conveniently extracting the
%              adjacency matrix for a specified graph.
%   responses: an (n x 1) vector containing the node labels of the
%              nodes appearing in all graphs.  node labels are
%              expected to be integers from 1..[num_classes]. the
%              entries in responses align with the rows of data, and
%              the graph_ind argument, below, can also be used to
%              index into responses to extract the node labels for a
%              specified graph.
%   graph_ind: an (n x 1) vector indicating which graph each row
%              (node) appearing in data/responses corresponds to.
%              the graphs are expected to be numbered with the
%              integers 1..[num_graphs].
%           h: an integer corresponding to the desired h parameter
%              as defined in the paper above.  if K_i represents
%              the kernel on the feature vectors resulting from the
%              ith application of the wl-subtree transformation,
%              then we return
%
%                 K_1(G, G) + K_2(G, G) + ... + K_h(G, G).
%
% outputs:
%
%   kernel_matrix: the resulting kernel matrix between the graphs.
%
% copyright (c) roman garnett, 2012.

function kernel_matrix = wl_subtree_kernel(data, responses, graph_ind, h)

  num_nodes = size(data, 1);
  num_graphs = max(graph_ind);

  kernel_matrix = zeros(num_graphs, num_graphs);

  iteration = 0;
  while (true)
    label_set = unique(responses);
    num_labels = numel(label_set);

    % the contribution to the graph feature vectors at every step
    % is simply the counts of each node label on the graph
    feature_vectors = zeros(num_graphs, num_labels);
    for i = 1:num_graphs
      ind = (graph_ind == i);
      labels = responses(ind);

      feature_vectors(i, :) = histc(labels, label_set);
    end

    % the kernel is the outer product of the feature vectors
    kernel_matrix = kernel_matrix + feature_vectors * feature_vectors';

    % exit after h applications of the WL transformation
    if (iteration == h)
      break;
    end

    % perform the WL transformation
    signatures = zeros(num_nodes, num_labels + 1);

    % the first entry of each node's signature is its current label
    signatures(:, 1) = responses;

    for i = 1:num_graphs
      % extract the labels and adjacency matrix for this graph only
      ind = (graph_ind == i);
      labels = responses(ind);
      A = full(data(ind, ind));

      % the signatures are the counts of the labels surrounding each node
      signatures(ind, 2:end) = histc(bsxfun(@times, A, labels), label_set)';
    end

    % perform signature compression
    [~, ~, responses] = unique(signatures, 'rows');

    iteration = iteration + 1;
  end
end