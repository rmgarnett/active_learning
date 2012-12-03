% binary gaussian process classifier.
%
% inputs:
%                  data: an (n x d) matrix of input data
%                labels: an (n x 1) vector of labels (class 1 is
%                        tested against "any other class")
%             train_ind: a list of indices into data/labels indicating
%                        the training points
%              test_ind: a list of indices into data/labels indicating
%                        the test points
%       hyperparameters: a gpml hyperparameter structure
%      inference_method: a gpml inference method
%         mean_function: a gpml mean function
%   covariance_function: a gpml covariance function
%            likelihood: a gpml likelihood
%
% outputs:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2012

function probabilities = gaussian_process_probability(data, labels, ...
          train_ind, test_ind, hyperparameters, inference_method, ...
          mean_function, covariance_function, likelihood)

  % transform labels to match what gpml expects
  labels(labels ~= 1) = -1;

  num_test = numel(test_ind);
  
  [~, ~, ~, ~, log_probabilities] = gp(hyperparameters, inference_method, ...
          mean_function, covariance_function, likelihood, data(train_ind, :), ...
          labels(train_ind), data(test_ind, :), ones(num_test, 1));

  probabilities = exp(log_probabilities);
  probabilities = [probabilities, (1 - probabilities)];

end