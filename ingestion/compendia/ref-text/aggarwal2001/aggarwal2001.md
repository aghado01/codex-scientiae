[Page 1]

# On the Surprising Behavior of Distance Metrics in High Dimensional Space

Charu C. Aggarwal 1 , Alexander Hinneburg 2 , and Daniel A. Keim 2 1 IBM T. J. Watson Research Center Yorktown Heights, NY 10598, USA. charu@watson.ibm.com 2 Institute of Computer Science, University of Halle Kurt-Mothes-Str.1, 06120 Halle (Saale), Germany { hinneburg, keim } @informatik.uni-halle.de

Abstract. In recent years, the eﬀect of the curse of high dimensionality has been studied in great detail on several problems such as clustering, nearest neighbor search, and indexing. In high dimensional space the data becomes sparse, and traditional indexing and algorithmic techniques fail from a eﬃciency and/or eﬀectiveness perspective. Recent research results show that in high dimensional space, the concept of proximity, distance or nearest neighbor may not even be qualitatively meaningful. In this paper, we view the dimensionality curse from the point of view of the distance metrics which are used to measure the similarity between objects. We speciﬁcally examine the behavior of the commonly used L k norm and show that the problem of meaningfulness in high dimensionality is sensitive to the value of k . For example, this means that the Manhattan distance metric ( L 1 norm) is consistently more preferable than the Euclidean distance metric ( L 2 norm) for high dimensional data mining applications. Using the intuition derived from our analysis, we introduce and examine a natural extension of the L k norm to fractional distance metrics. We show that the fractional distance metric provides more meaningful results both from the theoretical and empirical perspective. The results show that fractional distance metrics can signiﬁcantly improve the eﬀectiveness of standard clustering algorithms such as the k-means algorithm.

# 1 Introduction

In recent years, high dimensional search and retrieval have become very well studied problems because of the increased importance of data mining applications [1], [2], [3], [4], [5], [8], [10], [11]. Typically, most real applications which require the use of such techniques comprise very high dimensional data. For such applications, the curse of high dimensionality tends to be a major obstacle in the development of data mining techniques in several ways. For example, the performance of similarity indexing structures in high dimensions degrades rapidly, so that each query requires the access of almost all the data [1].

J. Van den Bussche and V. Vianu (Eds.): ICDT 2001, LNCS 1973, pp. 420–434, 2001. c   Springer-Verlag Berlin Heidelberg 2001

[Page 2]

It has been argued in [6], that under certain reasonable assumptions on the data distribution, the ratio of the distances of the nearest and farthest neighbors to a given target in high dimensional space is almost 1 for a wide variety of data distributions and distance functions. In such a case, the nearest neighbor problem becomes ill deﬁned, since the contrast between the distances to diﬀerent data points does not exist. In such cases, even the concept of proximity may not be meaningful from a qualitative perspective: a problem which is even more fundamental than the performance degradation of high dimensional algorithms.

In most high dimensional applications the choice of the distance metric is not obvious; and the notion for the calculation of similarity is very heuristical. Given the non-contrasting nature of the distribution of distances to a given query point, diﬀerent measures may provide very diﬀerent orders of proximity of points to a given query point. There is very little literature on providing guidance for choosing the correct distance measure which results in the most meaningful notion of proximity between two records. Many high dimensional indexing structures and algorithms use the euclidean distance metric as a natural extension of its traditional use in twoor three-dimensional spatial applications. In this paper, we discuss the general behavior of the commonly used L k norm ( x,y ∈ R d ,k ∈ Z ,   L k ( x,y ) =   d i =1 (   x i − y i   k ) 1 /k ) in high dimensional space. The L k norm distance function is also susceptible to the dimensionality curse for many classes of data distributions [6]. Our recent results [9] seem to suggest that the L k -norm may be more relevant for k = 1 or 2 than values of k ≥ 3. In this paper, we provide some surprising theoretical and experimental results in analyzing the dependency of the L k norm on the value of k . More speciﬁcally, we show that the relative contrasts of the distances to a query point depend heavily on the L k metric used. This provides considerable evidence that the meaningfulness of the L k norm worsens faster with increasing dimensionality for higher values of k . Thus, for a given problem with a ﬁxed (high) value of the dimensionality d , it may be preferable to use lower values of k . This means that the L 1 distance metric (Manhattan Distance metric) is the most preferable for high dimensional applications, followed by the Euclidean Metric ( L 2 ), then the L 3 metric, and so on. Encouraged by this trend, we examine the behavior of fractional distance metrics, in which k is allowed to be a fraction smaller than 1. We show that this metric is even more eﬀective at preserving the meaningfulness of proximity measures. We back up our theoretical results with empirical tests on real and synthetic data showing that the results provided by fractional distance metrics are indeed practically useful. Thus, the results of this paper have strong implications for the choice of distance metrics for high dimensional data mining problems. We speciﬁcally show the improvements which can be obtained by applying fractional distance metrics to the standard k-means algorithm.

This paper is organized as follows. In the next section, we provide a theoretical analysis of the behavior of the L k norm in very high dimensionality. In section 3, we discuss fractional distance metrics and provide a theoretical analysis of their behavior. In section 4, we provide the empirical results, and section 5 provides summary and conclusions.

[Page 3]

# 2 Behavior of the L k -Norm in High Dimensionality

In order to present our convergence results, we ﬁrst establish some notations and deﬁnitions in Table 1.

Table 1. Notations and Basic Deﬁnitions

