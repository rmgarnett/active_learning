% ACTIVE_LEARNING simulates an active learning experiment.
%
% This function performs active learning on a set of discrete points
% using a given query strategy. An active-learning experiment is
% simulated following the following procedure:
%
%   Given: initially labeled points x,
%          corresponding labels y,
%          budget B
%
%   for i = 1:B
%     % find points available for labeling
%     eligible_points = selector(x, y)
%
%     % decide on point(s) to observe
%     x_star = query_strategy(x, y, eligible_points)
%
%     % observe point(s)
%     y_star = label_oracle(x_star)
%
%     % add observation(s) to training set
%     x = [x, x_star]
%     y = [y, y_star]
%   end
%
% This function supports user-specified:
%
% * _Selectors,_ which given the current training set, return a set of
%   points currently eligible for labeling. See selectors.m for usage
%   and available implementations.
%
% * _Query strategies,_ which given a training set and the selected
%   eligible points, decides which point(s) to observe next. Note that
%   a query strategy can return multiple points, allowing for batch
%   observations. See query_strategies.m for usage and available
%   implementations.
%
% * _Label oracles,_ which given a set of points, return a set of
%   corresponding labels. Label oracles may optionally be
%   nondeterministic (see, for example, bernoulli_oracle). See
%   label_oracles.m for usage and available implementations.
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
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%             num_queries: the number of queries to make
%                 verbose: whether to print information regarding
%                          each query (default: false)
%        num_initial_data: (optional) number of initial observations 
%                          provided in (train_ind, observed_lables) [see
%                          below]. If the user does not provide this
%                          information, it will be automatically created.
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
%
%      chosen_ind: a list of indices of the chosen datapoints, in order
%   chosen_labels: a list of the corresponding observed labels
%
% See also LABEL_ORACLES, SELECTORS, QUERY_STRATEGIES.

% Copyright (c) 2011--2014 Roman Garnett.

function [chosen_ind, chosen_labels] = ...
      active_learning(problem, train_ind, observed_labels, label_oracle, ...
                      selector, query_strategy, callback)

  % set verbose to false if not defined
  verbose = isfield(problem, 'verbose') && problem.verbose;

  % check if train_ind and observed_labels have
  % same number of observations 
  if numel(train_ind) ~= size(observed_labels,1)
      error('Number of training examples (features,labels) do not match.')
  end
  
  % check if num_initial_data exists and is correct,
  % create/fix it otherwise.
  has_num_initial_data = isfield(problem, 'num_initial_data');
  if ~(has_num_initial_data && ...
          problem.num_initial_data == numel(train_ind)),
     problem.num_initial_data = numel(train_ind);
     if has_num_initial_data
         warning(['problem.size_initial_data provided was incorret. ', ...
             'Overriding initial information'])
     end
  end

  chosen_ind    = [];
  chosen_labels = [];

  % store number of initial training points (this can be used to track
  % the number of points selected thus far)
  problem.num_initial = numel(train_ind);

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
      warning('active_learning:no_points_selected', ...
              ['after %i steps, no points were selected. ' ...
               'Ending run early!'], i);

      return;
    end

    % shortcut if only one point available
    if (numel(test_ind) == 1)
      this_chosen_ind = test_ind;
    else
    % select location(s) of next observation(s) from the given list
      this_chosen_ind = ...
          query_strategy(problem, train_ind, observed_labels, test_ind);
    end

    % observe label(s) at chosen location(s)
    this_chosen_labels = ...
        label_oracle(problem, train_ind, observed_labels, this_chosen_ind);

    % update lists with new observation(s)
    chosen_ind      = [chosen_ind; this_chosen_ind];
    train_ind       = [train_ind;  this_chosen_ind];

    chosen_labels   = [chosen_labels;   this_chosen_labels];
    observed_labels = [observed_labels; this_chosen_labels];
    if (verbose)
      num_observations = numel(this_chosen_ind);
      observation_format_string = repmat('%i ', [1, num_observations]);
      observation_format_string = observation_format_string(1:(end - 1));

      label_format_string = repmat('%i/', [1, problem.num_classes]);
      label_format_string = label_format_string(1:(end - 1));

      fprintf(sprintf('done. Point chosen: %s (label: %s), took: %%.2fs. Cumulative label totals: [%s].\n', ...
                      observation_format_string, ...
                      observation_format_string, ...
                      label_format_string), ...
              this_chosen_ind,    ...
              this_chosen_labels, ...
              toc, ...
              accumarray(chosen_labels, 1, [problem.num_classes, 1]));
    end

    % call callback, if defined
    if (nargin > 6)
      callback(problem, train_ind, observed_labels);
    end
  end

end