function [estimated_proportions proportion_variances in_train] = ...
      iterative_surveying(data, responses, in_train, utility_function, ...
                          proportion_estimation_function, options)
  
  if (~isfield(options, 'verbose'))
    options.verbose = false;
  end
  if (~isfield(options, 'actual_proportion'))
    options.actual_proportion = 0;
  end
  
  variance_target = (isfield(options, 'variance_target'));
  evaluation_limit = (isfield(options, 'evaluation_limit'));

  estimated_proportions = [];
  proportion_variances = [];

  done = @(num_evaluations, variance) ...
         (variance_target && (variance < options.variance_target)) || ... 
         (evaluation_limit && (num_evaluations > options.evaluation_limit));

  num_evaluations = 1;
  while ((num_evaluations == 1) || ...
         ~done(num_evaluations, proportion_variances(end)))
    
    if (options.verbose)
      tic;
    end
    
    utilities = utility_function(data(in_train, :), responses(in_train), ...
                                 data(~in_train, :));
    [best_utility best_ind] = max(utilities);

    test_ind = find(~in_train);
    in_train(test_ind(best_ind)) = true;

    [estimated_proportion proportion_variance] = ...
        proportion_estimation_function(data(in_train, :), ...
            responses(in_train), data(~in_train, :));
    
    num_train = nnz(in_train);
    num_test = nnz(~in_train);

    this_mean = num_train / (num_train + num_test) * (mean(responses(in_train) == 1)) + ...
                num_test  / (num_train + num_test) * estimated_proportion;
    this_variance = (num_test / (num_train + num_test))^2 * proportion_variance;

    estimated_proportions(end + 1) = this_mean;
    proportion_variances(end + 1) = this_variance;

    if (options.verbose)
      elapsed = toc;
      to_print = ['point ' num2str(num_evaluations) ...
                  ', utility: ' num2str(best_utility) ...
                  ', distribution (' num2str(nnz(responses(in_train) == 1)) ...
                  ' / ' num2str(num_evaluations) ...
                  '), current estimate: ' num2str(estimated_proportions(num_evaluations) * 100) '%' ...
                  ' +/- ' num2str(sqrt(proportion_variances(num_evaluations)) * 100) '%'];

      if (options.actual_proportion > 0)
        [alpha beta] = moment_matched_beta(this_mean, this_variance);
        log_likelihood = log(normpdf(options.actual_proportion, alpha, beta));
        to_print = [to_print ', log likelihood: ' num2str(log_likelihood)];
      end
      
      to_print = [to_print ', took: ' num2str(elapsed) 's.'];
      disp(to_print);
    end

    num_evaluations = num_evaluations + 1;
  end

end
