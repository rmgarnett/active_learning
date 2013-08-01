% selects points with posterior probability above a specified threshold.
%
% function test_ind = probability_treshold_selector(problem, ...
%           train_ind, observed_labels, probability, threshold)
%
% inputs:
%           problem: a struct describing the problem, containing fields:
%
%                   points: an n x d matrix describing the avilable points
%              num_classes: the number of classes
%              num_queries: the number of queries to make
%
%         train_ind: a list of indices into problem.points
%                    indicating the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%       probability: a handle to a probability
%
% outputs:
%    test_ind: an list of indices into problem.points indicating the
%              points to test
%
% copyright (c) roman garnett, 2011--2013

function test_ind = probability_treshold_selector(problem, ...
          train_ind, observed_labels, probability, threshold)

  test_ind = (1:size(problem.points, 1))';

  probabilities = probability(problem, train_ind, observed_labels, test_ind);

  test_ind = find(any(probabilities >= threshold), 2);

end
