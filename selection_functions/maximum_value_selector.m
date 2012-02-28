% selects the single point that maximizes a given function of the
% test points.
%
% function test_ind = maximum_value_selector(data, responses, train_ind, ...
%           objective_function)
%
% where
%                   data: an (n x d) matrix of input data
%              responses: an (n x 1) vector of responses
%              train_ind: a list of indices into data/responses indicating
%                         the training points
%    objectiove_function: a function handle providing a function
%                         with the interface
%
%                         values = objective_function(data, responses, ...
%                                                     train_ind)
%
%                         this function is expected to retrun a value
%                         for every data point not in train_ind, and
%                         ultimately the currently unlabeled point
%                         that maximizes this function will be chosen.
%
%   test_ind: an index into data/responses indicating the point
%             with the maximal value of the objective function
%
% copyright (c) roman garnett, 2012

function test_ind = maximum_value_selector(data, responses, train_ind, ...
          objective_function)

  values = objective_function(data, responses, train_ind);
  [~, best_ind] = max(values);

  test_ind = identity_selector(responses, train_ind);
  test_ind = test_ind(best_ind);

end