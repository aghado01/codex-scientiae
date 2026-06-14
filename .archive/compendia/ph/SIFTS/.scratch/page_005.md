[Page 5]

Similarity Filtration (SIF). SIF is a simple method to compute persistent homology by creating a Vietoris-Rips complex over x 1 ,...,x n , where the diameter measures the similarity between text units:

1. \( D_{\max} = \max D(x_i, x_j), \forall i,j = 1 \dots n \)
2. FOR \( m = 0, 1, \dots, M \)
3. Add \( VR_{\frac{m}{M} D_{\max}} \) to the filtration
4. END

5. Compute persistent homology on the filtration

The growing diameter corresponds to allowing looser tiebacks: more dissimilar text units are linked together to form simplices in the Vietoris-Rips complex. Note the order of \( x_1 \dots x_n \) is ignored. Similarity Filtration with Time Skeleton (SIFTS). We

may be more interested in the ﬂow of the document. Recall we “connect the dots” in the introduction. This prompts us to add “time edges” \( (x_i, x_{i+1}), i = 1 \dots n - 1 \) to the simplicial complex before any similarity ﬁltration. These edges form a “time skeleton” by connecting units in document order. The SIFTS algorithm implements time skeleton by adding the following preprocessing step before the SIF algorithm in section 3:

$$
0 . \ D ( x _ { i } , x _ { i + 1 } ) = 0 \text { for } i = 1 , \dots , n - 1 \\ \intertext { s u l l } x _ { i } , x _ { i + 1 } , x _ { i + 2 } , x _ { i + 3 } , \dots , x _ { i + 5 } , x _ { i + 6 } , x _ { i + 7 } , \dots , x _ { i + 9 }
$$

The key difference between SIF and SIFTS is that a time-skeleton edge can be arbitrarily long as measured by \( D() \). By adding the time skeleton upfront, we enable “tie-back” holes in SIFTS. This is illustrated by the toy document \( (0, 0), (1, 0), (2, 0), (-\frac{1}{2}, 0) \) below, with the Vietoris-Rips complex \( VR(0.5) \):

![image 12](<SIFTS/imageFile12.png>)

SIF sees the Vietoris-Rips complex on the left as four vertices and an edge between \( (0, 0), (-\frac{1}{2}, 0) \). Even though the edge represents a tie-back between the first and last units, no hole has formed. In contrast, SIFTS sees the combined complex on the right with time skeleton in red. The similarity and time edges together form a hole (i.e., \( \beta_1 = 1 \)). The complete barcodes for SIF and SIFTS are presented below. SIF detects no hole at all (\( \beta_1 = 0 \) always): as \( \epsilon \) increase the filtration fills the complex with solid triangles, preventing holes. The hole detected by SIFTS persists until \( \epsilon \) is large enough to cover \( (1, 0) \) and \( (-\frac{1}{2}, 0) \). Also note SIFTS complex is trivially connected by the time skeleton, hence \( \beta_0 = 1 \) always.

![image 13](<SIFTS/imageFile13.png>)









## 3.1 On Nursery Rhymes and Other Stories

We now illustrate persistent homology as computed by SIF and SIFTS on a few nursery rhymes. Nursery rhymes are repetitive and familiar, ideal for homology examples. Each unit is a sentence. We perform minimum tokenization by case-folding and punctuation removal only. The distance D () is the Euclidean distance between sentence-level bag-ofwords count vectors. All ﬁltrations has M = 100 steps.

Figure 1(a) shows Itsy Bitsy Spider . Its homology is strikingly similar to the previous toy document, as the spider climbed up the water spout in both the 1st and the 4th sentences. This hole is detected by SIFTS but not SIF.

Figure 1(b) shows Row Row Row Your Boat . Its four sentences are distinct from each other, forming a “linear progression.” Both SIF and SIFTS give \( \beta_1 = 0 \): there is no hole.

Figure 1(c) shows London Bridge is Falling Down . The lyric has \( n = 48 \) sentences; The sentence “My fair Lady” repeats 12 times. With the time skeleton, SIFTS therefore detects 11 independent holes (\( \beta_1 = 11 \)) right away in \( VR(0) \). These holes are not detected by SIF. Both SIF and SIFTS detect more holes later, some are caused by the near-repetition “Build it up with X and Y ”, where \( X, Y \) vary from wood and clay to silver and gold.

We now move on to longer documents. Here and in next section, the text units are natural paragraphs (or chapters for Alice ). We perform Penn Treebank tokenization, case-folding, punctuation removal, and SMART stopword removal [ Salton, 1971 ] . Each text unit is converted to a tf.idf vector, where idf is computed within the document. We compute the cosine similarity then take the angular distance:  

$$
t , \quad D ( x _ { i } , x _ { j } ) = \cos ^ { - 1 } \left ( \frac { x _ { i } ^ { \top } x _ { j } } { \| x _ { i } \| \cdot \| x _ { j } \| } \right ) . \\ F i gure \, I ( d e f ) \, \text {show the barcodes on}
$$

 · Figure 1(d,e,f) show the barcodes on three stories. In general, SIFTS detects more holes and detects them earlier than SIF. The homology classes that persist the longest tend to be reappearance of salient words. For example, in Red-Cap the ﬁrst SIFTS hole is between the sentences “The better to see you with, my dear” and “The better to eat you with!”

## 3.2 On Child and Adolescent Writing

As a real world example, we quantitatively study whether children’s writing become structurally richer as they grow up. Speciﬁcally, our hypothesis is that older writers have more 1homology groups than younger writers.

We use the LUCY corpus which contains roughly matched child and adolescent writing [ Sampson, 2003 ] . We merge the F,H,K,M groups (ages 9–12, 150 essays) to form a childwriting set. We use the E group (undergraduates, 48 essays) as the adolescent-writing set. The main differences between the two sets are age and average article length (child=11.6 sentences, adolescent=25.8 sentences), see LUCY documentation for other minor differences.

We compute each essay’s SIFTS barcode. To facilitate comparison, we extract two summary statistics. The first is \( |H_1| \), the total number of 1st-order persistent homology classes (holes) over the whole \( \epsilon \) range. This is obtained by counting the number of bars. Note \( |H_1| \ge \beta_1 \) since the Betti number is for a specific \( \epsilon \). The second is \( \epsilon^* \), the smallest
