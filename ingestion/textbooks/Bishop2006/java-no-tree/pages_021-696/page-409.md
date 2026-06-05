[Page 409]

Figure 8.31 An undirected graphical model representing a Markov random ﬁeld for image de-noising, in which xi is a binary variable denoting the state of pixel i in the unknown noise-free image, and yi denotes the corresponding value of pixel i in the observed noisy image.

yi

xi

equivalently we can add the corresponding energies. In this example, this allows us to add an extra term hxi for each pixel i in the noise-free image. Such a term has the effect of biasing the model towards pixel values that have one particular sign in preference to the other.

The complete energy function for the model then takes the form

E(x,y) = h

xi − β

xixj − η

i

{i,j}

which deﬁnes a joint distribution over x and y given by

i

xiyi (8.42)

p(x,y) =

1 Z

exp{−E(x,y)}. (8.43)

We now ﬁx the elements of y to the observed values given by the pixels of the noisy image, which implicitly deﬁnes a conditional distribution p(x|y) over noisefree images. This is an example of the Ising model, which has been widely studied in statistical physics. For the purposes of image restoration, we wish to ﬁnd an image x having a high probability (ideally the maximum probability). To do this we shall use a simple iterative technique called iterated conditional modes, or ICM (Kittler and F¨oglein, 1984), which is simply an application of coordinate-wise gradient ascent. The idea is ﬁrst to initialize the variables {xi}, which we do by simply setting xi = yi for all i. Then we take one node xj at a time and we evaluate the total energy for the two possible states xj = +1 and xj = −1, keeping all other node variables ﬁxed, and set xj to whichever state has the lower energy. This will either leave the probability unchanged, if xj is unchanged, or will increase it. Because only

- Exercise 8.13 one variable is changed, this is a simple local computation that can be performed efﬁciently. We then repeat the update for another site, and so on, until some suitable stopping criterion is satisﬁed. The nodes may be updated in a systematic way, for instance by repeatedly raster scanning through the image, or by choosing nodes at random.


If we have a sequence of updates in which every site is visited at least once, and in which no changes to the variables are made, then by deﬁnition the algorithm
