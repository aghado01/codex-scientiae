# Manifest: Page 015

## REPAIR_MATH
- RAW: ```
\text {For } j = 1 , \cdots , m ,
```
  FIX: ```
$$
\text {For } j = 1 , \cdots , m ,
$$
```
- RAW: ```
\text {For } j = 1 , \cdots , m , \\ | \mathbb { E } \hat { f } ( x _ { i _ { j } } ) - f ( x _ { i _ { j } } ) | & \ = \ | E \hat { a } _ { j } - f ( x _ { i _ { j } } ) | = \left | \frac { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) f ( x _ { i _ { j } } ) } { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) } - f ( x _ { i } ) \right | \\ & \leq \ \frac { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) | f ( x _ { i _ { j } } ) - f ( x _ { i } ) | } { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) } \\ & \leq \ \frac { L \int _ { \overline { B } _ { x _ { i } } ( \kappa ^ { - 1 } ) } ( 1 - ( \kappa \rho ( x _ { i } , \omega ) ) ^ { \beta } ) \rho ( x _ { i } , \omega ) ) ^ { \beta } d \omega } { \int _ { \overline { B } _ { x _ { i } } ( \kappa ^ { - 1 } ) } ( 1 - ( \kappa \rho ( x _ { i } , \omega ) ) ^ { \beta } ) d \omega } \\ & \sim \ \frac { L } { \kappa ^ { \beta } } \frac { d } { 2 \beta + d } = C _ { 0 } \psi _ { n } \frac { d } { 2 \beta + d } \\ \intertext { a n d } \text {as } n \to \infty .
```
  FIX: ```
$$
\text {For } j = 1 , \cdots , m , \\ | \mathbb { E } \hat { f } ( x _ { i _ { j } } ) - f ( x _ { i _ { j } } ) | & \ = \ | E \hat { a } _ { j } - f ( x _ { i _ { j } } ) | = \left | \frac { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) f ( x _ { i _ { j } } ) } { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) } - f ( x _ { i } ) \right | \\ & \leq \ \frac { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) | f ( x _ { i _ { j } } ) - f ( x _ { i } ) | } { \sum _ { j = 1 } ^ { m } K _ { \kappa , x _ { i } } ( x _ { i _ { j } } ) } \\ & \leq \ \frac { L \int _ { \overline { B } _ { x _ { i } } ( \kappa ^ { - 1 } ) } ( 1 - ( \kappa \rho ( x _ { i } , \omega ) ) ^ { \beta } ) \rho ( x _ { i } , \omega ) ) ^ { \beta } d \omega } { \int _ { \overline { B } _ { x _ { i } } ( \kappa ^ { - 1 } ) } ( 1 - ( \kappa \rho ( x _ { i } , \omega ) ) ^ { \beta } ) d \omega } \\ & \sim \ \frac { L } { \kappa ^ { \beta } } \frac { d } { 2 \beta + d } = C _ { 0 } \psi _ { n } \frac { d } { 2 \beta + d } \\ \intertext { a n d } \text {as } n \to \infty .
$$
```
- RAW: ```
\text { as } n \to \infty .
```
  FIX: ```
$$
\text { as } n \to \infty .
$$
```
- RAW: ```
\text {Proof of the upper bound.} \\ \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - f \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \right ) \\ \leq \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } + \psi _ { n } ^ { - 1 } \left \| \mathbb { E } \hat { f } - f \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \right ) \\ \leq \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } + ( 1 + \delta ) C _ { 0 } \frac { d } { 2 \beta + d } > ( 1 + \delta ) C _ { 0 } \right ) \\ = \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \frac { 2 \beta } { 2 \beta + d } \right ) = 0 \\ \\ \text {the second inequality uses Lemma 6.2 and the last line uses Lemma 6.1.}
```
  FIX: ```
$$
\text {Proof of the upper bound.} \\ \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - f \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \right ) \\ \leq \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } + \psi _ { n } ^ { - 1 } \left \| \mathbb { E } \hat { f } - f \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \right ) \\ \leq \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } + ( 1 + \delta ) C _ { 0 } \frac { d } { 2 \beta + d } > ( 1 + \delta ) C _ { 0 } \right ) \\ = \lim _ { n \to \infty } \mathbb { P } \left ( \psi _ { n } ^ { - 1 } \left \| \hat { f } - \mathbb { E } \hat { f } \right \| _ { \infty } > ( 1 + \delta ) C _ { 0 } \frac { 2 \beta } { 2 \beta + d } \right ) = 0 \\ \\ \text {the second inequality uses Lemma 6.2 and the last line uses Lemma 6.1.}
$$
```
- RAW: ```
& \lim _ { n \to \infty } \sup \mathbb { E } w ^ { 2 } ( \psi _ { n } ^ { - 1 } \left \| \hat { f } _ { n } - f \right \| _ { \infty } ) \\ & = \lim \sup _ { n \to \infty } \left ( \int _ { 0 } ^ { ( 1 + \delta ) C _ { 0 } } w ^ { 2 } ( x ) g _ { n } ( x ) d x + \int _ { ( 1 + \delta ) C _ { 0 } } ^ { \infty } w ^ { 2 } ( x ) g _ { n } ( x ) d x \right ) \\ & \leq w ^ { 2 } ( ( 1 + \delta ) C _ { 0 } ) + \lim _ { n \to \infty } \sup _ { ( 1 + \delta ) C _ { 0 } } \int _ { 0 } ^ { \infty } x ^ { \alpha } g _ { n } ( x ) d x = w ^ { 2 } ( ( 1 + \delta ) C _ { 0 } ) \leq B < \infty , \\ & \quad w h o r o t h o c n t a n t . \ B \ d o o s n t o n d o n o n f _ { \ } t h o w t h i r d l i n o s u s c h t o r
```
  FIX: ```
$$
& \lim _ { n \to \infty } \sup \mathbb { E } w ^ { 2 } ( \psi _ { n } ^ { - 1 } \left \| \hat { f } _ { n } - f \right \| _ { \infty } ) \\ & = \lim \sup _ { n \to \infty } \left ( \int _ { 0 } ^ { ( 1 + \delta ) C _ { 0 } } w ^ { 2 } ( x ) g _ { n } ( x ) d x + \int _ { ( 1 + \delta ) C _ { 0 } } ^ { \infty } w ^ { 2 } ( x ) g _ { n } ( x ) d x \right ) \\ & \leq w ^ { 2 } ( ( 1 + \delta ) C _ { 0 } ) + \lim _ { n \to \infty } \sup _ { ( 1 + \delta ) C _ { 0 } } \int _ { 0 } ^ { \infty } x ^ { \alpha } g _ { n } ( x ) d x = w ^ { 2 } ( ( 1 + \delta ) C _ { 0 } ) \leq B < \infty , \\ & \quad w h o r o t h o c n t a n t . \ B \ d o o s n t o n d o n o n f _ { \ } t h o w t h i r d l i n o s u s c h t o r
$$
```