|Notation|Definition|
|---|---|
|d N F X d dist k d ( x, y ) ‖ · ‖ k Dmax k d = max {‖ X d ‖ k } Dmin k d = min {‖ X d ‖ k } E [ X ], var [ X ] Y d → p c|Dimensionality of the data space Number of data points 1-dimensional data distribution in (0 , 1) Data point from F d with each coordinate drawn from F Distance between ( x 1 , . ..x d ) and ( y 1 , . . . y d ) using L k metric = ∑ d i =1 [( x i 1 - x i 2 ) k ] 1 /k Distance of a vector to the origin (0 , . . . , 0) using the function dist k d ( · , · ) Farthest distance of the N points to the origin using the distance metric L k Nearest distance of the N points to the origin using the distance metric L k Expected value and variance of a random variable X A vector sequence Y 1 , . . .,Y d converges in probability to a constant vector c if: ∀ glyph[epsilon1] > 0 lim d →∞ P [ dist d ( Y d , c ) ≤ glyph[epsilon1] ] = 1|


# Theorem 1. Beyer et. al. (Adapted for L k metric) Dmax k Dmin k

$$
& \text {Ief} \, \min \, \{ \, I \colon \text {Beyer et. a.} \, ( \text {Adapted for } I ^ { k } \text {, metric} ) \\ & \text {If} \, l i m _ { d \to \infty } \ v a r \left ( \frac { \| X _ { d } \| _ { k } } { E [ \| X _ { d } \| _ { k } ] } \right ) = 0 \ , \, t h e n \ \frac { \ D m a x _ { d } ^ { k } - \text {Dmin} _ { d } ^ { k } } { \ D m i n _ { d } ^ { k } } \to _ { p } 0 . \\ & \text {Proof. See [6] for proof of a more general version of this result.}
$$

Proof. See [6] for proof of a more general version of this result.

The result of the theorem [6] shows that the diﬀerence between the maximum and minimum distances to a given query point 1 does not increase as fast as the nearest distance to any point in high dimensional space. This makes a proximity query meaningless and unstable because there is poor discrimination between the nearest and furthest neighbor. Henceforth, we will refer to the ratio Dmax k d − Dmin k d Dmin k d as the relative contrast . Dmax k Dmin k

The results in [6] use the value of d − d Dmin k d as an interesting criterion for meaningfulness. In order to provide more insight, in the following we analyze the behavior for diﬀerent distance metrics in high-dimensional space. We ﬁrst assume a uniform distribution of data points and show our results for N = 2 points. Then, we generalize the results to an arbitrary number of points and arbitrary distributions.

1 In this paper, we consistently use the origin as the query point. This choice does not aﬀect the generality of our results, though it simpliﬁes our algebra considerably.

[Page 4]

Lemma 1. Let F be uniform distribution of N = 2 points. For an L k metric,

F k

$$
\lim _ { \ s t a n t . } & E \left [ \frac { \ D m a x _ { d } ^ { k } - D m i n _ { d } ^ { k } } { d ^ { 1 / k - 1 / 2 } } \right ] = C \cdot \left ( \frac { 1 } { ( k + 1 ) ^ { 1 / k } } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot k + 1 } \right ) } , \, w h e r e \, C \, \text { is some } c n - \\
$$

Proof. Let A d and B d be the two points in a d dimensional data distribution such that each coordinate is independently drawn from a 1-dimensional data distribution F with ﬁnite mean and standard deviation. Speciﬁcally A d = ( P 1 ...P d ) and B d = ( Q 1 ...Q d ) with P i and Q i being drawn from F . Let PA d = {   d i =1 ( P i ) k } 1 /k be the distance of A d to the origin using the L k metric and PB d = {   d i =1 ( Q i ) k } 1 /k the distance of B d . The diﬀerence of distances is PA d − PB d = {   d i =1 ( P i ) k } 1 /k − {   d i =1 ( Q i ) k } 1 /k . It can be shown 2 that the random variable ( P i ) k has mean 1 k +1 and standard

deviation   k k +1       1 2 · k +1   . This means that ( PA d ) k d → p 1 ( k +1) , ( PB d ) k d → p 1 ( k +1) and therefore

$$
\frac { P A _ { d } } { d ^ { 1 / k } } \rightarrow _ { p } \left ( \frac { 1 } { k + 1 } \right ) ^ { 1 / k } , \ \frac { P B _ { d } } { d ^ { 1 / k } } \rightarrow _ { p } \left ( \frac { 1 } { k + 1 } \right ) ^ { 1 / k } \\
$$

We intend to show that | PA d − PB d | d 1 /k − 1 / 2 → p   1 ( k +1) 1 /k       2 2 · k +1   . We can express | PA d − PB d | in the following numerator/denominator form which we will use in order to examine the convergence behavior of the numerator and denominator individually. | ( PA d ) k − ( PB d ) k |

$$
| P A _ { d } - P B _ { d } | = \frac { | ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } | } { \sum _ { r = 0 } ^ { k - 1 } ( P A _ { d } ) ^ { k - r - 1 } ( P B _ { d } ) ^ { r } }
$$

| PA d − PB d | =   k − 1 r =0 ( PA d ) k − r − 1 ( PB d ) r Dividing both sides by d 1 /k − 1 / 2 and regrouping the right-hand-side we get:

