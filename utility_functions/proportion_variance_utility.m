% variance in the class proportion distribution used by active surveying.
%
% u(D) = -var[ \sum_i \chi(y_i = 1) | D ]
%
% function utility = maximum_variance_utility(data, responses, ...
%           train_ind, probability_function)
%
% inputs:
%                             data: an (n x d) matrix of input data
%                        responses: an (n x 1) vector of responses
%                                   (class 1 is treated as "interesting")
%                        train_ind: a list of indices into into
%                                   data/responses indicating the
%                                   training points
%   proportion_estimation_function: a handle to a proportion
%                                   estimation function
%
% outputs:
%   utility: the utility of the selected points
%
% copyright (c) roman garnett, 2011--2012

function utility = proportion_variance_utility(data, responses, ...
          train_ind, proportion_estimation_function)

  [~, proportion_variance] = proportion_estimation_function(data, ...
          responses, train_ind);
  utility = -proportion_variance;

end
