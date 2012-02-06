options_defined = true;
required_options = {'num_initial', 'num_experiments', 'num_evaluations', ...
                    'max_lookahead', 'report', 'balanced'};

for i = 1:numel(required_options)
  if (~exist(required_options{i}, 'var'))
  fprintf(['please define ' required_options{i} '.\n']);
  options_defined = false;
  end
end