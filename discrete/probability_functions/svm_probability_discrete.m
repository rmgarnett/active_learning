% support vector machine classifier.
%
% function probabilities = svm_probability_discrete(data, responses, ...
%        train_ind, test_ind, varargin)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of 0/1 responses
%   train_ind: an index into data/responses indicating
%              the training points
%    test_ind: an index into data/responses indicating
%              the test points
%    varargin: all remaining inputs are passed to svmtrain
%
% outputs:
%   probabilities: a vector of posterior probabilities for the test data
%
% copyright (c) roman garnett, 2011

function probabilities = svm_probability_discrete(data, responses, ...
        train_ind, test_ind, varargin)

  model = svmtrain(data(train_ind, :), responses(train_ind), varargin{:});
  probabilities = svmclassify(model, data(test_ind, :));

end