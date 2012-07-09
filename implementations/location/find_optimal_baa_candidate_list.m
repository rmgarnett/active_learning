function candidate_mask = find_optimal_baa_candidate_list(pdf)

  [~, ind] = sort(pdf(:), 'descend');

  candidate_mask = zeros(size(pdf));
  candidate_mask(ind) = 1:numel(pdf);
  
end