[Page 409]

Figure 8.31 An undirected graphical model representing a Markov random ﬁeld for image de-noising, in which $x_i$ is a binary variable denoting the state of pixel $i$ in the unknown noise-free image, and $y_i$ denotes the corresponding value of pixel $i$ in the observed noisy image.

![image 190](../images/imageFile190.png)

equivalently we can add the corresponding energies. In this example, this allows us to add an extra term $hx_i$ for each pixel $i$ in the noise-free image. Such a term has the effect of biasing the model towards pixel values that have one particular sign in preference to the other.

The complete energy function for the model then takes the form

$$
E(\mathbf{x}, \mathbf{y}) = h \sum_i x_i - \beta \sum_{\{i, j\}} x_i x_j - \eta \sum_i x_i y_i \tag{8.42}
$$

which deﬁnes a joint distribution over $\mathbf{x}$ and $\mathbf{y}$ given by

$$
p(\mathbf{x}, \mathbf{y}) = \frac{1}{Z} \exp\{-E(\mathbf{x}, \mathbf{y})\}. \tag{8.43}
$$

We now ﬁx the elements of $\mathbf{y}$ to the observed values given by the pixels of the noisy image, which implicitly deﬁnes a conditional distribution $p(\mathbf{x}|\mathbf{y})$ over noisefree images. This is an example of the Ising model, which has been widely studied in statistical physics. For the purposes of image restoration, we wish to ﬁnd an image $\mathbf{x}$ having a high probability (ideally the maximum probability). To do this we shall use a simple iterative technique called iterated conditional modes, or ICM (Kittler and Föglein, 1984), which is simply an application of coordinate-wise gradient ascent. The idea is ﬁrst to initialize the variables $\{x_i\}$, which we do by simply setting $x_i = y_i$ for all $i$. Then we take one node $x_j$ at a time and we evaluate the total energy for the two possible states $x_j = +1$ and $x_j = -1$, keeping all other node variables ﬁxed, and set $x_j$ to whichever state has the lower energy. This will either leave the probability unchanged, if $x_j$ is unchanged, or will increase it. Because only one variable is changed, this is a simple local computation that can be performed efﬁciently. We then repeat the update for another site, and so on, until some suitable stopping criterion is satisﬁed. The nodes may be updated in a systematic way, for instance by repeatedly raster scanning through the image, or by choosing nodes at random.

If we have a sequence of updates in which every site is visited at least once, and in which no changes to the variables are made, then by deﬁnition the algorithm
