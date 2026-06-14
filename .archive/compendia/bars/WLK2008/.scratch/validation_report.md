# Validation Report — WLK2008

> **59 issue(s)** across 8 page file(s). Address in page slices before running assemble_pages.py.

## page_002.md

- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Consider the problem of making inferences about a function \( f(t) \),
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …with \( f \) being a linear combination of splines having unknown sets

## page_003.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\([A, B]\) can be difficult in some problems due to spline boundary co
- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Key features of the MCMC implementation of BARS include (i) a reversib
- Line 10: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[ \tag{2} \]
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …(where \(y = (y_1, \ldots, y_n)\)), the integration being performed ex
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The essential idea of using reversible-jump MCMC to select knots was s
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …For each draw \(\xi^{(g)}\) from the posterior distribution of \(\xi\)

## page_004.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …From we obtain fitted values for selected and these, in turn, may be u
- Line 9: Alternate math delimiter \[ \] or \( \) — use $ or $$: …being a vector of fits along a grid that suitably covers the interval 
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …maximum of \( f(t) \) is obtained by finding the location of the maxim
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Our ability to use Kooperberg’s implementation for density estimation 
- Line 29: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Here the number of events \( N \) is a Poisson random variable with ex
- Line 33: Unclosed $$ display-math block (no matching closing $$)

## page_005.md

- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …then it becomes clear that estimation of \( \lambda(t) \) amounts to e
- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …We describe below the code and wrappers for the Poisson versions. The 
- Line 20: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 4. Run MCMC. For \( g = 1, \dots, G_b \), where \( G_b \) is the num
- Line 23: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- a. Take knot step: addition, deletion, or relocation. This produces 
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- c. Generate \( \beta^{(g)} \).
- Line 26: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- d. Using \( \beta^{(g)} \), obtain fits and also BIC, loglikelihood,

## page_012.md

- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …In the following, a model \( M^* \) contains information for an indivi
- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( k^* \), the number of interior knots
- Line 8: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( \xi^* \), the set of interior knots
- Line 9: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( X_{D,*} \), the design basis, and \( X_{G,*} \), the grid basis. 
- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( \beta^* \sim \pi(\beta | k^*, \xi^*, \text{Data}) \)
- Line 12: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( \mu_{D,*} = \exp(X_D \beta^*) \)
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- \( \mu_{G,*} = \exp(X_G \beta^*) \)
- Line 14: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- The BIC and log likelihood for the full model with parameters \( (k^
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Declare models \( M_{\text{curr}} \), \( M_{\text{cand}} \), and \( 
- Line 18: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Set initial knots in \( M_{\text{curr}} \). The initial knots may be
- Line 19: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Calculate birth and death probabilities for each possible value of \
- Line 30: Alternate math delimiter \[ \] or \( \) — use $ or $$: …birth probability = \( c \min(1, \pi(k + 1)/\pi(k)) \)
- Line 40: Alternate math delimiter \[ \] or \( \) — use $ or $$: …death probability = \( c \min(1, \pi(k - 1)/\pi(k)) \)
- Line 44: Alternate math delimiter \[ \] or \( \) — use $ or $$: …probability of knot relocation is \( 1 - (\text{birth probability} + \
- Line 46: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Define \( \mu^{(0)} \), used to start each iterative fitting process
- Line 47: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- for \( i \leftarrow 0 \) to \( (n - 1) \)

## page_014.md

- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …, \( curr \) ).

## page_015.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 9: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 27: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 29: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 63: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 68: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]

## page_016.md

- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( H \leftarrow WX \) . comment: Use known diagonal structure of \( W 
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( U \leftarrow \) Upper triangular matrix from the Cholesky decomposi
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \text{error} \leftarrow \text{true} \)
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \text{exit} \leftarrow \text{true} \)
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \hat{\beta} \leftarrow \) Solution to \( J\beta = H^\top z \) . com
- Line 23: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \text{error} \leftarrow \text{true} \)
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \text{exit} \leftarrow \text{true} \)
- Line 45: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- until ( \( \text{exit} \) )
- Line 51: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Generates \( \beta \) posterior distribution \( \pi ( \beta | k , \x
- Line 52: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- Let \( \pi^* \) denote the density for the normal approximation. Not
- Line 56: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( \hat{\beta} \) , the MLE of \( \beta \) .
- Line 58: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( U \) , a \( p \times p \) upper triangular matrix that contains inf
- Line 60: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( MHI \) , the number of Metropolis-Hastings iterations. This is a us
- Line 62: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( MHT \) , the threshhold used to determine whether (a) the initial \
