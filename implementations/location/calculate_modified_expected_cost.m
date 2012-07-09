function expected_cost = calculate_modified_expected_cost(item_cost, ...
          pdf, candidate_mask)

  num_points     = numel(candidate_mask);
  num_candidates = max(candidate_mask(:));
  
  area        = @(candidate) (numel(candidate) / num_points);
  probability = @(candidate) (sum(pdf(candidate)));
  
  points_examined = [];
  
  expected_cost = 0;
  for i = 1:num_candidates
    this_candidate = find(candidate_mask == i);
    this_candidate = setdiff(this_candidate, points_examined);
    
    expected_cost = expected_cost + ...
        (1 - probability(points_examined)) * (item_cost + area(this_candidate));

    points_examined = union(points_examined, this_candidate);
  end
end