[Page 9]

Table 1 Runtime for constructing the Mapper graph , where “Initial” is the time for constructing the initial Mapper graph, “Refinement” is the time for graph subdivision, and “Total” is the

overall runtime.



| 0.5200 |
|---|




Table 2

The intersection of two B-spline surfaces is divided into segments within the ( 𝑢,𝑣 ) parameter domain. OCCT refers to the intersection algorithm in the Open Cascade Technology. Different segments are distinguished by different colors.

![In this image, we can see a table with some text and numbers.](<GLL2026/imageFile7.png>)


Table 1 reports the runtime statistics for constructing the initial Mapper graph, performing Mapper graph subdivision, and the total runtime. It can be observed that the graph subdivision stage dominates the overall computational cost. Moreover, the refinement time is closely related to the number of connected components in the intersection point set, as well as the number of singular points. Therefore, Examples 2, 8, and 9 exhibit the largest runtimes among all test examples. Multiple connected branches . We first consider the

case where two intersecting surfaces contain multiple connected components. In Example 1 and Example 2 in Table

3 , the intersection of these two surfaces contain multiple connected components. The results in Table 3 show that our algorithm can correctly identify and distinguish all connected branches of the intersection, and obtain a one-to-one correspondence between the parametric domains of the two surfaces. Singular points . We also investigated the performance

of the algorithm when dealing with intersections containing singular points. In the example 3 in Table 3 , the intersection of two B-spline surfaces contains two singular points. Our algorithm can detect the location of the two singular points and split the intersection point sets into some simple subsets at the singular points and keep the topology consistent across different parameter domains. Different topology in different parameter domains .

Even when the topology of the intersection of different parameter domains is different, our method can still obtain the correct correspondence. Example 4 in Table 3 and Example 5 in Table 4 show the cases that two periodic B-spline surfaces intersecting. Due to periodicity, we need to partition the intersection set into different subsets at the boundary points in the parameter domain. Since the two surfaces 𝐵 1 ( 𝑢, 𝑣 ) and 𝐵 2 ( 𝑠, 𝑡 ) are unfolded at different positions in the parameter domain, the topology of the intersection point sets 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 of the parameter domain is different. However, we can still obtain the correct correspondence. Intersection with isolated points . Our method can also

precisely identify isolated intersection points. Example 6 in Table 4 demonstrates a case where two surfaces intersect at isolated tangent points. By locating nodes with degree 0 in the Mapper graph, our method can distinguish isolated tangent contact points and establish the correct correspondence between the parameter domains of the two surfaces. Combinations of multiple situations . Even when inter-

sections involve combinations of the aforementioned complex cases, our method achieves reliable topological understanding. In Example 7 in Table 4 , the intersection of the two surfaces contains both singular points and periodic boundary points. In Example 8 in Table 4 , the intersection of the two surfaces contains singular points and periodic boundary points, and multiple connected components. In Example 9 in Table 4 , the intersection of the two surfaces contains multiple singular points and periodic boundary points. Our method can effectively identifies their topological structures, correctly partition intersection point sets, and establishes accurate correspondences between the parameter domains of two intersecting surfaces. This validates the effectiveness of our method in handling complex topology.

# 5.3. Comparison

To evaluate the effectiveness of the proposed method, we compare it with the intersection-processing module in the open-source software Open CASCADE Technology (OCCT). The version of OCCT employed in this work is 7.8.1. Table 2 summarizes the results for examples containing multiple singular points, with the ordering consistent with Tables 4 and 3 .
