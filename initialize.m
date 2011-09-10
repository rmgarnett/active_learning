if (~exist('initialized', 'var'))
  try
    matlabpool close force;
    matlabpool open;
  end

  addpath(genpath('bmc'));
  initialized = true;
end
