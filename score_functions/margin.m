% MARGIN calculates predictive margin on given test points.
%
% The predictive margin for a point x is the difference between the
% probability assigned to the most probable class and the
% second-most probable class:
%
%   margin(x | D) = p(y = y_1 | x, D) - p(y = y_2 | x, D),
%
% where y_1 and y_2 are the most and second-most probable class
% labels for x given the observations in D, respectively.
%
% Minimizing margin gives rise to a popular query strategy known as
% margin sampling.
%
% Usage:
%
%   scores = margin(problem, train_ind, observed_labels, test_ind, model)
%
% Inputs:
%
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the points eligible for observation
%             model: a handle to a probability model
%
% Output:
%
%   scores: a vector of margins for each point specified by test_ind
%
% See also SCORE_FUNCTIONS, MODELS, MARGIN_SAMPLING.

% Copyright (c) 2014 Roman Garnett.

function scores = margin(problem, train_ind, observed_labels, ...
          test_ind, model)

  probabilities = model(problem, train_ind, observed_labels, test_ind);
  probabilities = sort(probabilities, 2, 'descend');

  scores = probabilities(:, 1) - probabilities(:, 2);

end