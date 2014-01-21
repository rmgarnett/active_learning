% Performs active learning on a set of discrete points using a given
% query strategy.
%
% function [chosen_ind, chosen_labels] = ...
%       active_learning(problem, train_ind, observed_labels, label_oracle, ...
%                       selector, query_strategy, callback)
%
% inputs:
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%             num_queries: the number of queries to make
%                 verbose: whether to print information regarding
%                          each query (default: false)
%
%         train_ind: a (possibly empty) list of indices indicating
%                    the labeled points at start
%   observed_labels: a (possibly empty) list of labels corresponding
%                    to the observations in train_ind
%      label_oracle: a handle to a label oracle. which takes an index
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
% outputs:
%      chosen_ind: a list of indices of the chosen datapoints, in order
%   chosen_labels: a list of the corresponding observed labels
%
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
      fprintf(' %i points for consideration', numel(test_ind));
    end

    % end early if no points returned from selector
    if (numel(test_ind) == 0)
      warning('active_learning:active_learning:no_points_selected', ...
              sprintf(['after %i steps, no points were selected. ' ...
                       'Ending run early!'], i));

      chosen_ind    = chosen_ind(1:i);
      chosen_labels = chosen_labels(1:i);
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
      fprintf(', done, point %i chosen (label: %i), took: %.2fs.\n', ...
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