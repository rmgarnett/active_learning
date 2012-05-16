function test_ind = graph_subset_selection_function(train_ind, graph_ind, graphs_to_select)

  test_ind = setdiff(find(ismember(graph_ind, graphs_to_select)), train_ind);

end