% function test_ind = probabiliy_treshold_selection_function(data, ...
%           responses, train_ind, probability_funciton, threshold)
%
% where
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of 0 / 1 responses
%              train_ind: an index into data/responses indicating the
%                         training points
%   probability_function: a function handle providing a probability function 
%              threshold: a value in [0, 1]; points with
%                         probability greater than this are selected
%
%   test_ind: an index into data/responses indicating the
%              points to test
%
% copyright (c) roman garnett, 2011

function test_ind = probabiliy_treshold_selection_function(data, ...
          responses, train_ind, probability_funciton, threshold)

  probabilities = ...
      probability_function(data, responses, train_ind, ~train_ind);

  test_ind = logical_ind(~train_ind, probabilities > threshold);

end
