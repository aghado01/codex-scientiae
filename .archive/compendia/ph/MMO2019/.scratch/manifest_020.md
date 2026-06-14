# Manifest: Page 020

## REPAIR_MATH
- RAW: ```
\mathbb { E } ( | \Delta _ { 0 } ^ { \sigma } \cap D | ) = \int _ { W } \kappa _ { \Delta _ { 0 } ^ { \sigma } } ( Z ) f ( Z ) \delta Z = \sum _ { N = 0 } ^ { M } \frac { N } { N ! } \int _ { W } 1 _ { \Delta _ { 0 } ^ { \sigma } } ( \xi _ { 1 } ) \left [ \int f ( \xi _ { 1 } , \dots \xi _ { N } ) d \xi _ { 2 } \dots d \xi _ { N } \right ] d \xi _ { 1 } \quad ( 4 . 1 0 )
```
  FIX: ```
$$
\mathbb { E } ( | \Delta _ { 0 } ^ { \sigma } \cap D | ) = \int _ { W } \kappa _ { \Delta _ { 0 } ^ { \sigma } } ( Z ) f ( Z ) \delta Z = \sum _ { N = 0 } ^ { M } \frac { N } { N ! } \int _ { W } 1 _ { \Delta _ { 0 } ^ { \sigma } } ( \xi _ { 1 } ) \left [ \int f ( \xi _ { 1 } , \dots \xi _ { N } ) d \xi _ { 2 } \dots d \xi _ { N } \right ] d \xi _ { 1 } \quad ( 4 . 1 0 )
$$
```
- RAW: ```
\int _ { \Delta _ { 0 } ^ { \sigma } } F _ { D } ( \xi ) d \xi & \leq \int _ { 0 } ^ { L } \int _ { y - \sigma } ^ { y } F _ { D } ( x , y ) \, d x \, d y + \int _ { L } ^ { \infty } \int _ { y - \sigma } ^ { y } C _ { 3 } y ^ { - 2 } \, d x \, d y \\ & \leq L C _ { 2 } \sigma + 3 C _ { 3 } \sigma / L = ( L C _ { 2 } + C _ { 3 } / L ) \sigma
```
  FIX: ```
$$
\int _ { \Delta _ { 0 } ^ { \sigma } } F _ { D } ( \xi ) d \xi & \leq \int _ { 0 } ^ { L } \int _ { y - \sigma } ^ { y } F _ { D } ( x , y ) \, d x \, d y + \int _ { L } ^ { \infty } \int _ { y - \sigma } ^ { y } C _ { 3 } y ^ { - 2 } \, d x \, d y \\ & \leq L C _ { 2 } \sigma + 3 C _ { 3 } \sigma / L = ( L C _ { 2 } + C _ { 3 } / L ) \sigma
$$
```
- RAW: ```
\mathbb { E } ( a ) = \sum _ { j = 0 } ^ { \infty } j \nu ( j ) = \sum _ { j = 1 } ^ { \infty } j \nu ( j ) \geq \sum _ { j = 1 } ^ { \infty } \nu ( j ) \geq \nu ( j _ { 0 } )
```
  FIX: ```
$$
\mathbb { E } ( a ) = \sum _ { j = 0 } ^ { \infty } j \nu ( j ) = \sum _ { j = 1 } ^ { \infty } j \nu ( j ) \geq \sum _ { j = 1 } ^ { \infty } \nu ( j ) \geq \nu ( j _ { 0 } )
$$
```

