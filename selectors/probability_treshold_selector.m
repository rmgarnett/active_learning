% PROBABILITY_THRESHOLD_SELECTOR selects confident points.
%
% This provides a selector that selects points with at least one
% class-membership probability above a specified threshold according
% to a given model.
%
% Usage:
%
%   test_ind = probability_treshold_selector(problem, train_ind, ...
%           observed_labels, model, threshold)
%
% Inputs:
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%             model: a handle to a probability model
%
% Output:
%
%   test_ind: a list of indices into problem.points indicating the
%             points to consider for labeling. Each index in test_ind
%             has at least one class-membership probability greater
%             than the provided threshold.
%
% See also SELECTORS, MODELS.

% Copyright (c) 2011--2014 Roman Garnett.

function test_ind = probability_treshold_selector(problem, train_ind, ...
          observed_labels, model, threshold)

  test_ind = identity_selector(problem, [], []);

  probabilities = model(problem, train_ind, observed_labels, test_ind);

  test_ind = find(any(probabilities >= threshold), 2);

end
