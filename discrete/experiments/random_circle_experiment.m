initialize;

results_directory = 'results/2';

num_experiments = 200;

num_observations = 250;
dimension = 2;
flip_percentage = 0.05;

num_evaluations = 10;
num_f_samples = 1000;

for count = 1:num_experiments
  disp(['experiment ' num2str(count) ' of ' num2str(num_experiments)]);

  data = rand(num_observations, dimension);

  num_circles = randi([1 10], 1);
  centers = rand(num_circles, dimension);
  radii = rand(num_circles) / 2;
  responses = false(num_observations, 1);
  for i = 1:num_circles
    responses = responses | (sum((data - repmat(centers(i, :), ...
            num_observations, 1)).^2, 2) < radii(i).^2);
  end

  actual_proportion = mean(responses);
  responses = 2 * responses - 1;
  
  flip = rand(size(responses)) < flip_percentage;
  responses(flip) = -responses(flip);
  
  disp(['dimension: ' num2str(dimension) ', circles: ' ...
        num2str(num_circles)]);
  
  active_estimation_discrete;

  save([results_directory '/' num2str(count)]);
end