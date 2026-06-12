[Page 16]

5.4.4 Finite differences . . . . . . . . . . . . . . . . . . . . . . . 252 5.4.5 Exact evaluation of the Hessian . . . . . . . . . . . . . . . 253 5.4.6 Fast multiplication by the Hessian . . . . . . . . . . . . . . 254

5.5 Regularization in Neural Networks . . . . . . . . . . . . . . . . . 256 5.5.1 Consistent Gaussian priors . . . . . . . . . . . . . . . . . . 257 5.5.2 Early stopping . . . . . . . . . . . . . . . . . . . . . . . . 259 5.5.3 Invariances . . . . . . . . . . . . . . . . . . . . . . . . . . 261 5.5.4 Tangent propagation . . . . . . . . . . . . . . . . . . . . . 263 5.5.5 Training with transformed data . . . . . . . . . . . . . . . . 265 5.5.6 Convolutional networks . . . . . . . . . . . . . . . . . . . 267 5.5.7 Soft weight sharing . . . . . . . . . . . . . . . . . . . . . . 269

5.6 Mixture Density Networks . . . . . . . . . . . . . . . . . . . . . . 272 5.7 Bayesian Neural Networks . . . . . . . . . . . . . . . . . . . . . . 277

5.7.1 Posterior parameter distribution . . . . . . . . . . . . . . . 278 5.7.2 Hyperparameter optimization . . . . . . . . . . . . . . . . 280 5.7.3 Bayesian neural networks for classiﬁcation . . . . . . . . . 281

Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 284

6 Kernel Methods 291 6.1 Dual Representations . . . . . . . . . . . . . . . . . . . . . . . . . 293 6.2 Constructing Kernels . . . . . . . . . . . . . . . . . . . . . . . . . 294 6.3 Radial Basis Function Networks . . . . . . . . . . . . . . . . . . . 299

6.3.1 Nadaraya-Watson model . . . . . . . . . . . . . . . . . . . 301

6.4 Gaussian Processes . . . . . . . . . . . . . . . . . . . . . . . . . . 303 6.4.1 Linear regression revisited . . . . . . . . . . . . . . . . . . 304 6.4.2 Gaussian processes for regression . . . . . . . . . . . . . . 306 6.4.3 Learning the hyperparameters . . . . . . . . . . . . . . . . 311 6.4.4 Automatic relevance determination . . . . . . . . . . . . . 312 6.4.5 Gaussian processes for classiﬁcation . . . . . . . . . . . . . 313 6.4.6 Laplace approximation . . . . . . . . . . . . . . . . . . . . 315 6.4.7 Connection to neural networks . . . . . . . . . . . . . . . . 319

Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 320 7 Sparse Kernel Machines 325

7.1 Maximum Margin Classiﬁers . . . . . . . . . . . . . . . . . . . . 326 7.1.1 Overlapping class distributions . . . . . . . . . . . . . . . . 331 7.1.2 Relation to logistic regression . . . . . . . . . . . . . . . . 336 7.1.3 Multiclass SVMs . . . . . . . . . . . . . . . . . . . . . . . 338 7.1.4 SVMs for regression . . . . . . . . . . . . . . . . . . . . . 339 7.1.5 Computational learning theory . . . . . . . . . . . . . . . . 344

7.2 Relevance Vector Machines . . . . . . . . . . . . . . . . . . . . . 345 7.2.1 RVM for regression . . . . . . . . . . . . . . . . . . . . . . 345 7.2.2 Analysis of sparsity . . . . . . . . . . . . . . . . . . . . . . 349 7.2.3 RVM for classiﬁcation . . . . . . . . . . . . . . . . . . . . 353

Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 357
