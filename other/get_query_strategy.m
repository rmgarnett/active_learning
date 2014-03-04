% GET_QUERY_STRATEGY creates a function handle to a query strategy.
%
% This is a convenience function for easily creating a function handle
% to a query strategy. Given a handle to a query strategy and its
% additional arguments (if any), returns a function handle for use in,
% e.g., active_learning.m.
%
% Example:
%
%   query_strategy = get_query_strategy(@maximum_score, score_function);
%
% returns the following function handle:
%
%   @(problem, train_ind, observed_labels, test_ind) ...
%       maximum_score(problem, train_ind, observed_labels,
%                     test_ind, score_function)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% Usage:
%
%   query_strategy = get_query_strategy(query_strategy, varargin)
%
% Inputs:
%
%   query_strategy: a function handle to the desired query strategy
%         varargin: any additional inputs to be bound to the query
%                   strategy beyond those required by the standard
%                   interface (problem, train_ind, observed_labels,
%                   test_ind)
%
% Output:
%
%   query_strategy: a function handle to the desired query strategy
%                   for use in active_learning
%
% See also QUERY_STRATEGIES.

% Copyright (c) 2013--2014 Roman Garnett.

function query_strategy = get_query_strategy(query_strategy, varargin)

  query_strategy = @(problem, train_ind, observed_labels, test_ind) ...
      query_strategy(problem, train_ind, observed_labels, test_ind, ...
                     varargin{:});

end