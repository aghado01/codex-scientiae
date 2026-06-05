[Page 723]

# Appendix D. Calculus of Variations

We can think of a function y ( x ) as being an operator that, for any input value x , returns an output value y . In the same way, we can deﬁne a functional F [ y ] to be an operator that takes a function y ( x ) and returns an output value F . An example of a functional is the length of a curve drawn in a two-dimensional plane in which the path of the curve is deﬁned in terms of a function. In the context of machine learning, a widely used functional is the entropy H[ x ] for a continuous variable x because, for any choice of probability density function p ( x ) , it returns a scalar value representing the entropy of x under that density. Thus the entropy of p ( x ) could equally well have been written as H[ p ] .

A common problem in conventional calculus is to ﬁnd a value of x that maximizes (or minimizes) a function y ( x ) . Similarly, in the calculus of variations we seek a function y ( x ) that maximizes (or minimizes) a functional F [ y ] . That is, of all possible functions y ( x ) , we wish to ﬁnd the particular function for which the functional F [ y ] is a maximum (or minimum). The calculus of variations can be used, for instance, to show that the shortest path between two points is a straight line or that the maximum entropy distribution is a Gaussian.

If we weren’t familiar with the rules of ordinary calculus, we could evaluate a conventional derivative d y/ d x by making a small change to the variable x and then expanding in powers of , so that

$$
y ( x + \epsilon ) = y ( x ) + \frac { d y } { d x } \epsilon + O ( \epsilon ^ { 2 } )
$$

and ﬁnally taking the limit → 0 . Similarly, for a function of several variables y ( x 1 ,...,x D ) , the corresponding partial derivatives are deﬁned by

$$
y ( x _ { 1 } + \epsilon _ { 1 } , \dots , x _ { D } + \epsilon _ { D } ) = y ( x _ { 1 } , \dots , x _ { D } ) + \sum _ { i = 1 } ^ { D } \frac { \partial y } { \partial x _ { i } } \epsilon _ { i } + O ( \epsilon ^ { 2 } ) . \quad ( D . 2 ) \\ \intertext { The analogous definition of a functional derivative arises when we consider how }
$$

The analogous definition of a functional derivative arises when we consider how much a functional F [ y ] changes when we make a small change /epsilon1η ( x ) to the function y ( x ) , where η ( x ) is an arbitrary function of x , as illustrated in Figure D.1. We denote the functional derivative of E [ f ] with respect to f ( x ) by δF/δf ( x ) , and define it by the following relation:
