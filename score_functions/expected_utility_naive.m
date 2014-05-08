% EXPECTED_UTILITY_NAIVE calculates one-step-lookahead expected utilities.
%
% This is an implementation of a score function that calculates the
% one-step-lookahead expected utilities after adding each of a given
% set of points to a dataset for a particular utility function.
%
% This is implmemented as a wrapper around expected_loss_naive that
% simply transforms the provided utility into a loss (via negation),
% calls that function, and again negates the outputs. The API is the
% same as for expected_loss_naive, modulo the replacement of losses by
% utilites.
%
% See also EXPECTED_LOSS_NAIVE, LOSS_FUNCTIONS, SCORE_FUNCTIONS.

% Copyright (c) 2014 Roman Garnett.

function expected_utilities = expected_utility_naive(problem, train_ind, ...
          observed_labels, test_ind, model, utility)

  % transform utility into a loss via negation
  loss = @(problem, train_ind, observed_labels) ...
         -utility(problem, train_ind, observed_labels);

  % calculate expected losses and transform back to expected utilities
  % by negation
  expected_utilities = -expected_loss_naive(problem, train_ind, ...
          observed_labels, test_ind, model, loss);

end