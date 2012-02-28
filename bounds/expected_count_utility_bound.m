% bound on the l-step lookahead expected utility of an unlabeled point
% for the active search problem (corresponding to count_utility). this
% is accomplished via a function providing a bound on the maximum
% possible posterior probability after adding a number of positive
% observations. the expected interface for this function is
%
% function bound = probability_bound(data, responses, train_ind, ...
%                                    test_ind, num_positives)
%
% which should return an upper bound for the maximum posterior
% probability after adding num_positives positive observations.
%
% function bound = expected_count_utility_bound(data, responses, ...
%          train_ind, test_ind, probability_bound, lookahead, num_positives)
%
% inputs:
%                data: an (n x d) matrix of input data
%           responses: an (n x 1) vector of responses (class 1 is
%                      tested against "any other class")
%           train_ind: an index into data/responses indicating the
%                      training points
%            test_ind: an index into data/responses indicating the
%                      test points
%   probability_bound: a function handle providing a probability bound
%           lookahead: the number of steps of lookahead to consider
%       num_positives: the number of additional positive
%                      observations to consider having added
%
% outputs:
%   bound: an upper bound for the (lookahead)-step expected count
%          utilities of the unlabeled points
%
% copyright (c) roman garnett, 2011--2012

function bound = expected_count_utility_bound(data, responses, ...
          train_ind, test_ind, probability_bound, lookahead, num_positives)

  current_probability_bound = probability_bound(data, responses, ...
          train_ind, test_ind, num_positives);

  if (lookahead == 1)
    bound = current_probability_bound;
    return;
  end

  % the bound may be written recursively as follows
  bound = ...
      current_probability_bound * (1 + ...
          expected_count_utility_bound(data, responses, train_ind, ...
              test_ind, probability_bound, lookahead - 1, num_positives + 1)) + ...
      (1 - current_probability_bound) * ...
          expected_count_utility_bound(data, responses, train_ind, ...
              test_ind, probability_bound, lookahead - 1, num_positives);

end