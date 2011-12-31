verbose = false;
num_experiments = 100;

num_initial = 10;
balanced = true;

max_lookahead = 4;

data_directory = '~/work/data/nips_papers/processed/top_venues/';
load([data_directory 'top_venues_graph'], 'nips_index');
load([data_directory 'nips_graph_pca_vectors'], 'data');

num_observations = size(data, 1);
num_components = size(data, 2);
data = data(1:num_observations, 1:num_components);

responses = false(num_observations, 1);
responses(nips_index(nips_index <= num_observations)) = true;
num_positives = nnz(responses == 1);

utility_function = @(data, responses, train_ind) ...
    count_utility_discrete(responses, train_ind);

setup_nips_mknn_plus_mst;

for num_evaluations = 100
  disp(['trying ' num2str(num_evaluations) ' evaluations.']);

  results = zeros(num_experiments, max_lookahead);

  for i = 1:num_experiments

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

    expected_utility_function = @(data, responses, train_ind, test_ind) ...
        expected_count_utility_discrete(data, responses, train_ind, ...
            test_ind, probability_function);

    for lookahead = 1:max_lookahead
			tic;
      [~, utilities] = optimal_learning_discrete(data, responses, ...
              train_ind, selection_functions, probability_function, ...
              expected_utility_function, utility_function, num_evaluations, ...
              lookahead, verbose);
      results(i, lookahead) = ...
          utilities(end) - utility_function(data, responses, train_ind);
      elapsed = toc;
      fprintf('%i-step utility: %i, mean: %.2f, took: %.2fs ', ...
              lookahead, ...
              results(i, lookahead), ...
              mean(results(1:i, lookahead)), ...
							elapsed);
    end

		fprintf('\n');
  end
end
