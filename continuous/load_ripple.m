load ~/work/data/active_mean/ripple_vectors
load ~/work/data/active_mean/people
load ~/work/data/active_mean/hostile

data = get_pca(2, normalized_eigenvectors, normalized_eigenvalues);
data = data(people, :);
num_observations = size(data, 1);

responses = hostile(:);
responses(responses == 0) = -1;
actual_proportion = mean(responses == 1);
