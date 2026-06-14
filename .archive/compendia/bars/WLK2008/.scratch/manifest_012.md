# Manifest: Page 012

## REPAIR_PROSE
- RAW: ```
userdefined
```
  FIX: ```
user-defined
```

## REPAIR_MATH
- RAW: ```
\text {if } ( k > = \max \text {KNOTS} )
```
  FIX: ```
$$
\text {if } ( k > = \max \text {KNOTS} )
$$
```
- RAW: ```
{ \mathbf i } ( k < = 1 )
```
  FIX: ```
$$
{ \mathbf i } ( k < = 1 )
$$
```
- RAW: ```
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0 . 1 , y _ { i } \right )
```
  FIX: ```
$$
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0 . 1 , y _ { i } \right )
$$
```
- RAW: ```
In the following, a model M * contains information
```
  FIX: ```
In the following, a model \( M^* \) contains information
```
- RAW: ```
- k * , the number of interior knots
- ξ * , the set of interior knots
- X D ,* , the design basis, and X G ,* , the grid basis.
```
  FIX: ```
- \( k^* \), the number of interior knots
- \( \xi^* \), the set of interior knots
- \( X_{D,*} \), the design basis, and \( X_{G,*} \), the grid basis.
```
- RAW: ```
- β *   ∼ π ( β | k * , ξ * , Data )
- μ D ,* = exp ( X D β * )
- μ G,* = exp ( X G β * )
- The BIC and log likelihood for the full model with parameters ( k * , ξ * , β * ).
```
  FIX: ```
- \( \beta^* \sim \pi(\beta | k^*, \xi^*, \text{Data}) \)
- \( \mu_{D,*} = \exp(X_D \beta^*) \)
- \( \mu_{G,*} = \exp(X_G \beta^*) \)
- The BIC and log likelihood for the full model with parameters \( (k^*, \xi^*, \beta^*) \).
```
- RAW: ```
- Declare models M curr , M cand , and M temp .
- Set initial knots in M curr .
```
  FIX: ```
- Declare models \( M_{\text{curr}} \), \( M_{\text{cand}} \), and \( M_{\text{temp}} \).
- Set initial knots in \( M_{\text{curr}} \).
```
- RAW: ```
- Calculate birth and death probabilities for each possible value of k , using
```
  FIX: ```
- Calculate birth and death probabilities for each possible value of \( k \), using
```
- RAW: ```
birth probability = c min (1, π ( k + 1)/ π ( k ))
```
  FIX: ```
birth probability = \( c \min(1, \pi(k + 1)/\pi(k)) \)
```
- RAW: ```
death probability = c min (1, π ( k 1)/ π ( k ))
```
  FIX: ```
death probability = \( c \min(1, \pi(k - 1)/\pi(k)) \)
```
- RAW: ```
probability of knot relocation is 1 ( birth probability + death probability ).
```
  FIX: ```
probability of knot relocation is \( 1 - (\text{birth probability} + \text{death probability}) \).
```
- RAW: ```
- Define μ (0) , used to start each iterative fitting process.
```
  FIX: ```
- Define \( \mu^{(0)} \), used to start each iterative fitting process.
```
- RAW: ```
- for i ← 0 to ( n 1)
```
  FIX: ```
- for \( i \leftarrow 0 \) to \( (n - 1) \)
```
