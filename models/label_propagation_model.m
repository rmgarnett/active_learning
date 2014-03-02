% LABEL_PROPAGATION_MODEL partially abosrbing label propagation.
%
% This is an implementation of the partially absorbing label
% propagation algorithm described in:
%
%   Neumann, M., Garnett, R., and Kersting, K. Coinciding Walk
%   Kernels: Parallel Absorbing Random Walks for Learning with Graphs
%   and Few Labels. (2013). Proceedings of the 5th Annual Asian
%   Conference on Machine Learning (ACML 2013).
%
% Usage:
%
%   probabilities = label_propagation_model(problem, train_ind, ...
%           observed_labels, test_ind, A, varargin)
%
% Required inputs:
%
%           problem: a struct describing the problem, which must at
%                    least contain the field:
%
%             num_classes: the number of classes
%
%         train_ind: a list of indices into A indicating the thus-far
%                    observed nodes
%   observed_labels: a list of labels corresponding to the
%                    observations in train_ind
%          test_ind: a list of indices into A indicating the test
%                    nodes
%                 A: a weighted adjacency matrix for the desired graph
%                    containing transition probabilities. A should be
%                    row-normalized.
%
% Optional name/value-pair arguments specified after requried inputs:
%
%      'num_iterations': the number of label propagation iterations to
%                        perform (default: 200)
%               'alpha': the absorbtion parameter to use in [0, 1]
%                        (default: 1, corresponds to standard label
%                        propagation)
%           'use_prior': a boolean indicating whether to use the
%                        empirical distribution on the training points
%                        as the prior (true) or a uniform prior
%                        (false) (default: false)
%         'pseudocount': if use_prior is set to true, a per-class
%                        pseudocount can also be specified (default: 1)
%
% Output:
%
%   probabilities: a matrix of posterior probabilities. The ith
%                  column gives p(y = i | x, D) for each of the
%                  indicated test points.
%
% See also MODELS, GRAPH_WALK_SELECTOR.

% Copyright (c) 2014 Roman Garnett.

function probabilities = label_propagation_model(problem, train_ind, ...
          observed_labels, test_ind, A, varargin)

  % parse optional inputs
  options = inputParser;

  options.addParamValue('num_iterations', 200, ...
                        @(x) (isscalar(x) && (x >= 0)));
  options.addParamValue('alpha', 1, ...
                        @(x) (isscalar(x) && (x >= 0) && (x <= 1)));
  options.addParamValue('use_prior', false, ...
                        @(x) (islogical(x) && (numel(x) == 1)));
  options.addParamValue('pseudocount', 0.1, ...
                        @(x) (isscalar(x) && (x > 0)));

  options.parse(varargin{:});
  options = options.Results;

  % check whether A is row-normalized
  if (any(sum(A) ~= 1))
    A = bsxfun(@times, A, 1 ./ sum(A, 2));
  end

  num_nodes   = size(A, 1);
  num_classes = problem.num_classes;
  num_train   = numel(train_ind);

  if (options.use_prior)
    prior = options.pseudocount + ...
            accumarray(observed_labels, 1, [1, num_classes]);
    prior = prior * (1 ./ sum(prior));
  else
    prior = ones(1, num_classes) * (1 / num_classes);
  end

  % expand graph with pseudonodes corresponding to the classes
  num_expanded_nodes = num_nodes + num_classes;

  A = [A, sparse(num_nodes, num_classes); ...
       sparse(num_classes, num_expanded_nodes)];

  % reduce weight of edges leaving training nodes by a factor of
  % (1 - alpha)
  A(train_ind, :) = (1 - options.alpha) * A(train_ind, :);

  % add edges from training nodes to label nodes with weight alpha
  A = A + sparse(train_ind, num_nodes + observed_labels, options.alpha, ...
                 num_expanded_nodes, num_expanded_nodes);

  % add self loops on label nodes
  pseudo_train_ind = (num_nodes + 1):num_expanded_nodes;
  A(pseudo_train_ind, pseudo_train_ind) = speye(num_classes);

  % begin with prior on all nodes
  probabilities = repmat(prior, [num_nodes + num_classes, 1]);

  % fill in known training labels
  probabilities(train_ind, :) = ...
      accumarray([(1:num_train)', observed_labels], 1, [num_train, num_classes]);

  % add knwon labels for label nodes
  probabilities(pseudo_train_ind, :) = eye(num_classes);

  for i = 1:options.num_iterations
    % propagate labels
    probabilities = A * probabilities;
  end

  probabilities = probabilities(test_ind, :);
end