$$
\text {big both sides by $d^{1/k-1/2}$ and regrouping the right-hand-side we get:} \\ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / k - 1 / 2 } } = \frac { | ( ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } ) | / \sqrt { d } } { \sum _ { r = 0 } ^ { k - 1 } \left ( \frac { P A _ { d } } { d ^ { 1 / k } } \right ) ^ { k - r - 1 } \left ( \frac { P B _ { d } } { d ^ { 1 / k } } \right ) ^ { r } } \\ \text {quietly, using Slutsky's theorem $3$ and the results of Equation 1 we obtain}
$$

Consequently, using Slutsky’s theorem 3 and the results of Equation 1 we obtain

$$
\sum _ { r = 0 } ^ { k - 1 } \left ( \frac { P A _ { d } } { d ^ { 1 / k } } \right ) ^ { k - r - 1 } \cdot \left ( \frac { P B _ { d } } { d ^ { 1 / k } } \right ) ^ { r } \to _ { p } k \cdot \left ( \frac { 1 } { k + 1 } \right ) ^ { ( k - 1 ) / k } \\ \text {aving characterized the converse behavior of the denominator of the right}
$$

Having characterized the convergence behavior of the denominator of the right hand side of Equation 3, let us now examine the behavior of the numerator: | ( PA d ) k − ( PB d ) k | / √ d = |   d i =1 (( P i ) k − ( Q i ) k ) | / √ d = |   d i =1 R i | / √ d . Here R i is the new random variable deﬁned by (( P i ) k − ( Q i ) k ) ∀ i ∈ { 1 ,...d } . This random variable has zero mean and standard deviation which is √ 2 · σ where 2 k 2 k

2 This is because E [ P k i ] = 1 / ( k +1) and E [ P 2 k i ] = 1 / (2 · k +1).

vectors and h ( · ) be a continuous function. If Y d → p c then h ( Y d ) → p h ( c ).

[Page 5]

σ is the standard deviation of ( P i ) k . The sum of diﬀerent values of R i over d dimensions will converge to a normal distribution with mean 0 and standard deviation √ 2 · σ · √ d because of the central limit theorem. Consequently, the mean average deviation of this distribution will be C · σ for some constant C . Therefore, we have: k k

$$
\lim _ { \substack { \lim _ { d \to \infty } E \left [ \frac { | ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } | } { \sqrt { d } } \right ] } } = C \cdot \frac { k } { k + 1 } \sqrt { \frac { 1 } { 2 \cdot k + 1 } } \\ \intertext { Sino, the denominator of Equation 3 shows probability, uniqueness, and a few points. }
$$

Since the denominator of Equation 3 shows probabilistic convergence, we can combine the results of Equations 4 and 5 to obtain

$$
\lim _ { d \to \infty } E \left [ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / k - 1 / 2 } } \right ] = C \cdot \frac { 1 } { ( k + 1 ) ^ { 1 / k } } \sqrt { \frac { 1 } { 2 \cdot k + 1 } } \\ \text {No.} \, \text {g. only} \, \text {g.or.only} \, \text {to} \, \text {a.d.} \, \text {dot} \, \text {b.so.} \, \text {of.} \, N \text { uniformly} \, \text {distributod}
$$

We can easily generalize the result for a database of N uniformly distributed points. The following Corollary provides the result.

$$
& \quad \text {Corollary} \ 1 . \ \text {Let} \ \mathcal { F } \ \text {be the uniform distribution of } N = n \text { points.} \ \text {Then} , \\ & \quad \left ( \frac { C } { ( k + 1 ) ^ { 1 / k } } \right ) \sqrt { \left ( \frac { 1 } { 2 ^ { k + 1 } } \right ) } \leq \lim _ { d \to \infty } E \left [ \frac { D \max _ { d } ^ { k } - D \min _ { d } ^ { k } } { d ^ { 1 / k - 1 / 2 } } \right ] \leq \left ( \frac { C \cdot ( n - 1 ) } { ( k + 1 ) ^ { 1 / k } } \right ) \sqrt { \left ( \frac { 1 } { 2 ^ { k + 1 } } \right ) } . \\ & \quad \text {Proof. This is because if L is the expected difference between the maximum and}
$$

Proof. This is because if L is the expected diﬀerence between the maximum and minimum of two randomly drawn points, then the same value for n points drawn from the same distribution must be in the range ( L, ( n − 1) · L ).

The results can be modiﬁed for arbitrary distributions of N points in a database by introducing the constant factor C k . In that case, the general dependency of D max − D min on d 1 k − 1 2 remains unchanged. A detailed proof is provided in the Appendix; a short outline of the reasoning behind the result is available in [9].

Lemma 2. [9] Let F be an arbitrary distribution of N = 2 points. Then, lim d →∞ E   Dmax k d − Dmin k d d 1 /k − 1 / 2   = C k , where C k is some constant dependent on k . Corollary 2. Let be the arbitrary distribution of N = n points. Then,

Corollary 2. Let F be the arbitrary distribution of N = n points. Then,

$$
C _ { k } \leq l i m _ { d \to \infty } E \left [ \frac { D m a x _ { d } ^ { k } - D m i n _ { d } ^ { k } } { d ^ { 1 / k - 1 / 2 } } \right ] \leq ( n - 1 ) \cdot C _ { k } .
$$

Thus, this result shows that in high dimensional space Dmax k d − Dmin k d increases at the rate of d 1 /k − 1 / 2 , independent of the data distribution. This means that for the manhattan distance metric, the value of this expression diverges to ∞ ; for the Euclidean distance metric, the expression is bounded by constants whereas for all other distance metrics, it converges to 0 (see Figure 1). Furthermore, the convergence is faster when the value of k of the L k metric increases. This provides the insight that higher norm parameters provide poorer contrast between the furthest and nearest neighbor. Even more insight may be obtained by examining the exact behavior of the relative contrast as opposed to the absolute distance between the furthest and nearest point.

[Page 6]

![The image is a graph with five different axes labeled as follows: - The x-axis is labeled as k and ranges from 0 to 10. - The y-axis is labeled as p and ranges from 0 to 10. - There are two sets of data points plotted on the graph. - The first set of data points is labeled as a and is plotted on the y-axis. - The second set of data points is labeled as b and is plotted on the x-axis. - The graph has a dashed line that starts at the point (0, 2) and extends upwards to the right. - The dashed line has a slope of 3 and a y-intercept of 2. - The graph also has a dashed line that starts at the point (2, 0) and extends upwards to the right. - The dashed line has a slope of](<aggarwal2001/imageFile1.png>)

1.1 1.15

1.9

25

p=2

p=2

p=1

1.05

1.7

20

1.05

1.6

1

1.5

15

0.9

1.4

0.85

1.3

10

0.8

1.2

0.75

1.1

5

0.7

1.1

0.7

1

