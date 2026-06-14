[Page 2]

Tracing methods generate intersections by stepping from initial points on a curve branch, following the local differential geometry of the curve [ Bajaj, Hoffmann, Lynch, and Hopcroft , 1988 ]. These methods require careful selection of valid initial points to ensure no branches are missed. Additionally, determining the tracking direction at singular points of the intersecting curves is challenging. Lattice methods decompose the Surface/Surface inter-

section problem by computing the intersection of multiple isoparametric lines from one surface to another [ Rossignac and Requicha , 1987 ]. However, the choice of mesh resolution is crucial, as inappropriate resolutions may result in the omission of important characteristic points. Subdivision methods are recursive approaches that sub-

divide surfaces into smaller facets and perform intersection tests between the facets of the two surfaces [ Lasser , 1986 ], [ De Figueiredo , 1996 ], [ Lin et al. , 2013 ]. These operations are repeated until the computed intersection meets accuracy requirements. While subdivision methods can achieve high accuracy in intersection curves, they struggle to determine the topology of intersections near singular points. Widely used methods in practice are hybrids of the

above approaches. One example is the hybrid of subdivision and tracing methods, which first identifies all intersecting branches through subdivision and then tracks each intersecting curve [ Barnhill and Kersey , 1990 ], [ Sinha, Klassen, and Wang , 1985 ]. Another hybrid combines algebraic and tracing methods: algebraic methods are used to identify characteristic points, and then tracking methods are applied to obtain intersecting curves [ Krishnan and Manocha , 1997 ]. For more details on Surface/Surface intersection, please

For more details on Surface/Surface intersection, please refer to [Hoschek and Lasser, 1993], [Patrikalakis, 2002].

methods to compute these characteristic points of intersection, thereby decomposing the intersection curve into several monotonic segments at the characteristic points to determine the topology of the intersection [ Grandine and Klein IV , 1997 ][ Hass et al. , 2007 ]. However, few studies focus on the overall topological structure of the intersection, such as the number of connected branches and cycles.

# 2.2. Mapper algorithm and its applications

The Mapper algorithm was first proposed by Singh et al. in 2007 [ Singh et al. , 2007 ]. It aims to perform data visualization and cluster analysis based on topology, to extract the global topological features of data. The early Mapper algorithm had limitations in practical use, such as relying on parameter selections like coverage and overlap ratio. To address these issues, some studies have proposed adaptive coverage selection strategies based on statistical analysis [ Carriere, Michel, and Oudot , 2018 ], [ Belchí, Brodzki, Burfitt, and Niranjan , 2020 ]. In addition, scholars have developed Mapper variants based on different clustering algorithmsfor example, applying classic ones like Fuzzy Clustering [ Bui, Vo, Do, Hung, and Snasel , 2020 ] and GMeans [ Alvarado, Belton, Fischer, Lee, Palande, Percival, and Purvine , 2025 ] to Mapper’s clustering step.

Currently,theMapperalgorithmhasbeenwidelyapplied in many fields, including computational biology [ Jeitziner, Carriere, Rougemont, Oudot, Hess, and Brisken , 2019 ], medicine [ Li, Cheng, Glicksberg, Gottesman, Tamler, Chen, Bottinger, and Dudley , 2015 ], manufacturing systems [ Guo and Banerjee , 2017 ], and machine learning [ Carrière and Michel , 2022 ]. However, its application in the CAD field remains scarce.

# 3. Preliminaries

In this section, we introduce key concepts used in this paper.

# 3.1. Mapper

Mapper is a tool in the field of topological data analysis proposed by Gurjeet Singh et al in 2007 [ Singh et al. , 2007 ]. The Mapper method extracts the topological structure

of a high-dimensional dataset through partial clustering, represented as a simplicial complex. In general, we usually construct a two-dimensional simplex complex form, that is, an undirected and unweighted graph 𝐺 = ⟨ 𝑉 , 𝐸 ⟩ , where 𝑉 stands for nodes and 𝐸 stands for edges. Unless otherwise stated, this paper defaults to this form of Mapper’s output, which we call a Mapper graph . The Mapper algorithm is inspired by the Reeb graph. It can be proven that in the limit, the Mapper graph constructed using Mapper is equivalent to the Reeb graph [ Munch and Wang , 2015 ]. Given a dataset with known pairwise distances and a

𝑋 filter function 𝑓 ∶ 𝑋 → ℝ , the Mapper algorithm on 𝑋 computed with the filter function 𝑓 contains the following steps:

1. Cover construction . Cover the range of values 𝑌 = 𝑓 ( 𝑋 ) with a set of overlapping intervals { 𝐼 𝑠 } 𝑆 1 . 2. Preimage clustering . For each interval , the preim-

Preimage clustering . For each interval 𝐼 𝑠 , the preimage 𝑋𝑠 = 𝑓 -1 ( 𝐼 𝑠 ) is clustered using a chosen clustering algorithm, resulting in clusters { 𝑋𝑠,𝑘 } .

Graph Construction ter 𝑋 𝑠,𝑘 , and edges are added between nodes if their corresponding clusters intersect (i. e. 𝑋 𝑠,𝑘 ⋂ 𝑋 𝑡,𝑙 ≠ ∅ )

Fig. 1 illustrates the Mapper algorithm applied to a noisy circle point set 𝑋 . The filter function is 𝑓 ( 𝑥 ) = 𝑥 1 , where 𝑥 = ( 𝑥 1 ,𝑥 2 ) is a point in 𝑋 . We cover the range of 𝑓 with five equal-length intervals, with a 20% overlap of neighboring intervals. Then for each interval we find its clustering using DBSCAN (Density-Based Spatial Clustering of Applications with Noise) algorithm[ Ester, Kriegel, Sander, Xu, et al. , 1996 ]. Finally, we treat each cluster as a node in the Mapper graph and add edges between nodes if their corresponding clusters intersect. The choice of filter function, cover parameters, and clus-

tering algorithm all influence the resulting Mapper graph. These parameters must be carefully selected to ensure that the topological features extracted by the algorithm accurately reflect the structure of the point set.
