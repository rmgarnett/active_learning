% Label oracles are functions that, given a point chosen to be
% queried, returns a corresponding label. In general, they need not be
% deterministic, which is especially interesting when points can be
% queried multiple times.
%
% Label oracles must satisfy the following interface:
%
%   label = label_oracle(problem, query_ind, labels)
%
% Inputs:
%
%     problem: a struct describing the problem, containing the fields:
%
%            points: an (n x d) data matrix for the available points
%       num_classes: the number of classes
%
%   query_ind: an index into problem.points specifying the point to be
%              queried
%
% Output:
%
%   label: an integer between 1 and problem.num_classes indicating the
%          observed label
%
% The following general-purpose label oracles are provided in this
% toolbox:
%
%        lookup_oracle: a trivial lookup-table label oracle given a
%                       fixed list of ground-truth labels
%     bernoulli_oracle: a label oracle that, conditioned on the
%                       queried point, samples labels independently
%                       from a Bernoulli distribution with given
%                       success probability
%   multinomial_oracle: a label oracle that, conditioned on the
%                       queried point, samples labels independently
%                       from a multinomial distribution with given
%                       success probabilities
%
% For convenience, the function get_label_oracle is provided for
% easily and concisely constructing function handles to label oracles
% for use, e.g., in active_learning.m.

% Copyright (c) 2014 Roman Garnett.
