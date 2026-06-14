# Manifest: Page 013

## REPAIR_MATH
- RAW: ```
Figure 5: The generators of Ω N 2
```
  FIX: ```
Figure 5: The generators of \( \Omega _ { N } ^ { 2 } \)
```
- RAW: ```
It was proven in [7] that any element of Ω 2 2 of path complex induced by finite digraph G can be represented as a linear combination of double edge, triangle and square. There were no classification for higher chain structure in [7]. We will show that the structure of Ω N 2 is same with Ω 2 2 .
```
  FIX: ```
It was proven in [7] that any element of \( \Omega _ { 2 } ^ { 2 } \) of path complex induced by finite digraph \( G \) can be represented as a linear combination of double edge, triangle and square. There were no classification for higher chain structure in [7]. We will show that the structure of \( \Omega _ { N } ^ { 2 } \) is same with \( \Omega _ { 2 } ^ { 2 } \).
```
- RAW: ```
Theorem 3.2. Elements of Ω N 2 of path complex P ( G ) induced by finite digraph G can be represented as a linear combination of double edge, triangle and square for N ≥ 2 .
```
  FIX: ```
Theorem 3.2. Elements of \( \Omega _ { N } ^ { 2 } \) of path complex \( P ( G ) \) induced by finite digraph \( G \) can be represented as a linear combination of double edge, triangle and square for \( N \geq 2 \).
```
- RAW: ```
Proof. Let v ∈ Ω N 2 , then it is a C -linear combination of elementary paths of the form e i,j,k . If i = k , we have double edge. If i ̸ = k and e i,k ∈ A 1 ( P ( G )), then it will form a triangle. 2
```
  FIX: ```
Proof. Let \( v \in \Omega _ { N } ^ { 2 } \), then it is a \( \mathbb{C} \)-linear combination of elementary paths of the form \( e _ { i , j , k } \). If \( i = k \), we have double edge. If \( i \neq k \) and \( e _ { i , k } \in \mathcal{A} _ { 1 } ( P ( G ) ) \), then it will form a triangle.
```
- RAW: ```
Now assume that e i,k ̸∈ A 1 ( P ( G )). We have ∂ ( e i,j,k ) = e i,j + ξe i,k + ξ e j,k where ξ is N th root of unity.
```
  FIX: ```
Now assume that \( e _ { i , k } \notin \mathcal{A} _ { 1 } ( P ( G ) ) \). We have \( \partial ( e _ { i , j , k } ) = e _ { i , j } + \xi e _ { i , k } + \xi ^ { 2 } e _ { j , k } \) where \( \xi \) is \( N \)-th root of unity.
```
- RAW: ```
Lets investigate which scenarios will result in the appearance of e i,k in the image of the boundary map. e i,k,m ,e i,m,k ,e m,i,k for some m are the only three options that e i,k appears in the image. Since e i,k ̸∈ A 1 ( P ( G )), the only possibility is e i,m,k
```
  FIX: ```
Lets investigate which scenarios will result in the appearance of \( e _ { i , k } \) in the image of the boundary map. \( e _ { i , k , m } , e _ { i , m , k } , e _ { m , i , k } \) for some \( m \) are the only three options that \( e _ { i , k } \) appears in the image. Since \( e _ { i , k } \notin \mathcal{A} _ { 1 } ( P ( G ) ) \), the only possibility is \( e _ { i , m , k } \)
```
- RAW: ```
We can be cancel ξe i,k in the image by two methods. First one is by negation version − ξe i,k . This means − e i,m,k must appear in v for some m . This is the same case explained in [7, Proposition 2.9] that results in a square.
```
  FIX: ```
We can be cancel \( \xi e _ { i , k } \) in the image by two methods. First one is by negation version \( - \xi e _ { i , k } \). This means \( - e _ { i , m , k } \) must appear in \( v \) for some \( m \). This is the same case explained in [7, Proposition 2.9] that results in a square.
```
- RAW: ```
The other method unique to our definition of the Mayer boundary map is that the property 1 + ξ + ··· + ξ N − 1 = 0 may appear as a coefficient. Let v = e i,j,k + N − 1 m =1 ξ m e i,j m ,k where j m ̸ = j for at least one m ∈ { 1 , ··· ,N − 1 } be called mayer type square form.
```
  FIX: ```
The other method unique to our definition of the Mayer boundary map is that the property \( 1 + \xi + \cdots + \xi ^ { N - 1 } = 0 \) may appear as a coefficient. Let \( v = e _ { i , j , k } + \sum _ { m = 1 } ^ { N - 1 } \xi ^ { m } e _ { i , j _ { m } , k } \) where \( j _ { m } \neq j \) for at least one \( m \in \{ 1 , \dots , N - 1 \} \) be called mayer type square form.
```
- RAW: ```
There is no need to check ∂ q , where 1 ≤ q ≤ N − 1 since the image is in either A 0 ( P ( G )) or 0. Observe that e i,j,k − e i,j m ,k is also a square element for each j m ̸ = j and j n = j ξ n e i,j,k is missing ξ m coefficients where j m ̸ = k , thus by using N − 1 i =0 ξ i = 0 the sum can be rewritten as j m ̸ = j − ξ m e i,j,k . The element v can be represented as follows
```
  FIX: ```
There is no need to check \( \partial _ { q } \), where \( 1 \leq q \leq N - 1 \) since the image is in either \( \mathcal{A} _ { 0 } ( P ( G ) ) \) or \( 0 \). Observe that \( e _ { i , j , k } - e _ { i , j _ { m } , k } \) is also a square element for each \( j _ { m } \neq j \) and \( \sum _ { j _ { n } = j } \xi ^ { n } e _ { i , j , k } \) is missing \( \xi ^ { m } \) coefficients where \( j _ { m } \neq k \), thus by using \( \sum _ { i = 0 } ^ { N - 1 } \xi ^ { i } = 0 \) the sum can be rewritten as \( \sum _ { j _ { m } \neq j } - \xi ^ { m } e _ { i , j , k } \). The element \( v \) can be represented as follows
```
- RAW: ```
e i,j,k + N − 1 j =1 ξ j e i,j m ,k is a linear combination of the squares e i,j,k − e i,j m ,k . The new cancellation method will not produce a independent generator.
```
  FIX: ```
\( e _ { i , j , k } + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } e _ { i , j _ { m } , k } \) is a linear combination of the squares \( e _ { i , j , k } - e _ { i , j _ { m } , k } \). The new cancellation method will not produce a independent generator.
```
- RAW: ```
# 3.1.2 ∂ -invariant 3 -path Ω N 3
```
  FIX: ```
# 3.1.2 \( \partial \)-invariant 3-path \( \Omega _ { N } ^ { 3 } \)
```
- RAW: ```
Grigoryan constructed a basis for Ω 2 3 in [6] under certain conditions such as free of double edge and multisquares. Later Li-Shen removed these assumptions and provided a general construction of a
```
  FIX: ```
Grigoryan constructed a basis for \( \Omega _ { 2 } ^ { 3 } \) in [6] under certain conditions such as free of double edge and multisquares. Later Li-Shen removed these assumptions and provided a general construction of a
```
- RAW: ```
\partial ( e _ { i , j , k } + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } e _ { i , j , m , k } ) = \partial ( e _ { i , j , k } ) + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } \partial ( e _ { i , j , m , k } ) = \sum _ { j = 0 } ^ { N - 1 } \xi ^ { j } e _ { i , k } + w = w \quad , w \in \mathcal { A } _ { 1 } ( P ( G ) )
```
  FIX: ```
$$
\partial ( e _ { i , j , k } + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } e _ { i , j , m , k } ) = \partial ( e _ { i , j , k } ) + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } \partial ( e _ { i , j , m , k } ) = \sum _ { j = 0 } ^ { N - 1 } \xi ^ { j } e _ { i , k } + w = w \quad , w \in \mathcal { A } _ { 1 } ( P ( G ) )
$$
```
- RAW: ```
v = \sum _ { j _ { n } = j } \xi ^ { n } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } ( e _ { i , j , k } - e _ { i , j _ { m } , k } )
```
  FIX: ```
$$
v = \sum _ { j _ { n } = j } \xi ^ { n } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } ( e _ { i , j , k } - e _ { i , j _ { m } , k } )
$$
```

