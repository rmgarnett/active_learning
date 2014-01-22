% binary gaussian process classifier.
%
% function probabilities = gaussian_process_probability(problem, train_ind, ...
%           observed_labels, test_ind, hyperparameters, inference_method, ...
%           mean_function, covariance_function, likelihood)
%
% inputs:
%           problem: a struct describing the problem, containing the field:
%
%             points: an n x d matrix describing the avilable points
%
%             train_ind: a list of indices into problem.points indicating
%                        the training points
%       observed_labels: a list of labels corresponding to the
%                        observations in train_ind
%              test_ind: a list of indices into problem.points indicating
%                        the test points
%       hyperparameters: a gpml hyperparameter structure
%      inference_method: a gpml inference method
%         mean_function: a gpml mean function
%   covariance_function: a gpml covariance function
%            likelihood: a gpml likelihood
%
% output:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2013

function probabilities = gaussian_process_probability(problem, train_ind, ...
          observed_labels, test_ind, hyperparameters, inference_method, ...
          mean_function, covariance_function, likelihood)

  % transform labels to match what gpml expects
  observed_labels(observed_labels ~= 1) = -1;

  num_test = numel(test_ind);

  [~, ~, ~, ~, log_probabilities] = gp(hyperparameters, inference_method, ...
                                       mean_function, covariance_function, likelihood, ...
                                       problem.points(train_ind, :), observed_labels, ...
                                       problem.points(test_ind, :), ones(num_test, 1));

  probabilities = exp(log_probabilities);
  probabilities = [probabilities, (1 - probabilities)];

end