0

20

60

80

80

120 140 160 180 200

20

60

80

80

120 140 160 180 200

20

60

80

80

120 140 160 180 200

(a)

= 3

(b)

= 2

(c)

= 1

k

k

k

400

1.6e+07

p=2/3

p=2/5

300

1.2e+07

300

1e+07

200

8e+06

200

6e+06

100

4e+06

100

2e+06

0

2e+06

0

0

20

60

80

80

120 140 160 180 200

20

60

80

80

120 140 160 180 200

(d)

= 2 /

3

(e)

= 2 /

5

k

/

k

/

Fig. 1. | Dmax − Dmin | depending on d for diﬀerent metrics (uniform data) Table 2. Eﬀect of dimensionality on relative ( L 1 and L 2 ) behavior of relative contrast

|Dimensionality 1 Both|P [ U d < T d ]|
|---|---|
|1|Both metrics are the same|
|2|85 . 0%|
|3|88 . 7%|
|4|91 . 3%|


|Dimensionality 10|P [ U d < T d ] 95 6%|
|---|---|
|15|95 . 6%|
|15|96 . 1%|
|20|97 . 1%|
|100|98 . 2%|


Theorem 2. Let F be the uniform distribution of N = 2 points. Then, lim d →∞ E    Dmax k d − Dmin k d Dmin k d   · √ d   = C ·   1 2 · k +1 . Proof. Let A d , B d , P 1 ...P d , Q 1 ...Q d , PA d , PB d be deﬁned as in the

proof of Lemma 1. We have shown in the proof of the previous result that PA d d 1 /k →   1 k +1   1 /k . Using Slutsky’s theorem we can derive that: 1 /k

$$
\min \{ \frac { P A _ { d } } { d ^ { 1 / k } } , \frac { P B _ { d } } { d ^ { 1 / k } } \} & \to \left ( \frac { 1 } { k + 1 } \right ) ^ { 1 / k } \\
$$

We have also shown in the previous result that:

$$
\lim _ { d \to \infty } E \left [ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / k - 1 / 2 } } \right ] = C \cdot \left ( \frac { 1 } { ( k + 1 ) ^ { 1 / k } } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot k + 1 } \right ) } \quad ( 8 )
$$

We can combine the results in Equation 7 and 8 to obtain:

$$
\lim _ { d \to \infty } E \left [ \sqrt { d } \cdot \frac { | P A _ { d } - P B _ { d } | } { \min \{ P A _ { d } , P B _ { d } \} } \right ] & = C \cdot \sqrt { 1 / ( 2 \cdot k + 1 ) } \\ \intertext { t o n t h e t h a t h e a b o v e r s u l t s e f r o m i f o r t h e s u l t s i n g l e b a v e s i t h o w s t h a t h e a b o w s t h a t h e s u l t s i n g l e b a v e s i t h o w s t h a t h e a b o w s t h a t h e s u l t s i n g l e b a v e s i t h o w s t h a t h e a b o w s t h a t h e s u l t s i n g l e b a v e s i t h o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e s u l t s i n g l e b a v e s i t h o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o w s t h a t h e a b o
$$

Note that the above results conﬁrm of the results in [6] because it shows that the relative contrast degrades as 1 / √ d for the diﬀerent distance norms. Note

[Page 7]

![image 2](<aggarwal2001/imageFile2.png>)

RELATIVE CONTRAST FOR UNIFORM DISTRIBUTION

4.5

N=10,000 N=1,000

N=100

4

N=100

3.5

3

1.5 2 2.5 3 RELATIVE CONTRAST

2.5

2

1.5

1

0.5

0

0

1

2

3

4

5

6

7

8

9

10

Fig. 2. Relative contrast variation with norm parameter for the uniform distribution

![image 3](<aggarwal2001/imageFile3.png>)

1

f=1

0.8

f=0.5

0.6

f=0.25

f=0.25

0.4

0.2

0

-0.2

-0.4

-0.6

-0.8

-1

-1

-0.8 -0.6 -0.4 -0.2

0

0.2

0.4

0.6

0.8

1

Fig. 3. Unit spheres for diﬀerent fractional metrics (2D)

that for values of d in the reasonable range of data mining applications, the norm dependent factor of   1 / (2 · k + 1) may play a valuable role in aﬀecting the relative contrast. For such cases, even the relative rate of degradation of the diﬀerent distance metrics for a given data set in the same value of the dimensionality may be important. In the Figure 2 we have illustrated the relative contrast created by an artiﬁcially generated data set drawn from a uniform distribution in d = 20 dimensions. Clearly, the relative contrast decreases with increasing value of k and also follows the same trend as   1 / (2 · k + 1). Another interesting aspect which can be explored to improve nearest neigh-

bor and clustering algorithms in high-dimensional space is the eﬀect of k on the relative contrast. Even though the expected relative contrast always decreases with increasing dimensionality, this may not necessarily be true for a given data set and diﬀerent k . To show this, we performed the following experiment on the Manhattan ( L 1 ) and Euclidean ( L 2 ) distance metric: Let U d =   Dmax 2 d − Dmin 2 d Dmin 2 d   and T d =   Dmax 1 d − Dmin 1 d Dmin 1 d   . We performed some empirical tests to calculate the value of P [ U d < T d ] for the case of the Manhattan ( L 1 ) and Euclidean ( L 2 ) distance metrics for N = 10 points drawn from a uniform distribution. In each trial, U d and T d were calculated from the same set of N = 10 points, and P [ U d < T d ] was calculated by ﬁnding the fraction of times U d was less than T d in 1000 trials. The results of the experiment are given in Table 2. It is clear that with increasing dimensionality d , the value of P [ U d < T d ] continues to increase. Thus, for higher dimensionality, the relative contrast provided by a norm with smaller parameter k is more likely to dominate another with a larger parameter. For dimensionalities of 20 or higher it is clear that the manhattan distance metric provides a signiﬁcantly higher relative contrast than the Euclidean distance metric with very high probability. Thus, among the distance metrics with integral norms, the manhattan distance metric is the method of choice for providing the best contrast between the diﬀerent points. This result of our analysis can be

directly used in a number of diﬀerent applications.

[Page 8]

# 3 Fractional Distance Metrics

The result of the previous section that the Manhattan metric ( k = 1) provides the best discrimination in high-dimensional data spaces is the motivation for looking into distance metrics with k < 1. We call these metrics fractional distance metrics. A fractional distance metric dist f d ( L f norm) for f ∈ (0 , 1) is deﬁned as: d

$$
d i s t _ { d } ^ { f } ( x , y ) & = \sum _ { i = 1 } ^ { d } \left [ ( x ^ { i } - y ^ { i } ) ^ { f } \right ] ^ { 1 / f } . \\ t i o n o f t h e b a h v i o r o f t h e f r a c t i o n a l d i s t a n c e
$$

To give a intuition of the behavior of the fractional distance metric we plotted in Figure 3 the unit spheres for diﬀerent fractional metrics in R 2 . We will prove most of our results in this section assuming that f is of the form

1 /l , where l is some integer. The reason that we show the results for this special case is that we are able to use nice algebraic tricks for the proofs. The natural conjecture from the smooth continuous variation of dist f d with f is that the results are also true for arbitrary values of f . 4 . Our results provide considerable insights into the behavior of the fractional distance metric and its relationship with the L k -norm for integral values of k .

Lemma 3. Let F be the uniform distribution of N = 2 points and f = 1 /l for some integer l . Then,

$$
J o n t C u n g C u t \colon & \colon \bar { I } n c h , \\ l i m _ { d \to \infty } E \left [ \frac { D m a x _ { d } ^ { f } - D m i n _ { d } ^ { f } } { d ^ { 1 / f - 1 / 2 } } \right ] = C \cdot \left ( \frac { 1 } { ( f + 1 ) ^ { 1 / f } } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot f + 1 } \right ) } . \\ P r o f \ J o n t \ A \, , \, B \, , \, P \, , \, P _ { \ } P a \, , \, P _ { \ } P a \, , \, P B \, , \, B \, \text { defined using}
$$

