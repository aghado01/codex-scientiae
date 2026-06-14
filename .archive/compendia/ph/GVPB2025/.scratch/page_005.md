[Page 5]

Comparison to similar frameworks. A distinguishing feature of our methodology is the choice of a \(k\)-NN filtration, whose stability was discussed in [60] in the context of persistent homology, though it was never applied to zigzag persistence. A notable effort in describing spatio-temporal networks similarly to this work is [40], where the main summary statistic (the rank invariant) involves calculating a 6-dimensional data vector (4 across layers and 2 across scale) and thus combines a variation of both a time and a scale parameter, using the Rips filtration. Varying also the scale parameter is worth investigating in this context, and the techniques in [40] would be a starting point for implementing it. The work [61] from the same authors is also related to our work since the maximal group diagram and the persistence clustergram (cfr. Figure 2) are “annotated” (with the representative topological features) barcodes. In this work, they fix a scale similar to our case.

Zigzag Persistence Diagram. The output of the zigzag algorithm is then a multiset of birth-death pairs \([b, d]\)^4 , known as the persistence diagram

$$
P _ { \text {ers} _ { p } } ( \Phi ) = \left \{ [ b , d ] \ | \ b , d \in \{ 0 , \dots , 2 ( N _ { \text {layers} } - 1 ) \} \right \} .
$$

We thus work with a zigzag filtration naturally indexed by \(\{ 0, 1, 2, \dots, 2(N_{\text{layers}} - 1) \}\) . Specifically, as shown in the Figure 1, even numbers starting from 0 are assigned to \(p\)-dimensional holes that emerge and disappear within the model layers. In contrast, odd numbers are designated for features at the intersection layers. It is important to note that homology classes are defined as equivalence classes, meaning that a connected component (in the case of 0-dimensional homology) need not maintain the same form at the level of simplices throughout its lifetime. The orange connected component in the figure exemplifies this: in Layer 1 , it corresponds to the three points \(\{ x_5, x_6, x_7 \}\) connected by edges, forming a triangle. In the intersection layer, it is reduced to the edge \(\{ x_6, x_7 \}\) . In Layer 2 this edge merges with another connected component (depicted in red), marking the death of the orange component. This feature ensures the robustness of our construction to small changes in the \(k\)-NN graph. A mathematical explanation of this is provided in Appendix A. The algorithm that generates \(\text{Pers}_p(\Phi)\) is schematically described in Appendix B, and in Appendix C we show a toy example using a calendar month task to visualize how we track zigzag barcodes.

Effective Persistence Image. The pairs generated within Pers p (Φ) can be visualized through a persistence image , a well-known descriptor within the TDA tools. The persistence image in our case results in a grid of size \((2N_{\text{layers}} - 1) \times (2N_{\text{layers}} - 1)\) , for each homology dimension \(p\) . Each pixel in the grid is associated with an integer value corresponding to the number of holes appearing with that birth-death pair. Defined this way, the persistence image does not discriminate between the model and intersection layers. Their behavior is generally fairly different, and have an alternating structure between model and intersection layers. Hence, persistence images are not smooth as a function of layers. To achieve a smoother representation, we introduce effective persistence images , obtained by excluding the intersection layers from the construction. This is achieved by defining a map, similar to the approach in [62], that translates the collection of intervals from the zigzag persistence diagram of the filtration in equation 2 into intervals, where the birth and death occur only across model layers. Formally, for \(b, d > 0\) , we obtain:

$$
\widehat { P I } _ { p } ( b / 2 , d / 2 ) = & P I _ { p } ( b , d ) + P I _ { p } ( b - 1 , d ) \\ & + P I _ { p } ( b , d - 1 ) + P I _ { p } ( b - 1 , d - 1 ) ,
$$

where \(PI_p\) is the effective persistence image for the \(p\)-dimensional holes and \(b, d\) are model layers indexed by even numbers.^5

# 3.3 Zigzag Descriptors

The collection of \(PI_p\)s taken over all \(p\) contains all the information output from our zigzag algorithm, and gives a useful overview of the model as a whole. On the other hand, they are not easily tractable statistically and are hard to interpret. We extract two descriptors from the effective persistence image, defined below.

^4 The repetition of a pair \([b, d]\) indicates that multiple holes in dimension \(p\) have been created and destroyed in correspondence of the same layers.

^5 Note that this operation does not modify the information about the model layers contained in the original \(\text{Pers}_p(\Phi)\) , as it redefines consistently all the births and deaths.
