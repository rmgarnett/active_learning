% A label orcale that, conditioned on the queried point, samples
% labels indepdendently from a multinomial with given marginal
% probabilities.
%
% function label = multinomial_oracle(problem, query_ind, probabilities)
%
% inputs:
%         problem: a struct describing the problem, containing the
%                  fields:
%
%                points: an (n x d) data matrix for the available points
%           num_classes: the number of classes
%
%                  Note: this input is ignored by multinomial_oracle.
%                  If desired, it can be replaced by an empty matrix.
%
%       query_ind: an index into problem.points specifying the point
%                  to be queried
%   probabilities: an (n x problem.num_classes) matrix of
%                  class-membership probabilities corresponding to
%                  the points in problem.points
%
% output:
%     label: an integer between 1 and problem.num_classes indicating
%            the observed label
%
% Copyright (c) Roman Garnett 2013--2014

function label = multinomial_oracle(~, query_ind, probabilities)

  label = 1 + nnz(rand > cumsum(probabilities(query_ind, :)));

end