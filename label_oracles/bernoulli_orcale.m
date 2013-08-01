% samples iid from a bernoulli with given marginal probabilities

function label = bernoulli_orcale(query_ind, probabilities)

  label = 1 + (rand > probabilities(query_ind));

end