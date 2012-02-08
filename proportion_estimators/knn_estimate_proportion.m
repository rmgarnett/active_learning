function [expected_proportion proportion_variance] = ...
      knn_estimate_proportion(data, responses, train_ind, ...
                              probability_function, shared_neighbors, ...
                              sn_nz_rows, sn_nz_cols, num_replications)

  num_train = numel(train_ind);
  half_num_train = floor(num_train / 2);

  test_ind = 1:size(data, 1);
  num_test = numel(test_ind);

  % valid sizes for hadamard matrices for n <= 2^14
  valid_designs = [   1    2    4    8   12   16   20   24 ...
                     32   40   48   64   80   96  128  160 ...
                    192  256  320  384  512  640  768 1024 ...
                   1280 1536 2048 2560 3072 4096 5120 6144 ...
                   8192 ...
                  ];

  design_ind = logical_ind(valid_designs >= num_train, 1);
  H = hadamard(valid_designs(design_ind));

  probabilities = zeros(num_test, num_replications);

  for i = 1:num_replications
    selected_ind = (H(i, 1:num_train) == 1);
    weight = nnz(selected_ind);

    halfsample = ...
        train_ind(logical_ind(selected_ind, 1:min(weight, half_num_train)));
    imputation_set = setdiff(train_ind, halfsample);

    imputed_probabilities = ...
        probability_function(data, responses, halfsample, imputation_set);

    fake_responses = responses;
    fake_responses(imputation_set) = (imputed_probabilities > (1 / 2));

    probabilities(:, i) = ...
        probability_function(data, fake_responses, train_ind, test_ind);
    probabilities(halfsample, i) = responses(halfsample);
  end

  expected_proportion = mean(probabilities(:));

  variances = var(probabilities, [], 2);
  correction = (1 + 2 / num_train) * (1 - num_train / num_test);
  variances = variances * correction;

  proportion_variance = ...
      sum(shared_neighbors .* ...
          sqrt(variances(sn_nz_rows) .* variances(sn_nz_cols)));
end
