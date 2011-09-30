function [estimated_proportions proportion_variances in_train] = ...
      iterative_surveying_discrete(data, responses, in_train, ...
          utility_function, proportion_estimation_function, ...
          num_evaluations, verbose)
  
  if (nargin < 7)
    verbose = false;
  end
    
  estimated_proportions = zeros(num_evaluations, 1);
  proportion_variances = zeros(num_evaluations, 1);
  
  for i = 1:num_evaluations
    if (verbose)
      tic;
    end
    
    utilities = utility_function(data, responses, in_train);
    [~, best_ind] = max(utilities);

    test_ind = find(~in_train);
    in_train(test_ind(best_ind)) = true;

    [estimated_proportion proportion_variance] = ...
        proportion_estimation_function(data, responses, in_train);
    
    num_train = nnz(in_train);
    num_test = nnz(~in_train);

    estimated_proportions(i) = ...
        num_train / (num_train + num_test) * (mean(responses(in_train) == 1)) + ...
        num_test  / (num_train + num_test) * estimated_proportion;
    
    proportion_variances(i) = ...
        (num_test / (num_train + num_test))^2 * proportion_variance;
    
    if (verbose)
      elapsed = toc;
      disp(['sampling: point ' num2str(i) ...
            ' of ' num2str(num_evaluations) ...
            ', current estimate: ' num2str(estimated_proportions(i)) ...
            ' +/- ' num2str(sqrt(proportion_variances(i))) ...
            ', took: ' num2str(elapsed) 's.']);
    end
  end

end