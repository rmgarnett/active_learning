% A model calculates the posterior class-membership probabilites for a
% selected set of test points given the current labeled training
% data.
%
% Models must satisfy the following interface:
%
%   probabilities = model(problem, train_ind, observed_labels, test_ind)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points
%                    indicating the test points
%
% Output:
%
%   probabilities: a matrix of posterior probabilities. The ith
%                  column gives p(y = i | x, D) for each of the
%                  indicated test points.
%
% The following models are provided in this toolbox:
%
%            cheating_model: a "cheating" model that queries a
%                            label oracle
%    gaussian_process_model: a binary Gaussian process classifier
%                 knn_model: a weighted k-NN model
%   label_propagation_model: partially absorbing label propagation
%       random_forest_model: a random forest model

% Copyright (c) 2011--2016 Roman Garnett.