Proof. Let A d , B d , P 1 ...P d , Q 1 ...Q d , PA d , PB d be deﬁned using the L f metric as they were deﬁned in Lemma 1 for the L k metric. Let further QA d = ( PA d ) f = ( PA d ) 1 /l =   d i =1 ( P i ) f and QB d = ( PB d ) f = ( PB d ) 1 /l =   d i =1 ( Q i ) f . Analogous to Lemma 1, QA d d → p 1 f +1 , QB d d → p 1 f +1 . PA PB

We intend to show that E   | d − d | d l − 1 / 2   = C ·   1 ( f +1) 1 /f       1 2 · f +1   . The diﬀerence of distances is | PA d − PB d | = {   d i =1 ( P i ) f } 1 /f − {   d i =1 ( Q i ) f } 1 /f = {   d i =1 ( P i ) f } l − {   d i =1 ( Q i ) f } l . Note that the above expression is of the form | a l − b l | = | a − b | · (   l − 1 r =0 a r · b l − r − 1 ). Therefore, | PA d − PB d | can be written as {   d i =1 | ( P i ) f − ( Q i ) f |}·{   l − 1 r =0 ( QA d ) r · ( QB d ) l − r − 1 } . By dividing both sides by d 1 /f − 1 / 2 and regrouping the right hand side we get:

$$
\frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / f - 1 / 2 } } \rightarrow _ { p } \{ \frac { \sum _ { i = 1 } ^ { d } | ( P _ { i } ) ^ { f } - ( Q _ { i } ) ^ { f } | } { \sqrt { d } } \} \cdot \{ \sum _ { r = 0 } ^ { l - 1 } \left ( \frac { Q A _ { d } } { d } \right ) ^ { r } \cdot \left ( \frac { Q B _ { d } } { d } \right ) ^ { l - r - 1 } \} \ ( 1 0 ) \\ \\ \intertext { s u n g t h e w s }
$$

By using the results in Equation 10, we can derive that:

$$
\frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / f - 1 / 2 } } \rightarrow _ { p } \{ \frac { \sum _ { i = 1 } ^ { d } | ( P _ { i } ) ^ { f } - ( Q _ { i } ) ^ { f } | } { \sqrt { d } } \} \cdot \{ l \cdot \frac { 1 } { ( 1 + f ) ^ { l - 1 } } \} \quad ( 1 1 ) \\ \frac { 4 \ E m p i r i c a l u m i o n s o f t h e r a l i t e c o n t r a s t h o w s i n d e d e t h a s e } { 4 \ E m p i r i c a l u m i o n s o f t h e r a l i t e c o n t r a s t h o w s i n d e d e t h a s e }
$$

4 Empirical simulations of the relative contrast show this is indeed the case.

[Page 9]

$$
\lim _ { d \to \infty } E \left [ \frac { | ( P A _ { d } ) ^ { f } - ( P B _ { d } ) ^ { f } | } { \sqrt { d } } \right ] = C \cdot \sigma = C \cdot \left ( \frac { f } { f + 1 } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot f + 1 } \right ) } . \ \ ( 1 2 )
$$

Combining the results of Equations 12 and 11, we get:

$$
\lim _ { d \to \infty } E \left [ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / f - 1 / 2 } } \right ] = \left ( \frac { C } { ( f + 1 ) ^ { 1 / f } } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot f + 1 } \right ) }
$$

An direct consequence of the above result is the following generalization to N = n points.

Corollary 3. When F is the uniform distribution of N = n points and f = 1 /l for some integer l . Then, for some constant C we have:

$$
& \quad \text {for $60m<\infty$} \, \text {and} \, \text {i.e.} \, \underset { ( f + 1 ) ^ { 1 / 7 } } { \text {to } } \left \lceil \left ( \frac { C } { ( f + 1 ) ^ { 1 / 7 } } \right ) \, \sqrt { \left ( \frac { 1 } { 2 \cdot f + 1 } \right ) } \right \rceil \leq \lim _ { d \to \infty } E \left [ \frac { D r a x _ { d } ^ { f } - D \min _ { d } ^ { f } } { d ^ { 1 / 7 - 1 / 2 } } \right ] \leq \left ( \frac { C \cdot ( n - 1 ) } { ( f + 1 ) ^ { 1 / 7 } } \right ) \sqrt { \left ( \frac { 1 } { 2 \cdot f + 1 } \right ) } . \\ & \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

Proof. Similar to corollary 1.

The above result shows that the absolute diﬀerence between the maximum and minimum for the fractional distance metric increases at the rate of d 1 /f − 1 / 2 . Thus, the smaller the fraction, the greater the rate of absolute divergence between the maximum and minimum value. Now, we will examine the relative contrast of the fractional distance metric.

Theorem 3. Let F be the uniform distribution of N = 2 points and f = 1 /l for some integer l . Then, f f

$$
\text {for some integer} l . \text { Then} , \\ \lim _ { d \to \infty } \left ( \frac { D \max _ { d } ^ { f } - D \min _ { d } ^ { f } } { D \min _ { d } ^ { f } } \right ) \sqrt { d } = C \cdot \sqrt { \frac { 1 } { 2 \cdot f + 1 } } \text { for some constant } C . \\
$$

Proof. Analogous to the proof of Theorem 2.

The following is the direct generalization to N = n points.

Corollary 4. Let F be the uniform distribution of N = n points, and f = 1 /l for some integer l . Then, for some constant C f f

$$
j o n \ s o m i t e g e { \iota . \, 1 } { h e n , j o n \ s o m i t e \, c o n s l a n t \, C } \\ C \cdot \sqrt { \frac { 1 } { 2 \cdot f + 1 } } \leq l i m _ { d \to \infty } E \left [ \frac { D \max _ { d } ^ { f } - D \min _ { d } ^ { f } } { D \min _ { d } ^ { f } } \right ] \leq C \cdot ( n - 1 ) \cdot \sqrt { \frac { 1 } { 2 \cdot f + 1 } } . \\ \\ R _ { \ } f o r \quad ( 1 - 1 ) + 1 = 0
$$

Proof. Analogous to the proof of Corollary 1.

[Page 10]

The above results show that fractional distance metrics provide better contrast than integral distance metrics both in terms of the absolute distributions of points to a given query point and relative distances. This is a surprising result in light of the fact that the Euclidean distance metric is traditionally used in a large variety of indexing structures and data mining applications. The widespread use of the Euclidean distance metric stems from the natural extension of applicability to spatial database systems (many multidimensional indexing structures were initially proposed in the context of spatial systems). However, from the perspective of high dimensional data mining applications, this natural interpretability in 2 or 3-dimensional spatial systems is completely irrelevant. Whether the theoretical behavior of the relative contrast also translates into practically useful implications for high dimensional data mining applications is an issue which we will examine in greater detail in the next section.

# 4 Empirical Results

In this section, we show that our surprising ﬁndings can be directly applied to improve existing mining techniques for high-dimensional data. For the experiments, we use synthetic and real data. The synthetic data consists of a number of clusters (data inside the clusters follow a normal distribution and the cluster centers are uniformly distributed). The advantage of the synthetic data sets is that the clusters are clearly separated and any clustering algorithm should be able to identify them correctly. For our experiments we used one of the most widely used standard clustering algorithms the k-means algorithm . The data set used in the experiments consists of 6 clusters with 10000 data points each and no noise. The dimensionality was chosen to be 20. The results of our experiments show that the fractional distance metrics provides a much higher classiﬁcation rate which is about 99% for the fractional distance metric with f = 0 . 3 versus 89% for the Euclidean metric (see ﬁgure 4). The detailed results including the confusion matrices obtained are provided in the appendix.

For the experiments with real data sets, we use some of the classiﬁcation problems from the UCI machine learning repository 5 . All of these problems are classiﬁcation problems which have a large number of feature variables, and a special variable which is designated as the class label. We used the following simple experiment: For each of the cases that we tested on, we stripped oﬀ the

5 http : //www.cs.uci.edu/ ˜ mlearn

[Page 11]

![image 4](<aggarwal2001/imageFile4.png>)

100

95

90

Classification Rate

85

80

75

70

65

60

55

50 0

0

0.5

1

1.5

2

2.5

3

Distance Parameter

Fig. 4. Eﬀectiveness of k-Means

- 1. Class Variable Accuracy: This was the primary measure that we used in order to test the quality of the diﬀerent distance metrics. Since the class variable is known to depend in some way on the feature variables, the proximity of objects belonging to the same class in feature space is evidence of the meaningfulness of a given distance metric. The speciﬁc measure that we used was the total number of the l nearest neighbors that belonged to the same class as the target object over all the diﬀerent target objects. Needless to say, we do not intend to propose this rudimentary unsupervised technique as an alternative to classiﬁcation models, but use the classiﬁcation performance only as an evidence of the meaningfulness (or lack of meaningfulness) of a given distance metric. The class labels may not necessarily always correspond to locality in feature space; therefore the meaningfulness results presented are evidential in nature. However, a consistent eﬀect on the class variable accuracy with increasing norm parameter does tend to be a powerful way of demonstrating qualitative trends.
- 2. Noise Stability: How does the quality of the distance metric vary with more or less noisy data? We used noise masking in order to evaluate this aspect. In noise masking, each entry in the database was replaced by a random entry with masking probability p c . The random entry was chosen from a uniform distribution centered at the mean of that attribute. Thus, when p c is 1, the data is completely noisy. We studied how each of the two problems were aﬀected by noise masking.


