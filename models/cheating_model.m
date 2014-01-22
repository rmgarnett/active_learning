% A "cheating" model.
%
% This model always predicts a delta distribution for each test point
% with mass on the output of a given label oracle.
%
% function probabilities = cheating_model(problem, train_ind, ...
%           observed_labels, test_ind, label_oracle)
%
% inputs:
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%
%                    Note: this input is ignored by cheating_model.
%                    If desired, it can be replaced by an empty matrix.
%
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: this input is ignored by cheating_model.
%                    If desired, it can be replaced by an empty matrix.
%
%          test_ind: a list of indices into problem.points indicating
%                    the test points
%      label_oracle: a handle to a label oracle. which takes an index
%                    into problem.points and returns a label
%
% outputs:
%   probabilities: a matrix of posterior probabilities. The ith column
%                  gives the posterior probabilities p(y = i | x, D)
%                  for each of the indicated test points; here
%                  p(y = i | x, D) = 1 if the label oracle output i
%                  for y; otherwise 0.
%
% See also models.

% Copyright (c) Roman Garnett, 2012--2014

function probabilities = cheating_model(problem, ~, ~, test_ind, label_oracle)

  num_test = numel(test_ind);

  probabilities = zeros(num_test, problem.num_classes);
  for i = 1:num_test
    probabilities(i, label_oracle(problem, test_ind(i))) = 1;
  end

end