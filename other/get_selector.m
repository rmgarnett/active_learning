% GET_SELECTOR creates a function handle to a selector.
%
% This is a convenience function for easily creating a function handle
% to a selector. Given a handle to a selector and its additional
% arguments (if any), returns a function handle for use in, e.g.,
% active_learning.m.
%
% Example:
%
%   selector = get_selector(@random_selector, num_test);
%
% returns the following function handle:
%
%   @(problem, train_ind, observed_labels) ...
%       random_selector(problem, train_ind, observed_labels, num_test)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% Usage:
%
%   selector = get_selector(selector, varargin)
%
% Inputs:
%
%   selector: a function handle to the desired selector
%   varargin: any additional inputs to be bound to the selector beyond
%             those required by the standard interface (problem,
%             train_ind, observed_labels)
%
% Output:
%
%   selector: a function handle to the desired selector for use in
%             active_learning
%
% See also SELECTORS.

% Copyright (c) 2014 Roman Garnett.

function selector = get_selector(selector, varargin)

  selector = @(problem, train_ind, observed_labels) ...
             selector(problem, train_ind, observed_labels, varargin{:});

end