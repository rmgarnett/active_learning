function utilities = restricted_search_utility_wrapper(data, responses, ...
          test, selection_function, utility_function)

  num_test = size(test, 1);
  utilities = -Inf(num_test, 1);

  test_ind = selection_function(data, responses, test);
  
  utilities(test_ind) = ...
      utility_function(data, responses, test(test_ind, :));
  
end