[Page 9]

**Step 1:** Propose with equal probability either to add, alter or remove a basis function. If $k = 1$ in the current model, then we cannot remove or change a basis, so we choose either to add a basis function or to skip to step 2 and redraw the parameters for the intercept basis.

**ADD:** Generate a new basis function as follows: Draw the interaction level of the basis uniformly from $(1, \ldots, p-1)$ and randomly select the corresponding number of covariates. Set basis parameters for all other covariates equal to zero. Sample selected basis function parameters from $N(0, 1)$, then normalize to get $(\mu_{l1}, \ldots, \mu_{lp})$, the non-intercept basis parameters. Randomly select one data point, $y_{ij}$, and let $\mu_{l0} = x_{ij,-1}'\mu_{l,-1}$. Add the new basis function to the proposed model.

**ALTER:** Randomly select a basis in the current model. Generate a new basis function as described above. Replace the selected basis function with the new one.

**REMOVE:** Randomly select a basis in the current model. Delete the selected basis from the proposed model.

**Step 2:** Accept the proposed model with appropriate probability (described below).

**Step 3:** If a proposal to add or remove has been accepted, the dimension of the model has changed. In order to update the parameters from their full conditionals, all vector parameters must have dimension $k^*$ of the new model. It suffices to adjust the dimension of $\beta$ and $\delta$, as we can then sample $\{b_i\}$ from the full conditionals. If we have added a basis, initialize $\beta_{k^*}$, the new element of $\beta$, to a pre-determined initial value and initialize $\delta_{k^*}$ to the mean of $\delta$ from the previous model. If a basis has been removed, delete the corresponding elements of $\beta$ and $\delta$.
