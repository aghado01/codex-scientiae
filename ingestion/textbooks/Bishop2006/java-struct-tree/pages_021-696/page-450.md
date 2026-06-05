[Page 450]

The image segmentation problem discussed above also provides an illustration of the use of clustering for data compression. Suppose the original image has N pixels comprising {R,G,B} values each of which is stored with 8 bits of precision. Then to transmit the whole image directly would cost 24N bits. Now suppose we ﬁrst run K-means on the image data, and then instead of transmitting the original pixel intensity vectors we transmit the identity of the nearest vector µk. Because there are K such vectors, this requires log2 K bits per pixel. We must also transmit the K code book vectors µk, which requires 24K bits, and so the total number of bits required to transmit the image is 24K + N log2 K (rounding up to the nearest integer). The original image shown in Figure 9.3 has 240 × 180 = 43,200 pixels and so requires 24 × 43,200 = 1,036,800 bits to transmit directly. By comparison, the compressed images require 43,248 bits (K = 2), 86,472 bits (K = 3), and 173,040 bits (K = 10), respectively, to transmit. These represent compression ratios compared to the original image of 4.2%, 8.3%, and 16.7%, respectively. We see that there is a trade-off between degree of compression and image quality. Note that our aim in this example is to illustrate the K-means algorithm. If we had been aiming to produce a good image compressor, then it would be more fruitful to consider small blocks of adjacent pixels, for instance 5×5, and thereby exploit the correlations that exist in natural images between nearby pixels.

9.2. Mixtures of Gaussians

In Section 2.3.9 we motivated the Gaussian mixture model as a simple linear superposition of Gaussian components, aimed at providing a richer class of density models than the single Gaussian. We now turn to a formulation of Gaussian mixtures in terms of discrete latent variables. This will provide us with a deeper insight into this important distribution, and will also serve to motivate the expectation-maximization algorithm.

Recall from (2.188) that the Gaussian mixture distribution can be written as a linear superposition of Gaussians in the form

�K

πkN(x|µk,Σk). (9.7)

p(x) =

k=1

Let us introduce a K-dimensional binary random variable z having a 1-of-K representation in which a particular element zk is equal to 1 and all other elements are equal to 0. The values of zk therefore satisfy zk ∈ {0,1} and

�

k zk = 1, and we see that there are K possible states for the vector z according to which element is nonzero. We shall deﬁne the joint distribution p(x,z) in terms of a marginal distribution p(z) and a conditional distribution p(x|z), corresponding to the graphical model in Figure 9.4. The marginal distribution over z is speciﬁed in terms of the mixing coefﬁcients πk, such that

p(zk = 1) = πk
