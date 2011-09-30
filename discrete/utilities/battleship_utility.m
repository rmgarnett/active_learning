function utilities = battleship_utility(data, responses, in_train, ...
          probability_function)

  utilities = probability_function(data, responses, in_train);

end
