[Page 1]

# Zigzag Persistent Homology and Real-valued Functions ∗

Gunnar Carlsson Department of Mathematics, Stanford University, California gunnar@math.stanford.edu

Vin de Silva Department of Mathematics, Pomona College, Claremont, California vin.desilva@pomona.edu Dmitriy Morozov Departments of Computer Science and Mathematics, Stanford University, California dmitriy@mrzv.org

# ABSTRACT

We study the problem of computing zigzag persistence of a sequence of homology groups and study a particular sequence derived from the levelsets of a real-valued function on a topological space. The result is a local, symmetric interval descriptor of the function. Our structural results establish a connection between the zigzag pairs in this sequence and extended persistence, and in the process resolve an open question associated with the latter. Our algorithmic results not only provide a way to compute zigzag persistence for any sequence of homology groups, but combined with our structural results give a novel algorithm for computing extended persistence. This algorithm is easily parallelizable and uses (asymptotically) less memory.

# Categories and Subject Descriptors

F.2.2 [ Analysis of Algorithms and Problem Complexity ]: Nonnumerical Algorithms and Problems; G.2.1 [ Discrete Mathematics ]: CombinatoricsCounting problems

# General Terms

algorithms, theory

# Keywords

Zigzag persistent homology, Mayer–Vietoris pyramid, levelset zigzag, extended persistence, algorithms.

# 1. INTRODUCTION

In this paper we develop the theory of zigzag persistent homology and present an effective algorithm for calculating it. We build on technical foundations presented in [3]; the original inspiration is the theory of persistence [11], which is the simplest special case. In this paper we focus on two major developments: an application of zigzag persistence theory to real-valued functions on a topological space; and an incremental, parallelizable, space-efficient algorithm analogous to the well-known algorithm for computing persistent homology [11, 16].

The idea that geometric techniques should be useful in understanding high dimensional data is by now well accepted. Multidimensional scaling [1, 15] can be used to obtain low dimensional embeddings of data sets which do not distort the metric excessively. Clustering methods are the statistical version of the topological concept of extracting the connected components of a topological space.

The translation of topological constructs into the context of point clouds typically requires a choice of scale. For example, single linkage clustering [13] requires the choice of a threshold parameter to give well defined clusters. In certain situations there exist various clever methods for selecting an ‘optimal’ scale parameter. On the other hand, it is sometimes possible to avoid such a choice by working at all scales simultaneously. The dendrograms which are produced for hierarchical clustering are a clear example of this idea.

Persistent homology [11, 16] is, among other things, a scale-invariant methodology for studying the higher dimensional topological invariants of a point cloud. As presented in [16], the key theoretical ingredient is the algebraic classification of persistence vector spaces . These are diagrams of the form

$$
$$
V _ { 0 } \rightarrow V _ { 1 } \rightarrow V _ { 2 } \rightarrow V _ { 3 } \rightarrow \cdots
$$
$$

where each V i is a vector space over a field k , and where each arrow represents a linear transformation between the corresponding vector spaces. Each space V i can be thought of, for instance, as the topology of a point cloud measured at scale i . The algebraic classification describes the overall diagram of spaces in terms of an interval barcode , or persistence diagram ; this captures information at all scales simultaneously.

We claim that diagrams of other shapes should also be useful in understanding point cloud data [2, 3]. We will deal with a specific class of diagrams zigzags whose shape is still linear, but in which the arrows can point in different directions. It is known that the classification of zigzag diagrams of vector spaces is essentially identical to the classification of persistence spaces; each diagram decomposes as a direct sum of irreducible terms labelled by intervals. Thus, many of the conceptual and practical advantages of persistent homology (over ordinary homology) become available to us in much greater generality.
