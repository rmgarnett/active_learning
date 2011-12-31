% random forest classifier.
%
% function probabilities = rf_probability(data, responses, ...
%           train_ind, test_ind, num_trees, options)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0/1 responses
%   train_ind: a list of indices into data/responses
%              indicating the training points
%    test_ind: a list of indices into data/responses
%              indicating the test points
%   num_trees: the number of trees to build in the random forest
%     options: (optional) additional options to pass into
%              TreeBagger for training
%
% outputs:
%   probabilities: a vector of posterior probabilities for the test data
%
% copyright (c) roman garnett, 2011

function probabilities = rf_probability(data, responses, ...
          train_ind, test_ind, num_trees, options)

  if (nargin < 6)
    options = [];
  end

  model = TreeBagger(num_trees, data(train_ind, :), responses(train_ind), ...
                     'method', 'classification', 'options', options);
  [~, votes] = predict(model, data(test_ind, :));
  probabilities = votes(:, 2);

end