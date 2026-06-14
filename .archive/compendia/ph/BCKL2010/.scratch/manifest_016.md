# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
& \text {loss function} \ w ( u ) . \text { Using the Cauchy-Schwarz inequality, we have} \\ & \quad \lim \sup _ { n \to \infty } \mathbb { E } w ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \\ & \quad \leq w ( ( 1 + \delta ) C _ { 0 } ) \lim \sup _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } - f \ \| _ { \infty } \leq ( 1 + \delta ) C _ { 0 } \right ) \\ & \quad + \lim \sup \left \{ \mathbb { E } w ^ { 2 } ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \mathbb { P } ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } - f \ \| _ { \infty } > ( 1 + \delta ) C _ { 0 } ) \right \} ^ { 1 / 2 } \\ & \quad = w ( ( 1 + \delta ) C _ { 0 } ) .
```
  FIX: ```
$$
& \text {loss function} \ w ( u ) . \text { Using the Cauchy-Schwarz inequality, we have} \\ & \quad \lim \sup _ { n \to \infty } \mathbb { E } w ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \\ & \quad \leq w ( ( 1 + \delta ) C _ { 0 } ) \lim \sup _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } - f \ \| _ { \infty } \leq ( 1 + \delta ) C _ { 0 } \right ) \\ & \quad + \lim \sup \left \{ \mathbb { E } w ^ { 2 } ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \mathbb { P } ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } - f \ \| _ { \infty } > ( 1 + \delta ) C _ { 0 } ) \right \} ^ { 1 / 2 } \\ & \quad = w ( ( 1 + \delta ) C _ { 0 } ) .
$$
```
- RAW: ```
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } \geq D .
```
  FIX: ```
$$
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } \geq D .
$$
```
- RAW: ```
( \kappa ^ { \prime } ) ^ { - 1 } = c ( \kappa ) \times \kappa ^ { - 1 } \\ \wr _ { \kappa } ( \omega ) = \omega \, \Omega \, \sigma _ { \kappa } \, \wr _ { \omega } ( \omega _ { \kappa } ) \, \Omega
```
  FIX: ```
$$
( \kappa ^ { \prime } ) ^ { - 1 } = c ( \kappa ) \times \kappa ^ { - 1 } \\ \wr _ { \kappa } ( \omega ) = \omega \, \Omega \, \sigma _ { \kappa } \, \wr _ { \omega } ( \omega _ { \kappa } ) \, \Omega
$$
```
- RAW: ```
\ v o l \left ( \mathbb { M } \right ) \leq \sum _ { i = 1 } ^ { N } v o l \left ( \overline { B } _ { x _ { i } } ( ( \kappa ^ { \prime } ) ^ { - 1 } ) \right ) \sim N v o l \left ( S ^ { d - 1 } \right ) ( \kappa ^ { \prime } ) ^ { - d } / d \\ \text {Thus}
```
  FIX: ```
$$
\ v o l \left ( \mathbb { M } \right ) \leq \sum _ { i = 1 } ^ { N } v o l \left ( \overline { B } _ { x _ { i } } ( ( \kappa ^ { \prime } ) ^ { - 1 } ) \right ) \sim N v o l \left ( S ^ { d - 1 } \right ) ( \kappa ^ { \prime } ) ^ { - d } / d \\ \text {Thus}
$$
```
- RAW: ```
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } = \liminf _ { \kappa \to \infty } c ( \kappa ) ^ { - d } N ( \kappa ^ { \prime } ) ^ { - d } \geq \text {const.} \times \frac { d v o l \left ( \mathbb { M } \right ) } { v o l \left ( S ^ { d - 1 } \right ) } .
```
  FIX: ```
$$
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } = \liminf _ { \kappa \to \infty } c ( \kappa ) ^ { - d } N ( \kappa ^ { \prime } ) ^ { - d } \geq \text {const.} \times \frac { d v o l \left ( \mathbb { M } \right ) } { v o l \left ( S ^ { d - 1 } \right ) } .
$$
```
- RAW: ```
J _ { \kappa , x } & = L \kappa ^ { - \beta } K _ { \kappa , x } ( x ) = L \kappa ^ { - \beta } ( 1 - ( \kappa d ( x , x ) ) ^ { \beta } ) _ { + } , \\ \\ \rho _ { \kappa , x } & = \varpi \, \Pi _ { \kappa } \, U _ { \kappa } \, \Pi _ { x } \, U _ { x } \, ( x ) \, \Psi _ { \kappa } \, \dot { \cdot } \, \Psi _ { x } \, \Psi _ { x }
```
  FIX: ```
$$
J _ { \kappa , x } & = L \kappa ^ { - \beta } K _ { \kappa , x } ( x ) = L \kappa ^ { - \beta } ( 1 - ( \kappa d ( x , x ) ) ^ { \beta } ) _ { + } , \\ \\ \rho _ { \kappa , x } & = \varpi \, \Pi _ { \kappa } \, U _ { \kappa } \, \Pi _ { x } \, U _ { x } \, ( x ) \, \Psi _ { \kappa } \, \dot { \cdot } \, \Psi _ { x } \, \Psi _ { x }
$$
```
- RAW: ```
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } \geq c o n s t .
```
  FIX: ```
$$
\liminf _ { \kappa \to \infty } N ( \kappa ) \kappa ^ { - d } \geq c o n s t .
$$
```

