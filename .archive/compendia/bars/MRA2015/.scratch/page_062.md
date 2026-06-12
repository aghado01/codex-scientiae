
# A.2 BAPS Sampling Scheme

The derivation of the full conditional distributions for the BAPS model is provided in this section.

# 1. Sampling θ

$$
1 . \, & \, Sampling \, \theta \\ p ( \theta | b , \beta , \gamma , \tau , \xi _ { 1 } , y ) \quad \otimes \quad p ( y | b , \theta , \tau ) p ( b | \tau , \xi _ { 1 } ) p ( \beta ) p ( \tau ) p ( \xi _ { 1 } | \rho _ { 1 } ) \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) \right \} \times \exp \left \{ - \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } D , b \right \} \times \exp \left \{ - \frac { 1 } { 2 \sigma _ { 2 } ^ { 3 } } \beta ^ { \prime } \beta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } - \theta ^ { \prime } T ^ { \prime } ) ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } y - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { \tau } { 2 } \theta ^ { \prime } T T \theta - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & \quad \otimes \quad \exp \left \{ \tau T ^ { \prime } T + \Lambda _ { y } \theta \right \} .
$$

Note that Q θ = ( τT T + Λ y ) − 1 . By solving for µ θ , i.e., Q − 1 θ µ θ = τT y ⇒ µ θ = τQ θ T y .

# 2. Sampling τ

$$
p ( \tau | \gamma , b , \xi _ { 1 } , \xi _ { 2 } , y ) & \quad \otimes \quad p ( y | \beta , b , \tau ) p ( \tau ) p ( b | \tau , \xi _ { 1 } ) p ( b _ { \gamma } | \tau , \xi _ { 1 } , \xi _ { 2 } ) \\ & \quad \otimes \quad \tau ^ { \frac { \hbar { \ell } } { 2 } ( \xi _ { 1 } ) ^ { \frac { 2 } { 2 } } ( \xi _ { 1 } \xi _ { 2 } ) ^ { \frac { K + a } { 2 } - \tau ^ { 1 } } \exp \left \{ - \frac { \tau } { 2 } \| y - T \theta \| ^ { 2 } - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D , b - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \xi _ { 1 } } _ { \gamma } b ^ { \prime } _ { \gamma } \right \} \\ & \quad \otimes \quad \tau ^ { \frac { n + K _ { s } + K _ { 1 } + a } { 2 } - 1 } \exp \left \{ - \frac { \tau } { 2 } \| y - T \theta \| ^ { 2 } - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D , b - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } , b \right \} \\ & = \quad \tau ^ { \frac { n } { 2 } ( n + K _ { s } + K _ { 1 } + a ) - 1 } \exp \left \{ - \frac { \left [ 1 } { 2 } \| y - T \theta \| ^ { 2 } + \frac { \xi _ { 1 } } { 2 } b ^ { \prime } D , b + \frac { \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } b _ { \gamma } \right ] \right \} , \quad \tau > 0 .
$$
