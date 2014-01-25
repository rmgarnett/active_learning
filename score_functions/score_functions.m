% Score function should have the following interface:
%
%   scores = score_function(problem, train_ind, observed_labels, test_ind)
%
% Inputs:
%           problem: a struct describing the problem, containing fields:
%
%                  points: an (n x d) data matrix for the available points
%             num_classes: the number of classes
%             num_queries: the number of queries to make
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%
% Output:
%   scores: a vector of real-valued scores; one for each point
%           specified by test_ind

% Copyright (C) Roman Garnett, 2014
