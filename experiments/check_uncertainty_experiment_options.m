options_defined = true;
required_options = {'num_additional', 'seed', 'num_experiments', ...
                    'num_evaluations', 'report'};

for i = 1:numel(required_options)
  if (~exist(required_options{i}, 'var'))
    fprintf(['please define ' required_options{i} '.\n']);
    options_defined = false;
  end
end