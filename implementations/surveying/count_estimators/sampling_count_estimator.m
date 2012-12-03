function [expected_count, count_variance] = ...
      sampling_count_estimator(label_samples)

  counts = sum(label_samples == 1);
  
  expected_count = mean(counts);
  count_variance = var(counts);
  
end
