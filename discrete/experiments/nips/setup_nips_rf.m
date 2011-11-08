options = statset('useparallel', 'always');

num_trees = 500;

probability_function = @(data, responses, in_train, test_ind) ...
    rf_probability_discrete(data, responses, in_train, test_ind, ...
                            num_trees, options);