function test_ind = farthest_point_selection(data, test, num_test_points)

  if (size(data, 1) > 1)
    min_distances = min(sq_dist(data', test'));
  else
    min_distances = sq_dist(data', test');
  end

  [~, ind] = sort(min_distances, 'descend');
  test_ind = ind(1:num_test_points);

end