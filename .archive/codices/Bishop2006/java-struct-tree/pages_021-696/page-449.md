[Page 449]

K = 2 K = 3 K = 10 Original image

![image 94](../../../../../images/imageFile94.png)

![image 95](../../../../../images/imageFile95.png)

![image 96](../../../../../images/imageFile96.png)

![image 97](../../../../../images/imageFile97.png)

![image 98](../../../../../images/imageFile98.png)

![image 99](../../../../../images/imageFile99.png)

![image 100](../../../../../images/imageFile100.png)

![image 101](../../../../../images/imageFile101.png)

Figure 9.3 Two examples of the application of the K-means clustering algorithm to image segmentation showing the initial images together with their K-means segmentations obtained using various values of K. This also illustrates of the use of vector quantization for data compression, in which smaller values of K give higher compression at the expense of poorer image quality.

and remains the subject of active research and is introduced here simply to illustrate the behaviour of the K-means algorithm.

We can also use the result of a clustering algorithm to perform data compression. It is important to distinguish between lossless data compression, in which the goal is to be able to reconstruct the original data exactly from the compressed representation, and lossy data compression, in which we accept some errors in the reconstruction in return for higher levels of compression than can be achieved in the lossless case. We can apply the K-means algorithm to the problem of lossy data compression as follows. For each of the N data points, we store only the identity k of the cluster to which it is assigned. We also store the values of the K cluster centres µk, which typically requires signiﬁcantly less data, provided we choose K � N. Each data point is then approximated by its nearest centre µk. New data points can similarly be compressed by ﬁrst ﬁnding the nearest µk and then storing the label k instead of the original data vector. This framework is often called vector quantization, and the vectors µk are called code-book vectors.
