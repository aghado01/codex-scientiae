[Page 11]

example 5

Example 6

Example 7

Example 8

Example 9

Surfaces


,𝑢,𝑣



,𝑠,𝑡


Mapper

graph of


,𝑢,𝑣




Result of


,𝑢,𝑣


![In this image there is a table with some text on it.](<GLL2026/imageFile9.png>)


Result of


,𝑠,𝑡


# 5.4. Discussion and limitations

Despite the promising results, the proposed algorithm has several limitations. One of the main limitations is related to the handling of clustered singular points. When multiple singular points are in close proximity, the current approach of constructing interval coverages for the filter function in the Mapper graph may assign these points to the same interval. As a result, they are clustered together as a single node in the Mapper graph, causing the algorithm to incorrectly identify them as a single singular point.

# 6. Conclusion

In this paper, we present a new algorithm for understanding the topology of intersections between B-spline surfaces with Mapper. The algorithm first constructs a Mapper graph using a Two-step Mapper algorithm. Next, the algorithm identifies characteristic nodes in the Mapper graph. Finally, by partitioning the Mapper graph at these characteristic nodes, we divide the intersections into simpler segments, enabling a more desirable understanding of the topological structure of the intersections. The significance of our method lies in its ability to

determine the overall topology of the intersection, which is
