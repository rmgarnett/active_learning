% selects all points not yet queried.

function test_ind = complement_selector(problem, train_ind)

  test_ind = identified_test_set_selector(problem, train_ind);

end