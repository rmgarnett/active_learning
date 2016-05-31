% MULTINOMIAL_ORACLE multinomial oracle with given probabilities.
%
% This provides a label oracle that, conditioned on queried point(s),
% samples labels independently from a multinomial with given marginal
% probabilities.
%
% Usage:
%
%   label = multinomial_oracle(problem, train_ind, observed_labels,
%                              query_ind, probabilities)
%
% Inputs:
%
%           problem: a struct describing the problem, containing the
%                    fields:
%
%                  points: an (n x d) data matrix for the avilable points
%             num_classes: the number of classes
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: the above inputs, part of the standard
%                    label oracle API, are ignored by
%                    multinomial_oracle. If desired, for standalone
%                    use it can be replaced by an empty matrix.
%
%          query_ind: an index into problem.points specifying the
%                     point(s) to be queried
%      probabilities: an (n x problem.num_classes) matrix of
%                     class-membership probabilities corresponding to
%                     the points in problem.points
%
% Output:
%
%   label: a list of integers between 1 and problem.num_classes
%          indicating the observed label(s)
%
% See also LABEL_ORACLES, BERNOULLI_ORACLE.

% Copyright (c) 2013--2016 Roman Garnett.

function label = multinomial_oracle(~, ~, ~, query_ind, probabilities)

  label = 1 + sum(bsxfun(@gt, rand(size(query_ind(:))), ...
                         cumsum(probabilities(query_ind, :), 2)), 2);

end