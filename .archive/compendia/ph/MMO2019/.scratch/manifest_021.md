# Manifest: Page 021

## REPAIR_MATH
- RAW: ```
& \mathbb { E } ^ { f } [ Q ^ { * } ( \gamma ) ] \leq \int _ { W _ { 0 } d - 1 } g ( p _ { \min } ( Z ) ) f ( Z ) \delta Z = \int _ { W _ { 0 } d - 1 } \left ( \int _ { \infty } ^ { p _ { \min } ( Z ) } g ^ { \prime } ( p ) d p \right ) f ( Z ) \delta Z \\ & = \int _ { \infty } ^ { 0 } \left ( \int _ { \{ Z ; p _ { \min } ( Z ) < p \} } f ( Z ) \delta Z \right ) g ^ { \prime } ( p ) d p = \int _ { 0 } ^ { \infty } \left ( \mathbb { P } ^ { f } [ p _ { \min } < p ] \right ) q ^ { \prime } ( p ) d p .
```
  FIX: ```
$$
& \mathbb { E } ^ { f } [ Q ^ { * } ( \gamma ) ] \leq \int _ { W _ { 0 } d - 1 } g ( p _ { \min } ( Z ) ) f ( Z ) \delta Z = \int _ { W _ { 0 } d - 1 } \left ( \int _ { \infty } ^ { p _ { \min } ( Z ) } g ^ { \prime } ( p ) d p \right ) f ( Z ) \delta Z \\ & = \int _ { \infty } ^ { 0 } \left ( \int _ { \{ Z ; p _ { \min } ( Z ) < p \} } f ( Z ) \delta Z \right ) g ^ { \prime } ( p ) d p = \int _ { 0 } ^ { \infty } \left ( \mathbb { P } ^ { f } [ p _ { \min } < p ] \right ) q ^ { \prime } ( p ) d p .
$$
```
- RAW: ```
\mathbb { E } ^ { f } \left [ Q ^ { * } ( \gamma ) \right ] & \leq \int _ { 0 } ^ { \infty } \mathbb { P } ^ { f } ( \Delta _ { 0 } ^ { p } \cap D \neq \emptyset ) \frac { 1 } { 2 \sigma \sqrt { \pi } } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } d p \\ & \leq \frac { C } { 2 \sigma \sqrt { \pi } } \int _ { 0 } ^ { \infty } p e ^ { - ( p / 2 \sigma ) ^ { 2 } } d p = \frac { C } { 2 \sigma \sqrt { \pi } } \left [ - 2 \sigma ^ { 2 } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } \right ] _ { p = 0 } ^ { \infty } = \frac { C } { \sqrt { \pi } } \sigma .
```
  FIX: ```
$$
\mathbb { E } ^ { f } \left [ Q ^ { * } ( \gamma ) \right ] & \leq \int _ { 0 } ^ { \infty } \mathbb { P } ^ { f } ( \Delta _ { 0 } ^ { p } \cap D \neq \emptyset ) \frac { 1 } { 2 \sigma \sqrt { \pi } } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } d p \\ & \leq \frac { C } { 2 \sigma \sqrt { \pi } } \int _ { 0 } ^ { \infty } p e ^ { - ( p / 2 \sigma ) ^ { 2 } } d p = \frac { C } { 2 \sigma \sqrt { \pi } } \left [ - 2 \sigma ^ { 2 } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } \right ] _ { p = 0 } ^ { \infty } = \frac { C } { \sqrt { \pi } } \sigma .
$$
```

