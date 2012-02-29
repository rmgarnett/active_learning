% binary gaussian process classifier.
%
% requires the gpml_extensions project available here
%
% https://github.com/rmgarnett/gpml_extensions
%
% function probabilities = gp_probability(data, responses, train_ind, ...
%          prior_covariances, inference_method, mean_function, ...
%          covariance_function, likelihood, hypersamples)
%
% inputs:
%                  data: an (n x d) matrix of input data
%             responses: an (n x 1) vector of responses (class 1 is
%                        tested against "any other class")
%             train_ind: a list of indices into data/responses
%                        indicating the training points
%              test_ind: a list of indices into data/responses
%                        indicating the test points
%     prior_covariances: a (num_hypersamples x n x n) matrix
%                        containing the prior covariance matrices
%      inference_method: a gpml inference method
%         mean_function: a gpml mean function
%   covariance_function: a gpml covariance function
%            likelihood: a gpml likelihood
%          hypersamples: a hypersample structure for use with
%                        gpml_extensions
%
% outputs:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2012

function probabilities = gp_probability(data, responses, train_ind, ...
          prior_covariances, inference_method, mean_function, ...
          covariance_function, likelihood, hypersamples)

  % transform responses to match what gpml expects
  responses(responses ~= 1) = -1;

  [means, variances, hypersample_weights] = ...
      estimate_latent_posterior_discrete(data, responses, train_ind, ...
          test_ind, prior_covariances, inference_method, mean_function, ...
          covariance_function, likelihood, hypersamples);

  num_predictions = numel(means);

  probabilities = ...
      reshape(exp(likelihood([], ones(num_predictions, 1), ...
                             means(:), variances(:))), ...
              size(means));

  probabilities = bsxfun(@times, probabilities, hypersample_weights);
  probabilities = sum(probabilities, 2);
  probabilities = [probabilities, (1 - probabilities0];

end