% utility function that is the negative variance in the class
% count distribution used by active surveying.
%
%   u(D) = -var[ \sum_i \chi(y_i = 1) | D ]
%
% function utility = negative_count_variance_utility(data, labels, ...
%           train_ind, count_estimator)
%
% inputs:
%              data: an (n x d) matrix of input data
%            labels: an (n x 1) vector of labels (class 1 is
%                    treated as "interesting")
%         train_ind: a list of indices into into data/labels
%                    indicating the training points
%   count_estimator: a handle to a proportion estimation function
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012

function utility = negative_count_variance_utility(data, labels, ...
          train_ind, count_estimator)

  [~, count_variance] = count_estimator(data, labels, train_ind);
  utility = -count_variance;

end
