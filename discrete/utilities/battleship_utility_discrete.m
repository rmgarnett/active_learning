function utility = battleship_utility_discrete(responses, in_train)

  utility = nnz(responses(in_train) == true);

end
