% "cheating" probability, always predicts a delta distribution for
% each test point with mass on the output of the label oracle.
%
% function probabilities = cheating_probability(problem, test_ind, label_oracle)
%
% inputs:
%        problem: a struct describing the problem, containing fields:
%
%               points: an n x d matrix describing the avilable points
%           num_points: the number of points
%          num_classes: the number of classes
%          num_queries: the number of queries to make
%              verbose: whether to print messages after each query
%                       (default: false)
%
%       test_ind: a list of indices into problem.points indicating
%                 the test points
%   label_oracle: a function taking an index into problem.points
%                 and returning a label
%
% outputs:
%   probabilites: a matrix of posterior probabilities.  the kth column
%                 gives the posterior probabilities p(y = k | x, D)
%                 for reach of the indicated test points; here
%                 p(y = k | x, D) = 1 if the label oracle output k
%                 for y; otherwise 0.
%
% copyright (c) roman garnett, 2012--2013

function probabilities = cheating_probability(problem, test_ind, label_oracle)

  num_test = numel(test_ind);

  probabilities = zeros(num_test, problem.num_classes);
  for i = 1:num_test
    probabilities(i, label_oracle(problem, test_ind(i))) = 1;
  end

end