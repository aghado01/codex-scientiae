[Page 657]

model for that particular observation. However, the latent variables {zn} are no longer treated as independent but now form a Markov chain.

Because the model is represented by a tree-structured directed graph, inference problems can be solved efﬁciently using the sum-product algorithm. The forward recursions, analogous to the α messages of the hidden Markov model, are known as the Kalman ﬁlter equations (Kalman, 1960; Zarchan and Musoff, 2005), and the backward recursions, analogous to the β messages, are known as the Kalman smoother equations, or the Rauch-Tung-Striebel (RTS) equations (Rauch et al., 1965). The Kalman ﬁlter is widely used in many real-time tracking applications.

Because the linear dynamical system is a linear-Gaussian model, the joint distribution over all variables, as well as all marginals and conditionals, will be Gaussian. It follows that the sequence of individually most probable latent variable values is

Exercise 13.19 the same as the most probable latent sequence. There is thus no need to consider the

analogue of the Viterbi algorithm for the linear dynamical system.

Because the model has linear-Gaussian conditional distributions, we can write the transition and emission distributions in the general form

p(zn|zn−1) = N(zn|Azn−1,Γ) (13.75)

p(xn|zn) = N(xn|Czn,Σ). (13.76) The initial latent variable also has a Gaussian distribution which we write as

p(z1) = N(z1|µ0,V0). (13.77)

Note that in order to simplify the notation, we have omitted additive constant terms from the means of the Gaussians. In fact, it is straightforward to include them if

Exercise 13.24 desired. Traditionally, these distributions are more commonly expressed in an equiv-

alent form in terms of noisy linear equations given by

zn = Azn−1 + wn (13.78) xn = Czn + vn (13.79)

z1 = µ0 + u (13.80) where the noise terms have the distributions

w ∼ N(w|0,Γ) (13.81) v ∼ N(v|0,Σ) (13.82) u ∼ N(u|0,V0). (13.83)

The parameters of the model, denoted by θ = {A,Γ,C,Σ,µ0,V0}, can be determined using maximum likelihood through the EM algorithm. In the E step, we need to solve the inference problem of determining the local posterior marginals for the latent variables, which can be solved efﬁciently using the sum-product algorithm, as we discuss in the next section.
