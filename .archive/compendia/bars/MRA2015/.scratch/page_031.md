
$$
Q _ { \theta } = ( \tau T ^ { \prime } T + \Lambda _ { y } ) ^ { - 1 } ,
$$

and Λ y = diag(1 /σ 2 β ,..., 1 /σ 2 β ,τξ 1 e γ 1 ,...,τξ 1 e γ K κ ).

- 2. The parameter τ is sampled from the gamma distribution,

$$
G \left ( \frac { 1 } { 2 } ( n + K _ { \kappa } + K _ { \iota } + q ) , \frac { 1 } { 2 } ( \| y - T \theta \| ^ { 2 } + \xi _ { 1 } b ^ { \prime } D _ { \gamma } b + \xi _ { 1 } \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } ) \right ) .
$$

- 3. The parameter ξ 1 is sampled from the gamma distribution,

$$
G \left ( \frac { 1 } { 2 } ( K _ { \kappa } + K _ { \iota } + q ) + 1 , \frac { 1 } { 2 } \tau b ^ { \prime } D _ { \gamma } b + \frac { 1 } { 2 } \tau \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 1 } \right ) .
$$

- 4. The parameter ξ 2 is sampled from the gamma distribution,

$$
G \left ( \frac { 1 } { 2 } ( K _ { \iota } + q ) + 1 , \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 2 } \right ) .
$$

- 5. The parameter ρ 1 is sampled from the gamma distribution, G (2 ,ξ 1 + c 1 ).
- 6. The parameter ρ 2 is sampled from the gamma distribution, G (2 ,ξ 2 + c 2 ).
- 7. The b γk ’s are sampled via a Metropolis-Hastings (M-H) step from


$$
p ( b _ { \gamma } | \gamma , b , \delta , \eta ) \, \in \, | D _ { \gamma } | ^ { 1 / 2 } \exp \left \{ - \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } D _ { \gamma } b - \frac { 1 } { 2 } \tau \xi _ { 1 } \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

A new value b ∗ γ is proposed from N ( ˆ b γ , ˆ Σ b γ ) , where ˆ b γ = arg max b γ log p ( b γ | γ , b ,τ,ξ 1 ,ξ 2 ) and 2 1

$$
\hat { \Sigma } _ { b _ { \gamma } } = \left [ - \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma , b , \tau , \xi _ { 1 } , \xi _ { 2 } ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } | _ { b _ { \gamma } = \hat { b } _ { \gamma } } \right ] ^ { - 1 } .
$$

The new value, b ( t +1) γ , satisfies

$$
b _ { \gamma } ^ { ( t + 1 ) } = \left \{ \begin{array} { l l } { b _ { \gamma } ^ { * } } & { w i t h \text { probability } \alpha _ { \gamma } } \\ { b _ { \gamma } ^ { ( t ) } } & { w i t h \text { probability } 1 - \alpha _ { b _ { \gamma } } , } \end{array}
$$

where b ( t ) γ is the current value. The acceptance probability is

$$
\alpha _ { b _ { \gamma } } = \min \left \{ \frac { p ( b _ { \gamma } ^ { * } | \gamma , b , \tau , \xi _ { 1 } , \xi _ { 2 } ) g ( b _ { \gamma } ^ { ( t ) } | b _ { \gamma } ^ { * } ) } { p ( b _ { \gamma } ^ { ( t ) } | \gamma , b , \tau , \xi _ { 1 } , \xi _ { 2 } ) g ( b _ { \gamma } ^ { * } | b _ { \gamma } ^ { ( t ) } ) } , 1 \right \} ,
$$

where g ( b ∗ γ | b ( t ) γ ) is the proposal density for b ∗ γ , i.e., N ( ˆ b γ , ˆ Σ b γ ) .
