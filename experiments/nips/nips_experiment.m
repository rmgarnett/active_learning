stream = RandStream('mt19937ar', 'seed', 31415);
RandStream.setGlobalStream(stream);

options_defined = true;
required_options = {'num_initial', 'num_experiments', 'num_evaluations', ...
                    'max_lookahead', 'report', 'balanced'};

for i = 1:numel(required_options)
  if (~exist(required_options{i}, 'var'))
  fprintf(['please define ' required_options{i} '.\n']);
  options_defined = false;
  end
end

if (options_defined)
  verbose = false;

  try
    if (matlabpool('size') == 0)
      %matlabpool('open');
    end
  end

  data_directory = '~/work/data/nips_papers/processed/top_venues/';
  load([data_directory 'top_venues_graph'], 'nips_index', 'connected_W');

  num_observations = size(connected_W, 1);
  data = (1:num_observations)';
  
  responses = 2 * ones(num_observations, 1);
  responses(nips_index(nips_index <= num_observations)) = 1;
  num_positives = nnz(responses == 1);

  if (~exist('probability_function', 'var'))
    weights = connected_W;
    clear connected_W;

    normalizer = max(weights, [], 2);
    weights = weights - bsxfun(@times, weights > 0, normalizer);
    
    % weights = max(weights, weights');

    max_weights = full(max(weights));

    probability_function = @(data, responses, train_ind, test_ind) ...
        knn_probability(responses, train_ind, test_ind, weights, pseudocount);
    
    probability_bound = @(data, responses, train_ind, test_ind, num_positives) ...
        knn_probability_bound(responses, train_ind, test_ind, weights, ...
                              max_weights, pseudocount, num_positives);
  end

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
      r = randperm(nnz(responses == 2));
      train_ind = [train_ind; logical_ind(responses == 2, r(1: num_initial))];
    end

    for lookahead = 1:max_lookahead
      start = tic;
      [~, utilities] = optimal_learning(data, responses, train_ind, ...
              selection_functions, probability_function, ...
              expected_utility_function, utility_function, ...
              num_evaluations, lookahead, verbose);
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