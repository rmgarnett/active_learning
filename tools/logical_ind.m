function ind = logical_ind(array, ind)

  ind = subsref(find(array), struct('type', '()', 'subs', {{ind}}));

end