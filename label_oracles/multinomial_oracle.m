% MULTINOMIAL_ORACLE multinomial oracle with given probabilities.
%
% This provides a label orcale that, conditioned on the queried point,
% samples labels indepdendently from a multinomial with given marginal
% probabilities.
%
% Usage:
%
%   label = multinomial_oracle(problem, query_ind, probabilities)
%
% Inputs:
%         problem: a struct describing the problem, containing the
%                  fields:
%
%                points: an (n x d) data matrix for the available points
%           num_classes: the number of classes
%
%                  Note: this input is ignored by multinomial_oracle.
%                  If desired, it can be replaced by an empty matrix.
%                  The struct is documented for reference below.
%
%       query_ind: an index into problem.points specifying the point
%                  to be queried
%   probabilities: an (n x problem.num_classes) matrix of
%                  class-membership probabilities corresponding to
%                  the points in problem.points
%
% Output:
%   label: an integer between 1 and problem.num_classes indicating the
%          observed label
%
% See also LABEL_ORACLES, BERNOULLI_ORACLE.

% Copyright (c) Roman Garnett 2013--2014

function label = multinomial_oracle(~, query_ind, probabilities)

  label = 1 + nnz(rand > cumsum(probabilities(query_ind, :)));

end