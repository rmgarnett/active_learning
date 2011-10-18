function utility = battleship_utility_discrete(data, responses, in_train)

  utility = nnz(responses(in_train) == true);

end
