function test_ind = random_point_selection(test, num_test_points)

  num_test = size(test, 1);
  r = randperm(num_test);
  test_ind = r(1:num_test_points);

end