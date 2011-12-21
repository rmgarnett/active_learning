verbose = false;
num_experiments = 100;

random_seed = 31415;
stream = RandStream.create('mt19937ar', 'Seed', random_seed);
RandStream.setGlobalStream(stream);

data_directory = '~/work/data/wikipedia/computer_science/processed/';
load([data_directory 'topics/wikipedia_topic_vectors.mat']);
load([data_directory 'programming_language_page_ids']);

data = topics;
clear('topics');

num_observations = size(data, 1);
num_neighbors = size(neighbors, 2);

responses = false(num_observations, 1);
responses(programming_language_page_ids) = true;
num_positives = nnz(responses == 1);

num_initial = 10;
balanced = true;

utility_function = @(data, responses, train_ind) ...
    count_utility_discrete(responses, train_ind);

setup_wikipedia_knn;

for num_evaluations = [1e1 2e1 5e1 1e2 2e2 5e2 1e3 2e3 5e3]
  disp(['trying ' num2str(num_evaluations) ' evaluations.']);

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
    [~, utilities] = optimal_learning_discrete(data, responses, ...
            train_ind, selection_functions, probability_function, ...
            expected_utility_function, utility_function, num_evaluations, ...
            lookahead, verbose);
    one_step_results(i) = utilities(end) - nnz(responses(train_ind));
    
    lookahead = 2;
    [~, utilities] = optimal_learning_discrete(data, responses, ...
            train_ind, selection_functions, probability_function, ...
            expected_utility_function, utility_function, num_evaluations, ...
            lookahead, verbose);
    two_step_results(i) = utilities(end) - nnz(responses(train_ind));
    
    disp([  'one-step utility: ' num2str(one_step_results(i)) ...
            ', mean: ' num2str(mean(one_step_results(1:i))) ...
            ', two-step utility: ' num2str(two_step_results(i)) ...
            ', mean: ' num2str(mean(two_step_results(1:i)))]);
  end
end