[Page 353]

Appendix E

where { a n 0 } and { µ n 0 } are Lagrange multipliers. The corresponding set of KKT conditions are given by

$$
\text { are given by} & & a _ { n } & \geqslant & 0 & & & ( 7 . 2 3 ) \\ & & t _ { n } y ( x _ { n } ) - 1 + \xi _ { n } & \geqslant & 0 & & & & \\ & a _ { n } \left ( t _ { n } y ( x _ { n } ) - 1 + \xi _ { n } \right ) & = & 0 & & & & ( 7 . 2 5 ) \\ & & \mu _ { n } & \geqslant & 0 & & & & ( 7 . 2 6 ) \\ & & \xi _ { n } & \geqslant & 0 & & & & ( 7 . 2 7 ) \\ & & \mu _ { n } \xi _ { n } & = & 0 & & & & ( 7 . 2 8 )
$$

where n = 1 ,...,N .

We now optimize out w , b , and { ξ n } making use of the deﬁnition (7.1) of y ( x ) to give

$$
\frac { \partial L } { \partial w } & = 0 \quad \Rightarrow \quad w = \sum _ { n = 1 } ^ { N } a _ { n } t _ { n } \phi ( x _ { n } ) \\ \partial L & \quad \Rightarrow \quad w = \sum _ { n = 1 } ^ { N } a _ { n } t _ { n } \phi ( x _ { n } )
$$

$$
\frac { \partial L } { \partial b } & = 0 \quad \Rightarrow \quad \sum _ { n = 1 } ^ { N } a _ { n } t _ { n } = 0 \\ \frac { \partial L } { \partial } & = 0 \quad \Rightarrow \quad a _ { n } - C _ { n } - \mu
$$

$$
\frac { \partial L } { \partial \xi _ { n } } = 0 \ \Rightarrow \ a _ { n } = C - \mu _ { n } .
$$

Using these results to eliminate w , b , and { ξ n } from the Lagrangian, we obtain the dual Lagrangian in the form

$$
\widetilde { L } ( a ) & = \sum _ { n = 1 } ^ { N } a _ { n } - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \sum _ { m = 1 } ^ { N } a _ { n } a _ { m } t _ { n } t _ { m } k ( x _ { n } , x _ { m } ) \\ \intertext { h i s identiical to the separable case, except that the constraints are somewhat  }
$$

which is identical to the separable case, except that the constraints are somewhat different. To see what these constraints are, we note that a n 0 is required because these are Lagrange multipliers. Furthermore, (7.31) together with µ n 0 implies a n C . We therefore have to minimize (7.32) with respect to the dual variables { a n } subject to

$$
0 \leqslant a _ { n } \leqslant C \\
$$

$$
\sum _ { n = 1 } ^ { N } a _ { n } t _ { n } = 0 \\ \intertext { e } ( 7 . 3 3 ) \text { are known as horizons } \text { This again represents}
$$

for n = 1 ,...,N , where (7.33) are known as box constraints . This again represents a quadratic programming problem. If we substitute (7.29) into (7.1), we see that predictions for new data points are again made by using (7.13).
