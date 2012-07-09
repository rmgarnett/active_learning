function candidate_list = build_candidate_mask(pdf, item_cost)

  candidate_mask = ones(size(pdf));
  
  [num_rows, num_cols] = size(pdf);
  largest_radius = min(num_rows, num_cols) / 10;
  
  available_mask = ones(num_rows, num_cols);

  uniform_pdf = ones(num_rows, num_cols) / (num_rows * num_cols);
  [col_inds, row_inds] = meshgrid(1:num_rows, 1:num_cols);

  keep_searching = true;
  while (keep_searching)
    keep_searching = false;

    probability_left = sum(sum(        pdf .* available_mask));
    area_left        = sum(sum(uniform_pdf .* available_mask));
    
    best_tail_cost        = probability_left;
    best_tail_cost_region = zeros(size(pdf));
    for radius = 1:largest_radius
      filter = fspecial('disk', radius);
      filter = filter / max(filter(:));
      
      region_areas         = conv2(uniform_pdf .* available_mask, ...
                                   filter, 'same');
      region_probabilities = conv2(        pdf .* available_mask, ...
                                   filter, 'same');
      
      candidate_tail_costs = ...
          probability_left * (item_cost + region_areas) + ...
          (probability_left - region_probabilities) .* (area_left - ...
              region_areas);
      
      [this_best_tail_cost, ind] = min(candidate_tail_costs(:));
      
      if (this_best_tail_cost < best_tail_cost)
        best_tail_cost = this_best_tail_cost;
        [row, col] = ind2sub(size(pdf), ind);

        best_tail_cost_region = ...
            ((row_inds - row).^2 + (col_inds - col).^2) <= ...
                radius^2;
        best_tail_cost_region = best_tail_cost_region .* available_mask;
      end
    end

    if (any(best_tail_cost_region(:)))
      candidate_list{end + 1} = best_tail_cost_region;

      available_mask = available_mask .* (1 - best_tail_cost_region);
      keep_searching = (numel(candidate_list) < 1 / item_cost);
    end
  end
  
end
