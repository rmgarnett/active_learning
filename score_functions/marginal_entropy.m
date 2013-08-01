function scores = marginal_entropy(problem, train_ind, observed_labels, ...
          test_ind, probability)

  probabilities = probability(problem, train_ind, observed_labels, test_ind);
  scores = -sum(probabilities .* log(probabilities), 2);

end