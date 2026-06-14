[Page 13]

The random variable Σ x ( { z } ) (which depends only on the realization of the observation noise once x,z are ﬁxed) determines the probability that we reconstruct z when the true conﬁguration is x . As we have conditioned on the true value of the signal at X 0 ,X v 1 ,...,X v k for | v | > m , we can assume that the true conﬁguration is correctly reconstructed on the boundary z r = x r for r ∈ ∂J . We want to show that the probability of correctly reconstructing the true conﬁguration at a given site inside J (e.g., X 0 k which corresponds to the point 0 := ( k, 0) ∈ J ) remains bounded away from 1 2 with high probability, no matter how far this site is from the boundary ∂J . 0 0

Now suppose that z = x , that is, that the conﬁguration at 0 is incorrectly decoded. Then there must exist an interface between the set of incorrectly decoded vertices (that contains 0 ) and the set of correctly decoded vertices (that contains the boundary ∂J ). This is illustrated in the following ﬁgure, where correctly decoded vertices are indicated by white circles and incorrectly decoded vertices are indicated by black circles:

glyph[negationslash]

···

![The image is a graph titled M-M-1, which represents a series of discrete values. The graph is composed of a series of interconnected hexagonal boxes, each containing a different number of dots. The dots are connected by lines, forming a grid-like structure. The graph is labeled with the labels m+1, m+2, m+3, and m+4, indicating the values of the variables m and m+1, m+2, m+3, and m+4. The graph is visually represented with a series of dots, each representing a different value. The dots are connected by lines, forming a grid-like structure. The dots are connected by lines, forming a grid-like structure. The graph is labeled with the labels m+1, m+2, m+3, and m+4, indicating the values of the variables m and m+1, m+2, m](<RVH2020/imageFile1.png>)









.

.

.





-


-


.

.

.

-


-


-


We call the shaded region a contour : it has the key property that every edge that crosses its boundary connects an incorrectly decoded site inside with a correctly decoded site outside (it also proves to be convenient to assume contours are simply connected, i.e., that they have no holes; this is why the white vertex is included in the shaded region).

The main idea of the proof is that when the error probability p is close to zero, it is very unlikely that a decoded conﬁguration z contains many edges that connect a correctly decoded site r with an incorrectly decoded site q . Intuitively, if the error probability p is small, then the observations reveal with a high degree of conﬁdence whether x q and x r coincide or diﬀer; therefore, if we reconstruct one (in)correctly, then it is very likely that the other will be reconstructed (in)correctly as well. More precisely, the Σ x -probability of reconstructing a conﬁguration that contains a given contour J ⊆ J is exponentially small in the length of the boundary of J (Lemma 3.7 below). It then follows from a simple union bound that the probability that the decoded conﬁguration contains any contour that includes 0 is bounded away from 1 2 . But this completes the proof, as at least one such contour must be present if 0 is incorrectly decoded. (Of course, the crucial insight behind this approach is that the probability of containing a given contour and the number of contours of a given length do not depend on the size of the domain, so that all the estimates that appear in this argument are dimension-free.)

We now proceed to make these ideas precise.
