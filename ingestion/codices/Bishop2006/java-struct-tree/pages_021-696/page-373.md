[Page 373]

3. Evaluate Σ and m, along with qi and si for all basis functions.

4. Select a candidate basis function ϕi.

5. If qi2 > si, and αi < ∞, so that the basis vector ϕi is already included in the model, then update αi using (7.101).

6. If qi2 > si, and αi = ∞, then add ϕi to the model, and evaluate hyperparameter αi using (7.101).

7. If qi2 � si, and αi < ∞ then remove basis function ϕi from the model, and set αi = ∞.

8. If solving a regression problem, update β. 9. If converged terminate, otherwise go to 3.

Note that if qi2 � si and αi = ∞, then the basis function ϕi is already excluded from the model and no action is required.

In practice, it is convenient to evaluate the quantities

Qi = ϕTi C−1t (7.102) Si = ϕTi C−1ϕi. (7.103)

The quality and sparseness variables can then be expressed in the form

αiQi αi − Si

qi =

(7.104)

αiSi αi − Si

si =

. (7.105)

Exercise 7.17 Note that when αi = ∞, we have qi = Qi and si = Si. Using (C.7), we can write

Qi = βϕTi t − β2ϕTi ΦΣΦTt (7.106) Si = βϕTi ϕi − β2ϕTi ΦΣΦTϕi (7.107)

where Φ and Σ involve only those basis vectors that correspond to ﬁnite hyperparameters αi. At each stage the required computations therefore scale like O(M3), where M is the number of active basis vectors in the model and is typically much smaller than the number N of training patterns.

7.2.3 RVM for classiﬁcation

We can extend the relevance vector machine framework to classiﬁcation problems by applying the ARD prior over weights to a probabilistic linear classiﬁcation model of the kind studied in Chapter 4. To start with, we consider two-class problems with a binary target variable t ∈ {0,1}. The model now takes the form of a linear combination of basis functions transformed by a logistic sigmoid function

�

�

y(x,w) = σ

wTφ(x)

(7.108)
