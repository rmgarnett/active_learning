% EXPECTED_LOSS_NAIVE calculates one-step-lookahead expected losses.
%
% This is an implementation of a score function that calculates the
% one-step-lookahead expected losses after adding each of a given set of
% points to a dataset for a particular loss function.
%
% Given a loss function \ell(D), this function computes the
% expected loss after adding each identified point x to the current
% dataset D:
%
%   E_y[ \ell(D U {(x, y)}) | x, D] = ...
%                       \sum_i p(y = i | x, D) \ell(D U {(x, i)}),
%
% where i ranges over the possible labels.
%
% Here this expectation is computed naively by augmenting the dataset
% D with (x, i) for each class i and weighting the resulting losses by
% the probability that y = i.
%
% Usage:
%
%   expected_losses = expected_loss_naive(problem, train_ind, ...
%           observed_labels, test_ind, model, loss)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an n x d matrix describing the available points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points
%                    indicating the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the points eligible for observation
%             model: a handle to the probability model to use
%              loss: a handle to the loss function to use
%
% Output:
%
%   expected_losses: the one-step lookahead expected losses for the
%                    points in test_ind
%
% See also LOSS_FUNCTIONS, EXPECTED_LOSS_LOOKAHEAD, MODELS, SCORE_FUNCTIONS.

% Copyright (c) 2011--2014 Roman Garnett.

function expected_losses = expected_loss_naive(problem, train_ind, ...
          observed_labels, test_ind, model, loss)

  num_test = numel(test_ind);

  % calculate the current posterior probabilities
  probabilities = model(problem, train_ind, observed_labels, test_ind);

  expected_losses = zeros(num_test, 1);
  for i = 1:num_test
    fake_train_ind = [train_ind; test_ind(i)];

    % sample over labels
    fake_losses = zeros(problem.num_classes, 1);
    for fake_label = 1:problem.num_classes
      fake_observed_labels = [observed_labels; fake_label];
      fake_losses(fake_label) = ...
          loss(problem, fake_train_ind, fake_observed_labels);
    end

    % calculate expectation using current probabilities
    expected_losses(i) = probabilities(i, :) * fake_losses;
  end

end