num_observations = 500;
dimension = 2;

num_circles = 1;

flip_percentage = 0;

num_evaluations = 25;
num_f_samples = 1000;

data = rand(num_observations, dimension);

centers = [0.5 0.5];
radii = 1 / 4;
responses = false(num_observations, 1);
for i = 1:num_circles
  responses = responses | ...
      (sum((data - repmat(centers(i, :), num_observations, 1)).^2, 2) < ...
       radii(i).^2);
end

actual_proportion = mean(responses);
responses = 2 * responses - 1;

flip = rand(size(responses)) < flip_percentage;
responses(flip) = -responses(flip);

disp(['dimension: ' num2str(dimension) ', circles: ' num2str(num_circles)]);