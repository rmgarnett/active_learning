if (~exist('initialized', 'var'))
  try
    matlabpool close force local;
  end
  try
    matlabpool open 4;
  end

  addpath(genpath('~/work/dependencies/bmc'));
  initialized = true;
end