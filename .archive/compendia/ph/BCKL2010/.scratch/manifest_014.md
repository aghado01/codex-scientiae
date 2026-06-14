# Manifest: Page 014

## REPAIR_MATH
- RAW: ```
\text {For sufficiently large $n$, $Z_{n}(x_{j})\sim N(0,\psi_{n}^{2}D_{n})$, hence as $n\to \infty$,} \\ \\ \mathbb { P } \left ( \| \psi _ { n } ^ { - 1 } Z _ { n } \| _ { \infty } > y \right ) & \ \leq \ \mathbb { P } \left ( \max _ { i = 1 , \cdots , m } \psi _ { n } ^ { - 1 } | Z _ { n } ( x _ { j } ) | > y \right ) \\ & \leq \ m \mathbb { P } \left ( D _ { n } ^ { - 1 } \psi _ { n } ^ { - 1 } | Z _ { n } ( x _ { j } ) | > \frac { y } { D _ { n } } \right ) \\ & \leq \ m \exp \left \{ - \frac { 1 } { 2 } \frac { y ^ { 2 } } { D _ { n } ^ { 2 } } \right \} = m \exp \left \{ - \frac { d ( 1 + \delta ) ^ { 2 } \log n } { 2 \beta + d } \right \} . \\ \text {Therefore}
```
  FIX: ```
$$
\text {For sufficiently large $n$, $Z_{n}(x_{j})\sim N(0,\psi_{n}^{2}D_{n})$, hence as $n\to \infty$,} \\ \\ \mathbb { P } \left ( \| \psi _ { n } ^ { - 1 } Z _ { n } \| _ { \infty } > y \right ) & \ \leq \ \mathbb { P } \left ( \max _ { i = 1 , \cdots , m } \psi _ { n } ^ { - 1 } | Z _ { n } ( x _ { j } ) | > y \right ) \\ & \leq \ m \mathbb { P } \left ( D _ { n } ^ { - 1 } \psi _ { n } ^ { - 1 } | Z _ { n } ( x _ { j } ) | > \frac { y } { D _ { n } } \right ) \\ & \leq \ m \exp \left \{ - \frac { 1 } { 2 } \frac { y ^ { 2 } } { D _ { n } ^ { 2 } } \right \} = m \exp \left \{ - \frac { d ( 1 + \delta ) ^ { 2 } \log n } { 2 \beta + d } \right \} . \\ \text {Therefore}
$$
```
- RAW: ```
\mathbb { P } \left ( \| \psi _ { n } ^ { - 1 } Z _ { n } \, | _ { \infty } > y \right ) \leq n ^ { - d ( ( 1 + \delta ) ^ { 2 } - 1 ) / ( 2 \beta + d ) } ( \log n ) ^ { - d / ( 2 \beta + d ) } D _ { n } \left ( \frac { L ( 2 \beta + d ) } { \delta C _ { 0 } d } \right ) ^ { d / \beta } .
```
  FIX: ```
$$
\mathbb { P } \left ( \| \psi _ { n } ^ { - 1 } Z _ { n } \, | _ { \infty } > y \right ) \leq n ^ { - d ( ( 1 + \delta ) ^ { 2 } - 1 ) / ( 2 \beta + d ) } ( \log n ) ^ { - d / ( 2 \beta + d ) } D _ { n } \left ( \frac { L ( 2 \beta + d ) } { \delta C _ { 0 } d } \right ) ^ { d / \beta } .
$$
```
- RAW: ```
\lim _ { n \to \infty } \sup _ { f \in \Lambda ( \beta , L ) } \psi _ { n } ^ { - 1 } \, \| \ f - \mathbb { E } \hat { f } _ { n } \, \| _ { \infty } \leq ( 1 + \delta ) C _ { 0 } \frac { d } { 2 \beta + d }
```
  FIX: ```
$$
\lim _ { n \to \infty } \sup _ { f \in \Lambda ( \beta , L ) } \psi _ { n } ^ { - 1 } \, \| \ f - \mathbb { E } \hat { f } _ { n } \, \| _ { \infty } \leq ( 1 + \delta ) C _ { 0 } \frac { d } { 2 \beta + d }
$$
```
- RAW: ```
\| \ f - \mathbb { E } \hat { f } \ \| _ { \infty } & \ = \ \max _ { j = 1 , \dots , m } \sup _ { x \in A _ { j } } | f ( x ) - \mathbb { E } \hat { f } ( x ) | \\ & \leq \ \max _ { j = 1 , \dots , m } \sup _ { x \in A _ { j } } \left ( | f ( x ) - f ( x _ { j } ) | + | \mathbb { E } \hat { f } ( x _ { j } ) - f ( x _ { j } ) | \right ) \\ & \leq \ \max _ { j = 1 , \dots , m } \left ( | \mathbb { E } \hat { f } ( x _ { j } ) - f ( x _ { j } ) | + L \sup _ { x \in A _ { j } } \rho ( x , x _ { j } ) ^ { \beta } \right ) .
```
  FIX: ```
$$
\| \ f - \mathbb { E } \hat { f } \ \| _ { \infty } & \ = \ \max _ { j = 1 , \dots , m } \sup _ { x \in A _ { j } } | f ( x ) - \mathbb { E } \hat { f } ( x ) | \\ & \leq \ \max _ { j = 1 , \dots , m } \sup _ { x \in A _ { j } } \left ( | f ( x ) - f ( x _ { j } ) | + | \mathbb { E } \hat { f } ( x _ { j } ) - f ( x _ { j } ) | \right ) \\ & \leq \ \max _ { j = 1 , \dots , m } \left ( | \mathbb { E } \hat { f } ( x _ { j } ) - f ( x _ { j } ) | + L \sup _ { x \in A _ { j } } \rho ( x , x _ { j } ) ^ { \beta } \right ) .
$$
```
- RAW: ```
\lim \sup _ { n \to \infty } \sup _ { x \in A _ { j } } \rho ( x , x _ { j } ) \leq \lim \sup _ { n \to \infty } \lambda ^ { - 1 } \leq \lim \sup _ { n \to \infty } \left ( \frac { C _ { 1 } } { m } \right ) ^ { 1 / d } .
```
  FIX: ```
$$
\lim \sup _ { n \to \infty } \sup _ { x \in A _ { j } } \rho ( x , x _ { j } ) \leq \lim \sup _ { n \to \infty } \lambda ^ { - 1 } \leq \lim \sup _ { n \to \infty } \left ( \frac { C _ { 1 } } { m } \right ) ^ { 1 / d } .
$$
```
- RAW: ```
\lim \sup _ { n \to \infty } \sup _ { x \in A _ { j } } \psi _ { n } ^ { - 1 } \rho ( x , x _ { j } ) ^ { \beta } \leq \lim _ { n \to \infty } \sup _ { n } \psi _ { n } ^ { - 1 } \left ( \frac { C _ { 1 } } { m } \right ) ^ { \beta / d } \leq \frac { \delta C _ { 0 } d } { L ( 2 \beta + d ) } .
```
  FIX: ```
$$
\lim \sup _ { n \to \infty } \sup _ { x \in A _ { j } } \psi _ { n } ^ { - 1 } \rho ( x , x _ { j } ) ^ { \beta } \leq \lim _ { n \to \infty } \sup _ { n } \psi _ { n } ^ { - 1 } \left ( \frac { C _ { 1 } } { m } \right ) ^ { \beta / d } \leq \frac { \delta C _ { 0 } d } { L ( 2 \beta + d ) } .
$$
```

