% selects only those points adjacent to the last observed point
% according to a specified graph.

function test_ind = graph_walk_selector(train_ind, A)

  test_ind = find(A(train_ind(end), :))';

end