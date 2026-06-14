# Manifest: Page 002

## REPLACE_TABLES
FILL_ME_IN

## REPAIR_PROSE
- RAW: `To characterize the k -dimensional features of a topological space X we can consider the homology group in dimension k , H k ð X Þ , composed of elements that intuitively correspond to equivalence classes of cycles that can be continuously deformed into one another on X .`
  FIX: `To characterize the \( k \)-dimensional features of a topological space \( X \) we can consider the homology group in dimension \( k \), \( H_k(X) \), composed of elements that intuitively correspond to equivalence classes of cycles that can be continuously deformed into one another on \( X \).`

## REPAIR_MATH
- RAW: `therefore, we focus on the two key parameters, q and v , coefficients for haptotaxis and chemotaxis, respectively.`
  FIX: `therefore, we focus on the two key parameters, \( q \) and \( v \), coefficients for haptotaxis and chemotaxis, respectively.`
- RAW: `In dimension one, the generators of the homology group correspond to 1D holes in X , or loops, while in dimension zero the generators of the homology group correspond to the connected components of X .`
  FIX: `In dimension one, the generators of the homology group correspond to 1D holes in \( X \), or loops, while in dimension zero the generators of the homology group correspond to the connected components of \( X \).`
- RAW: `The topological spaces we are interested in can be represented using finite sets of simplices known as simplicial complexes K that are constructed by joining together individual simplices, potentially of different dimensions, and are closed under the operation of taking faces.`
  FIX: `The topological spaces we are interested in can be represented using finite sets of simplices known as simplicial complexes \( K \) that are constructed by joining together individual simplices, potentially of different dimensions, and are closed under the operation of taking faces.`
- RAW: `Given a real valued function on K , we can define a filtration as a sequence of homology groups in a given dimension k , with homomorphisms induced by inclusion`
  FIX: `Given a real valued function on \( K \), we can define a filtration as a sequence of homology groups in a given dimension \( k \), with homomorphisms induced by inclusion`
- RAW: `where K a ¼ f 1 ð 1 ; a and a 0 < a 1 < ... < a n , and K a i K a j for i < j . Persistent homology then tracks the birth and death of elements of the homology groups as a varies.`
  FIX: `where \( K_a = f^{-1}(-\infty, a] \) and \( a_0 < a_1 < \dots < a_n \), and \( K_{a_i} \subseteq K_{a_j} \) for \( i < j \). Persistent homology then tracks the birth and death of elements of the homology groups as \( a \) varies.`
- RAW: ```
0 = H _ { k } ( K _ { a _ { 0 } } ) \to H _ { k } ( K _ { a _ { 1 } } ) \to \dots \to H _ { k } ( K _ { a _ { n } } ) = H _ { k } ( K ) \quad ( 1 )
```
  FIX: ```
$$
0 = H _ { k } ( K _ { a _ { 0 } } ) \to H _ { k } ( K _ { a _ { 1 } } ) \to \dots \to H _ { k } ( K _ { a _ { n } } ) = H _ { k } ( K ) \quad ( 1 )
$$
```
