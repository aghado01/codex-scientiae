[Page 408]

![image 89](../../../../../images/imageFile89.png)

![image 90](../../../../../images/imageFile90.png)

![image 91](../../../../../images/imageFile91.png)

![image 92](../../../../../images/imageFile92.png)

Figure 8.30 Illustration of image de-noising using a Markov random ﬁeld. The top row shows the original binary image on the left and the corrupted image after randomly changing 10% of the pixels on the right. The bottom row shows the restored images obtained using iterated conditional models (ICM) on the left and using the graph-cut algorithm on the right. ICM produces an image where 96% of the pixels agree with the original image, whereas the corresponding number for graph-cut is 99%.

random ﬁeld model whose undirected graph is shown in Figure 8.31. This graph has two types of cliques, each of which contains two variables. The cliques of the form {xi,yi} have an associated energy function that expresses the correlation between these variables. We choose a very simple energy function for these cliques of the form −ηxiyi where η is a positive constant. This has the desired effect of giving a lower energy (thus encouraging a higher probability) when xi and yi have the same sign and a higher energy when they have the opposite sign.

The remaining cliques comprise pairs of variables {xi,xj} where i and j are indices of neighbouring pixels. Again, we want the energy to be lower when the pixels have the same sign than when they have the opposite sign, and so we choose an energy given by −βxixj where β is a positive constant.

Because a potential function is an arbitrary, nonnegative function over a maximal clique, we can multiply it by any nonnegative functions of subsets of the clique, or
