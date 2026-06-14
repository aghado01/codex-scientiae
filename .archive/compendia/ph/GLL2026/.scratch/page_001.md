[Page 1]

# Topology Understanding of B-Spline Surface/Surface Intersection with Mapper

Chenming Gao a , Hongwei Lin b , ∗ and Gengchen Li c

School of Mathematical Science, Zhejiang University, Hangzhou, 310027, China State Key Laboratory of CAD & CG, Zhejiang University, Hangzhou, 310058, China

# ARTICLE INFO

Keywords : Surface/surface intersection Topology structure Topology understanding Mapper Topological data analysis

# ABSTRACT

In the realm of computer-aided design (CAD) software, the intersection of B-spline surfaces stands as a fundamental operation. Despite the extensive history of surface intersection algorithms, the challenge of handling complex intersection topologies persists. While subdivision algorithms have demonstrated strong robustness in computing surface/surface intersection and are capable of addressing singular cases, determining the topology of the intersection obtained through these methods is a key factor for calculating correct intersection, and remains a difficult issue. To address this challenge, we propose a Mapper-based method for determining the topology of the intersection between two B-spline surfaces. Our algorithm is designed to efficiently handle various common and complex intersection topologies. Experimental results verify the robustness and topological correctness of this method.

# 1. Introduction

B-spline surface intersection is one of the fundamental operations in computer-aided design (CAD) software. Ensuring that surface intersection operations are robust, efficient, and topologically correct is of paramount importance. Despite the extensive history of surface intersection algorithms, complex intersection topology remains a persistent challenge. Subdivision method is a robust method for calculat-

ing surface/surface intersections by recursively subdividing the parameter domains fo the two surfaces, leading to strip-shaped point cloud in each domain [ Lasser , 1986 ], [ De Figueiredo , 1996 ], [ Lin, Qin, Liao, and Xiong , 2013 ]. The key factor for computing the correct intersections is to understand the topological structure of the strips of point cloud correctly, i.e., determining the connected components, the openness or closeness of each connected component, and the bifurcation points. Because the surface/surface intersection can be very complicated in some cases, the topology structure of the strips of point cloud is also complicated, and hard to understand. To address this challenge, we propose a new method

based on Mapper [ Singh, Mémoli, Carlsson, et al. , 2007 ] for understanding the topology of intersection curves between two B-spline surfaces. Mapper is a significant tool in topological data analysis that extracts topological features from high-dimensional data at various scales and projects them into 2D or 3D space for visualization. First, we employ a two-step Mapper algorithm to construct the Mapper graph of the intersection points to understand its topological structure. Next, we identify two types of characteristic vertices within the Mapper graph: singular vertices and boundary vertices. Finally, by removing these characteristic vertices from the Mapper graph, we can partition the intersection region into several simple open or closed curves. In summary, the main contributions of this study are as follows:

∗ E-mail address: hwlin@zju.edu.cn (H. Lin).

- Topology structure of Surface/Surface intersection is understood by Mapper at the first time, showing its robustness and efficiency;

- A two-step mapper algorithm is developed to extract the structure of Surface/Surface intersection point sets.

The rest of the paper is organized as follows. In Section 2, we review related work on surface intersection algorithms and Mapper algorithm. In Section 3, preliminaries on the Mapper algorithm and surface intersection are introduced. In Section 4, we propose an algorithm for understanding the topology of the intersection of two B-spline surfaces. In Section 5, we verify the effectiveness of the algorithm experimentally. Finally, we conclude this study in Section 6.

# 2. Related work

# 2.1. Surface/Surface intersection and determination of intersection topology

In this section, we briefly review related work on Surface/Surface intersection. Surface intersection is a critical issue in geometric design and has been the subject of extensive research. In general, intersection methods can be categorized as follows. Algebraic methods typically involve converting one sur-

face into its implicit equation. The parametric form of the other surface is then substituted into this implicit equation to compute the Surface/Surface intersection using elimination theory [ Sarraga , 1983 ], [ Manocha and Canny , 1991 ], [ Manocha and Krishnan , 1997 ]. These methods determine the topology of the intersection by identifying "characteristic points" such as border points, turning points, and singular points [ Farouki , 1986 ], [ Hass, Farouki, Han, Song, and Sederberg , 2007 ]. However, determining how these points are connected remains a challenge, as incorrect connections can lead to topological errors.
