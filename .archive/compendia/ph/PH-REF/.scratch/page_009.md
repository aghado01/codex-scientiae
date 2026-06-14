[Page 9]

(ii) The bottleneck metric is a L ∞ -like metric. It turns out to be the natural one to express stability properties of persistence diagrams presented in Section 5, but it suﬀers from the same drawbacks as the usual L ∞ norms, i.e. it is completely determined by the largest distance among the pairs and do not take into account the closeness of the remaining pairs of points. A variant, to overcome this issue, the so-called Wasserstein distance between diagrams is sometimes considered. Given p 1, it is deﬁned by

$$
W _ { p } ( d g m _ { 1 } , d g m _ { 2 } ) ^ { p } = \inf _ { \text {matching} } \sum _ { ( p , q ) \in m } \| p - q \| _ { \infty } ^ { p } .
$$

Useful stability results for persistence in the metric W p exist among the literature, but they rely on assumptions that make them consequences of the stability results in the bottleneck metric.

## 5. Stability

5.1. A General Result. A fundamental property of persistence homology is that persistence diagrams of ﬁltrations built on top of data sets turn out to be very stable with respect to some perturbations of the data. To formalize and quantify such stability properties, we ﬁrst need to precise the notion of perturbation that are allowed.

Rather than working directly with ﬁltrations built on top of data sets, it turns out to be more convenient to deﬁne a notion of proximity between persistence module from which we will derive a general stability result for persistent homology. Then, most of the stability results for speciﬁc ﬁltrations will appear as a consequence of this general theorem. To avoid technical discussions, from now on we assume, without loss of generality, that the considered persistence modules are indexed by R .

Deﬁnition 5.1 (Homomorphism of Persistence Modules) . Let V , W be two persistence modules indexed by R . Given δ ∈ R , a homomorphism of degree δ between V and W is a collection Φ of linear maps φ r : V r → W r + δ , for all r ∈ R such that the following diagram commutes:


![image 8](<PH-REF/imageFile8.png>)



/

/









"

"

"

"

/

/



+

+






+




+


$$
T h a t \text { is, for all } r \leqslant s , \, \phi _ { s } \circ v _ { s } ^ { r } = w _ { s + \delta } ^ { r + \delta } \circ \phi _ { r } .
$$

An important example of homomorphism of degree δ is the shift endomorphism 1 δ V which consists of the families of linear maps φ r = v r r + δ . Notice also that homomorphisms of persistence modules can naturally be composed: the composition of a homomorphism Ψ of degree δ between U and V and a homomorphism Φ of degree δ between V and W naturally gives rise to a homomorphism ΦΨ of degree δ + δ between U and W .
