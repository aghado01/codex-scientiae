[Page 17]

CONTENTS xvii

- 8 Graphical Models 359

- 8.1 Bayesian Networks . . . . . . . . . . . . . . . . . . . . . . . . . . 360

- 8.1.1 Example: Polynomial regression . . . . . . . . . . . . . . . 362
- 8.1.2 Generative models . . . . . . . . . . . . . . . . . . . . . . 365
- 8.1.3 Discrete variables . . . . . . . . . . . . . . . . . . . . . . . 366
- 8.1.4 Linear-Gaussian models . . . . . . . . . . . . . . . . . . . 370


- 8.2 Conditional Independence . . . . . . . . . . . . . . . . . . . . . . 372

- 8.2.1 Three example graphs . . . . . . . . . . . . . . . . . . . . 373
- 8.2.2 D-separation . . . . . . . . . . . . . . . . . . . . . . . . . 378


- 8.3 Markov Random Fields . . . . . . . . . . . . . . . . . . . . . . . 383 8.3.1 Conditional independence properties . . . . . . . . . . . . . 383 8.3.2 Factorization properties . . . . . . . . . . . . . . . . . . . 384 8.3.3 Illustration: Image de-noising . . . . . . . . . . . . . . . . 387 8.3.4 Relation to directed graphs . . . . . . . . . . . . . . . . . . 390
- 8.4 Inference in Graphical Models . . . . . . . . . . . . . . . . . . . . 393


- 8.4.1 Inference on a chain . . . . . . . . . . . . . . . . . . . . . 394
- 8.4.2 Trees . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 398
- 8.4.3 Factor graphs . . . . . . . . . . . . . . . . . . . . . . . . . 399
- 8.4.4 The sum-product algorithm . . . . . . . . . . . . . . . . . . 402
- 8.4.5 The max-sum algorithm . . . . . . . . . . . . . . . . . . . 411
- 8.4.6 Exact inference in general graphs . . . . . . . . . . . . . . 416
- 8.4.7 Loopy belief propagation . . . . . . . . . . . . . . . . . . . 417
- 8.4.8 Learning the graph structure . . . . . . . . . . . . . . . . . 418


Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 418

- 9 Mixture Models and EM 423

- 9.1 K-means Clustering . . . . . . . . . . . . . . . . . . . . . . . . . 424

- 9.1.1 Image segmentation and compression . . . . . . . . . . . . 428

9.2 Mixtures of Gaussians . . . . . . . . . . . . . . . . . . . . . . . . 430

- 9.2.1 Maximum likelihood . . . . . . . . . . . . . . . . . . . . . 432 9.2.2 EM for Gaussian mixtures . . . . . . . . . . . . . . . . . . 435


- 9.3 An Alternative View of EM . . . . . . . . . . . . . . . . . . . . . 439 9.3.1 Gaussian mixtures revisited . . . . . . . . . . . . . . . . . 441 9.3.2 Relation to K-means . . . . . . . . . . . . . . . . . . . . . 443 9.3.3 Mixtures of Bernoulli distributions . . . . . . . . . . . . . . 444 9.3.4 EM for Bayesian linear regression . . . . . . . . . . . . . . 448
- 9.4 The EM Algorithm in General . . . . . . . . . . . . . . . . . . . . 450 Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 455


- 10 Approximate Inference 461


- 10.1 Variational Inference . . . . . . . . . . . . . . . . . . . . . . . . . 462

- 10.1.1 Factorized distributions . . . . . . . . . . . . . . . . . . . . 464
- 10.1.2 Properties of factorized approximations . . . . . . . . . . . 466
- 10.1.3 Example: The univariate Gaussian . . . . . . . . . . . . . . 470
- 10.1.4 Model comparison . . . . . . . . . . . . . . . . . . . . . . 473


- 10.2 Illustration: Variational Mixture of Gaussians . . . . . . . . . . . . 474
