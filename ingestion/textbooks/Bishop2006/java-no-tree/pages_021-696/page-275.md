[Page 275]

usual by summing over the contributions from each of the patterns separately. For the two-layer network, the forward-propagation equations are given by

aj =

wjixi (5.98)

i

zj = h(aj) (5.99) yk =

wkjzj. (5.100)

j

We now act on these equations using the R{·} operator to obtain a set of forward propagation equations in the form

R{aj} =

vjixi (5.101)

i

R{zj} = h (aj)R{aj} (5.102) R{yk} =

wkjR{zj} +

vkjzj (5.103)

j

j

where vji is the element of the vector v that corresponds to the weight wji. Quantities of the form R{zj}, R{aj} and R{yk} are to be regarded as new variables whose values are found using the above equations.

Because we are considering a sum-of-squares error function, we have the following standard backpropagation expressions:

δk = yk − tk (5.104) δj = h (aj)

wkjδk. (5.105)

k

Again, we act on these equations with the R{·} operator to obtain a set of backpropagation equations in the form

R{δk} = R{yk} (5.106) R{δj} = h (aj)R{aj}

wkjδk

k

###### + h (aj)

vkjδk + h (aj)

wkjR{δk}. (5.107)

k

k

Finally, we have the usual equations for the ﬁrst derivatives of the error

∂E ∂wkj

= δkzj (5.108) ∂E ∂wji

= δjxi (5.109)
