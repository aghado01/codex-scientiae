# Manifest: Page 022

## REPAIR_MATH
- RAW: ```
C _ { i } , \, \text {according to the upper cardinality } \, j \colon & \\ & K _ { \sigma } ( Z , \mathcal { D } _ { i } ) = \sum _ { j = 0 } ^ { N _ { i } } \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & = \nu _ { i } ( N - N _ { i } ) Q _ { i } ( \text {id} ) \prod _ { k = 1 } ^ { N _ { i } } p _ { i } ^ { ( k ) } ( \xi _ { k } ) \prod _ { k = N + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & \quad N _ { i } - 1 \\ & + \sum _ { j = 0 , j \neq N } \, \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & + 1 \{ n \in N \cdot n _ { i } \} ( N ) \nu _ { i } ( 0 ) \sum _ { \gamma \in I ( N , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \\ & = A _ { i } + B _ { i } + C _ { i } , \\ \intertext { where } A _ { i } \text { follows from } j = N _ { i } , \, C _ { i } \text { follows from } j = N \, ( C _ { i } = 0 \text { if } N _ { i } \leq N ) , \, \text { and } B _ { i } \text { consists of all }
```
  FIX: ```
$$
C _ { i } , \, \text {according to the upper cardinality } \, j \colon & \\ & K _ { \sigma } ( Z , \mathcal { D } _ { i } ) = \sum _ { j = 0 } ^ { N _ { i } } \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & = \nu _ { i } ( N - N _ { i } ) Q _ { i } ( \text {id} ) \prod _ { k = 1 } ^ { N _ { i } } p _ { i } ^ { ( k ) } ( \xi _ { k } ) \prod _ { k = N + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & \quad N _ { i } - 1 \\ & + \sum _ { j = 0 , j \neq N } \, \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & + 1 \{ n \in N \cdot n _ { i } \} ( N ) \nu _ { i } ( 0 ) \sum _ { \gamma \in I ( N , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \\ & = A _ { i } + B _ { i } + C _ { i } , \\ \intertext { where } A _ { i } \text { follows from } j = N _ { i } , \, C _ { i } \text { follows from } j = N \, ( C _ { i } = 0 \text { if } N _ { i } \leq N ) , \, \text { and } B _ { i } \text { consists of all }
$$
```
- RAW: ```
\sum _ { j = 0 , j \neq N } ^ { N _ { i } - 1 } \sum _ { \gamma \in I ( j , N _ { i } ) } \left [ \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } p _ { i } ^ { \ell } ( \xi _ { k } ) \right ] .
```
  FIX: ```
$$
\sum _ { j = 0 , j \neq N } ^ { N _ { i } - 1 } \sum _ { \gamma \in I ( j , N _ { i } ) } \left [ \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } p _ { i } ^ { \ell } ( \xi _ { k } ) \right ] .
$$
```
- RAW: ```
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { M _ { i } } q _ { i } ^ { ( \gamma ^ { * } ( k ) ) } p _ { i } ^ { ( \gamma ^ { * } ( k ) ) } ( \xi _ { k } ) \right ] \to f ( \xi _ { 1 } , \dots , \xi _ { m } ) ,
```
  FIX: ```
$$
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { M _ { i } } q _ { i } ^ { ( \gamma ^ { * } ( k ) ) } p _ { i } ^ { ( \gamma ^ { * } ( k ) ) } ( \xi _ { k } ) \right ] \to f ( \xi _ { 1 } , \dots , \xi _ { m } ) ,
$$
```
- RAW: ```
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \right ] \to \int _ { W ^ { m - j } } f ( \xi _ { 1 } , \dots , \xi _ { m } ) d \xi _ { j + 1 } . . . d \xi _ { m } , \quad ( 4 . 1 4 )
```
  FIX: ```
$$
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \right ] \to \int _ { W ^ { m - j } } f ( \xi _ { 1 } , \dots , \xi _ { m } ) d \xi _ { j + 1 } . . . d \xi _ { m } , \quad ( 4 . 1 4 )
$$
```

