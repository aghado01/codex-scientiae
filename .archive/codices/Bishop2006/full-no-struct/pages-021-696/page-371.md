[Page 371]

# Exercise 7.15

basis vectors ϕ 1 ,..., ϕ M a similar intuition holds, namely that if a particular basis vector is poorly aligned with the data vector t , then it is likely to be pruned from the model.

We now investigate the mechanism for sparsity from a more mathematical perspective, for a general case involving M basis functions. To motivate this analysis we ﬁrst note that, in the result (7.87) for re-estimating the parameter α i , the terms on the right-hand side are themselves also functions of α i . These results therefore represent implicit solutions, and iteration would be required even to determine a single α i with all other α j for j = i ﬁxed.

/negationslash

This suggests a approach to solving the optimization problem for the RVM, in which we make explicit all of the dependence of the marginal likelihood (7.85) on a particular α i and then determine its stationary points explicitly (Faul and Tipping, 2002; Tipping and Faul, 2003). To do this, we ﬁrst pull out the contribution from α i in the matrix C deﬁned by (7.86) to give

$$
\text {in the main} \, \mathbf C \ \, \text {delimited by } & ( 7 . 8 6 ) \, \text {to give} \\ & \quad \text {C} \ \, = \ \, \beta ^ { - 1 } \mathbf I + \sum _ { j \neq i } \alpha _ { j } ^ { - 1 } \varphi _ { j } \varphi _ { j } ^ { \top } + \alpha _ { i } ^ { - 1 } \varphi _ { i } \varphi _ { i } ^ { \top } \\ & \quad = \ \, \text {C} _ { - i } + \alpha _ { i } ^ { - 1 } \varphi _ { i } \varphi _ { i } ^ { \top } \\ \text {,} \, \text {donotes the } \, \mathbf h ^ { i } \, \text {column of } \, \mathbf D _ { j } \, \text { in other words the } \, \mathbf N \, \text { dimensional vector with}
$$

/negationslash

where ϕ i denotes the i th column of Φ , in other words the N -dimensional vector with elements ( φ i ( x 1 ) ,...,φ i ( x N )) , in contrast to φ n , which denotes the n th row of Φ . The matrix C − i represents the matrix C with the contribution from basis function i removed. Using the matrix identities (C.7) and (C.15), the determinant and inverse of C can then be written

$$
| C | \ = \ | C _ { - i } | | 1 + \alpha _ { i } ^ { - 1 } \varphi _ { i } ^ { \top } C _ { - i } ^ { - 1 } \varphi _ { i } | \\ C ^ { - 1 } \varphi _ { i } \circledast C ^ { \top } C ^ { - 1 } _ { - i }
$$

$$
| \, | & & | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \, | \, | & & | \, | \
$$

Using these results, we can then write the log marginal likelihood function (7.85) in the form

$$
L ( \alpha ) & = L ( \alpha _ { - i } ) + \lambda ( \alpha _ { i } ) & & ( 7 . 9 6 ) \\ \\
$$

where L ( α − i ) is simply the log marginal likelihood with basis function ϕ i omitted, and the quantity λ ( α i ) is deﬁned by

$$
\text {Quantity} \ \lambda ( \alpha _ { i } ) \, \text {is defined by} \\ \lambda ( \alpha _ { i } ) = \frac { 1 } { 2 } \left [ \ln \alpha _ { i } - \ln \left ( \alpha _ { i } + s _ { i } \right ) + \frac { q _ { i } ^ { 2 } } { \alpha _ { i } + s _ { i } } \right ] \\ \text {taking all the constants}
$$

and contains all of the dependence on α i . Here we have introduced the two quantities

$$
s _ { i } \ = \ \varphi _ { i } ^ { \top } C _ { - i } ^ { - 1 } \varphi _ { i } & & ( 7 . 9 8 ) \\ & & \\ s _ { i } \ = \ \varphi _ { i } ^ { \top } C _ { - i } ^ { - 1 } \mathfrak { t } & & ( 7 . 9 0 )
$$

$$
q _ { i } \ = \ \varphi _ { i } ^ { T } C _ { - i } ^ { - 1 } \mathbf t .
$$

Here s i is called the sparsity and q i is known as the quality of ϕ i , and as we shall see, a large value of s i relative to the value of q i means that the basis function ϕ i is more likely to be pruned from the model. The 'sparsity' measures the extent to which basis function ϕ i overlaps with the other basis vectors in the model, and the 'quality' represents a measure of the alignment of the basis vector ϕ n with the error between the training set values t = ( t 1 , . . . , t N ) T and the vector y -i of predictions that would result from the model with the vector ϕ i excluded (Tipping and Faul, 2003).
