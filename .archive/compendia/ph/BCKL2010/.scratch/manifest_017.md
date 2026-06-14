# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
\text {Let} \\ \mathcal { C } ( \kappa , \{ x _ { i } \} ) = \left \{ \sum _ { i = 1 } ^ { N } \theta _ { i } J _ { \kappa , x _ { i } } \colon | \theta _ { i } | \leq 1 , i = 1 , \cdots , N \right \} , \\ \text {where } \mathcal { C } ( \kappa , \{ x _ { i } \} ) \subset \Lambda ( \beta , L ) \text { when } 0 < \beta \leq 1 . \text { The complete class of }
```
  FIX: ```
$$
\text {Let} \\ \mathcal { C } ( \kappa , \{ x _ { i } \} ) = \left \{ \sum _ { i = 1 } ^ { N } \theta _ { i } J _ { \kappa , x _ { i } } \colon | \theta _ { i } | \leq 1 , i = 1 , \cdots , N \right \} , \\ \text {where } \mathcal { C } ( \kappa , \{ x _ { i } \} ) \subset \Lambda ( \beta , L ) \text { when } 0 < \beta \leq 1 . \text { The complete class of }
$$
```
- RAW: ```
\hat { f } _ { n } = \sum _ { i = 1 } ^ { N } \hat { \theta } _ { i } J _ { \kappa , x _ { i } } \\ \text {where } \hat { \theta } _ { i } = \delta _ { i } ( z _ { 1 } \cdots z _ { N } ) \ i = 1 \cdots N \text { and}
```
  FIX: ```
$$
\hat { f } _ { n } = \sum _ { i = 1 } ^ { N } \hat { \theta } _ { i } J _ { \kappa , x _ { i } } \\ \text {where } \hat { \theta } _ { i } = \delta _ { i } ( z _ { 1 } \cdots z _ { N } ) \ i = 1 \cdots N \text { and}
$$
```
- RAW: ```
i = & 1 \\ \text {where } \hat { \theta } _ { i } = \delta _ { i } ( z _ { 1 } , \cdots , z _ { N } ) , i = 1 , \cdots , N , \text { and} \\ & z _ { i } = \frac { \sum _ { j = 1 } ^ { n } J _ { \kappa , x _ { i } } ( x _ { j } ) y _ { j } } { \sum _ { j = 1 } ^ { n } J _ { \kappa , x _ { i } } ^ { 2 } ( x _ { j } ) } . \\ \text {When } \hat { f } _ { n } \text { is of the form } ( 6 . 2 ) \text { and } f \in \mathcal { C } ( \kappa , \{ x _ { i } \} ) \text { then} \\ & \| \hat { f } _ { n } \text { } f \| _ { 0 } \ > \ \max _ { \hat { f } _ { n } } | \hat { f } _ { n } ( x _ { j } ) \ \hat { f } ( x _ { j } ) | _ { 1 } \ \lfloor I _ { ( n + 1 ) } ( x _ { j } ) \rfloor \\
```
  FIX: ```
$$
i = & 1 \\ \text {where } \hat { \theta } _ { i } = \delta _ { i } ( z _ { 1 } , \cdots , z _ { N } ) , i = 1 , \cdots , N , \text { and} \\ & z _ { i } = \frac { \sum _ { j = 1 } ^ { n } J _ { \kappa , x _ { i } } ( x _ { j } ) y _ { j } } { \sum _ { j = 1 } ^ { n } J _ { \kappa , x _ { i } } ^ { 2 } ( x _ { j } ) } . \\ \text {When } \hat { f } _ { n } \text { is of the form } ( 6 . 2 ) \text { and } f \in \mathcal { C } ( \kappa , \{ x _ { i } \} ) \text { then} \\ & \| \hat { f } _ { n } \text { } f \| _ { 0 } \ > \ \max _ { \hat { f } _ { n } } | \hat { f } _ { n } ( x _ { j } ) \ \hat { f } ( x _ { j } ) | _ { 1 } \ \lfloor I _ { ( n + 1 ) } ( x _ { j } ) \rfloor \\
$$
```
- RAW: ```
-
```
  FIX: ```
$$
-
$$
```
- RAW: ```
\| \hat { f } _ { n } - f \ \| _ { \infty } & \quad \geq \max _ { i = 1 , \cdots , N } | \hat { f } _ { n } ( x _ { i } ) - f ( x _ { i } ) | = | J _ { \kappa , x _ { 1 } } ( x _ { 1 } ) | \| \ \hat { \theta } - \theta \ \| _ { \infty } \\ & = \ L \kappa ^ { - \beta } \ \| \hat { \theta } - \theta \ \| _ { \infty }
```
  FIX: ```
