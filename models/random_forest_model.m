% A random forest classifier.
%
% Requires the TreeBagger class in the MATLAB Statistics Toolbox.
%
% function probabilities = random_forest_model(problem, train_ind, ...
%           observed_labels, test_ind, num_trees, options)
%
% inputs:
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%              points: an (n x d) data matrix for the avilable points
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%         num_trees: the number of trees to build in the random forest
%           options: (optional) additional options to pass into
%                    TreeBagger for training (default: [])
%
% output:
%   probabilities: a matrix of posterior probabilities. The ith
%                  column gives p(y = i | x, D) for each of the
%                  indicated test points.
%
% See also TreeBagger, models.

function probabilities = random_forest_model(problem, train_ind, ...
          observed_labels, test_ind, num_trees, options)

  if (nargin < 6)
    options = [];
  end

  model = TreeBagger(num_trees, problem.points(train_ind, :), observed_labels, ...
                     'method', 'classification', ...
                     'options', options);

  [~, probabilities] = predict(model, problem.points(test_ind, :));

end

% Copyright (c) Roman Garnett, 2011--2014
