verbose = false;

num_evaluations = 100;
num_experiments = 10;

data_directory = '~/work/data/nips_papers/processed/top_venues/';
load([data_directory 'top_venues_graph'], 'nips_index');
load([data_directory 'nips_graph_pca_vectors'], 'data');

num_observations = size(data, 1);
num_components = size(data, 2);
data = data(1:num_observations, 1:num_components);

responses = false(num_observations, 1);
responses(nips_index(nips_index <= num_observations)) = true;
num_positives = nnz(responses == 1);

num_initial = 10;
balanced = true;

utility_function = @(data, responses, train_ind) ...
    count_utility_discrete(responses, train_ind);

setup_nips_mknn_plus_mst;

one_step_results = zeros(num_experiments, 1);
two_step_results = zeros(num_experiments, 1);

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

  lookahead = 1;
  [chosen_ind, utilities] = optimal_learning_discrete(data, responses, ...
          train_ind, one_step_selection_function, probability_function, ...
          expected_utility_function, utility_function, num_evaluations, ...
          lookahead, verbose);
  one_step_results(i) = utilities(end) - nnz(responses(train_ind));

  lookahead = 2;
  [chosen_ind, utilities] = optimal_learning_discrete(data, responses, train_ind, ...
          two_step_selection_function, probability_function, ...
          expected_utility_function, utility_function, num_evaluations, ...
          lookahead, verbose);
  two_step_results(i) = utilities(end) - nnz(responses(train_ind));

  disp([  'one-step utility: ' num2str(one_step_results(i)) ...
        ', mean: ' num2str(mean(one_step_results(1:i))) ...
        ', two-step utility: ' num2str(two_step_results(i)) ...
        ', mean: ' num2str(mean(two_step_results(1:i)))]);
end