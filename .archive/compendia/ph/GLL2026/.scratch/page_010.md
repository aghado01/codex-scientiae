[Page 10]

Topology understanding of different surface/surface intersections ( 𝜃 ov = 0 . 2) . Corresponding results in different parameter domains are drawn for clarity. The first row shows the intersecting B-spline surfaces; the second and third rows are the intersection point sets 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 ; the fourth row is the Mapper graph of point set 𝑃 1 ,𝑢,𝑣 ; the fifth and sixth rows are the results corresponding to 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 . Different intersection segments are represented in different colors.

Example 1

Example 2

Example 3

Example 4

Surfaces

=


,𝑢,𝑣



,𝑠,𝑡


Mapper

graph of


,𝑢,𝑣


JOC

![In this image there is a table with some objects on it.](<GLL2026/imageFile8.png>)

JOC

Result of


,𝑢,𝑣


Result of


,𝑠,𝑡


In example 3, both methods produce seven segments. In Example 8, OCCT generates only four segments because surface periodicity is not considered, whereas the proposed method produces eight segments. In Example 9, OCCT partitions the intersection into four segments, resulting in tangential discontinuities. In contrast, the proposed method separates the curve at all singular points and produces eight geometrically continuous segments. Overall, compared with OCCT, the proposed method

Overall, compared with OCCT, the proposed method achieves a finer and topologically consistent segmentation of the intersection. Although OCCT can partition the intersection into non-self-intersecting segments, it does not explicitly address topological transitions or geometric continuity at singular points. As a result, the intersection may not be fully separated at singularities, leading to discontinuities in tangent direction. By incorporating global topological information, the proposed method produces a finer partition in which each segment is free of self-intersection and maintains tangential continuity.
