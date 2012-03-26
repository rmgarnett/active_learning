function data = perform_row_normalization(data)

  data = diag(sum(data)) \ data;

end
