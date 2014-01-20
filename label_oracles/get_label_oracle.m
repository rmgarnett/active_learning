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
%                 API (problem and query_ind)
%
% output:
%   label_oracle: a function handle to the desired label oracle for
%                 use in active_learning
%
% Copyright (c) Roman Garnett 2013--2014

function label_oracle = get_label_oracle(label_oracle, varargin)

  label_oracle = @(problem, query_ind) ...
                 label_oracle(problem, query_ind, varargin{:});

end