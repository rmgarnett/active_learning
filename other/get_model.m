% GET_MODEL creates a function handle to a probability model.
%
% This is a convenience function for easily creating a function handle
% to a model. Given a handle to a model and its additional arguments
% (if any), returns a function handle for use in, e.g.,
% active_learning.m.
%
% Example:
%
%   model = get_model(@knn_model, weights, prior_alpha, prior_beta);
%
% returns the following function handle:
%
%   @(problem, train_ind, observed_labels, test_ind) ...
%       knn_model(problem, train_ind, observed_labels, test_ind, ...
%                 weights, prior_alpha, prior_beta)
%
% This is primarily for improving code readability by avoiding
% repeated verbose function handle declarations.
%
% Usage:
%
%   model = get_model(model, varargin)
%
% Inputs:
%
%      model: a function handle to the desired model
%   varargin: any additional inputs to be bound to the model beyond
%             those required by the standard interface (problem,
%             train_ind, observed_labels, test_ind)
%
% Output:
%
%   model: a function handle to the desired model for use in
%          active_learning
%
% See also MODELS.

% Copyright (c) 2013--2014 Roman Garnett.

function model = get_model(model, varargin)

  model = @(problem, train_ind, observed_labels, test_ind) ...
          model(problem, train_ind, observed_labels, test_ind, varargin{:});

end