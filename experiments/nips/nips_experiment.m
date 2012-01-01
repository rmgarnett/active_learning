verbose = false;
num_experiments = 100;

num_initial = 1;
balanced = true;

max_lookahead = 2;

data_directory = '~/work/data/nips_papers/processed/top_venues/';
load([data_directory 'top_venues_graph'], 'nips_index');
load([data_directory 'nips_graph_pca_vectors'], 'data');

num_observations = size(data, 1);
num_components = size(data, 2);
data = data(1:num_observations, 1:num_components);

responses = false(num_observations, 1);
responses(nips_index(nips_index <= num_observations)) = true;
num_positives = nnz(responses == 1);

if (~exist('probability_function', 'var'))
  setup_nips_mknn_plus_mst;
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

num_evaluations = 1000;
report = [10 20 50 100 200 500 1000];

results = zeros(num_experiments, num_evaluations, max_lookahead);
elapsed = zeros(num_experiments, max_lookahead);

for experiment = 1:num_experiments

  if (balanced)
    r = randperm(nnz(responses == 1));
    train_ind = logical_ind(responses == 1, r(1:num_initial));
    r = randperm(nnz(responses == 0));
    train_ind = [train_ind; ...
                 logical_ind(responses == 0, r(1:num_initial))];
  else
    r = randperm(num_observations);
    train_ind = r(1:num_initial);
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

    fprintf('%i-step utility: %i, mean: %.2f, took: %.2fs, mean: %.2fs\n', ...
            lookahead, ...
            results(experiment, end, lookahead), ...
            mean(results(1:experiment, :, lookahead)), ...
            elapsed(experiment, lookahead), ...
            mean(elapsed(1:experiment, lookahead)));

    for i = 1:numel(report)
      fprintf(' ... after %i steps: %i, mean: %.2f\n', ...
              report(i), ...
              results(experiment, report(i), lookahead), ...
              mean(results(1:experiment, report(i), lookahead)));
    end
    fprintf('\n');

  end
end
