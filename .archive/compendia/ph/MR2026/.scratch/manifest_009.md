# Manifest: Page 009

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
The degree r spans from zero to one; when r = 1 all the oscillators are in phase.```
  FIX: ```
The degree \( r \) spans from zero to one; when \( r = 1 \) all the oscillators are in phase.```
- RAW: ```
Complete synchronization can be reached only for certain values of K that are greater than a critical value K c .```
  FIX: ```
Complete synchronization can be reached only for certain values of \( K \) that are greater than a critical value \( K_c \).```
- RAW: ```
between two different time regime T 1 = [0 , 250) and T 2 = [250 , 500] .```
  FIX: ```
between two different time regimes \( T_1 = [0, 250) \) and \( T_2 = [250, 500] \).```
- RAW: ```
They used 128 oscillators connected through a given adjacency matrix G i,j .```
  FIX: ```
They used 128 oscillators connected through a given adjacency matrix \( G_{i,j} \).```
- RAW: ```
At each simulation they selected the initial conditions, which are the frequency and the phase for each oscillator, and integrated the system between t 0 = 0 and t max = 10 with 500 time steps.```
  FIX: ```
At each simulation they selected the initial conditions, which are the frequency and the phase for each oscillator, and integrated the system between \( t_0 = 0 \) and \( t_{\max} = 10 \) with 500 time steps.```
- RAW: ```
At the end of all the simulations they built a function network by computing the pairwise synchronicity coeﬀicient between two oscillators, defined as follows:```
  FIX: ```
At the end of all the simulations they built a function network by computing the pairwise synchronicity coefficient between two oscillators, defined as follows:```

## REPAIR_MATH
- RAW: ```
$$
\text {venient measure of the degree of synchrocity is defined} \\ r = \frac { 1 } { N } \sqrt { ( \sum _ { j = 1 } ^ { N } \cos ( \theta _ { j } ) ) ^ { 2 } + ( \sum _ { j = 1 } ^ { N } \sin ( \theta _ { j } ) ) ^ { 2 } ) } \\ \text {from zero to one; when } r = 1 \text { all the oscillators are}
$$```
  FIX: ```
\[
r = \frac{1}{N} \sqrt{\left(\sum_{j=1}^N \cos(\theta_j)\right)^2 + \left(\sum_{j=1}^N \sin(\theta_j)\right)^2}
\]```
- RAW: ```
$$
\begin{array} { r } { \beta \text {between two oscillators} , \text { defined} } \\ { \phi _ { i , j } ^ { T _ { k } } = \langle | \cos \left ( \theta _ { i } ^ { k } - \theta _ { j } ^ { k } \right ) | \rangle } \end{array}
$$```
  FIX: ```
\[
\phi_{i,j}^{T_k} = \langle | \cos\left( \theta_i^k - \theta_j^k \right) | \rangle
\]```
