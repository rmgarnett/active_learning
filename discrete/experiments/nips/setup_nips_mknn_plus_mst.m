k = 50;
pseudocount = 0.1;
weight_function = @(distances) (distances > 0);

probability_function = build_mknn_plus_mst_probability_discrete(data, ...
        k, weight_function, pseudocount);