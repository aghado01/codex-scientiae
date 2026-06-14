[Page 22]

Proposition 4.4. Let \( ( X _ k , Y _ k ) _ { k \in \mathbb { Z } } \) be a hidden Markov model as in section 2.1 with \( X _ k \in \{ - 1 , 1 \} ^ r \) (where \( r < \infty \)) and with observations \( Y _ k \in \{ - 1 , 1 \} ^ r \) of the form

$$
Y _ { k } ^ { v } = X _ { k } ^ { v } \xi _ { k } ^ { v } , \quad ( \xi _ { k } ^ { v } ) _ { k \in \mathbb { Z } , v \in \{ 1 , \dots , r \} } \text{ are i.i.d. } \perp X \text{ with } P [ \xi _ { k } ^ { v } = - 1 ] = p .
$$

Then the prediction ﬁlter is stable in the sense that

$$
| P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text{ in } L ^ { 1 }
$$

for every set A , provided that \( p \neq \frac { 1 } { 2 } \).

Proof. We use standard ideas from information theory [12]. Let \( H ( X ) \) denote entropy and \( H ( X | Y ) \) denote conditional entropy of discrete random variables \( X , Y \). Then

$$
\begin{aligned}
& \sum _ { k = 1 } ^ { n } \{ H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \} \\ & = H ( Y _ { 1 } , \dots , Y _ { n } ) - H ( Y _ { 1 } , \dots , Y _ { n } | X _ { 0 } ) \\ & = H ( X _ { 0 } ) - H ( X _ { 0 } | Y _ { 1 } , \dots , Y _ { n } ) \leq H ( X _ { 0 } ) ,
\end{aligned}
$$

where we have used the chain rule for entropy and symmetry of mutual information \( H ( X ) - H ( X | Y ) = H ( Y ) - H ( Y | X ) \coloneqq I ( X ; Y ) \). As \( H ( X _ 0 ) \leq r \) is independent of \( n \),

$$
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$

But note that

$$
\begin{aligned}
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) &= \\ E \left [ \sum _ { y \in \{ - 1 , 1 \} ^ { r } } P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] \log _ { 2 } \frac { P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] } { P [ Y _ { k } = y | Y _ { 1 } , \dots , Y _ { k - 1 } ] } \right ] ,
\end{aligned}
$$

which is precisely the expected relative entropy between the conditional distributions \( P [ Y _ k \in \cdot | X _ 0 , Y _ 1 , \dots , Y _ { k - 1 } ] \) and \( P [ Y _ k \in \cdot | Y _ 1 , \dots , Y _ { k - 1 } ] \). Thus by Pinsker’s inequality

$$
| \mathbf E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - \mathbf E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 }
$$

for every function \( g \). Now note that, by the conditional independence structure of the observations, we have \( E [ g ( Y _ k ) | X _ 0 , Y _ 1 , \dots , Y _ { k - 1 } , X _ k ] = E [ g ( Y _ k ) | Y _ 1 , \dots , Y _ { k - 1 } , X _ k ] = E [ g ( Y _ k ) | X _ k ] \). Thus we can write using the tower property

$$
\begin{aligned}
E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] , \\ E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] ,
\end{aligned}
$$

where

$$
f ( x ) = \mathbf E [ g ( Y _ { k } ) | X _ { k } = x ] = ( T _ { 1 } \cdots T _ { r } g ) ( x ) , \quad ( T _ { i } g ) ( x ) \coloneqq ( 1 - p ) g ( x ) + p g ( x ^ { - i } )
$$

and \( x ^ { - i } \coloneqq ( x _ 1 , \dots , x _ { i - 1 } , - x _ i , x _ { i + 1 } , \dots , x _ r ) \). But it is readily seen that if \( p \neq \frac { 1 } { 2 } \), then each operator \( T _ i \) is invertible. Thus every function \( f \) is of the form \( f ( x ) = E [ g ( Y _ k ) | X _ k = x ] \) for some function \( g \), and the proof is evidently complete. \square
