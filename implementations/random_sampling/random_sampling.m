function [chosen_ind, utilities] = random_sampling(data, responses, ...
          train_ind, utility_function, selection_functions, ...
          num_evaluations, verbose)

  % set verbose to false if not defined
  verbose = exist('verbose', 'var') && verbose;

  probability_function = [];
  lookahead = 0;

  [chosen_ind, utilities] = optimal_learning(data, responses, ...
          train_ind, utility_function, probability_function, ...
          selection_functions, lookahead, num_evaluations, verbose);

end
