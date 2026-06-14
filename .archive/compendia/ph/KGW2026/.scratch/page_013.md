[Page 13]

(a) Double edge

![The image depicts a diagram with three main components: a double edge, a triangle, and a square. Each component is represented by a different color. The double edge is represented by a green color, the triangle is represented by a blue color, and the square is represented by a red color. The double edge is a line segment that connects two points on a plane. It is a fundamental concept in geometry and is used to define the concept of a line segment. The triangle is a triangle formed by two sides and two angles. It is a fundamental concept in geometry and is used to define the concept of a triangle. The square is a square formed by two squares. It is a fundamental concept in geometry and is used to define the concept of a square. The diagram is labeled as follows: - The double edge is represented by a green color. - The triangle is represented by a blue color. - The square is represented by a red color. The](<KGW2026/imageFile6.png>)

(b) Triangle

Figure 5: The generators of \( \Omega _ { N } ^ { 2 } \)

(c) Square

It was proven in [7] that any element of \( \Omega _ { 2 } ^ { 2 } \) of path complex induced by finite digraph \( G \) can be represented as a linear combination of double edge, triangle and square. There were no classification for higher chain structure in [7]. We will show that the structure of \( \Omega _ { N } ^ { 2 } \) is same with \( \Omega _ { 2 } ^ { 2 } \).

Theorem 3.2. Elements of \( \Omega _ { N } ^ { 2 } \) of path complex \( P ( G ) \) induced by finite digraph \( G \) can be represented as a linear combination of double edge, triangle and square for \( N \geq 2 \).

Proof. Let \( v \in \Omega _ { N } ^ { 2 } \), then it is a \( \mathbb{C} \)-linear combination of elementary paths of the form \( e _ { i , j , k } \). If \( i = k \), we have double edge. If \( i \neq k \) and \( e _ { i , k } \in \mathcal{A} _ { 1 } ( P ( G ) ) \), then it will form a triangle.


Now assume that \( e _ { i , k } \notin \mathcal{A} _ { 1 } ( P ( G ) ) \). We have \( \partial ( e _ { i , j , k } ) = e _ { i , j } + \xi e _ { i , k } + \xi ^ { 2 } e _ { j , k } \) where \( \xi \) is \( N \)-th root of unity.

Lets investigate which scenarios will result in the appearance of \( e _ { i , k } \) in the image of the boundary map. \( e _ { i , k , m } , e _ { i , m , k } , e _ { m , i , k } \) for some \( m \) are the only three options that \( e _ { i , k } \) appears in the image. Since \( e _ { i , k } \notin \mathcal{A} _ { 1 } ( P ( G ) ) \), the only possibility is \( e _ { i , m , k } \)

We can be cancel \( \xi e _ { i , k } \) in the image by two methods. First one is by negation version \( - \xi e _ { i , k } \). This means \( - e _ { i , m , k } \) must appear in \( v \) for some \( m \). This is the same case explained in [7, Proposition 2.9] that results in a square.

The other method unique to our definition of the Mayer boundary map is that the property \( 1 + \xi + \cdots + \xi ^ { N - 1 } = 0 \) may appear as a coefficient. Let \( v = e _ { i , j , k } + \sum _ { m = 1 } ^ { N - 1 } \xi ^ { m } e _ { i , j _ { m } , k } \) where \( j _ { m } \neq j \) for at least one \( m \in \{ 1 , \dots , N - 1 \} \) be called mayer type square form.


$$
\partial ( e _ { i , j , k } + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } e _ { i , j , m , k } ) = \partial ( e _ { i , j , k } ) + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } \partial ( e _ { i , j , m , k } ) = \sum _ { j = 0 } ^ { N - 1 } \xi ^ { j } e _ { i , k } + w = w \quad , w \in \mathcal { A } _ { 1 } ( P ( G ) )
$$

There is no need to check \( \partial _ { q } \), where \( 1 \leq q \leq N - 1 \) since the image is in either \( \mathcal{A} _ { 0 } ( P ( G ) ) \) or \( 0 \). Observe that \( e _ { i , j , k } - e _ { i , j _ { m } , k } \) is also a square element for each \( j _ { m } \neq j \) and \( \sum _ { j _ { n } = j } \xi ^ { n } e _ { i , j , k } \) is missing \( \xi ^ { m } \) coefficients where \( j _ { m } \neq k \), thus by using \( \sum _ { i = 0 } ^ { N - 1 } \xi ^ { i } = 0 \) the sum can be rewritten as \( \sum _ { j _ { m } \neq j } - \xi ^ { m } e _ { i , j , k } \). The element \( v \) can be represented as follows




$$
v = \sum _ { j _ { n } = j } \xi ^ { n } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } e _ { i , j , k } + \sum _ { j _ { m } \neq j } \xi ^ { m } e _ { i , j _ { m } , k } = \sum _ { j _ { m } \neq j } - \xi ^ { m } ( e _ { i , j , k } - e _ { i , j _ { m } , k } )
$$





\( e _ { i , j , k } + \sum _ { j = 1 } ^ { N - 1 } \xi ^ { j } e _ { i , j _ { m } , k } \) is a linear combination of the squares \( e _ { i , j , k } - e _ { i , j _ { m } , k } \). The new cancellation method will not produce a independent generator.

# 3.1.2 \( \partial \)-invariant 3-path \( \Omega _ { N } ^ { 3 } \)

Grigoryan constructed a basis for \( \Omega _ { 2 } ^ { 3 } \) in [6] under certain conditions such as free of double edge and multisquares. Later Li-Shen removed these assumptions and provided a general construction of a
