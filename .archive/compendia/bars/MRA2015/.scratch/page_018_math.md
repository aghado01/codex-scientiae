[Page 18]



weight







number of weeks

Figure 2.1: Lines connecting points belonging to the same pig.

$$
\ w e i g h t _ { i j } = \beta _ { 0 } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j }, \quad 1 \leq i \leq 4 8, \quad 1 \leq j \leq 9,
$$

where the ij are independent and identically distributed random variables (i.i.d) from N (0,σ 2 ). However, model (2.6) does not account for the within-pig correlation of weight measurements. One solution to this drawback is to add an individual intercept α i, for each pig i so that,

$$
\ w e i g h t _ { i j } = \alpha _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j } .
$$

Adding this extra parameter to each individual pig improves the estimate of the slope β 1, but the practicality of model (2.7) is reduced, due to the large number of parameters. In addition, too much credence is placed on this random sample of pigs. We need to take into account the fact that this sample is only a subset of a broader population. A solution is to add to (2.6) random intercepts, b 1,..., b 48,