In Table 3, we have illustrated some examples of the variation in performance for diﬀerent distance metrics. Except for a few exceptions, the major trend in this table is that the accuracy performance decreases with increasing value of the norm parameter. We have show the table in the range L 0 . 1 to L 10 because it was easiest to calculate the distance values without exceeding the numerical ranges in the computer representation. We have also illustrated the accuracy performance when the L ∞ metric is used. One interesting observation is that the accuracy with the L ∞ distance metric is often worse than the accuracy value by picking a record from the database at random and reporting the corresponding target

[Page 12]

Table 3. Number of correct class label matches between nearest neighbor and target

|Data Set|L 0 . 1|L 0 . 5|L 1|L 2|L 4|4 L 10|L ∞|Random|
|---|---|---|---|---|---|---|---|---|
|Machine|522|474|449|402|364|353|341|153|
|Musk|998|893|683|405|301|272|163|140|
|Breast Cancer (wdbc)|5299|5268|5196|5052|4661|4172|4032 300|3021 323|
|Segmentation|1423|1471|1377|1210|1103|1031|300|323|
|Ionosphere|2954|3002|2839|2430|2062|1836|1769|1884|


![image 5](<aggarwal2001/imageFile5.png>)

4

3.5

1 1.5 2 2.5 3 ACCURACY RATIO TO RANDOM MATCHING

3

2.5

2

1.5

1

ACCURACY OF RANDOM MATCHING

0.5

0

0

1

2

3

4

5

6

7

8

9

10

3 4 5 6 7 PARAMETER OF DISTANCE NORM USED

Fig. 5. Accuracy depending on the norm parameter

![image 6](<aggarwal2001/imageFile6.png>)

3.5

L(0.1) L(1)

L(10)

3

L(10)

2.5

1.5 2 ACCURACY RATIO

2

1.5

1

ACCURACY OF RANDOM MATCHING

0.5

0

0

0.1

0.2

0.3

0.4

0.5

0.6

0.7

0.8

0.9

1

0.4 0.5 0.6 0.7 NOISE MASKING PROBABILITY

Fig. 6. Accuracy depending on noise masking

In Figure 5, we have shown the variation in the accuracy of the class variable matching with k , when the L k norm is used. The accuracy on the Y -axis is reported as the ratio of the accuracy to that of a completely random matching scheme. The graph is averaged over all the data sets of Table 3. It is easy to see that there is a clear trend of the accuracy worsening with increasing values of the parameter k .

We also studied the robustness of the scheme to the use of noise masking. For this purpose, we have illustrated the performance of three distance metrics in Figure 6: L 0 . 1 , L 1 , and L 10 for various values of the masking probability on the machine data set. On the X -axis, we have denoted the value of the masking probability, whereas on the Y -axis we have the accuracy ratio to that of a completely random matching scheme. Note that when the masking probability is 1, then any scheme would degrade to a random method. However, it is interesting to see from Figure 6 that the L 10 distance metric degrades much faster to the

[Page 13]

random performance (at a masking probability of 0.4), whereas the L 1 degrades to random at 0.6. The L 0 . 1 distance metric is most robust to the presence of noise in the data set and degrades to random performance at the slowest rate. These results are closely connected to our theoretical analysis which shows the rapid lack of discrimination between the nearest and furthest distances for high values of the norm-parameter because of undue weighting being given to the noisy dimensions which contribute the most to the distance.

# 5 Conclusions and Summary

In this paper, we showed some surprising results of the qualitative behavior of the diﬀerent distance metrics for measuring proximity in high dimensionality. We demonstrated our results in both a theoretical and empirical setting. In the past, not much attention has been paid to the choice of distance metrics used in high dimensional applications. The results of this paper are likely to have a powerful impact on the particular choice of distance metric which is used from problems such as clustering, categorization, and similarity search; all of which depend upon some notion of proximity.

# References

- 1. Weber R., Schek H.-J., Blott S.: A Quantitative Analysis and Performance Study for Similarity-Search Methods in High-Dimensional Spaces. VLDB Conference Proceedings , 1998.
- 2. Bennett K. P., Fayyad U., Geiger D.: Density-Based Indexing for Approximate Nearest Neighbor Queries. ACM SIGKDD Conference Proceedings , 1999.
- 3. Berchtold S., B¨ ohm C., Kriegel H.-P.: The Pyramid Technique: Towards Breaking the Curse of Dimensionality. ACM SIGMOD Conference Proceedings , June 1998.
- 4. Berchtold S., B¨ ohm C., Keim D., Kriegel H.-P.: A Cost Model for Nearest Neighbor Search in High Dimensional Space. ACM PODS Conference Proceedings , 1997.
- 5. Berchtold S., Ertl B., Keim D., Kriegel H.-P. Seidl T.: Fast Nearest Neighbor Search in High Dimensional Spaces. ICDE Conference Proceedings , 1998.
- 6. Beyer K., Goldstein J., Ramakrishnan R., Shaft U.: When is Nearest Neighbors Meaningful? ICDT Conference Proceedings , 1999.
- 7. Shaft U., Goldstein J., Beyer K.: Nearest Neighbor Query Performance for Unstable Distributions. Technical Report TR 1388, Department of Computer Science, University of Wisconsin at Madison.
- 8. Guttman, A.: R-Trees: A Dynamic Index Structure for Spatial Searching. ACM SIGMOD Conference Proceedings , 1984.
- 9. Hinneburg A., Aggarwal C., Keim D.: What is the nearest neighbor in high dimensional spaces? VLDB Conference Proceedings , 2000.
- 10. Katayama N., Satoh S.: The SR-Tree: An Index Structure for High Dimensional Nearest Neighbor Queries. ACM SIGMOD Conference Proceedings , 1997.
- 11. Lin K.-I., Jagadish H. V., Faloutsos C.: The TV-tree: An Index Structure for High Dimensional Data. VLDB Journal , Volume 3, Number 4, pages 517–542, 1992.


