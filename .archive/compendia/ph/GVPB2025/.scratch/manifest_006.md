# Manifest: Page 006

## REPAIR_MATH
- RAW: ```
B _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \sum _ { \ell _ { i } } \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } ,
```
  FIX: ```
$$
B _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \sum _ { \ell _ { i } } \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } ,
$$
```
- RAW: ```
\omega ( \ell , \ell _ { i } ) = | \ell - \ell _ { i } | ^ { \alpha }
```
  FIX: ```
$$
\omega ( \ell , \ell _ { i } ) = | \ell - \ell _ { i } | ^ { \alpha }
$$
```
- RAW: ```
\mathcal { Z } _ { p } ( \ell _ { 1 } , \ell _ { 2 } ) = \frac { \sum _ { \ell _ { 1 } \leq M _ { 1 } , \ell _ { 2 } > M _ { 2 } } \widehat { P I } _ { p } \left ( \ell _ { 1 } , \ell _ { 2 } \right ) } { \beta _ { p } ( \ell _ { 1 } ) } ,
```
  FIX: ```
$$
\mathcal { Z } _ { p } ( \ell _ { 1 } , \ell _ { 2 } ) = \frac { \sum _ { \ell _ { 1 } \leq M _ { 1 } , \ell _ { 2 } > M _ { 2 } } \widehat { P I } _ { p } \left ( \ell _ { 1 } , \ell _ { 2 } \right ) } { \beta _ { p } ( \ell _ { 1 } ) } ,
$$
```
- RAW: ```
\bar { \mathcal { Z } } _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) \, \mathcal { Z } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) }
```
  FIX: ```
$$
\bar { \mathcal { Z } } _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) \, \mathcal { Z } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) }
$$
```
- RAW: ```
new p -dimensional holes
```
  FIX: ```
new \( p \)-dimensional holes
```
- RAW: ```
exponent α . 6 For negative values of α ,
```
  FIX: ```
exponent \( \alpha \). 6 For negative values of \( \alpha \),
```
- RAW: ```
of α give more weight
```
  FIX: ```
of \( \alpha \) give more weight
```
- RAW: ```
fraction of p -dimensional holes in one layer, ℓ 1 , that exist in another layer, ℓ 2 , as well
```
  FIX: ```
fraction of \( p \)-dimensional holes in one layer, \( \ell_1 \), that exist in another layer, \( \ell_2 \), as well
```
- RAW: ```
where M 1 = min( ℓ 1 ,ℓ 2 ); M 2 = max( ℓ 1 ,ℓ 2 ) and β p ( ℓ ) is the Betti number, i.e. the number of alive p -dimensional holes at layer ℓ . 8 We can then
```
  FIX: ```
where \( M_1 = \min(\ell_1, \ell_2) \); \( M_2 = \max(\ell_1, \ell_2) \) and \( \beta_p(\ell) \) is the Betti number, i.e. the number of alive \( p \)-dimensional holes at layer \( \ell \). 8 We can then
```
- RAW: ```
the same as Eq. equation 6. Given that the birth or death of a given p -dimensional hole implies the rearrangements of points in space, ¯ Z p tracks
```
  FIX: ```
the same as Eq. 6. Given that the birth or death of a given \( p \)-dimensional hole implies the rearrangements of points in space, \( \bar{\mathcal{Z}}_p \) tracks
```
- RAW: ```
{ 100, 200, ..., 1000 }
```
  FIX: ```
\( \{ 100, 200, \dots, 1000 \} \)
```

## REPAIR_PROSE
- RAW: ```
6 This type of weighting has been used previously for topological descriptors, see e.g. [63]. 7

We note that this is related to the generalized rank invariants
```
  FIX: ```
6 This type of weighting has been used previously for topological descriptors, see e.g. [63].

7 We note that this is related to the generalized rank invariants
```
- RAW: ```
throughout the intermediate layers. 8

Note that equation 7 is well-defined only when β p ( ℓ ) > 0 . If there are no p -dimensional holes at either ℓ 1 or ℓ 2 , Z p ( ℓ 1 , ℓ 2 ) should be 0 by definition. We omitted this limit case from equation 7 for readability. 9

https://huggingface.co/datasets/NeelNanda/pile-10k 10

https://huggingface.co/datasets/codeparrot/github-code
```
  FIX: ```
throughout the intermediate layers.

8 Note that equation 7 is well-defined only when \( \beta_p(\ell) > 0 \). If there are no \( p \)-dimensional holes at either \( \ell_1 \) or \( \ell_2 \), \( \mathcal{Z}_p(\ell_1, \ell_2) \) should be 0 by definition. We omitted this limit case from equation 7 for readability.

9 https://huggingface.co/datasets/NeelNanda/pile-10k

10 https://huggingface.co/datasets/codeparrot/github-code
```
