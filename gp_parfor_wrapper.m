function [varargout] = ... 
  gp_parfor_wrapper(full_covariance, inference_hyperparameters, mean_hyperparameters, ...
                    covariance_hyperparameters, likelihood_hyperparameters, ...
                    varargin)

hyp.inf = inference_hyperparameters(:);
hyp.mean = mean_hyperparameters(:);
hyp.cov = covariance_hyperparameters(:);
hyp.lik = likelihood_hyperparameters(:);

if (full_covariance)
  [varargout{1:nargout}] = gp_full_covariance(hyp, varargin{:});
else
  [varargout{1:nargout}] = gp_with_likelihood(hyp, varargin{:});
end