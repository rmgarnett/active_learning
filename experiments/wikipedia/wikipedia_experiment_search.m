stream = RandStream('mt19937ar', 'seed', 31415);
RandStream.setGlobalStream(stream);

check_search_experiment_options;

if (options_defined)

  data_directory = '~/work/data/wikipedia/computer_science/processed/';
  load([data_directory 'topics/wikipedia_topic_vectors']);
  load([data_directory 'programming_language_page_ids']);

  data = topics;
  clear('topics');

  num_observations = size(data, 1);
  num_neighbors = size(neighbors, 2);

  responses = 2 * ones(num_observations, 1);
  responses(programming_language_page_ids) = 1;
  num_positives = nnz(responses == 1);

  setup_wikipedia_knn;

  open_matlabpool;

  [results, elapsed] = perform_search_experiment(data, responses, ...
          probability_function, probability_bound, num_experiments, ...
          num_evaluations, num_initial, balanced, report);
end