
![The image is a scatter plot with a categorical scale starting at 2 and ending at 8 on the x-axis, labeled number of weeks. The y-axis is labeled . The plot is labeled as . The category is represented by a dashed line. The dashed line is positioned at the bottom of the graph, indicating that the data points are likely to be the same for both categories. The x-axis is labeled number of weeks, and the y-axis is labeled , and the y-axis is labeled Figure 2.1: Lines connecting points belonging to the same pig.

$$
\ w e i g h t _ { i j } = \beta _ { 0 } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j } , \quad 1 \leq i \leq 4 8 , \quad 1 \leq j \leq 9 ,
$$

where the $\epsilon_{ij}$ are independent and identically distributed random variables (i.i.d) from $N(0, \sigma^2)$. However, model (2.6) does not account for the within-pig correlation of weight measurements. One solution to this drawback is to add an individual intercept $\alpha_i$ , for each pig i so that,

$$
\ w e i g h t _ { i j } = \alpha _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j } .
$$

Adding this extra parameter to each individual pig improves the estimate of the slope $\beta_1$ , but the practicality of model (2.7) is reduced, due to the large number of parameters. In addition, too much credence is placed on this random sample of pigs. We need to take into account the fact that this sample is only a subset of a broader population. A solution is to add to (2.6) random intercepts, $b_1, \dots, b_{48}$ ,
