% function [train_ind utilities] = optimal_learning_discrete(data, ...
%           responses, train_ind, selection_function, probability_function, ...
%           expected_utility_function, utility_function, num_evaluations, ...
%           lookahead, verbose)
%
% perform optimal active learning on a set of discrete points for a
% particular utility function and lookahead.  this function supports
% using user-defined:
%
% - selection functions, which specify which among the unlabeled
%   points should have their expected utilities evaluated.
% - probability functions, which assign probabilities to indicated
%   test data from the current training set
% - expected utility functions, which calculate the expected
%   utility of the dataset after adding one of a specified set of
%   points
% - utility functions, which calculate the utility of a selected
%   set of points
%
% inputs:
%                        data: an (n x d) matrix of input data
%                   responses: an (n x 1) vector of 0 / 1 responses
%                   train_ind: an index into data/responses
%                              indicating the starting labeled points
%          selection_function: the selection function to use
%        probability_function: the probability function to use
%   expected_utility_function: the expected utility function to use
%            utility_function: the utility function to use
%             num_evaluations: the number of points to select
%                   lookahead: the number of steps to look ahead
%                     verbose: true to print status after each
%                              evaluation
%
% outputs:
%   train_ind: an index into data/observations indicating the
%              points in the final selected set
%   utilities: the utility of the dataset after adding each
%              successive point
%
% copyright (c) roman garnett, 2011

function [train_ind utilities] = optimal_learning_discrete(data, ...
          responses, train_ind, selection_function, probability_function, ...
          expected_utility_function, utility_function, num_evaluations, ...
          lookahead, verbose)
  
  if (nargin < 10)
    verbose = false;
  end

  utilities = zeros(num_evaluations, 1);

  for i = 1:num_evaluations
    if (verbose)
      tic;
      disp(['point ' num2str(i) ':']);
    end
    
    % do not look past the maximum number of evaluations
    lookahead = min(lookahead, num_evaluations - i + 1);

    % find the optimal next point to add given the current training
    % set and chosen utility function
    [best_utility, best_ind] = find_optimal_point(data, responses, ...
            train_ind, selection_function, probability_function, ...
            expected_utility_function, lookahead, verbose);
    
    % add the selected point
    train_ind(best_ind) = true;

    % measure our current success
    utilities(i) = utility_function(data, responses, train_ind);

    if (verbose)
      elapsed = toc;
      disp(['  ...expected utility: ' num2str(best_utility) ...
            ', true utility: ' num2str(utilities(i)) ...
            ', distribution (' num2str(nnz(responses(train_ind) == 1)) ...
            ' / ' num2str(nnz(train_ind)) ')' ...
            ', took: ' num2str(elapsed) 's.' ...
           ]);
   end
  end
end
