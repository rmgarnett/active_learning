% random forest classifier.
%
% function probabilities = rf_probability(data, responses, ...
%           train_ind, test_ind, num_trees, options)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses
%   train_ind: a list of indices into data/responses indicating
%              the training points
%    test_ind: a list of indices into data/responses indicating
%              the test points
%   num_trees: the number of trees to build in the random forest
%     options: (optional) additional options to pass into
%              TreeBagger for training
%
% outputs:
%   probabilites: a matrix of posterior probabilities.  the kth
%                 column gives the posterior probabilities
%                 p(y = k | x, D) for reach of the indicated
%                 test points
%
% copyright (c) roman garnett, 2011--2012

function probabilities = rf_probability(data, responses, ...
          train_ind, test_ind, num_trees, options)

  if (nargin < 6)
    options = [];
  end

  model = TreeBagger(num_trees, data(train_ind, :), responses(train_ind), ...
                     'method', 'classification', 'options', options);
  [~, probabilities] = predict(model, data(test_ind, :));

end