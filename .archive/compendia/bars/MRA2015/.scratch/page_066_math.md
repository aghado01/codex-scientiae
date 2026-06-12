[Page 66]

Accept the new value via

$$
\theta ^ { ( t + 1 ) } = \begin{cases} \ \theta ^ { * } & \text {with probability $\alpha_{\theta}$} \\ \ \theta ^ { ( t ) } & \text {with probability $1-\alpha_{\theta}$}, \end{cases}
$$

with acceptance probability

$$
\alpha _ { \theta } = \min \left \{ \frac { \pi ( \theta ^ { * } | I, C ) g ( \theta ^ { ( t ) } | \theta ^ { * } ) } { \pi ( \theta ^ { ( t ) } | I, C ) g ( \theta ^ { * } | \theta ^ { ( t ) } ) }, 1 \right \}
$$

such that π ( θ | I,C ) = p ( θ | I,C ) and g ( θ ∗ | θ ( t ) ) is the proposal density for θ ∗, i.e., N ( ˆ θ, ˆ Σ θ ) .

$$
p ( b _ { \gamma } | \gamma, b, \eta, \delta ) & \quad \infty \quad p ( b _ { \gamma } | \eta ) p ( b | \delta ) p ( \delta | g _ { 1 } ) \\ & \quad \infty \quad \delta ^ { \frac { K _ { s } } { 2 } } | D _ { \gamma } | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times \exp \left \{ - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} \\ & = \ \left | D _ { \gamma } \right | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

Partial derivatives:

$$
P a r t i a l \ d e r i v a t i v e s \colon \\ \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) \ = \ \frac { 1 } { 2 } \sum _ { j = 1 } ^ { K _ { \kappa } } z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} - \frac { 1 } { 2 } \eta b _ { \gamma } ^ { \prime } b _ { \gamma } \\ \frac { \partial \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } } \ = \ \frac { 1 } { 2 } Z _ { \gamma _ { 1 } } ^ { \prime } 1 - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } - \eta b _ { \gamma } \\ \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } \ = \ - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } z _ { \gamma _ { j } } ^ { \prime } - \eta I _ { K _ { \imath } + q } \\ \text {where } z _ { \gamma _ { j } } \text { is the } \text {th row of } Z _ { \gamma _ { j } } \text { .} \text {Propose a new value } b _ { \kappa } ^ { * } \text { from } N ( \hat { b } _ { \gamma, \hat { \Sigma } _ { h } } ) \text {, where}
$$

where z γ j is the j th row of Z γ.Propose a new value b ∗ γ from N ( ˆ b γ, ˆ Σ b γ ), where ˆ b γ = arg max b γ log p ( b γ | γ, b,η,δ ) and

$$
\hat { \Sigma } _ { b _ { \gamma } } = \left [ - \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } | _ { b _ { \gamma } = \hat { b } _ { \gamma } } \right ] ^ { - 1 } .
$$

Accept the new value via

$$
b _ { \gamma } ^ { ( t + 1 ) } = \begin{cases} \ b _ { \gamma } ^ { * } & \text {with probability $\alpha_{\gamma}$} \\ \ b _ { \gamma } ^ { ( t ) } & \text {with probability $1-\alpha_{\gamma}$}, \end{cases}
$$
