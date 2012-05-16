function test_ind = rotating_graph_selection_function(train_ind, graph_ind)

  num_graphs = max(graph_ind);
  graph_to_select = 1 + mod(numel(train_ind), num_graphs);
  
  test_ind = graph_subset_selection_function(train_ind, graph_ind, graph_to_select);

end