[Page 3]

[0.00, 1.00]

[1.60, 2.60]

[3.20, 4.20]

[0.80, 1.80]

[2.40, 3.40]

(a)

![In this image we can see a diagram with some text and numbers.](<GLL2026/imageFile1.png>)

C)

(c)

(b)

(d)

Fig. 1: An example of the Mapper algorithm. The data is sampled from a noisy circle, and the filter function is 𝑓 ( 𝑥 ) = 𝑥 1 , where 𝑥 = ( 𝑥 1 ,𝑥 2 ) is a point in 𝑋 . (a) The point set 𝑋 colored by the value of the filter function 𝑓 . (b)The range of 𝑓 is covered with five equal-length intervals, with a 20% overlap of neighboring intervals. (c)The DBSCAN algorithm [ Ester et al. , 1996 ] is used to cluster the preimage for each interval. (d)Nodes of the mapper graph are colored by the average filter function value.

(a)

(c)

(b)

![In this image, we can see a graph. On the graph, we can see numbers.](<GLL2026/imageFile2.png>)

(d)

Fig. 2: An example of the subdivision method. (a)Initial axisaligned bounding box on the ( 𝑢,𝑣 ) parameter domain. Each surface is initially divided into two surface patches within the parameter domain. (b)Results after 1 subdivision operation. (c)Results after 1000 subdivision operation. (d)Results after 4000 subdivision operation.

# 3.2. Surface intersection by subdivision method

In this section, we introduce the general idea of the subdivision method for solving the intersection of B-spline surfaces without involving specific implementations. The core idea of the subdivision method in solving the intersection of B-spline surfaces is to narrow down potential intersection regions through gradual subdivision of the surface parameter domain and the judgment of geometric relationships, and finally determine the intersection point sets. Its basic steps are as follows. Construction of initial bounding boxes and predic-

tion of intersection possibility . For the two B-spline surfaces 𝐵 1 ( 𝑢,𝑣 ) and 𝐵 2 ( 𝑠,𝑡 ) involved in the intersection calculation, first, initial surface patches are divided within their respective parameter domains, and an axis-aligned bounding box is constructed for each surface patch. By judging whether the bounding boxes of two surface patches intersect, we can quickly eliminate the combinations of surface patches that cannot have intersection curves: if the bounding boxes have no intersection, the corresponding surface patches must not intersect and can be directly eliminated; if the bounding boxes intersect, the surface patches may intersect and need to proceed to the next step of processing. Subdivision of parameter domain . For surface patches

Subdivision of parameter domain . For surface patches with intersecting bounding boxes, it is necessary to subdivide the corresponding parameter domain rectangles, dividing the original rectangles into smaller sub-rectangles, each corresponding to a more refined sub-surface patch. At the same time, a new bounding box is constructed for each sub-surface patch, and the above-mentioned intersection possibility prediction process is repeated until the bounding boxes of the sub-surface patches do not intersect (and thus can be eliminated) or the size of the sub-surface patches reaches the preset precision threshold. Fig. 2 illustrates the subdivision process of the ( 𝑢, 𝑣 ) parameter domain. Each surface is initially divided into two surface patches within the parameter domain. Through iterative subdivision and intersection detection, the remaining rectangular bounding boxes progressively narrow in the actual intersection.

boxes progressively narrow in the actual intersection. Extraction of intersection point set . After iterative subdivision, we obtain two strip-shaped intersection regions on the parameter domains of two B-spline surfaces 𝐵 1 ( 𝑢,𝑣 ) and 𝐵 2 ( 𝑠,𝑡 ) . In fact, they correspond to two sets of rectangles on the respective parameter domains. We compute the centroid of each rectangle as a point on the parameter domain where the B-spline surfaces intersect. In conclusion. we get two piecesofintersectionpointsets 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 ontheparameter domains. In order to generate the desirable intersection curves, we should understand the topology structure of the strip-shaped point clouds 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 correctly.

# 4. Topology understanding of intersecting curves in parameter domains

In this paper, we use the affine arithmetic-based subdivision method proposed in [ Lin et al. , 2013 ] to obtain the intersection point sets 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 in the parameter domains of the two B-spline surfaces 𝐵 1 ( 𝑢,𝑣 ) and 𝐵 2 ( 𝑠,𝑡 ) , with their parameter ranges being [ 𝑢 𝑠 ,𝑢 𝑒 ] × [ 𝑣 𝑠 ,𝑣 𝑒 ] and [ 𝑠 𝑠 ,𝑠 𝑒 ] × [ 𝑡 𝑠 ,𝑡 𝑒 ] . In this section, we analyze the topological
