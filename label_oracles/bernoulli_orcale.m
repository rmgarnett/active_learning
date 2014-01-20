% A label orcale that, conditioned on the queried point, samples
% labels indepdendently from a Bernoulli with given success
% probability. Here membership to class 1 is treated as "success."
%
% function label = bernoulli_oracle(problem, query_ind, probabilities)
%
% inputs:
%         problem: a struct describing the problem, containing the
%                  fields:
%
%                points: an (n x d) data matrix for the available points
%           num_classes: the number of classes (here, should be 2)
%
%                  Note: this input is ignored by bernoulli_oracle.
%                  If desired, it can be replaced by an empty matrix.
%
%       query_ind: an index into problem.points specifying the point
%                  to be queried
%   probabilities: a length-n vector of success probabilities
%                  corresponding to the points in problem.points
%
% output:
%     label: an integer, either 1 or 2, indicating the observed
%            label. "1" indicates success.
%
% Copyright (c) Roman Garnett 2013--2014

function label = bernoulli_oracle(~, query_ind, probabilities)

  label = 1 + (rand > probabilities(query_ind));

end