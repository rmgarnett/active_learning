function [estimated_proportions proportion_variances in_train] = ...
      iterative_surveying_variance_target(data, responses, in_train, ...
          utility_function, proportion_estimation_function, ...
          variance_target, verbose)
  
  if (nargin < 7)
    verbose = false;
  end

  estimated_proportions = [];
  proportion_variances = [];
  
  [estimated_proportion proportion_variance] = ...
      proportion_estimation_function(data(in_train, :), ...
          responses(in_train), data(~in_train, :));
    
  num_train = nnz(in_train);
  num_test = nnz(~in_train);

  estimated_proportions(1) = ...
      num_train / (num_train + num_test) * (mean(responses(in_train) == 1)) + ...
      num_test  / (num_train + num_test) * estimated_proportion;
  
  proportion_variances(1) = ...
        (num_test / (num_train + num_test))^2 * proportion_variance;

  if (verbose)
    disp(['surveying, beginning estimate: ' ...
          num2str(estimated_proportions(1)) ' +/- ' ...
          num2str(sqrt(proportion_variances(1)))]);
  end

  num_evaluations = 1;
  while (proportion_variance(end) > variance_target)
    if (verbose)
      tic;
    end
    
    utilities = utility_function(data(in_train, :), responses(in_train), ...
                                 data(~in_train, :));
    [~, best_ind] = max(utilities);

    test_ind = find(~in_train);
    in_train(test_ind(best_ind)) = true;

    [estimated_proportion proportion_variance] = ...
        proportion_estimation_function(data(in_train, :), ...
            responses(in_train), data(~in_train, :));
    
    num_train = nnz(in_train);
    num_test = nnz(~in_train);

    estimated_proportions(end + 1) = ...
        num_train / (num_train + num_test) * (mean(responses(in_train) == 1)) + ...
        num_test  / (num_train + num_test) * estimated_proportion;
    
    proportion_variances(end + 1) = ...
        (num_test / (num_train + num_test))^2 * proportion_variance;
    
    if (verbose)
      elapsed = toc;
      disp(['surveying, point ' num2str(num_evaluations) ...
            ' of ' num2str(num_evaluations) ...
            ', current estimate: ' num2str(estimated_proportions(num_evaluations)) ...
            ' +/- ' num2str(sqrt(proportion_variances(num_evaluations))) ...
            ', took: ' num2str(elapsed) 's.']);
    end

    num_evaluations = num_evaluations + 1;
  end

end