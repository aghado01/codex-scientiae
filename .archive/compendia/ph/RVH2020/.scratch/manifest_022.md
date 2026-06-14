# Manifest: Page 022

## REPAIR_MATH
- RAW: ```
$$
Y _ { k } ^ { v } = X _ { k } ^ { v } \xi _ { k } ^ { v } , \quad ( \xi _ { k } ^ { v } ) _ { k \in \mathbb { Z } , v \in \{ 1 , \dots , r \} } \ a r e \ i . i . d . \perp X \ w i t h \ P [ \xi _ { k } ^ { v } = - 1 ] = p .
$$
```
  FIX: ```
$$
Y _ { k } ^ { v } = X _ { k } ^ { v } \xi _ { k } ^ { v } , \quad ( \xi _ { k } ^ { v } ) _ { k \in \mathbb { Z } , v \in \{ 1 , \dots , r \} } \text{ are i.i.d. } \perp X \text{ with } P [ \xi _ { k } ^ { v } = - 1 ] = p .
$$
```

- RAW: ```
$$
| P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 }
$$
```
  FIX: ```
$$
| P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text{ in } L ^ { 1 }
$$
```

- RAW: ```
$$
n
$$

$$
& \sum _ { k = 1 } ^ { n } \{ H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \} \\ & = H ( Y _ { 1 } , \dots , Y _ { n } ) - H ( Y _ { 1 } , \dots , Y _ { n } | X _ { 0 } ) \\ & = H ( X _ { 0 } ) - H ( X _ { 0 } | Y _ { 1 } , \dots , Y _ { n } ) \leq H ( X _ { 0 } ) ,
$$

$$
\}
$$
```
  FIX: ```
$$
\begin{aligned}
& \sum _ { k = 1 } ^ { n } \{ H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \} \\ & = H ( Y _ { 1 } , \dots , Y _ { n } ) - H ( Y _ { 1 } , \dots , Y _ { n } | X _ { 0 } ) \\ & = H ( X _ { 0 } ) - H ( X _ { 0 } | Y _ { 1 } , \dots , Y _ { n } ) \leq H ( X _ { 0 } ) ,
\end{aligned}
$$
```

- RAW: ```
$$
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$
```
  FIX: ```
$$
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$
```

- RAW: ```
$$
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) = \\ E \left [ \sum _ { y \in \{ - 1 , 1 \} ^ { r } } P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] \log _ { 2 } \frac { P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] } { P [ Y _ { k } = y | Y _ { 1 } , \dots , Y _ { k - 1 } ] } \right ] ,
$$

$$
\lfloor y \in \{ - 1 , 1 \} ^ { r }
$$
```
  FIX: ```
$$
\begin{aligned}
H ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - H ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) &= \\ E \left [ \sum _ { y \in \{ - 1 , 1 \} ^ { r } } P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] \log _ { 2 } \frac { P [ Y _ { k } = y | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] } { P [ Y _ { k } = y | Y _ { 1 } , \dots , Y _ { k - 1 } ] } \right ] ,
\end{aligned}
$$
```

- RAW: ```
$$
| \mathbf E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - \mathbf E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 }
$$
```
  FIX: ```
$$
| \mathbf E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - \mathbf E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 }
$$
```

- RAW: ```
$$
E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] , \\ E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] ,
$$
```
  FIX: ```
$$
\begin{aligned}
E [ g ( Y _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] , \\ E [ g ( Y _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] & = E [ f ( X _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] ,
\end{aligned}
$$
```

- RAW: ```
$$
f ( x ) = \mathbf E [ g ( Y _ { k } ) | X _ { k } = x ] = ( T _ { 1 } \cdots T _ { r } g ) ( x ) , \quad ( T _ { i } g ) ( x ) \coloneqq ( 1 - p ) g ( x ) + p g ( x ^ { - i } )
$$
```
  FIX: ```
$$
f ( x ) = \mathbf E [ g ( Y _ { k } ) | X _ { k } = x ] = ( T _ { 1 } \cdots T _ { r } g ) ( x ) , \quad ( T _ { i } g ) ( x ) \coloneqq ( 1 - p ) g ( x ) + p g ( x ^ { - i } )
$$
```

