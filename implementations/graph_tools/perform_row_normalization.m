function A = perform_row_normalization(A)

  A = bsxfun(@times, 1 ./ sum(A, 2), A);

end
