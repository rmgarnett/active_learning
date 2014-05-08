% EXPECTED_LOSS_LOOKAHEAD calculates "lookahed" expected losses.
%
% This is an implementation of a score function that calculates the
% k-step-lookahead expected losses after adding each of a given set of
% points to a dataset for a particular loss function and lookahead
% horizon k.
%
% This function supports user-specified:
%
% * _Loss functions,_ which calculate the loss associated with a
%   selected training set,
%
% * _Selectors,_ which given the current training set, specify which
%   points should have their expected losses evaluated. This
%   implementation allows multiple selectors to be used, should
%   different ones be desired for different lookaheads.
%
% Note on Expected Loss Functions:
%
% This function requires as an input a function, expected_loss, that
% will return the one-step-lookahead expected losses after adding each
% of a given set of points to a dataset for the chosen loss
% function. That is, given a point x and a loss function \ell(D) for a
% dataset D = (X, Y), this function should return
%
%   E_y[ \ell(D U {(x, y)}) | x, D] = ...
%                       \sum_i p(y = i | x, D) \ell(D U {(x, i)}),
%
% where i ranges over the possible labels.
%
% The API for this expected loss function is the same as for any
% score function:
%
%   expected_losses = expected_loss(problem, train_ind, observed_labels, ...
%           test_ind)
%
% Sometimes this expectation over y may be calculated directly without
% enumerating all cases for y. If that is not possible, the function
% expected_loss_naive may be used with any arbitrary loss function to
% calculate this expectation naively (by augmenting the dataset D with
% (x, i) for each class i and weigting the resulting losses by the
% probabiliy that y = i).
%
% Usage:
%
%   expected_losses = expected_loss_lookahead(problem, train_ind, ...
%           observed_labels, test_ind, model, expected_loss, selectors, ...
%           lookahead)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an n x d matrix describing the avilable points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points
%                    indicating the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the points eligible for observation
%             model: a handle to probability model to use
%     expected_loss: a handle to the one-step expected loss function
%                    to use (see note above)
%         selectors: a cell array of selectors to use. If lookahead == k,
%                    then the min(k, numel(selection_functions))th
%                    element of this array will be used.
%         lookahead: the number of steps to look ahead. If
%                    lookahead == 0, then random expected losses are
%                    returned.
%
% Output:
%
%   expected_losses: the lookahead-step expected losses for the points
%                    in test_ind
%
% See also LOSS_FUNCTIONS, EXPECTED_LOSS_NAIVE, SELECTORS, MODELS, SCORE_FUNCTIONS.

% Copyright (c) 2011--2014 Roman Garnett.

function expected_losses = expected_loss_lookahead(problem, train_ind, ...
          observed_labels, test_ind, model, expected_loss, selectors, ...
          lookahead)

  num_test = numel(test_ind);

  % for zero-step lookahead, return random expected losses
  if (lookahead == 0)
    expected_losses = rand(num_test, 1);
    return;

  % for one-step lookahead, return values from base expected loss
  elseif (lookahead == 1)
    expected_losses = expected_loss(problem, train_ind, observed_labels, ...
            test_ind);
    return;
  end

  % We will calculate the expected loss after adding each dataset to the
  % training set by sampling over labels to create ficticious datasets
  % and measuring the expected loss of each. We accomplish lookahead
  % by calling this function recursively to calculate the expected
  % loss at later levels.

  % Used to recursively select test points. Allow array of selectors and
  % fall back if no entry for current lookahead.
  selector = selectors{min(lookahead - 1, numel(selectors))};

  % Given one additional new point, we will always select the remaining
  % points by minimizing the (lookahead - 1) expected loss.
  lookahead_loss = @(problem, train_ind, observed_labels) ...
      min(expected_loss_lookahead(problem, train_ind, observed_labels, ...
          selector(problem, train_ind, observed_labels), model, ...
          expected_loss, selectors, lookahead - 1));

  % Use expected_loss_naive to evaluate the expected loss of the given
  % points.
  expected_losses = expected_loss_naive(problem, train_ind, ...
          observed_labels, test_ind, model, lookahead_loss);

end