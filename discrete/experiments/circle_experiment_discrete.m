initialize;

num_observations = 500;
dimension = 2;

num_evaluations = 20;
num_f_samples = 1000;

data = rand(num_observations, dimension);

center = [0.5 0.5];
radius = 1 / 4;
responses = (sum((data - repmat(center, num_observations, 1)).^2, ...
                 2) < radius.^2);

actual_proportion = pi / 16;
responses = 2 * responses - 1;

active_estimation_discrete;