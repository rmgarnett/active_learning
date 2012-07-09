function expected_cost = calculate_baa_expected_cost(candidate_mask, pdf)

  num_points     = numel(pdf);
  num_candidates = max(candidate_mask(:));
  
  area        = @(candidate) (numel(candidate) / num_points);
  probability = @(candidate) (sum(pdf(candidate)));
  
  points_examined = [];
  
  expected_cost = 0;
  for i = 1:num_candidates
    this_candidate = find(candidate_mask == i);
    this_candidate = setdiff(this_candidate, points_examined);
    
    expected_cost = expected_cost + ...
        (1 - probability(points_examined)) * area(this_candidate);

    points_examined = union(points_examined, this_candidate);
  end
end