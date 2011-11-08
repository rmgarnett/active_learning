% function expected_utilities = expected_random_utility_discrete(test_ind)
%
% calculates expected utilities for a random utility function
%
% u(D) = rand
%
% inputs:
%               test_ind: an index into data/responses indicating
%                         the test data
% outputs:
%     expected_utilities: a vector indicating the expected utility of
%                         adding each indicated test point to the
%                         dataset
%
% Copyright (c) Roman Garnett, 2011

function expected_utilities = expected_random_utility_discrete(test_ind)

  expected_utilities = rand(length(test_ind), 1);

end