stream = RandStream('mt19937ar', 'seed', 31415);
RandStream.setGlobalStream(stream);

check_search_experiment_options;

if (options_defined)

  data_directory = '~/work/data/nips_papers/processed/top_venues/';
  load([data_directory 'nips_graph_pca_vectors'], 'nips_index');
  load([data_directory 'top_venues_graph'], 'nips_index');

  num_observations = size(data, 1);

  responses = 2 * ones(num_observations, 1);
  responses(nips_index) = 1;
  num_positives = nnz(responses == 1);

  if (~exist('probability_function', 'var'))
    setup_nips_knn;
  end

  open_matlabpool;

  [results, elapsed] = perform_search_experiment(data, responses, ...
          probability_function, probability_bound, num_experiments, ...
          num_evaluations, num_initial, balanced, report);
end