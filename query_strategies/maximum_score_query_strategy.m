% trivial but most popular query strategy; selects point with
% maximal score given by an extral score function.

function query_ind = maximum_score_query_strategy(problem, train_ind, ...
          observed_labels, test_ind, score_function)

  scores = score_function(problem, train_ind, observed_labels, test_ind);

  [~, best_ind] = max(scores);
  query_ind = test_ind(best_ind);

end