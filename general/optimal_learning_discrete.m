function [in_train utilities] = optimal_learning_discrete(data, responses, ...
          in_train, probability_function, selection_function, ...
          utility_function, num_evaluations, options)
  
  if (~isfield(options, 'verbose'))
    options.verbose = false;
  end

  utilities = zeros(num_evaluations, 1);

  for i = 1:num_evaluations
    if (options.verbose)
      tic;
    end

    test_ind = selection_function(data, responses, in_train);
    num_test = numel(test_ind);

    probabilities = probability_function(data, responses, in_train, test_ind);
    expected_utilities = zeros(num_test, 1);
    
    parfor j = 1:num_test
      fake_in_train = in_train;
      fake_in_train(test_ind(j)) = true;

      fake_responses = responses;
      
      fake_responses(test_ind(j)) = true;
      utility_true = utility_function(data, fake_responses, fake_in_train);

      fake_in_train(test_ind(j)) = false;
      utility_false = utility_function(data, fake_responses, fake_in_train);
      
      expected_utilities(j) = probabilities(j)  * utility_true + ...
                         (1 - probabilities(j)) * utility_false;
    end
    
    [best_utility best_ind] = max(expected_utilities);
    in_train(test_ind(best_ind)) = true;

    utilities(i) = utility_function(data, responses, in_train);

    if (options.verbose)
      elapsed = toc;

      disp(['point ' num2str(num_evaluations) ...
            ', expected utility: ' num2str(best_utility) ...
            ', true utility: ' num2str(utilities(i)) ...
            ', distribution (' num2str(nnz(responses(in_train) == 1)) ...
            ' / ' num2str(i) ')' ...
            ', took: ' num2str(elapsed) 's.' ...
           ]);
   end
  end
end
