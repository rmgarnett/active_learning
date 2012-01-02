% calculates expected utilities for a random utility function
%
% u(D) = rand
%
% function expected_utilities = expected_random_utility(test_ind)
%
% inputs:
%   test_ind: a list of indices into data/responses
%             indicating the test data
% outputs:
%   expected_utilities: a vector indicating the expected utility of
%                       adding each indicated test point to the
%                       dataset
%
% copyright (c) roman garnett, 2011

function expected_utilities = expected_random_utility(test_ind)

  expected_utilities = rand(numel(test_ind), 1);

end