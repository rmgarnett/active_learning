% "meta" selector that intersects all points returned from a set of
% selectors.

function test_ind = intersection_selector(problem, train_ind, observed_labels, ...q
                                          selectors)

  test_ind = selectors{1}(problem, train_ind, observed_labels);
  for i = 2:numel(selectors)
    test_ind = intersect(test_ind, selectors{i}(problem, train_ind, observed_labels));
  end

end