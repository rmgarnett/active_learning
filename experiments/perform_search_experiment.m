function [results, elapsed] = perform_search_experiment(data, ...
          responses, num_initial, balanced, seed, probability_function, ...
          probability_bound, num_experiments, num_evaluations, ...
          max_lookahead, report)

  stream = RandStream('mt19937ar', 'seed', seed);
  RandStream.setDefaultStream(stream);

  utility_function = @(data, responses, train_ind) ...
      count_utility(responses, train_ind);

  expected_utility_function = @(data, responses, train_ind, test_ind) ...
      expected_count_utility(data, responses, train_ind, test_ind, ...
                             probability_function);

  selection_functions = cell(max_lookahead, 1);
  for i = 1:max_lookahead
    selection_functions{i} = @(data, responses, train_ind) ...
        optimal_search_bound_selection_function(data, responses, ...
            train_ind, probability_function, probability_bound, i);
  end

  results = zeros(num_experiments, num_evaluations, max_lookahead);
  elapsed = zeros(num_experiments, max_lookahead);

  for experiment = 1:num_experiments

    r = randperm(nnz(responses == 1));
    train_ind = logical_ind(responses == 1, r(1:num_initial));
    if (balanced)
      r = randperm(nnz(responses == 0));
      train_ind = [train_ind; logical_ind(responses == 0, r(1:num_initial))];
    end

    fprintf('experiment %i -- ', experiment);
    for lookahead = 1:max_lookahead
      start = tic;
      [~, utilities] = optimal_learning(data, responses, train_ind, ...
              selection_functions, probability_function, ...
              expected_utility_function, utility_function, ...
              num_evaluations, lookahead);
      utilities = utilities - utility_function(data, responses, train_ind);
      results(experiment, :, lookahead) = utilities;
      elapsed(experiment, lookahead) = toc(start);

      fprintf('%i-step utility: %i, mean: %.2f, took: %.2fs, mean: %.2fs ', ...
              lookahead, ...
              results(experiment, end, lookahead), ...
              mean(results(1:experiment, end, lookahead)), ...
              elapsed(experiment, lookahead), ...
              mean(elapsed(1:experiment, lookahead)));
    end
    fprintf('\n');

    for steps = 1:numel(report)
      fprintf(' ... ');
      for lookahead = 1:max_lookahead
        fprintf('%i-step-utility after %i steps: %i, mean: %.2f ', ...
                lookahead, ...
                report(steps), ...
                results(experiment, report(steps), lookahead), ...
                mean(results(1:experiment, report(steps), lookahead)));
      end
      fprintf('\n');
    end
  end
end
