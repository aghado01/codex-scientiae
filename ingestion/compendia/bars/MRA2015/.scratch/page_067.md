
with acceptance probability

$$
\alpha _ { b _ { \gamma } } = \min \left \{ \frac { \pi ( b _ { \gamma } ^ { * } | \gamma , b , \eta , \delta ) g ( b _ { \gamma } ^ { ( t ) } | b _ { \gamma } ^ { * } ) } { \pi ( b _ { \gamma } ^ { ( t ) } | \gamma , b , \eta , \delta ) g ( b _ { \gamma } ^ { * } | b _ { \gamma } ^ { ( t ) } ) } , 1 \right \} ,
$$

such that π ( b γ | γ , b ,η,δ ) = p ( b γ | γ , b ,η,δ ) and g ( b ∗ γ | b ( t ) γ ) is the proposal density for b ∗ γ , i.e., N ( ˆ b γ , ˆ Σ b γ ) .

- 3. Sampling δ

$$
p ( \delta | b , \gamma , g _ { 1 } ) & \quad \infty \ \ p ( b | \gamma , \delta ) p ( \delta | g _ { 1 } ) \\ & \quad \ \alpha \ \delta ^ { \frac { K _ { s } } { 2 } } | D _ { \gamma } | ^ { 2 } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D , b \right \} \times ( \delta ^ { - 1 } ) ^ { - ( \frac { \lambda _ { 1 } } { 2 } + 1 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & \quad \ \alpha \ \delta ^ { \frac { K _ { s } } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times ( \delta ^ { - 1 } ) ^ { - ( \frac { \lambda _ { 1 } } { 2 } + 1 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } } { 2 } } ( \delta ^ { - 1 } ) ^ { - ( \frac { 1 } { 2 } + 1 ) } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } + \frac { \nu _ { 1 } } { 2 } - 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } + \frac { \nu _ { 1 } } { 2 } - 1 } { 2 } } \exp \left \{ - \delta \left [ \frac { 1 } { 2 } b ^ { \prime } D _ { \gamma } b + \frac { \nu _ { 1 } } { g _ { 1 } } \right ] \right \} , \quad \delta > 0 . \\
$$

- 4. Sampling g 1


$$
p ( g _ { 1 } | \delta ) & \quad \infty \quad p ( \delta | g _ { 1 } ) p ( g _ { 1 } ) \\ & \quad \times \quad \frac { ( \nu _ { 1 } / g _ { 1 } ) ^ { \frac { \nu _ { 1 } } { 2 } } } { \Gamma ( \nu _ { 1 } / 2 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \times g _ { 1 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & \quad \times \quad g _ { 1 } ^ { - \frac { \nu _ { 1 } } { 2 } } g _ { 1 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & = \quad g _ { 1 } ^ { - \frac { \nu _ { 1 } - \frac { 3 } { 2 } } { 2 } } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & = \quad g _ { 1 } ^ { - ( \frac { \nu _ { 1 } + 1 } { 2 } + 1 ) } \exp \left \{ - \frac { 1 } { g _ { 1 } } \left [ \nu _ { 1 } \delta + \frac { 1 } { G _ { 1 } ^ { 2 } } \right ] \right \} , \quad g _ { 1 } > 0 .
$$
