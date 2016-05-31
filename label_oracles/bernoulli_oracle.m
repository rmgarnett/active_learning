% BERNOULLI_ORACLE Bernoulli oracle with given success probabilities.
%
% This provides a label oracle that, conditioned on queried point(s),
% samples labels independently from a Bernoulli with given success
% probability. Here membership to class 1 is treated as "success."
%
% Usage:
%
%   label = bernoulli_oracle(problem, train_ind, observed_labels, ...
%                            query_ind, probabilities)
%
% Inputs:
%
%           problem: a struct describing the problem, containing the
%                    field:
%
%                  points: an (n x d) data matrix for the avilable points
%
%         train_ind: a list of indices into problem.points indicating
%                    the thus-far observed points
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%
%                    Note: the above inputs, part of the standard
%                    label oracle API, are ignored by
%                    bernoulli_oracle. If desired, for standalone use
%                    it can be replaced by an empty matrix.
%
%         query_ind: an index into problem.points specifying the
%                    point(s) to be queried
%     probabilities: a length-n vector of success probabilities
%                    corresponding to the points in problem.points
%
% Output:
%
%   label: a list of integers between 1 and problem.num_classes
%          indicating the observed label(s)
%
% See also LABEL_ORACLES, MULTINOMIAL_ORACLE.

% Copyright (c) 2013--2016 Roman Garnett.

function label = bernoulli_oracle(~, ~, ~, query_ind, probabilities)

  label = 1 + (rand(size(query_ind(:))) > probabilities(query_ind));

end