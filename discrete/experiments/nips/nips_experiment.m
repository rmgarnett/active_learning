verbose = true;

num_evaluations = 2;
num_experiments = 1000;

data_directory = '~/work/data/nips_papers/processed/top_venues/';
load([data_directory 'top_venues_graph'], 'nips_index');
load([data_directory 'nips_graph_pca_vectors'], 'data');

num_observations = size(data, 1);
num_components = size(data, 2);
data = data(1:num_observations, 1:num_components);

responses = false(num_observations, 1);
responses(nips_index(nips_index <= num_observations)) = true;
num_positives = nnz(responses == 1);

num_initial = 1000;
balanced = true;

selection_function = @(data, responses, in_train) ...
    identity_point_selection(in_train);
utility_function = @(data, responses, in_train) ...
    count_utility_discrete(responses, in_train);

setup_nips_mknn_plus_mst;

one_step_results = zeros(num_experiments, 1);
two_step_results = zeros(num_experiments, 1);

for i = 1:num_experiments

  in_train = false(num_observations, 1);
  if (balanced)
    r = randperm(nnz(responses == 1));
    in_train(logical_ind(responses == 1, r(1:num_initial))) = true;
    r = randperm(nnz(responses == 0));
    in_train(logical_ind(responses == 0, r(1:num_initial))) = true;
  else
    r = randperm(num_observations);
    in_train(r(1:num_initial)) = true;
  end

  expected_utility_function = @(data, responses, in_train, test_ind) ...
      expected_count_utility_discrete(data, responses, in_train, ...
          test_ind, probability_function);

  [~, utilities] = optimal_learning_discrete(data, responses, in_train, ...
          selection_function, probability_function, ...
          expected_utility_function, utility_function, num_evaluations, ...
          1, verbose);

  one_step_results(i) = utilities(end) - nnz(responses(in_train));

  [~, utilities] = optimal_learning_discrete(data, responses, in_train, ...
          selection_function, probability_function, ...
          expected_utility_function, utility_function, num_evaluations, ...
          2, verbose);

  two_step_results(i) = utilities(end) - nnz(responses(in_train));

  disp([  'one-step utility: ' num2str(one_step_results(i)) ...
        ', mean: ' num2str(mean(one_step_results(1:i))) ...
        ', two-step utility: ' num2str(two_step_results(i)) ...
        ', mean: ' num2str(mean(two_step_results(1:i)))]);
end