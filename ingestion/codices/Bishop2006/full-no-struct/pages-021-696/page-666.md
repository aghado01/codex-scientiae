[Page 666]

straightforward since, again using Bayes’ theorem

$$
\text {straight forward since, again using Bayes' theorem} \\ p ( z _ { n + 1 } | X _ { n } ) \ = \ \int p ( z _ { n + 1 } | z _ { n } , X _ { n } ) p ( z _ { n } | X _ { n } ) \, d z _ { n } \\ \ = \ \int p ( z _ { n + 1 } | z _ { n } ) p ( z _ { n } | X _ { n } ) \, d z _ { n } \\ \ = \ \int p ( z _ { n + 1 } | z _ { n } ) p ( z _ { n } | x _ { n } , X _ { n - 1 } ) \, d z _ { n } \\ \ = \ \frac { \int p ( z _ { n + 1 } | z _ { n } ) p ( x _ { n } | z _ { n } ) p ( z _ { n } | X _ { n - 1 } ) \, d z _ { n } } { \int p ( x _ { n } | z _ { n } ) p ( z _ { n } | X _ { n - 1 } ) \, d z _ { n } } \\ \ = \ \sum _ { l } w _ { n } ^ { ( l ) } p ( z _ { n + 1 } | z _ { n } ^ { ( l ) } ) \\ \text {where we have made use of the conditional independence properties} \\ p ( z _ { n + 1 } | z _ { n } ; X _ { n } ) \ = \ p ( z _ { n + 1 } | z _ { n } ) \quad ( 1 3 . 1 2 0 )
$$

where we have made use of the conditional independence properties

$$
p ( z _ { n + 1 } | z _ { n } , X _ { n } ) \ & = \ p ( z _ { n + 1 } | z _ { n } ) \\ p ( x \ | z _ { n } , X _ { n } ) \ & = \ p ( x \ | z _ { n } )
$$

$$
\ p ( x _ { n } | z _ { n } , X _ { n - 1 } ) \ = \ p ( x _ { n } | z _ { n } )
$$

which follow from the application of the d-separation criterion to the graph in Figure 13.5. The distribution given by (13.119) is a mixture distribution, and samples can be drawn by choosing a component l with probability given by the mixing coefﬁcients w ( l ) and then drawing a sample from the corresponding component.

In summary, we can view each step of the particle ﬁlter algorithm as comprising two stages. At time step n , we have a sample representation of the posterior distribution p ( z n | X n ) expressed as samples { z ( l ) n } with corresponding weights { w ( l ) n } . This can be viewed as a mixture representation of the form (13.119). To obtain the corresponding representation for the next time step, we ﬁrst draw L samples from the mixture distribution (13.119), and then for each sample we use the new observation x n +1 to evaluate the corresponding weights w ( l ) n +1 ∝ p ( x n +1 | z ( l ) n +1 ) . This is illustrated, for the case of a single variable z , in Figure 13.23.

The particle ﬁltering, or sequential Monte Carlo, approach has appeared in the literature under various names including the bootstrap ﬁlter (Gordon et al. , 1993), survival of the ﬁttest (Kanazawa et al. , 1995), and the condensation algorithm (Isard and Blake, 1998).

# Exercises

13.1 ( ) www Use the technique of d-separation, discussed in Section 8.2, to verify that the Markov model shown in Figure 13.3 having N nodes in total satisﬁes the conditional independence properties (13.3) for n = 2 ,...,N . Similarly, show that a model described by the graph in Figure 13.4 in which there are N nodes in total
