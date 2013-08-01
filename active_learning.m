% performs active learning on a set of discrete points using a given
% query strategy.
%
% function [chosen_ind, chosen_labels] = ...
%       active_learning(problem, train_ind, observed_labels, query_strategy)
%
% inputs:
%           problem: a struct describing the problem, containing fields:
%
%                   points: an n x d matrix describing the avilable points
%              num_classes: the number of classes
%              num_queries: the number of queries to make
%                  verbose: whether to print messages after each
%                           query (default: false)
%
%         train_ind: a (possibly empty) list of indices
%                    indicating the starting labeled points
%   observed_labels: a (possibly empty) list of labels corresponding
%                    to the observations in train_ind
%      label_oracle: a function taking an index into problem.points
%                    and returning a label
%          selector: a handle to a point selector, which specifies
%                     which points are eligable to query at a given time
%    query_strategy: a handle to a query strategy
%
% outputs:
%      chosen_ind: a list of indices of the chosen datapoints, in order
%   chosen_labels: a list of the corresponding observed labels
%
% copyright (c) roman garnett, 2011--2013

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
      fprintf('point %i: ', i);
    end

    test_ind = selector(problem, train_ind, observed_labels);

    % find the optimal next point to add given the current training set
    % and chosen utility function
    query_ind = query_strategy(problem, train_ind, observed_labels, ...
                               test_ind);

    % add the selected point and measure our current success
    chosen_ind(i)    = query_ind;
    train_ind        = [train_ind; chosen_ind(i)];
    chosen_labels(i) = label_oracle(problem, chosen_ind(i));
    observed_labels  = [observed_labels; chosen_labels(i)];

    if (verbose)
      elapsed = toc;
      fprintf('done, took: %.2fs.\n', elapsed);
    end
  end

end