$$
\| \hat { f } _ { n } - f \ \| _ { \infty } & \quad \geq \max _ { i = 1 , \cdots , N } | \hat { f } _ { n } ( x _ { i } ) - f ( x _ { i } ) | = | J _ { \kappa , x _ { 1 } } ( x _ { 1 } ) | \| \ \hat { \theta } - \theta \ \| _ { \infty } \\ & = \ L \kappa ^ { - \beta } \ \| \hat { \theta } - \theta \ \| _ { \infty }
$$
```
- RAW: ```
r _ { n } & \ \geq \ \inf _ { \hat { f } _ { n } \ f \in \mathcal { C } ( \kappa , \{ x _ { i } \} ) } \mathbb { E } w ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \\ & \geq \ \inf _ { \hat { \theta } } \sup _ { | \theta _ { i } | \leq 1 } \mathbb { E } w ( \psi _ { \varepsilon } ^ { - 1 } L \kappa ^ { - \beta } \ \| \ \hat { \theta } - \theta \ \| _ { \infty } ) , \\
```
  FIX: ```
$$
r _ { n } & \ \geq \ \inf _ { \hat { f } _ { n } \ f \in \mathcal { C } ( \kappa , \{ x _ { i } \} ) } \mathbb { E } w ( \psi _ { n } ^ { - 1 } \ \| \ \hat { f } _ { n } - f \ \| _ { \infty } ) \\ & \geq \ \inf _ { \hat { \theta } } \sup _ { | \theta _ { i } | \leq 1 } \mathbb { E } w ( \psi _ { \varepsilon } ^ { - 1 } L \kappa ^ { - \beta } \ \| \ \hat { \theta } - \theta \ \| _ { \infty } ) , \\
$$
```
- RAW: ```
\text {Fix a small number $\delta$ such that $0 < \delta < 2$ and} \\ C _ { 0 } ^ { \prime } = L ^ { d / ( 2 \beta + d ) } \left ( \frac { ( 2 - \delta ) v o l \left ( \mathbb { M } \right ) ( \beta + d ) d ^ { 2 } } { 2 v o l \left ( \mathbb { S } ^ { d - 1 } \right ) \beta ^ { 2 } } \right ) ^ { \beta / ( 2 \beta + d ) } \\ \kappa = \left ( \frac { C _ { 0 } ^ { \prime } \psi _ { \varepsilon } } { L } \right ) ^ { - 1 / \beta } .
```
  FIX: ```
$$
\text {Fix a small number $\delta$ such that $0 < \delta < 2$ and} \\ C _ { 0 } ^ { \prime } = L ^ { d / ( 2 \beta + d ) } \left ( \frac { ( 2 - \delta ) v o l \left ( \mathbb { M } \right ) ( \beta + d ) d ^ { 2 } } { 2 v o l \left ( \mathbb { S } ^ { d - 1 } \right ) \beta ^ { 2 } } \right ) ^ { \beta / ( 2 \beta + d ) } \\ \kappa = \left ( \frac { C _ { 0 } ^ { \prime } \psi _ { \varepsilon } } { L } \right ) ^ { - 1 / \beta } .
$$
```
- RAW: ```
\text {Since} & & \sigma _ { N } ^ { - 1 } \ = \ \sigma ^ { - 1 } \sqrt { \sum _ { j = 1 } ^ { N } J _ { \kappa , x _ { i } } ^ { 2 } ( x _ { j } ) } \sim \sqrt { \frac { ( 2 - \delta ) d } { 2 \beta + d } } \log n \\ & \leq \ \sqrt { ( 2 - \delta ) ( \log ( \log n / n ) ^ { - d / ( 2 \beta + d ) } ) } \\ & = \ \sqrt { 2 - \delta } \sqrt { \log ( \log n \times \kappa ^ { d } ) } = \sqrt { 2 - \delta } \sqrt { \log N }
```
  FIX: ```
$$
\text {Since} & & \sigma _ { N } ^ { - 1 } \ = \ \sigma ^ { - 1 } \sqrt { \sum _ { j = 1 } ^ { N } J _ { \kappa , x _ { i } } ^ { 2 } ( x _ { j } ) } \sim \sqrt { \frac { ( 2 - \delta ) d } { 2 \beta + d } } \log n \\ & \leq \ \sqrt { ( 2 - \delta ) ( \log ( \log n / n ) ^ { - d / ( 2 \beta + d ) } ) } \\ & = \ \sqrt { 2 - \delta } \sqrt { \log ( \log n \times \kappa ^ { d } ) } = \sqrt { 2 - \delta } \sqrt { \log N }
$$
```

