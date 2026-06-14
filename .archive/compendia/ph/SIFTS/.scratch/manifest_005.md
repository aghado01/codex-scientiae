# Manifest: Page 005

## REPAIR_MATH
- RAW: ```
0 . \ D ( x _ { i } , x _ { i + 1 } ) = 0 \text { for } i = 1 , \dots , n - 1 \\ \intertext { s u l l } x _ { i } , x _ { i + 1 } , x _ { i + 2 } , x _ { i + 3 } , \dots , x _ { i + 5 } , x _ { i + 6 } , x _ { i + 7 } , \dots , x _ { i + 9 }
```
  FIX: ```
$$
0 . \ D ( x _ { i } , x _ { i + 1 } ) = 0 \text { for } i = 1 , \dots , n - 1 \\ \intertext { s u l l } x _ { i } , x _ { i + 1 } , x _ { i + 2 } , x _ { i + 3 } , \dots , x _ { i + 5 } , x _ { i + 6 } , x _ { i + 7 } , \dots , x _ { i + 9 }
$$
```
- RAW: ```
t , \quad D ( x _ { i } , x _ { j } ) = \cos ^ { - 1 } \left ( \frac { x _ { i } ^ { \top } x _ { j } } { \| x _ { i } \| \cdot \| x _ { j } \| } \right ) . \\ F i gure \, I ( d e f ) \, \text {show the barcodes on}
```
  FIX: ```
$$
t , \quad D ( x _ { i } , x _ { j } ) = \cos ^ { - 1 } \left ( \frac { x _ { i } ^ { \top } x _ { j } } { \| x _ { i } \| \cdot \| x _ { j } \| } \right ) . \\ F i gure \, I ( d e f ) \, \text {show the barcodes on}
$$
```
- RAW: ```
1. D max = max D ( x i ,x j ) , ∀ i,j = 1 ...n 2. FOR m = 0 , 1 ,...M 3. Add V R m M D max to the ﬁltration 4. END

5. Compute persistent homology on the ﬁltration
```
  FIX: ```
1. \( D_{\max} = \max D(x_i, x_j), \forall i,j = 1 \dots n \)
2. FOR \( m = 0, 1, \dots, M \)
3. Add \( VR_{\frac{m}{M} D_{\max}} \) to the filtration
4. END

5. Compute persistent homology on the filtration
```
- RAW: ```
Note the order of x 1 ...x n is ignored.
```
  FIX: ```
Note the order of \( x_1 \dots x_n \) is ignored.
```
- RAW: ```
“time edges” ( x i ,x i +1 ) ,i = 1 ...n − 1 to the simplicial
```
  FIX: ```
“time edges” \( (x_i, x_{i+1}), i = 1 \dots n - 1 \) to the simplicial
```
- RAW: ```
measured by D () . By adding the time skeleton upfront, we enable “tie-back” holes in SIFTS. This is illustrated by the toy document (0 , 0) , (1 , 0) , (2 , 0) , ( − 1 2 , 0) below, with the Vietoris-Rips complex V R (0 . 5) :
```
  FIX: ```
measured by \( D() \). By adding the time skeleton upfront, we enable “tie-back” holes in SIFTS. This is illustrated by the toy document \( (0, 0), (1, 0), (2, 0), (-\frac{1}{2}, 0) \) below, with the Vietoris-Rips complex \( VR(0.5) \):
```
- RAW: ```
(0 , 0) , ( − 1 2 , 0) . Even though the edge represents a tie-back between the ﬁrst and last units, no hole has formed. In contrast, SIFTS sees the combined complex on the right with time skeleton in red. The similarity and time edges together form a hole (i.e., β 1 = 1 ). The complete barcodes for SIF and SIFTS are presented below. SIF detects no hole at all ( β 1 = 0 always): as increase the ﬁltration ﬁlls the complex with solid triangles, preventing holes. The hole detected by SIFTS persists until is large enough to cover (1 , 0) and ( − 1 2 , 0) . Also note SIFTS complex is trivially connected by the time skeleton, hence β 0 = 1 always.
```
  FIX: ```
\( (0, 0), (-\frac{1}{2}, 0) \). Even though the edge represents a tie-back between the first and last units, no hole has formed. In contrast, SIFTS sees the combined complex on the right with time skeleton in red. The similarity and time edges together form a hole (i.e., \( \beta_1 = 1 \)). The complete barcodes for SIF and SIFTS are presented below. SIF detects no hole at all (\( \beta_1 = 0 \) always): as \( \epsilon \) increase the filtration fills the complex with solid triangles, preventing holes. The hole detected by SIFTS persists until \( \epsilon \) is large enough to cover \( (1, 0) \) and \( (-\frac{1}{2}, 0) \). Also note SIFTS complex is trivially connected by the time skeleton, hence \( \beta_0 = 1 \) always.
```
- RAW: ```
Both SIF and SIFTS give β 1 = 0 : there is no hole.
```
  FIX: ```
Both SIF and SIFTS give \( \beta_1 = 0 \): there is no hole.
```
- RAW: ```
The lyric has n = 48 sentences; The sentence “My fair Lady” repeats 12 times. With the time skeleton, SIFTS therefore detects 11 independent holes ( β 1 = 11 ) right away in V R (0) . These holes are not detected by SIF. Both SIF and SIFTS detect more holes later, some are caused by the near-repetition “Build it up with X and Y ”, where X,Y vary from wood and clay to silver and gold.
```
  FIX: ```
The lyric has \( n = 48 \) sentences; The sentence “My fair Lady” repeats 12 times. With the time skeleton, SIFTS therefore detects 11 independent holes (\( \beta_1 = 11 \)) right away in \( VR(0) \). These holes are not detected by SIF. Both SIF and SIFTS detect more holes later, some are caused by the near-repetition “Build it up with X and Y ”, where \( X, Y \) vary from wood and clay to silver and gold.
```
- RAW: ```
The ﬁrst is | H 1 | , the total number of 1st-order persistent homology classes (holes) over the whole   range. This is obtained by counting the number of bars. Note | H 1 | ≥ β 1 since the Betti number is for a speciﬁc   . The second is   ∗ , the smallest
```
  FIX: ```
The first is \( |H_1| \), the total number of 1st-order persistent homology classes (holes) over the whole \( \epsilon \) range. This is obtained by counting the number of bars. Note \( |H_1| \ge \beta_1 \) since the Betti number is for a specific \( \epsilon \). The second is \( \epsilon^* \), the smallest
```

## REPAIR_PROSE
- RAW: ```
SIF (dimension 0)

SIFTS (dimension 0)







SIF (dimension

SIFTS (dimension







```
  FIX: ```
```
