% ACTIVE_LEARNING simulates an active learning experiment.
%
% This function performs active learning on a set of discrete points
% using a given query strategy. An active-learning experiment is
% simulated following the following procedure:
%
%   Given: initially labeled points x, corresponding labels y,
%          budget B
%
%   for i = 1:B
%     % find points available for labeling
%     eligible_points = selector(x, y)
%
%     % decide on point to observe
%     x_star = query_strategy(x, y, eligible_points)
%
%     % observe point
%     y_star = label_oracle(x_star)
%
%     % add observation to training set
%     x = [x x_star];
%     y = [y y_star];
%   end
%
% This function supports user-specified:
%
% * Selectors, which given the current training set, return a set of
%   points currently eligible for labeling. See selectors.m for
%   usage and available implementations.
%
% * Label oracles, which given a point, return a corresponding
%   label. Label oracles may optionally be nondeterministic (see, for
%   example, bernoulli_oracle). See label_oracles.m for usage and
%   available implementations.
%
% * Query strategies, which given a training set and the selected
%   eligible points, decides which point to observe next. See
%   query_strategies.m for usage and available implementations.
%
% This function also supports arbitrary user-specified callbacks
% called after each round of the experiment. This can be useful, for
% example, for plotting the progress of the algorithm and/or printing
% statistics such as test error online.
%
% Usage:
%
%   [chosen_ind, chosen_labels] = ...
%       active_learning(problem, train_ind, observed_labels, label_oracle, ...
%                       selector, query_strategy, callback)
%
% Inputs:
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%             num_queries: the number of queries to make
%                 verbose: whether to print information regarding
%                          each query (default: false)
%
%         train_ind: a (possibly empty) list of indices into
%                    problem.points indicating the labeled points at
%                    start
%   observed_labels: a (possibly empty) list of labels corresponding
%                    to the observations in train_ind
%      label_oracle: a handle to a label oracle, which takes an index
%                    into problem.points and returns a label
%          selector: a handle to a point selector, which specifies
%                    which points are eligible to query at a given time
%    query_strategy: a handle to a query strategy
%          callback: (optional) a handle to an arbitrary user-defined
%                    callback called after each new point is queried.
%                    The callback will be called as
%
%                      callback(problem, train_ind, observed_labels)
%
%                    and anything returned will be ignored.
%
% Outputs:
%      chosen_ind: a list of indices of the chosen datapoints, in order
%   chosen_labels: a list of the corresponding observed labels
%
% See also LABEL_ORACLES, SELECTORS, QUERY_STRATEGIES.

% Copyright (c) Roman Garnett 2011--2014

function [chosen_ind, chosen_labels] = ...
      active_learning(problem, train_ind, observed_labels, label_oracle, ...
                      selector, query_strategy)

  % set verbose to false if not defined
  verbose = isfield(problem, 'verbose') && problem.verbose;

  chosen_ind    = zeros(problem.num_queries, 1);
  chosen_labels = zeros(problem.num_queries, 1);

  for i = 1:problem.num_queries
    if (verbose)
      tic;
      fprintf('point %i:', i);
    end

    % get list of points to consider for querying this round
    test_ind = selector(problem, train_ind, observed_labels);
    if (verbose)
      fprintf(' %i points for consideration ... ', numel(test_ind));
    end

    % end early if no points returned from selector
    if (isempty(test_ind))
      if (verbose)
        fprintf('\n');
      end
      warning('active_learning:active_learning:no_points_selected', ...
              sprintf(['after %i steps, no points were selected. ' ...
                       'Ending run early!'], i));

      chosen_ind    = chosen_ind(1:(i - 1));
      chosen_labels = chosen_labels(1:(i - 1));
      return;
    end

    % select location of next observation from the given list
    chosen_ind(i) = query_strategy(problem, train_ind, observed_labels, test_ind);

    % observe label at chosen location
    chosen_labels(i) = label_oracle(problem, chosen_ind(i));

    % update lists with new observation
    train_ind       = [train_ind; chosen_ind(i)];
    observed_labels = [observed_labels; chosen_labels(i)];
    if (verbose)
      fprintf('done. Point %i chosen (label: %i), took: %.2fs.\n', ...
              chosen_ind(i),    ...
              chosen_labels(i), ...
              toc);
    end

    % call callback, if defined
    if (nargin > 6)
      callback(problem, train_ind, observed_labels);
    end
  end

end