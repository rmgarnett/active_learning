function [selected utilities] = optimal_learning(data, responses, ...
          response_function, probability_function, selection_function, ...
          utility_function, num_evaluations, options)
  
  if (~isfield(options, 'verbose'))
    options.verbose = false;
  end

  dimension = size(data, 2);

  utilities = zeros(num_evaluations, 1);
  selected = zeros(num_evaluations, dimension);

  for i = 1:num_evaluations
    if (options.verbose)
      tic;
    end

    test = selection_function(data, responses);
    num_test = size(test, 1);

    probabilities = probability_function(data, responses, test);
    expected_utilities = zeros(num_test, 1);
    
    parfor j = 1:num_test
      fake_data = [data; test(j, :)];
      fake_responses = [responses; true];

      utility_true = utility_function(fake_data, fake_responses);

      fake_responses(end) = false;
      utility_false = utility_function(fake_data, fake_responses);
      
      expected_utilities(j) = probabilities(j)  * utility_true + ...
                         (1 - probabilities(j)) * utility_false;
    end
    
    [best_utility best_ind] = max(expected_utilities);
    
    selected(i, :) = test(best_ind, :);
    data = [data; selected(1:i, :)];
    responses = [responses; response_function(selected(i, :))];

    utilities(i) = utility_function(data, responses);

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
