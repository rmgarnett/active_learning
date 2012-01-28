weight_function = @(distances) (double(distances > 0));

weights = knn_weights(data, k, weight_function);
max_weights = full(max(weights));

probability_function = @(data, responses, train_ind, test_ind) ...
    knn_probability(responses, train_ind, test_ind, weights, pseudocount);

probability_bound = @(data, responses, train_ind, test_ind, num_positives) ...
    knn_probability_bound(responses, train_ind, test_ind, weights, ...
                          max_weights, pseudocount, num_positives);
