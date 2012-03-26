function upper_triangle_vector = extract_upper_triangle_vector(matrix)

  upper_triangle = triu(matrix);
  upper_triangle_vector = upper_triangle(triu(true(size(matrix))));

end