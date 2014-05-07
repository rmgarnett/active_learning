Active Learning Toolbox for MATLAB
==================================

This software package provides a toolbox for testing pool-based
active-learning algorithms in MATLAB.

Active Learning
---------------

Specifically, we consider the following scenario. There is a pool of
datapoints ![X][1]. We may successively select a set of points
![x in X][2] to observe. Each observation reveals a discrete,
integer-valued label ![y in L][3] for ![x][4]. This labeling process
might be nondeterministic; we might choose the same point ![x][4]
twice and observe different labels each time. In active learning, we
typically assume we have a budget ![B][5] that limits the number of
points we may observe.

Our goal is to iteratively build a set of observations

![D = (X, Y)][6]

that achieves some goal in an efficient manner. One typical goal is
that this training set allows us to accurately predict the labels on
the unobserved points. Assume we have a probabilistic model

![p(y | x, D)][7]

and let ![U = X \ X][8] represent the set of unobserved points. We
might with to minimize either the 0/1 loss on the unlabeled points

![\sum_{x in U} (\hat{y} \neq y)][9],

where ![\hat{y} = \argmax p(y | x, D)][10], or the log loss:

![\sum_{x in U} -\log p(y | x, D)][11].

We could sample a random set of ![B][5] points, but by careful
consideration of our observation locations, we hope we can do
significantly better than this. One common active learning strategy,
known as _uncertainty sampling_, iteratively chooses to make an
observation at the point with the largest marginal entropy given the
current data:

![x* = \argmax H(y | x, D)][12],

with the hope that these queries can better map out the boundaries
between classes.

Of course, there are countless goals besides minimizing generalization
error and numerous other strategies besides the highly myopic
uncertainty sampling. Indeed, many active learning scenerios might not
involve probability models at all. Providing a highly adaptable and
extensible toolbox for conducting arbitrary pool-based active learning
experiments is the goal of this project.

Using this Toolbox
------------------

The most-important function is `active_learning`, which simulates an
active learning experiment using the following procedure:

    Given: initially labeled points X,
	       corresponding labels Y,
		   budget B

    for i = 1:B
      % find points available for labeling
      eligible_points = selector(x, y)

      % decide on point(s) to observe
      x_star = query_strategy(x, y, eligible_points)

      % observe point(s)
      y_star = label_oracle(x_star)

      % add observation(s) to training set
      X = [X, x_star]
      Y = [Y, y_star]
    end

The implementation supports user-specified:

* _Selectors,_ which given the current training set, return a set of
  points currently eligible for labeling. See `selectors.m` for usage
  and available implementations.

* _Query strategies,_ which given a training set and the selected
  eligible points, decides which point(s) to observe next. Note that a
  query strategy can return multiple points, allowing for batch
  observations. See `query_strategies.m` for usage and available
  implementations.

* _Label oracles,_ which given a set of points, return a set of
  corresponding labels. Label oracles may optionally be
  nondeterministic (see, for example, `bernoulli_oracle`). See
  `label_oracles.m` for usage and available implementations.

Each of these are provided as function handles satisfying a desired
API, described below.

This function also supports arbitrary user-specified callbacks
called after each round of the experiment. This can be useful, for
example, for plotting the progress of the algorithm and/or printing
statistics such as test error online.

Selectors
---------

A _selector_ considers the current labeled dataset and indicates which
of the unlabeled points should be considered for observation at this
time.

Selectors must satisfy the following interface:

    test_ind = selector(problem, train_ind, observed_labels)

### Inputs: ###

* `problem`: a struct describing the problem, containing fields:

  *      `points`: an ![(n x d)][13] data matrix for the available points
  * `num_classes`: the number of classes
  * `num_queries`: the number of queries to make

* `train_ind`: a list of indices into `problem.points` indicating the
   thus-far observed points

* `observed_labels`: a list of labels corresponding to the
   observations in `train_ind`

### Output: ###

* `test_ind`: a list of indices into `problem.points` indicating the
   points to consider for labeling

The following general-purpose selectors are provided in this toolbox:

* `fixed_test_set_selector`: selects all points besides a given test
   set
* `graph_walk_selector`: confines an experiment to follow a path on a
   graph
* `identity_selector`: selects all points
* `random_selector`: selects a random subset of points
* `unlabeled_selector`: selects points not yet observed

In addition, the following "meta" selectors are provided, which
combine or modify the outputs of other selectors:

*   `complement_selector`: takes the complement of a selector's output
* `intersection_selector`: takes the intersection of the outputs of selectors
*        `union_selector`: takes the union of the outputs of selectors

Query Strategies
----------------

