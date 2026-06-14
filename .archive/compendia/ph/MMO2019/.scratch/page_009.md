[Page 9]

As with typical derivatives, there is a complementary set integration operation for set derivatives. Set derivatives (at ∅ ) are essentially Radon-Nikody´m derivatives with order tied to cardinality, and so the corresponding set integral acts like Lebesgue integration summed over each cardinality.

Deﬁnition 12 Consider a Borel subset A of W 0: − 1 and a Borel subset O of C ≤ M ( W 0: − 1 ) . For a set function f : C ≤ M ( W 0: − 1 ) → R , its set integrals over A and O are respectively deﬁned according to the following sums of Lebesgue integrals:

$$
\int _ { A } f ( Z ) \delta Z = \sum _ { N = 0 } ^ { M } \frac { 1 } { N ! } \int _ { A ^ { N } } f ( h _ { N } ( \xi _ { 1 } , \dots , \xi _ { N } ) ) d \xi _ { 1 } \dots d \xi _ { N } ,
$$

$$
\int _ { O } f ( Z ) \delta Z = \sum _ { N = 0 } ^ { M } \frac { 1 } { N ! } \int _ { h _ { N } ^ { - 1 } ( O ) } f ( h _ { N } ( \xi _ { 1 } , \dots , \xi _ { N } ) ) d \xi _ { 1 } \dots d \xi _ { N } ,
$$

where Z = { ξ 1 ,...,ξ N } ⊂ W 0: − 1 is a persistence diagram.

Dividing by N ! in Eqs. (3.5a) and (3.5b) accounts for integrating over W N 0: − 1 instead of W N 0: − 1 / Π N ∼ = C N ( W 0: − 1 ). It has been shown that set derivatives and integrals are inverse operations (Matheron, 1975); speciﬁcally, the set derivative of a belief function yields a probability density for a random diagram D such that

$$
\beta _ { D } ( A ) = \int _ { A } \frac { \delta \beta _ { D } } { \delta Z } ( \emptyset ) \delta Z .
$$

Indeed, A N = h − 1 N ( { D ⊂ A } ) so that Eq. (3.5a) also holds as an integral over the set O A = { D ∈ C ≤ M : D ⊂ A } in the sense of Eq. (3.5b).

Deﬁnition 13 For a random persistence diagram D , a global probability density function (global pdf) f D : ∪ N ∈ N W N 0: − 1 → R must satisfy

$$
\sum _ { \pi \in \Pi _ { N } } f _ { D } ( \xi _ { \pi ( 1 ) } , \dots , \xi _ { \pi ( N ) } ) = \frac { \delta ^ { N } \beta _ { D } } { \delta \xi _ { 1 } \cdots \delta \xi _ { N } } ( \emptyset ) .
$$

and is described by its layered restrictions f N = f D W N 0: − 1 : W N 0: − 1 → R for each N .

Remark 14 It is necessary to make a distinction between local and global densities because the global pdf is not deﬁned on a single Euclidean space, and is instead expressed as a collection of densities over a range of dimensions. Speciﬁcally, while each local density f N (for input cardinality N ) is deﬁned on W N 0: − 1 , the global pdf f D is deﬁned on ∪ M N =1 W N 0: − 1 and restricts to a local density on each input dimension. Each local density f N ( Z ) = f D   W N 0: − 1 ( Z ) decomposes into the product of the conditional density f D ( Z   | Z | = N ) and the cardinality probability P [ | Z | = N ] (this follows from Proposition 16). Thus, each local density does not integrate to one, but instead to the associated probability P [ | Z | = N ] . Also, the global pdf is not a set function and does not require division by N ! , leading to the following relation:   A N f D ( ξ 1 ,...,ξ N ) dξ 1 ...dξ N = 1 N !   A N δ N β D δ N Z ( ∅ ) dξ 1 ...dξ N .
