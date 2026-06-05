[Page 384]

Figure 8.5 This shows the same model as in Figure 8.4 but with the deterministic parameters shown explicitly by the smaller solid nodes.

σ2

xn

tn

N

α

w

values, for example the variables {tn} from the training set in the case of polynomial curve ﬁtting. In a graphical model, we will denote such observed variables by shading the corresponding nodes. Thus the graph corresponding to Figure 8.5 in which the variables {tn} are observed is shown in Figure 8.6. Note that the value of w is not observed, and so w is an example of a latent variable, also known as a hidden variable. Such variables play a crucial role in many probabilistic models and will form the focus of Chapters 9 and 12.

Having observed the values {tn} we can, if desired, evaluate the posterior distribution of the polynomial coefﬁcients w as discussed in Section 1.2.5. For the moment, we note that this involves a straightforward application of Bayes’ theorem

�N

p(tn|w) (8.7)

p(w|T) ∝ p(w)

n=1

where again we have omitted the deterministic parameters in order to keep the notation uncluttered.

In general, model parameters such as w are of little direct interest in themselves, because our ultimate goal is to make predictions for new input values. Suppose we are given a new input value �x and we wish to ﬁnd the corresponding probability distribution for�t conditioned on the observed data. The graphical model that describes this problem is shown in Figure 8.7, and the corresponding joint distribution of all of the random variables in this model, conditioned on the deterministic parameters, is then given by

p(�t,t,w|�x,x,α,σ2) = � N

p(tn|xn,w,σ2)�p(w|α)p(�t|�x,w,σ2). (8.8)

�

n=1

Figure 8.6 As in Figure 8.5 but with the nodes {tn} shaded to indicate that the corresponding random variables have been set to their observed (training set) values.

xn

α

σ2

tn

w
