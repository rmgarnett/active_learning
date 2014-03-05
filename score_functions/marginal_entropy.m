% MARGINAL_ENTROPY calculates predictive entropy on given test points.
%
% The predictive marginal entropy H for a point x given observations D
% is given by
%
%   H[y | x, D] = -\sum_i p(y = i | x, D) \log(p(y = i | x, D)).
%
% Maximizing the marginal entropy gives rise to a common query
% strategy known as uncertainty sampling.
%
% Usage:
%
%   scores = marginal_entropy(problem, train_ind, observed_labels, ...
%                             test_ind, model)
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
%                    the test points
%             model: a function handle to a probability model
%
% Output:
%
%   scores: a vector of marginal entropies for each point specified by
%           test_ind.
%
% See also: SCORE_FUNCTIONS, MODELS, UNCERTAINTY_SAMPLING.

% Copyright (c) 2013--2014 Roman Garnett.

function scores = marginal_entropy(problem, train_ind, observed_labels, ...
          test_ind, model)

  probabilities = model(problem, train_ind, observed_labels, test_ind);
  scores = -sum(probabilities .* log(probabilities), 2);

end