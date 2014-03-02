% BERNOULLI_ORACLE Bernoulli oracle with given success probabilities.
%
% This provides a label orcale that, conditioned on the queried point,
% samples labels indepdendently from a Bernoulli with given success
% probability. Here membership to class 1 is treated as "success."
%
% Usage:
%
%   label = bernoulli_oracle(problem, query_ind, probabilities)
%
% Inputs:
%
%         problem: a struct describing the problem, containing the
%                  field:
%
%            points: an (n x d) data matrix for the available points
%
%                  Note: this input, part of the standard label oracle
%                  API, is ignored by bernoulli_oracle. If desired,
%                  for standalone use it can be replaced by an empty
%                  matrix.
%
%       query_ind: an index into problem.points specifying the point
%                  to be queried
%   probabilities: a length-n vector of success probabilities
%                  corresponding to the points in problem.points
%
% Output:
%
%   label: an integer between 1 and problem.num_classes indicating the
%          observed label
%
% See also LABEL_ORACLES, MULTINOMIAL_ORACLE.

% Copyright (c) 2013--2014 Roman Garnett.

function label = bernoulli_oracle(~, query_ind, probabilities)

  label = 1 + (rand > probabilities(query_ind));

end