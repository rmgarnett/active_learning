random_seed = 12345;

stream = RandStream.create('mt19937ar', 'Seed', random_seed);
RandStream.setGlobalStream(stream);

data_directory = '~/work/data/nips_papers/processed/top_venues';
load([data_directory '/top_venues_graph'], 'nips_index');
load([data_directory '/nips_graph_pca_vectors'], 'data');
all_data = data;

num_observations = size(data, 1);

responses = false(num_observations, 1);
responses(nips_index) = true;
responses = 2 * responses - 1;
actual_proportion = mean(responses == 1);

in_train = false(num_observations, 1);

positives = find(responses == 1);
negatives = find(responses ~= 1);

num_initial = 1;
r = randperm(numel(positives));
in_train(positives(r(1:num_initial))) = true;
r = randperm(numel(negatives));
in_train(negatives(r(1:num_initial))) = true;

variance_target = 0.05^2;

num_trial_points = floor(num_observations / 50);
num_trials = 1;
num_f_samples = 1000;

num_test_points = floor(num_observations / 100);

log_input_scale_prior_mean = -4;
log_input_scale_prior_variance = 1;

log_output_scale_prior_mean = 0;
log_output_scale_prior_variance = 1;

latent_prior_mean_prior_mean = -1;
latent_prior_mean_prior_variance = 0.5;

hypersamples.prior_means = ...
    [latent_prior_mean_prior_mean ...
     log_input_scale_prior_mean ...
     log_output_scale_prior_mean];

hypersamples.prior_variances = ...
    [latent_prior_mean_prior_variance ...
     log_input_scale_prior_variance ...
     log_output_scale_prior_variance];

hypersamples.values = find_ccd_points(hypersamples.prior_means, ...
        hypersamples.prior_variances);

hypersamples.mean_ind = 1;
hypersamples.covariance_ind = 2:3;
hypersamples.likelihood_ind = [];
hypersamples.marginal_ind = 1:3;

hyperparameters.lik = hypersamples.values(1, hypersamples.likelihood_ind);
hyperparameters.mean = hypersamples.values(1, hypersamples.mean_ind);
hyperparameters.cov = hypersamples.values(1, hypersamples.covariance_ind);

inference_method = @infEP;
mean_function = @meanConst;
covariance_function = @covSEiso;
likelihood = @likErf;

[~, inference_method, mean_function, covariance_function, likelihood] = ...
    check_gp_arguments(hyperparameters, inference_method, ...
                       mean_function, covariance_function, likelihood, ...
                       data, responses);

probability_function = @(data, responses, test) gp_probability(data, ...
        responses, test, inference_method, mean_function, ...
        covariance_function, likelihood, hypersamples);

proportion_estimation_function = @(data, responses, test) ...
    gp_estimate_proportion_approximate(data, responses, test, ...
        inference_method, mean_function, covariance_function, ...
        likelihood, hypersamples, num_f_samples, num_trial_points, num_trials);

random_utility_function = @random_utility;
uncertainty_utility_function = @(data, responses, test) ...
    uncertainty_utility(data, responses, test, probability_function);
optimal_utility_function = @(data, responses, test) ...
    partial_search_utility_wrapper(data, responses, test, @(data, ...
        responses, test) optimal_utility(data, responses, test, ...
        all_data, probability_function, proportion_estimation_function), ...
        num_test_points);

random_estimated_proportions = [];
uncertainty_estimated_proportions = [];
optimal_estimated_proportions = [];

random_proportion_variances = [];
uncertainty_proportion_variances = [];
optimal_proportion_variances = [];

random_in_train = in_train;
uncertainty_in_train = in_train;
optimal_in_train = in_train;

round = 1;

done = @(round, variances) ((round > 1) && (variances(end) < variance_target));

options.verbose = true;
options.actual_proportion = actual_proportion;
options.num_evaluations = 1;

while (~(done(round, random_proportion_variances) && ...
         done(round, uncertainty_proportion_variances) && ...
         done(round, optimal_proportion_variances)))

  disp(['evaluation round ' num2str(round)]);
  if (~done(round, random_proportion_variances))
    [random_estimated_proportions(end + 1) ...
     random_proportion_variances(end + 1) random_in_train] ...
        = iterative_surveying(data, responses, random_in_train, ...
                              random_utility_function, ...
                              proportion_estimation_function, options);
  end

  if (~done(round, uncertainty_proportion_variances))
    [uncertainty_estimated_proportions(end + 1) ...
     uncertainty_proportion_variances(end + 1) uncertainty_in_train] ...
        = iterative_surveying(data, responses, uncertainty_in_train, ...
                              uncertainty_utility_function, ...
                              proportion_estimation_function, options);
  end

  if (~done(round, optimal_proportion_variances))
    [optimal_estimated_proportions(end + 1) ...
     optimal_proportion_variances(end + 1) optimal_in_train] = ...
        iterative_surveying(data, responses, optimal_in_train, ...
                            optimal_utility_function, ...
                            proportion_estimation_function, options);
  end

  round = round + 1;
end

random_predictions = probability_function(data(random_in_train, :), ...
        responses(random_in_train), data(~random_in_train, :));
random_likelihood = ...
    sum(log(random_predictions(responses(~random_in_train) == 1))) + ...
    sum(log(1 - random_predictions(responses(~random_in_train) == -1)));

uncertainty_predictions = probability_function(data(uncertainty_in_train, :), ...
        responses(uncertainty_in_train), data(~uncertainty_in_train, :));
uncertainty_likelihood = ...
    sum(log(uncertainty_predictions(responses(~uncertainty_in_train) == 1))) + ...
    sum(log(1 - uncertainty_predictions(responses(~uncertainty_in_train) == -1)));

optimal_predictions = probability_function(data(optimal_in_train, :), ...
        responses(optimal_in_train), data(~optimal_in_train, :));
optimal_likelihood = ...
    sum(log(optimal_predictions(responses(~optimal_in_train) == 1))) + ...
    sum(log(1 - optimal_predictions(responses(~optimal_in_train) == -1)));
