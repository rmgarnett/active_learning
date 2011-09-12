if (~exist('initialized', 'var'))
  try
    matlabpool open;
  end

  addpath(genpath('~/work/dependencies/bmc'));
  initialized = true;
end
