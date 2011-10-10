function utilities = partial_search_utility_wrapper(data, responses, ...
        test, utility_function, num_test_points)

  num_test = size(test, 1);

  utilities = -Inf(num_test, 1);

  r = randperm(num_test);
  test_ind = r(1:num_test_points);
  
  utilities(test_ind) = ...
      utility_function(data, responses, test(test_ind, :));
  
end