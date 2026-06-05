[Page 274]

- 2. Both weights in the ﬁrst layer: ∂2En

∂wji(1)∂wj(1) i

= xixi h (aj )Ijj

k

wkj(2) δk

+xixi h (aj )h (aj)

k k

wk(2) j wkj(2)Mkk . (5.94)

- 3. One weight in each layer:


∂2En ∂wji(1)∂wkj(2)

= xih (aj ) δkIjj + zj

k

wk(2) j Hkk . (5.95)

Here Ijj is the j,j element of the identity matrix. If one or both of the weights is a bias term, then the corresponding expressions are obtained simply by setting the

- Exercise 5.23 appropriate activation(s) to 1. Inclusion of skip-layer connections is straightforward.


###### 5.4.6 Fast multiplication by the Hessian

For many applications of the Hessian, the quantity of interest is not the Hessian matrix H itself but the product of H with some vector v. We have seen that the evaluation of the Hessian takes O(W2) operations, and it also requires storage that is O(W2). The vector vTH that we wish to calculate, however, has only W elements, so instead of computing the Hessian as an intermediate step, we can instead try to ﬁnd an efﬁcient approach to evaluating vTH directly in a way that requires only O(W) operations.

To do this, we ﬁrst note that

vTH = vT∇(∇E) (5.96)

where ∇ denotes the gradient operator in weight space. We can then write down the standard forward-propagation and backpropagation equations for the evaluation of ∇E and apply (5.96) to these equations to give a set of forward-propagation and backpropagation equations for the evaluation of vTH (Møller, 1993; Pearlmutter, 1994). This corresponds to acting on the original forward-propagation and backpropagation equations with a differential operator vT∇. Pearlmutter (1994) used the notation R{·} to denote the operator vT∇, and we shall follow this convention. The analysis is straightforward and makes use of the usual rules of differential calculus, together with the result

R{w} = v. (5.97)

The technique is best illustrated with a simple example, and again we choose a two-layer network of the form shown in Figure 5.1, with linear output units and a sum-of-squares error function. As before, we consider the contribution to the error function from one pattern in the data set. The required vector is then obtained as