## REPAIR_PROSE
- RAW: ```
Proposition 4.4. Let ( X k ,Y k ) k ∈ Z be a hidden Markov model as in section 2.1 with X k ∈ {− 1 , 1 } r (where r < ∞ ) and with observations Y k ∈ {− 1 , 1 } r of the form
```
  FIX: ```
Proposition 4.4. Let \( ( X _ k , Y _ k ) _ { k \in \mathbb { Z } } \) be a hidden Markov model as in section 2.1 with \( X _ k \in \{ - 1 , 1 \} ^ r \) (where \( r < \infty \)) and with observations \( Y _ k \in \{ - 1 , 1 \} ^ r \) of the form
```

- RAW: ```
for every set A , provided that p = 1 2 .

glyph[negationslash]
```
  FIX: ```
for every set A , provided that \( p \neq \frac { 1 } { 2 } \).
```

- RAW: ```
Proof. We use standard ideas from information theory [12]. Let H ( X ) denote entropy and H ( X | Y ) denote conditional entropy of discrete random variables X,Y . Then
```
  FIX: ```
Proof. We use standard ideas from information theory [12]. Let \( H ( X ) \) denote entropy and \( H ( X | Y ) \) denote conditional entropy of discrete random variables \( X , Y \). Then
```

- RAW: ```
where we have used the chain rule for entropy and symmetry of mutual information H ( X ) − H ( X | Y ) = H ( Y ) − H ( Y | X ) =: I ( X ; Y ). As H ( X 0 ) ≤ r is independent of n ,
```
  FIX: ```
where we have used the chain rule for entropy and symmetry of mutual information \( H ( X ) - H ( X | Y ) = H ( Y ) - H ( Y | X ) \coloneqq I ( X ; Y ) \). As \( H ( X _ 0 ) \leq r \) is independent of \( n \),
```

- RAW: ```
which is precisely the expected relative entropy between the conditional distributions P [ Y k ∈ ·| X 0 ,Y 1 ,...,Y k − 1 ] and P [ Y k ∈ ·| Y 1 ,...,Y k − 1 ]. Thus by Pinsker’s inequality
```
  FIX: ```
which is precisely the expected relative entropy between the conditional distributions \( P [ Y _ k \in \cdot | X _ 0 , Y _ 1 , \dots , Y _ { k - 1 } ] \) and \( P [ Y _ k \in \cdot | Y _ 1 , \dots , Y _ { k - 1 } ] \). Thus by Pinsker’s inequality
```

- RAW: ```
for every function g . Now note that, by the conditional independence structure of the observations, we have E [ g ( Y k ) | X 0 ,Y 1 ,...,Y k − 1 ,X k ] = E [ g ( Y k ) | Y 1 ,...,Y k − 1 ,X k ] = E [ g ( Y k ) | X k ]. Thus we can write using the tower property
```
  FIX: ```
for every function \( g \). Now note that, by the conditional independence structure of the observations, we have \( E [ g ( Y _ k ) | X _ 0 , Y _ 1 , \dots , Y _ { k - 1 } , X _ k ] = E [ g ( Y _ k ) | Y _ 1 , \dots , Y _ { k - 1 } , X _ k ] = E [ g ( Y _ k ) | X _ k ] \). Thus we can write using the tower property
```

- RAW: ```
and x − i := ( x 1 ,...,x i − 1 , − x i ,x i +1 ,...,x r ). But it is readily seen that if p   = 1 2 , then each operator T i is invertible. Thus every function f is of the form f ( x ) = E [ g ( Y k ) | X k = x ] for some function g , and the proof is evidently complete.

glyph[negationslash]
```
  FIX: ```
and \( x ^ { - i } \coloneqq ( x _ 1 , \dots , x _ { i - 1 } , - x _ i , x _ { i + 1 } , \dots , x _ r ) \). But it is readily seen that if \( p \neq \frac { 1 } { 2 } \), then each operator \( T _ i \) is invertible. Thus every function \( f \) is of the form \( f ( x ) = E [ g ( Y _ k ) | X _ k = x ] \) for some function \( g \), and the proof is evidently complete. \square
```
