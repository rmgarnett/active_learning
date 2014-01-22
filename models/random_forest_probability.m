% random forest classifier.
%
% function probabilities = random_forest_probability(problem, ...
%           train_ind, observed_labels, test_ind, num_trees, options)
%
% inputs:
%           problem: a struct describing the problem, containing the field:
%
%             points: an n x d matrix describing the avilable points
%
%         train_ind: a list of indices into problem.points indicating
%                    the training points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%         num_trees: the number of trees to build in the random forest
%           options: (optional) additional options to pass into
%                    TreeBagger for training (default: [])
%
% output:
%   probabilites: a matrix of posterior probabilities.  the kth
%                 column gives the posterior probabilities
%                 p(y = k | x, D) for each of the indicated
%                 test points
%
% copyright (c) roman garnett, 2011--2013

function probabilities = random_forest_probability(problem, ...
          train_ind, observed_labels, test_ind, num_trees, options)

  if (nargin < 6)
    options = [];
  end

  model = TreeBagger(num_trees, problem.points(train_ind, :), observed_labels, ...
                     'method', 'classification', ...
                     'options', options);
  [~, probabilities] = predict(model, problem.points(test_ind, :));

end