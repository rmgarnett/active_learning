% copyright (c) roman garnett, 2011--2012

function probabilities = label_propagation_probability(A, labels, ...
          train_ind, test_ind, num_iterations, varargin)

  options = inputParser;

  options.addParamValue('use_prior', false, ...
                        @(x) (islogical(x) && (numel(x) == 1)));
  options.addParamValue('pseudocount', 0.1, ...
                        @(x) (isscalar(x) && (x > 0)));
  options.addParamValue('store_intermediate', false, ...
                        @(x) (islogical(x) && (numel(x) == 1)));
  options.addParamValue('alpha', 1, ...
                        @(x) (isscalar(x) && (x >= 0) && (x <= 1)));

  options.parse(varargin{:});
  options = options.Results;

  num_nodes   = size(A, 1);
  num_classes = max(labels);
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
    probabilities = zeros(num_nodes, num_classes, num_iterations + 1);
  else
    probabilities = zeros(num_nodes, num_classes);
  end

  iteration = 0;
  while (true)
    if (options.store_intermediate)
      probabilities(:, :, iteration + 1) = current_probabilities;
    end

    if (iteration == num_iterations)
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