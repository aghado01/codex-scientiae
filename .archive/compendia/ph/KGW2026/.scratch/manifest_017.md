# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
\phi ( v ) \in \{ S , W \} \times \{ N _ { w } \} \times \{ N _ { w } \} \times \{ S , W \} .
```
  FIX: ```
$$
\phi ( v ) \in \{ S , W \} \times \{ N _ { w } \} \times \{ N _ { w } \} \times \{ S , W \} .
$$
```
- RAW: ```
( S , T , N _ { w } , T ) , ( S , S , N _ { w } , T ) , ( S , W , N _ { w } , T ) , ( T , N _ { w } , T , S ) , ( T , N _ { w } , S , ) , ( T , N _ { w } , W , S ) , ( S , N _ { w } , N _ { w } , S )
```
  FIX: ```
$$
( S , T , N _ { w } , T ) , ( S , S , N _ { w } , T ) , ( S , W , N _ { w } , T ) , ( T , N _ { w } , T , S ) , ( T , N _ { w } , S , S ) , ( T , N _ { w } , W , S ) , ( S , N _ { w } , N _ { w } , S )
$$
```
- RAW: ```
\gamma _ { 1 } & = ( S , T , N _ { w } , T ) , \quad \gamma _ { 2 } = ( S , S , N _ { w } , T ) , \quad \gamma _ { 3 } = ( S , W , N _ { w } , T ) , \\ \gamma _ { 4 } & = ( T , N _ { w } , T , S ) , \quad \gamma _ { 5 } = ( T , N _ { w } , S , S ) , \quad \gamma _ { 6 } = ( T , N _ { w } , W , S ) , \\ \gamma _ { 7 } & = ( S , N _ { w } , N _ { w } , S ) .
```
  FIX: ```
$$
\gamma _ { 1 } & = ( S , T , N _ { w } , T ) , \quad \gamma _ { 2 } = ( S , S , N _ { w } , T ) , \quad \gamma _ { 3 } = ( S , W , N _ { w } , T ) , \\ \gamma _ { 4 } & = ( T , N _ { w } , T , S ) , \quad \gamma _ { 5 } = ( T , N _ { w } , S , S ) , \quad \gamma _ { 6 } = ( T , N _ { w } , W , S ) , \\ \gamma _ { 7 } & = ( S , N _ { w } , N _ { w } , S ) .
$$
```
- RAW: ```
\gamma _ { 8 } = ( T , S , S , T ) , \gamma _ { 9 } = ( T , T , T , T )
```
  FIX: ```
$$
\gamma _ { 8 } = ( T , S , S , T ) , \gamma _ { 9 } = ( T , T , T , T )
$$
```

- If \( e_{i,k}, e_{j,l} \notin A_1 \), then the second and third faces are non-admissible and
So far this yields a finite list of candidate patterns, but most of them are excluded by the cancellation requirement defining \( \Omega_{N,1}^3 \) of a simple digraph.
By Lemma 3.5, all patterns whose second entry is \( N_w \) but fourth entry is not \( S \), and all patterns whose third entry is \( N_w \) but first entry is not \( S \) is not in \( C_{N,1} \). The surviving patterns are
Together with \( (T,T,T,T) \) (for all \( N \ge 2 \)) and \( (T,S,S,T) \), this gives \( |\phi(C_{N,1})| = 9 \) for \( N \ge 2 \).
The significance of this classification is that every component of a minimal element of \( \Omega_{N,1}^3 \) belongs to one of finitely many types.
Each vertex of \( \Gamma \) can be labeled by its type that is listed in the previous theorem.
For the following lemma, one-step connectable means, they share the \( N_w \) face and the linear combination of these two elements will cancel the \( N_w \) component.
Lemma 3.7. The components \( \gamma_i \) are one-step connectable only to themselves and to \( \gamma_7 \) for \( i = 1, 2, 4, 5 \) where \( \gamma_3 \) and \( \gamma_6 \) is one-step connectable to only \( \gamma_7 \). The component \( \gamma_7 \) is one-step connectable to all elements of \( L \).
Proof. Let \( w \in \Omega_{N,1}^3 \) be a \( (a,b) \)-cluster so that \( w = w_i \). The existence of \( e_{a,b} \) will create partition of patterns. Thus the elements of \( N_{a,b} = \{\gamma_2, \gamma_3, \gamma_5, \gamma_6\} \) is not one-step connectable to the elements of \( A_{a,b} = \{\gamma_1, \gamma_4\} \) where \( A_{a,b} \) is the set of types where \( e_{a,b} \) is admissible and \( N_{a,b} \) is non-admissible. Furthermore, they will not be in the linear combination together with \( \gamma_1 \) and \( \gamma_4 \) for generators of \( \Omega_{N,1}^3 \).
Similarly, the existence of multiple \( e_{a,*,b} \) is possible for the patterns \( \gamma_2, \gamma_5 \) while there is a unique \( e_{a,*,b} \) in \( \gamma_3, \gamma_6 \). This results in three different groups such as \( \{\gamma_1, \gamma_4\} \), \( \{\gamma_2, \gamma_5\} \) and \( \{\gamma_3, \gamma_6\} \)
Observe that \( \pi_2(\gamma_1) = 0 \) and \( \pi_2(\gamma_4) = 1 \) which makes them incompatible for one-step connection where \( \pi_2 \) and \( \pi_3 \) are indicator maps that is defined in the proof of Theorem 3.6. The only element of \( L \) whose image-type contains non-admissible faces at both indices 2 and 3 is \( \gamma_7 \). Therefore \( \gamma_1 \) and \( \gamma_4 \) are one-step connectable only to themselves and to \( \gamma_7 \). The same reason is valid for pairs \( (\gamma_3, \gamma_6) \) and \( (\gamma_2, \gamma_5) \)
Let \( \phi(e_{a,j_1,k_1,b}) = \gamma_3 \) and \( \phi(e_{a,j_1,k_2,b}) = \gamma_3 \) be two 3-paths so that their \( N_w \) components aligns where \( \gamma_3 = (S, W, N_w, T) \). The pattern induces that \( e_{a,k_2} \in A_1 \) and \( e_{a,k_1,b} \) is only admissible which conditions that there is no \( e_{i,l} \) or \( e_{i,*,l} \). Since \( e_{i,k_2} \in A_1 \) we have \( e_{i,k_2,l} \in A_2 \). Therefore this one-step connection is not possible. Thus \( \gamma_3 \) is only one-step connectable to \( \gamma_7 \). Since \( \gamma_6 = (T, N_w, W, S) \) is symmetric of \( \gamma_3 = (S, W, N_w, T) \), the same reason is obstacle to create one-step connection \( \gamma_6 \) to itself. Therefore \( \gamma_6 \) is only one-step connectable to \( \gamma_7 \). There is no restriction to connect \( \gamma_7 \) to itself which proves the last part of the claim.

