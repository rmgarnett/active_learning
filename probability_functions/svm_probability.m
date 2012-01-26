% binary support vector machine classifier.
%
% function probabilities = svm_probability(data, responses, ...
%        train_ind, test_ind, varargin)
%
% inputs:
%        data: an (n x d) matrix of input data
%   responses: an (n x 1) vector of responses (class 1 is tested
%              against "any other class")
%   train_ind: a list of indices into data/responses
%              indicating the training points
%    test_ind: a list of indices into data/responses
%              indicating the test points
%    varargin: all remaining inputs are passed to svmtrain
%
% outputs:
%   probabilities: a matrix of posterior probabilities for the test
%                  data. column 1 is p(y = 1 | x, D); column 2 is
%                  p(y \neq 1 | x, D).
%
% copyright (c) roman garnett, 2011--2012

function probabilities = svm_probability(data, responses, ...
        train_ind, test_ind, varargin)

  % this method is limited to only binary classification
  if (any(responses > 2))
    warning('optimal_learning:multi-class_not_supported', ...
            ['svm_probability can only be used for binary problems! ' ...
             'will test class 1 vs "any other class."']);
  end

  % transform responses to what svmtrain/svmclassify expects
  responses(responses ~= 1) = 0;

  model = svmtrain(data(train_ind, :), responses(train_ind), varargin{:});
  probabilities = svmclassify(model, data(test_ind, :));
  probabilities = [probabilities (1 - probabilities)];

end