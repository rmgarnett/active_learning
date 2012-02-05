try
  if (matlabpool('size') == 0)
    matlabpool('open');
  end
end
