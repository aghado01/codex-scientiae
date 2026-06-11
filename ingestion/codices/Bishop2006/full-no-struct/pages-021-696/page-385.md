[Page 385]

Figure 8.7 The polynomial regression model, corresponding to Figure 8.6, showing also a new input value b x together with the corresponding model prediction b t .

![In this image, we can see a diagram with some lines and points. There is a circle in the middle of the image.](../images/imageFile166.png)

x

α

n

w

t

n

N

x

ˆ

2

σ

ˆ

t

The required predictive distribution for t is then obtained, from the sum rule of probability, by integrating out the model parameters w so that p ( t x, x , t ,α,σ 2 ) p ( t, t , w x, x ,α,σ 2 )d w

$$
& y , \, by \, \text {integrating out the model parameters } w \, \text { so that} \\ & \quad p ( \widehat { t } | \widehat { x } , \mathbf x , \mathbf t , \alpha , \sigma ^ { 2 } ) \, \infty \, \int p ( \widehat { t } , \mathbf t , w | \widehat { x } , \mathbf x , \alpha , \sigma ^ { 2 } ) \, d w \\ & \, \text { are implicitly setting the random variables in } \mathbf t \, \text { to the specific } w \\ & \, \text {the data set. The details of this calculation were discussed in Chai}
$$

where we are implicitly setting the random variables in t to the speciﬁc values observed in the data set. The details of this calculation were discussed in Chapter 3.

# 8.1.2 Generative models

There are many situations in which we wish to draw samples from a given probability distribution. Although we shall devote the whole of Chapter 11 to a detailed discussion of sampling methods, it is instructive to outline here one technique, called ancestral sampling , which is particularly relevant to graphical models. Consider a joint distribution p ( x 1 ,...,x K ) over K variables that factorizes according to (8.5) corresponding to a directed acyclic graph. We shall suppose that the variables have been ordered such that there are no links from any node to any lower numbered node, in other words each node has a higher number than any of its parents. Our goal is to draw a sample x 1 ,..., x K from the joint distribution. To do this, we start with the lowest-numbered node and draw a sample from the

    distribution p ( x 1 ) , which we call   x 1 . We then work through each of the nodes in order, so that for node n we draw a sample from the conditional distribution p ( x n | pa n ) in which the parent variables have been set to their sampled values. Note that at each stage, these parent values will always be available because they correspond to lowernumbered nodes that have already been sampled. Techniques for sampling from speciﬁc distributions will be discussed in detail in Chapter 11. Once we have sampled from the ﬁnal variable x K , we will have achieved our objective of obtaining a sample from the joint distribution. To obtain a sample from some marginal distribution corresponding to a subset of the variables, we simply take the sampled values for the required nodes and ignore the sampled values for the remaining nodes. For example, to draw a sample from the distribution p ( x 2 ,x 4 ) , we simply sample from the full joint distribution and then retain the values   x 2 ,   x 4 and discard the remaining values {   x j   =2 , 4 } .

/negationslash
