% EXPECTED_UTILITY_LOOKAHEAD calculates "lookahed" expected utilities.
%
% This is an implementation of a score function that calculates the
% k-step-lookahead expected utilities after adding each of a given set
% of points to a dataset for a particular utility function and
% lookahead horizon k.
%
% This is implemented as a wrapper around expected_loss_lookahead that
% simply transforms the provided utility into a loss (via negation),
% calls that function, and again negates the outputs. The API is the
% same as for expected_loss_lookahead, modulo the replacement of
% losses by utilities.
%
% See also EXPECTED_LOSS_LOOKAHEAD, LOSS_FUNCTIONS, SCORE_FUNCTIONS.

% Copyright (c) 2014 Roman Garnett.

function expected_utilities = expected_utility_lookahead(problem, ...
          train_ind, observed_labels, test_ind, model, expected_utility, ...
          selectors, lookahead)

  % transform utility into a loss via negation
  expected_loss = @(problem, train_ind, observed_labels, test_ind) ...
      -expected_utility(problem, train_ind, observed_labels, ...
                        test_ind);

  % calculate expected losses and transform back to expected utilities
  % by negation
  expected_utilities = -expected_loss_lookahead(problem, train_ind, ...
          observed_labels, test_ind, model, expected_loss, selectors, ...
          lookahead);

end