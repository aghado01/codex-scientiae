[Page 373]

- 3. Evaluate Σ and m , along with q i and s i for all basis functions.
- 4. Select a candidate basis function ϕ i .
- 5. If q 2 i > s i , and α i < ∞ , so that the basis vector ϕ i is already included in the model, then update α i using (7.101).
- 6. If q 2 i > s i , and α i = ∞ , then add ϕ i to the model, and evaluate hyperparameter α i using (7.101).
- 7. If q 2 i s i , and α i < ∞ then remove basis function ϕ i from the model, and set α i = ∞ . 8. If solving a regression problem, update β .

If solving a regression problem, update β .

9. If converged terminate, otherwise go to 3.

Note that if q 2 i s i and α i = ∞ , then the basis function ϕ i is already excluded from the model and no action is required.

In practice, it is convenient to evaluate the quantities

$$
Q _ { i } \ = \ \varphi _ { i } ^ { T } C ^ { - 1 } \mathfrak { t }
$$

$$
S _ { i } \ = \ \varphi _ { i } ^ { \top } C ^ { - 1 } \varphi _ { i } .
$$

The quality and sparseness variables can then be expressed in the form

$$
q _ { i } \ = \ \frac { \alpha _ { i } Q _ { i } } { \alpha _ { i } - S _ { i } } & & ( 7 . 1 0 4 ) \\ & & \alpha _ { i } S _ { i }
$$

$$
s _ { i } \ = \ \frac { \alpha _ { i } S _ { i } } { \alpha _ { i } - S _ { i } } . \\ \intertext { s u h e v e s } \ w h e v e \ s _ { i } \ O _ { i } \ a n d \ s _ { i } \ S _ { i } \ U l i n \ ( C \, 7 ) \ w a n d \ w u n t i o n
$$

i ∞ i i i i Exercise 7.17

Note that when α = , we have q = Q and s = S . Using (C.7), we can write

$$
Q _ { i } \ & = \ \beta \varphi _ { i } ^ { T } t - \beta ^ { 2 } \varphi _ { i } ^ { T } \Phi \Sigma \Phi ^ { T } t \\ S _ { i } \ & = \ \beta ( \varrho _ { i } ^ { T } ( \varrho _ { i } - \beta ^ { 2 } ( \varrho _ { i } ^ { T } \Phi \Sigma \Phi ^ { T } ) \varrho _ { i } \\
$$

$$
S _ { i } \ = \ \beta \varphi _ { i } ^ { T } \varphi _ { i } - \beta ^ { 2 } \varphi _ { i } ^ { T } \Phi \Sigma \Phi ^ { T } \varphi _ { i }
$$

where Φ and Σ involve only those basis vectors that correspond to ﬁnite hyperparameters α i . At each stage the required computations therefore scale like O ( M 3 ) , where M is the number of active basis vectors in the model and is typically much smaller than the number N of training patterns.

# 7.2.3 RVM for classiﬁcation

We can extend the relevance vector machine framework to classiﬁcation problems by applying the ARD prior over weights to a probabilistic linear classiﬁcation model of the kind studied in Chapter 4. To start with, we consider two-class problems with a binary target variable t ∈ { 0 , 1 } . The model now takes the form of a linear combination of basis functions transformed by a logistic sigmoid function

$$
y ( x , w ) = \sigma \left ( w ^ { T } \phi ( x ) \right )
$$
