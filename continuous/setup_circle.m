flip_percentage = 0;

num_evaluations = 10;
num_f_samples = 1000;

selection_function = @(n) rand(n, 2);

centers = [0.5 0.5];
radii = 1 / 4;
responses = false(num_observations, 1);
for i = 1:num_circles
  responses = responses | ...
      (sum((data - repmat(centers(i, :), num_observations, 1)).^2, 2) < ...
       radii(i).^2);
end

actual_proportion = pi / 16;
responses = 2 * responses - 1;