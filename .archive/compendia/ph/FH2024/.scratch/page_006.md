[Page 6]

# 2.3.1 Time delay embedding

In real world applications, frequently not the entire information about a dynamical system is known. Instead, only certain quantities can be measured, which is described by a so-called observation function, usually a univariate time series \( x = (x_1, \dots, x_n) \). The delay embedding of one observation function \( x \) is defined as

$$
Y = \left \{ y \in \mathbb { R } ^ { d } \colon y = ( x _ { i } , \dots , x _ { i + ( d - 1 ) \tau } ) \right \}
$$

with embedding dimension \( d \) and delay parameter \( \tau \). According to Takens embedding theorem [37], the delay embedding of the observation function has the same topological structure as the state space of the dynamical system under certain, not very restrictive, assumptions.

# 2.3.2 Zigzag persistent homology for time series

In [38], the authors examined a different approach by using zigzag persistent homology in order to track the evolution of the topological features over time. Following the procedure in [5], they constructed a zigzag sequence of simplicial complexes by including the simplicial complexes of two neighboring point clouds \( X_i \) and \( X_{i+1} \) \( (i = 1, \dots, n-1) \) into a bigger space \( X_i \cup X_{i+1} \) as follows:

![image 2](<FH2024/imageFile2.png>)




···







-

















-



In this sequence, generators at time steps i and i + 1 that generate the same feature in X i ∪ X i +1 are said to belong to the same feature, but at different time steps. Hence, zigzag persistent homology tracks the persistence with respect to time instead of spatial persistence. Notice that for multi-variate time series, one possible way to construct a zigzag sequence is to partition the time series into windows and build a simplicial complex on that data. However, since the vertex sets of neighboring windows are disjoint, the union is also disjoint. To avoid this, we build the intermediate step by taking the union of the point clouds and building a Vietoris-Rips complex on the union point cloud.

Similarly to one-parameter modules, zigzag modules decompose into a direct sum of interval modules and thus, the barcode (resp. persistence diagram) of a zigzag module is a complete invariant. To construct the simplicial complexes \( X_i \), the authors of [38] used Vietoris Rips complexes at specified radii \( \varepsilon_i \). However, it is a priori not clear how to choose the radii. Our approach is to combine zigzag filtrations with filtrations in a spatial direction and therefore, to regard diagrams of the following form, where the superscript \( \varepsilon_i \) denotes the scale of the Vietoris-Rips complex.
