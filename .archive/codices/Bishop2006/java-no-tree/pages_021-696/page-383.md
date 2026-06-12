[Page 383]

- Figure 8.3 Directed graphical model representing the joint distribution (8.6) corresponding to the Bayesian polynomial regression model introduced in Section 1.2.6.

w

t1 tN

tion 1.2.6. The random variables in this model are the vector of polynomial coefﬁcients w and the observed data t = (t1,...,tN)T. In addition, this model contains the input data x = (x1,...,xN)T, the noise variance σ2, and the hyperparameter α representing the precision of the Gaussian prior over w, all of which are parameters of the model rather than random variables. Focussing just on the random variables for the moment, we see that the joint distribution is given by the product of the prior p(w) and N conditional distributions p(tn|w) for n = 1,...,N so that

p(t,w) = p(w)

N

n=1

p(tn|w). (8.6)

This joint distribution can be represented by a graphical model shown in Figure 8.3.

When we start to deal with more complex models later in the book, we shall ﬁnd it inconvenient to have to write out multiple nodes of the form t1,...,tN explicitly as in Figure 8.3. We therefore introduce a graphical notation that allows such multiple nodes to be expressed more compactly, in which we draw a single representative node tn and then surround this with a box, called a plate, labelled with N indicating that there are N nodes of this kind. Re-writing the graph of Figure 8.3 in this way, we obtain the graph shown in Figure 8.4.

We shall sometimes ﬁnd it helpful to make the parameters of a model, as well as its stochastic variables, explicit. In this case, (8.6) becomes

p(t,w|x,α,σ2) = p(w|α)

N

n=1

p(tn|w,xn,σ2).

Correspondingly, we can make x and α explicit in the graphical representation. To do this, we shall adopt the convention that random variables will be denoted by open circles, and deterministic parameters will be denoted by smaller solid circles. If we take the graph of Figure 8.4 and include the deterministic parameters, we obtain the graph shown in Figure 8.5.

When we apply a graphical model to a problem in machine learning or pattern recognition, we will typically set some of the random variables to speciﬁc observed

- Figure 8.4 An alternative, more compact, representation of the graph shown in Figure 8.3 in which we have introduced a plate (the box labelled N) that represents N nodes of which only a single example tn is shown explicitly.


###### w

tn
