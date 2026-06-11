[Page 384]

Figure 8.5

This shows the same model as in Figure 8.4 but with the deterministic parameters shown explicitly by the smaller solid nodes.

![image 164](../images/imageFile164.png)

x

α

n

w

2

σ

t

n

N

values, for example the variables { t n } from the training set in the case of polynomial curve ﬁtting. In a graphical model, we will denote such observed variables by shading the corresponding nodes. Thus the graph corresponding to Figure 8.5 in which the variables { t n } are observed is shown in Figure 8.6. Note that the value of w is not observed, and so w is an example of a latent variable, also known as a hidden variable. Such variables play a crucial role in many probabilistic models and will form the focus of Chapters 9 and 12.

Having observed the values { t n } we can, if desired, evaluate the posterior distribution of the polynomial coefﬁcients w as discussed in Section 1.2.5. For the moment, we note that this involves a straightforward application of Bayes’ theorem

$$
p ( w | T ) \, \infty \, p ( w ) \prod _ { n = 1 } ^ { N } p ( t _ { n } | w ) \\ \intertext { a n d t e r $ i n t e r $ a n d t e r $ i n c h e r $ } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text
$$

where again we have omitted the deterministic parameters in order to keep the notation uncluttered.

In general, model parameters such as w are of little direct interest in themselves, because our ultimate goal is to make predictions for new input values. Suppose we are given a new input value x and we wish to ﬁnd the corresponding probability distribution for t conditioned on the observed data. The graphical model that describes this problem is shown in Figure 8.7, and the corresponding joint distribution of all of the random variables in this model, conditioned on the deterministic parameters, is then given by

$$
i s \text { then given by} \\ p ( t , t , w | \widehat { x } , x , \alpha , \sigma ^ { 2 } ) = \left [ \prod _ { n = 1 } ^ { N } p ( t _ { n } | x _ { n } , w , \sigma ^ { 2 } ) \right ] p ( w | \alpha ) p ( \widehat { t } | x , w , \sigma ^ { 2 } ) . \\ \intertext { u s } \text { As in Figure 8.5 but with the nodes } \{ t _ { n } \} \text { shared}
$$

![image 165](../images/imageFile165.png)

Figure 8.6 As in Figure 8.5 but with the nodes { t n } shaded to indicate that the corresponding random variables have been set to their observed (training set) values.

x

α

n

w

2

σ

t

n
