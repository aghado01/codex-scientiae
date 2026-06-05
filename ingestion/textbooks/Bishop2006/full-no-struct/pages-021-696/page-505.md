[Page 505]

to explaining the data will have their mixing coefﬁcients driven to zero during the optimization, and so they are effectively removed from the model through automatic relevance determination . This allows us to make a single training run in which we start with a relatively large initial value of K , and allow surplus components to be pruned out of the model. The origins of the sparsity when optimizing with respect to hyperparameters is discussed in detail in the context of the relevance vector machine.

# 10.2.5 Induced factorizations

In deriving these variational update equations for the Gaussian mixture model, we assumed a particular factorization of the variational posterior distribution given by (10.42). However, the optimal solutions for the various factors exhibit additional factorizations. In particular, the solution for q ( µ , Λ ) is given by the product of an independent distribution q ( µ k , Λ k ) over each of the components k of the mixture, whereas the variational posterior distribution q ( Z ) over the latent variables, given by (10.48), factorizes into an independent distribution q ( z n ) for each observation n (note that it does not further factorize with respect to k because, for each value of n , the z nk are constrained to sum to one over k ). These additional factorizations are a consequence of the interaction between the assumed factorization and the conditional independence properties of the true distribution, as characterized by the directed graph in Figure 10.5.

We shall refer to these additional factorizations as induced factorizations because they arise from an interaction between the factorization assumed in the variational posterior distribution and the conditional independence properties of the true joint distribution. In a numerical implementation of the variational approach it is important to take account of such additional factorizations. For instance, it would be very inefﬁcient to maintain a full precision matrix for the Gaussian distribution over a set of variables if the optimal form for that distribution always had a diagonal precision matrix (corresponding to a factorization with respect to the individual variables described by that Gaussian).

Such induced factorizations can easily be detected using a simple graphical test based on d-separation as follows. We partition the latent variables into three disjoint groups A , B , C and then let us suppose that we are assuming a factorization between C and the remaining latent variables, so that

$$
q ( A , B , C ) = q ( A , B ) q ( C ) .
$$

Using the general result (10.9), together with the product rule for probabilities, we see that the optimal solution for q ( A , B ) is given by

$$
\ln q ^ { * } ( A , B ) \ & = \ \mathbb { E } _ { C } [ \ln p ( X , A , B , C ) ] + \text {const} \\ & = \ \mathbb { E } _ { C } [ \ln p ( A , B | X , C ) ] + \text {const} . \\ \text {now, only} \ \intertext { w o n s k , w h o b y t h e r i g h e r i o n w i l l }
$$

We now ask whether this resulting solution will factorize between A and B , in other words whether q ( A , B ) = q ( A ) q ( B ) . This will happen if, and only if, ln p ( A , B | X , C ) = ln p ( A | X , C ) + ln p ( B | X , C ) , that is, if the conditional independence relation

$$
A \perp B \, | \, X , C
$$
