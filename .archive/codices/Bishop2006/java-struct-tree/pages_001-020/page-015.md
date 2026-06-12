[Page 15]

CONTENTS xv

4 Linear Models for Classiﬁcation 179

4.1 Discriminant Functions . . . . . . . . . . . . . . . . . . . . . . . . 181 4.1.1 Two classes . . . . . . . . . . . . . . . . . . . . . . . . . . 181 4.1.2 Multiple classes . . . . . . . . . . . . . . . . . . . . . . . . 182 4.1.3 Least squares for classiﬁcation . . . . . . . . . . . . . . . . 184 4.1.4 Fisher’s linear discriminant . . . . . . . . . . . . . . . . . . 186 4.1.5 Relation to least squares . . . . . . . . . . . . . . . . . . . 189 4.1.6 Fisher’s discriminant for multiple classes . . . . . . . . . . 191 4.1.7 The perceptron algorithm . . . . . . . . . . . . . . . . . . . 192

4.2 Probabilistic Generative Models . . . . . . . . . . . . . . . . . . . 196 4.2.1 Continuous inputs . . . . . . . . . . . . . . . . . . . . . . 198 4.2.2 Maximum likelihood solution . . . . . . . . . . . . . . . . 200 4.2.3 Discrete features . . . . . . . . . . . . . . . . . . . . . . . 202 4.2.4 Exponential family . . . . . . . . . . . . . . . . . . . . . . 202

4.3 Probabilistic Discriminative Models . . . . . . . . . . . . . . . . . 203 4.3.1 Fixed basis functions . . . . . . . . . . . . . . . . . . . . . 204 4.3.2 Logistic regression . . . . . . . . . . . . . . . . . . . . . . 205 4.3.3 Iterative reweighted least squares . . . . . . . . . . . . . . 207 4.3.4 Multiclass logistic regression . . . . . . . . . . . . . . . . . 209 4.3.5 Probit regression . . . . . . . . . . . . . . . . . . . . . . . 210 4.3.6 Canonical link functions . . . . . . . . . . . . . . . . . . . 212

4.4 The Laplace Approximation . . . . . . . . . . . . . . . . . . . . . 213 4.4.1 Model comparison and BIC . . . . . . . . . . . . . . . . . 216

4.5 Bayesian Logistic Regression . . . . . . . . . . . . . . . . . . . . 217 4.5.1 Laplace approximation . . . . . . . . . . . . . . . . . . . . 217 4.5.2 Predictive distribution . . . . . . . . . . . . . . . . . . . . 218

Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 220 5 Neural Networks 225

5.1 Feed-forward Network Functions . . . . . . . . . . . . . . . . . . 227 5.1.1 Weight-space symmetries . . . . . . . . . . . . . . . . . . 231

5.2 Network Training . . . . . . . . . . . . . . . . . . . . . . . . . . . 232 5.2.1 Parameter optimization . . . . . . . . . . . . . . . . . . . . 236 5.2.2 Local quadratic approximation . . . . . . . . . . . . . . . . 237 5.2.3 Use of gradient information . . . . . . . . . . . . . . . . . 239 5.2.4 Gradient descent optimization . . . . . . . . . . . . . . . . 240

5.3 Error Backpropagation . . . . . . . . . . . . . . . . . . . . . . . . 241 5.3.1 Evaluation of error-function derivatives . . . . . . . . . . . 242 5.3.2 A simple example . . . . . . . . . . . . . . . . . . . . . . 245 5.3.3 Efﬁciency of backpropagation . . . . . . . . . . . . . . . . 246 5.3.4 The Jacobian matrix . . . . . . . . . . . . . . . . . . . . . 247

5.4 The Hessian Matrix . . . . . . . . . . . . . . . . . . . . . . . . . . 249 5.4.1 Diagonal approximation . . . . . . . . . . . . . . . . . . . 250 5.4.2 Outer product approximation . . . . . . . . . . . . . . . . . 251 5.4.3 Inverse Hessian . . . . . . . . . . . . . . . . . . . . . . . . 252