_Query strategies_ select which of the points currently eligible for
labeling (returned by a selector) should be observed next.

Query strategies must satisfy the following interface:

    query_ind = query_strategy(problem, train_ind, observed_labels, test_ind)

### Inputs: ###

* `problem`: a struct describing the problem, containing fields:

  *      `points`: an ![(n x d)][13] data matrix for the available points
  * `num_classes`: the number of classes
  * `num_queries`: the number of queries to make

* `train_ind`: a list of indices into `problem.points` indicating the
   thus-far observed points

* `observed_labels`: a list of labels corresponding to the
   observations in `train_ind`
* `test_ind`: a list of indices into `problem.points` indicating the
   points eligible for observation

### Output: ###

* `query_ind`: an index into `problem.points` indicating the point(s)
   to query next (every entry in `query_ind` will always be a member
   of the set of points in `test_ind`)

The following query strategies are provided in this toolbox:

* `argmax`: samples the point(s) maximizing a given score function
* `argmin`: samples the point(s) minimizing a given score function
* `expected_error_reduction`: samples the point giving lowest
   expected loss on unlabeled points
* `margin_sampling`: samples the point with the smallest margin
* `query_by_committee`: samples the point with the highest disagreement
   between models
* `uncertainty_sampling`: samples the most uncertain point

Label Oracles
-------------

_Label oracles_ are functions that, given a set of points chosen to be
queried, returns a set of corresponding labels. In general, they need
not be deterministic, which is especially interesting when points can
be queried multiple times.

Label oracles must satisfy the following interface:

    label = label_oracle(problem, query_ind)

### Inputs: ###

* `problem`: a struct describing the problem, containing fields:

  *      `points`: an ![(n x d)][13] data matrix for the available points
  * `num_classes`: the number of classes

* `query_ind`: an index into `problem.points` specifying the point(s) to be
   queried

### Output: ###

* `label`: a list of integers between 1 and `problem.num_classes`
   indicating the observed label(s)

The following general-purpose label oracles are provided in this
toolbox:

* `lookup_oracle`: a trivial lookup-table label oracle given a fixed
   list of ground-truth labels
* `bernoulli_oracle`: a label oracle that, conditioned on the queried
   point(s), samples labels independently from a Bernoulli distribution
   with given success probability
* `multinomial_oracle`: a label oracle that, conditioned on the
   queried point(s), samples labels independently from a multinomial
   distribution with given success probabilities

[1]: http://latex.codecogs.com/svg.latex?%5Cmathcal%7BX%7D
[2]: http://latex.codecogs.com/svg.latex?x%20%5Cin%20%5Cmathcal%7BX%7D
[3]: http://latex.codecogs.com/svg.latex?y%20%5Cin%20%5BL%5D
[4]: http://latex.codecogs.com/svg.latex?x
[5]: http://latex.codecogs.com/svg.latex?B
[6]: http://latex.codecogs.com/svg.latex?%5Cmathcal%7BD%7D%20%3D%20%5Cbigl%5Clbrace%20(x_i%2C%20y_i)%20%5Cbigr%20%5Crbrace_%7Bi%3D1%7D%5EB%20%3D%20(X%2C%20Y)
[7]: http://latex.codecogs.com/svg.latex?p(y%20%5Cmid%20x%2C%20%5Cmathcal%7BD%7D),
[8]: http://latex.codecogs.com/svg.latex?%5Cmathcal%7BU%7D%20%3D%20%5Cmathcal%7BX%7D%20%5Csetminus%20X
[9]: http://latex.codecogs.com/svg.latex?%5Csum_%7Bx%20%5Cin%20%5Cmathcal%7BU%7D%7D%20%5B%5Chat%7By%7D%20%5Cneq%20y%5D
[10]: http://latex.codecogs.com/svg.latex?%5Chat%7By%7D%20%3D%20%5Coperatorname%7Barg%5C%2Cmax%7D%20p(y%20%5Cmid%20x%2C%20%5Cmathcal%7BD%7D)
[11]: http://latex.codecogs.com/svg.latex?%5Csum_%7Bx%20%5Cin%20%5Cmathcal%7BU%7D%7D%20-%5Clog%20p(y%20%5Cmid%20x%2C%20%5Cmathcal%7BD%7D)
[12]: http://latex.codecogs.com/svg.latex?x%5E%5Cast%20%3D%20%5Coperatorname%7Barg%5C%2Cmax%7D_x%20H%5By%20%5Cmid%20x%2C%20%5Cmathcal%7BD%7D%5D
[13]: http://latex.codecogs.com/svg.latex?(n%20%5Ctimes%20d)
