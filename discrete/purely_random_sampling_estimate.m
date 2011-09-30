function [estimated_proportion proportion_variance in_train] = ...
  purely_random_sampling_estimate(responses, in_train, num_evaluations)

  test_ind = find(~in_train);
  r = randperm(numel(test_ind));

  in_train(test_ind(r(1:num_evaluations))) = true;

  estimated_proportion = mean((responses(in_train) + 1) / 2);
  proportion_variance = 0;
end