% EXPECTED_ERROR_REDUCTION queries the point giving lowest expected error.
%
% This is an implementation of expected error reduction, a simple and
% popular query strategy. Expected error reduction queries the point
% that would result in the lowest expected error on the remaining
% unlabeled points. Let a point x and a dataset D = (X, Y) be given.
% Let \ell(D) be a loss function for the unlabeled points U given D;
% here we support either the total 0/1 loss:
%
%   \ell(D) = \sum_{x \in U} [ y != \hat{y} ],
%
% where \hat{y} = argmax p(y | x, D) is the predicted label for x, or
% the total log loss:
%
%   \ell(D) = \sum_{x \in U} -\log p(y = \hat{y} | x, D).
%
% Then expected error reduction queries the point x resulting the in
% the lowest expected loss on U after adding the observation (x, y)
% to D:
%
%   x* = \argmin E_y[ p(y | x, D) \ell(D U (x, y)) ].
%
% Note that the set of unlabeled points U depends on x!
%
% Usage:
%
%   query_ind = expected_error_reduction(problem, train_ind, ...
%           observed_labels, test_ind, model, loss)
%
% Required Inputs:
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
%          test_ind: a list of indices into problem.points indicating
%                    the points eligible for observation
%             model: a function handle to a probability model
%
% Optional Input:
%
%              loss: a string specifying the desired loss function;
%                    the following are supported: '01', '0/1', 'log'.
%                    (case insensitive; default: 'log')
%
% Output:
%
%   query_ind: an index into test_ind indicating the point to query
%              next
%
% See also MODELS, QUERY_STRATEGIES.

% Copyright (c) 2014 Roman Garnett.

function query_ind = expected_error_reduction(problem, train_ind, ...
          observed_labels, test_ind, model, loss)

  if (nargin < 6)
    loss = 'log';
  end

  % create handle to appropriate loss function
  switch (tolower(loss))
    case {'01', '0/1'}
      loss = @expected_01_loss;

    case 'log'
      loss = @expected_log_loss;

    otherwise
      error('active_learning:unknown_loss', ...
            'unknown loss function: %s', loss);
  end

  % expected error reduction is one-step lookahead minimization of
  % the chosen expected loss on the set of unlabeled points.

  loss = @(problem, train_ind, observed_labels) ...
         loss(problem, train_ind, observed_labels, ...
              unlabeled_selector(problem, train_ind, []), ...
              model);

  score_function = get_score_function(@expected_loss_naive, model, loss);

  query_ind = argmin(problem, train_ind, observed_labels, test_ind, ...
                     score_function);

end