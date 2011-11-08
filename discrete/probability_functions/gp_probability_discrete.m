% implementation of the probability function interface for a
% gaussian process classifier.  
%
% requires the gpml_extensions project available here
%
% https://github.com/rmgarnett/gpml_extensions
%
% function probabilities = gp_probability_discrete(data, responses, ...
%           in_train, prior_covariances, inference_method, mean_function, ...
%           covariance_function, likelihood, hypersamples)
%
% inputs:
%                  data: an (n x d) matrix of input data
%             responses: an (n x 1) vector of 0/1 responses
%             train_ind: an index into data/responses indicating
%                        the training points
%              test_ind: an index into data/responses indicating
%                        the test points
%     prior_covariances: a (num_hypersamples x n x n) matrix
%                        containing the prior covariance matrices
%      inference_method: a gpml inference method
%         mean_function: a gpml mean function
%   covariance_function: a gpml covariance function
%            likelihood: a gpml likelihood
%          hypersamples: a hypersample structure for use with gpml_extensions
%
% outputs:
%   probabilities: a vector of posterior probabilities for the test data
%
% copyright (c) roman garnett, 2011

function probabilities = gp_probability_discrete(data, responses, ...
          train_ind, prior_covariances, inference_method, mean_function, ...
          covariance_function, likelihood, hypersamples)

  [means variances hypersample_weights] = ...
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
  
end