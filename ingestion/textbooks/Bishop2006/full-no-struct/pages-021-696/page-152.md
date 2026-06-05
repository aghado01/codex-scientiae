[Page 152]

Mahalanobis distance ∆ is given by

$$
V _ { D } | \Sigma | ^ { 1 / 2 } \Delta ^ { D }
$$

where V D is the volume of the unit sphere in D dimensions, and the Mahalanobis distance is deﬁned by (2.44).

2.24 ( ) www Prove the identity (2.76) by multiplying both sides by the matrix

$$
\begin{pmatrix} A & B \\ C & D \end{pmatrix}
$$

and making use of the deﬁnition (2.77).

2.25 ( ) In Sections 2.3.1 and 2.3.2, we considered the conditional and marginal distributions for a multivariate Gaussian. More generally, we can consider a partitioning of the components of x into three groups x a , x b , and x c , with a corresponding partitioning of the mean vector µ and of the covariance matrix Σ in the form

$$
\mu & = \begin{pmatrix} \mu _ { a } \\ \mu _ { b } \end{pmatrix} , \quad \Sigma = \begin{pmatrix} \Sigma _ { a a } & \Sigma _ { a b } & \Sigma _ { a c } \\ \Sigma _ { b a } & \Sigma _ { b b } & \Sigma _ { b c } \\ \Sigma _ { c a } & \Sigma _ { c b } & \Sigma _ { c c } \end{pmatrix} .
$$

By making use of the results of Section 2.3, ﬁnd an expression for the conditional distribution p ( x a | x b ) in which x c has been marginalized out.

2.26 ( ) A very useful result from linear algebra is the Woodbury matrix inversion formula given by

$$
( A + B C D ) ^ { - 1 } = A ^ { - 1 } - A ^ { - 1 } B ( C ^ { - 1 } + D A ^ { - 1 } B ) ^ { - 1 } D A ^ { - 1 } . \quad ( 2 . 2 8 9 )
$$

By multiplying both sides by ( A + BCD ) prove the correctness of this result.

2.27 ( ) Let x and z be two independent random vectors, so that p ( x , z ) = p ( x ) p ( z ) . Show that the mean of their sum y = x + z is given by the sum of the means of each of the variable separately. Similarly, show that the covariance matrix of y is given by the sum of the covariance matrices of x and z . Conﬁrm that this result agrees with that of Exercise 1.10.

2.28 ( ) www Consider a joint distribution over the variable

$$
z = \begin{pmatrix} x \\ y \end{pmatrix} & ( 2 . 2 9 0 ) \\
$$

whose mean and covariance are given by (2.108) and (2.105) respectively. By making use of the results (2.92) and (2.93) show that the marginal distribution p ( x ) is given (2.99). Similarly, by making use of the results (2.81) and (2.82) show that the conditional distribution p ( y | x ) is given by (2.100).