[Page 14]

# Appendix

Here we provide a detailed proof of Lemma 2, which proves our modiﬁed convergence results for arbitrary distributions of points. This Lemma shows that the asymptotical rate of convergence of the absolute diﬀerence of distances between the nearest and furthest points is dependent on the distance norm used. To recap, we restate Lemma 2.

Lemma 2: Let F be an arbitrary distribution of N = 2 points. Then, lim d →∞ E   Dmax k d − Dmin k d d 1 /k − 1 / 2   = C k , where C k is some constant dependent on k . Proof. Let A d and B d be the two points in a d dimensional data distribution

such that each coordinate is independently drawn from the data distribution F . Speciﬁcally A d = ( P 1 ...P d ) and B d = ( Q 1 ...Q d ) with P i and Q i being drawn from F . Let PA d = {   d i =1 ( P i ) k } 1 /k be the distance of A d to the origin using the L k metric and PB d = {   d i =1 ( Q i ) k } 1 /k the distance of B d . We assume that the k th power of a random variable drawn from the dis-

tribution F has mean µ F ,k and standard deviation σ F ,k . This means that: PA k d d → p µ F ,k , PB k d d → p µ F ,k and therefore:

$$
\ P A _ { d } / d ^ { 1 / k } \to _ { p } ( \mu _ { \mathcal { F } , k } ) ^ { 1 / k } \, , \ \ P B _ { d } / d ^ { 1 / k } \to _ { p } ( \mu _ { \mathcal { F } , k } ) ^ { 1 / k } \, .
$$

We intend to show that | PA d − PB d | d 1 /k − 1 / 2 → p C k for some constant C k depending on k . We express | PA d − PB d | in the following numerator/denominator form which we will use in order to examine the convergence behavior of the numerator and denominator individually.

$$
| P A _ { d } - P B _ { d } | & = \frac { | ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } | } { \sum _ { r = 0 } ^ { k - 1 } ( P A _ { d } ) ^ { k - r - 1 } ( P B _ { d } ) ^ { r } } \\ \intertext { g b o t h s d i s e b y d ^ { 1 / k - 1 / 2 } a n d r e group ing o n r i g h t h a n d s i d e w e get }
$$

Dividing both sides by d 1 /k − 1 / 2 and regrouping on right-hand-side we get

$$
\text {g both sides by $d^{-}^{\prime}$} - \text {and regrouping on right-hand-side we get} \\ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / k - 1 / 2 } } = \frac { | ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } | / \sqrt { d } } { \sum _ { r = 0 } ^ { k - 1 } \left ( \frac { P A _ { d } } { d ^ { 1 / k } } \right ) ^ { k - r - 1 } \left ( \frac { P B _ { d } } { d ^ { \prime / k } } \right ) ^ { r } } \\ \text {quietly, using Slutsky's theorem and the results of Equation 14 we have: }
$$

  Consequently, using Slutsky’s theorem and the results of Equation 14 we have:

$$
\sum _ { r = 0 } ^ { k - 1 } \left ( P A _ { d } / d ^ { 1 / k } \right ) ^ { k - r - 1 } \cdot \left ( P B _ { d } / d ^ { 1 / k } \right ) ^ { r } \to _ { p } k \cdot ( \mu _ { \mathcal { F } , k } ) ^ { ( k - 1 ) / k } \\ \text {Using some generalized theorems, by definition of the denominator of the right}
$$

Having characterized the convergence behavior of the denominator of the righthand-side of Equation 16, let us now examine the behavior of the numerator: | ( PA d ) k − ( PB d ) k | / √ d = |   d i =1 (( P i ) k − ( Q i ) k ) | / √ d = |   d i =1 R i | / √ d . Here R i is the new random variable deﬁned by (( P i ) k − ( Q i ) k ) ∀ i ∈ { 1 ,...d } . This random variable has zero mean and standard deviation which is √ 2 · σ F ,k where σ F ,k is the standard deviation of ( P i ) k . Then, the sum of diﬀerent values

[Page 15]

$$
\lim _ { d \to \infty } E \left [ \frac { | ( P A _ { d } ) ^ { k } - ( P B _ { d } ) ^ { k } | } { \sqrt { d } } \right ] = C \cdot \sigma _ { \mathcal { F } , k } \\
$$

Since the denominator of Equation 16 shows probabilistic convergence, we can combine the results of Equations 17 and 18 to obtain:

$$
\lim _ { d \to \infty } E \left [ \frac { | P A _ { d } - P B _ { d } | } { d ^ { 1 / k - 1 / 2 } } \right ] = C \cdot \frac { \sigma _ { \mathcal { F } , k } } { k \cdot \mu _ { \mathcal { F } , k } ^ { ( k - 1 ) / k } }
$$

The result follows.

Confusion Matrices. We have illustrated the confusion matrices for two different values of p below. As illustrated, the confusion matrix for using the value p = 0 . 3 is signiﬁcantly better than the one obtained using p = 2.

Table 4. Confusion Matrixp=2, (rows for prototype, colums for cluster)

|1208|82|9711 4|4|10|14|
|---|---|---|---|---|---|
|0|2|0|0|6328 4|4|
|1|9872|104 74|32|11 0|0|
|8750|8|74|9954|1|18|
|39|0|10|8|8|9948|
|2|36|101|2|3642|16|


Table 5. Confusion Matrixp=0.3, (rows for prototype, colums for cluster)

|51|115|9773|10|37|15|
|---|---|---|---|---|---|
|0|17|24 0|0|9935|14|
|15 1|10|9|9962 0|0|4|
|1|9858|66|5|19|1|
|8|0|9|3|9|9956|
|9925|0|119|20|0|10|


