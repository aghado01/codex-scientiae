[Page 407]

choice of xC). Given this restriction, we can make a precise relationship between factorization and conditional independence.

To do this we again return to the concept of a graphical model as a ﬁlter, corresponding to Figure 8.25. Consider the set of all possible distributions deﬁned over a ﬁxed set of variables corresponding to the nodes of a particular undirected graph. We can deﬁne UI to be the set of such distributions that are consistent with the set of conditional independence statements that can be read from the graph using graph separation. Similarly, we can deﬁne UF to be the set of such distributions that can be expressed as a factorization of the form (8.39) with respect to the maximal cliques of the graph. The Hammersley-Clifford theorem (Clifford, 1990) states that the sets UI and UF are identical.

Because we are restricted to potential functions which are strictly positive it is convenient to express them as exponentials, so that

ψC(xC) = exp{−E(xC)} (8.41)

where E(xC) is called an energy function, and the exponential representation is called the Boltzmann distribution. The joint distribution is deﬁned as the product of potentials, and so the total energy is obtained by adding the energies of each of the maximal cliques.

In contrast to the factors in the joint distribution for a directed graph, the potentials in an undirected graph do not have a speciﬁc probabilistic interpretation. Although this gives greater ﬂexibility in choosing the potential functions, because there is no normalization constraint, it does raise the question of how to motivate a choice of potential function for a particular application. This can be done by viewing the potential function as expressing which conﬁgurations of the local variables are preferred to others. Global conﬁgurations that have a relatively high probability are those that ﬁnd a good balance in satisfying the (possibly conﬂicting) inﬂuences of the clique potentials. We turn now to a speciﬁc example to illustrate the use of undirected graphs.

###### 8.3.3 Illustration: Image de-noising

We can illustrate the application of undirected graphs using an example of noise removal from a binary image (Besag, 1974; Geman and Geman, 1984; Besag, 1986). Although a very simple example, this is typical of more sophisticated applications. Let the observed noisy image be described by an array of binary pixel values yi ∈ {−1,+1}, where the index i = 1,...,D runs over all pixels. We shall suppose that the image is obtained by taking an unknown noise-free image, described by binary pixel values xi ∈ {−1,+1} and randomly ﬂipping the sign of pixels with some small probability. An example binary image, together with a noise corrupted image obtained by ﬂipping the sign of the pixels with probability 10%, is shown in Figure 8.30. Given the noisy image, our goal is to recover the original noise-free image.

Because the noise level is small, we know that there will be a strong correlation

between xi and yi. We also know that neighbouring pixels xi and xj in an image are strongly correlated. This prior knowledge can be captured using the Markov
