% GET_SCORE_FUNCTION creates a function handle to a score function.
%
% This is a convenience function for easily creating a function handle
% to a score function. Given a handle to a score function and its
% additional arguments (if any), returns a function handle for use in,
% e.g., active_learning.m.
%
% Example:
%
%   score_function = get_score_function(@expected_accuracy, model);
%
% returns the following function handle:
%
%   @(problem, train_ind, observed_labels, test_ind) ...
%       expected_accuracy(problem, train_ind, observed_labels,
%                         test_ind, model)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% Usage:
%
%   score_function = get_score_function(score_function, varargin)
%
% Inputs:
%
%   score_function: a function handle to the desired score function
%         varargin: any additional inputs to be bound to the score
%                   function beyond those required by the standard
%                   interface (problem, train_ind, observed_labels,
%                   test_ind)
%
% Output:
%
%   score_function: a function handle to the desired label oracle for
%                   use in active_learning
%
% See also SCORE_FUNCTIONS.

% Copyright (c) 2013--2014 Roman Garnett.

function score_function = get_score_function(score_function, varargin)

  score_function = @(problem, train_ind, observed_labels, test_ind) ...
      score_function(problem, train_ind, observed_labels, test_ind, ...
                     varargin{:});

end