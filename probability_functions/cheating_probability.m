% "cheating" probability, always predicts a delta distribution for
% each test point with mass on the true label.
%
% function probabilities = cheating_probability(data, labels, train_ind, ...
%         test_ind)
%
% inputs:
%                  data: an (n x d) matrix of input data
%                labels: an (n x 1) vector of labels (class 1 is
%                        tested against "any other class")
%             train_ind: a list of indices into data/labels indicating
%                        the training points
%              test_ind: a list of indices into data/labels indicating
%                        the test points
%
% outputs:
%   probabilites: a matrix of posterior probabilities.  the kth column
%                 gives the posterior probabilities p(y = k | x, D)
%                 for reach of the indicated test points; here
%                 p(y = k | x, D) = 1 if y = k; otherwise 0.
%
% copyright (c) roman garnett, 2012

function probabilities = cheating_probability(labels, test_ind)

  num_test = numel(test_ind);
  num_classes = max(labels);
  
  probabilities = accumarray([(1:num_test)', labels(test_ind)], 1, ...
                             [num_test, num_classes]);
  
end