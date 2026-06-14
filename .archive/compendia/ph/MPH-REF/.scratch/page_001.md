[Page 1]

# Chapter 9

## Multiparameter persistence

This chapter closely follows the introductory paper [ 2 ] on multiparameter persistence. The interested reader is referred there for a (much) more comprehensive overview of the topic.

As we have seen, the persistence modules arising from the Čech or Vietoris-Rips complexes are stable under small perturbations of the underlying data, but not robust . That is, even a small number of outliers can drastically change the persistence diagram or barcode. We could try to remedy this problem by making these complexes density-aware in some way. For the Vietoris-Rips complex, a typical way to do this is as follows. For a vertex v in a simplicial complex, its degree deg ( v ) is the number of edges ( 1 -simplices) in the complex that contain v . Then. for d 2 , the degreed Vietoris-Rips complex is

r d ( X ) : = { 2 r ( X ) : each vertex of has degree at least d } .

Note that vertices corresponding to data points in high-density areas of X will have relatively higher degree, whereas outliers will have relatively lower degree. Thus, for d large enough, we should expect this modiﬁcation to reduce the impact of outliers. On the other hand, if d is too large, we are ‘throwing away the baby with the bathwater’. So, the question is: how to choose d ? Here, we run into the same issue that originally motivated persistence: there might not be one choice of d that accurately reﬂects the entire data set. Even if this choice would exist, it might be hard to determine. Instead, we would like to consider all choices of d simultaneously. The solution is to look at persistence w.r.t. both the scale parameter r and the density parameter d at the same time. In this chapter, we formalize such multiparameter persistence, and take a look at the representability and robustness of the resulting multiparameter persistence modules .

## 9.1 Persistence modules indexed by a poset

A persistence module (indexed by ) consists of a family of vectors spaces U a , a 2 , together with commuting maps U a ! U b for a 6 b . If we want to deﬁne persistence
