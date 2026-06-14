[Page 8]

(a)

Two intersecting cylindrical surfaces

(b)

The intersection point set 𝑃


,𝑢,𝑣


(c) The Mapper graph of 𝑃


,𝑢,𝑣


(d) Mapper graph after removing characteristic nodes

![The image is a diagram with five different types of curves. Each curve is labeled with a number and a symbol. The labels and symbols are as follows: 1. **Two intersecting cylindrical surfaces**: - The curve is labeled as Two intersecting cylindrical surfaces. - The symbol is a circle with a line segment connecting two points. 2. **Intersection point set**: - The curve is labeled as The intersection point set. - The symbol is a circle with a line segment connecting two points. 3. **Mapped graph of P**: - The curve is labeled as The mapped graph of P. - The symbol is a circle with a line segment connecting two points. 4. **Corresponding results of P**: - The curve is labeled as Corresponding results of P. - The symbol is a circle with a line segment connecting two points. 5. **Mapped graph of P**: - The curve is](<GLL2026/imageFile5.png>)

(e)

The partitioning result of 𝑃


,𝑢,𝑣


(f) Corresponding results of 𝑃 2 ,𝑠,𝑡

Fig. 5: An example of intersecting set partition based on the Mapper graph.

(a)

The

point set


intersection

,𝑢,𝑣


(b)



.



![In this image, we can see a diagram with a line and a point.](<GLL2026/imageFile6.png>)

(c)



.



(d)



.



(e)



.



Fig. 6: An example of the impact of changing the overlap ratio parameter 𝜃 ov .

and Hess , 2021 ] to compute the Mapper graph. In our experiments, we will show that the algorithm can successfully understand the topology of intersection.

# 5.1. Parameter selection for the Two-step Mapper algorithm

The overlap ratio 𝜃 ov is a key parameter in the Mapper algorithm. This section analyzes its influence on the resulting graph structure. The overlap ratio controls the degree of overlap

𝜃 ov between two adjacent intervals when constructing the cover. According to Eq. 8 , the interval length 𝑙 is proportional to 1∕ 𝜃 ov .Consequently,increasing 𝜃 ov leadstoshorterintervals and a larger number of nodes in the resulting Mapper graph. This produces a more compact and detailed graph representation, but at the expense of increased computational cost.

Figure 6 illustrates the effect of varying 𝜃 ov . When 𝜃 ov = 0 . 1 , the graph is sparsely connected due to the large interval length. When 𝜃 ov = 0 . 2 , the node distribution becomes significantly denser and more informative. When 𝜃 ov is further increased to 0 . 4 , the graph continues to become denser; however, the growth trend becomes less pronounced. This behavior is consistent with the relationship between 𝑙 and 𝜃 ov . To balance the expressive capability of the Mapper representation and computational efficiency, we set 𝜃 ov = 0 . 2 in the following experiments.

# 5.2. Experimental results

In this section, we apply the proposed algorithm to a series of surface/surface intersections with complex topology to validate its effectiveness.
