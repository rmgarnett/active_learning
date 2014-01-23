% BERNOULLI_ORACLE bernoulli oracle with given success probabilities.
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
%         problem: a struct describing the problem, containing the
%                  field:
%
%            points: an (n x d) data matrix for the available points
%
%                  Note: this input is ignored by bernoulli_oracle.
%                  If desired, it can be replaced by an empty matrix.
%                  The struct is documented for reference below.
%
%       query_ind: an index into problem.points specifying the point
%                  to be queried
%   probabilities: a length-n vector of success probabilities
%                  corresponding to the points in problem.points
%
% Output:
%     label: an integer, either 1 or 2, indicating the observed
%            label. "1" indicates success.
%
% See also LABEL_ORACLES, MULTINOMIAL_ORACLE.

% Copyright (c) Roman Garnett 2013--2014

function label = bernoulli_oracle(~, query_ind, probabilities)

  label = 1 + (rand > probabilities(query_ind));

end