# 2 Preliminaries

# 2.1 Persistent homology

One of the major tasks in TDA is to determine the structure of point cloud data that was sampled on a space. In order to achieve that, a filtration of a simplicial complex \( K_0 \subset K_1 \subset \dots \subset K_n \) (most frequently the Vietoris-Rips complex [10]) is constructed from point cloud data and the \( p \)-th simplicial homology functor \( H_p(-) \) with coefficients in a field (usually \( \mathbb{F}_2 \)) is applied to the filtration. This results in a sequence of vector spaces \( M_0, \dots, M_n \) and associated linear maps \( M(a \leq b) : M_a \to M_b \) for all \( 0 \leq a \leq b \leq n \), the so-called (oneparameter) persistence module. The maps \( M(a \leq b) \) are also referred to as structure maps. Alternatively, persistence modules can be defined as functors from a partially ordered set (poset) to the category of vector spaces over a fixed field. In the case where the poset is \( \mathbb{R} \) or \( \mathbb{Z} \), or a subset thereof, we call it a oneparameter persistence module. When the indexing poset is \( \mathbb{R}^n \) we call it a multiparameter persistence module. When the target category is the category of finite dimensional vector spaces, the persistence module is called pointwise finite dimensional. By \( \mathbf{Vec} \) we mean the category of all vector spaces over a fixed field and by \( \mathbf{vec} \) the full subcategory of finite dimensional vector spaces. According to the structure theorem [42], oneparameter persistence modules can be uniquely decomposed into a direct sum of interval modules, which are defined as follows.

Definition 2.1 Let \( b \leq d \). An interval module \( I_{[b,d]} \) with birth time \( b \) and death time \( d \) is defined as

$$
I _ { i } = \begin{cases} \mathbb { F } & \text {for } b \leq i \leq d , \\ 0 & \text {otherwise} , \end{cases}
$$

where all the maps between \( I_i \) and \( I_{i+1} \) are identity maps if both \( I_i \) and \( I_{i+1} \) are \( \mathbb{F} \) and zero maps otherwise.

The multiset of intervals that appear in the direct sum decomposition is a complete discrete invariant of the persistence module [42], and is called the barcode or persistence diagram . Contrarily, in the case of multiparameter persistence modules no complete discrete invariant exists [6]. As a result, plenty of research has been going on in defining other invariants for multiparameter persistent homology that have some discriminative properties or are suitable to visualize relevant homological features, like the fibered barcode [21], the rank invariant [6], persistence landscapes [40], and many more. The rank invariant sends a pair of indices \( a \leq b \) to the rank of the linear map \( M(a \leq b) \). For oneparameter persistence modules, the rank invariant and the barcode determine each other and hence, the rank invariant is also a complete discrete invariant.

# 2.2 Persistence landscapes
