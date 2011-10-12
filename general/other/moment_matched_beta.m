function [alpha beta] = moment_matched_beta(mean, variance)

  alpha = (mean^2 - mean * variance - mean^3) / variance;
  beta = (mean^3 - 2 * mean^2 + mean * variance + mean - variance) / variance;
end