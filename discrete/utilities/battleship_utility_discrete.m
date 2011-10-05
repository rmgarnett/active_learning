function utilities = battleship_utility_discrete(data, responses, in_train, ...
          probability_function)

  utilities = probability_function(data, responses, in_train);

end
