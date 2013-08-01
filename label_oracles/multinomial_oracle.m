% samples iid from a multinomial with given marginal probabilities

function label = multinomial_oracle(query_ind, probabilities)

  [~, label] = max(mnrnd(1, probabilities(query_ind, :)), [], 2);

end