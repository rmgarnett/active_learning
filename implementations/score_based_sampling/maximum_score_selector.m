% selects the single point that maximizes a given function of the test
% points.
%
% function test_ind = maximum_value_selector(data, labels, train_ind, ...
%           objective_function)
%
% where
%             data: an (n x d) matrix of input data
%           labels: an (n x 1) vector of labels
%        train_ind: a list of indices into data/labels indicating the
%                   training points
%   score_function: a function handle providing a function with the
%                   interface
%
%                   scores = score_function(data, labels,
%                                           train_ind, test_ind)
%
%                   this function is expected to retrun a value for
%                   every data point in test_ind, and ultimately
%                   the currently unlabeled point that maximizes this
%                   function will be chosen.
%
%   test_ind: an index into data/labels indicating the point
%             with the maximal value of the score function
%
% copyright (c) roman garnett, 2012

function test_ind = maximum_score_selector(data, labels, train_ind, ...
          base_selection_function, score_function)

  test_ind = base_selection_function(data, labels, train_ind);

  scores = score_function(data, labels, train_ind, test_ind);
  [~, best_ind] = max(scores);

  test_ind = test_ind(best_ind);

end