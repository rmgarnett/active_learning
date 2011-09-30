actual_proportions = zeros(100, 1);
purely_random_proportions = zeros(100, 1);
random_proportions = zeros(100, 10);
uncertainty_proportions = zeros(100, 10);
optimal_proportions = zeros(100, 10);
random_variances = zeros(100, 10);
uncertainty_variances = zeros(100, 10);
optimal_variances = zeros(100, 10);

for m = 1:100
  load(['results/3-10/results' num2str(m)]);
  actual_proportions(m) = actual_proportion;
  purely_random_proportions(m) = purely_random_estimated_proportion;
  random_proportions(m, :) = random_estimated_proportions';
  uncertainty_proportions(m, :) = uncertainty_estimated_proportions';
  optimal_proportions(m, :) =  optimal_estimated_proportions';
  random_variances(m, :) = random_proportion_variances';
  uncertainty_variances(m, :) = uncertainty_proportion_variances';
  optimal_variances(m, :) =  optimal_proportion_variances';
end
