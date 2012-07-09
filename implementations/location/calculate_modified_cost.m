function cost = calculate_modified_cost(item_cost, candidate_mask, query_ind)

  num_points     = numel(candidate_mask);
  num_candidates = max(candidate_mask(:));
  
  area = @(candidate) (numel(candidate) / num_points);
  
  points_examined = [];
  
  cost = 0;
  for i = 1:num_candidates
    this_candidate = find(candidate_mask == i);
    this_candidate = setdiff(this_candidate, points_examined);
    
    cost = cost + item_cost + area(this_candidate);
    if (ismember(query_ind, this_candidate))
      break;
    end

    points_examined = union(points_examined, this_candidate);
  end
end