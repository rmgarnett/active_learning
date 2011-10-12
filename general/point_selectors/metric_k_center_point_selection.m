function test_ind = metric_k_center_point_selection(test, num_centers)

  test_ind = 1;
  candidate_ind = 2:size(test, 1);

  for i = 2:num_centers
    min_distances = ...
        min(sq_dist(test(test_ind, :)', test(candidate_ind, :)'));
    
    [~, ind] = max(min_distances);
    test_ind = [test_ind ind];
    candidate_ind(ind) = [];
  end

end