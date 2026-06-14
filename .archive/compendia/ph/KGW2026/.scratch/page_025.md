[Page 25]

$$
\sum _ { j = 1 } ^ { n } y _ { j } v _ { j } \in \ker ( \partial _ { 1 } ) .
$$

For the final assertions, note that if n is odd, then

$$
u _ { 1 } - u _ { 2 } = n - 2 u _ { 2 }
$$

is also odd. Hence N 2 must be odd, which is equivalent to N ≡ 2 (mod 4). Moreover, since | u 1 − u 2 | ≤ n , the congruence N

$$
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N }
$$

can hold only if n ≥ N 2 .

The linear combinations arising from undirected cycles in G u that satisfy the conditions of the previous proposition are called admissible cycles. However, admissible cycles do not exhaust all elements of the kernel. In particular, certain linear combinations of non-admissible cycles may also lie in ker( ∂ 1 ). For a given two non-admissible cycle define the merge of the cycles as the union of the vertex and edge set.

Proposition 3.3. Let I and J be two non-admissible cycles in G u with nonempty intersection on vertex set. Then there exists a nonzero weighted element supported on the merge of I and J that lies in ker( ∂ 1 ) .

Proof. Let I and J be two non-admissible cycles induced by vertex sequences i 1 ,...,i n and j 1 ,...,j m , respectively, and suppose they share a nontrivial path i 1 = j 1 ,...,i k = j k . Define the paths

$$
P _ { 1 } = ( i _ { 1 } , \dots , i _ { k } ) , \ \ P _ { 2 } = ( i _ { k } , \dots , i _ { n } , i _ { 1 } ) , \ \ P _ { 3 } = ( j _ { k } , \dots , j _ { m } , j _ { 1 } ) .
$$

Let A i be the adjacency matrix for P i where i = 1 , 2 , 3.

$$
[ A _ { i } ] _ { j , j } = ( x _ { i } ) _ { j } \ \ [ A _ { i } ] _ { j + 1 , j } = ( x _ { i } ) _ { j } ^ { * } \ \ j = 1 , \cdots , k - 1
$$

where ( x i ) j ∈ { 1 ,ξ } and ( x i ) j ( x i ) ∗ j = 1 for ξ is the N th root of unity. T a

Let y i = ( y i, 1 , ··· ,y i,a i ) ∈ C i where a 1 = k − 1, a 2 = n − k + 1 and a 3 = m − k + 1. Let A be the adjacency matrix of merge of I and J . Ay T = 0 will yield the following equations where y is stack of y i

$$
y _ { i , j - 1 } ( x _ { i } ) _ { j - 1 } ^ { * } + y _ { i , j } ( x _ { i } ) _ { j } & = 0 \quad i = 1 , 2 , 3 \quad j = 2 , \cdots , a _ { i } \quad ( 1 ) \\ y _ { 1 , 1 } ( x _ { 1 } ) _ { 1 } + y _ { 2 , a _ { 2 } } ( x _ { 2 } ) _ { a _ { 2 } } ^ { * } + y _ { 3 , a _ { 3 } } ( x _ { 3 } ) _ { a _ { 3 } } ^ { * } & = 0 \quad ( 2 ) \\ y _ { 1 , a _ { 1 } } ( x _ { 1 } ) _ { a _ { 1 } } ^ { * } + y _ { 2 , 1 } ( x _ { 2 } ) _ { 1 } + y _ { 3 , 1 } ( x _ { 3 } ) _ { 1 } & = 0 \quad ( 3 ) \\ \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \
$$

The recursive relation (1) implies

$$
y _ { t , a _ { t } } = ( - 1 ) ^ { a _ { t } - 1 } \prod _ { l = 1 } ^ { a _ { t } - 1 } \frac { ( x _ { t } ) _ { l } ^ { * } } { ( x _ { t } ) _ { l + 1 } } y _ { t , 1 } \ \ t = 1 , 2 , 3
$$
