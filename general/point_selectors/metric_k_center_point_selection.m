function test_ind = metric_k_center_point_selection(test, num_centers)

  test_ind = zeros(num_centers, 1);
  test_ind(1) = 1;

  for i = 2:num_centers
    current_ind = test_ind(1:(i - 1));
    candidate_ind = setdiff(1:num_test, current_ind);
    
    if (numel(current_ind) > 1)
      min_distances = ...
          min(sq_dist(test(current_ind, :)', test(candidate_ind, :)'));
    else
      min_distances = ...
          sq_dist(test(current_ind, :)', test(candidate_ind, :)');
    end
    
    [~, ind] = max(min_distances);
    test_ind(i) = ind;
  end

end