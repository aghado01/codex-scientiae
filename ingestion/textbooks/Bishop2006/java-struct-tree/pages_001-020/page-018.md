[Page 18]

10.2.1 Variational distribution . . . . . . . . . . . . . . . . . . . . 475 10.2.2 Variational lower bound . . . . . . . . . . . . . . . . . . . 481 10.2.3 Predictive density . . . . . . . . . . . . . . . . . . . . . . . 482 10.2.4 Determining the number of components . . . . . . . . . . . 483 10.2.5 Induced factorizations . . . . . . . . . . . . . . . . . . . . 485

10.3 Variational Linear Regression . . . . . . . . . . . . . . . . . . . . 486 10.3.1 Variational distribution . . . . . . . . . . . . . . . . . . . . 486 10.3.2 Predictive distribution . . . . . . . . . . . . . . . . . . . . 488 10.3.3 Lower bound . . . . . . . . . . . . . . . . . . . . . . . . . 489

10.4 Exponential Family Distributions . . . . . . . . . . . . . . . . . . 490

10.4.1 Variational message passing . . . . . . . . . . . . . . . . . 491 10.5 Local Variational Methods . . . . . . . . . . . . . . . . . . . . . . 493 10.6 Variational Logistic Regression . . . . . . . . . . . . . . . . . . . 498

10.6.1 Variational posterior distribution . . . . . . . . . . . . . . . 498 10.6.2 Optimizing the variational parameters . . . . . . . . . . . . 500 10.6.3 Inference of hyperparameters . . . . . . . . . . . . . . . . 502

10.7 Expectation Propagation . . . . . . . . . . . . . . . . . . . . . . . 505 10.7.1 Example: The clutter problem . . . . . . . . . . . . . . . . 511 10.7.2 Expectation propagation on graphs . . . . . . . . . . . . . . 513

Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 517 11 Sampling Methods 523

11.1 Basic Sampling Algorithms . . . . . . . . . . . . . . . . . . . . . 526 11.1.1 Standard distributions . . . . . . . . . . . . . . . . . . . . 526 11.1.2 Rejection sampling . . . . . . . . . . . . . . . . . . . . . . 528 11.1.3 Adaptive rejection sampling . . . . . . . . . . . . . . . . . 530 11.1.4 Importance sampling . . . . . . . . . . . . . . . . . . . . . 532 11.1.5 Sampling-importance-resampling . . . . . . . . . . . . . . 534 11.1.6 Sampling and the EM algorithm . . . . . . . . . . . . . . . 536

11.2 Markov Chain Monte Carlo . . . . . . . . . . . . . . . . . . . . . 537 11.2.1 Markov chains . . . . . . . . . . . . . . . . . . . . . . . . 539 11.2.2 The Metropolis-Hastings algorithm . . . . . . . . . . . . . 541

11.3 Gibbs Sampling . . . . . . . . . . . . . . . . . . . . . . . . . . . 542 11.4 Slice Sampling . . . . . . . . . . . . . . . . . . . . . . . . . . . . 546 11.5 The Hybrid Monte Carlo Algorithm . . . . . . . . . . . . . . . . . 548

11.5.1 Dynamical systems . . . . . . . . . . . . . . . . . . . . . . 548 11.5.2 Hybrid Monte Carlo . . . . . . . . . . . . . . . . . . . . . 552

11.6 Estimating the Partition Function . . . . . . . . . . . . . . . . . . 554 Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 556

12 Continuous Latent Variables 559

12.1 Principal Component Analysis . . . . . . . . . . . . . . . . . . . . 561 12.1.1 Maximum variance formulation . . . . . . . . . . . . . . . 561 12.1.2 Minimum-error formulation . . . . . . . . . . . . . . . . . 563 12.1.3 Applications of PCA . . . . . . . . . . . . . . . . . . . . . 565 12.1.4 PCA for high-dimensional data . . . . . . . . . . . . . . . 569
