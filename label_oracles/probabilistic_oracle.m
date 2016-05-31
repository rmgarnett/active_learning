% PROBABILISTIC_ORACLE multinomial oracle with model probabilities.
%
% This provides a label oracle that, conditioned on queried point(s),
% samples labels independently from a multinomial with marginal
% probabilities computed from a given model.
%
% Usage:
%
%   label = probabilistic_oracle(problem, train_ind, observed_labels,
%                                query_ind, model)
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
%         query_ind: an index into problem.points specifying the
%                    point(s) to be queried
%             model: a function handle to a model to use
%
% Output:
%
%   label: a list of integers between 1 and problem.num_classes
%          indicating the observed label(s)
%
% See also LABEL_ORACLES, MULTINOMIAL_ORACLE, MODELS.

% Copyright (c) 2016 Roman Garnett.

function label = probabilistic_oracle(problem, train_ind, observed_labels, ...
          query_ind, model)

  probabilities = model(problem, train_ind, observed_labels, query_ind);

  label = 1 + sum(bsxfun(@gt, rand(size(query_ind(:))), ...
                         cumsum(probabilities, 2)), 2);

end