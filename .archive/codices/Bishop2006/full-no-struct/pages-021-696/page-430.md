[Page 430]

![The image depicts a series of interconnected circular shapes. These shapes are connected by lines, forming a web-like pattern. The shapes are arranged in a sequence, with each shape connected to the next. The lines are blue and appear to be the same length. Here is a detailed description of the image: ### Description of the Shapes: 1. **Circles**: - **Shape**: Circular - **Length**: 2 units - **Position**: Located at the top of the image. 2. **Triangles**: - **Shape**: Triangle - **Length**: 1 unit - **Position**: Located at the bottom of the image. 3. **Squares**: - **Shape**: Square - **Length**: 1 unit - **Position**: Located at the top of the image. 4. **Triangles**: - **Shape**: Triangle - **Length**: 1 unit - **Position**: Located](../images/imageFile211.png)

x

x

x

x

x

x

1

2

3

1

2

3

x

x

4

4

(a)

(b)

Figure 8.52 Flow of messages for the sum-product algorithm applied to the example graph in Figure 8.51. (a) From the leaf nodes x 1 and x 4 towards the root node x 3 . (b) From the root node towards the leaf nodes.

One message has now passed in each direction across each link, and we can now evaluate the marginals. As a simple check, let us verify that the marginal p ( x 2 ) is given by the correct expression. Using (8.63) and substituting for the messages using the above results, we have

$$
the above results, we have \\ & \widetilde { p } ( x _ { 2 } ) \ = \ \mu _ { a } \to _ { x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { b } } \to _ { x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } } \to _ { x _ { 2 } } ( x _ { 2 } ) \\ & = \ \left [ \sum _ { x _ { 1 } } f _ { a } ( x _ { 1 } , x _ { 2 } ) \right ] \left [ \sum _ { x _ { 3 } } f _ { b } ( x _ { 2 } , x _ { 3 } ) \right ] \left [ \sum _ { x _ { 4 } } f _ { c } ( x _ { 2 } , x _ { 4 } ) \right ] \\ & = \ \sum _ { x _ { 1 } } \sum _ { x _ { 2 } } \sum _ { x _ { 4 } } f _ { a } ( x _ { 1 } , x _ { 2 } ) f _ { b } ( x _ { 2 } , x _ { 3 } ) f _ { c } ( x _ { 2 } , x _ { 4 } ) \\ & = \ \sum _ { x _ { 1 } } \sum _ { x _ { 3 } } \sum _ { x _ { 4 } } \widetilde { p } ( x ) \\ \intertext { a r s u r i g e . } \text { So far, we have assumed that all of the variables in the graph are hidden. In most } \\ \text { practical applications, a subset of the variables will be observed, and we wish to cal- }
$$

as required.

So far, we have assumed that all of the variables in the graph are hidden. In most practical applications, a subset of the variables will be observed, and we wish to calculate posterior distributions conditioned on these observations. Observed nodes are easily handled within the sum-product algorithm as follows. Suppose we partition x into hidden variables h and observed variables v , and that the observed value of v is denoted v . Then we simply multiply the joint distribution p ( x ) by i I ( v i , v i ) , where I ( v, v ) = 1 if v = v and I ( v, v ) = 0 otherwise. This product corresponds to p ( h , v = v ) and hence is an unnormalized version of p ( h | v = v ) . By running the sum-product algorithm, we can efﬁciently calculate the posterior marginals p ( h i | v = v ) up to a normalization coefﬁcient whose value can be found efﬁciently using a local computation. Any summations over variables in v then collapse into a single term. We have assumed throughout this section that we are dealing with discrete vari-

ables. However, there is nothing speciﬁc to discrete variables either in the graphical framework or in the probabilistic construction of the sum-product algorithm. For
