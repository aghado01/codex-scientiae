[Page 7]




![The image is a mathematical diagram consisting of a series of equations. The diagram is structured with a series of arrows pointing from one variable to another, indicating the direction of the flow of information or data. The arrows are labeled with the variables x and y, and they are connected to each other. The diagram is labeled with the variables x and y, and the arrows are labeled with the variables x and y. The diagram is divided into two main sections: 1. **Left Section**: - The left section contains the variables x and y. - The arrows from x to y are labeled with the variables x and y. - The arrows from y to x are labeled with the variables y and x. - The arrows from x to y are labeled with the variables x and y. - The arrows from y to x are labeled with the variables y and x. - The arrows from x to y are labeled with the variables x and y. - The](<FH2024/imageFile3.png>)









Since the above diagram is not a multiparameter filtration, none of the common invariants can be applied to it. We call the corresponding persistence module an extended zigzag module . In this work, we propose an algorithm to calculate persistence landscapes for these modules by using the generalization of the rank invariant introduced in [17].

# 2.4 Generalized Rank

For zigzag modules, we require a generalization of the rank invariant that is equivalent to the barcode, because we seek to obtain information about the persistence of features in time. In [32], the author defined the rank invariant for multiparameter persistence modules as the map that sends a tuple of points \( ( a,b ) \), where \( a < b \), to the rank of the map \( M ( a < b ) \). However, for zigzag modules only adjacent indices are comparable (i.e. \( a < b \) or \( b < a \)). The following example shows that the rank invariant in [32] does not contain all the information about the interval decomposition of the zigzag module.

Example 2.8 Consider the two zigzag modules

$$
M \ \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \ \xrightarrow { ( 1 \, 0 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { C } \ \xrightarrow { ( 0 \, 1 ) } \, \mathbb { F } \ \xrightarrow { 0 } \, 0 ,
$$

$$
N \, \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { ( 1 \, 1 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { 0 } \, 0 ,
$$

indexed by \( \{ 1 , 2 , 3 , 4 , 5 \} \). They both have the same rank invariant, but since \( M = [2 , 3] \oplus [3 , 4] \) and \( N = [2 , 4] \oplus [3 , 3] \), they are not isomorphic.

In [17], the authors proposed a generalized rank invariant for modules indexed over arbitrary posets. The rank invariant is defined for so-called intervals, which are defined as follows.

Definition 2.9 Let \( P \) be a poset. We call a nonempty subset \( I \) of \( P \) an interval of \( P \) if for all \( p,q \in I \) and \( p \le r \le q \) it holds that \( r \in I \) and \( I \) is connected, i.e. for all \( p,q \in I \) there is a sequence \( p = p_1 , \dots , p_l = q \) of elements in \( I \) such that \( p_i \) and \( p_{i+1} \) are comparable (\( p_i \le p_{i+1} \) or \( p_i \ge p_{i+1} \) for all \( 1 \le i \le l - 1 \)).

For a persistence module \( M : P \to \text{Vec} \) we denote by \( M|_I \) its restriction to a subset \( I \) of \( P \). Furthermore, we denote by \( \lim_{\longleftarrow} M|_I = ( L, ( \pi_p : L \to M_p )_{p \in I} ) \) the limit of \( M|_I \) and by \( \lim_{\longrightarrow} M|_I = ( C, ( i_p : M_p \to C )_{p \in I} ) \) the colimit of \( M|_I \). See Appendix A for the definitions of limits and colimits.
