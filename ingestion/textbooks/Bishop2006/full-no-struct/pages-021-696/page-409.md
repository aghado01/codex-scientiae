[Page 409]

Figure 8.31

An undirected graphical model representing a Markov random ﬁeld for image de-noising, in which x i is a binary variable denoting the state of pixel i in the unknown noise-free image, and y i denotes the corresponding value of pixel i in the observed noisy image.

![The image depicts a simple diagram consisting of a series of interconnected circular loops. Each loop is connected to the next, forming a continuous loop. The loops are connected by a single red line, which is the outermost line of the loop. The loops are arranged in a clockwise direction, starting from the top left and moving clockwise. Here is a detailed description of the image: - **Circular Loops:** The image is a simple diagram of a series of interconnected circular loops. Each loop is connected to the next, forming a continuous loop. The loops are connected by a single red line, which is the outermost line of the loop. - **Circular Loops:** The loops are connected by a single red line. The loops are connected by a single red line. - **Circular Loops:** The loops are connected by a single red line. The loops are connected by a single red line. - **Circular Loops:** The loops](../images/imageFile190.png)

y

i

x

i

equivalently we can add the corresponding energies. In this example, this allows us to add an extra term hx i for each pixel i in the noise-free image. Such a term has the effect of biasing the model towards pixel values that have one particular sign in preference to the other.

The complete energy function for the model then takes the form

$$
E ( x , y ) = h \sum _ { i } x _ { i } - \beta \sum _ { \{ i , j \} } x _ { i } x _ { j } - \eta \sum _ { i } x _ { i } y _ { i } \\
$$

which deﬁnes a joint distribution over x and y given by

$$
p ( x , y ) = \frac { 1 } { Z } \exp \{ - E ( x , y ) \} .
$$

We now ﬁx the elements of y to the observed values given by the pixels of the noisy image, which implicitly deﬁnes a conditional distribution p ( x | y ) over noisefree images. This is an example of the Ising model , which has been widely studied in statistical physics. For the purposes of image restoration, we wish to ﬁnd an image x having a high probability (ideally the maximum probability). To do this we shall use a simple iterative technique called iterated conditional modes , or ICM (Kittler and F¨ oglein, 1984), which is simply an application of coordinate-wise gradient ascent. The idea is ﬁrst to initialize the variables { x i } , which we do by simply setting x i = y i for all i . Then we take one node x j at a time and we evaluate the total energy for the two possible states x j = +1 and x j = − 1 , keeping all other node variables ﬁxed, and set x j to whichever state has the lower energy. This will either leave the probability unchanged, if x j is unchanged, or will increase it. Because only one variable is changed, this is a simple local computation that can be performed efﬁciently. We then repeat the update for another site, and so on, until some suitable stopping criterion is satisﬁed. The nodes may be updated in a systematic way, for instance by repeatedly raster scanning through the image, or by choosing nodes at random.

If we have a sequence of updates in which every site is visited at least once, and in which no changes to the variables are made, then by deﬁnition the algorithm
