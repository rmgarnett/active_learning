function response_sample = map_response_sampler(data, responses, ...
          train_ind, probability_function)

  test_ind = identity_selector(responses, train_ind);

  probabilities = probability_function(data, responses, train_ind, test_ind);

  response_sample = responses;
  [~, response_sample(test_ind)] = max(probabilities, [], 2);

end
