function [varargout] = ...
      gp_test_full_covariance_given_K(K, train_ind, test_ind, ...
            hyp, inf, mean, cov, lik, x, y, xs, ys)
% Calculate test set predictive probabilities given a specified
% Gaussian process prior, trianing data, and test points.  If desired,
% the negative log marginal likelihood of a Gaussian process and its
% partial derivatives with respect to the hyperparameters may be
% returned as well.
%
% Unlike gp_test, this function returns the full posterior GP
% covariance.
%
% Please call check_gp_arguments before calling this function.
%
% Usage:
%   [ymu ys2 fmu fs2 lp nlZ dnlZ] = ... 
%     gp_test_full_covariance(hyp, inf, mean, cov, lik, x, y, xs);
%
% where:
%
%   hyp      column vector of hyperparameters
%   inf      function specifying the inference method 
%   cov      prior covariance function (see below)
%   mean     prior mean function
%   lik      likelihood function
%   x        n by D matrix of training inputs
%   y        column vector of length n of training targets
%   xs       ns by D matrix of test inputs
%   ys       column vector of length nn of test targets
%
%   ymu      column vector (of length ns) of predictive output means
%   ys2      column vector (of length ns) of predictive output variances
%   fmu      column vector (of length ns) of predictive latent means
%   fs2      ns x ns matrix of predictive latent variance
%   lp       column vector (of length ns) of log predictive probabilities
%   nlZ      returned value of the negative log marginal likelihood
%   dnlZ     column vector of partial derivatives of the negative
% 
% See also covFunctions.m, infMethods.m, likFunctions.m, meanFunctions.m.
%
% Based on code from:
%
% GAUSSIAN PROCESS REGRESSION AND CLASSIFICATION Toolbox version 3.1
%    for GNU Octave 3.2.x and Matlab 7.x
% Copyright (c) 2005-2010 Carl Edward Rasmussen & Hannes Nickisch. All
% rights reserved.
%
% Copyright (c) 2011 Roman Garnett. All rights reserved.

% call the inference method
nlZ = [];
dnlZ = [];
try
  if (nargout < 6)        % no likelihood desired
    post = inf(hyp, mean, cov, lik, x, y);
  elseif (nargout < 7)    % likelihood desired
    [post nlZ] = inf(hyp, mean, cov, lik, x, y);
  else                    % likelihood and derivatives desired
    [post nlZ dnlZ] = inf(hyp, mean, cov, lik, x, y);
  end
catch msgstr
  disp('Inference method failed!');
  rethrow(msgstr);
end

alpha = post.alpha;
L = post.L; 
sW = post.sW;

% handle things for sparse representations
if (issparse(alpha))
  error('This method does not yet support sparse representations.\n');
end

% number of data points
ns = size(xs, 1);

% prior mean
ms = feval(mean{:}, hyp.mean, xs);

% cross-covariances
Ks = K(train_ind, test_ind);

% in case L is not provided, we compute it
if (numel(L) == 0)
  L = chol(eye(ns) + sW * sW' .* K(train_ind, train_ind));
end

% predictive means
fmu = ms + Ks' * alpha;

% prior test covariance
Kss = K(test_ind, test_ind);

% predictive covariance
V  = L' \ (repmat(sW, 1, size(xs, 1)) .* Ks);
fs2 = Kss - V' * V;

% assign output arguments
if (nargin < 12)
  [~, ymu, ys2] = lik(hyp.lik, [], fmu, diag(fs2));
  varargout = {ymu, ys2, fmu, fs2, [], nlZ, dnlZ};
else
  [lp, ymu, ys2] = lik(hyp.lik, ys, fmu, diag(fs2));
  varargout = {ymu, ys2, fmu, fs2, lp, nlZ, dnlZ};
end
