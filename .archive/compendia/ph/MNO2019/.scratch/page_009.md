[Page 9]

where W is the indicator function of the wedge W . ‘

Consider a random persistence diagram D X as in (M2) and a collection of observed PDs { D Y 1 , ··· ,D Y m } that are independent samples from Poisson PP characterizing the PD D Y in (M3). We denote D Y 1: m := ∪ m i =1 D Y i . Below we specialize (M2) and (M3) so that applying Theorem 3.1 to a mixed Gaussian prior intensity yields a mixed Gaussian posterior:

(M2 ) D X = D X O ∪ D X V , where D X O and D X V are independent Poisson PPs with intensities αλ D X ( x ) and (1 − α ) λ D X ( x ), respectively, with N

$$
\lambda _ { \mathcal { D } _ { X } } ( x ) = \sum _ { j = 1 } ^ { N } c _ { j } ^ { \mathcal { D } _ { X } } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { \mathcal { D } _ { X } } , \sigma _ { j } ^ { \mathcal { D } _ { X } } I ) , \\ \intertext { b e r o f m i ture c o n n t e r s }
$$

j =1 where N is the number of mixture components.

(M3 ) D Y = D Y O ∪ D Y S where

- (i) the marked Poisson PP ( D X O , D Y O ) has density   ( y | x ) given by

$$
\ell ( y | x ) = \mathcal { N } ^ { * } ( y ; x , \sigma ^ { \mathcal { D } _ { Y } } o \, I ) .
$$

- (ii) D Y O and D Y S are independent ﬁnite Poisson PPs and D Y S has intensity function given below.


$$
\lambda _ { \mathcal { D } _ { Y _ { S } } } ( y ) = \sum _ { k = 1 } ^ { M } c _ { k } ^ { \mathcal { D } _ { Y _ { S } } } \mathcal { N } ^ { * } ( y ; \mu _ { k } ^ { \mathcal { D } _ { Y _ { S } } } , \sigma _ { k } ^ { \mathcal { D } _ { Y _ { S } } } I ) ,
$$

where M is the number of mixture components.

Proposition 3.1. Suppose that the assumptions (M1),(M2 ), and (M3 ) hold; then, the posterior intensity of Equation (3) in Theorem 3.1 is a Gaussian mixture of the form

$$
\begin{array} { r l } & { \text {Equation} \, ( 3 ) \, i n \, T h e o r m \, 3 . 1 \, i s \, a \, G a u s i s i n \, m i x t u r e \, o f t h e \, f o r m } \\ & { \quad \lambda _ { D _ { X } | D _ { Y } _ { 1 } , m } ( x ) = ( 1 - \alpha ) \lambda _ { D _ { X } } ( x ) + \frac { \alpha } { m } \sum _ { i = 1 } ^ { m } \sum _ { y \in \mathcal { D } _ { Y } } \sum _ { j = 1 } ^ { N } C _ { j } ^ { y } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) , } \\ & { \quad w h e r e \quad C _ { j } ^ { y } = \frac { w _ { j } ^ { y } } { \lambda _ { D _ { Y } _ { s } } ( y ) + \alpha \sum _ { j = 1 } ^ { N } w _ { j } ^ { y } Q _ { j } } ; \, Q _ { j } ^ { y } = \int _ { W } \mathcal { N } ( u ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) d u ; } \\ & { \quad w _ { j } ^ { y } = c _ { j } ^ { X } \mathcal { N } ( y ; \mu _ { j } ^ { X } x , ( \sigma _ { j } ^ { Y _ { o } } + \sigma _ { j } ^ { D _ { X } } ) I ) ; } \\ & { \quad a n d \quad \mu _ { j } ^ { X } = \frac { \sigma _ { j } ^ { D _ { X } } y + \sigma ^ { D _ { Y } o } \mu _ { j } ^ { X } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } ; \sigma _ { j } ^ { y } = \frac { \sigma ^ { D _ { Y } o } \, \sigma _ { j } ^ { D _ { X } } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } . } \\ & { \quad T h e \, \pro f o r \, \text {Proposition} \, 3 . 1 \, f o l lows \, from \, w e l l \, k n w n \, r e s l u t s \, a b o u t \, \text {products of Gaussian densities given} } \end{array}
$$

The proof of Proposition 3.1 follows from well known results about products of Gaussian densities given below; for more details, the reader may refer to [37] and references therein.

Lemma 3.1. For p × p matrices H,R,P , with R and P positive deﬁnite ,and a p × 1 vector s , N ( y ; Hx,R ) N ( x ; s,P ) = q ( y ) N ( x ; ˆ s, ˆ P ) , where q ( y ) = N ( y ; Hs,R + HPH T ) , ˆ s = s + K ( y − Hs ) , ˆ P = ( I − KH ) P and K = PH T ( HPH T + R ) − 1 .

Proof of Proposition 3.1. Using Lemma 3.1, we ﬁrst derive   ( y | x ) λ D X ( x ) by observing that, in our model, H = I,R = σ D Y O I,s = µ D X j and P = σ D X j I . By typical matrix operations we obtain, K = σ D X j σ D X j + σ D Y O , ˆ s = σ D X j y + σ D Y O µ D X j σ X j + σ D Y O , and ˆ P = σ D Y O σ D X j σ D X j + σ D Y O . Hence the numerator and denominator of the second term in Equation (3),   N j =1 c D X j N ( y ; µ D X j , ( σ D Y O + σ D X j ) I ) N ∗ ( x ; µ y j ,σ y j I ), and λ D Y S ( y )+ α   N j =1 c D X j N ( y ; µ D X j , ( σ D Y O + σ D X j ) I )   W N ( u ; mu y j ,σ y j I ) du, respectively, yield
