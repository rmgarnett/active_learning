% GET_LABEL_ORACLE creates a function handle to a label oracle.
%
% This is a convenience function for easily creating a function handle
% to a label oracle. Given a handle to a label oracle and its
% additional arguments (if any), returns a function handle for use in,
% e.g., active_learning.m.
%
% Example:
%
%   label_oracle = get_label_oracle(@lookup_oracle, labels);
%
% returns the following function handle:
%
%   @(problem, query_ind) ...
%       lookup_oracle(problem, train_ind, observed_labels, query_ind, ...
%                     labels)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% Usage:
%
%   label_oracle = get_label_oracle(label_oracle, varargin)
%
% Inputs:
%
%   label_oracle: a function handle to the desired label oracle
%       varargin: any additional inputs to be bound to the label
%                 oracle beyond those required by the standard
%                 interface (problem, query_ind)
%
% Output:
%
%   label_oracle: a function handle to the desired label oracle for
%                 use in active_learning
%
% See also LABEL_ORACLES.

% Copyright (c) 2013--2016 Roman Garnett.

function label_oracle = get_label_oracle(label_oracle, varargin)

  label_oracle = @(problem, train_ind, observed_labels, query_ind) ...
      label_oracle(problem, train_ind, observed_labels, query_ind, ...
                   varargin{:});

end