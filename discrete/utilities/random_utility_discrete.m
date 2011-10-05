function utilities = random_utility_discrete(data, responses, in_train)

  num_test = nnz(~in_train);
  utilities = rand(num_test, 1);

end
