# Manifest: Page 014

## REPAIR_MATH
- RAW: ```
\mathbb { P } \left ( d _ { b } \left ( d g m ( \text {Filt} ( \mathbb { X } _ { \mu } ) ) , d g m ( \text {Filt} ( \mathbb { X } _ { n } ) ) \right ) & > \varepsilon \right ) \leq & \, \mathbb { P } \left ( d _ { G H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \mathbb { P } \left ( d _ { H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \min \left ( \frac { 2 ^ { b } } { a ^ { \varepsilon } b } \exp ( - n a \varepsilon ^ { b } ) , 1 \right ) , \\ \intertext { w h e r e } \mathbb { W } \left ( d _ { b } \left ( d g m ( \text {Filt} ( \mathbb { X } _ { \mu } ) ) , d g m ( \text {Filt} ( \mathbb { X } _ { n } ) ) > \varepsilon \right ) & < \mathbb { P } \left ( d _ { G } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \mathbb { P } \left ( d _ { H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \min \left ( \frac { 2 ^ { b } } { a ^ { \varepsilon } b } \exp ( - n a \varepsilon ^ { b } ) , 1 \right ) ,
```
  FIX: ```
$$
\mathbb { P } \left ( d _ { b } \left ( d g m ( \text {Filt} ( \mathbb { X } _ { \mu } ) ) , d g m ( \text {Filt} ( \mathbb { X } _ { n } ) ) \right ) & > \varepsilon \right ) \leq & \, \mathbb { P } \left ( d _ { G H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \mathbb { P } \left ( d _ { H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \min \left ( \frac { 2 ^ { b } } { a ^ { \varepsilon } b } \exp ( - n a \varepsilon ^ { b } ) , 1 \right ) , \\ \intertext { w h e r e } \mathbb { W } \left ( d _ { b } \left ( d g m ( \text {Filt} ( \mathbb { X } _ { \mu } ) ) , d g m ( \text {Filt} ( \mathbb { X } _ { n } ) ) > \varepsilon \right ) & < \mathbb { P } \left ( d _ { G } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \mathbb { P } \left ( d _ { H } \left ( \mathbb { X } _ { \mu } , \mathbb { X } _ { n } \right ) > \varepsilon / 2 \right ) \\ & \leq \min \left ( \frac { 2 ^ { b } } { a ^ { \varepsilon } b } \exp ( - n a \varepsilon ^ { b } ) , 1 \right ) ,
$$
```
- RAW: ```
\mathbb { E } _ { \mu ^ { n } } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) \right ] \\ = \int _ { 0 } ^ { \infty } \mathbb { P } \left ( d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) > \varepsilon \right ) d \varepsilon .
```
  FIX: ```
$$
\mathbb { E } _ { \mu ^ { n } } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) \right ] \\ = \int _ { 0 } ^ { \infty } \mathbb { P } \left ( d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) > \varepsilon \right ) d \varepsilon .
$$
```
- RAW: ```
\text {on } [ 0 , \varepsilon _ { n } ] , \text { we get } \\ \mathbb { E } _ { \mu ^ { n } } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \widehat { \mathbb { X } } _ { n } ) ) ) \right ] \\ \leqslant \varepsilon _ { n } + \int _ { \varepsilon _ { n } } ^ { \infty } \frac { 8 ^ { b } } { a } \exp ( - n a \varepsilon ^ { b } / 4 ^ { b } ) d \varepsilon \\ \leqslant \varepsilon _ { n } + \frac { 4 n 2 ^ { b } } { b } ( n a ) ^ { - 1 / b } \int _ { \log n } ^ { \infty } u ^ { 1 / b - 2 } \exp ( - u ) d u . \\ \text {now distinguish two cases.}
```
  FIX: ```
$$
\text {on } [ 0 , \varepsilon _ { n } ] , \text { we get } \\ \mathbb { E } _ { \mu ^ { n } } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \widehat { \mathbb { X } } _ { n } ) ) ) \right ] \\ \leqslant \varepsilon _ { n } + \int _ { \varepsilon _ { n } } ^ { \infty } \frac { 8 ^ { b } } { a } \exp ( - n a \varepsilon ^ { b } / 4 ^ { b } ) d \varepsilon \\ \leqslant \varepsilon _ { n } + \frac { 4 n 2 ^ { b } } { b } ( n a ) ^ { - 1 / b } \int _ { \log n } ^ { \infty } u ^ { 1 / b - 2 } \exp ( - u ) d u . \\ \text {now distinguish two cases.}
$$
```
- RAW: ```
\mathbb { E } \left [ d _ { b } ( d g m ( \text {Filt} ( X _ { \mu } ) ) , d g m ( \text {Filt} ( \widehat { X } _ { n } ) ) ) \right ] & \leqslant \varepsilon _ { n } + 4 \frac { 2 ^ { b } } { b } \left ( \frac { \log n } { n } \right ) ^ { 1 / b } ( \log n ) ^ { - 2 } \\ & \leqslant C _ { a , b } \left ( \frac { \log n } { n } \right ) ^ { 1 / b } ,
```
  FIX: ```
$$
\mathbb { E } \left [ d _ { b } ( d g m ( \text {Filt} ( X _ { \mu } ) ) , d g m ( \text {Filt} ( \widehat { X } _ { n } ) ) ) \right ] & \leqslant \varepsilon _ { n } + 4 \frac { 2 ^ { b } } { b } \left ( \frac { \log n } { n } \right ) ^ { 1 / b } ( \log n ) ^ { - 2 } \\ & \leqslant C _ { a , b } \left ( \frac { \log n } { n } \right ) ^ { 1 / b } ,
$$
```
- RAW: ```
b & < 2 . \quad \text {we } \iota ( \rho \cdot \underbar { = } [ 1 / 0 ] \text { and } u _ { n } \cdot \underbar { = } \log h ! \text { casing } \text {Recall} c d \text { incgurations by } \text { parts} \\ & \quad \text {yields} \\ & \quad \int _ { u _ { n } } ^ { \infty } u ^ { 1 / b - 2 } \exp ( - u ) d u \\ & = u _ { n } ^ { 1 / b - 2 } \exp ( u _ { n } ) + ( \frac { 1 } { b } - 2 ) u _ { n } ^ { 1 / b - 3 } \exp ( u _ { n } ) + \dots + \\ & \quad + \prod _ { i = 2 } ^ { p } \left ( \frac { 1 } { b } - i \right ) u _ { n } ^ { 1 / b - p } \exp ( u _ { n } ) + \int _ { \log n } ^ { \infty } u ^ { 1 / b - p - 1 } \exp ( - u ) d u \\ & \leqslant C _ { a , b } ^ { \prime } \frac { ( \log n ) ^ { 1 / b - 2 } } { n } , \\ & \text {where } C _ { a , b } ^ { \prime } \text { only depends only } a \text { and } b .
```
  FIX: ```
$$
b & < 2 . \quad \text {we } \iota ( \rho \cdot \underbar { = } [ 1 / 0 ] \text { and } u _ { n } \cdot \underbar { = } \log h ! \text { casing } \text {Recall} c d \text { incgurations by } \text { parts} \\ & \quad \text {yields} \\ & \quad \int _ { u _ { n } } ^ { \infty } u ^ { 1 / b - 2 } \exp ( - u ) d u \\ & = u _ { n } ^ { 1 / b - 2 } \exp ( u _ { n } ) + ( \frac { 1 } { b } - 2 ) u _ { n } ^ { 1 / b - 3 } \exp ( u _ { n } ) + \dots + \\ & \quad + \prod _ { i = 2 } ^ { p } \left ( \frac { 1 } { b } - i \right ) u _ { n } ^ { 1 / b - p } \exp ( u _ { n } ) + \int _ { \log n } ^ { \infty } u ^ { 1 / b - p - 1 } \exp ( - u ) d u \\ & \leqslant C _ { a , b } ^ { \prime } \frac { ( \log n ) ^ { 1 / b - 2 } } { n } , \\ & \text {where } C _ { a , b } ^ { \prime } \text { only depends only } a \text { and } b .
$$
```

