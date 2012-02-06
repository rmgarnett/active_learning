check_search_experiment_options;

if (options_defined)

  data_directory = '~/work/data/wikipedia/computer_science/processed/';
  load([data_directory 'topics/wikipedia_topic_vectors.mat']);
  load([data_directory 'programming_language_page_ids']);

  data = topics;
  clear('topics');

  num_observations = size(data, 1);
  num_neighbors = size(neighbors, 2);

  responses = zeros(num_observations, 1);
  responses(programming_language_page_ids) = 1;

  setup_wikipedia_knn;

  [results, elapsed] = perform_search_experiment(data, responses, ...
          num_initial, balanced, seed, probability_function, ...
          probability_bound, num_experiments, num_evaluations, ...
          max_lookahead, report);
end