function utility = sum_top_scores_utility(data, responses, train_ind, ...
          objective_function, k)

  values = sort(objective_function(data, responses, train_ind), 'descend');

  utility = sum(values(1:k));
  
end