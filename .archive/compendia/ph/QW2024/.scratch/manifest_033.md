# Manifest: Page 033

## REPAIR_MATH
- RAW: ```
\frac { w ( \sigma ) } { w ( d _ { i } \sigma ) } \frac { w ( d _ { i } \sigma ) } { w ( d _ { j - 1 } d _ { i } \sigma ) } = \frac { w ( \sigma ) } { w ( d _ { j } \sigma ) } \frac { w ( d _ { j } \sigma ) } { w ( d _ { i } d _ { j } \sigma ) }
```
  FIX: ```
$$
\frac { w ( \sigma ) } { w ( d _ { i } \sigma ) } \frac { w ( d _ { i } \sigma ) } { w ( d _ { j - 1 } d _ { i } \sigma ) } = \frac { w ( \sigma ) } { w ( d _ { j } \sigma ) } \frac { w ( d _ { j } \sigma ) } { w ( d _ { i } d _ { j } \sigma ) }
$$
```
- RAW: ```
\phi ( d _ { i } \sigma , d _ { j - 1 } d _ { i } \sigma ) \phi ( \sigma , d _ { i } \sigma ) = \phi ( d _ { j } \sigma , d _ { i } d _ { j } \sigma ) \phi ( \sigma , d _ { j } \sigma ) ,
```
  FIX: ```
$$
\phi ( d _ { i } \sigma , d _ { j - 1 } d _ { i } \sigma ) \phi ( \sigma , d _ { i } \sigma ) = \phi ( d _ { j } \sigma , d _ { i } d _ { j } \sigma ) \phi ( \sigma , d _ { j } \sigma ) ,
$$
```
- RAW: ```
\partial _ { q } \sigma = \sum _ { i = 0 } ^ { q } ( - 1 ) ^ { i } \phi ( \sigma , d _ { i } \sigma ) d _ { i } \sigma .
```
  FIX: ```
$$
\partial _ { q } \sigma = \sum _ { i = 0 } ^ { q } ( - 1 ) ^ { i } \phi ( \sigma , d _ { i } \sigma ) d _ { i } \sigma .
$$
```
- RAW: ```
\begin{pmatrix} v _ { 0 } v _ { 1 } & v _ { 0 } v _ { 4 } & v _ { 1 } v _ { 2 } & v _ { 2 } v _ { 3 } & v _ { 3 } v _ { 4 } \\ \\ v _ { 0 } & - \alpha _ { 0 } & - \alpha _ { 0 } & 0 & 0 & 0 \\ \\ v _ { 1 } & \alpha _ { 1 } & 0 & - \alpha _ { 1 } & 0 & 0 \\ \\ v _ { 2 } & 0 & 0 & \alpha _ { 2 } & - \alpha _ { 2 } & 0 \\ \\ v _ { 3 } & 0 & 0 & 0 & \alpha _ { 3 } & - \alpha _ { 3 } \\ \\ v _ { 4 } & 0 & \alpha _ { 4 } & 0 & 0 & \alpha _ { 4 } \end{pmatrix}
```
  FIX: ```
$$
\begin{pmatrix} v _ { 0 } v _ { 1 } & v _ { 0 } v _ { 4 } & v _ { 1 } v _ { 2 } & v _ { 2 } v _ { 3 } & v _ { 3 } v _ { 4 } \\ \\ v _ { 0 } & - \alpha _ { 0 } & - \alpha _ { 0 } & 0 & 0 & 0 \\ \\ v _ { 1 } & \alpha _ { 1 } & 0 & - \alpha _ { 1 } & 0 & 0 \\ \\ v _ { 2 } & 0 & 0 & \alpha _ { 2 } & - \alpha _ { 2 } & 0 \\ \\ v _ { 3 } & 0 & 0 & 0 & \alpha _ { 3 } & - \alpha _ { 3 } \\ \\ v _ { 4 } & 0 & \alpha _ { 4 } & 0 & 0 & \alpha _ { 4 } \end{pmatrix}
$$
```

