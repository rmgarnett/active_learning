% qpplies a given index to the nonzero elements of an array and
% return an index into a larger array.
%
% function ind = logical_ind(array, ind)
%
% inputs:
%   array: a numerical array
%     ind: an integer index into the nonzero elements of array
%
% outputs:
%   ind: a transformed integer index into the corresponding
%        elements of array
%
% copyright (c) 2012, roman garnett

function ind = logical_ind(array, ind)

  ind = subsref(find(array), struct('type', '()', 'subs', {{ind}}));

end