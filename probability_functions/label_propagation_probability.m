% an implementation of the partially absorbing label propagation
% algorithm described in:
%
%   Neumann, M., Garnett, R., and Kersting, K. Coinciding Walk
%   Kernels: Parallel Absorbing Random Walks for Learning with Graphs
%   and Few Labels. (2013). To appear in: Proceedings of the 5th
%   Annual Asian Conference on Machine Learning (ACML 2013).
%
% function probabilities = label_propagation_probability(problem, train_ind,
%   observed_labels, test_ind, A, varargin)
%
% required inputs:
%           problem: a struct describing the problem, containing
%                    the field:
%
%             num_classses: the number of classes
%
%         train_ind: a list of indices into A comprising the
%                    training nodes
%   observed_labels: a list of integer labels corresponding to the
%                    nodes in train_ind
%          test_ind: a list of indices into A comprising the test
%                    nodes
%                 A: the adjacency matrix for the graph under
%                    consideration
%
% optional named arguments specified after requried inputs:
%      'num_iterations': the number of label propagation iterations to
%                        use (default: 200)
%               'alpha': the absorbtion parameter to use in [0, 1]
%                        (default: 1)
%           'use_prior': a boolean indicating whether to use the
%                        empirical distribution on the training points
%                        as the prior (true) or a uniform prior (false)
%                        (default: false)
%         'pseudocount': if use_prior is set to true, a per-class
%                        pseudocount can also be specified (default: 1)
%  'store_intermediate': whether to store the probabilities for
%                        every iteration of label propagation
%                        (default: false)
%
% outputs:
%   probabilities: a matrix containing the probabilities on the
%                  test points.  if n is the number of test points and
%                  k is the number of classes, then this matrix has
%                  size (n x k) (if store_intermediate is false) or
%                  (n x k x num_iterations) (if store_intermediate
%                  is true)
%
% copyright (c) Roman Garnett, 2013.

function probabilities = label_propagation_probability(problem, train_ind,
  observed_labels, test_ind, A, varargin)

  options = inputParser;
  options.addParamValue('num_iterations', 200, ...
                        @(x) (isscalar(x) && (x >= 0)));
  options.addParamValue('alpha', 1, ...
                        @(x) (isscalar(x) && (x >= 0) && (x <= 1)));
  options.addParamValue('use_prior', false, ...
                        @(x) (islogical(x) && (numel(x) == 1)));
  options.addParamValue('pseudocount', 0.1, ...
                        @(x) (isscalar(x) && (x > 0)));
  options.addParamValue('store_intermediate', false, ...
                        @(x) (islogical(x) && (numel(x) == 1)));

  options.parse(varargin{:});
  options = options.Results;

  num_nodes   = size(A, 1);
  num_classes = problem.num_classes;
  num_train   = numel(train_ind);

  if (options.use_prior)
    prior = options.pseudocount * ones(1, num_classes) + ...
            histc(labels(train_ind), 1:num_classes)';
    prior = prior / sum(prior);
  else
    prior = ones(1, num_classes) / num_classes;
  end

  A = [A, zeros(num_nodes, num_classes); ...
       zeros(num_classes, num_nodes + num_classes)];

  A(train_ind, :) = (1 - options.alpha) * A(train_ind, :);

  A = A + sparse(train_ind, num_nodes + labels(train_ind), options.alpha, ...
                 num_nodes + num_classes, num_nodes + num_classes);

  pseudo_train_ind = (num_nodes + 1):(num_nodes + num_classes);
  A(pseudo_train_ind, pseudo_train_ind) = speye(num_classes);

  current_probabilities = repmat(prior, [num_nodes + num_classes, 1]);
  current_probabilities(train_ind, :) = ...
      accumarray([(1:num_train)', labels(train_ind)], 1, [num_train, num_classes]);
  current_probabilities(pseudo_train_ind, :) = eye(num_classes);

  num_nodes = size(A, 1);

  if (options.store_intermediate)
    probabilities = zeros(num_nodes, num_classes, options.num_iterations + 1);
  else
    probabilities = zeros(num_nodes, num_classes);
  end

  iteration = 0;
  while (true)
    if (options.store_intermediate)
      probabilities(:, :, iteration + 1) = current_probabilities;
    end

    if (iteration == options.num_iterations)
      break;
    end

    current_probabilities = A * current_probabilities;

    iteration = iteration + 1;
  end

  if (options.store_intermediate)
    probabilities = probabilities(test_ind, :, :);
  else
    probabilities = current_probabilities(test_ind, :);
  end
end