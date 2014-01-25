% Convenience function for easily creating a function handle to a
% label oracle. Given a handle to a label oracle and its additional
% arguments (if any), returns a function handle for use in, e.g.,
% active_learning.m.
%
% Example:
%
%   label_oracle = get_label_oracle(@lookup_oracle, labels);
%
% returns the following function handle:
%
%   @(problem, query_ind) lookup_oracle(problem, query_ind, labels)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% inputs:
%   label_oracle: a function handle to the desired label oracle
%       varargin: any additional inputs to be bound to the label
%                 oracle beyond those required by the standard
%                 interface (problem, query_ind)
%
% output:
%   label_oracle: a function handle to the desired label oracle for
%                 use in active_learning
%
% Copyright (c) Roman Garnett 2013--2014

function score_function = get_score_function(score_function, varargin)

  score_function = @(problem, train_ind, observed_labels, test_ind) ...
      score_function(problem, train_ind, observed_labels, test_ind, ...
                     varargin{:});

end