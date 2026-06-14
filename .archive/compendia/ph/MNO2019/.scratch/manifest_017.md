# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
p _ { \mathcal { D } } ( D ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { \mathcal { D } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \sum _ { i = 1 } ^ { N } c _ { i } ^ { P } \mathcal { N } ^ { * } ( d ; \mu _ { i } ^ { \mathcal { D } } , \sigma _ { i } ^ { \mathcal { D } } I ) ,
```
  FIX: ```
$$
p _ { \mathcal { D } } ( D ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { \mathcal { D } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \sum _ { i = 1 } ^ { N } c _ { i } ^ { P } \mathcal { N } ^ { * } ( d ; \mu _ { i } ^ { \mathcal { D } } , \sigma _ { i } ^ { \mathcal { D } } I ) ,
$$
```
- RAW: ```
p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) & = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { D | T _ { Y } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \left [ ( 1 - \alpha ) \lambda _ { \mathcal { D } } ( d ) + \frac { \alpha } { n } \sum _ { y _ { j } \in T _ { Y } } \sum _ { i = 1 } ^ { N } C _ { i } ^ { d | y _ { j } } \mathcal { N } ( d ; \mu _ { i } ^ { d | y _ { j } } , \sigma _ { i } ^ { d | y _ { j } } I ) \right ] , \ ( 1 0 )
```
  FIX: ```
$$
p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) & = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { D | T _ { Y } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \left [ ( 1 - \alpha ) \lambda _ { \mathcal { D } } ( d ) + \frac { \alpha } { n } \sum _ { y _ { j } \in T _ { Y } } \sum _ { i = 1 } ^ { N } C _ { i } ^ { d | y _ { j } } \mathcal { N } ( d ; \mu _ { i } ^ { d | y _ { j } } , \sigma _ { i } ^ { d | y _ { j } } I ) \right ] , \ ( 1 0 )
$$
```
- RAW: ```
B F ( D ) = \frac { p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) } { p _ { D | \mathcal { D } _ { Y ^ { \prime } } } ( D | T _ { Y ^ { \prime } } ) }
```
  FIX: ```
$$
B F ( D ) = \frac { p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) } { p _ { D | \mathcal { D } _ { Y ^ { \prime } } } ( D | T _ { Y ^ { \prime } } ) }
$$
```

