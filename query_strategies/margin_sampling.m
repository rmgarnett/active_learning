% MARGIN_SAMPLING queries the point with the smallest margin.
%
% This is an implementation of margin sampling, a simple and popular
% query strategy. Margin sampling successively queries the point with
% the smallest margin:
%
%   x* = argmin margin(x | D),
%
% where margin(x | D) is the predictive margin of x given the
% observations in D:
%
%   margin(x | D) = p(y = y_1 | x, D) - p(y = y_2 | x, D),
%
% where y_1 and y_2 are the most and second-most probable class
% labels for x, respectively.
%
% For binary problems, this coincides with uncertainty sampling.
%
% Usage:
%
%   query_ind = margin_sampling(problem, train_ind, observed_labels, ...
%           test_ind, model)
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
%             model: a function handle to a probability model
%
% Output:
%
%   query_ind: an index into test_ind indicating the point to query
%              next
%
% See also MODELS, MARGIN, QUERY_STRATEGIES.

% Copyright (c) 2014 Roman Garnett.

function query_ind = margin_sampling(problem, train_ind, observed_labels, ...
          test_ind, model)

  score_function = get_score_function(@margin, model);

  query_ind = argmin(problem, train_ind, observed_labels, test_ind, ...
                     score_function);

end