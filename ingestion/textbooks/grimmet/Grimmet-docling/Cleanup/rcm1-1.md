Geoffrey Grimmett

# The Random-Cluster Model

With 37 Figures

### Springer

Geoffrey Grimmett Statistical Laboratory Centre for Mathematical Sciences University of Cambridge Wilberforce Road Cambridge CB3 0WB United Kingdom

Mathematics Subject Classiﬁcation (2000): 60K35, 82B20, 82B43

![image 1](<rcm1-1_images/imageFile1.png>)

F K

Kees Fortuin (1971)

Piet Kasteleyn (1968)

## Preface

Therandom-clustermodelwasinventedbyCees[Kees]FortuinandPietKasteleyn around 1969 as a uniﬁcation of percolation, Ising, and Potts models, and as an extrapolation of electrical networks. Their original motivation was to harmonize the series and parallel laws satisﬁed by such systems. In so doing, they initiated a study in stochastic geometry which has exhibited beautiful structure in its own right, and which has become a central tool in the pursuit of one of the oldest challenges of classical statistical mechanics, namely to model and analyse the ferromagnet and especially its phase transition.

The importance of the model for probability and statistical mechanics was not fully recognized until the late 1980s. There are two reasons for this period of dormancy. Although the early publications of 1969–1972 contained many of the basic properties of the model, the emphasis placed there upon combinatorial aspects may have obscured its potential for applications. In addition, many of the geometrical arguments necessary for studying the model were not known prior to 1980, but were developed during the ‘decade of percolation’ that began

then. In 1980 was published the proof that pc = 21 for bond percolation on the square lattice, and this was followed soon by Harry Kesten’s monograph on two-

![image 2](<rcm1-1_images/imageFile2.png>)

dimensional percolation. Percolation moved into higherdimensions around 1986, and many of the mathematical issues of the day were resolved by 1989. Interest in the random-cluster model as a tool for studying the Ising/Potts models was rekindled around 1987. Swendsen and Wang utilized the model in proposing an algorithm for the time-evolutionof Potts models; Aizenman, Chayes, Chayes, and Newman used it to show discontinuity in long-range one-dimensional Ising/Potts models; Edwards and Sokal showed how to do it with coupling.

One of my main projects since 1992 has been to comprehend the (in)validity of the mantra ‘everything worth doing for Ising/Potts is best done via randomcluster’. There is a lot to be said in favour of this assertion, but its unconditionality is its weakness. The random-clusterrepresentationhasallowedbeautifulproofsof importantfacts including: the discontinuity of the phase transition forlarge values ofthecluster-factorq,theexistenceofnon-translation-invariant‘Dobrushin’ states for large values of the edge-parameter p, the Wulff construction in two and more dimensions,andsoon. Ithasplayedimportantrolesinthestudiesofotherclassical

and quantum systems in statistical mechanics, including for example the Widom– Rowlinson two-typelattice gasand the Edwards–Andersonspin-glassmodel. The lastmodelisespecially challenging because itisnon-ferromagnetic,and thusgives rise to new problems of importance and difﬁculty.

The random-cluster model is however only one of the techniques necessary for the mathematical study of ferromagnetism. The principal illustration of its limitations concerns the Ising model. This fundamental model for a ferromagnet has exactly two local states, and certain special features of the number 2 enable a beautiful analysis via the so-called ‘random-current representation’ which does not appear to be reproducible by random-cluster arguments.

In pursuing the theory of the random-cluster model, I have been motivated not only by its applications to spin systems but also because it is a source of beautiful problems in its own right. Such problems involve the stochastic geometry of interacting lattice systems, and they are close relatives of those treated in my monograph on percolation, published ﬁrst in 1989 and in its second edition in 1999. There are many new complications and some of the basic questions remain unanswered, at least in part. The currentwork is primarilyan exposition of a fairly mature theory, but prominence is accorded to open problems of signiﬁcance.

New problemshavearrivedrecentlyto join the old, and these concernprimarily the two-dimensional phase transition and its relation to the theory of stochastic Lowner¨ evolutions. SLE has been much developed for percolation and related topics since the 1999 edition of Percolation, mostly through the achievements of Schramm, Smirnov, Lawler, and Werner. We await an extension of the mathematics of SLE to random-cluster and Ising/Potts models.

Here are some remarks on the contents of this book. The setting for the vast majority of the work reported here is the d-dimensional hypercubic lattice Zd where d ≥ 2. This has been chosen for ease of presentation, and may usually be replaced by any other ﬁnite-dimensional lattice in two or more dimensions, although an extra complication may arise if the lattice is not vertex-transitive. An exception to this is found in Chapter 6, where the self-duality of the square lattice is exploited.

Following the introductory material of Chapter 1, the fundamental properties of monotonic and random-cluster measures on ﬁnite graphs are summarized in Chapters 2 and 3, including accounts of stochastic ordering, positive association, and exponential steepness.

A principal feature of the model is the presence of a phase transition. Since singularities may occur only on inﬁnite graphs, one requires a deﬁnition of the random-cluster model on an inﬁnite graph. This may be achieved as for other systemseitherbypassingtoaninﬁnite-volumeweaklimit, orbystudyingmeasures which satisfy consistency conditions of Dobrushin–Lanford–Ruelle (DLR) type. Inﬁnite-volume measures in their two forms are studied in Chapter 4.

The percolation probability is introduced in Chapter 5, and this leads to a study of the phase transition and the critical point pc(q). When p < pc(q), one expects

Preface ix

that the size of the open cluster containing a given vertex of Zd is controlled by exponentially-decaying probabilities. This is unproven in general, although exponential decay is proved subject to a further condition on the parameter p.

The supercritical phase, when p > pc(q), has been the scene of recent major developments for random-cluster and Ising/Potts models. A highlight has been the proof of the so-called ‘Wulff construction’ for supercritical Ising models. A version of the Wulff construction is valid for the random-cluster model subject to a stronger condition on p, namely that p > pc(q) where pc(q) is (for d ≥ 3) the limit of certain slab critical points. We have no proof that pc(q) = pc(q) except when q = 1,2, and to prove this is one of the principal open problems of the day. A second problemis to provethe uniquenessof the inﬁnite-volumelimit whenever p  = pc(q).

The self-duality of the two-dimensional square lattice Z2 is complemented by a duality relation for random-cluster measures on planar graphs, and this allows a fuller understanding of the two-dimensional case, as described in Chapter 6. There remain important open problems, of which the principal one is to obtain a clear proof of the ‘exact calculation’ pc(q) =

√q). This calculation is accepted by probabilists when q = 1 (percolation), q = 2 (Ising), and when q is large, but the “exact solutions” of theoretical physics seem to have no complete counterpartin rigorousmathematics for generalvalues of q satisfying q ∈ [1,∞). There is strong evidence that the phase transition with d = 2 and q ∈ [1,4) will be susceptible to an analysis using SLE, and this will presumably enable in due course a computation of its critical exponents.

√q/(1 +

![image 3](<rcm1-1_images/imageFile3.png>)

![image 4](<rcm1-1_images/imageFile4.png>)

InChapter7,weconsiderdualityinthreeandmoredimensions. Thedualmodel amountstoaprobabilitymeasureonsurfacesandcertaintopologicalcomplications arise. Two signiﬁcant facts are proved. First, it is proved for sufﬁciently large q thatthephasetransitionisdiscontinuous. Secondly,itisprovedfor q ∈ [1,∞)and sufﬁciently large p that there exist non-translation-invariant ‘Dobrushin’ states.

The model has been assumed so far to be static in time. Time-evolutions may be introduced in several ways, as described in Chapter 8. Glauber dynamics and the Gibbs sampler are discussed, followed by the Propp–Wilson scheme known as ‘coupling from the past’. The random-cluster measures for different values of p may be coupled via the equilibrium measure of a suitable Markov process on [0,1]E, where E denotes the set of edges of the underlying graph.

Theso-called‘random-currentrepresentation’wasremarkedabovefortheIsing model, and a related representation using the ‘ﬂow polynomial’ is derived in Chapter 9 for the q-state Potts model. It has not so far proved possible to exploit this in a full study of the Potts phase transition. In Chapter 10, we consider the random-cluster model on graphs with a different structure than that of ﬁnitedimensional lattices, namely the complete graph and the binary tree. In each case one may perform exact calculations of mean-ﬁeld type.

The ﬁnal Chapter 11 is devoted to applications of the random-cluster representation to spin systems. Five such systems are described, namely the Potts

and Ashkin–Teller models, the disordered Potts model, the spin-glass model of Edwards and Anderson, and the lattice gas of Widom and Rowlinson.

There is an extensive literature associated with ferromagnetism, and I have not aspired to a complete account. Salient references are listed throughout this book, but inevitably there are omissions. Amongst earlier papers on random-cluster models, the following include a degree of review material: [8, 44, 136, 149, 156, 169, 240].

I ﬁrst encountered the random-cluster model one day in late 1971 when John Hammersley handed me Cees Fortuin’s thesis. Piet Kasteleyn responded enthusiastically to my 1992 request for information about the history of the model, and his letters are reproduced with his permission in the Appendix. The responses from fellow probabilists to my frequent requests for help and advice have been deeply appreciated, and the supportof the communityis gratefullyacknowledged. I thank Laantje Kasteleyn and Frank den Hollander for the 1968 photograph of Piet, andCees Fortuinforsendingme a copyof the imagefromhis1971California driving licence. Raphael¨ Cerf kindly offered guidance on the Wulff construction, and has supplied some of his beautiful illustrations of Ising and random-cluster models, namely Figures 1.2 and 5.1. A number of colleagues have generously commented on parts of this book, and I am especially grateful to Rob van den Berg, Benjamin Graham, Olle Haggstr¨ om,¨ Chuck Newman, Russell Lyons, and Senya Shlosman. Jeff Steif has advised me on ergodic theory, and Aernout van Enter has helped me with statistical mechanics. Catriona Byrne has been a source of encouragement and support. I express my thanks to these and to others who have, perhaps unwittingly or anonymously, contributed to this volume.

G. R. G.

Cambridge January 2006

Note added at reprinting: Several friends and colleagues have kindly made suggestions for improvements, and special mention is made of Markus Heydenreich (and the reading group at the Technische Universiteit Eindhoven), Remco van der Hofstad, Kenshi Hosaka, and Svante Janson.

May 2009

## Contents

1 Random-Cluster Measures 1

1.1 Introduction . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 1 1.2 Random-cluster model ... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 4 1.3 Ising and Potts models . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 6 1.4 Random-cluster and Ising/Potts models coupled . . .. . .. . .. . . .. . 8 1.5 The limit as q ↓ 0 . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 13 1.6 Basic notation . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 15

2 Monotonic Measures 19

2.1 Stochastic ordering of measures.. .. . .. . .. . .. . .. . .. . .. . .. . . .. . 19 2.2 Positive association ... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 25 2.3 Inﬂuence for monotonic measures.. . .. . .. . .. . .. . .. . .. . .. . . .. . 30 2.4 Sharp thresholds for increasing events . . .. . .. . .. . .. . .. . .. . . .. . 33 2.5 Exponential steepness . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 35

3 Fundamental Properties 37

3.1 Conditional probabilities . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 37 3.2 Positive association ... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 39 3.3 Differential formulae and sharp thresholds . .. . .. . .. . .. . .. . . .. . 40 3.4 Comparison inequalities . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 43 3.5 Exponential steepness . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 49 3.6 Partition functions .. .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 53 3.7 Domination by the Ising model . . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 57 3.8 Series and parallel laws .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 61 3.9 Negative association .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 63

4 Inﬁnite-Volume Measures 67

4.1 Inﬁnite graphs . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 67 4.2 Boundary conditions.. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 70 4.3 Inﬁnite-volume weak limits . . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 72 4.4 Inﬁnite-volume random-cluster measures . . .. . .. . .. . .. . .. . . .. . 78 4.5 Uniqueness via convexity of pressure .. . .. . .. . .. . .. . .. . .. . . .. . 85 4.6 Potts and random-cluster models on inﬁnite graphs . . .. . .. . . .. . 95

xii Contents

5 Phase Transition 98

5.1 The critical point .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 98 5.2 Percolation probabilities . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 102 5.3 Uniqueness of random-cluster measures .. . .. . .. . .. . .. . .. . . .. . 107 5.4 The subcritical phase . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 110 5.5 Exponential decay of radius . . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 113 5.6 Exponential decay of volume . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 119 5.7 The supercritical phase and the Wulff crystal . . .. . .. . .. . .. . . .. . 122 5.8 Uniqueness when q < 1 . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 131

6 In Two Dimensions 133

6.1 Planar duality .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 133 6.2 The value of the critical point ... . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 138 6.3 Exponential decay of radius . . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 143 6.4 First-order phase transition .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 144 6.5 General lattices in two dimensions . . .. . .. . .. . .. . .. . .. . .. . . .. . 152 6.6 Square, triangular, and hexagonal lattices . . .. . .. . .. . .. . .. . . .. . 154 6.7 Stochastic Lowner¨ evolutions ... . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 164

7 Duality in Higher Dimensions 167

7.1 Surfaces and plaquettes .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 167 7.2 Basic properties of surfaces . . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 169 7.3 A contour representation . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 173 7.4 Polymer models ... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 179 7.5 Discontinuous phase transition for large q . .. . .. . .. . .. . .. . . .. . 182 7.6 Dobrushin interfaces.. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 195 7.7 Probabilistic and geometric preliminaries . . .. . .. . .. . .. . .. . . .. . 199 7.8 The law of the interface .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 202 7.9 Geometry of interfaces ... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 208 7.10 Exponential bounds for group probabilities... . .. . .. . .. . .. . . .. . 215 7.11 Localization of interface . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 218

8 Dynamics of Random-Cluster Models 222

8.1 Time-evolution of the random-cluster model . . .. . .. . .. . .. . . .. . 222 8.2 Glauber dynamics . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 224 8.3 Gibbs sampler . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 225 8.4 Coupling from the past... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 227 8.5 Swendsen–Wang dynamics .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 230 8.6 Coupled dynamics on a ﬁnite graph . .. . .. . .. . .. . .. . .. . .. . . .. . 232 8.7 Box dynamics with boundary conditions .. . .. . .. . .. . .. . .. . . .. . 237 8.8 Coupled dynamics on the inﬁnite lattice .. . .. . .. . .. . .. . .. . . .. . 240 8.9 Simultaneous uniqueness.. .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 255

Contents xiii

9 Flows in Poisson Graphs 257

9.1 Potts models and ﬂows... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 257 9.2 Flows in the Ising model . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 262 9.3 Exponential decay for the Ising model .. .. . .. . .. . .. . .. . .. . . .. . 273 9.4 The Ising model in four and more dimensions . .. . .. . .. . .. . . .. . 274

10 On Other Graphs 276

10.1 Mean-ﬁeld theory . . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 276 10.2 On complete graphs .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 277 10.3 Main results for the complete graph . .. . .. . .. . .. . .. . .. . .. . . .. . 281 10.4 The fundamental proposition . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 284 10.5 The size of the largest component .. . .. . .. . .. . .. . .. . .. . .. . . .. . 286 10.6 Proofs of main results for complete graphs . .. . .. . .. . .. . .. . . .. . 289 10.7 The nature of the singularity .. .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 295 10.8 Large deviations .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 296 10.9 On a tree . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 299 10.10 The critical point for a tree .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 305 10.11 (Non-)uniqueness of measures on trees . .. . .. . .. . .. . .. . .. . . .. . 313 10.12 On non-amenable graphs .. .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 315

11 Graphical Methods for Spin Systems 320

11.1 Random-cluster representations .. .. . .. . .. . .. . .. . .. . .. . .. . . .. . 320 11.2 The Potts model... . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 321 11.3 The Ashkin–Teller model . .. . .. . .. . .. . .. . .. . .. . .. . .. . .. . . .. . 326 11.4 The disordered Potts ferromagnet .. . .. . .. . .. . .. . .. . .. . .. . . .. . 330 11.5 The Edwards–Anderson spin-glass model .. .. . .. . .. . .. . .. . . .. . 333 11.6 The Widom–Rowlinson lattice gas . . .. . .. . .. . .. . .. . .. . .. . . .. . 337

Appendix. The Origins of FK(G) 341 List of Notation 350 References 353 Index 374

## Chapter 1 Random-Cluster Measures

Summary. The random-cluster model is introduced, and its relationship to Ising and Potts models is presented via a coupling of probability measures. In the limit as the cluster-weighting factor tends to 0, one arrives at electrical networks and uniform spanning trees and forests.

1.1 Introduction

In 1925came the Isingmodelfora ferromagnet,andin 1957the percolationmodel foradisorderedmedium. Eachhassincebeenthesubjectofintensestudy,andtheir theories have become elaborate. Each possesses a phase transition marking the onset of long-range order, deﬁned in terms of correlation functions for the Ising model and in terms of the unboundedness of paths for percolation. These two phase transitions have been the scenes of notable exact (and rigorous) calculations which have since inspired many physicists and mathematicians.

It has been known since at least 1847 that electrical networks satisfy so-called ‘series/parallel laws’. Piet Kasteleyn noted during the 1960s that the percolation and Ising models also have such properties. This simple observation led in joint work with Cees Fortuin to the formulation of the random-cluster model. This new model has two parameters, an ‘edge-weight’ p and a ‘cluster-weight’ q. The (bond) percolation model is retrieved by setting q = 1; when q = 2, we obtain a representation of the Ising model, and similarly of the Potts model when q = 2,3,. . . . The discovery of the model is described in Kasteleyn’s words in the Appendix of the current work.

The mathematics begins with a ﬁnite graph G = (V, E), and the associated Ising model1 thereon. A random variable σx taking values −1 and +1 is assigned to each vertex x of G, and the probability of the conﬁguration σ = (σx : x ∈ V) is taken to be proportional to e−βH(σ), where β > 0 and the ‘energy’ H(σ) is the

![image 5](<rcm1-1_images/imageFile5.png>)

1The so-called Ising model [190] was in fact proposed (to Ising) by Lenz. The Potts model [105, 278] originated in a proposal (to Potts) by Domb.

2 Random-Cluster Measures [1.1]

negativeof the sum of σxσy overall edges e = x, y of G. As β increases, greater probability is assigned to conﬁgurations having a large number of neighbouring pairs of vertices with equal signs. The Ising model has proved extraordinarily successful in generating beautiful mathematics of relevance to the physics, and it has been useful and provocative in the mathematical theory of phase transitions and cooperative phenomena (see, for example, [118]). The proof of the existence of a phase transition in two dimensions was completed by Peierls, [266], by way of his famous “argument”.

Thereare manypossiblegeneralizationsofthe Ising modelin whichthe σx may take a generalnumber q of values, ratherthan q = 2 only. One such extension, the so-called ‘Potts model’, [278], has attracted especial interest amongst physicists, and has displayed a complex and varied structure. For example, when q is large, it possesses a discontinuousphase transition, in contrast to the continuoustransition believedto take place forsmall q. Ising/Pottsmodelsare the ﬁrst of three principal ingredients in the story of random-cluster models. Note that they are ‘vertexmodels’ in the sense that they involve random variables σx indexed by the vertices x of the underlying graph. (There is a related extension of the Ising model due to Ashkin and Teller, [21], see Section 11.3.)

The (bond) percolation model was inspired by problems of physical type, and emerged from the mathematics literature2 of the 1950s, [70]. In this model for a porous medium, each edge of the graph G is declared ‘open’ (to the passage of ﬂuid) with probability p, and ‘closed’ otherwise, different edges having independent states. The problem is to determine the typical large-scale properties of connected components of open edges as the parameter p varies. Percolation theory is now a mature part of probability lying at the core of the study of random media and interacting systems, and it is the second ingredient in the story of random-clustermodels. Note that bond percolation is an ‘edge-model’, in that the randomvariablesare indexedby the set ofedgesof the underlyinggraph. (Thereis a variant termed ‘site percolation’ in which the vertices are open/closed at random rather than the edges, see [154, Section 1.6].)

The theory of electrical networks on the graph G is of course more ancient than that of Ising and percolation models, dating back at least to the 1847 paper, [215], in which Kirchhoff set down a method for calculating macroscopic properties of an electrical network in terms of its local structure. Kirchhoff’s work explains in particular the relevance of counts of certain types of spanning trees of the graph. To import current language, an electrical network on a graph G may be studied via the properties of a ‘uniformly random spanning tree’ (UST) on G (see [31]).

The three ingredients above seemed fairly distinct until Fortuin and Kasteleyn discovered around 1970, [120, 121, 122, 123, 203], that each features within a certain parametric family of models which they termed ‘random-cluster models’. They developed the basic theory of such models — correlation inequalities and the like — in this series of papers. The true power of random-cluster models as

![image 6](<rcm1-1_images/imageFile6.png>)

2See also the historical curiosity [323].

[1.1] Introduction 3

a mechanism for studying Ising/Potts models has emerged progressively over the intervening three decades.

The conﬁguration space of the random-cluster model is the set of all subsets of the edge-set E, which we represent as the set = {0,1}E of 0/1-vectors indexed by E. An edge e is termed open in the conﬁguration ω ∈ if ω(e) = 1, and it is termed closed if ω(e) = 0. The random-cluster model is thus an edge-model, in contrast to the Ising and Potts models which assign spins to the vertices of G. The subject of current study is the subgraph of G induced by the set of open edges of a conﬁguration chosen at random from according to a certain probability measure. Of particular importance is the existence (or not) of paths of open edges joining given vertices x and y, and thus the random-cluster model is a model in stochastic geometry.

The model may be viewed as a parametric family of probability measures φp,q on , the two parameters being denoted by p ∈ [0,1] and q ∈ (0,∞). The parameter p amounts to a measure of the density of open edges, and the parameter q is a ‘cluster-weighting’ factor. When q = 1, φp,q is a product measure, and the ensuing probabilityspace is usually termed a percolationmodelor a randomgraph dependingon the context. The integervalues q = 2,3,. . . correspondin a certain way to the Potts model on G with q local states, and thus q = 2 correspondsto the Ising model. The nature of these ‘correspondences’,as described in Section 1.4, is that ‘correlation functions’ of the Potts model may be expressed as ‘connectivity functions’ of the random-clustermodel. When extendedto inﬁnite graphs, it turns out that long-range order in a Potts model corresponds to the existence of inﬁnite clusters in the corresponding random-cluster model. In this sense the Potts and percolation phase transitions are counterparts of one another.

Therein lies a major strength of the random-cluster model. Geometrical methods of some complexity have been derived in the study of percolation, and some of these may be adapted and extended to more general random-cluster models, therebyobtainingresults of signiﬁcance forIsing and Potts models. Such has been the value of the random-cluster model in studying Ising and Potts models that it is sometimes called simply the ‘FK representation’ of the latter systems, named after Fortuin and Kasteleyn. We shall see in Chapter 11 that several other spin models of statistical mechanics possess FK-type representations.

The random-cluster and Ising/Potts models on the graph G = (V, E) are deﬁned formally in the next two sections. Their relationship is best studied via a certain coupling on the product {0,1}E × {1,2,. . .,q}V, and this coupling is described in Section 1.4. The ‘uniform spanning-tree’ (UST) measure on G is a limiting case of the random-cluster measure, and this and related limits are the topic of Section 1.5. This chapter ends with a section devoted to basic notation.

4 Random-Cluster Measures [1.2]

1.2 Random-cluster model

Let G = (V, E) be a ﬁnite graph. The graphsconsideredhere will usually possess neither loops nor multiple edges, but we make no such general assumption. An edge e having endvertices x and y is written as e = x, y . A random-cluster measure on G is a member of a certain class of probability measures on the set of subsets of the edge set E. We take as state space the set = {0,1}E, members of which are 0/1-vectors ω = (ω(e) : e ∈ E). We speak of the edge e as being open (in ω) if ω(e) = 1, and as being closed if ω(e) = 0. For ω ∈ , let η(ω) = {e ∈ E : ω(e) = 1} denote the set of open edges. There is a one–one correspondence between vectors ω ∈ and subsets F ⊆ E, given by F = η(ω). Let k(ω) be the numberof connected components(or ‘open clusters’) of the graph (V,η(ω)), and note that k(ω) includes a count of isolated vertices, that is, of vertices incident to no open edge. We associate with the σ-ﬁeld F of all its subsets.

A random-cluster measure on G has two parameters satisfying p ∈ [0,1] and q ∈ (0,∞), and is deﬁned as the measure φp,q on the measurable pair ( ,F ) given by

1 ZRC e∈E

pω(e)(1 − p)1−ω(e) qk(ω), ω ∈  ,

(1.1) φp,q(ω) =

![image 7](<rcm1-1_images/imageFile7.png>)

where the ‘partition function’, or ‘normalizing constant’, ZRC is given by

pω(e)(1 − p)1−ω(e) qk(ω).

(1.2) ZRC = ZRC(p,q) =

ω∈ e∈E

Thismeasurediffersfromproductmeasurethroughthe inclusionofthe term qk(ω). Note the difference between the cases q ≤ 1 and q ≥ 1: the former favours fewer clusters, whereas the latter favours a larger number of clusters. When q = 1, edges are open/closed independently of one another. This very special case has been studied in detail under the titles ‘percolation’ and ‘random graphs’, see [61, 154, 194]. Perhaps the most important values of q are the integers, since the random-cluster model with q ∈ {2,3,. . .} corresponds, in a way described in the next two sections, to the Potts model with q local states. The bulk of the work presented in this book is devoted to the theory of random-cluster measures when q ≥ 1. The case q < 1 seems to be harder mathematically and less important physically. There is some interest in the limit as q ↓ 0; see Section 1.5.

We shall sometimes write φG,p,q for φp,q when the choice of graph G is to be stressed. Computer-generated samples from random-cluster measures on Z2 are presented in Figures 1.1–1.2. When q = 1, the measure φp,q is a product measure with density p, and we write φG,p or φp for this special case.

=

.

0

30

p

=

.

0

45

p

=

.

0

49

p

=

.

0

51

p

=

.

0

55

p

=

.

0

70

p

Figure 1.1. Samples from the random-cluster measure with q = 1 on a 40 × 40 box of the square lattice. We have set q = 1 for ease of programming, the measure being of product form in this case. The critical value is p c ( 1 ) = 1 2 . Samples with more general values of q may be obtained by the method of ‘coupling from the past’, as described in Section 8.4.

6 Random-Cluster Measures [1.3]

![image 8](<rcm1-1_images/imageFile8.png>)

Figure 1.2. A picture of the random-cluster model with free boundary conditions on a 2048× 2048 box of L2, with p = 0.585816 and q = 2. The critical value of the model with q = 2 is pc =

√2) = 0.585786 ..., and therefore the simulation is of a mildly supercritical system. It was obtained by simulating the Ising model using Glauber dynamics (see Section 8.2), and then applying the coupling illustrated in Figure 1.3. Each individual cluster is highlighted with a different tint of gray, and the smaller clusters are not visible in the picture. This and later simulations in Section 5.7 are reproduced by kind permission of Raphael¨ Cerf.

√2/(1 +

![image 9](<rcm1-1_images/imageFile9.png>)

![image 10](<rcm1-1_images/imageFile10.png>)

1.3 Ising and Potts models

In a famous experiment, a piece of iron is exposed to a magnetic ﬁeld. The ﬁeld is increased from zero to amaximum,and then diminished tozero. If the temperature is sufﬁciently low, the iron retains some residual magnetization, otherwise it does not. There is a critical temperature for this phenomenon, often called the Curie point after Pierre Curie, who reported this discovery in his 1895 thesis, [98]3. The

![image 11](<rcm1-1_images/imageFile11.png>)

3In an example of Stigler’s Law, [309], the existence of such a temperature was discovered before 1832 by Pouillet, see [198].

[1.3] Ising and Potts models 7

famous (Lenz–)Ising model for such ferromagnetism, [190], may be summarized as follows. One supposes that particles are positioned at the points of some lattice embedded in Euclidean space. Each particle may be in either of two states, representing the physical states of ‘spin-up’ and ‘spin-down’. Spin-values are chosen at random according to a certain probability measure, known as a ‘Gibbs state’, which is governed by interactions between neighbouring particles. The relevant probability measure is given as follows.

Let G = (V, E) be a ﬁnite graph representing part of the lattice. We think of each vertex x ∈ V as being occupied by a particle having a random spin. Since spins are assumed to come in two basic types, we take as sample space the set

= {−1,+1}V. The appropriateprobabilitymass function λβ,J,h on has three parameters satisfying β, J ∈ [0,∞) and h ∈ R, and is given by (1.3) λβ,J,h(σ) =

1 ZI

e−βH(σ), σ ∈  , where the partition function ZI and the ‘Hamiltonian’ H : → R are given by (1.4) ZI =

![image 12](<rcm1-1_images/imageFile12.png>)

e−βH(σ), H(σ) = −J

σxσy − h

σx.

e= x,y ∈E

x∈V

σ∈

The physical interpretation of β is as the reciprocal 1/T of temperature, of J as the strength of interaction between neighbours, and of h as the external magnetic ﬁeld. For reasons of simplicity, we shall consider here only the case of zero external-ﬁeld, and we assume henceforth that h = 0.

Each edge has equal interaction strength J in the above formulation. Since β and J occur only as a product β J, the measure λβ,J,0 has effectively only a single parameter β J. In a more complicated measure not studied here, different edges e are permitted to have different interaction strengths Je, see Chapter 9. In the meantime we shall wrap β and J together by setting J = 1, and we write λβ = λβ,1,0

As pointed out by Baxter, [26], the Ising model permits an inﬁnity of generalizations. Of these, the extension to so-called ‘Potts models’ has proved especially fruitful. Whereas the Ising model permits only two possible spin-values at each vertex, the Potts model [278] permits a general number q ∈ {2,3,. . .}, and is governed by a probability measure given as follows.

Let q be an integer satisfying q ≥ 2, and take as sample space the set of vectors = {1,2,. . .,q}V. Thus each vertex of G may be in any of q states. For an edge

e = x, y and a conﬁguration σ = (σx : x ∈ V) ∈ , we write δe(σ) = δσx,σy where δi,j is the Kronecker delta. The relevant probability measure is given by (1.5) πβ,q(σ) =

1 ZP

e−βH′(σ), σ ∈  ,

![image 13](<rcm1-1_images/imageFile13.png>)

where ZP = ZP(β,q)isthe appropriate normalizingconstantandtheHamiltonian H′ is given by

(1.6) H′(σ) = −

δe(σ).

e= x,y ∈E

8 Random-Cluster Measures [1.4]

In the special case q = 2, the multiplicative formula (1.7) δσx,σy = 21(1 + σxσy), σx,σy ∈ {−1,+1}, is valid. It is now easy to see in this case that the ensuing Potts model is simply the Ising model with an adjusted value of β, in that πβ,2 is the measure obtained from λβ/2 by re-labelling the local states.

![image 14](<rcm1-1_images/imageFile14.png>)

Here is a brief mention of one furthergeneralizationof the Ising model, namely the so-called n-vector or O(n) model. Let n ∈ {1,2,. . .} and let I be the set of vectors of Rn with unit length. The n-vector model on G = (V, E) has conﬁguration space IV and Hamiltonian

sx · sy, s = (sv : v ∈ V) ∈ IV,

Hn(s) = −

e= x,y ∈E

where sx · sy denotes the dot product. When n = 1, this is the Ising model. It is called the X/Y model when n = 2, and the Heisenberg model when n = 3.

1.4 Random-cluster and Ising/Potts models coupled

Fortuin and Kasteleyn discovered that Potts models may be re-cast as randomcluster models, and furthermore that the relationship between the two systems facilitates an extended study of phase transitions in Potts models, see [121, 122, 123, 203]. Their methods were elementary in nature. In a more modern approach, we construct the two systems on a common probability space. There may in principle be many ways to do this, but the standard coupling of Edwards and Sokal, [108], is of special value.

Let q ∈ {2,3,. . .}, p ∈ [0,1], and let G = (V, E) be a ﬁnite graph. We consider the product sample space × where = {1,2,. . .,q}V and = {0,1}E as above. We deﬁne a probability mass function µ on × by

(1 − p)δω(e),0 + pδω(e),1δe(σ) , (σ,ω) ∈ ×  ,

(1.8) µ(σ,ω) ∝

e∈E

where, as before, δe(σ) = δσx,σy for e = x, y ∈ E. The constant of proportionality is exactly that which ensures the normalization

µ(σ,ω) = 1.

(σ,ω)∈ ×

By an expansion of (1.8), µ(σ,ω) ∝ ψ(σ)φp(ω)1F(σ,ω), (σ,ω) ∈ ×  ,

where ψ is the uniform probability measure on , φp is product measure on with density p, and 1F is the indicator function of the event

(1.9) F = (σ,ω) : δe(σ) = 1 for any e satisfying ω(e) = 1 ⊆ ×  . Therefore, µ may be viewed as the product measure ψ × φp conditioned on F.

Elementary calculations reveal the following facts.

(1.10)Theorem(Marginalmeasuresofµ)[108]. Letq ∈ {2,3,. . .}, p ∈ [0,1), and suppose that p = 1 − e−β.

(a) Marginal on . The marginal measure µ1(σ) = ω∈ µ(σ,ω) on is the Potts measure

µ1(σ) =

1 ZP

exp β

![image 15](<rcm1-1_images/imageFile15.png>)

e∈E

δe(σ) , σ ∈  .

(b) Marginalon . The marginal measure µ2(ω) = σ∈ µ(σ,ω) on is the random-cluster measure

1 ZRC e∈E

pω(e)(1 − p)1−ω(e) qk(ω), ω ∈  .

µ2(ω) =

![image 16](<rcm1-1_images/imageFile16.png>)

(c) Partition functions. We have that

pω(e)(1− p)1−ω(e) qk(ω) =

exp[β(δe(σ)−1)], (1.11)

σ∈ e∈E

ω∈ e∈E

which is to say that

ZRC(p,q) = e−β|E|ZP(β,q). (1.12)

The conditional measures of µ are given in the following theorem4, and illustrated in Figure 1.3. (1.13) Theorem (Conditional measures of µ) [108]. Let q ∈ {2,3,. . .}, p ∈ [0,1), and suppose that p = 1 − e−β.

- (a) For ω ∈ , the conditional measure µ(· | ω) on is obtained by putting random spins on entire clusters of ω (of which there are k(ω)). These spins are constant on given clusters, are independent between clusters, and each is uniformly distributed on the set {1,2,. . .,q}.
- (b) For σ ∈ , the conditional measure µ(· | σ) on is obtained as follows. If e = x, y is such that σx  = σy, we set ω(e) = 0. If σx = σy, we set


ω(e) =

1 with probability p, 0 otherwise,

the values of different ω(e) being (conditionally) independent random variables.

![image 17](<rcm1-1_images/imageFile17.png>)

4The corresponding facts for the inﬁnite lattice are given in Theorem 4.91.

![image 4](<rcm1-1_images/imageFile4.png>)

2

2

4

4

1

2

2

2

1

2

2

2

1

4

2

2

2

2

4

4

1

2

2

2

1

2

2

2

1

4

2

2

Figure 1.3. The upper diagram is an illustration of the conditional measure of µ on   given ω , with q = 4. To each open cluster of ω is allocated a spin-value chosen uniformly from { 1 , 2 , 3 , 4 } . Differentclustersareallocatedindependentvalues. Inthelowerdiagram, webegin withaconﬁguration σ . Anedgeisplacedbetweenvertices x , y withprobability p (respectively, 0) if σ x = σ y (respectively, σ x  = σ y ), and the outcome has as law the conditional measure of µ on   given σ .

In conclusion, the measure µ is a coupling of a Potts measure π β, q on V , together with the random-cluster measure φ p , q on   . The parameters of these measures are related by the equation p = 1 − e − β . Since 0 ≤ p < 1, we have that 0 ≤ β < ∞ . This special coupling may be used in a particularly simple way to show that

correlations in Potts models correspond to open connections in random-cluster models. When extended to inﬁnite graphs, this will imply that the phase transition of a Potts model corresponds to the creation of an inﬁnite open cluster in the random-cluster model. Thus, arguments of stochastic geometry, and particularly those developed for the percolation model, may be harnessed directly in order to understand the correlation structure of the Potts system. The basic step is as follows.

Let { x ↔ y } denote the set of all ω ∈   for which there exists an open path joining vertex x to vertex y . The complement of the event { x ↔ y } is denoted by { x / ↔ y } .

c   Springer-Verlag 2006

The ‘two-point correlation function’ of the Potts measure πβ,q on the ﬁnite graph G = (V, E) is deﬁned to be the function τβ,q given by

1 q

(1.14) τβ,q(x, y) = πβ,q(σx = σy) −

, x, y ∈ V.

![image 18](<rcm1-1_images/imageFile18.png>)

The term q−1 is the probability that two independent and uniformly distributed spins are equal. Thus5,

(1.15) τβ,q(x, y) =

1 q

πβ,q(qδσx,σy − 1).

![image 19](<rcm1-1_images/imageFile19.png>)

The ‘two-point connectivity function’ of the random-cluster measure φp,q is deﬁned as the function φp,q(x ↔ y) for x, y ∈ V, that is, the probability that x and y are joined by a path of open edges. It turns out that these ‘two-point functions’ are (except for a constant factor) the same.

(1.16)Theorem(Correlation/connection)[203]. Let q ∈ {2,3,. . .}, p ∈ [0,1), and suppose that p = 1 − e−β. Then

τβ,q(x, y) = (1 − q−1)φp,q(x ↔ y), x, y ∈ V.

The theorem may be generalized as follows. Suppose we are studying the Potts model, and are interested in some ‘observable’ f : → R. The mean value of

f (σ) satisﬁes

πβ,q( f ) =

=

σ

ω

f (σ)πβ,q(σ) =

σ,ω

f (σ)µ(σ,ω)

F(ω)φp,q(ω) = φp,q(F)

where F : → R is given by F(ω) = µ( f | ω) =

σ

f (σ)µ(σ | ω).

Theorem 1.16 is obtained by setting f (σ) = δσx,σy − q−1.

The Potts models considered above have zero external-ﬁeld. Some complications arise when an external ﬁeld is added; see the discussions in [15, 44]. Proof of Theorem 1.10. (a) Let σ ∈ be given. Then

(1 − p)δω(e),0 + pδω(e),1δe(σ)

µ(σ,ω) ∝

ω∈ e∈E

ω∈

[1 − p + pδe(σ)].

=

e∈E

![image 20](<rcm1-1_images/imageFile20.png>)

5If µ is a probability measure and X a random variable, the expectation of X with respect to µ is written µ(X).

12 Random-Cluster Measures [1.4]

Now p = 1 − e−β and 1 − p + pδ = eβ(δ−1), δ ∈ {0,1},

whence (1.17)

exp[β(δe(σ) − 1)].

(1 − p)δω(e),0 + pδω(e),1δe(σ) =

e∈E

ω∈ e∈E

Viewed as a set of weights on , the latter expression generates the Potts measure. (b) Let ω ∈ be given. We have that

(1 − p)δω(e),0 + pδω(e),1δe(σ) = p|η(ω)|(1 − p)|E\η(ω)|1F(σ,ω),

(1.18)

e∈E

where 1F(σ,ω) is the indicator function that δe(σ) = 1 whenever ω(e) = 1, see (1.9). Now, 1F(σ,ω) = 1 if and only if σ is constant on every open cluster of ω. There are k(ω) such clusters, and therefore qk(ω) qualifying spin-vectors σ. Thus,

(1 − p)δω(e),0 + pδω(e),1δe(σ) = p|η(ω)|(1 − p)|E\η(ω)|qk(ω).

(1.19)

σ∈ e∈E

This set of weights on generates the random-cluster measure. (c) We obtain the same answer if we sum (1.17) over all σ, or we sum (1.19) over all ω.

Proof of Theorem 1.13. (a) Let ω ∈ be given. From (1.18)–(1.19), µ(σ | ω) =

1F(σ,ω) qk(ω)

, σ ∈  ,

![image 21](<rcm1-1_images/imageFile21.png>)

whence the conditional measure is uniform on those σ with 1F(σ,ω) = 1. (b) Let σ ∈ be given. By (1.8),

(1 − p)δω(e),0 + pδω(e),1 ,

µ(ω | σ) = Kσ

δω(e),0

e∈E: δe(σ)=1

e∈E: δe(σ)=0

where Kσ = Kσ(p,q). Therefore, µ(ω | σ) is a product measure on with ω(e) = 1 with probability

0 if δe(σ) = 0, p if δe(σ) = 1.

Proof of Theorem 1.16. By Theorem 1.13(a), τβ,q(x, y) =

1{σx=σy}(σ) − q−1 µ(σ,ω)

σ,ω

µ(σ | ω) 1{σx=σy}(σ) − q−1

=

φp,q(ω)

ω

σ

φp,q(ω) (1 − q−1)1{x↔y}(ω) + 0 · 1{x↔/ y}(ω)

=

ω

= (1 − q−1)φp,q(x ↔ y),

[1.5] The limit as q ↓ 0 13

where µ is the above coupling of the Potts and random-cluster measures.

Here is a ﬁnal note. The random-cluster measure φp,q has two parameters p, q. In a more general version, we replace p by a vector p = (pe : e ∈ E) of reals each of which satisﬁes pe ∈ [0,1]. The corresponding random-cluster measure φp,q on ( ,F ) is given by

(1.20) φp,q(ω) =

![image 22](<rcm1-1_images/imageFile22.png>)

1 Z e∈E

peω(e)(1 − pe)1−ω(e) qk(ω), ω ∈  ,

where Z is the appropriate normalizing factor. The measure φp,q is retrieved by setting pe = p for all e ∈ E.

1.5 The limit as q ↓ 0

Let G = (V, E) be a ﬁnite connected graph, and let φp,q be the random-cluster measure on G with parameters p ∈ (0,1), q ∈ (0,∞). We considerin thissection the set of weak limits which may arise as q ↓ 0. In preparation, we introduce three graph-theoretic terms.

A subset F of the edge-set E is called:

- • a forest of G if the graph (V, F) contains no circuit,
- • a spanning tree of G if (V, F) is connected and contains no circuit,
- • a connected subgraph of G if (V, F) is connected. In each case we consider the graph (V, F) containing every vertex of V; in this regard, sets F of edges satisfying one of the above conditions are sometimes termed spanning. Note that F is a spanning tree if and only if it is both a forest and a connected subgraph. For = {0,1}E and ω ∈ , we call ω a forest (respectively, spanning tree, connected subgraph) if η(ω) is a forest (respectively, spanning tree, connected subgraph). Write for, st, cs for the subsets of containing all forests, spanning trees, and connected subgraphs, respectively, and write USF, UST, UCS for the uniform probability measures6 on the respective sets for, st, cs.


We considerﬁrst the weak limit of φp,q as q ↓ 0 forﬁxed p ∈ (0,1). This limit may be ascertained by observing that the dominant terms in the partition function

ZRC(p,q) =

ω∈

p|η(ω)|(1 − p)|E\η(ω)|qk(ω)

are those for which k(ω) is a minimum, that is, those with k(ω) = 1. It follows that limq↓0 φp,q is precisely the product measure φp = φp,1 (that is, percolation

![image 23](<rcm1-1_images/imageFile23.png>)

6This usage of the term ‘uniform spanning forest’ differs from that of [31].

14 Random-Cluster Measures [1.5]

with intensity p) conditioned on the resulting graph (V,η(ω)) being connected. That is, φp,q ⇒ φrcs as q ↓ 0, where r = p/(1 − p),

1 Zcs

r|η(ω)| if ω ∈ cs, 0 otherwise,

(1.21) φrcs(ω) =

![image 24](<rcm1-1_images/imageFile24.png>)

and Zcs = Zcs(r) is the appropriate normalizing constant. In the special case p = 21, we have that φp,q ⇒ UCS as q ↓ 0.

![image 25](<rcm1-1_images/imageFile25.png>)

Further limits arise if we allow both p and q to convergeto 0. Suppose p = pq is related to q in sucha way that p → 0 andq/p → 0 as q ↓ 0; thus, p approaches zero slower than does q. We may write ZRC in the form

|η(ω)|+k(ω) q(1 − p) p

k(ω)

p 1 − p

ZRC(p,q) = (1 − p)|E|

.

![image 26](<rcm1-1_images/imageFile26.png>)

![image 27](<rcm1-1_images/imageFile27.png>)

ω∈

Note that p/(1 − p) → 0 and q(1 − p)/p → 0 as q ↓ 0. Now, k(ω) ≥ 1 and |η(ω)|+k(ω) ≥ |V| forω ∈ ; these two inequalitiesare satisﬁed simultaneously with equality if and only if ω ∈ st. Therefore, in the limit as q ↓ 0, the ‘mass’ is concentratedonspanningtrees, anditis easily seenthatthelimitmassisuniformly distributed. That is, φp,q ⇒ UST.

Another limit emerges if p approaches 0 at the same rate as does q. Take p = αq where α ∈ (0,∞) is constant, and consider the limit as q ↓ 0. This time we write

|η(ω)|

α 1 − αq

ZRC(p,q) = (1 − αq)|E|

q|η(ω)|+k(ω).

![image 28](<rcm1-1_images/imageFile28.png>)

ω∈

We have that |η(ω)| + k(ω) ≥ |V| with equality if and only if ω ∈ for, and it follows that φp,q ⇒ φαfor, where

1 Zfor

α|η(ω)| if ω ∈ for, 0 otherwise,

(1.22) φαfor(ω) =

![image 29](<rcm1-1_images/imageFile29.png>)

and Zfor = Zfor(α) is the appropriate normalizing constant. In the special case α = 1, we ﬁnd that φp,q ⇒ USF.

Finally, if p approaches 0 faster than does q, in that p/q → 0 as p,q → 0, it is easily seen that the limit measure is concentrated on the empty set of edges. We summarize the three special cases above in a theorem.

(1.23) Theorem. We have in the limit as q ↓ 0 that:

 

UCS if p = 21, UST if p → 0 and q/p → 0,

![image 30](<rcm1-1_images/imageFile30.png>)

φp,q ⇒



USF if p = q.

The spanning-treelimitis especially interestingforhistoricalandmathematical reasons. As explained in the Appendix, the random-cluster model originated in a systematic study by Fortuin and Kasteleyn of systems of a certain type which satisfy certain parallel and series laws (see Section 3.8). Electrical networks are the best known such systems: two resistors of resistances r1 and r2 in parallel (respectively, in series) may be replaced by a single resistor with resistance (r1−1 + r2−1)−1 (respectively, r1 + r2). Fortuin and Kasteleyn [123] realized that the electrical-network theory of a graph G is related to the limit as q ↓ 0 of the random-clustermodel on G, where p is given7 by p =

√q). It has been known since Kirchhoff’s theorem, [215], that the electrical currents which ﬂow in a network may be expressed in terms of counts of spanning trees. We return to this discussion of UST in Section 3.9.

√q/(1+

![image 31](<rcm1-1_images/imageFile31.png>)

![image 32](<rcm1-1_images/imageFile32.png>)

The theory of the uniform-spanning-tree measure UST is beautiful in its own right(see[31]),andislinkedinanimportantwaytotheemergingﬁeldofstochastic growth processes of ‘stochastic Lowner¨ evolution’ (SLE) type (see [231, 284]), to which we return in Section 6.7. Further discussions of USF and UCS may be found in [165, 268].

1.6 Basic notation

We present some of the basic notation necessary for a study of random-cluster measures. Let G = (V, E) be a graph, with ﬁnite or countably inﬁnite vertex-set V and edge-set E. If two vertices x and y are joined by an edge e, we write x ∼ y, and e = x, y , and we say that x is adjacent to y. The (graph-theoretic) distance δ(x, y) from x to y is deﬁned to be the number of edges in a shortest path of G from x to y.

The conﬁguration space of the random-cluster model on G is the set = {0,1}E, points of which are represented as vectors ω = (ω(e) : e ∈ E) and called conﬁgurations. For ω ∈ , we call an edge e open (or ω-open, when the role of ω is to be emphasized) if ω(e) = 1, and closed (or ω-closed) if ω(e) = 0. We speak of a set F of edges as being ‘open’ (respectively, ‘closed’) in the conﬁguration ω if ω( f ) = 1 (respectively, ω( f ) = 0) for all f ∈ F.

The indicatorfunction of a subset A of is the function 1A : → {0,1} given by

0 if ω ∈/ A, 1 if ω ∈ A.

1A(ω) =

For e ∈ E, we write Je = {ω ∈ : ω(e) = 1}, the event that the edge e is open. We use Je to denote also the indicatorfunctionof this event, so that Je(ω) = ω(e). A function X : → R is called a cylinder function if there exists a ﬁnite subset F of E such that X(ω) = X(ω′) whenever ω(e) = ω′(e) for e ∈ F. A subset A of is called a cylinder event if its indicator function is a cylinder function. We

![image 33](<rcm1-1_images/imageFile33.png>)

7This choice of p is convenient, but actually one requires only that q/p → 0, see [166].

take F to be the σ-ﬁeld of subsets of generated by the cylinder events, and we shall consider certain probability measures on the measurable pair ( ,F ). If G is ﬁnite, then F is the set of all subsets of ; all events are cylinder events, and all functions are cylinder functions. The complement of an event A is written Ac or A.

![image 34](<rcm1-1_images/imageFile34.png>)

For W ⊆ V, let EW denote the set of edges of G having both endvertices in W. We write FW (respectively, TW) for the smallest σ-ﬁeld of F with respect to which each of the random variables ω(e), e ∈ EW (respectively, e ∈/ EW), is measurable. The notation FF, TF is to be interpreted similarly for F ⊆ E. The intersection of the TF over all ﬁnite sets F is called the tail σ-ﬁeld and is denoted by T . Sets in T are called tail events.

Thereis a naturalpartialorderon the set of conﬁgurationsgivenby: ω1 ≤ ω2 if and only if ω1(e) ≤ ω2(e) for all e ∈ E. Rather than working always with the vector ω ∈ , we shall sometimes work with its set of open edges, given by

(1.24) η(ω) = {e ∈ E : ω(e) = 1}. Clearly,

ω1 ≤ ω2 if and only if η(ω1) ⊆ η(ω2). The smallest (respectively, largest) conﬁguration is that with ω(e) = 0 (respectively, ω(e) = 1) for all e, and this is denoted by 0 (respectively, 1). A function X : → R is called increasing if X(ω1) ≤ X(ω2) whenever ω1 ≤ ω2. Similarly, X is decreasing if −X is increasing. Note that every increasing function X : → R is necessarily bounded since X(0) ≤ X(ω) ≤ X(1) for all ω ∈ . A subset A of is called increasing (respectively, decreasing) if it has increasing (respectively, decreasing) indicator function.

For ω ∈ and e ∈ E, let ωe and ωe be the conﬁgurations obtained from ω by ‘switching on’ and ‘switching off’ the edge e, respectively. That is,

ω( f ) if f  = e, 1 if f = e,

ωe( f ) =

for f ∈ E,

(1.25)

ω( f ) if f  = e, 0 if f = e,

for f ∈ E.

ωe( f ) =

More generally, for J ⊆ E and K ⊆ E \ J, we denote by ωKJ the conﬁguration that equals 1 on J, equals 0 on K, and agrees with ω on E \ (J ∪ K). When J

and/or K contain only one or two edges, we may omit the necessary parentheses. The Hamming distance between two conﬁgurations is given by

(1.26) H(ω1,ω2) =

|ω1(e) − ω2(e)|, ω1,ω2 ∈  .

e∈E

A path of G is deﬁned as an alternating sequence x0,e0, x1,e1,. . . ,en−1, xn of distinct vertices xi and edges ei = xi, xi+1 . Such a path has length n and

is said to connect x0 to xn. A circuit or cycle of G is an alternating sequence x0,e0, x1,. . .,en−1, xn,en, x0 of vertices and edges such that x0,e0,. . . ,en−1, xn is a path and en = xn, x0 ; such a circuit has length n + 1. For ω ∈ , we call a path or circuit open if all its edges are open, and closed if all its edges are closed. Two subgraphs of G are called edge-disjoint if they have no edges in common, and disjoint if they have neither edges nor vertices in common.

Let ω ∈ . Consider the random subgraph of G containing the vertex set V and the open edges only, that is, the edges in η(ω). The connected components of this graph are called open clusters. We write Cx = Cx(ω) for the open cluster containing the vertex x, and we call Cx the open cluster at x. The vertex-set of Cx is the set of all verticesof G that are connectedto x by openpaths, and the edgesof Cx are those edges of η(ω) that join pairs of such vertices. We shall occasionally use the term Cx to represent the set of vertices joined to x by open paths, rather than the graph of this open cluster. We shall be interested in the size of Cx, and we denote by |Cx| the number of vertices in Cx. Note that Cx = {x} whenever x is an isolated vertex, which is to say that x is incident to no open edge. We denote by k(ω) the number of open clusters in the conﬁguration ω, that is, k(ω) is the number of components of the graph (V,η(ω)). The random variable k plays an important role in the deﬁnition of a random-cluster measure, and the reader is warned of the importance of including in k a count of the number of isolated vertices of the graph.

Let ω ∈ . If A and B are sets of vertices of G, we write ‘A ↔ B’ if there exists an open path joining some vertex in A to some vertex in B; if A ∩ B  = ∅ then A ↔ B trivially. Thus, for example, Cx = {y ∈ V : x ↔ y}. We write ‘A ↔/ B’ if there exists no open path from any vertex of A to any vertex of B, and ‘A ↔ B off D’ if there exists an open path joining some vertex in A to some vertex in B that uses no vertex in the set D.

If W is a set of vertices of the graph, we write ∂W for the boundary of A, being the set of vertices in A that are adjacent to some vertex not in A,

∂W = {x ∈ W : there exists y ∈/ W such that x ∼ y}.

We write eW for the set of edges of G having exactly one endvertex in W, and we call eW the edge-boundary of W.

We shall be mostly interested in the case when G is a subgraph of a d-dimensional lattice with d ≥ 2. Rather than embarking on a debate of just what constitutes a ‘lattice-graph’, we shall, almost without exception, consider only the case of the (hyper)cubic lattice. This restriction enables a clear exposition of the theory and open problems without suffering the complications which arise through allowing greater generality.

Let d be a positive integer. We write Z = {. . .,−1,0,1,. . .} for the set of all integers, and Zd for the set of all d-vectors x = (x1, x2,. . ., xd) with integral coordinates. For x ∈ Zd, we generally write xi for the ith coordinate of x, and we

deﬁne

d

|xi − yi|.

δ(x, y) =

i=1

The origin of Zd is denoted by 0. The set {1,2,. . .} of natural numbers is denoted by N, and Z+ = N ∪ {0}. The real line is denoted by R.

We turn Zd intoa graph, calledthe d-dimensionalcubiclattice, byaddingedges between all pairs x, y of points of Zd with δ(x, y) = 1. We denote this lattice by Ld, and we write Zd for the set of vertices of Ld, and Ed for the set of its edges. Thus, Ld = (Zd,Ed). We shall often think of Ld as a graph embedded in Rd, the edges being straight line-segments between their endvertices. The edge-set EV of V ⊆ Zd is the set of all edges of Ld both of whose endvertices lie in V.

Let x, y be vertices of Ld. The (graph-theoretic)distance from x to y is simply δ(x, y), and we write |x| for the distance δ(0, x) from the origin to x. We shall make occasional use of another distance function on Zd, namely

x = max |xi| : i = 1,2,. . . ,d , x ∈ Zd, and we note that

x ≤ |x| ≤ d x , x ∈ Zd. For ω ∈ = {0,1}Ed, we abbreviate to C the open cluster C0 at the origin. A box of Ld is a subset of Zd of the form

a,b = x ∈ Zd : ai ≤ xi ≤ bi for i = 1,2,. . .,d , a,b ∈ Zd, and we sometimes write

d

[ai,bi]

a,b =

i=1

as a convenient shorthand. The expression a,b is used also to denote the graph with vertex-set a,b together with those edges of Ld joining two vertices in a,b. For x ∈ Zd, we write x + a,b for the translate by x of the box a,b. The expression n denotes the box with side-length 2n and centre at the origin,

(1.27) n = [−n,n]d = {x ∈ Zd : x ≤ n}. Note that ∂ n = n \ n−1.

In taking whatiscalled a ‘thermodynamiclimit’,one worksoften ona ﬁnite box

of Zd, and then takes the limit as ↑ Zd. Such a limit is to be interpreted along a sequence = ( n : n = 1,2,. . .) of boxes such that: n is non-decreasing in n and, for all m, n ⊇ [−m,m]d for all large n.

For any random variable X and appropriate probability measure µ, we write µ(X) for the expectation of X,

µ(X) = X dµ.

Let⌊a⌋and⌈a⌉denotetheintegerpartoftherealnumber a,andtheleastinteger not less than a, respectively. Finally, a ∧ b = min{a,b} and a ∨ b = max{a,b}.

## Chapter 2 Monotonic Measures

Summary. The property of monotonicity of measures leads naturally to positive association and the FKG inequality. A monotonic measure may be used as the seed for a parametric family of measures satisfying probabilistic inequalities including inﬂuence, sharp-threshold, and exponential-steepness inequalities.

2.1 Stochastic ordering of measures

The stochastic orderingof probabilitymeasuresprovidesa techniquewhichis fundamental to the study of random-cluster measures. Let E be a ﬁnite or countably inﬁnite set, let = {0,1}E, and let F be the σ-ﬁeld generated by the cylinder eventsof . In applicationsof the argumentsof this section, E will be the edge-set of a graph, and thus we refer to members of E as ‘edges’, although the graphical structure is not itself relevant at this stage.

The conﬁguration space is a partially ordered set with partial order given by: ω1 ≤ ω2 if ω1(e) ≤ ω2(e) for all e ∈ E. A random variable X : → R is called increasing if X(ω1) ≤ X(ω2) whenever ω1 ≤ ω2. An event A ∈ F is called increasing (respectively, decreasing) if its indicator function 1A is increasing (respectively, decreasing). The set , equipped with the topology of open sets generated by the cylinder events, is a metric space, and we speak of a random variable X : → R as being ‘continuous’ if it is a continuous function on this metric space. Since is compact, any continuous function on

is necessarily bounded. In addition, any increasing function X : → R is bounded since X(0) ≤ X(ω) ≤ X(1) for ω ∈ .

Given two probability measures µ1, µ2 on ( ,F ), we write µ1 ≤st µ2 (or µ2 ≥st µ1), and we say that µ1 is stochastically smaller than µ2, if1 µ1(X) ≤ µ2(X) for all increasing continuous random variables X on .

![image 35](<rcm1-1_images/imageFile35.png>)

1Recall that µ(X) denotes the expectation of X under µ, that is, µ(X) = X dµ.

For two probability measures φ1, φ2 on ( ,F ), a coupling of φ1 and φ1 is a probability measure κ on ( ,F ) × ( ,F ) whose ﬁrst (respectively, second) marginal is φ1 (respectively, φ2). There exist many couplings of any given pair φ1, φ2, and the art of coupling lies in ﬁnding one that is useful. Let µ1, µ2 be probability measures on ( ,F ). The theorem known sometimes as ‘Strassen’s theorem’ states that µ1 ≤st µ2 if and only if there exists a coupling κ satisfying κ(S) = 1, where S = {(ω1,ω2) ∈ 2 : ω1 ≤ ω2} is the ‘sub-diagonal’ of the product space 2. A useful account of coupling and its applications may be found in [237].

We call a probability measure µ on ( ,F ) strictly positive if µ(ω) > 0 for all ω ∈ . For ω1,ω2 ∈ , we denote by ω1 ∨ ω2 and ω1 ∧ ω2 the ‘maximum’ and ‘minimum’ conﬁgurations given by

ω1 ∨ ω2(e) = max{ω1(e),ω2(e)}, e ∈ E, ω1 ∧ ω2(e) = min{ω1(e),ω2(e)}, e ∈ E.

We suppose for the remainder of this section that E is ﬁnite. There is a useful sufﬁcient condition for the stochastic inequality µ1 ≤st µ2, as follows. (2.1) Theorem (Holley inequality) [185]. Let µ1 and µ2 be strictly positive probability measures on the ﬁnite space ( ,F ) such that (2.2) µ2(ω1 ∨ ω2)µ1(ω1 ∧ ω2) ≥ µ1(ω1)µ2(ω2), ω1,ω2 ∈  . Then

µ1(X) ≤ µ2(X) for increasing functions X : → R, which is to say that µ1 ≤st µ2.

This may be extended in (at least) two ways. Firstly, a similar claim2 is valid in themoregeneralsettingwhere = T E and T isaﬁnitesubsetofR. Secondly,one may relax the condition that the measures be strictly positive. See, for example, [136, Section 4].

Let S ⊆ 2 (= × ) be the set of all ordered pairs (π,ω) of conﬁgurations satisfying π ≤ ω, as above. In the proof of Theorem 2.1, we shall construct a coupling κ of µ1 and µ2 such that κ(S) = 1. It is an immediate consequence that µ1 ≤st µ2. There is a variety of couplings of measures which play roles in the theory of random-cluster measures. Another may be found in the proof of Theorem 3.45.

Condition (2.2) in key to Theorem 2.1, and it is equivalent to a condition of monotonicity on the one-point conditional distributions.

![image 36](<rcm1-1_images/imageFile36.png>)

2An application of such a claim may be found in the analysis of the Ashkin–Teller model at Theorem 11.12.

(2.3) Theorem. Let µ1, µ2 be strictly positive probability measures on ( ,F ). The following are equivalent.

(a) The pair µ1, µ2 satisﬁes (2.2). (b) The one-point conditional probabilities are monotonic in that

µ2 ω(e) = 1 ω( f ) = ζ( f ) for all f ∈ E \ {e}

≥ µ1 ω(e) = 1 ω( f ) = ξ( f ) for all f ∈ E \ {e} (2.4) for all e ∈ E, and all pairs ξ,ζ ∈ satisfying ξ ≤ ζ.

(c) It is the case that

µ2(ζe) µ2(ζe) ≥

µ1(ξe) µ1(ξe)

, ξ ≤ ζ, e ∈ E. (2.5)

![image 37](<rcm1-1_images/imageFile37.png>)

![image 38](<rcm1-1_images/imageFile38.png>)

The following is sufﬁcient for (2.2).

- (2.6) Theorem. Let µ1, µ2 be strictly positive probability measures on ( ,F ) such that
- (2.7) µ2(ωe)µ1(ωe) ≥ µ1(ωe)µ2(ωe), ω ∈  , e ∈ E. If either µ1 or µ2 satisﬁes (2.8) µ(ωef )µ(ωef ) ≥ µ(ωef )µ(ωef ), ω ∈  , e, f ∈ E, then (2.2) holds.


Proof of Theorem 2.1. The theorem amounts to a ‘mere’ numerical inequality involving a ﬁnite number of positive reals. It may in principle be proved in a totally elementary manner, using essentially no general mechanism. The proof given here proceeds by constructing certain reversible Markov chains. There is some extra mechanismrequired, butthe methodis beautiful, and in additionyields a structure which ﬁnds applications elsewhere.

The main step of the proof is designed to show that, under condition (2.2), µ1 and µ2 may be ‘coupled’ in such a way that the sub-diagonal S has full measure. This is achieved by constructing a certain Markov chain with the coupled measure as invariant measure.

Here is a preliminary calculation. Let µ be a strictly positive probability measure on ( ,F ). We may construct a reversible Markov chain with state space and unique invariant measure µ by choosing a suitable generator (or ‘Q-matrix’) satisfying the detailed balance equations. The dynamics of the chain involve the ‘switching on or off’ of components of the current state. Let G : 2 → R be given by

(2.9) G(ωe,ωe) = 1, G(ωe,ωe) =

µ(ωe) µ(ωe)

, ω ∈  , e ∈ E.

![image 39](<rcm1-1_images/imageFile39.png>)

We let G(ω,ω′) = 0 for all other pairs ω,ω′ with ω  = ω′. The diagonal elements G(ω,ω) are chosen in such a way that

ω′∈

G(ω,ω′) = 0, ω ∈  .

It is elementary that µ(ω)G(ω,ω′) = µ(ω′)G(ω′,ω), ω,ω′ ∈  ,

and therefore G generates a Markov chain on the state space which is reversible with respect to µ. The chain is irreducible, for the following reason. For ω,ω′ ∈

, one may add edges one by one to η(ω) thus arriving at the unit vector 1, and then one may remove edges one by one thus arriving at ω′. By (2.9), each such transition has a strictly positive intensity, whence the chain is irreducible. It follows that the chain has unique invariant measure µ. Similar constructions are explored in Chapter 8. An account of the general theory of reversible Markov chains may be found in [164, Section 6.5].

We follownexta similarroutefor pairs ofconﬁgurations. Letµ1 and µ2 satisfy the hypotheses of the theorem, and let S be the set of all ordered pairs (π,ω) of conﬁgurations in satisfying π ≤ ω. We deﬁne H : S × S → R by

(2.10) H(πe,ω; πe,ωe) = 1, H(π,ωe; πe,ωe) =

µ2(ωe) µ2(ωe)

(2.11) ,

![image 40](<rcm1-1_images/imageFile40.png>)

µ1(πe) µ1(πe) −

µ2(ωe) µ2(ωe)

H(πe,ωe; πe,ωe) =

(2.12) ,

![image 41](<rcm1-1_images/imageFile41.png>)

![image 42](<rcm1-1_images/imageFile42.png>)

for all (π,ω) ∈ S and e ∈ E; all other off-diagonal values of H are set to 0. The diagonal terms H(π,ω; π,ω) are chosen in such a way that

H(π,ω; π′,ω′) = 0, (π,ω) ∈ S.

(π′,ω′)∈S

Equation (2.10) speciﬁes that, for π ∈ and e ∈ E, the edge e is acquired by π (if it does not already contain it) at rate 1; any edge so acquired is added also to ω if it does not already contain it. (Here, we speak of a conﬁguration ψ ‘containing the edge e’ if ψ(e) = 1.) Equation (2.11) speciﬁes that, for ω ∈ and e ∈ E with ω(e) = 1, the edge e is removed from ω (and also from π if π(e) = 1) at the rate given in (2.11). For e with π(e) = 1, there is an additional rate given in (2.12) at which e is removed from π but not from ω. This additional rate is indeed non-negative, since the required inequality

(2.13) µ2(ωe)µ1(πe) ≥ µ1(πe)µ2(ωe) whenever π ≤ ω,

follows from (2.2) with ω1 = πe and ω2 = ωe.

Let (Yt, Zt)t≥0 be a Markov chain on S with generator H, and set (Y0, Z0) = (0,1), where 0 (respectively, 1) is the state of all zeros (respectively, ones). We write P for the appropriate probability measure. Since all transitions retain the orderingof the two componentsof the state, we mayassume thatthe chain satisﬁes P(Yt ≤ Zt for all t) = 1. By examination of (2.10)–(2.12) we see that Y = (Yt : t ≥ 0) is a Markov chain with generator given by (2.9) with µ = µ1, and that Z = (Zt : t ≥ 0) arises similarly with µ = µ2. Here is a brief explanation of this elementary step in the case of Y, a similar argument holds for Z. For π ∈ and e ∈ E,

P(Yt+h = πe | Yt = πe) =

P Yt+h = πe (Yt, Zt) = (πe,ω) P(Zt = ω | Yt = πe)

ω∈

[h + o(h)]P(Zt = ω | Yt = πe) by (2.10)

=

ω∈

= h + o(h).

Similarly, with Je the event that e is open, P(Yt+h = πe | Yt = πe)

P (Yt+h, Zt+h) = (πe,ω′) (Yt, Zt) = (πe,ωe) ×P(Zt = ωe | Yt = πe)

=

ω∈Je, ω′∈

H(πe,ωe; πe,ωe) + H(πe,ωe; πe,ωe) h + o(h) ×P(Zt = ωe | Yt = πe)

=

ω∈Je

µ1(πe) µ1(πe)

h + o(h) P(Zt = ωe | Yt = πe) by (2.11) and (2.12)

=

![image 43](<rcm1-1_images/imageFile43.png>)

ω∈Je

µ1(πe) µ1(πe)

h + o(h).

=

![image 44](<rcm1-1_images/imageFile44.png>)

Let κ be an invariant measure for the paired chain (Yt, Zt)t≥0. Since Y and Z have (respective) unique invariant measures µ1 and µ2, the marginals of κ are µ1 and µ2. Since P(Yt ≤ Zt for all t) = 1,

κ(S) = κ {(π,ω) : π ≤ ω} = 1,

and κ is the required ‘coupling’ of µ1 and µ2. Let (π,ω) ∈ S be chosen according to the measure κ. Then

µ1(X) = κ(X(π)) ≤ κ(X(ω)) = µ2(X), for any increasing function X. Therefore µ1 ≤st µ2.

Proof of Theorem 2.3. Inequality (2.4) is equivalent to

µ2(ζe)[µ1(ξe) + µ1(ξe)] ≥ µ1(ξe)[µ2(ζe) + µ2(ζe)], which is the same as (2.5). Therefore, (b) and (c) are equivalent.

It is clear that (a) implies (c). Suppose conversely that (c) holds. We identify a conﬁguration ω ∈ with the set of indices η(ω) at which ω takes the value 1. Let ω1,ω2 ∈ , and write Ak = η(ωk). Let B = A1 \ A2 = {b1,b2,. . .,br}, and write Bs = {b1,b2,. . .,bs} for s ≥ 1. Assume ω1  = ω2, and without loss of generality that r ≥ 1. By (2.5),

µ2(A2 ∪ B1) µ2(A2) ≥

µ2(A2 ∪ B) µ2(A2 ∪ Br−1) ·

µ2(A2 ∪ Br−1) µ2(A2 ∪ Br−2) ···

µ2(ω1 ∨ ω2) µ2(ω2) =

![image 45](<rcm1-1_images/imageFile45.png>)

![image 46](<rcm1-1_images/imageFile46.png>)

![image 47](<rcm1-1_images/imageFile47.png>)

![image 48](<rcm1-1_images/imageFile48.png>)

µ1((A1 ∩ A2) ∪ Br−1) µ1((A1 ∩ A2) ∪ Br−2)

µ1((A1 ∩ A2) ∪ B) µ1((A1 ∩ A2) ∪ Br−1) ·

![image 49](<rcm1-1_images/imageFile49.png>)

![image 50](<rcm1-1_images/imageFile50.png>)

µ1((A1 ∩ A2) ∪ B1) µ1(A1 ∩ A2)

···

![image 51](<rcm1-1_images/imageFile51.png>)

µ1(ω1) µ1(ω1 ∧ ω2) as required for (a). The above may be called a ‘telescoping’ argument. Proof of Theorem 2.6. We prove ﬁrst by a telescoping argument that (2.7) is equivalent to

=

![image 52](<rcm1-1_images/imageFile52.png>)

(2.14)

µ2(ζ) µ2(ξ) ≥

µ1(ζ) µ1(ξ)

, ξ,ζ ∈  , ξ ≤ ζ.

![image 53](<rcm1-1_images/imageFile53.png>)

![image 54](<rcm1-1_images/imageFile54.png>)

Asabove,weidentifyaconﬁgurationω ∈ withthesetofindicesη(ω)atwhichω takesthevalue1. That(2.14)implies(2.7)isimmediateonsettingζ = ωe, ξ = ωe. Conversely, let ξ,ζ ∈ satisfy ξ ≤ ζ. Let B = η(ζ) \ η(ξ) = {b1,b2,. . .,br}, and write Bs = {b1,b2,. . .,bs} for s ≥ 0. We may assume ξ  = ζ so that r ≥ 1. By (2.7),

r

µ2(ζ) µ2(ξ) =

![image 55](<rcm1-1_images/imageFile55.png>)

- s=1

µ2(η(ξ) ∪ Bs) µ2(η(ξ) ∪ Bs−1)

![image 56](<rcm1-1_images/imageFile56.png>)

≥

r

- s=1


µ1(η(ξ) ∪ Bs) µ1(η(ξ) ∪ Bs−1) =

µ1(ζ) µ1(ξ)

.

![image 57](<rcm1-1_images/imageFile57.png>)

![image 58](<rcm1-1_images/imageFile58.png>)

Inequality (2.8) may be written as

(2.15)

µ(ωef ) µ(ωef )

≥

![image 59](<rcm1-1_images/imageFile59.png>)

µ(ωef ) µ(ωef )

, ω ∈  , e, f ∈ E.

![image 60](<rcm1-1_images/imageFile60.png>)

[2.2] Positive association 25

The edge f is ‘switched on’ in both numerator and denominator of the left side, and ‘switched off’ on the right side. Let ξ,ζ ∈ and ξ ≤ ζ. By a sequential application of (2.15) toalledges(otherthanpossibly e) inη(ζ)\η(ξ),(2.8) implies

µ(ξe) µ(ξe)

µ(ζe) µ(ζe) ≥

(2.16)

, ξ ≤ ζ, e ∈ E.

![image 61](<rcm1-1_images/imageFile61.png>)

![image 62](<rcm1-1_images/imageFile62.png>)

It follows by Theorem 2.3 that

µ(ω1 ∨ ω2) µ(ω2) ≥

µ(ω1) µ(ω1 ∧ ω2)

(2.17)

, ω1,ω2 ∈  .

![image 63](<rcm1-1_images/imageFile63.png>)

![image 64](<rcm1-1_images/imageFile64.png>)

Assumethat(2.7)holds,andletω1,ω2 ∈ . Ifµ1 satisﬁes(2.8),thenitsatisﬁes (2.17), and (2.2) follows from (2.14) with ζ = ω1 ∨ ω2, ξ = ω2. Similarly, if µ2 satisﬁes (2.8), it satisﬁes (2.17), and (2.2) follows from (2.14) with ζ = ω1, ξ = ω1 ∧ ω2.

2.2 Positive association

Let E be a ﬁnite set as in the last section, and let = {0,1}E. A probability measure µ on is said to have the FKG lattice property if it satisﬁes the so-called FKG lattice condition:

(2.18) µ(ω1 ∨ ω2)µ(ω1 ∧ ω2) ≥ µ(ω1)µ(ω2), ω1,ω2 ∈  .

It is a consequence of the Holley inequality (Theorem 2.1), as follows, that any strictly positive probability measure with the FKG lattice property satisﬁes the so-called FKG inequality. A stronger result will appear at Theorem 2.27.

- (2.19) Theorem (FKG inequality) [124, 185]. Let µ be a strictly positive probability measure on satisfying the FKG lattice condition. Then
- (2.20) µ(XY) ≥ µ(X)µ(Y) for increasing functions X,Y : → R.


There is an extensive literature on the FKG inequality3 and its extensions. See, for example, [2, 25, 184]. One may extend the inequality to probability measures on sample spaces of the form T E with T a ﬁnite subset of R. In addition, some of the results of this section are valid for measures that are not strictly positive. Any probability measure µ satisfying (2.20) is said to have the property of ‘positive association’ or, more concisely, to be ‘positively associated’. We consider in Section 4.1 the positive association of measures on = {0,1}E when E is countably inﬁnite.

![image 65](<rcm1-1_images/imageFile65.png>)

3The history and origins of the FKG inequality are described in the Appendix.

Correlation-type inequalities play an important role in mathematical physics. For example, the FKG inequality is a fundamental tool in the study of the Ising and random-cluster models, see Chapter 3. There are many other correlation inequalities in statistical physics (see [118]), but these do not generally have a random-cluster equivalent and are omitted from the current work.

Proof. Since inequality (2.20) involves a ﬁnite set of real numbers only, it may in principle be proved in a totally elementary manner, [280]. We follow here the more interesting route via the Holley inequality, Theorem 2.1. Assume that µ satisﬁes the FKG lattice condition (2.18), and let X and Y be increasing functions. Let a > 0 and Y′ = Y + a. Since

µ(XY′) − µ(X)µ(Y′) = µ(XY) − µ(X)µ(Y), it sufﬁces to prove (2.20) with Y replaced by Y′. We may pick a sufﬁciently large that Y(ω) > 0 for all ω ∈ . Thus, it sufﬁces to prove (2.20) under the additional hypothesis that Y is strictly positive, and we assume henceforth that this holds. Deﬁne the strictly positive probability measures µ1 and µ2 on ( ,F ) by µ1 = µ and

Y(ω)µ(ω) ω′∈ Y(ω′)µ(ω′)

, ω ∈  .

µ2(ω) =

![image 66](<rcm1-1_images/imageFile66.png>)

Since Y is increasing, inequality (2.2) follows from (2.18). By the Holley inequality, µ2(X) ≥ µ1(X), which is to say that

ω∈ X(ω)Y(ω)µ(ω) ω′∈ Y(ω′)µ(ω′) ≥

X(ω)µ(ω).

![image 67](<rcm1-1_images/imageFile67.png>)

ω∈

If X is increasing and Y is decreasing, we may apply (2.20) to X and −Y to ﬁnd, under the conditions of the theorem, that µ(XY) ≤ µ(X)µ(Y). In the special case when X = 1A, Y = 1B, the indicator functions of events A and B, we obtain similarly that

(2.21) µ(A ∩ B) ≥ µ(A)µ(B) for increasing events A, B.

Let X = (X1, X2,. . ., Xr) be a vector of random variables taking values in {0,1}r. We speak of X as being positively associated if its law on {0,1}r is itself positively associated. Let Y = h(X) where h : {0,1}r → {0,1}s is a non-decreasing function. It is standard that the vector Y is positively associated whenever X is positively associated. The proof is straightforward, as follows. Let A, B be increasing subsets of {0,1}s. Then

P(Y ∈ A ∩ B) = P X ∈ {h−1A} ∩ {h−1B} ≥ P(X ∈ h−1A)P(X ∈ h−1B)

= P(Y ∈ A)P(Y ∈ B), since h−1A and h−1B are increasing subsets of {0,1}r.

We turn now to a consideration of the FKG lattice condition. Recall the Hamming distance between conﬁgurations deﬁned in (1.26). A pair ω1,ω2 ∈ is called comparable if either ω1 ≤ ω2 or ω1 ≥ ω2, and incomparable otherwise.

(2.22) Theorem. A strictly positive probability measure µ on ( , F ) satisﬁes the FKGlatticeconditionifandonlytheinequalityof (2.18) holdsforallincomparable pairs ω 1 ,ω 2 ∈   with H (ω 1 ,ω 2 ) = 2 .

For pairs ω 1 , ω 2 that differ on exactly two edges e and f , the inequality of (2.18) is equivalent to the statement that, conditional on the states of all other edges, the states of e and f are positively associated.

Proof. The inequality of (2.18) is a triviality when H (ω 1 ,ω 2 ) = 1, and the claim now follows by Theorem 2.6 with µ 1 = µ 2 = µ . See also [257, Lemma 6.5].  

TheFKGlatticeconditionissufﬁcientbutnotnecessaryfor positiveassociation. It is equivalent for strictly positive measures to a stronger property termed ‘strong positive-association’ (or, sometimes, ‘strong FKG’). For F ⊆ E and ξ ∈   , we write   F = { 0 , 1 } F and

$$
\Omega _ { F } ^ { \xi } = \{ \omega \in \Omega \, \colon \omega ( e ) = \xi ( e ) \text { for all } e \in E \ \ F \} ,
$$

the set of conﬁgurations that agree with ξ on the complement of F . Let µ be a probability measure on ( , F ) , and let F , ξ be such that µ(  ξ F ) > 0. We deﬁne the conditional probability measure µ ξ F on   F by

$$
\mu _ { F } ^ { \xi } ( \omega _ { F } ) = \mu ( \omega _ { F } \, | \, \Omega _ { F } ^ { \xi } ) = \frac { \mu ( \omega _ { F } \times \xi ) } { \mu ( \Omega _ { F } ^ { \xi } ) } , \quad \omega _ { F } \in \Omega _ { F } ,
$$

where ω F × ξ denotes the conﬁguration that agrees with ω F on F and with ξ on its complement. We say that µ is strongly positively-associated if: for all F ⊆ E and all ξ ∈   such that µ(  ξ F ) > 0, the measure µ ξ F is positively associated. We call µ monotonic if: for all F E , all increasing subsets A of   F , and all

We call µ monotonic if: for all F ⊆ E , all increasing subsets A of /Omega1 F , and all ξ, ζ ∈ /Omega1 such that µ(/Omega1 ξ F ), µ(/Omega1 ζ F ) > 0,

$$
\mu _ { F } ^ { \xi } ( A ) \leq \mu _ { F } ^ { \zeta } ( A ) \quad \text {whenever} \, \xi \leq \zeta .
$$

That is, µ is monotonic if, for all F ⊆ E ,

$$
\mu _ { F } ^ { \xi } \leq _ { \text {st} } \mu _ { F } ^ { \zeta } \quad \text {whenever} \, \xi \leq \zeta .
$$

We call µ 1monotonic if (2.26) holds for all singleton sets F . That is, µ is 1-monotonic if and only if, for all f ∈ E , µ( J f |   ξ f ) is a non-decreasing function of ξ . Here, J f denotes the event that f is open.

(2.27) Theorem4. Let µ be a strictly positive probability measure on ( ,F ). The following are equivalent.

(a) µ is strongly positively-associated. (b) µ satisﬁes the FKG lattice condition. (c) µ is monotonic. (d) µ is 1-monotonic.

It is a near triviality to check that any product measure on satisﬁes the FKG lattice condition, and thus product measures are strongly positively-associated. This is the q = 1 case of Theorem 3.8, and is usually referred to as Harris’s inequality,[181]. Wegivetwoexamplesofprobabilitymeasuresthatarepositively associated but do not satisfy the statements of the above theorem.

(2.28) Example5. Let ǫ,δ ∈ (0,1), and let µ0, µ1 be the probability measures on {0,1}3 given by

µ0(010) = µ0(001) = δ, µ0(000) = 1 − 2δ, µ1(111) = µ1(100) = 12.

![image 68](<rcm1-1_images/imageFile68.png>)

Let ǫ ∈ [0,1] and set µ = ǫµ0 + (1 − ǫ)µ1. Note that µ(011) = µ(101) = µ(110) = 0.

It may be checked that µ does not satisfy the FKG lattice condition whereas, for sufﬁciently small positive values of the constants ǫ, δ, the measure µ is positively associated. Note from the above that µ is not strictly positive. However, a strictly positive example may be arranged by replacing µ by the probability measure µ′ = (1 − η)µ + ηµ2 where

µ2(011) = µ2(101) = µ2(110) = 31 and η is small and positive.

![image 69](<rcm1-1_images/imageFile69.png>)

![image 70](<rcm1-1_images/imageFile70.png>)

(2.29) Example6. Let X and Y be independent Bernoulli random variables with parameter 21, so that

![image 71](<rcm1-1_images/imageFile71.png>)

P(X = 0) = P(X = 1) = 21, and similarly for Y. Let Z = max{X,Y}. It is clear that

![image 72](<rcm1-1_images/imageFile72.png>)

P(X = 1 | Z = 1) > P(X = 1), P(X = 1 | Y = Z = 1) = P(X = 1).

![image 73](<rcm1-1_images/imageFile73.png>)

- 4Closely related material is discussed in [204]. The equivalence of (a) and (b) is attributed in [8] to J. van den Berg and R. M. Burton (1987). See [136] for a further discussion of monotonic measures.
- 5Proposed by J. Steif. 6Proposed by J. van den Berg.


[2.2] Positive association 29

It is easy to deduce that the law µ of the triple (X,Y, Z) is not monotonic. It is however positively associated since the triple (X,Y, Z) is an increasing function of the independent pair X, Y.

As in the previous example, µ is not strictly positive, a weakness which we remedy differently than before. Let X′, Y′, Z′ (respectively, X′′, Y′′, Z′′) be Bernoulli random variables with parameter δ (respectively, 1−δ), and assume the maximal amount of independence. The triple

(A, B,C) = (X ∨ X′) ∧ X′′,(Y ∨ Y′) ∧ Y′′,(Z ∨ Z′) ∧ Z′′

isanincreasingfunctionofpositivelyassociatedrandomvariables,andistherefore positively associated. However, for small positive δ, it is only a small (stochastic) perturbation of the original triple (X,Y, Z), and one may check that (A, B,C) is notmonotonic. Itiseasily veriﬁedthat P((A, B,C) = ω) > 0 forall ω ∈ {0,1}3.

![image 74](<rcm1-1_images/imageFile74.png>)

Proof of Theorem 2.27. Throughout, µ is assumed strictly positive.

(a) ⇐⇒ (b). We prove ﬁrst that (a) implies (b). By Theorem 2.22, it sufﬁces to prove (2.18) for two incomparable conﬁgurations ω1, ω2 that disagree on exactly two distinct edges e, f ∈ E. We order E = (e1,e2,. . .,em) with e1 = e and e2 = f , and we express a conﬁguration ω as a ‘word’ ω(e1) · ω(e2) · . . . · ω(em) in the alphabet with two letters. Thus ω1 = 0 · 1 · w and ω2 = 1 · 0 · w for some word w of length |E| − 2. By strong positive-association, α(xy) = µ(x · y · w) satisﬁes

![image 75](<rcm1-1_images/imageFile75.png>)

α(11) α(00) + α(01) + α(10) + α(11) ≥ α(01) + α(11) α(10) + α(11) , which may be simpliﬁed to obtain as required that

α(11)α(00) ≥ α(01)α(10).

We prove next that (b) implies (a). Suppose (b) holds, and let F ⊆ E and ξ ∈ . It is immediate from (2.24) that

µξF(ω1 ∨ ω2)µξF(ω1 ∧ ω2) ≥ µξF(ω1)µξF(ω2), ω1,ω2 ∈ F.

By Theorem 2.19, µξF is positively associated. (b)  ⇒ (c). By the Holley inequality, Theorem 2.1, it sufﬁces to prove for ωF,ρF ∈ F that

![image 76](<rcm1-1_images/imageFile76.png>)

µζF(ωF ∨ ρF)µξF(ωF ∧ ρF) ≥ µζF(ωF)µξF(ρF) whenever ξ ≤ ζ. This is, by (2.24), an immediate consequence of the FKG lattice property applied to the pair ωF × ζ, ρF × ξ. (c)  ⇒ (d). This is trivial. (d)  ⇒ (b). Let µ be 1-monotonic. By Theorem 2.3, the pair µ, µ satisﬁes (2.2), which is to say that µ satisﬁes the FKG lattice condition.

![image 77](<rcm1-1_images/imageFile77.png>)

![image 78](<rcm1-1_images/imageFile78.png>)

2.3 Inﬂuence for monotonic measures

Let N ≥ 1, and let E be an arbitary ﬁnite set with |E| = N. We write = {0,1}E as usual, and F for the set of all subsets of . Let µ be a probability measure on ( ,F ), and A an increasing event. The (conditional) inﬂuence on A of the edge e ∈ E is deﬁned by

(2.30) IA(e) = µ(A | Je = 1) − µ(A | Je = 0),

where J = (Je : e ∈ E) denotes7 the identity function on . There has been an extensive study of the largest inﬂuence, maxe IA(e), when µ is a productmeasure, and this has been used to obtain concentration theorems for φp(A) viewed as a function of p, where φp denotes product measure with density p on . Such resultshave applicationsto severaltopicsincludingrandomgraphs,random walks, and percolation. Theorems concerning inﬂuence were ﬁrst proved for product measures, but they may be extended in a natural way to monotonic measures.

(2.31)Theorem(Inﬂuence)[141]. Thereexistsaconstantcsatisfyingc ∈ (0,∞) such thatthe followingholds. Let N ≥ 1, let E be a ﬁnite setwith |E| = N, and let A be an increasing subset of = {0,1}E. Let µ be a strictly positive probability measure on ( ,F ) that is monotonic. There exists e ∈ E such that

log N N

IA(e) ≥ c min µ(A),1 − µ(A)

.

![image 79](<rcm1-1_images/imageFile79.png>)

There are several useful references concerning inﬂuence for product measures, see [125, 126, 200, 201, 329] and their bibliographies. The order of magnitude N−1 log N is the best possible, see [34].

Proof. Letµbestrictlypositiveandmonotonic. Theideaistoencodeµintermsof Lebesgue measureλ on the Euclideancube [0,1]E, and then to apply the inﬂuence theorem8 of [67]. This will be done via a certain function f : [0,1]E → {0,1}E constructed next. A similar argument will be used to prove Theorem 3.45.

We may suppose without loss of generality that E = {1,2,. . ., N}. Let x = (xi : i = 1,2,. . ., N) ∈ [0,1]E, and let f (x) = ( fi(x) : i = 1,2,. . ., N) ∈ RE be given recursively as follows. The ﬁrst coordinate f1(x) is deﬁned by:

(2.32) with a1 = µ(J1 = 1), let f1(x) =

1 if x1 > 1 − a1, 0 otherwise.

Suppose we know the values fi(x) for i = 1,2,. . .,k − 1. Let (2.33) ak = µ Jk = 1 Ji = fi(x) for i = 1,2,. . .,k − 1 ,

![image 80](<rcm1-1_images/imageFile80.png>)

7Thus, Je denotes both the event {ω ∈ : ω(e) = 1} and its indicator function. 8An interesting aspect of the proof of this theorem is the use of discrete Fourier transforms

and hypercontractivity.

[2.3] Inﬂuence for monotonic measures 31

and deﬁne

(2.34) fk(x) =

1 if xk > 1 − ak, 0 otherwise.

It may be shown as follows that the function f : [0,1]E → {0,1}E is non-

decreasing. Let x ≤ x′, and write ak = ak(x) and ak′ = ak(x′) for the values in (2.32)–(2.33) corresponding to the vectors x and x′. Clearly a1 = a′

1, so that f1(x) ≤ f1(x′). Since µ is monotonic, a2 ≤ a′

2, implying that f2(x) ≤ f2(x′). Continuing inductively, we ﬁnd that fk(x) ≤ fk(x′) for all k, which is to say that

f (x) ≤ f (x′). Let A ∈ F be an increasing event, and let B be the increasing subset of [0,1]E

given by B = f −1(A). We make four notes concerning the deﬁnition of f . (a) For given x, each ak depends only on x1, x2,. . ., xk−1. (b) Since µ is strictly positive, the ak satisfy 0 < ak < 1 for all x ∈ [0,1]N and

k ∈ E. (c) For any x ∈ [0,1]N and k ∈ E, the values fk(x), fk+1(x),. . ., fN(x) de-

pendon x1, x2,. . ., xk−1 onlythroughthevalues f1(x), f2(x),. . ., fk−1(x). (d) The function f and the event B depend on the ordering of the set E.

Let U = (Ui : i = 1,2,. . ., N) be the identity function on [0,1]E, so that U has law λ. By the deﬁnition of f , f (U) has law µ. Hence, (2.35) µ(A) = λ( f (U) ∈ A) = λ(U ∈ f −1(A)) = λ(B).

Let

KB(i) = λ(B | Ui = 1) − λ(B | Ui = 0), where the conditional probabilities are interpreted as

λ(B | Ui = u) = lim ǫ↓0

λ B Ui ∈ (u − ǫ,u + ǫ) .

By [67, Thm 1], there exists a constant c ∈ (0,∞), independent of the choice of N and A, such that: there exists e ∈ E with

log N N

(2.36) KB(e) ≥ c min λ(B),1 − λ(B)

.

![image 81](<rcm1-1_images/imageFile81.png>)

We choose e accordingly. We claim that (2.37) IA(j) ≥ KB(j) for j ∈ E. By (2.35) and (2.36), it sufﬁces to prove (2.37). We prove ﬁrst that (2.38) IA(1) ≥ KB(1),

which is stronger than (2.37) with j = 1. By (b) and (c) above, (2.39) IA(1) = µ(A | J1 = 1) − µ(A | J1 = 0)

= λ(B | f1(U) = 1) − λ(B | f1(U) = 0)

= λ(B | U1 > 1 − a1) − λ(B | U1 ≤ 1 − a1)

= λ(B | U1 = 1) − λ(B | U1 = 0)

= KB(1).

We turn to (2.37) with j ≥ 2. We re-order the set E to bring the index j to the front. That is, we let F be the re-ordered index set F = (k1,k2,. . . ,kN) = (j,1,2,. . ., j − 1, j + 1,. . ., N). Let g = (gkr : r = 1,2,. . ., N) denote the associated function given by (2.32)–(2.34) subject to the new ordering, and let C = g−1(A). We claim that

(2.40) KC(k1) ≥ KB(j). By (2.39) with E replaced by F, KC(k1) = IA(j), and (2.37) follows. It remains to prove (2.40), and we use monotonicity again for this. It sufﬁces to prove that (2.41) λ(C | Uj = 1) ≥ λ(B | Uj = 1), together with the reversed inequality given Uj = 0. Let (2.42) U = (U1,U2,. . . ,Uj−1,1,Uj+1,. . .,UN).

![image 82](<rcm1-1_images/imageFile82.png>)

The 0/1-vector f (U) = ( fi(U) : i = 1,2,. . ., N) is constructed sequentially (as above)byconsideringtheindices1,2,. . ., N inturn. Atstagek,wedeclare fk(U) equal to 1 if Uk exceeds a certain function ak of the variables fi(U), 1 ≤ i < k. By the monotonicity of µ, this function is non-increasing in these variables. The index j plays a special role in that: (i) fj(U) = 1, and (ii) given this fact, it is more likely than before that the variables fk(U), j < k ≤ N, will take the value 1. The values fk(U), 1 ≤ k < j are unaffected by the value of Uj.

![image 83](<rcm1-1_images/imageFile83.png>)

![image 84](<rcm1-1_images/imageFile84.png>)

![image 85](<rcm1-1_images/imageFile85.png>)

![image 86](<rcm1-1_images/imageFile86.png>)

![image 87](<rcm1-1_images/imageFile87.png>)

![image 88](<rcm1-1_images/imageFile88.png>)

![image 89](<rcm1-1_images/imageFile89.png>)

Consider now the 0/1-vector g(U) = (gkr(U) : r = 1,2,. . ., N), constructed in the same manner as above but with the new ordering F of the index set E. First we examine index k1 (= j), and we automatically declare gk1(U) = 1 (since Uj = 1). We then construct gkr(U), r = 2,3,. . ., N, in sequence. Since the ak are non-decreasing in the variables constructed so far,

![image 90](<rcm1-1_images/imageFile90.png>)

![image 91](<rcm1-1_images/imageFile91.png>)

![image 92](<rcm1-1_images/imageFile92.png>)

![image 93](<rcm1-1_images/imageFile93.png>)

(2.43) gkr(U) ≥ fkr (U), r = 2,3,. . ., N. Therefore, g(U) ≥ f (U), and hence (2.44) λ(C | Uj = 1) = λ(g(U) ∈ A) ≥ λ( f (U) ∈ A) = λ(B | Uj = 1).

![image 94](<rcm1-1_images/imageFile94.png>)

![image 95](<rcm1-1_images/imageFile95.png>)

![image 96](<rcm1-1_images/imageFile96.png>)

![image 97](<rcm1-1_images/imageFile97.png>)

![image 98](<rcm1-1_images/imageFile98.png>)

![image 99](<rcm1-1_images/imageFile99.png>)

Inequality (2.41) has been proved. The same argument implies the reversed inequality obtained from (2.41) by changing the conditioning to Uj = 0. Inequality (2.40) follows, and the proof is complete.

[2.4] Sharp thresholds for increasing events 33

2.4 Sharp thresholds for increasing events

We consider next certain families of probability measures µp indexed by a parameter p ∈ (0,1), and we prove a sharp-threshold theorem subject to a hypothesis of monotonicity. The idea is as follows. Let A be a non-empty increasing event in = {0,1}N. Subject to a certain hypothesis on the µp, the function

f (p) = µp(A) is non-decreasing with f (0) = 0 and f (1) = 1. If A has a certain property of symmetry, the sharp-threshold theorem asserts that f (p) increases steeply from 0 to 1 over a short interval of p-values with length of order 1/log N.

We use the notation of the previous section. Let µ be a probability measure on ( ,F ). For p ∈ (0,1), let µp be the probability measure given by

(2.45) µp(ω) =

1 Zp

µ(ω)

![image 100](<rcm1-1_images/imageFile100.png>)

pω(e)(1 − p)1−ω(e) , ω ∈  ,

e∈E

where Zp is the normalizing constant

Zp =

ω∈

µ(ω)

pω(e)(1 − p)1−ω(e) .

e∈E

, and that (each) µp is strictly positive if and only if µ is strictly positive. It is easy to check that (each) µp satisﬁes the FKG lattice condition (2.18) if and only if µ satisﬁes this condition, and it follows by Theorem 2.27 that, for strictly positive µ, µ is monotonic if and only if (each) µp is monotonic. In order to prove a sharp-threshold theorem for the family µp, we present ﬁrst a differential formula of the type referred to as Russo’s formula, [154, Section 2.4].

It is elementary that µ = µ1

2

![image 101](<rcm1-1_images/imageFile101.png>)

- (2.46) Theorem [39]. For a random variable X : → R,
- (2.47)


1 p(1 − p)

d dp

covp(|η|, X), p ∈ (0,1),

µp(X) =

![image 102](<rcm1-1_images/imageFile102.png>)

![image 103](<rcm1-1_images/imageFile103.png>)

where covp denotes covariance with respect to the probability measure µp, and η(ω) is the set of ω-open edges.

We note for later use that

(2.48) covp(|η|, X) =

covp(Je, X).

e∈E

Proof. We follow [39, Prop. 4] and [156, Section 2.4]. Write

νp(ω) = p|η(ω)|(1 − p)N−|η(ω)|µ(ω), ω ∈  ,

34 Monotonic Measures [2.4]

so that (2.49) µp(X) =

1 Zp ω∈

X(ω)νp(ω).

![image 104](<rcm1-1_images/imageFile104.png>)

It is elementary that (2.50)

Z′p Zp

1 Zp ω∈

N − |η(ω)| 1 − p

d dp

|η(ω)| p −

X(ω)νp(ω) −

µp(X) =

µp(X),

![image 105](<rcm1-1_images/imageFile105.png>)

![image 106](<rcm1-1_images/imageFile106.png>)

![image 107](<rcm1-1_images/imageFile107.png>)

![image 108](<rcm1-1_images/imageFile108.png>)

![image 109](<rcm1-1_images/imageFile109.png>)

where Z′p = dZp/dp. Setting X = 1, we ﬁnd that 0 =

Z′p Zp

1 p(1 − p)

µp(|η| − pN) −

, whence

![image 110](<rcm1-1_images/imageFile110.png>)

![image 111](<rcm1-1_images/imageFile111.png>)

d dp

p(1 − p)

µp(X) = µp [|η| − pN]X − µp(|η| − pN)µp(X)

![image 112](<rcm1-1_images/imageFile112.png>)

= µp(|η|X) − µp(|η|)µp(X)

= covp(|η|, X).

Let be the group of permutations of E. Any π ∈ acts9 on by πω = (ω(πe) : e ∈ E). We say that a subgroup A of acts transitively on E if, for all pairs j,k ∈ E, there exists α ∈ A with αj = k.

Let A be a subgroup of . A probability measure φ on ( ,F ) is called Ainvariant ifφ(ω) = φ(αω)forallα ∈ A. Anevent A ∈ F iscalledA-invariant if A = αA for all α ∈ A. It is easily seen that, for any subgroup A, µ is A-invariant if and only if (each) µp is A-invariant.

- (2.51) Theorem (Sharp threshold) [141]. There exists a constant c satisfying c ∈ (0,∞) such that the following holds. Let N = |E| ≥ 1 and let A ∈ F be an increasing event. Let µ be a strictly positive probability measure on ( ,F ) that is monotonic. Suppose there exists a subgroup A of acting transitively on E such that µ and A are A-invariant. Then
- (2.52)


cmp p(1 − p)

d dp

min µp(A),1−µp(A) log N, p ∈ (0,1), where mp = µp(Je)(1 − µp(Je)).

µp(A) ≥

![image 113](<rcm1-1_images/imageFile113.png>)

![image 114](<rcm1-1_images/imageFile114.png>)

Let ǫ ∈ (0, 21) and let A be non-empty and increasing. Under the conditions of the theorem, µp(A) increases from ǫ to 1 − ǫ over an interval of values of p having length of order 1/log N. This amounts to a quantiﬁcation of the so-called S-shape results described and cited in [154, Section 2.5]. Note that mp does not depend on the choice of edge e.

![image 115](<rcm1-1_images/imageFile115.png>)

The proof is preceded by an easy lemma. Let Ip,A(e) = µp(A | Je = 1) − µp(A | Je = 0), e ∈ E.

![image 116](<rcm1-1_images/imageFile116.png>)

9This differs slightly from the deﬁnition of Section 4.3, for reasons of local convenience.

[2.5] Exponential steepness 35

(2.53) Lemma. Let A ∈ F . Suppose there exists a subgroup A of acting transitively on E such that µ and A are A-invariant. Then Ip,A(e) = Ip,A( f ) for all e, f ∈ E and all p ∈ (0,1).

Proof. Since µ is A-invariant, so is µp for every p. Let e, f ∈ E, and ﬁnd α ∈ A such that αe = f . Under the given conditions,

µp(A, Jf = 1) =

µp(αω)Je(αω)

µp(ω)Jf (ω) =

ω∈A

ω∈A

µp(ω′)Je(ω′) = µp(A, Je = 1).

=

ω′∈A

We deduce with A = that µp(Jf = 1) = µp(Je = 1). On dividing, we obtain that µp(A | Jf = 1) = µp(A | Je = 1). A similar equality holds with 1 replaced by 0, and the claim of the lemma follows.

Proof of Theorem 2.51. By Lemma 2.53, Ip,A(e) = Ip,A( f ) for all e, f ∈ E. Since A is increasing and µp is monotonic, each Ip,A(e) is non-negative, and therefore

covp(Je,1A) = µp(Je1A) − µp(Je)µp(A)

= µp(Je)(1 − µp(Je))Ip,A(e) ≥ mpIp,A(e), e ∈ E.

Summing over the index set E as in (2.47)–(2.48), we deduce (2.52) by Theorem 2.31 applied to the monotonic measure µp.

2.5 Exponential steepness

This chapter closes with a further differential inequality for the probability of a monotonic event. Let A ∈ F and ω ∈ . We deﬁne HA(ω) to be the Hamming distance from ω to A, that is,

(2.54) HA(ω) = inf H(ω′,ω) : ω′ ∈ A , where H(ω′,ω) is given in (1.26). Note that (2.55)

 

[ω′(e) − ω(e)] : ω′ ≥ ω, ω′ ∈ A if A is increasing,

inf

e

HA(ω) =

[ω(e) − ω′(e)] : ω′ ≤ ω, ω′ ∈ A if A is decreasing.



inf

e

Suppose now that A is increasing (respectively, decreasing). Here are three useful facts concerning HA.

36 Monotonic Measures [2.5]

- (i) HA is a decreasing (respectively, increasing) random variable.
- (ii) The function |η| + HA (respectively, |η| − HA) is increasing, since the addition of a single open edge to a conﬁguration ω causes |η(ω)| to increase by 1, and HA(ω) to decrease (respectively, increase) by at most 1.
- (iii) We have that HA(ω)1A(ω) = 0 for ω ∈ .


Given a probability measure µ on ( ,F ), the associated measures µp, p ∈ (0,1), are given by (2.45). (2.56) Theorem [153, 163]. Let µ be a strictly positive probability measure on ( ,F ) that is monotonic. For a non-empty event A ∈ F , and p ∈ (0,1),

µp(HA) p(1 − p)

d dp

(2.57) , if A is increasing,

logµp(A) ≥

![image 117](<rcm1-1_images/imageFile117.png>)

![image 118](<rcm1-1_images/imageFile118.png>)

µp(HA) p(1 − p)

d dp

(2.58) , if A is decreasing.

logµp(A) ≤ −

![image 119](<rcm1-1_images/imageFile119.png>)

![image 120](<rcm1-1_images/imageFile120.png>)

Inequality (2.57) bears a resemblance to a formula valid for percolation that may be written as

1 p

d dp

logφp(A) =

φp(NA | A),

![image 121](<rcm1-1_images/imageFile121.png>)

![image 122](<rcm1-1_images/imageFile122.png>)

where NA isthenumberofpivotaledgesforthe increasingevent A, andφp denotes product measure with density p on ( ,F ). See [154, p. 44] for further details.

Proof. Since µ is assumed strictly positive and monotonic, it satisﬁes the FKG lattice property. Therefore, every µp satisﬁes the FKG lattice property, and hence is positively associated. Let A ∈ F be non-empty and increasing. By (2.47), (ii)–(iii) above, and positive association,

1 p(1 − p)

d dp

covp(|η|,1A)

µp(A) =

![image 123](<rcm1-1_images/imageFile123.png>)

![image 124](<rcm1-1_images/imageFile124.png>)

1 p(1 − p)

covp(|η| + HA,1A) − covp(HA,1A)

=

![image 125](<rcm1-1_images/imageFile125.png>)

1 p(1 − p)

covp(HA,1A)

≥ −

![image 126](<rcm1-1_images/imageFile126.png>)

µp(HA)µp(A) p(1 − p)

=

, and (2.57) follows. The argument is easily adapted for decreasing A.

![image 127](<rcm1-1_images/imageFile127.png>)

Let A ∈ F be non-empty and increasing. Inequality (2.57) is usually used in integrated form. Integrating over the interval [r,s], and using the facts that p(1 − p) ≤ 41 and that HA is decreasing, we obtain that

![image 128](<rcm1-1_images/imageFile128.png>)

s

(2.59) µp(HA)dp

µr(A) ≤ µs(A)exp −4

r

≤ µs(A)exp −4(s − r)µs(HA) , 0 < r ≤ s < 1. This may sometimes be combined with a complementary inequality derived by a consideration of ‘ﬁnite energy’, see Theorem 3.45.

# Chapter 3

# Fundamental Properties

Summary. The basic properties of random-cluster measures are presented in a manner suitable for future applications. Accounts of conditional randomclustermeasures andpositive associationare followed by differential formulae, a sharp-threshold theorem, and exponential steepness. There are several useful inequalities involving partition functions. Theseries/parallel laws are formulated, and the chapter ends with a discussion of negative correlation.

# 3.1 Conditional probabilities

Throughout this chapter, G = ( V , E ) will be assumed to be a ﬁnite graph. Let φ G , p , q be the random-cluster measure on G . Whether or not a given edge e is open depends on the conﬁguration on the remainder of the graph. The relevant conditional probabilities may be described in the following useful manner.

For e =   x , y   ∈ E , the expression G \ e (respectively, G . e ) denotes the graph obtained from G by deleting (respectively, contracting) the edge e . We write     e   = { 0 , 1 } E \{ e } and, for ω ∈   , we deﬁne ω   e   ∈     e   by

$$
\omega _ { \langle e \rangle } ( f ) = \omega ( f ) , \quad f \in E , \, f \neq e .
$$

Let K e denote the event that x and y are joined by an open path not using e .

(3.1) Theorem (Conditional probabilities) [122]. Let p ∈ ( 0 , 1 ) , q ∈ ( 0 , ∞ ) . (a) We have for e E that

(a) We have for e ∈ E that

$$
\ p { G _ { \ } p , q } \left ( \omega \left | \, \omega ( e ) = j \right ) = \left \{ \begin{array} { l l } { \phi _ { G , p , q } ( \omega \left | \, \omega ( e ) = j \right ) = \left \{ \begin{array} { l l } { \phi _ { G \left | \, e , p , q } ( \omega _ { \left ( e \right ) } ) } & { i f j = 0 , } \\ { \phi _ { G . e , p , q } ( \omega _ { \left ( e \right ) } ) } & { i f j = 1 , } \end{array} } \end{array}
$$

and

$$
d a n \\ \phi _ { G , p , q } ( \omega ( e ) = 1 \, | \, \omega _ { ( e ) } ) = \left \{ \begin{array} { l l } { p } & { i f \omega _ { ( e ) } \in K _ { e } , } \\ { \frac { p } { p + q ( 1 - p ) } } & { i f \omega _ { ( e ) } \notin K _ { e } . } \end{array}
$$

c   Springer-Verlag 2006

38 Fundamental Properties [3.1]

(b) Conversely, if φ is a probability measure on ( ,F ) satisfying (3.3) for all ω ∈ and e ∈ E, then φ = φG,p,q.

The effect of conditioning on the absence or presence of an edge e is to replace the measure φG,p,q by the random-clustermeasure on the respectivegraph G\e or G.e. In addition, the conditionalprobabilitythat e is open, given the conﬁguration elsewhere, depends only on whether or not Ke occurs, and is then given by the stated formula. By (3.3),

(3.4) 0 < φG,p,q(ω(e) = 1 | ω e ) < 1, e ∈ E, p ∈ (0,1), q ∈ (0,∞).

Thus, given ω e , each of the two possible states of e occurs with a strictly positive probability. This usefulfact is known as the ‘ﬁnite-energy property’,and is related to the property of so-called ‘insertion tolerance’ (see Section 10.12).

We shall sometimes need to condition on the states of more than one edge. Towards this end, we state next a more general propertythan (3.2), beginningwith a brief discussion of boundary conditions; more on the latter topic may be found

in Section 4.2. Let ξ ∈ , F ⊆ E, and let ξF be the subset of containing all conﬁgurations ψ satisfying ψ(e) = ξ(e) for all e ∈/ F. We deﬁne the random-

cluster measure φξF,p,q on ( ,F ) by (3.5)

 

1 ZξF(p,q) e∈F

pω(e)(1 − p)1−ω(e) qk(ω,F) if ω ∈ ξF, 0 otherwise,

![image 129](<rcm1-1_images/imageFile129.png>)

φξF,p,q(ω) =



where k(ω, F) is the number of components of the graph (G,η(ω)) that intersect the set of endvertices of F, and

(3.6) ZξF(p,q) =

ω∈ ξF

pω(e)(1 − p)1−ω(e) qk(ω,F).

e∈F

Note that φξF,p,q( ξF) = 1. (3.7) Theorem. Let p ∈ [0,1], q ∈ (0,∞), and F ⊆ E. Let X be a random variable that is FF-measurable. Then

φG,p,q(X | TF)(ξ) = φξF,p,q(X), ξ ∈  .

In other words, given the states of edges not belonging to F, the conditional measure on F is a random-cluster measure subject to the retention of open connections of ξ using edges not belonging to F.

Here is a ﬁnal note. Let p ∈ (0,1) and q  = 1. It is easily seen that the states of two distinct edges e, f are independent if and only if the pair e, f lies in no circuit of G. This may be proved either directly or via the simulation methods of Sections 3.4 and 8.2.

[3.2] Positive association 39

Proof of Theorem 3.1. (a) This is easily seen by an expansion of the conditional probability,

φG,p,q(ωe)/φG,p,q(Je) if j = 0, φG,p,q(ωe)/φG,p,q(Je) if j = 1,

![image 130](<rcm1-1_images/imageFile130.png>)

φG,p,q(ω | ω(e) = j) =

where Je = {ω ∈ : ω(e) = 1}, and ωe, ωe are given by (1.25). Similarly,

ω ∈  ,

φG,p,q(ωe) φG,p,q(ωe) + φG,p,q(ωe)

φG,p,q(ω(e) = 1 | ω e ) =

![image 131](<rcm1-1_images/imageFile131.png>)

[p/(1 − p)]|η(ωe)|qk(ωe) [p/(1 − p)]|η(ωe)|qk(ωe) + [p/(1 − p)]|η(ωe)|qk(ωe)

=

![image 132](<rcm1-1_images/imageFile132.png>)

 

p/(1 − p) [p/(1 − p)] + 1

if ωe ∈ Ke, p/(1 − p) [p/(1 − p)] + q

![image 133](<rcm1-1_images/imageFile133.png>)

=



if ωe ∈/ Ke,

![image 134](<rcm1-1_images/imageFile134.png>)

where η(ω) is, as usual, the set of open edges in . (b) The claim is immediate by the fact, easily proved,that a strictly positive probability measure φ is speciﬁed uniquely by the conditional probabilities φ(ω(e) = 1 | ω e ), ω ∈ , e ∈ E.

Proof of Theorem 3.7. This holds by repeated application of (3.2), with one application for each edge not belonging in F.

3.2 Positive association

Let φp,q denote the random-cluster measure on G with parameters p and q. We shall see that φp,q satisﬁes the FKG lattice condition (2.18) whenever q ≥ 1, and we arrive thus at the following conclusion.

#### (3.8) Theorem (Positive association) [122]. Let p ∈ (0,1) and q ∈ [1,∞).

- (a) The random-cluster measure φp,q is strictly positive and satisﬁes the FKG lattice condition.
- (b) The random-cluster measure φp,q is strongly positively-associated, and in particular


φp,q(XY) ≥ φp,q(X)φp,q(Y) for increasing X,Y : → R, φp,q(A ∩ B) ≥ φp,q(A)φp,q(B) for increasing A, B ∈ F .

It is not difﬁcult to see that φp,q is not (in general) positively associated when q ∈ (0,1), as illustrated in the example following. Let G be the graph containing

just two vertices and having exactly two parallel edges e and f joining these vertices. It is an easy computation that

p2q2(q − 1)(1 − p)2 Z(p,q)2

(3.9) φp,q(Je ∩ Jf ) − φp,q(Je)φp,q(Jf ) =

,

![image 135](<rcm1-1_images/imageFile135.png>)

where Jg is the event that g is open. This is strictly negative if 0 < p,q < 1.

Proof of Theorem 3.8. Let p ∈ (0,1) and q ∈ [1,∞). Part (b) follows from (a) and Theorem 2.27. It is elementary that φp,q is strictly positive. We now check as required that φp,q satisﬁes the FKG lattice condition (2.18). Since the set η(ω) of open edges in a conﬁguration ω satisﬁes

(3.10) |η(ω1 ∨ ω2)| + |η(ω1 ∧ ω2)| = |η(ω1)| + |η(ω2)|, ω1,ω2 ∈  , it sufﬁces, on taking logarithms, to prove that (3.11) k(ω1 ∨ ω2) + k(ω1 ∧ ω2) ≥ k(ω1) + k(ω2), ω1,ω2 ∈  .

By Theorem 2.22, we may restrict our attention to incomparable pairs ω1, ω2 that differ on exactly two edges. There must then exist distinct edges e, f ∈ E

and a conﬁguration ω ∈ such that ω1 = ωef , ω2 = ωef . As in the proof of Theorem 2.27, we omit reference to the states of edges other than e and f , and

we write ω1 = 10 and ω2 = 01. Let Df be the indicator function of the event that the endvertices of f are connected by no open path of E \ { f }. Since Df is a decreasing random variable, we have that Df (10) ≤ Df (00). Therefore,

k(10) − k(11) = Df (10) ≤ Df (00) = k(00) − k(01), which implies (3.11).

Theorem 3.8 applies only to ﬁnite graphs G, whereas many potential applications concern inﬁnite graphs. We shall see in Sections 4.3 and 4.4 how to derive the required extension.

3.3 Differential formulae and sharp thresholds

One way of estimating the probability of an event A is via an estimate of its derivative dφp,q(A)/dp. When q = 1, there is a formula for this derivative which has proved very useful in reliability theory, percolation, and elsewhere, see [22, 126, 154, 287]. This formula has been extended to random-cluster measures. For ω ∈ , let |η| = |η(ω)| = e∈E ω(e) be the number of open edges of ω as usual, and k = k(ω) the number of open clusters.

[3.3] Differential formulae and sharp thresholds 41

(3.12) Theorem [39]. Let p ∈ (0,1), q ∈ (0,∞), and let φp,q be the corresponding random-cluster measure on a ﬁnite graph G = (V, E). We have that

1 p(1 − p)

d dp

(3.13) covp,q(|η|, X),

φp,q(X) =

![image 136](<rcm1-1_images/imageFile136.png>)

![image 137](<rcm1-1_images/imageFile137.png>)

1 q

d dq

(3.14) covp,q(k, X),

φp,q(X) =

![image 138](<rcm1-1_images/imageFile138.png>)

![image 139](<rcm1-1_images/imageFile139.png>)

for any random variable X : → R, where covp,q denotes covariance with respect to φp,q.

In most applications, we set X = 1A, the indicator function of some given event A, and we obtain that

(3.15)

φp,q(1A|η|) − φp,q(A)φp,q(|η|) p(1 − p)

d dp

φp,q(A) =

,

![image 140](<rcm1-1_images/imageFile140.png>)

![image 141](<rcm1-1_images/imageFile141.png>)

with a similar formula for the derivative with respect to q.

Here are two simple examples of Theorem 3.12 which result in monotonicities valid for all q ∈ (0,∞). Let h : R → R be non-decreasing. On setting X = h(|η|), we have from (3.13) that

1 p(1 − p)

d dp

covp,q(|η|,h(|η|)) ≥ 0.

φp,q(X) =

![image 142](<rcm1-1_images/imageFile142.png>)

![image 143](<rcm1-1_images/imageFile143.png>)

In the special case h(x) = x, we deduce that the mean number of open edges is a non-decreasing function of p, for all q ∈ (0,∞). Similarly, by (3.14), for non-decreasing h,

d dq

φp,q(h(k)) =

![image 144](<rcm1-1_images/imageFile144.png>)

1 q

covp,q(k,h(k)) ≥ 0.

![image 145](<rcm1-1_images/imageFile145.png>)

This time we take h = −1(−∞,1], so that −h is the indicator function of the event that the open graph (V,η(ω)) is connected. We deduce that the probability of connectedness is a decreasing function of q on the interval (0,∞). These examples are curiosities, given the failure of stochastic monotonicity when q < 1.

Let q ∈ [1,∞). Since φp,q satisﬁes the FKG lattice condition (2.18), it is monotonic. Let A be a subgroup of the automorphism group1 Aut(G) of the graph G = (V, E). We call E A-transitive if A acts transitively on E.

![image 146](<rcm1-1_images/imageFile146.png>)

1The automorphism group Aut(G) is discussed further in Sections 4.3 and 10.12.

- (3.16) Theorem (Sharp threshold) [141]. There exists an absolute constant c ∈ (0,∞) such that the following holds. Let A ∈ F be an increasing event, and suppose there exists a subgroup A of Aut(G) such that E is A-transitive and A is A-invariant. Then, for p ∈ (0,1) and q ∈ [1,∞),
- (3.17)


d dp

φp,q(A) ≥ C min φp,q(A),1 − φp,q(A) log|E|,

![image 147](<rcm1-1_images/imageFile147.png>)

where

q {p + q(1 − p)}2

C = c min 1,

.

![image 148](<rcm1-1_images/imageFile148.png>)

Since q ≥ 1, (3.17) implies that

c q

d dp

min φp,q(A),1 − φp,q(A) log|E|,

(3.18)

φp,q(A) ≥

![image 149](<rcm1-1_images/imageFile149.png>)

![image 150](<rcm1-1_images/imageFile150.png>)

an inequality that may be integrated directly. Let p1 = p1(A,q) ∈ (0,1) be chosen such that φp1,q(A) ≥ 12. Then

![image 151](<rcm1-1_images/imageFile151.png>)

d dp

log[1 − φp,q(A)] ≥

−

![image 152](<rcm1-1_images/imageFile152.png>)

c q

log|E|, p ∈ (p1,1),

![image 153](<rcm1-1_images/imageFile153.png>)

and hence, by integration, (3.19) φp,q(A) ≥ 1 − 12|E|−c(p−p1)/q, p ∈ (p1,1), q ∈ [1,∞), whenever the conditions of Theorem 3.16 are satisﬁed. If in addition p1 ≥ √q/(1 +

![image 154](<rcm1-1_images/imageFile154.png>)

√q), then C = c, and hence

![image 155](<rcm1-1_images/imageFile155.png>)

![image 156](<rcm1-1_images/imageFile156.png>)

(3.20) φp,q(A) ≥ 1 − 12|E|−c(p−p1), p ∈ (p1,1). An application to box crossings in two dimensions may be found in [141]. Proof of Theorem 3.12. The ﬁrst formula was proved for Theorem 2.46, and the second is obtained in a similar fashion.

![image 157](<rcm1-1_images/imageFile157.png>)

Proof of Theorem 3.16. With A as in the theorem, φp,q is A-invariant since A ⊆ Aut(G). The claim is a consequence of Theorem 2.51 on noting from (3.3) that

φp,q(Je)φp,q(Je) p(1 − p) ≥ min 1,

q [p + q(1 − p)]2

![image 158](<rcm1-1_images/imageFile158.png>)

, e ∈ E.

![image 159](<rcm1-1_images/imageFile159.png>)

![image 160](<rcm1-1_images/imageFile160.png>)

3.4 Comparison inequalities

The comparison inequalities of this section are an important tool in the study of random-clustermeasures. As usual, we write φp,q for the random-clustermeasure on the ﬁnite graph G = (V, E).

(3.21) Theorem (Comparison inequalities) [122]. It is the case that: (3.22) φp1,q1 ≤st φp2,q2 if q1 ≥ q2, q1 ≥ 1, and p1 ≤ p2,

p2 q2(1 − p2)

p1 q1(1 − p1) ≥

(3.23) .

φp1,q1 ≥st φp2,q2 if q1 ≥ q2, q1 ≥ 1, and

![image 161](<rcm1-1_images/imageFile161.png>)

![image 162](<rcm1-1_images/imageFile162.png>)

The ﬁrst of these inequalities may be strengthened as in the next theorem. A subset W of the vertex set V is called spanning if every edge of E is incident to at least one vertex of W. The degree deg(W) of a spanning set W is deﬁned to be the maximum degree of its members, that is, the maximum number of edges of G incident to any one vertex in W.

- (3.24) Theorem [151]. For ∈ {1,2,. . .}, there exists a continuous function γ(p,q) = γ (p,q), which is strictly increasing in p on (0,1), and strictly decreasing in q on [1,∞), such that the following holds. Let G be a ﬁnite graph, and suppose there exists a spanning set W such that deg(W) ≤ . Then
- (3.25) φp1,q1 ≤st φp2,q2 if 1 ≤ q2 ≤ q1 and γ(p1,q1) ≤ γ(p2,q2).


An application is to be found in Section 5.1, where it is proved that the critical point pc(q) of an inﬁnite-volume random-cluster model on a lattice is strictly increasing in q.

Proof of Theorem 3.21. We may assume that p1, p2 ∈ (0,1), since the othercases are straightforward. We may either apply the Holley inequality (Theorem 2.1) or use the positive association of random-clustermeasures (Theorem3.8) as follows. Let X : → R be increasing. Then

φp2,q2(X)

1 Z(p2,q2) ω∈

X(ω)p2|η(ω)|(1 − p2)|E\η(ω)|q2k(ω)

=

![image 163](<rcm1-1_images/imageFile163.png>)

|E| 1 Z(p2,q2) ω∈

1 − p2 1 − p1

X(ω)Y(ω)p1|η(ω)|(1 − p1)|E\η(ω)|q1k(ω)

=

![image 164](<rcm1-1_images/imageFile164.png>)

![image 165](<rcm1-1_images/imageFile165.png>)

|E| Z(p1,q1) Z(p2,q2)

1 − p2 1 − p1

φp1,q1(XY)

=

![image 166](<rcm1-1_images/imageFile166.png>)

![image 167](<rcm1-1_images/imageFile167.png>)

where

k(ω) p2/(1 − p2) p1/(1 − p1)

|η(ω)|

q2 q1

Y(ω) =

.

![image 168](<rcm1-1_images/imageFile168.png>)

![image 169](<rcm1-1_images/imageFile169.png>)

Setting X = 1, we obtain

φp2,q2(1) = 1 =

whence, on dividing,

1 − p2 1 − p1

![image 170](<rcm1-1_images/imageFile170.png>)

|E| Z(p1,q1) Z(p2,q2)

φp1,q1(Y),

![image 171](<rcm1-1_images/imageFile171.png>)

φp1,q1(XY) φp1,q1(Y)

(3.26) φp2,q2(X) =

.

![image 172](<rcm1-1_images/imageFile172.png>)

Assume now that the conditions of (3.22) hold. Since k(ω) is a decreasing function and |η(ω)| is increasing, we have that Y is increasing. Since q1 ≥ 1, φp1,q1 is positively associated, whence

(3.27) φp1,q1(XY) ≥ φp1,q1(X)φp1,q1(Y), and (3.26) yields φp2,q2(X) ≥ φp1,q1(X). Claim (3.22) follows.

Assume now that the conditions of (3.23) hold. We write Y(ω) in the form

k(ω)+|η(ω)| p2/[q2(1 − p2)] p1/[q1(1 − p1)]

|η(ω)|

q2 q1

Y(ω) =

.

![image 173](<rcm1-1_images/imageFile173.png>)

![image 174](<rcm1-1_images/imageFile174.png>)

Note that k(ω) + |η(ω)| is an increasing function of ω, since the addition of an extra open edge to ω causes |η(ω)| to increase by 1 and k(ω) to decrease by at most 1. In addition, |η(ω)| is increasing. Since q2 ≤ q1 and p2/[q2(1 − p2)] ≤ p1/[q1(1 − p1)] by assumption, we have that Y is decreasing. By the positive association of φp1,q1 as above,

φp1,q1(XY) ≤ φp1,q1(X)φp1,q1(Y), and (3.26) now implies φp2,q2(X) ≤ φp1,q1(X). Claim (3.23) follows.

The proof of Theorem 3.24 begins with a subsidiary result. This contains two inequalities, only the ﬁrst of which will be used in that which follows.

- (3.28) Proposition [151]. Let p ∈ (0,1), q ∈ [1,∞) and ∈ {1,2,. . .}. There exists a strictly positive and continuous function α(p,q) = α (p,q) such that the following holds. Let G be a ﬁnite graph, and suppose there exists a spanning set W such that deg(W) ≤ . Then
- (3.29) α(p,q)


∂ ∂p

∂ ∂q

∂ ∂p

φp,q(A) ≤ p(1 − p)

φp,q(A) ≤ −q

φp,q(A)

![image 175](<rcm1-1_images/imageFile175.png>)

![image 176](<rcm1-1_images/imageFile176.png>)

![image 177](<rcm1-1_images/imageFile177.png>)

for all increasing events A.

Proof. Let A be an increasing event, and write θ(p,q) = φp,q(A). As in the proof of Theorem 2.1 we shall construct a Markov chain Zt = (Xt,Yt) taking values in the product space 2.

Let ω ∈ and e ∈ E, and let ωe, ωe be the conﬁgurations given at (1.25). Let De(ω) be the indicatorfunctionof the eventthatthe endverticesof e are connected by no open path of E \{e}. We deﬁne the functions H, H A : 2 → R as follows. First,

(3.30) H(ωe,ωe) = 1, H(ωe,ωe) =

1 − p p

(3.31) qDe(ω),

![image 178](<rcm1-1_images/imageFile178.png>)

for ω ∈ and e ∈ E. Secondly, H(ω,ω′) = 0 for other pairs ω,ω′ with ω  = ω′. Next, we deﬁne H A by

(3.32) H A(ω,ω′) = H(ω,ω′)1A(ω ∧ ω′) if ω  = ω′. The diagonal terms H(ω,ω) and H A(ω,ω) are chosen in such a way that

ω′∈

H(ω,ω′) =

ω′∈

H A(ω,ω′) = 0, ω ∈  .

Let S = {(π,ω) ∈ 2 : π ≤ ω}, the set of all ordered pairs of conﬁgurations, and let J : S × S → R be given by

(3.33) J(πe,ω; πe,ωe) = 1, (3.34) J(π,ωe; πe,ωe) = H A(ωe,ωe), (3.35) J(πe,ωe; πe,ωe) = H(πe,πe) − H A(ωe,ωe),

for e ∈ E. Allotheroff-diagonalvaluesof J are setto 0,and the diagonalelements are chosen such that

J(π,ω; π′,ω′) = 0, (π,ω) ∈ S.

(π′,ω′)∈S

The function J will be used as the generator of a Markov chain Z = (Zt : t ≥ 0) on the state space S ⊆ 2. With J viewed in this way, equation (3.33) speciﬁes that, for π ∈ and e ∈ E, the edge e is acquired by π (if it does not already contain it) at rate 1; any edge thus acquired is added also to ω if it does not already contain it. Equation (3.34) speciﬁes that, for ω ∈ and e ∈ η(ω), the edge e is removed from ω (and also from π if e ∈ η(π)) at rate H A(ωe,ωe). For e ∈ η(π) (⊆ η(ω)), there is an additional rate at which e is removed from π but not from ω. This additional rate is indeed non-negative, since

1 − p p

H(πe,πe) − H A(ωe,ωe) =

![image 179](<rcm1-1_images/imageFile179.png>)

qDe(π) − qDe(ω)1A(ωe) ≥ 0,

by (3.31) and (3.32). We have used the facts that q ≥ 1, and De(ω) ≤ De(π) for π ≤ ω. The ensuing Markov chain has no possible transition that can exit the set S. That is, if the chain starts in S, then we may assume it remains in S for all time.

It is easily seen as in Section 2.1 and [39] that there exists a Markov chain Zt = (Xt,Yt) on the state space S such that:

(i) Zt has generator J, that is, for (π,ω)  = (π′,ω′),

P Zt+h = (π′,ω′) Zt = (π,ω) = J(π,ω; π′,ω′)h + o(h),

(ii) Xt ⇒ φp,q(·) as t → ∞, (iii) Yt ⇒ φp,q(· | A) as t → ∞, (iv) Xt ≤ Yt for all t.

See [164, Chapter 6] for an account of the theory of Markov chains.

Differentiating θ = θ(p,q) = φp,q(A) with respect to p, one obtains as in Theorem 3.12 that

1 p(1 − p)

∂θ ∂p =

(3.36) covp,q(|η|,1A)

![image 180](<rcm1-1_images/imageFile180.png>)

![image 181](<rcm1-1_images/imageFile181.png>)

1 p(1 − p)

φp,q(|η|1A) − φp,q(|η|)φp,q(A)

=

![image 182](<rcm1-1_images/imageFile182.png>)

θ(p,q) p(1 − p)

lim

P |η(Yt)| − |η(Xt)|

=

![image 183](<rcm1-1_images/imageFile183.png>)

t→∞

θ(p,q) p(1 − p) e∈E

lim

P Xt(e) = 0, Yt(e) = 1 ,

=

![image 184](<rcm1-1_images/imageFile184.png>)

t→∞

where |η| = |η(ω)| is the number of open edges, and P is the appropriate probability measure for the chain Z. A similar calculation using (3.14) yields that

(3.37)

∂θ ∂q =

![image 185](<rcm1-1_images/imageFile185.png>)

1 q

1 q

covp,q(k,1A) = −

![image 186](<rcm1-1_images/imageFile186.png>)

θ(p,q) lim

P k(Xt) − k(Yt) ,

![image 187](<rcm1-1_images/imageFile187.png>)

t→∞

where k = k(ω) is the number of open components. By an elementary graph-theoretic argument,

k(Xt) − k(Yt) ≤ |η(Yt)| − |η(Xt)|, whence, by (3.36)–(3.37),

∂θ ∂p

∂θ ∂q ≤ p(1 − p)

−q

,

![image 188](<rcm1-1_images/imageFile188.png>)

![image 189](<rcm1-1_images/imageFile189.png>)

which is the right-hand inequality of (3.29).

Let be a positive integer, and let W be a spanning set of vertices satisfying deg(W) ≤ . For x ∈ V, let Ix be the indicator function of the event that x is an isolated vertex. Clearly,

P Ix(Xt) = 1, Ix(Yt) = 0 ,

(3.38) P k(Xt) − k(Yt) ≥

x∈W

since the right-hand side counts the number of vertices of W that are isolated in Xt but not in Yt. Let x ∈ W, and let ex be any edge of E that is incident to x. We claim that

(3.39) νP Xt(ex) = 0, Yt(ex) = 1 ≤ P Ix(Xt+1) = 1, Ix(Yt+1) = 0

for some ν = ν (p,q) which is continuous, and is strictly positive on (0,1) × [1,∞). Here, ν is allowed to depend on the value of but not further upon x, ex, W, G, or the choice of event A. Once (3.39) is proved, the left-hand inequality of (3.29) follows with α = νp(1 − p)/  by summing (3.39) over x and using (3.36)–(3.38) as follows:

∂θ ∂q ≥ θ lim

P Ix(Xt+1) = 1, Ix(Yt+1) = 0

−q

![image 190](<rcm1-1_images/imageFile190.png>)

t→∞ x∈W

1

P Xt(e) = 0, Yt(e) = 1

≥ θν lim

![image 191](<rcm1-1_images/imageFile191.png>)

t→∞ x∈W

e: e∼x

θν

P Xt(e) = 0, Yt(e) = 1

lim

≥

![image 192](<rcm1-1_images/imageFile192.png>)

t→∞ e∈E

νp(1 − p) ∂θ ∂p

=

,

![image 193](<rcm1-1_images/imageFile193.png>)

![image 194](<rcm1-1_images/imageFile194.png>)

where e:e∼x denotes summation over all edges e incident to the vertex x.

Finally we prove (3.39). Let Ex be the set of edges of E that are incident to x. Suppose that the event Ft = {Xt(ex) = 0, Yt(ex) = 1} occurs. Let:

- (a) T be the event that, during the time-interval (t,t + 1), every edge e of Ex \ {ex} with Xt(e) = 1 changes its X-state from 1 to 0; the removal of such edges from X may or may not entail their removal from Y,
- (b) U be the event that no edge e of Ex \ {ex} with Xt(e) = 0 changes its state (Xu(e),Yu(e)) in the time-interval (t,t + 1), (c) V be the event that the state (Xu(ex),Yu(ex)) of the edge ex remains unchanged during the time-interval (t,t + 1).


By elementary computations using the generator of the chain Zt = (Xt,Yt), there exists a strictly positive and continuousfunction νW = νW(p,q) on (0,1)× [1,∞), whichisallowedtodependon G and W onlythroughthequantitydeg(W), such that

P(T ∩ U ∩ V | Ft) ≥ νW, t ≥ 0,

uniformly in x, ex, and G. This inequality remains true if we replace νW by the strictly positive and continuous function ν = ν (p,q) deﬁned by

ν (p,q) = min νW(p,q) : W a spanning set such that 0 ≤ deg(W) ≤ .

If Ft ∩ T ∩ U ∩ V occurs, then x is isolated in Xt+1 but not in Yt+1 (since Yt+1(ex) = 1). Therefore, (3.39) is valid, and the proof of the proposition is complete. A function ν of the required form may be written down explicitly.

Proof of Theorem 3.24. Let α be as in Proposition 3.28, and let A be an increasing event. Inequality (3.29) may be stated in the form

(3.40) (α,q).∇φp,q(A) ≤ 0 ≤ (p(1 − p),q).∇φp,q(A),

where

∇ f =

∂f ∂q

∂f ∂p

,

![image 195](<rcm1-1_images/imageFile195.png>)

![image 196](<rcm1-1_images/imageFile196.png>)

, f : (0,1) × [1,∞) → R.

In addition, by Theorem 3.21,

∂ ∂q

φp,q(A) ≤ 0 ≤

![image 197](<rcm1-1_images/imageFile197.png>)

∂ ∂p

φp,q(A).

![image 198](<rcm1-1_images/imageFile198.png>)

The right-hand inequality of (3.40) may be used to obtain (3.23), but our current interest lies with the left-hand inequality. Let γ : (0,1) × [1,∞) be a solution of the differential equation (α,q).∇γ = 0 subject to

(3.41)

∂γ ∂q

< 0 <

![image 199](<rcm1-1_images/imageFile199.png>)

∂γ ∂p

, p ∈ (0,1), q ∈ (1,∞).

![image 200](<rcm1-1_images/imageFile200.png>)

See Figure 3.1 for a sketch of the contours of γ, that is, the curves on which γ is constant. The contour of γ passing through the point (p,q) has tangent (α,q). The directional derivative of φp,q(A) in this direction satisﬁes, by (3.40),

∂ ∂p

(α,q).∇φp,q(A) = α

∂ ∂q

φp,q(A) + q

![image 201](<rcm1-1_images/imageFile201.png>)

φp,q(A) ≤ 0,

![image 202](<rcm1-1_images/imageFile202.png>)

whence φp,q(A) is decreasing as (p,q) moves along the contour of γ in the direction of increasing q. Therefore,

φp1,q1(A) ≤ φp2,q2(A) if γ(p1,q1) = γ(p2,q2) and 1 ≤ q2 ≤ q1, and (3.25) follows.

This may be used in the following way. By (3.46)

K

∞

[1 − Ckφs,q(A)],

φr,q(HA > k) ≥

φr,q(HA) =

k=0

k=0

where K = max{k : Ckφs,q(A) ≤ 1}. Since C > 1,

− logφs,q(A) logC −

C − φs,q(A) C − 1

(3.47) φr,q(HA) ≥

, 0 < r < s < 1.

![image 203](<rcm1-1_images/imageFile203.png>)

![image 204](<rcm1-1_images/imageFile204.png>)

Inequalities (3.43) and (3.47) provide a mechanism for bounding below the gradient of log φp,q(A).

One area of potential application is the study of connection probabilities. Let S and T be disjoint sets of vertices of G, and let A = {S ↔ T} be the event that there exists an open path joining some s ∈ S to some t ∈ T. Then HA is the minimum number of closed edges amongst the family of all paths from S to T, which is to say that

HA(ω) = min

[1 − ω(e)] : π ∈ .

e∈π

Before proceeding to the proofs, we note that Theorem 3.45 is closely related to the ‘sprinkling lemma’ of [6], a version of which is valid for random-cluster models; see also [154]. The argument used to prove Theorem 3.45 may be used also to prove the following, the proof of which is omitted.

- (3.48) Theorem. Let q ∈ [1,∞) and 0 < r < s < 1. For any non-empty, decreasing event A ∈ F ,
- (3.49) φr,q(A) ≥


k

s − r qs

φs,q(HA ≤ k), k = 0,1,2,. . ..

![image 205](<rcm1-1_images/imageFile205.png>)

Proof of Theorem 3.45. Let q ∈ [1,∞) and 0 < r < s < 1. We shall employ a suitable coupling of the measures φr,q and φs,q. Let E = {e1,e2,. . . ,em} be the edges of the graph G, and let U1,U2,. . .,Um be independent random variables having the uniform distribution on [0,1]. We write P for the probability measure associated with the Uj. We shall examine the edges in turn, to determine whether they are open or closed for the respective parameters r and s. The outcome will be a pair (π,ω) of conﬁgurations each lying in = {0,1}E and such that π ≤ ω. The conﬁgurations π, ω are random in the sense that they are functions of the Uj. A similar coupling was used in the proof of Theorem 2.31.

First, we declare

π(e1) = 1 if and only if U1 < φr,q(J1), ω(e1) = 1 if and only if U1 < φs,q(J1),

[3.5] Exponential steepness 51

where Ji is the event that ei is open. By the comparison inequality (3.22), φr,q(J1) ≤ φs,q(J1), and therefore π(e1) ≤ ω(e1).

Let M be an integer satisfying 1 ≤ M < m. Having deﬁned π(ei), ω(ei) for 1 ≤ i ≤ M such that π(ei) ≤ ω(ei), we deﬁne π(eM+1) and ω(eM+1) as follows. We declare

π(eM+1) = 1 if and only if UM+1 < φr,q(JM+1 | M,π), ω(eM+1) = 1 if and only if UM+1 < φs,q(JM+1 | M,ω),

where M,γ is the set of conﬁgurations ν ∈ satisfying ν(ei) = γ(ei) for 1 ≤ i ≤ M. By the comparison inequalities (Theorem 3.21) and strong positive association (Theorem 3.8),

φr,q(JM+1 | M,π) ≤ φs,q(JM+1 | M,ω)

since r < s and π(ei) ≤ ω(ei) for 1 ≤ i ≤ M. Therefore, π(eM+1) ≤ ω(eM+1). Continuing likewise, we obtain a pair (π,ω) of conﬁgurations satisfying π ≤ ω, and such that π has law φr,q, and ω has law φs,q.

By Theorem 3.1,

p p + q(1 − p)

φp,q(Ji | Ki) =

, φp,q(Ji | Ki) = p,

![image 206](<rcm1-1_images/imageFile206.png>)

![image 207](<rcm1-1_images/imageFile207.png>)

where Ki istheeventthatthereexistsanopenpathof E\{ei}joiningtheendvertices of ei. Using conditional expectations and the assumption q ≥ 1,

p p + q(1 − p) ≤ φp,q(Ji | D) ≤ p

(3.50)

![image 208](<rcm1-1_images/imageFile208.png>)

for any event D deﬁned in terms of the states of edges in E \ {ei}. Therefore2, by the deﬁnition of the π(ei) and ω(ei),

P π(eM+1) = 0 U1,U2,. . .,UM = 1 − φr,q(JM+1 | M,π) ≤

q(1 − r) r + q(1 − r)

.

![image 209](<rcm1-1_images/imageFile209.png>)

We claim that

(3.51) P ω(eM+1) = 1, π(eM+1) = 0 U1,U2,. . .,UM

= φs,q(JM+1 | M,ω) − φr,q(JM+1 | M,π) ≥

s − r q

,

![image 210](<rcm1-1_images/imageFile210.png>)

![image 211](<rcm1-1_images/imageFile211.png>)

2Subject to the correct interpretation of the conditional measure in question.

andtheproofofthisfollows. ByTheorem3.42with A = Ji (sothat HJi = 1−1Ji) together with (3.50),

φp,q(Ji)(1 − φp,q(Ji)) p(1 − p) ≥

1 p + q(1 − p) ≥

1 q

d dp

φp,q(Ji) ≥

.

![image 212](<rcm1-1_images/imageFile212.png>)

![image 213](<rcm1-1_images/imageFile213.png>)

![image 214](<rcm1-1_images/imageFile214.png>)

![image 215](<rcm1-1_images/imageFile215.png>)

We integrate over the interval [r,s] to obtain that (3.52) φs,q(Ji) − φr,q(Ji) ≥

s − r q

. Finally,

![image 216](<rcm1-1_images/imageFile216.png>)

φs,q(JM+1 | M,ω) − φr,q(JM+1 | M,π) ≥ φs,q(JM+1 | M,ω) − φr,q(JM+1 | M,ω),

and (3.51) follows by applying (3.52) with i = M + 1 to the graph obtained from G by contracting (respectively, deleting) any edge ei (for 1 ≤ i ≤ M) with ω(ei) = 1 (respectively, ω(ei) = 0). See [152, Theorem 2.3].

By the above, (3.53)

r + q(1 − r) q(1 − r)

s − r q ·

P ω(eM+1) = 1 π(eM+1) = 0, U1,U2,. . .,UM ≥

.

![image 217](<rcm1-1_images/imageFile217.png>)

![image 218](<rcm1-1_images/imageFile218.png>)

Let ξ ∈ , and let B be a set of edges satisfying ξ(e) = 0 for e ∈ B. We claim

that (3.54)

|B|

r + q(1 − r) q(1 − r)

s − r q ·

P(π = ξ, ω(e) = 1 for e ∈ B) ≥

P(π = ξ).

![image 219](<rcm1-1_images/imageFile219.png>)

![image 220](<rcm1-1_images/imageFile220.png>)

This follows by the recursive construction of π and ω in terms of the family U1,U2,. . . ,Um, in the light of the bound (3.53).

Inequality (3.54) implies the claim of the theorem, as follows. Let A be an increasing event and let ξ be a conﬁguration satisfying HA(ξ) ≤ k. There exists a set B = Bξ of edges such that:

(a) |B| ≤ k, (b) ξ(e) = 0 for e ∈ B, (c) ξB ∈ A, where ξB is obtained from ξ by allocating state 1 to all edges in B.

If more than one such set B exists, we pick the earliest in some deterministic ordering of all subsets of E. By (3.54),

φs,q(A) ≥ P HA(π) ≤ k, ω(e) = 1 for e ∈ Bπ

P π = ξ, ω(e) = 1 for e ∈ Bξ

=

ξ: HA(ξ)≤k

k

r + q(1 − r) q(1 − r)

s − r q ·

φr,q(HA ≤ k).

≥

![image 221](<rcm1-1_images/imageFile221.png>)

![image 222](<rcm1-1_images/imageFile222.png>)

3.6 Partition functions

The partition function associated with the ﬁnite graph G = (V, E) is given by

(3.55) ZG(p,q) =

ω∈

p|η(ω)|(1 − p)|E\η(ω)|qk(ω).

In the usual approach of classical statistical mechanics, one studies phase transitions via the partitionfunctionandits derivatives. We preferin this work to follow a more probabilistic approach, but shall nevertheless have recourse to various arguments based on the behaviour of the partition function, of which we note some basic properties.

The (Whitney) rank-generating function of G = (V, E) is the function

(3.56) WG(u,v) =

ur(G′)vc(G′), u,v ∈ R,

E′⊆E

where r(G′) = |V| − k(G′) is the rank of the subgraph G′ = (V, E′), and c(G′) = |E′| − |V| + k(G′) is its co-rank. Here, k(G′) denotes the number of components of the graph G′. The rank-generating function has various useful properties, and it crops up in several contexts in graph theory, see [40, 313]. It occurs in other forms also. For example, the function

- (3.57) TG(u,v) = (u − 1)|V|−k(G)WG (u − 1)−1,v − 1 is known as the dichromatic (or Tutte) polynomial, [313]. The partition function ZG of the graph G is easily seen to satisfy
- (3.58) ZG(p,q) = q|V|(1 − p)|E|WG


p 1 − p

p q(1 − p)

,

,

![image 223](<rcm1-1_images/imageFile223.png>)

![image 224](<rcm1-1_images/imageFile224.png>)

a relationship which provides a link with other classical quantities associated with a graph. See [40, 41, 121, 157, 308, 315] and Chapter 9.

Anotherwayofviewing ZG isasthemomentgeneratingfunctionofthenumber of clusters in a random graph, that is,

(3.59) ZG(p,q) = φp(qk(ω)),

where φp denotes product measure. This indicates a link to percolation on G, and to the large-deviation theory of the number of clusters in the percolation model. See [62, 298] and Section 10.8.

The partition function ZG does not change a great deal if an edge is removed from G. Let F ⊆ E, and write G\F forthe graph G with the edgesin F removed. If F is the singleton {e}, we write G \ e for G \ {e}.

- (3.60) Theorem. Let p ∈ [0,1] and q ∈ (0,∞). Then
- (3.61) (1 ∧ q)|F| ≤


ZG\F(p,q) ZG(p,q) ≤ (1 ∨ q)|F|, F ⊆ E.

![image 225](<rcm1-1_images/imageFile225.png>)

We give next an application of these inequalities to be used later. Let Gi = (Vi, Ei), i = 1,2, be ﬁnite graphson disjointvertexsets V1, V2, andwrite G1∪G2 for the graph (V1 ∪ V2, E1 ∪ E2). It is immediate from (3.55) that

(3.62) ZG1∪G2 = ZG1ZG2,

where for clarity we have removed explicit mention of p, q. Taken in conjunction with (3.61), this leads easily to a pair of inequalities which we state as a theorem.

(3.63) Theorem. Let G = (V, E) be a ﬁnite graph, and let F be a set of edges whose removal breaks G into two disjoint graphs G1 = (V1, E1), G2 = (V2, E2). Thus, V = V1 ∪ V2 and E = E1 ∪ E2 ∪ F. For p ∈ [0,1] and q ∈ (0,∞),

ZG1ZG2(1 ∨ q)−|F| ≤ ZG ≤ ZG1ZG2(1 ∧ q)−|F|.

Proof of Theorem 3.60. It sufﬁces to prove (3.61) with F a singleton set, that is, F = {e}. The claim for general F will follow by iteration. For ω ∈ , we write ω e for the conﬁguration in e = {0,1}E\{e} that agrees with ω off e. Clearly,

k(ω) ≤ k(ω e ) ≤ k(ω) + 1, whence

(3.64) (1 ∧ q)qk(ω) ≤ qk(ω e ) ≤ (1 ∨ q)qk(ω).

Now, since p + (1 − p) = 1,

(3.65) p|η(ω e )|(1 − p)|E\η(ω e )|−1qk(ω e )

ZG\e(p,q) =

ω e ∈ e

p|η(ω)|(1 − p)|E\η(ω)|qk(ω e ).

=

ω∈

Equations (3.64) and (3.65) imply (3.61) with F = {e}.

We develop next an inequality related to (3.61) concerning the addition of a vertex, and which will be useful later. Let G = (V, E) be a ﬁnite graph as usual, and let v ∈/ V and W ⊆ V. We augment G by adding the vertex v together with edges v,w for w ∈ W. Let us write G + v for the resulting graph.

(3.66) Theorem. Let p ∈ [0,1] and q ∈ [1,∞). In the above notation,

ZG+v(p,q) ZG(p,q) ≥ q(1 − p + pq−1)|W|.

![image 226](<rcm1-1_images/imageFile226.png>)

Proof. Let E = {0,1}E and v = {0,1}W. We identify ν ∈ v with the edge-conﬁguration on the edge-neighbourhood { v,w : w ∈ W} of v given by ν( v,w ) = ν(w). Now,

(3.67) p|η(ω)|(1 − p)|E\η(ω)|qk(ω)

ZG+v(p,q) =

ω∈ E, ν∈ v

pν(w)(1 − p)1−ν(w) q1−k(ω,ν)

×

w∈W

= ZG(p,q)φG,p,q qφp(q−k(ω,ν)) ,

where φp is product measure on v with density p, and k(ω,ν) is the number of open clusters of ω containing some w ∈ W with ν(w) = 1. Let n1,n2,. . .,nr be the sizes of the equivalence classes of W under the equivalence relation w1 ∼ w2 if w1 ↔ w2 in ω. For ω ∈ E,

r

1 q

(1 − p)ni +

φp(q−k(ω,ν)) =

(3.68) [1 − (1 − p)ni]

![image 227](<rcm1-1_images/imageFile227.png>)

i=1

r

ni

1 q + 1 −

1 q

(1 − p)

≥

![image 228](<rcm1-1_images/imageFile228.png>)

![image 229](<rcm1-1_images/imageFile229.png>)

i=1

|W|

1 q + 1 −

1 q

(1 − p)

=

, where we have used the elementary (convexity) inequality

![image 230](<rcm1-1_images/imageFile230.png>)

![image 231](<rcm1-1_images/imageFile231.png>)

α + (1 − α)yn ≥ [α + (1 − α)y]n, α, y ∈ [0,1], n ∈ {1,2,. . .}. We substitute (3.68) into (3.67) to obtain the claim.

So far in this section we have considered the effect on the partition function of removing edges or adding vertices. There is a related result in which, instead, we identify certain vertices. Let G = (V, E) be a ﬁnite graph, and let C be a subset of V separating the vertex-sets A1 and A2. That is, V is partitioned as V = A1 ∪ A2 ∪ C and, for all a1 ∈ A1, a2 ∈ A2, every path from a1 to a2 passes through at least one vertex in C. We write c for a composite vertex formed by identifying all vertices in C, and G1 = (A1 ∪ {c}, E1) (respectively, G2 = (A2 ∪ {c}, E2)) for the graph on the vertex set A1 ∪ {c} (respectively, A2 ∪ {c}) and with the edges derived from G. For example, if x, y ∈ A1, then

x, y is an edge of G1 if and only if it is an edge of G; for a ∈ A1, the number of edges of G1 between a and c is exactly the number of edges in G between a and members of C.

(3.69) Lemma. For p ∈ [0,1] and q ∈ [1,∞), ZG ≥ q−1ZG1ZG2.

Since ZG ≥ q for all G when q ≥ 1,

(3.70) ZG ≥ ZG1.

Proof. Let ω ∈ {0,1}E, and let ω1 and ω2 be the induced conﬁgurations in 1 = {0,1}E1 and 2 = {0,1}E2, respectively. It is easily seen that

k(ω) ≥ k(ω1) + k(ω2) − 1, and the claim follows from the deﬁnition (3.55)

The partition function has a property of convexity which will be useful when studying random-cluster measures on inﬁnite graphs. Rather than working with ZG, we work for convenience with the function YG : R2 → R given by

(3.71) YG(π,κ) =

ω∈

exp π|η(ω)| + κk(ω) ,

a function which is related to ZG as follows. We set π = π(p) and κ = κ(q) where

p 1 − p

, κ(q) = logq,

(3.72) π(p) = log

![image 232](<rcm1-1_images/imageFile232.png>)

and then

ZG(p,q) = (1 − p)|E|YG(π(p),κ(q)). We write ∇X for the gradient vector of a function X : R2 → R. (3.73) Theorem. Let the vectors (π,κ) and (p,q) be related by (3.72).

(a) The gradient vector of the function logYG(π,κ) is given by ∇{logYG(π,κ)} = φp,q(|η|),φp,q(k) . (3.74) (b) Let i = (i1,i2) be a unit vector in R2. We have that

d2 dα2

logYG (π,κ) + αi

= varp,q(i1|η| + i2k) (3.75)

![image 233](<rcm1-1_images/imageFile233.png>)

α=0

where varp,q denotes variance with respect to φp,q. In particular, logYG is a convex function on R2.

By (3.71),

YG (π,κ) + αi = YG(π,κ)φp,q(eαL(i)),

where L(i) = i1|η| +i2k. Therefore, the jth derivative as in (3.75) equals the jth cumulant (or semi-invariant3) of L(i).

Proof. (a) It is elementary that

1 YG(π,κ) ω∈ |η(ω)| exp π|η(ω)| + κk(ω)

∂ ∂π

logYG(π,κ) =

![image 234](<rcm1-1_images/imageFile234.png>)

![image 235](<rcm1-1_images/imageFile235.png>)

= φp,q(|η|),

with a similar relation for the other derivative. (b) We have that

YG (π,κ) + αi =

ω∈

exp α i1|η(ω)| + i2k(ω) exp π|η(ω)| + κk(ω) ,

and (3.75) follows as in part (a). The convexity is a consequence of the fact that variances are non-negative.

3.7 Domination by the Ising model

Stochastic domination is an invaluable tool in the study of random-cluster measures. Since the random-cluster model is an ‘edge-model’, it is usual to make comparisons with other edge-models. The relationship when q ∈ {2,3,. . .} to Potts models suggest the possibility of comparison with a ‘vertex-model’, and a hint of how to achieve this is provided by the case of integral q.

Consider the random-clustermodel with parameters p and q on the ﬁnite graph G = (V, E). If q ∈ {2,3,. . .}, we may generate a Potts model by assigning a uniformly chosen spin-value to each open cluster. The spin conﬁguration thus obtained is governed by the Potts measure with inverse-temperature β satisfying p = 1−e−β. Evidently,this can workonly if q is an integer. Aweakerconclusion may be obtained if q is not an integer, namely the following. Suppose p ∈ [0,1] and q ∈ [1,∞). We examine each open cluster of the random-cluster model in turn, and we declareitto be red with probability1/q and white otherwise, different clusters receiving independent colours4. Let R be the set of vertices lying in red clusters. If q ∈ {2,3,. . .}, then R has the same distribution as the set of vertices of the corresponding Potts model that have a pre-determined spin-value. Write Pp,q for an appropriate probability measure. One has for general q ∈ (1,∞) that,

![image 236](<rcm1-1_images/imageFile236.png>)

3See [164, p. 185] and [255, p. 266]. 4This construction is related to the so-called fuzzy Potts model, see [35, 170, 172, 245, 328].

for A ⊆ V,

(3.76)

1 ZG(p,q)

(1 − p)| eA|

Pp,q(R = A) =

![image 237](<rcm1-1_images/imageFile237.png>)

k(ω)

1 q

p|η(ω)|(1 − p)|EA\η(ω)|qk(ω)

×

![image 238](<rcm1-1_images/imageFile238.png>)

ω∈ A

1 q

p|η(ω′)|(1 − p)|EA\η(ω′)|qk(ω′) 1 −

×

![image 239](<rcm1-1_images/imageFile239.png>)

![image 240](<rcm1-1_images/imageFile240.png>)

ω′∈ A

![image 241](<rcm1-1_images/imageFile241.png>)

1 ZG(p,q)

(1 − p)| eA|ZA(p,q − 1)

=

![image 242](<rcm1-1_images/imageFile242.png>)

![image 243](<rcm1-1_images/imageFile243.png>)

k(ω′)

where A = V \ A, A = {0,1}EA with EA the subset of E containing all edges with both endvertices in A, the ZG, ZA are the appropriate partition functions, and eA is the set of edges of G with exactly one endvertex in A. When q is an integer, (3.76) reduces to the usual Potts law for the set of vertices with a given spin-value.

![image 244](<rcm1-1_images/imageFile244.png>)

![image 245](<rcm1-1_images/imageFile245.png>)

The random set R, with law given in (3.76), is the ﬁrst element in the proposed stochastic comparison. The second element is the set of + spins of an Ising model with external ﬁeld, and we recall next from Section 1.3 the deﬁnition of an Ising model on the graph G. Let = {−1,+1}V, and let β ∈ (0,∞) and h ∈ R. The Hamiltonian is the function H : → R given by

(3.77) H(σ) = −

σuσv − h

v∈V

e= u,v ∈E

σv, σ = (σu : u ∈ V) ∈  ,

and the (Ising) probability measure is given by

(3.78) πβ,h(σ) =

1 ZI

e−12βH(σ), σ ∈  ,

![image 246](<rcm1-1_images/imageFile246.png>)

![image 247](<rcm1-1_images/imageFile247.png>)

where ZI = ZI(β,h)istherequirednormalizingconstant5. Weshallbeconcerned here with the random set S = S(σ) = {u ∈ V : σu = 1}, containing all vertices with spin +1.

Let deg(u) denote the degree of the vertex u in the graph G, and let

= max deg(u) : u ∈ V .

![image 248](<rcm1-1_images/imageFile248.png>)

5The fraction 21 in the exponent is that appearing in (1.7).

![image 249](<rcm1-1_images/imageFile249.png>)

- (3.79) Theorem [15]. Let β ∈ (0,∞), p = 1 − e−β, q ∈ [2,∞), and let R be the random ‘red’ set of the random-cluster model, governed by the law given in (3.76). Let β′ ∈ (0,∞) and h′ ∈ (−∞,∞) be given by
- (3.80) e2β′ = eβ


1 q − 1

q − 2 + eβ q − 1

, eβ′( +h′) =

eβ ,

![image 250](<rcm1-1_images/imageFile250.png>)

![image 251](<rcm1-1_images/imageFile251.png>)

and let S be the set of vertices with spin +1 under the Ising measure πβ′,h′. Then (3.81) R ≤st S. Inequality (3.81) is to be interpreted as

Pp,q( f (R)) ≤ πβ′,h′( f (S))

for all increasing functions f : {0,1}V → R. Its importance lies in the deduction that R is small whenever S is small. The Ising model allows a deeper analysis than do general Potts and random-cluster models (see, for example, the results of Chapter 9). Particularly relevant facts are known for the set of + spins in the Ising model when the external ﬁeld h′ is negative, and thus it becomes important to obtain conditions under which h′ < 0.

Letq > 2and assume that G issuch that ≥ 3. Setting h′ = 0 and eliminating β′ in (3.80), we ﬁnd that β = β where

q − 2 (q − 1)1−(2/ ) − 1

(3.82) eβ =

. By (3.80) and an elementary argument using monotonicity, (3.83) h′ < 0 if and only if β < β .

![image 252](<rcm1-1_images/imageFile252.png>)

We make one further note in advance of proving the theorem. By (3.82), β → 0 as → ∞; ifthemaximumvertexdegreeislarge,theﬁeldofapplication of the theorem is small. In an important application of the theorem, we shall take G to be a box of the lattice Ld with so-called ‘wired boundary conditions’ (see Section 4.2). This amounts to identifying all vertices in the boundary ∂ , and thus to the introductionof a single vertex, w say, having large degree. The method of proof of Theorem 3.79 is valid in this slightly more general setting with

= max deg(u) : u ∈ V \ {w} ,

under the assumption that the open cluster containing w is automatically designated red. That is, we let R be the union of the cluster at w together with all other clusters declared red under the above randomization, and we let S be the set of + spins in the Ising modelwith parameters β′, h′ and with σw = +1. The conclusion

(3.81) is then valid in this setting, with given as above. An application to the exponential decay of connectivity in two dimensions will be found in Section 6.3.

Further work on stochastic domination inequalities for the set S of + spins of the Ising model may be found in [236]. Proof. We present a direct proof based on the Holley inequality, Theorem 2.1. For A ⊆ V and u,v ∈ V with u  = v, we write

Au = A ∪ {u}, Av = A \ {v}, Auv = (Au)v, and so on. Let µ1 (respectively, µ2) denote the law of R (respectively, S), so that

µ1(A) = Pp,q(R = A), µ2(A) = πβ′,h′(S = A), A ⊆ V.

We shall apply Theorem 2.6, noting ﬁrst that the µi are strictly positive. It sufﬁces to check (2.7), and that one of µ1, µ2 satisﬁes (2.8).

First, we check (2.7). Let C ⊆ V and u ∈ V \ C. We claim that (3.84) µ2(Cu)µ1(C) ≥ µ1(Cu)µ2(C). Let r = |{c ∈ C : c ∼ u}|, the number of neighbours of u in C. By (3.77)–(3.78),

µ2(Cu)

µ2(C) = exp β′(2r − δ) + β′h′ where δ = deg(u). Also, by (3.76) and Theorem 3.66,

(3.85)

![image 253](<rcm1-1_images/imageFile253.png>)

ZC(p,q − 1) ZCu(p,q − 1)

µ1(C) µ1(Cu) = (1 − p)2r−δ

![image 254](<rcm1-1_images/imageFile254.png>)

(3.86)

![image 255](<rcm1-1_images/imageFile255.png>)

![image 256](<rcm1-1_images/imageFile256.png>)

![image 257](<rcm1-1_images/imageFile257.png>)

≥ (1 − p)2r−δ(q − 1) 1 − p + p(q − 1)−1 δ−r.

Substituting p = 1 − e−β and setting x = eβ, we obtain by multiplying (3.85) and (3.86) that

µ2(Cu)µ1(C) µ1(Cu)µ2(C) ≥ exp β′(2r − δ) + β′h′ − β(2r − δ)

![image 258](<rcm1-1_images/imageFile258.png>)

× (q − 1) e−β + (1 − e−β)(q − 1)−1 δ−r

r−δ/2 q − 2 + x q − 1

− /2 x /2

= xr−δ/2 q − 2 + x q − 1

![image 259](<rcm1-1_images/imageFile259.png>)

![image 260](<rcm1-1_images/imageFile260.png>)

![image 261](<rcm1-1_images/imageFile261.png>)

q − 1 × xδ−2r(q − 1)

δ−r

q − 2 + x x(q − 1)

![image 262](<rcm1-1_images/imageFile262.png>)

( −δ)/2

x(q − 1) q − 2 + x

=

,

![image 263](<rcm1-1_images/imageFile263.png>)

62 Fundamental Properties [3.8]

parameter-value ph, see (1.20). We shall see that φp,q is invariant (in a manner to made speciﬁc soon) when two edges e, f in parallel (respectively, series) are replaced as above by a single edge g having the ‘correct’ associated parametervalue pg given by

(3.88) pg =

π(pe, pf ) if e, f are in parallel, σ(pe, pf ,q) if e, f are in series.

Let ′ = {0,1}E′ be the conﬁgurationspace associated with the graph G′ given above. We deﬁne a mapping τ : → ′ by τω(h) = ω(h) for h  = g, and

1 − (1 − ω(e))(1 − ω( f )) if e, f are in parallel, ω(e)ω( f ) if e, f are in series.

τω(g) =

When e, f are in parallel (respectively, series), g is open in τω if and only if either e or f is open (respectively, both e and f are open) in ω. The mapping τ maps open connections to open connections; in particular, for x, y ∈ V′, x ↔ y in τω if and only if x ↔ y in ω.

The measure φp,q on induces a measure φp′,q on ′ deﬁned by

φp′,q(ω′) = φp,q(τ−1ω′), ω′ ∈ ′,

and it turns out that this new measure is simply a random-cluster measure with an adapted parameter-value for the new edge g, as in (3.88).

(3.89) Theorem. Let e, f be distinct edges of the ﬁnite graph G.

- (a) Parallel law. Let e, f be in parallel. The measure φp′,q is the random-cluster measure on G′ with parameters ph for h  = g, pg = π(pe, pf ).
- (b) Series law. Let e, f be in series. The measure φp′,q is the random-cluster measure on G′ with parameters ph for h  = g, pg = σ(pe, pf ,q).


There is a third transformation of value when calculating effective resistances of electrical networks, namely the ‘star–triangle’ (or ‘star–delta’) transformation. Thisplaysapartforrandom-clustermodelsalso,seeSection6.6andthediscussion leading to Lemma 6.64.

Proof. (a) The edge g is open in τω if and only if either or both of e, f is open in ω. Therefore, the numbers of open clusters in ω and τω satisfy k(ω) = k(τω). It is a straightforward calculation to check that, for ω′ ∈ ′,

phω′(h)(1 − ph)1−ω′(h) πω′(g)(1 − π)1−ω′(h) qk(ω′),

φp′,q(ω′) ∝

ω: τω=ω′ h: h =g

where π = pe pf + pe(1 − pf ) + pf (1 − pe) = π(pe, pf ).

(b) Write e = u,v , f = v,w , so that g = u,w . Recall that ω and τω agree off the edges e, f , g, and hence the partial conﬁgurations (ω(h) : h  = e, f ) and (τω(h) : h  = g) have the same law. Let K be the set of all ω ∈ such that there exists an open path from u to w not using e, f ; let K′ be the corresponding event in ′ with e, f replaced by g. Note that K′ = τ K.

By the remarks above and Theorem 3.1(b), it sufﬁces to show that (3.90) φp′,q(ω′(g) = 1 | K′) = σ,

σ σ + q(1 − σ)

φp′,q(ω′(g) = 1 | K′) =

(3.91) ,

![image 264](<rcm1-1_images/imageFile264.png>)

![image 265](<rcm1-1_images/imageFile265.png>)

where σ = σ(pe, pf ,q). The edge g is open in τω if and only if both e and f are open in ω. Therefore,

φp′,q(ω′(g) = 1 | K′) = φp,q ω(e) = ω( f ) = 1 K , which is easily seen to equal

pepf pe pf + pe(1 − pe) + pf (1 − pf ) + q(1 − pe)(1 − pf )

,

![image 266](<rcm1-1_images/imageFile266.png>)

in agreement with (3.90). Similarly,

φp′,q(ω′(g) = 1 | K′) = φp,q ω(e) = ω( f ) = 1 K , which in turn equals

![image 267](<rcm1-1_images/imageFile267.png>)

![image 268](<rcm1-1_images/imageFile268.png>)

pepf pe pf + qpe(1 − pf ) + qpf (1 − pe) + q2(1 − pe)(1 − pf )

,

![image 269](<rcm1-1_images/imageFile269.png>)

in agreement with (3.91).

3.9 Negative association

This chapter closes with a short discussion of negative association when q ≤ 1. Let E be a ﬁnite set, and let µ be a probability measure on the sample space

= {0,1}E. There are four relevant concepts of negative association, of which we start at the ‘lowest’. The measure µ is said to be edge-negatively-associated if (3.92) µ(Je ∩ Jf ) ≤ µ(Je)µ(Jf ), e, f ∈ E, e  = f. Recall that Je = {ω ∈ : ω(e) = 1}.

There is a more general notion of negative association, as follows. For ω ∈ and F ⊆ E we deﬁne the cylinder event F,ω generated by ω on F by

F,ω = {ω′ ∈ : ω′(e) = ω(e) for e ∈ F}.

For E′ ⊆ E and an event A ⊆ , we say that A is deﬁned on E′ if, for all ω ∈ , we have that ω ∈ A if and only if E′,ω ⊆ A. We call µ negatively associated if

µ(A ∩ B) ≤ µ(A)µ(B)

for all pairs (A, B) of increasing events with the property that there exists E′ ⊆ E such that A is deﬁned on E′ and B is deﬁned on its complement E \ E′. An account of negative association and its inherent problems may be found in [268].

Ourthird andfourthconceptsof negativeassociationinvolveso-called ‘disjoint occurrence’ (see [37, 154]). Let A and B be events in . We deﬁne A B to be the set of all vectors ω ∈ forwhich there exists a set F ⊆ E such that F,ω ⊆ A and F,ω ⊆ B, where F = E \ F. Note that the choice of F is allowed to depend on the vector ω. We say that µ has the disjoint-occurrence property if

![image 270](<rcm1-1_images/imageFile270.png>)

![image 271](<rcm1-1_images/imageFile271.png>)

(3.93) µ(A B) ≤ µ(A)µ(B), A, B ⊆  , and hasthe disjoint-occurrenceproperty onincreasingevents if (3.93)holdsunder the additional assumption that A and B are increasing events.

It is evident that: µ has the disjoint-occurrence property

⇒ µ has the disjoint-occurrence property on increasing events

⇒ µ is negatively associated

⇒ µ is edge-negatively-associated.

It was proved by van den Berg and Kesten [37] that the product measures φp on have the disjoint-occurrence property on increasing events, and further by Reimer[283] that φp hasthe more generaldisjoint-occurrenceproperty. Itiseasily seen7 that the random-cluster measure φp,q cannot in general be edge-negativelyassociated when q > 1. It may however be conjectured that φp,q satisﬁes some form of negative association when q < 1. Such a property would be useful in studying random-cluster measures, particularly in the thermodynamic limit (see Chapter 4), but no such property has yet been proved.

In the absence of a satisfactory approach to the general case of random-cluster measures with q < 1, we turn next to the issue of negative association of weak limits of φp,q as q ↓ 0; see Section 1.5 and especially Theorem 1.23. Here is a mild conjecture, as yet unproven.

(3.94) Conjecture [156, 165, 199, 268]. For any ﬁnite graph G = (V, E), the uniform-spanning-forest measure USF and the uniform-connected-subgraph measure UCS are edge-negatively-associated.

A stronger version of this conjecture is that USF and UCS are negatively associated in one or more of the senses described above.

![image 272](<rcm1-1_images/imageFile272.png>)

7Consider the two events Je, Jf in the graph G comprising exactly two edges e, f in parallel.

Since USF and UCS are uniform measures, Conjecture 3.94 may be rewritten in the form of two questions concerning subgraph counts. For simplicity we shall consideronlygraphswithneitherloopsnormultipleedges. Let V = {1,2,. . .,n}, and let K be the set of N = n2 edges of the complete graph on the vertex set V. We think of subsets of K as being graphs on V. Let E ⊆ K. For X ⊆ E, let MX = MX(E) be the number of subsets E′ of E with E′ ⊇ X such that the graph (V, E′) is connected. Edge-negative-association for connected subgraphs amounts to the inequality

(3.95) M{e, f}M∅ ≤ MeM f , e, f ∈ E, e  = f. Here and later in this context, singleton sets are denoted without their braces, and any empty set is suppressed.

In the second such question, we ask if the same inequality is valid with MX re-deﬁned as the number of subsets E′ ⊆ E containing X such that (V, E′) is a forest. See [199, 268].

With E ﬁxed as above, and with X,Y ⊆ E, let MYX = MYX(E) denote the number of subsets E′ ⊆ E of the required type such that E′ ⊇ X and E′∩Y = ∅. Inequality (3.95) is easily seen to be equivalent to the inequality

(3.96) M{e, f}M{e, f} ≤ Mef Mef , e, f ∈ E, e  = f. The corresponding statement for the uniform spanning tree is known. (3.97) Theorem. The uniform-spanning-tree measure UST is edge-negativelyassociated.

The stronger property of negative association has been proved for UST, see [116], but we do not discuss this here. See also the discussions in [31, 241]. The strongest such conclusion known currently for USF appears to be the following, the proof is computer-aided and is omitted.

(3.98) Theorem [165]. If G = (V, E) has eight or fewer vertices, or has nine vertices and eighteen or fewer edges, then the associated uniform-spanning-forest measure USF has the edge-negative-association property.

Since forests are dual to connected subgraphs for planar graphs, this implies a property of edge-negative-association for the UCS measure on certain planar graphs having fewer than ten faces.

The conjectures of this section have been expressed in terms of inequalities involving counts of connected subgraphs and forests, see the discussion around (3.95). Such inequalities may be formulated in the following more general way. Let p = (pe : e ∈ E) be a collection of non-negative numbers indexed by E. For E′ ⊆ E, let

fp(E′) =

pe.

e∈E′

We now ask whether (3.95) holds with MX = MX(p) deﬁned by

(3.99) MX(p) =

E′: X⊆E′⊆E (V,E′) has property

fp(E′),

where is either the property of being connected or the property of containing no circuits. Note that (3.95) becomes a polynomial inequality in |E| real variables. Such a formulation is natural when the problem is cast in the context of the Tutte polynomial, see Section 3.6 and [308].

Proof8 of Theorem 3.97. Consider an electrical network on the connected graph G in which each edge corresponds to a unit resistor. The relevant fact from the theory of electrical networks is that, if a unit current ﬂows from a source vertex s to a sink vertex t ( = s), then the current ﬂowing along the edge e = x, y in the direction xy equals N(s, x, y,t)/N, where N is the number of spanning trees of G and N(s, x, y,t) is the number of spanning trees whose unique path from s to t passes along the edge x, y in the direction xy.

- Let e = x, y , and let µ be the UST measureon G. By the above,µ(Je)equals the current ﬂowing along e when a unit current ﬂows through G from source x to sink y. By Ohm’s Law, this equals the potential difference between x and y, which in turn equals the effective resistance RG(x, y) of the network between x and y.
- Let f ∈ E, f  = e,anddenoteby G. f thegraphobtainedfrom G bycontracting the edge f . There is a one–one correspondence between spanning trees of G. f and spanning trees of G containing f . Therefore, µ(Je | Jf ) equals the effective resistance RG.f (x, y) of the network G. f between x and y.


Theso-called Rayleighprinciplestates thatthe effectiveresistance ofa network is a non-decreasing function of the individual edge-resistances. It follows that RG.f (x, y) ≤ RG(x, y), and hence µ(Je | Jf ) ≤ µ(Je).

The usual proof of the Rayleigh principle makes use of the Thomson/Dirichlet variational principle, which in turn asserts that, amongst all unit ﬂows from source to sink, the true ﬂow of unit size is that which minimizes the dissipated energy. A good account of the Kirchhoff theorem on electrical networks and spanning trees may be found in [59]. Further accounts of the mathematics of electrical networks include [106] and [241, 329], the latter containing also much material about the uniform spanning tree.

![image 273](<rcm1-1_images/imageFile273.png>)

8When re-stated in terms of counts of spanning trees with certain properties, this is a consequence of the 1847 work of Kirchhoff [215] on electrical networks, as elaborated by Brooks, Smith, Stone, and Tutte in their famous paper [71] on the dissection of rectangles. Indeed, the difference µ(Je ∩ Jf ) − µ(Je)µ(Jf ) may be expressed in terms of a certain ‘transfer current matrix’. See [74] for an extension to more than two edges, and [31, 241] for related discussion.

## Chapter 4 Inﬁnite-Volume Measures

Summary. Random-cluster measures on inﬁnite graphs may be deﬁned either by passing to inﬁnite-volume limits or by using the approach of Dobrushin, Lanford, and Ruelle. The problem of the uniqueness of inﬁnitevolume measures is answered in part by way of an argument using the convexity of ‘pressure’. The random-cluster and Potts measures in inﬁnite volume may be coupled, thereby permitting a study of the Potts model on the lattice Ld.

4.1 Inﬁnite graphs

Although there is interesting theory associated with random-cluster measures on ﬁnite graphs, the real action, seen from the point of view of statistical mechanics, takes place in the context of inﬁnite graphs. On a ﬁnite graph, all probabilities are polynomials in p and q, and are therefore smooth functions, whereas singularities and‘phasetransitions’occurwhenthegraphisinﬁnite. Thesesingularitiesprovide most of the mathematical and physical motivation for the study of the randomcluster model.

While one may deﬁne random-cluster measures on a broad class of inﬁnite graphs using the methods of this chapter, we shall concentrate here on ﬁnitedimensional lattice-graphs. We shall, almost without exception, consider the (hyper)cubic lattice Ld = (Zd,Ed) in some number d of dimensions satisfying d ≥ 2. This restriction enables a clear exposition of the theory and open problems without suffering the complications that arise through allowing greater generality. We note however that many of the basic properties of random-clustermeasures on lattices are valid on a much larger class of graphs. Interesting further questions arise in the non-ﬁnite-dimensional setting of non-amenable graphs, to which we return in Section 10.12.

There are two ways of deﬁning random-cluster measures on an inﬁnite graph G = (V, E). The ﬁrst is to consider weak limits of measures on ﬁnite subgraphs , in the limit as ↑ V. This will be discussed in Section 4.3, following the

68 Inﬁnite-Volume Measures [4.1]

introduction in Section 4.2 of the notion of boundary conditions. The second way is to restrict oneself to inﬁnite-volume measures whose conditional marginal on any given ﬁnite sub-domain is the ﬁnite-volume random-cluster measure on

with the correct boundary condition. This latter route is inspired by work of Dobrushin [102] and Lanford–Ruelle[226] for Gibbs states, and will be discussed in Section 4.4. In preparation for the required arguments, we summarize next the stochastic ordering and positive association of probability measures on Ld.

Let = {0,1}Ed, and let F be the σ-ﬁeld generated by the cylinder subsets of . Since is a partially ordered set, we may speak of ‘increasing’ events and random variables. Given two probability measures µ1, µ2 on ( ,F ), we write µ1 ≤st µ2 if

(4.1) µ1(X) ≤ µ2(X) for all increasing continuous X : → R. See Section 2.1. Note thatanyincreasingrandomvariable X with rangeR satisﬁes X(0) ≤ X(ω) ≤ X(1) for all ω ∈ , and is therefore bounded.

One sometimes wishes to apply (4.1) to increasing random variables X that are semicontinuous rather than continuous1. This may be done as follows. For ω,ξ ∈ and a box , we write ωξ for the conﬁguration given by

(4.2) ωξ (e) =

ω(e) if e ∈ E , ξ(e) otherwise.

For X : → R, we deﬁne X0 and X1 by

(4.3) Xb (ω) = X(ωb ), ω ∈  , b = 0,1.

Assume that X is increasing. It is easily checked that, as ↑ Zd,

X0 ↑ X if and only if X is lower-semicontinuous, X1 ↓ X if and only if X is upper-semicontinuous,

(4.4)

where the convergence is pointwise on . The functions X0 , X1 are continuous. Therefore, by the monotone convergence theorem, µ1 ≤st µ2 if and only if

(4.5) µ1(X) ≤ µ2(X) for all increasing semicontinuous X.

It is a usefulfact that, when µ1 ≤st µ2, then µ1 = µ2 whenevertheir marginals are equal. We state this as a theorem for future use, see also [235, Section II.2]. Recall that Je is the event that e is open.

![image 274](<rcm1-1_images/imageFile274.png>)

1An important example of an upper-semicontinuous function is the indicator function X = 1A of an increasing closed event A.

[4.1] Inﬁnite graphs 69

- (4.6) Proposition. Let E be a countable set, let = {0,1}E, and let F be the σ-ﬁeld generatedby the cylindersubsets of . Let µ1, µ2 be probabilitymeasures on ( ,F ) such that µ1 ≤st µ2. Then µ1 = µ2 if and only if
- (4.7) µ1(Je) = µ2(Je) for all e ∈ E.


We say that a probability measure µ on ( ,F ) is positively associated if (4.8) µ(XY) ≥ µ(X)µ(Y) for all increasing continuous X, Y. Note from the arguments above that µ is positively associated if and only if (4.9) µ(XY) ≥ µ(X)µ(Y) for all increasing semicontinuous X, Y.

Stochastic inequalities and positive association are conserved by weak convergence, in the following sense. (4.10) Proposition. Let E be a countable set, let = {0,1}E, and let F be the σ-ﬁeld generated by the cylinder subsets of .

- (a) Let (µn,i : n = 1,2,. . .), i = 1,2, be two sequences of probability measures on ( ,F ) satisfying: µn,i ⇒ µi as n → ∞, for i = 1,2, and µn,1 ≤st µn,2 for all n. Then µ1 ≤st µ2.
- (b) Let (µn : n = 1,2,. . .) be a sequence of probability measures on ( ,F ) satisfying µn ⇒ µ as n → ∞. If each µn is positively associated, then so is µ.


Proof of Proposition 4.6. If µ1 = µ2 then (4.7) holds. Suppose conversely that (4.7) holds. By [235, Thm 2.4] or [237, Thm II.2.4], there exists a ‘coupled’ measure µ on ( ,F ) × ( ,F ) with marginals µ1 and µ2, and such that

µ {(π,ω) ∈ 2 : π ≤ ω} = 1. For any increasing cylinder event A,

µ2(A) − µ1(A) = µ {(π,ω) : π ∈/ A, ω ∈ A} ≤

µ π(e) = 0, ω(e) = 1

e∈E

µ(ω(e) = 1) − µ(π(e) = 1)

=

e∈E

µ2(Je) − µ1(Je) = 0.

=

e∈E

Since F is generated by the increasing cylinders A, the claim is proved.

ProofofProposition4.10. (a)We havethatµn,1(X) ≤ µn,2(X)foranyincreasing continuousrandomvariable X, andtheconclusionfollowsbylettingn → ∞. Part (b) is proved similarly.

70 Inﬁnite-Volume Measures [4.2]

4.2 Boundary conditions

An important part of statistical mechanics is directed at understanding the way in which assumptions on the boundary of a region affect what happens in its interior. Inordertomakeprecisesuchadiscussionforrandom-clustermodels,weintroduce next the concept of a ‘boundary condition’.

Let be a ﬁnite subset of Zd. We shall later take to be a box, but we retain the extra generality at this point. For ξ ∈ , let ξ denote the (ﬁnite) subset of

containing all conﬁgurations ω satisfying ω(e) = ξ(e) for e ∈ Ed \ E ; these are the conﬁgurationsthat‘agree with ξ off ’. For ξ ∈ and p ∈ [0,1], q ∈ (0,∞),

we shall write φ ,ξ p,q for the random-cluster measure on the ﬁnite graph ( ,E ) ‘with boundary condition ξ’; this is the equivalent of a ‘speciﬁcation’ for Gibbs

states, see [134]. More precisely, let φ ,ξ p,q be the probability measure on the pair ( ,F ) given by (4.11)

 

1 Zξ (p,q) e∈E

pω(e)(1 − p)1−ω(e) qk(ω, ) if ω ∈ ξ ,

![image 275](<rcm1-1_images/imageFile275.png>)

φ ,ξ p,q(ω) =



0 otherwise, where k(ω, ) is the number of componentsof the graph (Zd,η(ω)) that intersect , and Zξ (p,q) is the appropriate normalizing constant,

(4.12) Zξ (p,q) =

ω∈ ξ e∈E

pω(e)(1 − p)1−ω(e) qk(ω, ).

Note that φ ,ξ p,q( ξ ) = 1.

The boundary condition ξ inﬂuences the measure φ ,ξ p,q through the way in which the term k(ω, ) in (4.11) counts the number of ω-open clusters of intersecting the boundary ∂ . Let x, y ∈ ∂ , and suppose there exists a path of ξ-open edges of Ed \ E from x to y. Then any two ω-open clusters of containing x and y, respectively, will contribute only 1 to the count k(ω, ).

Random-cluster measures have an important ‘nesting’ property which is best expressed in terms of conditional probabilities. For any ﬁnite subset of Zd, we write as usual F (respectively, T ) for the σ-ﬁeld generated by the states of edges in E (respectively, Ed \ E ).

(4.13) Lemma. Let p ∈ [0,1] and q ∈ (0,∞). If , are ﬁnite sets of vertices with ⊆ , then for every ξ ∈ and every event A ∈ F ,

φ ,ξ p,q(A | T )(ω) = φ ,ω p,q(A), ω ∈ ξ .

Two extremal boundary conditions of special importance are the conﬁgurations 0 and 1, comprising ‘all edges closed’ and ‘all edges open’ respectively.

[4.2] Boundary conditions 71

One speaks of conﬁgurations in 0 as having ‘free’ boundary conditions, and conﬁgurations in 1 as having ‘wired’ boundary conditions. The word ‘wired’ refers to the fact that, with boundary condition 1, the set of open clusters of ω ∈ 1 that intersect ∂  are ‘wired together’ and contribute only 1 in all to the count k(ω, ) of clusters2. This terminology originated in the study of electrical networks. ‘Free’ is understood as the converse: such clusters are counted in their actual number when the boundary condition is 0.

The free and wired boundary conditions provide random-cluster measures which are extremal (for q ≥ 1) in the sense of stochastic ordering. (4.14) Lemma. Let p ∈ [0,1] and q ∈ [1,∞), and let ⊆ Zd be a ﬁnite set.

(a) For every ξ ∈ , the probability measure φ ,ξ p,q is positively associated. (b) For ψ,ξ ∈ , we have that φ ,ψ p,q ≤st φ ,ξ p,q whenever ψ ≤ ξ. In

particular,

φ ,0 p,q ≤st φ ,ξ p,q ≤st φ ,1 p,q, ξ ∈  .

- Proof of Lemma 4.13. We apply Theorem 3.1(a) repeatedly, once for each edge in E \ E .
- Proof of Lemma 4.14. The key to the proof is positive association, which is valid by Theorem 3.8 when q ∈ [1,∞). The proof is straightforward,if slightly tedious when written out in detail. Since p and q will be held constant, we omit them from future subscripts. Let q ∈ [1,∞) and let be a ﬁnite subset of Zd. For ξ ∈ and for any increasing continuous function X : → R, we deﬁne the increasing random variable Xξ : → R by


Xξ (ω) = X(ωξ )

where ωξ isgiven in (4.2). We may view Xξ asan increasing function on {0,1}E .

We augment the graph ( ,E ) by adding some extra edges as follows around the boundary∂ . Foreverydistinctunorderedpair x, y ∈ ∂ , we adda newedge, denoted [x, y], between x and y. If the edge x, y exists already in , we simply add another in parallel. We write F for the set of new edges, = {0,1}E ∪F for the augmented conﬁguration space, and let φ be the random-cluster measure on the augmentedgraph ( ,E ∪F). The key pointis thatφ satisﬁes the statements in Theorem 2.27.

![image 276](<rcm1-1_images/imageFile276.png>)

![image 277](<rcm1-1_images/imageFile277.png>)

![image 278](<rcm1-1_images/imageFile278.png>)

For ξ ∈ , let ∼ξ be the equivalence relation on ∂  given by: x ∼ξ y if and only if there exists a ξ-open path of Ed \ E joining x to y. Let Fξ be the set of all edges [x, y] ∈ F such that x ∼ξ y.

![image 279](<rcm1-1_images/imageFile279.png>)

2Alternatively, one may omit from the cluster-count all clusters that intersect ∂ . This under-

cuts k(ω,  ) by 1 for the wired measure φ ,1 p,q, and the difference, being constant, has no effect on the measure. See also Section 10.9.

(a) Let X, Y be increasing and continuous on . Then

φξ (XY) = φξ (Xξ Yξ )

= φ (Xξ Yξ | Fξ open, F \ Fξ closed) ≥ φ (Xξ | Fξ open, F \ Fξ closed)φ (Yξ | Fξ open, F \ Fξ closed)

![image 280](<rcm1-1_images/imageFile280.png>)

![image 281](<rcm1-1_images/imageFile281.png>)

![image 282](<rcm1-1_images/imageFile282.png>)

by strong positive-association

= φξ (Xξ )φξ (Yξ ) = φξ (X)φξ (Y),

whence φξ is positively associated.

(b) In broad terms, the ‘greater’ the connections off , the larger is the induced measure within . Let ψ ≤ ξ, whence Fψ ⊆ Fξ, and let X be an increasing random variable. Then

φψ (X) = φψ (Xψ )

= φ (Xψ | Fψ open, F \ Fψ closed) ≤ φ (Xψ | Fξ open, F \ Fξ closed) by monotonicity ≤ φ (Xξ | Fξ open, F \ Fξ closed) since Xψ ≤ Xξ

![image 283](<rcm1-1_images/imageFile283.png>)

![image 284](<rcm1-1_images/imageFile284.png>)

![image 285](<rcm1-1_images/imageFile285.png>)

= φξ (Xξ ) = φξ (X), and the claim follows.

4.3 Inﬁnite-volume weak limits

We begin with a deﬁnition of a ‘weak-limit’ random-cluster measure on Ld. The use of the letter is restricted throughout this section to boxes of Zd.

(4.15) Deﬁnition. Let p ∈ [0,1] and q ∈ (0,∞). A probability measure φ on ( ,F ) is called a limit-random-cluster measure with parameters p and q if, for

some ξ ∈ , φ is an accumulation point of the family {φ ,ξ p,q : ⊆ Zd}, that is, there exists a sequence = ( n : n = 1,2,. . .) of boxes satisfying n ↑ Zd as n → ∞ such that

φξ n,p,q ⇒ φ as n → ∞. The set of all such measures φ is denoted by Wp,q, and the closed convex hull of Wp,q is denoted by coWp,q.

![image 286](<rcm1-1_images/imageFile286.png>)

One might at ﬁrst sight consider instead the class of all weak limits of the form

φξn n,p,q

(4.16) φ = lim

n→∞

for sequences = ( n) of boxes and (ξn) of conﬁgurations. This provides no extra generality over Deﬁnition 4.15, as we explain next in two paragraphs which the reader may choose to omit, [152].

The measure φ ,ξ p,q is inﬂuenced by ξ through the connections it provides between vertices in the boundary ∂ . By arrangingfor the same connections(and no others) to be provided in a manner which is ‘more economical in the use of space’ one discovers the following. Let be a box and ξ ∈ . There exists a box

′ ⊇ and a conﬁguration ζ such that: φ ,ζ p,q(A) = φ ,ψ p,q(A) for any event A ∈ F and any conﬁguration ψ that agrees with ζ on E ′ \ E .

Assume now that (4.16) holds for some , ξ. Let A be a cylinder event, and assume that 1 is such that A ∈ F 1. Deﬁne the increasing subsequence ( n : n = 1,2,. . .) of and the conﬁguration ξ as follows. We set 1 = 1 and ξ(e) = ξ1(e) for e ∈ E 1. Having constructed r = nr and the partial conﬁguration (ξ(e) : e ∈ E r) for r < R, we construct R and the additional conﬁguration (ξ(e) : e ∈ E R \ E R−1) by the following rule. By the remark above, there exists a box ′ ⊇ R−1 and a conﬁguration ζ such that

φξn RR−−11,p,q(A) = φψ R−1,p,q(A)

for any ψ that agrees with ζ on E ′ \E R−1. We ﬁnd m = nR such that m > nR−1 and m ⊇ ′, and we set R = m and ξ(e) = ζ(e) for e ∈ E R \ E R−1. By

(4.16), φξ r,p,q(A) → φ(A) as r → ∞, whence φξ r,p,q ⇒ φ.

The following claim is standard of its type. Part (b) is related to the so-called ‘ﬁnite-energy property’ to be discussed in the next section. (4.17) Theorem. Let p ∈ [0,1] and q ∈ (0,∞).

(a) Existence. The set Wp,q of limit-random-cluster measures is non-empty. (b) Finite-energy property. Let φ ∈ coWp,q and e ∈ Ed. We have that

![image 287](<rcm1-1_images/imageFile287.png>)

p p + q(1 − p) ≤ φ(Je | Te) ≤ max p,

p p + q(1 − p)

min p,

,

![image 288](<rcm1-1_images/imageFile288.png>)

![image 289](<rcm1-1_images/imageFile289.png>)

φ-almost-surely, where Je is the event that e is open. (c) Positive association. If q ∈ [1,∞), any member of Wp,q is positively associated.

Proof. (a) The metric space is the product of discrete spaces, and is therefore compact. Any inﬁnite family of probability measures on is therefore tight, and hence relatively compact (by Prohorov’s theorem, see [42]), which is to say that anyinﬁnite subsequencecontainsa weakly convergentsubsubsequence. We apply

this to the family {φξ n,p,q : n = 1,2,. . .} for any given ξ ∈ and any given sequence = ( n : n = 1,2,. . .) with n ↑ Zd as n → ∞. (b) Let φ ∈ Wp,q, so that

φ ,ξ p,q

(4.18) φ = lim

↑Zd

for some ξ ∈ and some sequence of boxes . For ⊆ Zd and e ∈ Ed, let F \e denote the σ-ﬁeld generated by {ω( f ) : f ∈ E , f  = e}. By the martingale convergence theorem [164, eqn (12.3.10)] and weak convergence,

φ(Je | F \e) φ-a.s.

φ(Je | Te) = lim

↑Zd

φ ,ξ p,q(Je | F \e) φ-a.s.

lim

= lim

↑Zd

↑Zd

The claim follows by Theorem 3.1(a). It is evident that any convex combination of measures in Wp,q satisﬁes the same inequalities. A similar argument yields the claim for weak limits of such combinations. (c) Let q ∈ [1,∞), and let φ be expressed as in (4.18). By Lemma 4.14(a), each φ ,ξ p,q is positively associated, and the claim follows by Proposition 4.10(b).

Let = ( n : n = 1,2,. . .) be an increasing sequence of boxes such that

n ↑ Zd as n → ∞. When does the limit limn→∞ φξ n,p,q exist, and is it independent of the choice of the sequence ? Only a limited amount is known when q < 1, and the readerisreferredtoSection5.8forthiscase. When q ≥ 1, we mayusepositiveassociationtoprovetheexistenceofthelimitintheextremalcases with ξ = 0,1. The next theorem comprises the basic existence result, together with some properties of the limit measures. It is preceded by some important deﬁnitions.

Let G = (V, E) be a countable, locally ﬁnite3 graph, and write E = {0,1}E, and FE for the σ-ﬁeld generated by the cylindersubsets of E. An automorphism of G is a bijection τ : V → V such that, for all u,v ∈ V, u,v ∈ E if and only if

τ(u),τ(v) ∈ E. We write Aut(G) forthe groupof all such automorphisms. The domain of an automorphism τ may be extended to the edge-set E by τ( u,v ) =

τ(u),τ(v) . An automorphism τ generates an operator on E, denoted also by τ : E → E and given by τω(e) = ω(τ−1e) for e ∈ E. A random variable X : E → R is called τ-invariant if X(ω) = X(τω) for all ω ∈ E. A probability measure µ on ( E,FE) is called τ-invariant if µ(A) = µ(τ A) for all A ∈ FE.

Let Ŵ be a subgroup of Aut(G). A random variable X : → R is called Ŵ-invariant if it is τ-invariant for all τ ∈ Ŵ, and a similar deﬁnition holds for a probability measure µ on ( E,FE). The measure µ is called automorphisminvariant if it is Aut(G)-invariant. A probability measure µ on ( E,FE) is called Ŵ-ergodic if every Ŵ-invariant random variable is µ-almost-surely constant, see [241, Chapter 6]. It is clear that, if Ŵ′ ⊆ Ŵ, then µ is Ŵ-ergodic whenever it is Ŵ′-ergodic. In the case when Ŵ is the group generated by a single automorphism τ, we use the term τ-ergodic rather than Ŵ-ergodic.

We turn now to the graph G = Ld, and to a class of automorphisms termed translations. Let x ∈ Zd, and deﬁne the function τx : Zd → Zd by τx(y) = x + y.

![image 290](<rcm1-1_images/imageFile290.png>)

3A graph is called locally ﬁnite if every vertex has ﬁnite degree.

The automorphism τx is referred to as a translation. We denote the group of translations by Zd, noting that τ0 is the identity map. A random variable X : → R(respectively,a probability measure µon( ,F)) iscalled translation-invariant if it is Zd-invariant.

The probability measure µ on ( ,F ) is said to be tail-trivial if, for any tail event A ∈ T , µ(A) equals either 0 or 1. The propertyof tail-triviality is important and useful for two reasons. First, tail-triviality implies mixing, see (4.22) and Corollary 4.23. Secondly, in statistical mechanics, for a given speciﬁcation, tailtriviality is equivalent to extremality within the convex set of Gibbs states, see [134, Thm 7.7].

(4.19) Theorem (Thermodynamic limit) [8, 63, 122, 149, 150, 152]. Let p ∈ [0,1] and q ∈ [1,∞).

(a) Existence. Let = ( n : n = 1,2,. . .) be an increasing sequence of boxes satisfying n ↑ Zd as n → ∞. The weak limits

φb n,p,q, b = 0,1, (4.20) exist and are independent of the choice of .

φpb,q = lim

n→∞

- (b) Automorphism-invariance. The probability measure φpb,q is automorphisminvariant, for b = 0,1.
- (c) Extremality. The φpb,q, b = 0,1, are extremal in that


φp0,q ≤st φ ≤st φp1,q, φ ∈ Wp,q. (4.21)

(d) Tail-triviality. The measures φp0,q and φp1,q are tail-trivial.

A probability measure µ on ( ,F ) is said to be mixing if, for all A, B ∈ F , (4.22) lim

µ(A ∩ τx B) = µ(A)µ(B),

|x|→∞

which is to say that, for ǫ > 0, there exists N = N(ǫ) such that µ(A ∩ τx B) − µ(A)µ(B) < ǫ if |x| ≥ N.

(4.23) Corollary. Let p ∈ [0,1], q ∈ [1,∞), and b ∈ {0,1}. The probability measure φpb,q is mixing, and is τ-ergodic for every translation τ of Ld other than the identity.

Proof of Theorem 4.19. (a) Suppose ﬁrst that b = 0. Let and be boxes satisfying ⊆ , and let A be the event that all edges in E \E have state 0. By Theorem 3.1(a), φ ,0 p,q may be viewed as the marginal measure on E of φ ,0 p,q conditioned on the event A. Since A is a decreasing event, by positive association,

(4.24) φ ,0 p,q(B) = φ ,0 p,q(B | A) ≤ φ ,0 p,q(B)

for any increasing B ∈ F . Therefore, the increasing limit φp0,q(B) = lim

φ ,0 p,q(B)

↑Zd

exists for all increasing cylinder events B, and the value of the limit does not dependonthewaythat ↑ Zd. Thecollectionofallsuchevents B isconvergencedetermining, [42, pp. 14–19], whence the limit probability measure φp0,q exists. For the case b = 1, we let A be the event that all edges in E \ E are open, and we reverse the inequality in (4.24).

(b) The translation-invariance of φp0,q is obtained as follows. Let F be a ﬁnite subset of Ed, and let B ∈ FF be increasing. Let τ be a translation of Ld. For any box containing all endverticesof all edges in F, we have by positive association as in (4.24) that

φp0,q(B) ≥ φ ,0 p,q(B) = φτ ,0 p,q(τ−1B) → φp0,q(τ−1B) as ↑ Zd.

Applying the same argument with B and τ replaced by τ−1B and τ−1, we obtain that φp0,q(B) = φp0,q(τ B). Similar arguments are valid for φp1,q.

Let C be the set of automorphisms that ﬁx the origin. Each automorphism of Ld is a combination of a translation τ and an element σ ∈ C. Every element of C preserves boxes of the form n = [−n,n]d, and it follows by (4.20) that the φpb,q are automorphism-invariant. (c) By Lemma 4.14,

φ ,0 p,q ≤st φ ,ξ p,q ≤st φ ,1 p,q, ξ ∈  ,

and (4.21) follows by Proposition 4.10(a). (d) We develop the proof of [31, 240] rather than the earlier approach of [152]. Let b = 0, an exactly analogous proof is valid for b = 1. Let , be boxes with ⊆ , and let A ∈ F be increasing, and let B ∈ F \ . By strong positive-association4, Theorem 3.8(b),

φ ,0 p,q(A ∩ B) = φ ,0 p,q(A | B)φ ,0 p,q(B)

≥ φ ,0 p,q(A)φ ,0 p,q(B). Let ↑ Zd to obtain that

φp0,q(A ∩ B) ≥ φ ,0 p,q(A)φp0,q(B). Since this holds for B ∈ F \ , it holds for B ∈ T , and hence for B ∈ T . Let

↑ Zd to deduce that (4.25) φp0,q(A ∩ B) ≥ φp0,q(A)φp0,q(B), B ∈ T .

![image 291](<rcm1-1_images/imageFile291.png>)

4The case φ ,0 p,q(B) = 0 should be handled separately.

Applying (4.25) to the complement B, we have that (4.26) φp0,q(A ∩ B) ≥ φp0,q(A)φp0,q(B), B ∈ T . Since the sum of (4.25) and (4.26) holds with equality, (4.27) φp0,q(A ∩ B) = φp0,q(A)φp0,q(B), B ∈ T .

![image 292](<rcm1-1_images/imageFile292.png>)

![image 293](<rcm1-1_images/imageFile293.png>)

![image 294](<rcm1-1_images/imageFile294.png>)

Since this holds for all increasing A ∈ F , it holds (as in the proof of part (a)) for all A ∈ F . Setting A = B yields that φp0,q(B) equals 0 or 1, which is to say that T is trivial. The same proof with several inequalities reversed is valid for φp1,q.

Proof of Corollary 4.23. It is a general fact that tail-triviality implies mixing, see [134, Prop. 7.9] and the related discussion at [134, Remark 7.13, Prop. 14.9]. The τ-ergodicity of the φpb,q is a standard application of mixing, as follows. Let y  = 0 and τ = τy. Let B be a τ-invariant event, and apply (4.22) with x = ny and A = B to obtain, on letting n → ∞, that φpb,q(B) = φpb,q(B)2. Alternatively, note that the σ-ﬁeld of τ-invariant events is contained in the completion of the tail σ-ﬁeld T , see the proof for d = 1 in [222, Prop. 4.5].

We close this section with the inﬁnite-volume comparison inequalities and certain semicontinuity properties of the mean φpb,q(X) of a random variable X. (4.28) Proposition. Let p ∈ [0,1] and q ∈ [1,∞).

(a) Comparison inequalities. For b = 0,1, the measures φpb,q satisfy the comparison inequalities:

φpb1,q1 ≤st φpb2,q2 if q1 ≥ q2 ≥ 1, and p1 ≤ p2, φpb1,q1 ≥st φpb2,q2 if q1 ≥ q2 ≥ 1, and

p1 q1(1 − p1) ≥

p2 q2(1 − p2)

.

![image 295](<rcm1-1_images/imageFile295.png>)

![image 296](<rcm1-1_images/imageFile296.png>)

(b) Upper-semicontinuity. Let X be an increasing upper-semicontinuous ran-

dom variable. Then φp1,q(X) is an upper-semicontinuous function of the vector (p,q), and is therefore a right-continuous function of p and a leftcontinuous function of q.

(c) Lower-semicontinuity. Let X be an increasing lower-semicontinuous ran-

dom variable. Then φp0,q(X) is a lower-semicontinuous function of the vector (p,q), and is therefore a left-continuous function of p and a rightcontinuous function of q.

Conditions for the semicontinuity of an increasing random varable are given at (4.4). An important class of increasing upper-semicontinuous functions is provided by the indicator functions X = 1A of increasing closed events A. It is easily seen by (4.4) thatsuch anindicatorfunctionisindeedupper-semicontinuous,and it follows by part (b) above that φp1,q(A) is right-continuousin p and left-continuous

78 Inﬁnite-Volume Measures [4.4]

in q. As an important example of such an event A, consider the event {0 ↔ ∞}, that there exists an inﬁnite open path in Ld with endvertex 0.

Similarly, the indicatorfunctionof any increasing open event A is an increasing lower-semicontinuousrandomvariable, and thus part (c) may be applied. We note that (b) and (c) apply to all increasing continuous random variables, and therefore to the indicator function X = 1B of any increasing cylinder B.

ProofofProposition4.28. (a)ThisisaconsequenceofTheorems3.21and4.10(a). (b) Let n = [−n,n]d. Suppose X satisﬁes the given condition, and deﬁne Xnb by Xnb(ω) = X(ωb n) for b = 0,1, where ωb is given in (4.2). Using stochastic orderings of measures and (4.5), we have for m ≤ n that

φp1,q(X) ≤ φ1 n,p,q(X) ≤ φ1 n,p,q(Xm1 ) since X ≤ Xm1

→ φp1,q(Xm1 ) as n → ∞

→ φp1,q(X) as m → ∞, where we have used (4.4) and the monotone convergence theorem. Also,

φ1 n,p,q(Xn1) ≥ φ1 n+1,p,q(Xn1) since n ⊆ n+1 ≥ φ1 n+1,p,q(Xn1+1) since Xn1 ≥ Xn1+1.

By the two inequalities above, the sequence φ1 n,p,q(Xn1), n = 1,2,. . ., is nonincreasing with limit φp1,q(X). Each φ1 n,p,q(Xn1) is a continuous function of p and q, whence φp1,q(X) is upper-semicontinuous.

(c) The argument of part (b) is valid with Xn1 replaced by Xn0, the boundary condition 1 replaced by 0, and with the inequalities reversed.

4.4 Inﬁnite-volume random-cluster measures

There is a second way to construct inﬁnite-volume measures, this avoids weak limits and works directly on the inﬁnite lattice. The following deﬁnition is based upon the well known Dobrushin–Lanford–Ruelle (DLR) deﬁnition of a Gibbs state, [102, 134, 226]. It was introduced in [111, 149, 150, 272] and discussed further in [63, 152].

(4.29) Deﬁnition. Let p ∈ [0,1] and q ∈ (0,∞). A probability measure φ on ( ,F ) is called a DLR-random-cluster measure with parameters p and q if: (4.30)

for all A ∈ F and boxes , φ(A | T )(ξ) = φ ,ξ p,q(A) for φ-a.e. ξ. The set of such measures is denoted by Rp,q.

Theconditionofthisdeﬁnitionamountstothe following. Supposewe aregiven that the conﬁguration off the ﬁnite box is that of ξ ∈ . Then, for almost every ξ, the (conditional) measure on is the ﬁnite-volume random-cluster measure

φ ,ξ p,q. It is not difﬁcult to see, by a calculation of conditional probabilities, that no further generality may be gained by replacing the ﬁnite box by a general ﬁnite subset of Zd. Indeed, we shall see in Proposition 4.37(b) that it sufﬁces to have (4.30) for all pairs = {x, y} with x ∼ y.

The structure of Rp,q relative to the set Wp,q remains somewhat obscure. It is not known, for example, whether or not Wp,q ⊆ Rp,q, and indeed one needs some work even to demonstrate that Rp,q is non-empty. The best result in this direction to date is restricted to probability measures having a certain additional property. For ω ∈ , let I(ω) be the number of inﬁnite open clusters of ω. We say that a probability measure φ on ( ,F ) has the 0/1-inﬁnite-cluster property5 if φ(I ∈ {0,1}) = 1.

(4.31) Theorem [152, 153, 156, 272]. Let p ∈ [0,1] and q ∈ (0,∞). If φ ∈ co Wp,q and φ has the 0/1-inﬁnite-cluster property, then φ ∈ Rp,q.

![image 297](<rcm1-1_images/imageFile297.png>)

A sufﬁcient condition for the 0/1-inﬁnite-cluster property is provided by the uniqueness theorem of Burton–Keane, [72], namely translation-invariance6 and so-called ‘ﬁnite energy’. A probability measure φ on ( ,F ) is said to have the ﬁnite-energy property if

(4.32) 0 < φ(Je | Te) < 1 φ-a.s., for all e ∈ Ed, where, as before, Je is the event that e is open. (4.33) Theorem [152, 153, 156]. Let p ∈ [0,1] and q ∈ (0,∞).

(a) The closed convex hull coWp,q contains some translation-invariant proba-

![image 298](<rcm1-1_images/imageFile298.png>)

bility measure φ. (b) Let p ∈ (0,1). Every φ ∈ coWp,q has the ﬁnite-energy property. (c) If φ ∈ coWp,q is translation-invariant, then φ has the 0/1-inﬁnite-cluster

![image 299](<rcm1-1_images/imageFile299.png>)

![image 300](<rcm1-1_images/imageFile300.png>)

property.

Theorems 4.31 and 4.33 imply jointly that |Rp,q|  = ∅ when p ∈ (0,1) and q ∈ (0,∞). [The cases p = 0,1 are trivial.] We now present some of the basic properties of the set Rp,q.

![image 301](<rcm1-1_images/imageFile301.png>)

- 5The 0/1-inﬁnite-cluster property is linked to the property of so-called ‘almost-sure quasilocality’, see Lemma 4.39 and [272].
- 6Ratherlessthanfulltranslation-invarianceisinfactrequired. Theproofin[72]usesergodicity of the probability measure, rather than simply translation-invariance. Further comments about the extension to translation-invariant measures may be found in [73] and [136, p. 42]. See [158] for a general account of Burton–Keane uniqueness.


(4.39) Lemma [152]. Let φ be a probability measure on ( ,F ) with the ﬁniteenergy property (4.32) and the 0/1-inﬁnite-cluster property. For any box and any cylinder event A ∈ F , the random variable g(ω) = φ ,ω p,q(A) is φ-almostsurely continuous.

Proof. Let be a ﬁnite box and A ∈ F . The set Dg of discontinuities of the random variable g(ω) = φ ,ω p,q(A) is a subset of the set

ω : sup

|g(ζ) − g(ω)| > 0

(4.40) Dg( ) =

ζ: ζ=ω on

: ⊇

where the intersection is over all boxes containing , and we write ‘ζ = ω on

’ if ζ(e) = ω(e) for e ∈ E . Let D ,  be the set of all ω ∈ with the property: there exist two points u,v ∈ ∂  such that both u and v are joined to ∂  by paths using ω-open edges of E \ E , but u is not joined to v by such a path. If D ,  does not occur, then k(ζ, ) = k(ω, ) for all ζ ∈ such that ζ = ω on , implying that g(ζ) = g(ω). It follows that

D , .

Dg( ) ⊆

: ⊇

It easily seen that D ,  = {I ≥ 2}, where I is the number of inﬁnite open clusters of Ed \ E intersecting ∂ . Therefore,

(4.41) φ(Dg) ≤ φ(Dg( )) ≤ φ(I ≥ 2).

By the ﬁnite-energy property (4.32), (4.42) φ(I ≥ 2) > 0 if φ(I ≥ 2) > 0. By the 0/1-inﬁnite-cluster property, φ(I ≥ 2) = 0, and therefore φ(Dg) = 0 as required.

Proof of Theorem 4.33. (a) Since φp0,q ∈ Wp,q for q ∈ [1,∞), we shall consider the case when q ∈ (0,1) only. By Theorem 4.17(a), we may ﬁnd φ ∈ Wp,q. Let

1 | m| x∈

(4.43) ψm =

τx ◦ φ

![image 302](<rcm1-1_images/imageFile302.png>)

m

where m = [−m,m]d, and τx ◦ φ is the probability measure on ( ,F ) given by τx ◦ φ(A) = φ(τx A) for the translation τx(y) = x + y of the lattice. Clearly, τx ◦ φ ∈ Wp,q for all x, whence ψm belongs to the convex hull of Wp,q. Let ψ be an accumulation point of the family (ψm : m = 1,2,. . .) of measures.

Let e be a unit vector of Zd. By (4.43), for any event A,

|∂ m| | m|

(4.44) ψm(A) − τe ◦ ψm(A) ≤

![image 303](<rcm1-1_images/imageFile303.png>)

→ 0 as m → ∞,

whence ψ is τe-invariant. Certainly ψ ∈ coWp,q, and the proof of (a) is complete. (b) This follows by Theorem 4.17(b).

![image 304](<rcm1-1_images/imageFile304.png>)

(c) If p = 0 (respectively, p = 1), then φ is concentrated on the conﬁguration 0 (respectively, 1), and the claim holds trivially. If p ∈ (0,1), it follows from (b) and the main theorem of [72]. See also the footnote on page 79.

Proof of Theorem 4.31. The claim is trivial when p = 0,1, and we assume that p ∈ (0,1). The proof is straightforward under the stronger hypothesis that φ ∈ Wp,q, andwe beginwith thisspecialcase. Supposethat = ( n : n = 1,2,. . .), ξ ∈ , and φ ∈ Wp,q are such that

φξ n,p,q,

φ = lim

n→∞

and assume that φ has the 0/1-inﬁnite-cluster property. Let be a box and let A ∈ F . By Lemma 4.13,

(4.45) if ⊆ n, φ ,ω p,q(A) = φξ n,p,q(A | T )(ω) for φξ n,p,q-a.e. ω.

Let B be a cylinder event in T . By Theorem 4.33(b) and Lemma 4.39 applied to the measure φ, the function 1B(ω)φ ,ω p,q(A) is φ-almost-surely continuous, whence

φξ n,p,q 1B(·)φ ,· p,q(A)

φ 1B(·)φ ,· p,q(A) = lim

n→∞

φξ n,p,q 1B(·)φξ n,p,q(A | T ) by (4.45)

= lim

n→∞

φξ n,p,q(A ∩ B)

= lim

n→∞

= φ(A ∩ B). Since T is generated by its cylinder events, we deduce that (4.46) φ(A | T ) = φ ,· p,q(A) φ-a.s., whence φ ∈ Rp,q.

We require a further lemma for the general case. Let X : → R be a bounded random variable, set

v(X) = sup

ω,ω′∈

|X(ω) − X(ω′)|,

and let DX be the discontinuity set of X, that is, (4.47) DX = ω ∈ : X is discontinuous at ω .

(4.48) Lemma. Let µn, µ be probability measures on ( ,F ) such that µn ⇒ µ as n → ∞. For any bounded random variable X : → R,

lim sup

|µn(X) − µ(X)| ≤ v(X)µ(DX).

n→∞

Proof. By [107, Thm 11.7.2], there exists a probability space ( ,G,P) and random variables ρn,ρ : → such that: ρn has law µn, ρ has law µ, and ρn → ρ almost surely. Therefore,

X(ρn)1C(ρ) → X(ρ)1C(ρ) P-a.s., where C = \ DX. By the bounded convergence theorem,

|µn(X) − µ(X)| = |P(X(ρn) − X(ρ))| ≤ P|X(ρn) − X(ρ)|

= P |X(ρn) − X(ρ)|1C(ρ) + P |X(ρn) − X(ρ)|1C(ρ) ≤ P |X(ρn) − X(ρ)|1C(ρ) + v(X)P(1C(ρ))

![image 305](<rcm1-1_images/imageFile305.png>)

![image 306](<rcm1-1_images/imageFile306.png>)

→ 0 + v(X)µ(C) = v(X)µ(DX) as n → ∞.

![image 307](<rcm1-1_images/imageFile307.png>)

Let φ ∈ co Wp,q have the 0/1-inﬁnite-cluster property, and write φ as φ = limn→∞ φn where

![image 308](<rcm1-1_images/imageFile308.png>)

Kn

1 Kn

φ ,ξn,ip,q.

φn,i, φn,i = lim

(4.49) φn =

![image 309](<rcm1-1_images/imageFile309.png>)

↑Zd

i=1

The latter is actually a shorthand, since will in general approach Zd along some sequence of boxes which depends on the values of n and i, but this will not be important in what follows.

Let be a box, and let A ∈ F . Let B be a cylinder event in T . Since F are T are generated by the classes of such cylinders, it is enough to prove that

(4.50) φ 1B(·)φ ,· p,q(A) = φ(A ∩ B).

Let D ,  be the event given after (4.40), noting as before that (4.51) D ,  ↓ {I ≥ 2} as ↑ Zd, where I is the number of inﬁnite open clusters of Ed \ E that intersect ∂ .

By (4.49) and Lemma 4.48, (4.52) lim sup

φn,i(1Bφ ,· p,q(A)) − φ ,ξn,ip,q(1Bφ ,· p,q(A)) ≤ φn,i(I ≥ 2),

↑Zd

as in (4.41). By Lemma 4.13,

φ ,ξn,ip,q(1Bφ ,· p,q(A)) = φ ,ξn,ip,q(A ∩ B) for all large  , and therefore, on taking the limit as ↑ Zd,

(4.53) φn,i(1Bφ ,· p,q(A)) − φn,i(A ∩ B) ≤ φn,i(I ≥ 2). By (4.49) and Lemma 4.39,

whence

1 Kn

φ(1Bφ ,· p,q(A)) = lim

![image 310](<rcm1-1_images/imageFile310.png>)

n→∞

1 Kn

φ(A ∩ B) = lim

![image 311](<rcm1-1_images/imageFile311.png>)

n→∞

Kn

φn,i(1Bφ ,· p,q(A)),

i=1

Kn

φn,i(A ∩ B),

i=1

φ(1Bφ ,· p,q(A)) − φ(A ∩ B)

Kn

1 Kn

φn,i(1Bφ ,· p,q(A)) − φn,i(A ∩ B)

≤ lim sup

![image 312](<rcm1-1_images/imageFile312.png>)

n→∞

i=1

Kn

1 Kn

≤ lim sup

φn,i(I ≥ 2) by (4.53)

![image 313](<rcm1-1_images/imageFile313.png>)

n→∞

i=1

Kn

1 Kn

≤ lim sup

φn,i(D , ) if ⊇ , by (4.51)

![image 314](<rcm1-1_images/imageFile314.png>)

n→∞

i=1

= lim sup

φn(D , )

n→∞

= φ(D , )

→ φ(I ≥ 2) as → Zd. The ﬁnal probability equals 0 as in (4.42), and therefore (4.50) holds.

Proof of Theorem 4.34. (a) By Theorem 4.33, there exists φ ∈ coWp,q with the 0/1-inﬁnite-cluster property. By Theorem 4.31, φ ∈ Rp,q. Convexity follows immediately from Deﬁnition 4.29: for φ,ψ ∈ Rp,q and α ∈ [0,1], the measure αφ + (1 − α)ψ satisﬁes the condition of the deﬁnition.

![image 315](<rcm1-1_images/imageFile315.png>)

(b) Assume q ∈ [1,∞). By Theorem 4.19(b) the φpb,q are translation-invariant, whence by Theorem 4.33(c) they have the 0/1-inﬁnite-cluster property. By The-

orem 4.31, each belongs to Rp,q. Inequality (4.35) follows from Lemma 4.14(b) and Deﬁnition 4.29, on taking the limit as → Zd.

(c) The φpb,q are tail-trivial by Theorem 4.19(d), and tail-triviality is equivalent to extremality, see [134, Thm 7.7]. There is a more direct proof using the stochastic

ordering of part (b). If φp0,q is not extremal, it may be written in the form φp0,q = αφ1 + (1 − α)φ2 for some α ∈ (0,1) and φ1,φ2 ∈ Rp,q. For any increasing cylinder event A, φp0,q(A) ≤ min{φ1(A),φ2(A)} by (4.35), in contradictionof the above. A similar argument holds for φp1,q.

Proof of Proposition 4.37. (a) This is a consequence of Deﬁnition 4.29 in conjunction with (3.3).

(b) Let φ satisfy (4.38) for all e ∈ E, and let be a ﬁnite box. For φ-almost-every ξ ∈ , the conditional measure µξ(·) = φ(· | T )(ξ) may be thought of as a probability measure on the ﬁnite set = {0,1}E with an appropriate boundary

condition. By (4.38) and Theorem 3.1(b), µξ = φ ,ξ p,q for φ-almost-every ξ, whence (4.30) holds and the claim follows.

(c) Let q ∈ [1,∞), and let X,Y : → R be increasing, continuous random variables. For φ ∈ Rp,q,

φ(XY) = φ φ(XY | T )

= φ φ ,· p,q(XY) ≥ φ φ ,· p,q(X)φ ,· p,q(Y) by positive association

= φ φ(X | T )φ(Y | T )

→ φ φ(X | T )φ(Y | T ) as ↑ Zd,

by the bounded convergence theorem and the backward martingale convergence theorem [107, Thm 10.6.1]. If φ is tail-trivial,

φ(X | T ) = φ(X), φ(Y | T ) = φ(Y), φ-a.s., and the required positive-association inequality follows.

4.5 Uniqueness via convexity of pressure

We address next the question of the uniqueness of limit- and DLR-random-cluster measures on Ld for given p and q. The main result of this section is the following. There exists a (possibly empty) countable subset Dq of the interval [0,1] such that φp0,q = φp1,q, and hence there exists a unique random-cluster measure in that |Wp,q| = |Rp,q| = 1, if and only if p ∈/ Dq. Further results concerning the uniqueness of measures may be found at Theorems 5.33, 6.17, and 7.33.

The‘almosteverywhere’uniquenessofrandom-clustermeasureswillbeproved by showing that the asymptotic behaviour of the logarithm of the partition function does not depend on the choice of boundary condition, and then by relating

the differentiability of the limit function to the uniqueness of measures. A certain convexity property of the limit function will play a role in studying its differentiability. Rather than working with the usual partition function Zξ (p,q) of (4.12), we shall use the function Yξ : R2 → R given by

(4.54) Yξ (π,κ) =

exp π|E ∩ η(ω)| + κk(ω, ) ,

ω∈ ξ

and satisfying (4.55) Zξ (p,q) = (1 − p)|E |Yξ (π,κ), where π = π(p) and κ = κ(q) are given by (4.56) π(p) = log

p 1 − p

, κ(q) = logq.

![image 316](<rcm1-1_images/imageFile316.png>)

Note that (4.57) Zξ (p,1) = 1, Y (π,0) = (1 − p)−|E |.

We introduce next a function G(π,κ) which describes the exponential asymptoticsof Yξ (π,κ)as ↑ Zd. In line with the terminology of statisticalmechanics, we call this function the pressure. All logarithms will for convenience be natural logarithms.

(4.58) Theorem [145, 150, 152]. Let be a box of Ld. The ﬁnite limits (4.59) G(π,κ) = lim

1 |E |

logYξ (π,κ) , (π,κ) ∈ R2,

![image 317](<rcm1-1_images/imageFile317.png>)

↑Zd

exist and are independent of ξ ∈ and of the way in which ↑ Zd. The ‘pressure’ function G is a convex function on its domain R2.

In the proof, we shall see that G may be approximatedfrom below and above to any required degree of accuracy by smooth functions of (π,κ), see (4.68)–(4.70).

WeshallidentifythesetDq mentionedatthestartofthissectionasDq = Dκ(′ q), a set given in the next theorem with κ(q) = logq. This set corresponds to the points of non-differentiabilityof the convex function G. Recall that, by convexity, G is differentiable at (π,κ) if and only if G has both its partial derivatives at this point.

Let D′ be the set of all (π,κ) at which G is not differentiable when viewed as a functionfrom R2 to R. Since G is convex,D′ hasLebesguemeasure0, andindeed D′ may be covered by a countable collection of rectiﬁable curves (see [115, Thm 8.18], [291, Thm 2.2.4]). For any line l of R2, the restriction of G to l is convex, whence G restricted to l is differentiable along l except at countably many points. Each such point of non-differentiability on l lies in D′, but the converse may not generally be true.

The two partial derivatives of G have special physical signiﬁcance for the random-cluster model, and one may show when q > 1 (that is, κ > 0) that G has one partial derivative at any given point (π,κ) if and only if it has both.

#### (4.60) Theorem.

(a) For each κ ∈ R, there exists a (possibly empty) countable subset Dκ′ of reals such that G(π,κ) is a differentiable function of π if and only if π ∈/ Dκ′ . (b) Foreachπ ∈ R, there exists a (possibly empty)countablesubsetDπ′′ of reals

such that G(π,κ) is a differentiable function of κ if and only if κ ∈/ Dπ′′. (c) For (π,κ) ∈ R × (0,∞), exactly one of the following holds:

(i) (π,κ) ∈ D′, and G has neither partial derivative at (π,κ), (ii) (π,κ) ∈/ D′, and G has both partial derivatives at (π,κ).

Parts (a) and (b) follow from the remarks prior to the theorem. The proof of part (c) is deferred until later in this section. With Dκ′ given in (a), we write Dq = Dκ(′ q).

For given q ∈ (0,∞), one thinks of Dq = Dκ(′ q) as the set of ‘bad’ values of p. The situation when q ∈ (0,1) is obscure. When q ∈ (1,∞), the set Dq is exactly the set of singularities of the random-cluster model in the sense of the next theorem. Here is some further notation. Let q ∈ [1,∞), and

(4.61) hb(p,q) = φpb,q(Je), b = 0,1,

where Je is the event that e is open. Since the φpb,q are automorphism-invariant7, hb(p,q) does not depend on the choice of e, and therefore equals the edge-density under φpb,q. We write

(4.62) F(p,q) = G(π,κ)

where (p,q) and (π,κ) are related by (4.56), and G is given in (4.59). We shall use the word ‘pressure’ for both F and G.

(4.63) Theorem. Let p ∈ (0,1) and q ∈ (1,∞). The following ﬁve statements are equivalent.

(a) p ∈/ Dq. (b) (i) h0(x,q) is a continuous function of x at the point x = p.

(ii) h1(x,q) is a continuous function of x at the point x = p. (c) It is the case that h0(p,q) = h1(p,q). (d) There is a unique random-cluster measure with parameters p and q, that is,

|Wp,q| = |Rp,q| = 1.

What is the set Dq? We shall return to this question in Section 5.3, but in the meantime we summarize the anticipated situation. Let d ≥ 2 be given, and assume q ∈ [1,∞). It is thought to be the case that Dq is empty when q − 1 is

![image 318](<rcm1-1_images/imageFile318.png>)

7There is an error in [152, Thm 4.5] in the case q ∈ (0, 1). The correct condition there is that the measure φ be automorphism-invariant rather than translation-invariant.

small, and is a singleton point (that is, the critical value pc(q), see Section 5.1) when q is large. It is conjectured that there exists Q = Q(d) > 1 such that

(4.64) Dq =

∅ if q ≤ Q, {pc(q)} if q > Q.

This would imply in particular that |Rp,q| = 1 unless q > Q and p = pc(q). A further issue concerns the structure of Rp,q in situations where |Rp,q| > 1. For furtherinformationaboutthe non-uniquenessof random-clustermeasures, the reader is directed to Sections 6.4 and 7.5.

Proof of Theorem 4.58. Let p ∈ (0,1) and q ∈ (0,∞), and let (π,κ) be given by (4.56). We shall use a standard argument of statistical mechanics, namely the near-multiplicativity of Yξ (π,κ) viewed as a function of . The irrelevance to the limit of the boundary condition ξ hinges on the fact that |∂ |/| | → ∞ as

↑ Zd.

We show ﬁrst that the limit (4.59) exists with ξ = 0, and shall for the moment suppress explicitreferenceto the boundarycondition. Let n = (n1,n2,. . .,nd) ∈ Nd, write |n| = n1n2 ···nd, andlet n bethe box di=1[1,ni]. By thetranslationinvariance of Z (p,q), we may restrict ourselves to boxes of this type.

We ﬁx k ∈ Nd, and write

(n,k) = ki

ni ki

![image 319](<rcm1-1_images/imageFile319.png>)

: i = 1,2,. . .,d ,

d

n k =

![image 320](<rcm1-1_images/imageFile320.png>)

i=1

ni ki

![image 321](<rcm1-1_images/imageFile321.png>)

.

By Theorem 3.63, for n ≥ k,

d

n k

|k| ki (4.65) log(1 ∨ q) + log Z n\ (n,k) ≤ log Z n ≤

log Z k − d

![image 322](<rcm1-1_images/imageFile322.png>)

![image 323](<rcm1-1_images/imageFile323.png>)

i=1

d

|k| ki

n k

log(1 ∧ q) + log Z n\ (n,k),

log Z k − d

![image 324](<rcm1-1_images/imageFile324.png>)

![image 325](<rcm1-1_images/imageFile325.png>)

i=1

and furthermore,

|n| − |k| · ⌊n/k⌋ log

q (1 ∨ q)d ≤ log Z n\ (n,k)

![image 326](<rcm1-1_images/imageFile326.png>)

≤ |n| − |k| · ⌊n/k⌋ log

q (1 ∧ q)d

![image 327](<rcm1-1_images/imageFile327.png>)

.

Divide by |n| and let the ni tend to ∞ to ﬁnd that, for all k,

d

1 ki

1 |k|

(4.66) log(1 ∨ q)

log Z k − d

![image 328](<rcm1-1_images/imageFile328.png>)

![image 329](<rcm1-1_images/imageFile329.png>)

i=1

1 |n|

1 |n|

log Z n ≤ lim sup

log Z n

≤ lim inf

![image 330](<rcm1-1_images/imageFile330.png>)

![image 331](<rcm1-1_images/imageFile331.png>)

n→∞

n→∞

d

1 ki

1 |k|

log Z k − d

log(1 ∧ q).

≤

![image 332](<rcm1-1_images/imageFile332.png>)

![image 333](<rcm1-1_images/imageFile333.png>)

i=1

Assume that q ≥ 1, a similar argument is valid when q < 1. Therefore, the limit

1 |n|

(4.67) H(p,q) = lim

log Z n exists, and furthermore

![image 334](<rcm1-1_images/imageFile334.png>)

n→∞

d

1 ki

1 |k|

(4.68) log(1 ∨ q)

log Z k − d

H(p,q) = sup

![image 335](<rcm1-1_images/imageFile335.png>)

![image 336](<rcm1-1_images/imageFile336.png>)

k

i=1

d

1 |k|

1 ki

log(1 ∧ q) .

log Z k − d

= inf

![image 337](<rcm1-1_images/imageFile337.png>)

![image 338](<rcm1-1_images/imageFile338.png>)

k

i=1

Since Z k is a continuousfunctionof p and q, these equationsimply that H(p,q) may be approximated from below and above to any degree of accuracy by continuous functions, and is therefore continuous. We will obtain greater regularity from the claim of convexity to be proved soon. Evidently, as ↑ Zd,

1 |E |

1 d

(4.69)

log Z →

H(p,q),

![image 339](<rcm1-1_images/imageFile339.png>)

![image 340](<rcm1-1_images/imageFile340.png>)

and, by (4.55) and (4.62),

1 |E |

1 d

(4.70) H(p,q)

logY (π,κ) → − log(1 − p) +

![image 341](<rcm1-1_images/imageFile341.png>)

![image 342](<rcm1-1_images/imageFile342.png>)

= F(p,q) = G(π,κ).

We show next that the same limit is valid with a general boundary condition. Let be a ﬁnite box, and let

1 |E |

logYξ (π,κ).

(4.71) Gξ (π,κ) =

![image 343](<rcm1-1_images/imageFile343.png>)

For ω,ξ ∈ , let ωξ ∈ ξ be as in (4.2). Clearly, k(ω0 , ) − |∂ | ≤ k(ω1 , ) ≤ k(ωξ , ) ≤ k(ω0 , ),

whence

Y0 (π,κ)e−κ|∂ | ≤ Yξ (π,κ) ≤ Y0 (π,κ), κ ∈ [0,∞), and the same holds with the inequalities reversed when κ ∈ (−∞,0). Therefore,

G0 (π,κ) − κ |∂ | |E |

≤ Gξ (π,κ) ≤ G0 (π,κ), κ ∈ [0,∞),

![image 344](<rcm1-1_images/imageFile344.png>)

and with the inequalities reversed if κ ∈ (−∞,0). Since |∂ |/|E | → 0 as ↑ Zd, the limit of Gξ exists by (4.70), and is independent of the choice of ξ.

It is clear from its form that Gξ (π,κ) is a convex function on its domain R2. Indeed, Theorem 3.73(b) includes a representation of its second derivative in an arbitrary given direction as the variance of a random variable. We note from Theorem 3.73(a) for later use that

1 |E |

φ ,ξ p,q(|η(ω) ∩ E |),φ ,ξ p,q(k(ω, )) .

(4.72) ∇Gξ (π,κ) =

![image 345](<rcm1-1_images/imageFile345.png>)

Since, for any ξ ∈ , the Gξ (π,κ) are convex functions of (π,κ) which converge to the ﬁnite limit function G(π,κ) as ↑ Zd, G is convex on R2. Proof of Theorem 4.63.

(c) ⇐⇒ (d). By (4.36), |Wp,q| = |Rp,q| = 1 if and only if φp0,q = φp1,q. By Proposition 4.6 and the fact that φp0,q ≤st φp1,q, φp0,q = φp1,q if and only if h0(p,q) = h1(p,q). Therefore, (c) and (d) are equivalent.

![image 346](<rcm1-1_images/imageFile346.png>)

(a) ⇐⇒ (b) ⇐⇒ (c). This is inspired by a related computation for the Ising model, [233]. Let p ∈ (0,1), q ∈ (1,∞), and let (π,κ) satisfy (4.56). Recall the functions Gξ given in (4.71), and note from (4.72) that

![image 347](<rcm1-1_images/imageFile347.png>)

dGξ dπ =

1 |E |

φ ,ξ p,q(|η(ω) ∩ E |).

(4.73)

![image 348](<rcm1-1_images/imageFile348.png>)

![image 349](<rcm1-1_images/imageFile349.png>)

Since G is convex, Dq is countable. By the convexity of the Gξ ,

dGξ dπ →

dG dπ

as ↑ Zd, ξ ∈  , p ∈/ Dq. For any box and any edge e ∈ E ,

(4.74)

![image 350](<rcm1-1_images/imageFile350.png>)

![image 351](<rcm1-1_images/imageFile351.png>)

1 |E |

(4.75) φ ,0 p,q(|η(ω) ∩ E |) ≤ φp0,q(Je) ≤ φp1,q(Je) ≤

![image 352](<rcm1-1_images/imageFile352.png>)

1 |E |

φ ,1 p,q(|η(ω) ∩ E |),

![image 353](<rcm1-1_images/imageFile353.png>)

where we have used the automorphism-invarianceof φp0,q and φp1,q, together with the stochastic ordering of measures. We deduce on passing to the limit as ↑ Zd that

dG dπ = φp0,q(Je) = φp1,q(Je), e ∈ Ed, p ∈/ Dq.

(4.76)

![image 354](<rcm1-1_images/imageFile354.png>)

In particular, (a) implies (c).

Since G(π,κ) is a convex function of π, it has right and left derivatives with respect to π, denoted respectively by dG/dπ±. Furthermore, dG/dπ+ (respectively, dG/dπ−) is right-continuous (respectively, left-continuous) and non-decreasing. We shall prove that

dG dπ+ −

dG dπ− = φp1,q(Je) − φp0,q(Je),

(4.77)

![image 355](<rcm1-1_images/imageFile355.png>)

![image 356](<rcm1-1_images/imageFile356.png>)

and that (4.78) φp1,q(Je) = lim

φp1′,q(Je).

φp0′,q(Je), φp0,q(Je) = lim p′↑p

p′↓p

In advance of proving (4.77) and (4.78), we note the following. By (4.77), (a) and (c) are equivalent. By (4.77)–(4.78), the following three statements are equivalent for any given π:

- 1. p ∈/ Dq,
- 2. h0(x,q) is right-continuous at x = p,
- 3. h1(x,q) is left-continuous at x = p.


By Proposition 4.28, h0(·,q) (respectively, h1(·,q)) is left-continuous (respectively, right-continuous),andtherefore(a) isequivalentto eachof (b)(i)and (b)(ii).

It remains to prove (4.77) and (4.78). We concentrate ﬁrst on the ﬁrst equation of (4.78). By Proposition 4.28(b), h1(·,q) is right-continuous, whence

h1(p,q) = lim p′↓p

h1(p′,q).

Now Dq is countable, whence φp0′,q = φp1′,q, and in particular h0(p′,q) = h1(p′,q), for almost every p′. By the monotonicity of h0(·,q),

h1(p,q) = lim p′↓p

h0(p′,q).

as required. The second equation of (4.78) holds by a similar argument. By the semicontinuity of the dG/dπ±, (4.76), and Proposition 4.28,

dG dπ+ = lim

d dx

G(x,κ) = φp1,q(Je), dG

![image 357](<rcm1-1_images/imageFile357.png>)

![image 358](<rcm1-1_images/imageFile358.png>)

x↓π x∈/Dκ′

d dx

G(x,κ) = φp0,q(Je),

dπ− = lim

![image 359](<rcm1-1_images/imageFile359.png>)

![image 360](<rcm1-1_images/imageFile360.png>)

x↑π x∈/Dκ′

and (4.77) follows.

Proof of Theorem 4.60. Parts (a) and (b) follow by the remarks prior to the statement of the theorem, and we turn to part (c). Recall ﬁrst that G is differentiable at (π,κ), that is (π,κ) ∈/ D′, if and only if G possesses both partial derivatives at (π,κ). It remains to show therefore that, for κ ∈ (0,∞), π ∈ Dκ′ if and only if κ ∈ Dπ′′. Let κ ∈ (0,∞). Since, by Theorem 4.63, Dκ′ is exactly the set of π = π(p) such that φp0,q  = φp1,q, it sufﬁces to show the following.

(4.79) Lemma. Let p ∈ (0,1), q ∈ (1,∞), and let (π,κ) satisfy (4.56). Then κ ∈ Dπ′′ if and only if φp0,q  = φp1,q.

Proof. The function Gξ of (4.71) is convex in κ, whence

dGξ dκ →

dG dκ

as ↑ Zd, ξ ∈  , κ ∈/ Dπ′′, as in (4.74). Inequalities (4.75) become

(4.80)

![image 361](<rcm1-1_images/imageFile361.png>)

![image 362](<rcm1-1_images/imageFile362.png>)

1 |E |

1 |E |

(4.81) φp0,q(k(ω, )) ≥

φ ,0 p,q(k(ω, )) ≥

![image 363](<rcm1-1_images/imageFile363.png>)

![image 364](<rcm1-1_images/imageFile364.png>)

1 |E |

φp1,q(k(ω, )) ≥

![image 365](<rcm1-1_images/imageFile365.png>)

1 |E |

φ ,1 p,q(k(ω, )), since k(ω, ) is decreasing in ω. Therefore, by Theorem 3.73(a), dG0 dκ ≥ φp0,q

![image 366](<rcm1-1_images/imageFile366.png>)

k(ω, ) |E |

(4.82)

![image 367](<rcm1-1_images/imageFile367.png>)

![image 368](<rcm1-1_images/imageFile368.png>)

dG1 dκ

k(ω, ) |E |

≥ φp1,q

, κ ∈/ Dπ′′.

≥

![image 369](<rcm1-1_images/imageFile369.png>)

![image 370](<rcm1-1_images/imageFile370.png>)

For ω ∈ and x ∈ Zd, let Cx = Cx(ω) be the ω-open cluster at x, and |Cx| the number of its vertices. As in [154, Section 4.1],

and

k(ω, ) =

x∈

k(ω, ) −

x∈

1 |Cx|

![image 371](<rcm1-1_images/imageFile371.png>)

1 |Cx ∩ |

≥

![image 372](<rcm1-1_images/imageFile372.png>)

x∈

1 |Cx|

,

![image 373](<rcm1-1_images/imageFile373.png>)

1 |Cx ∩ |

1 |Cx| ≤

=

−

![image 374](<rcm1-1_images/imageFile374.png>)

![image 375](<rcm1-1_images/imageFile375.png>)

x∈

1 |Cx ∩ |

≤ |∂ |.

![image 376](<rcm1-1_images/imageFile376.png>)

x∈ : x↔∂ 

The φpb,q are τ-ergodic for all translations τ other than the identity. By the ergodic theorem applied to the family {|Cx|−1 : x ∈ Zd} of bounded random variables,

k(ω, ) | |

→ φpb,q(|C0|−1) φpb,q-a.s. and in L1, as ↑ Zd.

(4.83) φpb,q

![image 377](<rcm1-1_images/imageFile377.png>)

By (4.80), (4.82), and (4.83),

(4.84)

dG dκ =

![image 378](<rcm1-1_images/imageFile378.png>)

1 d

φp0,q(|C0|−1) =

![image 379](<rcm1-1_images/imageFile379.png>)

1 d

φp1,q(|C0|−1), κ ∈/ Dπ′′.

![image 380](<rcm1-1_images/imageFile380.png>)

This implies by the next proposition that φp0,q = φp1,q for κ ∈/ Dπ′′. (4.85) Proposition. Let p ∈ (0,1) and q ∈ [1,∞). If

(4.86) φp0,q(|C0|−1) = φp1,q(|C0|−1)

then φp0,q = φp1,q.

Proof. Suppose that (4.86) holds. There are two steps, in the ﬁrst of which we show that the law of the vertex-setof C0 is the same under φp0,q and φp1,q. As in the proofof Proposition4.6, thereexistsa probabilitymeasureµon( ,F )×( ,F ), with marginals φp0,q and φp1,q, and such that

(4.87) µ {(ω0,ω1) ∈ 2 : ω0 ≤ ω1} = 1.

By (4.87), Cx(ω0) ⊆ Cx(ω1) for all x ∈ Zd, µ-almost-surely. Let E =

(ω0,ω1) ∈ 2 : |Cx(ω0)|−1 = |Cx(ω1)|−1 .

x∈Zd

By (4.86),

µ |Cx(ω0)|−1 > |Cx(ω1)|−1 = 0,

µ(E) ≤

![image 381](<rcm1-1_images/imageFile381.png>)

x∈Zd

whence µ(E) = 1.

If the vertex-set of C0(ω0) is a strict subset of that of C0(ω1), one of the two statements following must hold:

(i) C0(ω0) is ﬁnite and |C0(ω0)|−1 > |C0(ω1)|−1, (ii) C0(ω0) is inﬁnite, |C0(ω0)|−1 = |C0(ω1)|−1 = 0, and there exists x ∈ C0(ω1) \ C0(ω0).

By (4.86), the µ-probability of (i) is zero. By considering the two sub-cases of (ii) depending on whether Cx(ω0) is ﬁnite or inﬁnite, we ﬁnd that the µ-probabiltiy of (ii) is no larger than

µ(E) + µ(I(ω0) ≥ 2),

where I(ω) is the number of inﬁnite open clusters of ω. By Theorem 4.33(c), µ(I(ω0) ≥ 2) = φp0,q(I ≥ 2) = 0. We conclude as required that the vertex-sets of C0(ω0) and C0(ω1) are equal, µ-almost-surely. Therefore, by the translationinvariance of the φpb,q,

(4.88) φp0,q(x ↔/ y) = φp1,q(x ↔/ y), x, y ∈ Zd.

We turn now to the second step. Let Je be the event that edge e = x, y is open, and let Ke be the event that x and y are joined by an open path of Ed \ {e}. By Proposition 4.37(a),

p p + q(1 − p)

φpb,q(Ke)

φpb,q(Je) = pφpb,q(Ke) +

![image 382](<rcm1-1_images/imageFile382.png>)

![image 383](<rcm1-1_images/imageFile383.png>)

p p + q(1 − p) − p φpb,q(Ke),

= p +

![image 384](<rcm1-1_images/imageFile384.png>)

![image 385](<rcm1-1_images/imageFile385.png>)

and

φpb,q(x ↔/ y) q(1 − p)/[p + q(1 − p)]

φpb,q(Je ∩ Ke) φpb,q(Je | Ke) =

![image 386](<rcm1-1_images/imageFile386.png>)

![image 387](<rcm1-1_images/imageFile387.png>)

φpb,q(Ke) =

![image 388](<rcm1-1_images/imageFile388.png>)

.

![image 389](<rcm1-1_images/imageFile389.png>)

![image 390](<rcm1-1_images/imageFile390.png>)

![image 391](<rcm1-1_images/imageFile391.png>)

![image 392](<rcm1-1_images/imageFile392.png>)

Hence, by (4.88),

φp0,q(Je) = φp1,q(Je), e ∈ Ed, whence, by Proposition 4.6, φp0,q = φp1,q.

We return now to the proof of Lemma 4.79. Suppose conversely that φp0,q = φp1,q, and let q′ < q < q′′. By Proposition 4.28(a) applied to the decreasing function |C|−1,

φp1,q′(|C|−1) ≤ φp1,q(|C|−1) = φp0,q(|C|−1) ≤ φp0,q′′(|C|−1).

Take the limits as q′ ↑ q and q′′ ↓ q along sequences satisfying κ(q′),κ(q′′) ∈/ Dπ′′, andusethemonotonicityofthesefunctionstoﬁndfrom(4.84)andProposition 4.28 that

1 d

dG dκ+ −

dG dκ− =

φp0,q(|C|−1) − φp1,q(|C|−1) = 0.

![image 393](<rcm1-1_images/imageFile393.png>)

![image 394](<rcm1-1_images/imageFile394.png>)

![image 395](<rcm1-1_images/imageFile395.png>)

Therefore, G has the appropriate partial derivative at the point (π,κ), which is to say that κ ∈/ Dπ′′ as required.

4.6 Potts and random-cluster models on inﬁnite graphs

Therandom-clustermodelprovidesawaytostudythePottsmodelonﬁnitegraphs, as explained in Section 1.4. The method is valid for inﬁnite graphs also, as summarized in this section in the context of the lattice Ld = (Zd,Ed).

Let p ∈ [0,1), q ∈ {2,3,. . .}, and p = 1 − e−β as usual, and consider the free and wired random-cluster measures, φp0,q and φp1,q, respectively. The corresponding Potts measures on Ld are the free and ‘1’ measures,

(4.89) π ,β,q,

πβ,q = lim

↑Zd

(4.90) π ,β,1 q.

πβ,1 q = lim

↑Zd

The measure π ,β,q is the Potts measure on given in (1.5). The measure π ,β,1 q is the corresponding measure with ‘1’ boundary conditions, given as in (1.5) but

subject to the constraint that σx = 1 for all x ∈ ∂ . It is standard that the limits in (4.89)–(4.90) exist. Probably the easiest proof of this is to couple the Potts model with a random-cluster model on the same graph, and to use the stochastic monotonicity of the latter to prove the existence of the inﬁnite-volume limit.

We explain this in the wired case, and a similar argumentholds in the free case. Part (a) of the next theorem may be taken as the deﬁnition of the inﬁnite-volume Potts measure πβ,1 q. (4.91) Theorem [8].

(a) Let ω be sampled from with law φp1,q. Conditional on ω, each vertex x ∈ Zd is assigned a random spin σx ∈ {1,2,. . .,q} in such a way that: (i) σx = 1 if x ↔ ∞,

(ii) σx is uniformly distributed on {1,2,. . .,q} if x ↔/ ∞, (iii) σx = σy if x ↔ y, (iv) σx1,σx2,. . .,σxn are independent whenever x1, x2,. . ., xn are in diff-

erent ﬁnite open clusters of ω.

The lawofthe spin vectorσ = (σx : x ∈ Zd)is denotedby πβ,1 q andsatisﬁes (4.90).

(b) Let σ be sampled from = {1,2,. . .,q}Zd with law πβ,1 q. Conditional on σ, each edge e = x, y ∈ Ed is assigned a random state ω(e) ∈ {0,1} in such a way that:

(i) the states of different edges are independent, (ii) ω(e) = 0 if σx  = σy,

(iii) if σx = σy, then ω(e) = 1 with probability p, The edge-conﬁguration ω = (ω(e) : e ∈ Ed) has law φp1,q.

Asimilartheorem isvalid forthepair φp0,q, πβ,q, with the difference thatinﬁnite open clusters are treated in the same way as ﬁnite clusters in part (a).

96 Inﬁnite-Volume Measures [4.6]

The Potts modelhas a usefulpropertycalled ‘reﬂection-positivity’. It is natural to ask whether a similar property is satisﬁed by general random-cluster measures. It was shown in [43] that the answer is negative for non-integer values of the parameter q.

Proof of Theorem 4.91. (a) Of the possible proofs we select one using coupling, anotherapproachmay be foundin [142]. Let n = [−n,n]d and write n = 1 n and φn1 = φ1 n,p,q. Let be the set of all vectors ω = (ω1,ω2,. . . ) such that: ωn ∈ n and ωn ≥ ωn+1 for n ≥ 1. Recall fromthe proofof Theorem4.19(a)that φn ≥st φn+1 for n ≥ 1, and that φn ⇒ φp1,q as n → ∞. By [237, Thm 6.1], there exists a measure µ on such that, for each n ≥ 1, the law of the nth component ωn is φn. For ω ∈ , the limit ω∞ = limn→∞ ωn exists by monotonicity and, by the weak convergence of the sequence (φn1 : n = 1,2,. . .), ω∞ has law φp1,q. Note that

(4.92) for e ∈ Ed, ωn(e) = ω∞(e) for all large n.

Let S = (Sx : x ∈ Zd) be independent random variables with the uniform distribution on the spin set {1,2,. . .,q}. The Sx are chosen independently of the ω, and we abuse notation by writing µ for the required product measure on the product space × .

Let ω ∈ , and let the vector τ(ω) = (τw(ω) : w ∈ Zd) be given by

1 if w ↔ ∞ in the conﬁguration ω, Szw otherwise,

τw(ω) =

where zw = zw(ω) is the earliest vertex in the lexicographic ordering of Zd that belongs to the (ﬁnite) ω-open cluster at w.

Let us check that:

(4.93) for w ∈ Zd, τw(ωn) = τw(ω∞) for all large n.

If w ↔ ∞ in ω∞, then w ↔ ∞ in ωn for all large n, whence τw(ωn) = 1 = τw(ω∞) for all n. If, on the other hand, w ↔/ ∞ in ω∞ then, by (4.92), Cw(ωn) = Cw(ω∞) for all large n. Therefore, τw(ωn) = τw(ω∞) for all large n, and (4.93) is proved.

Let W be a ﬁnite subset of Zd and, for ω ∈ , deﬁne the vector τW(ω) = (τw(ω) : w ∈ W). By Theorem 1.13(a), for n sufﬁciently large that W ⊆ n, (4.94)

µ(τW(ωn) = α) = π1 n,β,q(σw = αw for w ∈ W), α ∈ {1,2,. . .,q}W. By (4.93), the vector τW(ωn) is constant for all large (random) n. Therefore,

τW(ωn) → τW(ω∞) as n → ∞,

and so, for α ∈ {1,2,. . .,q}W,

µ(τW(ωn) = α) → µ(τW(ω∞) = α) as n → ∞,

by the bounded convergence theorem. By (4.94), the vector τW(ω∞) has as law the inﬁnite-volume limit of the ﬁnite-volume measure π ,β,1 q, and the claim is proved. (b) We continueto employthe notationof the proofof part(a), where it wasproved that the vector τ(ω∞) = (τx(ω∞) : x ∈ Zd) has law πβ,1 q. Since ω∞ has law φp1,q, it sufﬁces to show that the conditional law of ω∞ given τ(ω∞) is that of the given recipe.

By the deﬁnition of τ(ω∞), the edge e = x, y satisﬁes ω∞(e) = 0 whenever τx(ω∞)  = τy(ω∞). Let ei = xi, yi , i = 1,2,. . .,n, be a ﬁnite collection of distinct edges, and let D be the subset of × given by

D = (ω, S) : τxi(ω) = τyi(ω) for i = 1,2,. . .,n .

For any event A deﬁned in terms of the states of the edges ei, we have by (4.92)– (4.93) that

µ ω∞ ∈ A (ω∞, S) ∈ D = lim

µ ωn ∈ A (ωn, S) ∈ D .

n→∞

The law of ωn is φn and, by Theorem 1.13(a), the vector (τx(ωn) : x ∈ n) has law π1 n,β,q. By Theorem 1.13(b), the last probability equals ψp(A) where ψp is product measure on {0,1}n with density p. The claim follows.

## Chapter 5 Phase Transition

Summary. When q ∈ [1, ∞), there exists a critical value pc(q) of the edgeparameter p, separating the phase with no inﬁnite cluster from the phase with one or more inﬁnite clusters. Partial results are known for both phases, but important open problems remain. In the subcritical phase, exponential decay is proved for sufﬁciently small p, and is conjectured to hold for all p < pc(q). Much is known for the supercritical phase subject to the assumption that p exceeds a certain ‘slab critical point’ pc(q), conjectured to equal pc(q). The Wulff construction is a high point of the theory of the random-cluster model.

5.1 The critical point

The random-cluster model possesses an inﬁnite open cluster if and only if p is sufﬁciently large. There is a critical value of p separating the regime in which all open clusters are ﬁnite from that in which inﬁnite clusters exist. We explore this phasetransitioninthischapter. WiththeexceptionoftheﬁnalSection5.8,weshall assume for the entirety of the chapter that q ∈ [1,∞), and we shall concentrate on the extremal random-cluster measures φp0,q and φp1,q. The quantities of principal interest are the φpb,q-percolation-probabilities,

(5.1) θb(p,q) = φpb,q(0 ↔ ∞), b = 0,1. We deﬁne the critical points (5.2) pcb(q) = sup p : θb(p,q) = 0 , b = 0,1. By Proposition 4.28(a), the θb(·,q) are non-decreasing functions, and therefore (5.3) θb(p,q) = 0 if p < pcb(q),

> 0 if p > pcb(q).

By Theorem 4.63, φp0,q = φp1,q for almost every p ∈ [0,1]. Therefore,

θ0(p,q) = θ1(p,q) for almost every p, and hence pc0(q) = pc1(q). Henceforth, we use the abbreviated notation

(5.4) pc(q) = pc0(q) = pc1(q), and we refer to pc(q) as the critical point of the random-cluster model.

It is almost trivial to prove that pc(q) = 1 in the very special case when the number d of dimensions satisﬁes d = 1. In contrast, it is fundamental that 0 < pc(q) < 1 when d ≥ 2. Not a great deal is known in general1 about the way in which pc(q) behaves when viewed as a function of q. The following basic inequalities are consequences of the comparison inequalities of Proposition 4.28.

- (5.5) Theorem [8]. We have that
- (5.6)


q/q′ pc(q) −

1 pc(q′) ≤

1 pc(q) ≤

q q′ + 1, 1 ≤ q′ ≤ q.

![image 396](<rcm1-1_images/imageFile396.png>)

![image 397](<rcm1-1_images/imageFile397.png>)

![image 398](<rcm1-1_images/imageFile398.png>)

![image 399](<rcm1-1_images/imageFile399.png>)

From (5.6) we obtain that

(q − q′)pc(q′)(1 − pc(q′)) q′ + (q − q′)pc(q′)

(5.7) 0 ≤ pc(q) − pc(q′) ≤

, 1 ≤ q′ ≤ q,

![image 400](<rcm1-1_images/imageFile400.png>)

whence, on setting q′ = 1,

(q − 1)pc(1)(1 − pc(1)) 1 + (q − 1)pc(1)

, q ≥ 1.

(5.8) 0 ≤ pc(q) − pc(1) ≤

![image 401](<rcm1-1_images/imageFile401.png>)

Since 0 < pc(1) < 1 for d ≥ 2, [154, Thm 1.10], we deduce the important fact that

(5.9) 0 < pc(q) < 1, q ≥ 1.

By (5.7), pc(q) is a continuous non-decreasing function of q. Strict monotonicity2 requires the further comparison inequality of Theorem 3.24.

(5.10) Theorem [151]. Let d ≥ 2. When viewed as a function of q, the critical value pc(q) is Lipschitz-continuousand strictly increasing on the interval [1,∞).

In advance of proving Theorems 5.5 and 5.10, we state and prove two facts of independent interest.

![image 402](<rcm1-1_images/imageFile402.png>)

1Except for its behaviour for large q, see Theorem 7.34. 2The strict monotonicity of pc(q) as a function of the underlying lattice was proved in [39],

see also [148].

100 Phase Transition [5.1]

(5.11) Proposition [8]. For p ∈ [0,1] and q ∈ [1,∞),

φ ,1 p,q(0 ↔ ∂ ) → θ1(p,q) as ↑ Zd.

There is no ‘elementary’ proof of the corresponding fact for the 0-boundarycondition measure φ ,0 p,q, and indeed this is unproven for general pairs (p,q).

(5.12) Proposition. Let φ , ⊆ Zd, be probability measures on ( ,F ) indexed by boxes and satisfying φ ⇒ φ as ↑ Zd. If φ has the 0/1-inﬁnite-cluster property, then

φ (x ↔ y) → φ(x ↔ y), x, y ∈ Zd.

Proof of Proposition 5.11. It is clear that

φp1,q(0 ↔ ∂ ) ≤ φ ,1 p,q(0 ↔ ∂ ) ≤ φ ,1 p,q(0 ↔ ∂ ) for ⊆  ,

by positive association and the fact that {0 ↔ ∂ } ⊆ {0 ↔ ∂ } when ⊆ . We take the limits as ↑ Zd and ↑ Zd in that order to obtain the claim.

Proof of Proposition 5.12. Let x and y be vertices in a box . Then,

φ (x ↔ y) ≥ φ (x ↔ y in  )

→ φ(x ↔ y in  ) as ↑ Zd

→ φ(x ↔ y) as ↑ Zd. Furthermore,

φ (x ↔ y, x ↔/ y in  ) ≤ φ (x, y ↔ ∂ , x ↔/ y in  )

→ φ(x, y ↔ ∂ , x ↔/ y in  ) as ↑ Zd

→ φ(x, y ↔ ∞, x ↔/ y) as ↑ Zd. The last probability equals 0 since φ has the 0/1-inﬁnite-cluster property. Proof of Theorem 5.5. Let 1 ≤ q′ ≤ q and

p′ q′(1 − p′) =

p q(1 − p)

(5.13)

.

![image 403](<rcm1-1_images/imageFile403.png>)

![image 404](<rcm1-1_images/imageFile404.png>)

We apply Theorem 3.21 to the probability φ ,1 p,q(0 ↔ ∂ ). By Proposition 5.11, on letting ↑ Zd,

θ1(p′,q) ≤ θ1(p′,q′) ≤ θ1(p,q).

If p′ < pc(q′), then θ1(p′,q′) = 0, so that θ1(p′,q) = 0 and therefore p′ ≤ pc(q). This implies that pc(q′) ≤ pc(q), the ﬁrst inequality of (5.6). Similarly, if p < pc(q) then p′ ≤ pc(q′), whence

pc(q′) q′(1 − pc(q′))

pc(q) q(1 − pc(q)) ≤

,

![image 405](<rcm1-1_images/imageFile405.png>)

![image 406](<rcm1-1_images/imageFile406.png>)

and hence the second inequality of (5.6). Proof of Theorem 5.10. By (5.7),

pc(q) − pc(q′) q − q′ ≤

0 ≤

![image 407](<rcm1-1_images/imageFile407.png>)

1 4q′

, 1 ≤ q′ < q,

![image 408](<rcm1-1_images/imageFile408.png>)

whence pc(q) is Lipschitz-continuous on the interval [1,∞). Turning to strict monotonicity, let γ be given as in Theorem 3.24 with = 2d, and let 1 ≤ q2 < q1. Recall that γ(p,q) is continuous, and is strictly increasing in p and strictly decreasing in q. We apply Theorem 3.24 to the graph obtained from

by identifying all vertices of ∂ , with spanning set W = \ ∂  satisfying deg(W) = 2d, to obtain that

φ ,1 p1,q1(0 ↔ ∂ ) ≤ φ ,1 p2,q2(0 ↔ ∂ ) if γ(p1,q1) ≤ γ(p2,q2).

Let ↑ Zd and deduce by Proposition 5.11 that

(5.14) θ1(p1,q1) ≤ θ1(p2,q2) if γ(p1,q1) ≤ γ(p2,q2).

We claim that

(5.15) γ(pc(q1),q1) ≥ γ(pc(q2),q2).

Suppose on the contrary that γ(pc(q1),q1) < γ(pc(q2),q2). By the continuity of γ, there exist p1 > pc(q1) and p2 < pc(q2) such that γ(p1,q1) < γ(p2,q2). By (5.14),

θ1(p1,q1) ≤ θ1(p2,q2).

However, θ1(p1,q1) > 0 and θ1(p2,q2) = 0, a contradiction, and thus (5.15) holds. If pc(q1) = pc(q2), then the strict monotonicity of γ(·,·) and the fact that q2 < q1 are in contradiction of (5.15). Therefore pc(q2) < pc(q1) as claimed.

5.2 Percolation probabilities

The continuityofthe percolationprobabilitiesθb(p,q)is relatedtothe uniqueness of random-cluster measures, in the sense that the θb(·,q) are continuous at p if and only if there is a unique random-cluster measure at this value.

(5.16) Theorem. Let d ≥ 2 and q ∈ [1,∞). (a) The function θ0(·,q) is left-continuous on (0,1] \ {pc(q)}. (b) The function θ1(·,q) is right-continuous on [0,1). (c) θ0(p,q) = θ1(p,q) if and only if p ∈/ Dq, where Dq is that of Theorem

4.63. (d) Let p  = pc(q). The functions θ0(·,q) and θ1(·,q) are continuous at the point p if and only if p ∈/ Dq.

Clearly, θ0(p,q) = θ1(p,q) = 0 if q ∈ [1,∞) and p < pc(q), and hence Dq∩[0, pc(q)) = ∅, bypart(c). Itispresumablythecasethatθ0(·,q)andθ1(·,q) are continuous except possibly at p = pc(q). In addition it may be conjectured that θ0(·,q) is left-continuous on the entire interval (0,1]. A veriﬁcation of this conjecture would include a proof that

θ0(pc(q),q) = lim

θ0(p,q) = 0.

p↑pc(q)

This would in particular solve one of the famous open problems of percolation theory, namely to show that θ(pc(1),1) = 0, see [154, 161].

The functions θ0(p,q) and θ1(p,q) play, respectively, the roles of the magnetizations for Potts measures with free and constant-spin boundary conditions. We state this more fully as a theorem. As in Section 1.3, we write σu for the spin at vertex u of a Potts model with q local states (where q is now assumed to be integral). We denote by πβ,q (respectively, πβ,1 q) the ‘free’ (respectively, ‘1’) q-state Potts measure on Ld with parameter β, see (4.89)–(4.90).

(5.17) Theorem. Let d ≥ 2, p ∈ (0,1), q ∈ {2,3,. . .}, and let β satisfy p = 1 − e−β. We have that:

|u|→∞ (5.18) πβ,q(σ0 = σu) − q−1 , (5.19) (1 − q−1)θ1(p,q) = πβ,1 q(σ0 = 1) − q−1.

(1 − q−1)θ0(p,q)2 = lim

Equation (5.19) is standard (see [8, 108, 150]). Equation (5.18) is valid also

with θ0(p,q) and πβ,q replaced, respectively, by θ1(p,q) and πβ,1 q, and the proof is similar.

Proof of Theorem 5.16. We shall prove part (a) at the end of Section 8.8. Part (b) is a consequence of Proposition 4.28(b) applied to the indicator function of the increasingclosedevent{0 ↔ ∞}. Part(d)followsfrom(a)–(c)andTheorem4.63,

on noting that the θb(·,q) are non-decreasing. It remains to prove (c). Certainly φp0,q = φp1,q if p ∈/ Dq (by Theorem 4.63), whence θ0(p,q) = θ1(p,q) for p ∈/ Dq. Suppose conversely that q > 1 and

(5.20) θ0(p,q) = θ1(p,q). We shall now give the main steps in a proof that (5.21) h0(p,q) = h1(p,q). This will imply by Theorem 4.63 that p ∈/ Dq.

Let e = u,v be an edge, and Je the event that e is open. For w ∈ Zd, let Iw = {w ↔ ∞}, and let Hw be the event that w is in an inﬁnite open path of Ed \ {e}. As in the proof of Proposition 4.6, there exists a probability measure ψ

on ( ,F )2 with marginals φp0,q and φp1,q, and assigning probability 1 to the set of pairs (ω0,ω1) ∈ 2 satisfying ω0 ≤ ω1. Let F(ω) be the set of vertices that are joined to inﬁnity by open paths of the conﬁguration ω ∈ . We have that

φp1,q(Iw) − φp0,q(Iw) = 0, by (5.20). The event Je ∩ Iu ∩ Iv is increasing, whence (5.23) φp0,q(Je ∩ Iu ∩ Iv) ≤ φp1,q(Je ∩ Iu ∩ Iv). Also, (5.24) φp0,q(Je ∩ Iu ∩ Iv) = φp0,q(Je ∩ Hu ∩ Hv)

(5.22) 0 ≤ ψ F(ω0)  = F(ω1) ≤

w∈Zd

![image 409](<rcm1-1_images/imageFile409.png>)

![image 410](<rcm1-1_images/imageFile410.png>)

= φp0,q(Je | Hu ∩ Hv)φp0,q(Hu ∩ Hv). However,

![image 411](<rcm1-1_images/imageFile411.png>)

φp0,q(Je | Hu ∩ Hv) = φp1,q(Je | Hu ∩ Hv)

![image 412](<rcm1-1_images/imageFile412.png>)

![image 413](<rcm1-1_images/imageFile413.png>)

by Proposition 4.37(a) and the fact (Theorem 4.34) that φp0,q,φp1,q ∈ Rp,q. In addition, φp0,q(Hu ∩ Hv) ≤ φp1,q(Hu ∩ Hv) since Hu ∩ Hv is an increasing event. Therefore (5.24) implies that

(5.25) φp0,q(Je ∩ Iu ∩ Iv) ≤ φp1,q(Je | Hu ∩ Hv)φp1,q(Hu ∩ Hv)

![image 414](<rcm1-1_images/imageFile414.png>)

![image 415](<rcm1-1_images/imageFile415.png>)

= φp1,q(Je ∩ Hu ∩ Hv) = φp1,q(Je ∩ Iu ∩ Iv). Adding (5.23) and (5.25), we obtain that

![image 416](<rcm1-1_images/imageFile416.png>)

![image 417](<rcm1-1_images/imageFile417.png>)

φp0,q(Iu ∩ Iv) ≤ φp1,q(Iu ∩ Iv).

Equality holds here by (5.22), and therefore equality holds in (5.23), which is to say that

(5.26) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv).

It is obvious that

(5.27) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv)

![image 418](<rcm1-1_images/imageFile418.png>)

![image 419](<rcm1-1_images/imageFile419.png>)

since both sides equal 0; the same equation holds with Iu ∩ Iv replaced by Iu ∩ Iv. Finally, we prove that

![image 420](<rcm1-1_images/imageFile420.png>)

![image 421](<rcm1-1_images/imageFile421.png>)

(5.28) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv)

![image 422](<rcm1-1_images/imageFile422.png>)

![image 423](<rcm1-1_images/imageFile423.png>)

![image 424](<rcm1-1_images/imageFile424.png>)

![image 425](<rcm1-1_images/imageFile425.png>)

which, in conjunction with (5.26), (5.27), and the subsequent remark, implies the required (5.21) by addition. Let ǫ > 0. Let be a box containing u and v, and let A = {u ↔/ ∂ , v ↔/ ∂ }. We have that

0 ≤ φp0,q(A ) − φp1,q(A )

→ φp0,q(Iu ∩ Iv) − φp1,q(Iu ∩ Iv) as ↑ Zd ≤ ψ F(ω0)  = F(ω1) = 0,

![image 426](<rcm1-1_images/imageFile426.png>)

![image 427](<rcm1-1_images/imageFile427.png>)

![image 428](<rcm1-1_images/imageFile428.png>)

![image 429](<rcm1-1_images/imageFile429.png>)

by (5.22). Therefore,

0 ≤ φp0,q(A ) − φp1,q(A ) < ǫ for all large  ,

and we pick accordingly. The events {u ↔/ ∂ } and {v ↔/ ∂ } are cylinder events, whence

(5.29) 0 ≤ φ ,0 p,q(A ) − φ ,1 p,q(A ) < 2ǫ for all large  ,

and we pick ⊇ accordingly. We now employ a certain coupling of φ ,0 p,q and φ ,1 p,q. Similar couplings will be encountered later.

(5.30) Proposition. Let p ∈ (0,1) and q ∈ [1,∞), and let , be ﬁnite boxes of Zd satisfying ⊆ . For ω ∈ , let G = G(ω) = {x ∈ : x ↔/ ∂ }. There exists a probability measure ψ on 0 × 1 , with marginals φ ,0 p,q and φ ,1 p,q, that assigns probability 1 to pairs (ω0,ω1) satisfying ω0 ≤ ω1, and with the additional property that, conditional on the set G = G(ω1), both marginals of ψ on EG equal the free random-cluster measure φG,p,q.

Writing G for the class of all subsets of that contain both u and v, we have by the proposition that

φ ,1 p,q(Je, G = g) =

φ ,1 p,q(Je ∩ A ) =

ψ ω1 ∈ Je, G(ω1) = g

g∈G

g∈G

ψ ω1 ∈ Je G(ω1) = g ψ (G(ω1) = g)

=

g∈G

ψ ω0 ∈ Je G(ω1) = g ψ (G(ω1) = g)

=

g∈G

= ψ (ω0 ∈ Je, ω1 ∈ A ) ≤ ψ (ω0 ∈ Je, ω0 ∈ A ) = φ ,0 p,q(Je ∩ A ).

Therefore,

0 ≤ φ ,0 p,q(Je ∩ A ) − φ ,1 p,q(Je ∩ A ) = ψ (ω0 ∈ Je, ω0 ∈ A , ω1 ∈/ A ) ≤ ψ (ω0 ∈ A , ω1 ∈/ A ) ≤ 2ǫ,

by (5.29). Let ↑ Zd, ↑ Zd, and ǫ ↓ 0 in that order, to obtain (5.28).

Proof of Proposition 5.30. Let φb = φ ,b p,q. Since φ0 ≤st φ1, there exists a coupled probability measure on 0 × 1 with marginals φ0, φ1, and that allocates probability 1 to the set of pairs (ω0,ω1) with ω0 ≤ ω1. This fact is immediate from the stochastic ordering, but we require in addition the special property stated in the proposition, and to this end we shall develop a special coupling not dissimilar to those used in [38] and [259, p. 254]. We do this by building a random conﬁguration (ω0,ω1) ∈ 0 × 1 in a sequential manner, and we shall speak of ω0 (respectively, ω1) as the lower (respectively, upper) conﬁguration. We shall proceed edge by edge, and shall check the (conditional) stochastic ordering at each stage.

After stage n we will have found the (paired) states of edges belonging to some subset Sn of E . We begin with S0 = ∅, and we build inwards starting at the boundary of . Let (el : l = 1,2,. . ., L) be a deterministic ordering of the edges in E . Let ej1 be the earliest edge in this ordering that is incident to some vertex in ∂ , and let

I0b = {every edge outside E has state b}, b = 0,1. By the usual stochastic ordering, (5.31) φ0(ej1 is open | I00) ≤ φ1(ej1 is open | I01). Therefore,we may ﬁnd {0,1}-valuedrandomvariables ω0(ej1), ω1(ej1) with mean values as in (5.31) and satisfying ω0(ej1) ≤ ω1(ej1). We set S1 = {ej1} and

I1b = I0b ∩ {ej1 has state ωb(ej1)}, b = 0,1.

We iterate this process. After stage r, we will have gathered the information Ir0 (respectively, Ir1) relevant to the lower (respectively, upper) process, and we will proceed to consider the state of some further edge ejr+1. The analogue of (5.31), namely

φ0(ejr+1 is open | Ir0) ≤ φ1(ejr+1 is open | Ir1),

is valid since, by construction, ω0(ejs) ≤ ω1(ejs) for s = 1,2,. . .,r. Thus we may pick a pair of random states ω0(ejr+1), ω1(ejr+1) for the new edge, these having the correct marginals and satisfying ω0(ejr+1) ≤ ω1(ejr+1).

Next is described how we choose the edges ej2,ej3,. . .. Suppose the ﬁrst r stages of the above process are complete, and write Sr = {ejs : s = 1,2,. . .,r}. Let Kr be the set of vertices x ∈ such that there exists a path π joining x to some z ∈ ∂ , with the property that ω1(e) = 1 for all e ∈ π. (This requires that every edge e in π has been considered in the ﬁrst r stages, and that the ω1-value of each such e was found to be 1.) We let ejr+1 be the earliest edge in the given ordering of E that does not belong to Sr but possesses an endvertex in Kr.

Let us call a temporary halt at the stage when no new edge can be found. At this stage, R say, we have revealed the states of edges in a certain (random) set SR. Let FR be the set of edges in E that are closed in the upper conﬁguration. By construction, FR contains exactly those edges of E that have at least one endvertex in KR and that have been determined to be closed in the upper conﬁguration. By the ordering, the edges in FR are closed in the lower conﬁgurationalso. By construction, the lower (respectively, upper) conﬁguration so far revealed is governed by the measure φ0 (respectively, φ1).

Suppose for the moment that = , in which case G(ω1) = \ KR. When extending the upper and lower conﬁgurations to edges in EG, the only relevant informationgathered to date is that all edges in the edge-boundary eG are closed in both conﬁgurations. We may therefore complete ω0, ω1 at one stroke by taking them to be equal, with (common) law φG0 ,p,q. This proves the proposition in the special case when = . Consider now the general case ⊆ .

We explainnexthowto re-startthe processat stage R. We beganabovewith the ‘seed’ ∂  and we built a set of edges connected to ∂  by paths of open edges in the upper conﬁguration, together with its closed edge-boundary. Having reached stage R, we choose a vertex x ∈ satisfying x ∈/ KR ∪ (  \ ∂ ) that is incident to some edge of FR. We then re-start the process with x as seed, and we continue until we have revealed the open cluster Cx(ω1) at x in the upper conﬁguration. We add the vertex-set of Cx(ω1) to KR to obtain a larger set K′. To FR, we add all edges incident to vertices in this cluster that are closed in the upper conﬁguration, obtaining thus a larger set F′. Next, we ﬁnd another seed y ∈/ K′ ∪ (  \ ∂ ) incident to some edge in F′. This process is iterated until no new seed may be found.

At the end of all this, we have revealed the paired states of all edges in some set S. Let T be the union of the vertex-sets of the open clusters of all seeds. Since no further seed may be found, it is the case that G(ω1) = \ T. As before, the

lower and upper conﬁgurations may be completed at one stroke by sampling the states of edges in EG according to the free measure φG,p,q.

Proof of Theorem 5.17. Let µ be the (coupled) probability measure on × given by the recipe of Theorem 4.91(a). We have that

πβ,1 q(σ0 = 1) = µ(σ0 = 1 | 0 ↔ ∞)θ1(p,q)

+ µ(σ0 = 1 | 0 ↔/ ∞)[1 − θ1(p,q)]

1 q

= θ1(p,q) +

[1 − θ1(p,q)],

![image 430](<rcm1-1_images/imageFile430.png>)

and (5.19) follows. Turning to (5.18), we have similarly to the above that

(1 − q−1)φp0,q(0 ↔ u) = πβ,q(σ0 = σu) −

1 q

, u ∈ Zd.

![image 431](<rcm1-1_images/imageFile431.png>)

The claim is proven once we have shown that (5.32) φp0,q(0 ↔ u) → θ0(p,q)2 as |u| → ∞. By the 0/1-inﬁnite-cluster property of φp0,q, see the remark after (4.36),

φp0,q(0 ↔ u) = φp0,q(0 ↔ ∞, u ↔ ∞) + φp0,q(u ∈ C, |C| < ∞). The last probability tends to zero as |u| → ∞. Also,

φp0,q(0 ↔ ∞, u ↔ ∞) → φp0,q(0 ↔ ∞)2 as |u| → ∞, since φp0,q is mixing, see Corollary 4.23.

5.3 Uniqueness of random-cluster measures

We record in this section some information about the set of values of p at which there exists a unique random-cluster measure.

(5.33) Theorem [8, 152]. Let q ∈ [1,∞) and d ≥ 2. There exists a unique random-cluster measure, in that |Wp,q| = |Rp,q| = 1, if either of the following holds:

(a) θ0(p,q) = θ1(p,q), which is to say that p ∈/ Dq, (b) p > p′, where p′ = p′(q,d) ∈ [pc(q),1) is a certain real number.

By part (a), there is a unique random-cluster measure for any p such that θ1(p,q) = 0, [8, Thm A.2]. In particular, there exists a unique random-cluster measure throughout the subcritical phase, that is, when 0 ≤ p < pc(q). It is an important open problem to establish the same conclusion when p > pc(q).

108 Phase Transition [5.3]

(5.34) Conjecture. Let q ∈ [1,∞) and d ≥ 2. We have that φp0,q = φp1,q, and therefore |Wp,q| = |Rp,q| = 1, if and only if either of the following holds:

(i) either p < pc(q) or p > pc(q), (ii) p = pc(q) and θ1(pc(q),q) = 0.

Slightly more is known in the case of two dimensions. It is proved in Theorem 6.17 that there is a unique random-cluster measure when d = 2 and p  = psd(q), where psd(q) =

√q/(1 +

√q) is the ‘self-dual’ value of p. It is conjectured that pc(q) = psd(q) for q ∈ [1,∞). Proof of Theorem 5.33. The sufﬁciency of (a) was proved in Theorem 5.16(c).

![image 432](<rcm1-1_images/imageFile432.png>)

![image 433](<rcm1-1_images/imageFile433.png>)

We sketch a proof that φp0,q = φp1,q if p is sufﬁciently close to 1. There are certain topological complications in this3, and we refrain from giving all the relevant details, most of which may be found in a closely related passage of [211, Section 2]. We begin by deﬁning a lattice L with the same vertex set as Ld but with edge-relation

x ∼ y if |xi − yi| ≤ 1 for 1 ≤ i ≤ d.

For ω ∈ , we call a vertex x white if ω(e) = 1 for all e incident with x in Ld, and black otherwise. Foranyset V ofverticesof L, we deﬁneits blackcluster B(V)as the union of V together with the set of all vertices x0 of L for which the following holds: there exists a path x0,e0, x1,e1,. . .,en−1, xn of alternating vertices and edges of L such that x0, x1,. . ., xn−1 ∈/ V, xn ∈ V, and x0, x1,. . ., xn−1 are black. Note that the colours of vertices in V have no effect on B(V), and that V ⊆ B(V). Let

d

|xi − yi| : x ∈ V, y ∈ B(V) .

B(V) = sup

i=1

When V is a singleton, V = {x} say, we abbreviate B(V) to B(x).

For an integer n and a vertex x, the event { B(x) ≥ n} is a decreasing event, whence

(5.35) φp0,q( B(x) ≥ n) ≤ φ ,0 p,q( B(x) ≥ n) for any box ≤ φ ,π( B(x) ≥ n),

where φ ,π is product measure on E with density π = p/[p + q(1 − p)], and we have used the comparison inequality of Proposition 4.28(a). By a Peierls argument (see [211, pp. 151–152]) there exists α(p) such that: the percolation (product) measure φπ = lim ↑Zd φ ,π satisﬁes

(5.36) φπ( B(x) ≥ n) ≤ e−nα(p), n ≥ 1,

![image 434](<rcm1-1_images/imageFile434.png>)

3An alternative approach may be based on the methods of Section 7.2.

and furthermore α(p) > 0 if p is sufﬁciently large, say p > p′ for some p′ ∈ [pc(q),1).

Let A be an increasingcylinderevent, and ﬁnd a ﬁnite box such that A ∈ F . Let be a box satisfying ⊆ . For any subset S of = Zd \ containing ∂ , we deﬁne the ‘internal boundary’ D(S) of S to be the set of all vertices x of L satisfying:

![image 435](<rcm1-1_images/imageFile435.png>)

(a) x ∈/ S, (b) x is adjacent in L to some vertex of S, (c) there exists a path of Ld from x to some vertex in , this path using no

vertex of S.

Let S = S ∪ D(S), and denote by I(S) the set of vertices x0 for which there exists a path x0,e0, x1,e1,. . .,en−1, xn of Ld with xn ∈ , xi ∈/ S for all i. Note that every vertex of ∂I(S) is adjacent to some vertex in D(S). We shall concentrate on the case S = B(∂ ).

Let ǫ > 0 and p > p′, where p′ is given after (5.36). By (5.35)–(5.36), there exists a box ′ sufﬁciently large that (5.37) φp0,q(K , ) ≥ 1 − ǫ, ⊇ ′, where K ,  = B(∂ ) ∩ = ∅ . We pick ′ accordingly, and let ⊇ ′.

Assume that K ,  occurs, so that I = I(B(∂ )) satisﬁes I ⊇ . Let H be the set of all subsets h of such that h ⊆ . We note three facts about B(∂ ) and D(B(∂ )):

![image 436](<rcm1-1_images/imageFile436.png>)

![image 437](<rcm1-1_images/imageFile437.png>)

(a) D(B(∂ )) is Ld-connected in that, for all pairs x, y ∈ D(B(∂ )), there

exists a path of Ld joining x to y using vertices of D(B(∂ )) only, (b) every vertex in D(B(∂ )) is white,

(c) D(B(∂ )) is measurable with respect to the colours of vertices in I = Zd \ I, in the following sense: for any h ∈ H , the event {B(∂ ) = h, D(B(∂ )) = D(h)} lies in the σ-ﬁeld generated by the colours of vertices in I(h).

![image 438](<rcm1-1_images/imageFile438.png>)

![image 439](<rcm1-1_images/imageFile439.png>)

Claim (a) may be proved by adapting the argument used to prove [211, Lemma 2.23]; claim (b) is a consequence of the deﬁnition of D(B(∂ )); claim (c) holds since D(B(∂ )) is part of the boundary of the black cluster of L generated by ∂ . Full proofs of (a) and (c) are not given here. They would be rather long, and would have much in common with [211, Section 2].

Let h ∈ H . The φp0,q-probability of A, conditional on {B(∂ ) = h}, is given by the wired measure φ1I(h),p,q. This holds since: (a) every vertex in ∂I(h) is adjacent to some vertex of D(h), and (b) D(h) is Ld-connected and all vertices in D(h) are white. Therefore, by conditional probability and positive association,

(5.38) φp0,q(A) ≥ φp0,q φ1I,p,q(A)1K , 

≥ φp0,q φ ,1 p,q(A)1K ,  since I ⊆ ≥ φ ,1 p,q(A) − ǫ by (5.37).

Let ↑ Zd and ǫ ↓ 0 in that order, and deduce that φp0,q ≥st φp1,q. Since φp0,q ≤st φp1,q, we conclude that φp0,q = φp1,q.

5.4 The subcritical phase

The random-cluster model is said to be in the subcritical phase when p < pc(q), and this phase is the subject of the next three sections. Let q ∈ [1,∞), d ≥ 2, and

p < pc(q). By Theorem 5.33(a), φp0,q = φp1,q, and hence |Wp,q| = |Rp,q| = 1. We shall denote the unique random-cluster measure by φp0,q.

The subcritical phase is characterized by the (almost-sure) absence of an inﬁnite open cluster. Thus all open clusters are almost-surely ﬁnite, and one seeks estimates on the tail of the size of such a cluster. As described in [154, Chapter 6], one may study both the ‘radius’ and the ‘volume’ of a cluster C. We concentrate here on the cluster C = C0 at the origin, and we deﬁne its radius4 by

(5.39) rad(C) = max{ y : y ∈ C} = max{ y : 0 ↔ y}.

It is immediate that rad(C) ≥ n if and only if 0 ↔ ∂ n, where n = [−n,n]d. We note for later use that there exists a positive constant β = β(d) such that

(5.40) β|C|1/d ≤ rad(C) + 1 ≤ |C|.

It is believed that the tails of both rad(C) and |C| decay exponentially when p < pc(q), but this is currently unproven. It is easy to prove that the appropriate limits exist, but the non-triviality of the limiting values remains open. That is, one may use subadditivity to show the existence of the constants

1 n

(5.41) logφp0,q(0 ↔ ∂ n) ,

ψ(p,q) = lim

−

![image 440](<rcm1-1_images/imageFile440.png>)

n→∞

1 n

(5.42) logφp0,q(|C| ≥ n) .

ζ(p,q) = lim

−

![image 441](<rcm1-1_images/imageFile441.png>)

n→∞

It is quite another matter to show as expected that

(5.43) ψ(p,q) > 0, ζ(p,q) > 0 for p < pc(q).

We conﬁne ourselves in this section to ‘soft’ arguments concerning the existence of ψ and ζ; the ‘harder’ arguments relevant to strict positivity are deferred to the next two sections. We begin by considering the radius of the cluster at the origin. The existence of the limit in (5.41) relies essentially on positive association. We write en = (n,0,0,. . . ,0).

![image 442](<rcm1-1_images/imageFile442.png>)

4Note the use of the distance function · rather than the function | · | of [154].

[5.4] The subcritical phase 111

(5.44) Theorem. Let µ be an automorphism-invariant probability measure on ( ,F ) which is positively associated. The limits

1 n

logµ(0 ↔ en) ,

ν(µ) = lim

−

![image 443](<rcm1-1_images/imageFile443.png>)

n→∞

1 n

ψ(µ) = lim

logµ(0 ↔ ∂ n) , exist and satisfy 0 ≤ ν(µ) = ψ(µ) ≤ ∞, and

−

![image 444](<rcm1-1_images/imageFile444.png>)

n→∞

µ(0 ↔ en) ≤ e−nν(µ), µ(0 ↔ ∂ n) ≤ (2d26d)nd−1e−nψ(µ), n ≥ 1. (5.45) Corollary. Let p ∈ (0,1] and q ∈ [1,∞). The limit

1 n

1 n

logφp0,q(0 ↔ en) = lim

logφp0,q(0 ↔ ∂ n)

ψ(p,q) = lim

−

−

![image 445](<rcm1-1_images/imageFile445.png>)

![image 446](<rcm1-1_images/imageFile446.png>)

n→∞

n→∞

exists and satisﬁes 0 ≤ ψ = ψ(p,q) < ∞. There exists a constant σ = σ(d) such that

(5.46) φp0,q(0 ↔ en) ≤ e−nψ, φp0,q(0 ↔ ∂ n) ≤ σnd−1e−nψ, n ≥ 1.

Proofs of Theorem 5.44 and Corollary 5.45. The proof of Theorem 5.44 follows exactlythatofthecorrespondingpartsof[154,Thms6.10,6.44],andthedetailsare omitted. For the second proof, it sufﬁces to check that φp0,q satisﬁes the conditions of Theorem 5.44.

We turn next to the volume |C| of the open cluster at the origin. A probability measure µ on ( ,F ) is said to satisfy the ‘uniform insertion-tolerancecondition’ if, for some α,β ∈ (0,1),

α ≤ µ(Je | Te) ≤ β, µ-almost-surely, for e ∈ Ed, where Je is the event that e is open. Let E be a ﬁnite set of edges, and let K1, K2,. . ., KI be the components of the graph (Zd,Ed \ E). We say that µ has the ‘empty-boundary Markov property’ if: for all such sets E, given that every edge in E is closed, the conﬁgurationson the Ki, i = 1,2,. . ., I, are independent. (5.47) Theorem. Let µ be a translation-invariant, positively associated probability measure on ( ,F ) with the uniform insertion-tolerance property for some α,β ∈ (0,1), and also the empty-boundary Markov property. The limit

1 n

logµ(|C| = n)

(5.48) ζ(µ) = lim

−

![image 447](<rcm1-1_images/imageFile447.png>)

n→∞

exists and satisﬁes (5.49) µ(|C| = n) ≤

(1 − α)2 α

ne−nζ(µ), n ≥ 1. Furthermore, 0 ≤ ζ(µ) ≤ − log[α(1 − β)2(d−1)].

![image 448](<rcm1-1_images/imageFile448.png>)

It is an easy consequence of (5.48)–(5.49) that (5.50) −

1 n

logµ(n ≤ |C| < ∞) → ζ(µ) as n → ∞.

![image 449](<rcm1-1_images/imageFile449.png>)

(5.51) Corollary. Let p ∈ (0,1) and q ∈ [1,∞). The limit

1 n

logφp0,q(|C| = n) exists and satisﬁes

ζ(p,q) = lim

−

![image 450](<rcm1-1_images/imageFile450.png>)

n→∞

q2(1 − p)2 p[p + q(1 − p)]

φp0,q(|C| = n) ≤

ne−nζ.

![image 451](<rcm1-1_images/imageFile451.png>)

Proofs of Theorem 5.47 and Corollary 5.51. These are obtained by following the proof of [154, Thm 6.78], and the details are omitted.

Since φp0,q(0 ↔ ∞) > 0 when p > pc(q), it is elementary that (5.52) ψ(p,q) = 0 for p > pc(q). It is rather less obvious that (5.53) ζ(p,q) = 0 for p > pc(q), and this is implied (for sufﬁciently large p) by Theorem 5.108. It is an important open problem to prove that ψ(p,q) > 0 and ζ(p,q) > 0 when p < pc(q). (5.54) Conjecture (Exponentialdecay). Let q ∈ [1,∞). Then ψ(p,q) > 0 and ζ(p,q) > 0 whenever p < pc(q).

A partial result in this direction is the following rather weak statement; related results may be obtained via Theorem 3.79 as in Theorem 6.30. (5.55) Theorem. Let q ∈ [1,∞) and 0 < p < pc(1). Then ψ(p,q) > 0 and ζ(p,q) > 0.

Proof. Let q ∈ [1,∞), while noting in passing that the method of proof is valid even when q ∈ (0,1), using the comparison inequalities of Theorem 3.21 as in (5.118). By Proposition 4.28(a), φp0,q ≤st φp. Therefore,

φp0,q(0 ↔ ∂ n) ≤ φp(0 ↔ ∂ n),

whence ψ(p,q) ≥ ψ(p,1), and the strict positivity of ψ follows by the corresponding statement for percolation, [154, Thm 6.14].

Similarly,

φp0,q(|C| = n) ≤ φp0,q(|C| ≥ n) ≤ φp(|C| ≥ n). By [154, eqn (6.82)],

1 n

logφp(|C| ≥ n) → ζ(p,1) as n → ∞. Furthermore, ζ(p,1) > 0 when p < pc(1), by [154, Thm 6.78].

−

![image 452](<rcm1-1_images/imageFile452.png>)

5.5 Exponential decay of radius

We address next the exponential decay of the radius of an open cluster. The existence of the limit

1 n

logφp0,q(0 ↔ ∂ n)

(5.56) ψ(p,q) = lim

−

![image 453](<rcm1-1_images/imageFile453.png>)

n→∞

follows from Corollary 5.45, and the problem is to determine for which p, q it is the case that ψ(p,q) > 0. See Conjecture 5.54.

In the case of percolation, a useful intermediate step was the proof by Hammersley [177] that ψ(p,1) > 0 whenever the two-point connectivity function is summable, that is,

φp(0 ↔ x) < ∞.

φp(|C|) =

x∈Zd

Similarly, Simon [300] and Lieb [234] proved the exponential decay of the twopoint function of Ising and other models under a summability assumption on this function, see Section 9.3. Such conclusions provoke the following question in the current context: if φp0,q(0 ↔ ∂ n) decays at some polynomial rate as n → ∞, then must it necessarily decay at an exponential rate? An afﬁrmative answer is provided in the discussion that follows.

We concentrate here on the quantity (5.57) L(p,q) = lim sup

nd−1φp0,q(0 ↔ ∂ n) .

n→∞

By the comparison inequality, Proposition 4.28, L(p,q) is non-decreasing in p, and therefore,

< ∞ if p < pc(q), = ∞ if p > pc(q),

L(p,q)

where (5.58) pc(q) = sup p : L(p,q) < ∞ . Clearly pc(q) ≤ pc(q), and equality is believed to hold. (5.59) Conjecture [163]. If q ∈ [1,∞), then pc(q) = pc(q).

Certainly pc(q) = pc(q) when q = 1, see [154], and we shall see at Theorem 7.33 that this holds also when q is sufﬁciently large. It is in addition valid for q = 2, see Theorem 9.53 and the remarks thereafter.

The condition L(p,q) < ∞ amounts to the statement that the radius R = rad(C)hasataildecayingatleastasfastasn−(d−1). Thisisslightlyweakerthanthe moment condition φp0,q(Rd−1) < ∞. In fact, L(p,q) = 0 if φp0,q(Rd−1) < ∞, since

∞

nd−1φp0,q(0 ↔ ∂ n) = nd−1φp0,q(R ≥ n) ≤

kd−1φp0,q(R = k).

k=n

There is a converse statement. If p < pc(q) then L(p,q) < ∞, implying that ncφp0,q(0 ↔ ∂ n) → 0 for all c satisfying c < d − 1.

This in turn implies, as in [164, Exercise 5.6.4], that φp0,q(Rc) < ∞ for all c < d − 1.

We state nextthe main conclusionof this section. A related result is to be found at Theorem 5.86. (5.60) Theorem. Let q ∈ [1,∞). The function ψ in (5.56) satisﬁes ψ(p,q) > 0 whenever 0 < p < pc(q).

The proof, which is delayed until later in the section, uses the method of exponential steepness described in Section 3.5. Let A be an event, and recall from (2.54) the deﬁnition of the random variable HA,

|ω′(e) − ω(e)| : ω′ ∈ A , ω ∈  .

HA(ω) = inf

e

We shall consider the event An = {0 ↔ ∂ n}, and we write Hn for HAn. The question of ascertaining the asymptotics of Hn may be viewed as a ﬁrst-passage problem. Imagine you are travelling from 0 to ∂ n; travel along open edges is instantaneous, but along each closed edge requires time 1. The fastest route requires time Hn, and one is interested in the time-constant η, deﬁned as η = limn→∞{n−1Hn}.

(5.61)Theorem(Existenceof time-constant). Letµbe a probabilitymeasure on ( ,F ) that is automorphism-invariant and Zd-ergodic. The deterministic limit

1 n

η(µ) = lim

Hn exists µ-almost-surely and in L1(µ).

![image 454](<rcm1-1_images/imageFile454.png>)

n→∞

The constant η(µ) is called the time-constant associated with µ.

Proof. See the comments in [119, 211], and the later paper [58]. The existence of the limit η is a consequence of a theorem attributed in [119, p. 748, Erratum] and [211, p. 259] to Derrienic.

We apply this to the measure µ = φp0,q to deduce the existence, φp0,q-almostsurely, of the associated (deterministic) time-constant (5.62) η(p,q) = lim

1 n

Hn . By Proposition 4.28, η(p,q) is non-increasing in p, and we deﬁne (5.63) ptc(q) = sup p : η(p,q) > 0 . We seek a condition under which η(p,q) > 0. As usual, C denotes the vertex set of the open cluster at the origin.

![image 455](<rcm1-1_images/imageFile455.png>)

n→∞

(5.64) Theorem (Positivity of time-constant) [163]. Let p ∈ (0,1) and q ∈ [1,∞). If φp0,q(|C|2d+ǫ) < ∞ for some ǫ > 0, then η(p,q) > 0.

We deﬁne the further critical point (5.65) pg(q) = sup p : ψ(p,q) > 0 , with ψ(p,q) as in (5.56). The correlation length ξ(p,q) is deﬁned by

ξ(p,q) = ψ(p,q)−1, subject to the conventionthat 0−1 = ∞. Note that ξ(p,q) is non-decreasingin p. Thusφp0,q(0 ↔ ∂ n)decaysexponentially asn → ∞ if and only if ξ(p,q) < ∞. (5.66) Theorem. Let q ∈ [1,∞). It is the case that ptc(q) = pg(q).

By this theorem and the prior observations, (5.67) ptc(q) = pg(q) = pc(q) ≤ pc(q), with equality conjectured. From the next section onwards, we shall use the expression pc(q) for the common value of ptc(q), pg(q), pc(q).

In the percolation case (when q = 1), the above ﬁrst-passage problem and the associated time-constant η(p,q) have been studied in detail; see [208, 211]. Several authors have given serious attention to a closely related question when q = 2 and d = 2, namely, the corresponding question for the two-dimensional Ising model with the ‘passage time’ Hn replaced by the minimum number of changes of spin along paths from the origin to ∂ n, see [1, 90, 119]. The timeconstant in the Ising case cannot exceed the corresponding random-cluster timeconstantη(p,2), sinceeachedgeoftheIsingmodelhavingendverticeswithunlike spins gives rise to a closed edge in the (coupled) random-cluster model.

We turn now to the proofs of Theorems 5.60 and 5.66, and shall use the ‘exponential-steepness’ Theorems 3.42 and 3.45. Let A be an increasing cylinder event. We apply (3.44) and (3.47) to the random-cluster measure φ0 m,p,q, noting that

q(1 − r) s − r

q s − r

< C <

. Let m → ∞ to obtain that, for 0 < r < s < 1,

![image 456](<rcm1-1_images/imageFile456.png>)

![image 457](<rcm1-1_images/imageFile457.png>)

(5.68) φr0,q(A) ≤ φs0,q(A)exp −4(s − r)φs0,q(HA) ,

− logφs0,q(A) log[q/(s − r)] −

C C − 1

φr0,q(HA) ≥

(5.69) .

![image 458](<rcm1-1_images/imageFile458.png>)

![image 459](<rcm1-1_images/imageFile459.png>)

Noteinpassingthatinequalities(5.68)and(5.69),with A = An = {0 ↔ ∂ n}, imply that the correlation length ξ(p,q) is strictly increasing in p whenever it is ﬁnite, cf. [154, Thm 6.14].

Proof of Theorem 5.66. Let r < s < ptc(q). Since s < ptc(q), there exists γ = γ(s,q) > 0 such that

(5.70) φs,q(Hn) ≥ nγ, n ≥ 1. Let A = An = {0 ↔ ∂ n}. In conjunction with (5.70), (5.68) implies the exponential decay of φr,q(An), whence r ≤ pg(q). Therefore ptc(q) ≤ pg(q).

Conversely, suppose that r < s < pg(q). There exists α = α(s,q) > 0 such that φs0,q(An) ≤ e−αn. By (5.69) with A = An and some β = β(r,s,q) > 0,

− log(e−αn) log[q/(s − r)] − β =

αn

φr0,q(Hn) ≥

log[q/(s − r)] − β, whence r ≤ ptc(q). Therefore pg(q) ≤ ptc(q).

![image 460](<rcm1-1_images/imageFile460.png>)

![image 461](<rcm1-1_images/imageFile461.png>)

There are two stages in the proof of Theorem 5.60. In the ﬁrst, we apply (5.68)–(5.69) with A = An, and we utilize an iterative scheme to prove that φp0,q(An) decays ‘near-exponentially’ when p < pc(q). In the second stage, we use Theorems 5.64 and 5.66 to deduce full exponential decay. The conclusion of the ﬁrst stage may be summarized as follows.

- (5.71) Lemma. Let q ∈ [1,∞), and let 0 < p < pc(q). There exist constants c = c(p,q) ∈ (0,∞), =  (p,q) ∈ (0,1) such that
- (5.72) φp0,q(An) ≤ exp(−cn ), n ≥ 1.


Lemma 5.71 will be proved by an iterative scheme which may be continued further. If this is done, one obtains that φp0,q(An) decays at least as fast as exp(−αkn/logk n) for any k ≥ 1, where αk = αk(p,q) > 0 and logk n is the kth iterate of logarithm, that is,

log1 x = log x, logk x = log(1 ∨ logk−1 x), k ≥ 2.

Proof of Lemma 5.71. We shall use (5.68) and (5.69) in an iterative scheme. In the following, we shall sometimes use real quantities when integers are required. All terms of the form o(1) or O(1) are to be interpreted in the limit as n → ∞.

Fix q ∈ [1,∞). For p < pc(q), there exists c1(p) > 0 such that

c1(p) nd−1

(5.73) φp0,q(An) ≤

, n ≥ 1.

![image 462](<rcm1-1_images/imageFile462.png>)

Let 0 < r < s < t < pc(q). By (5.69),

− logφt0,q(An) log D + O(1) ≥

(d − 1)logn log D + O(1)

φs0,q(Hn) ≥

![image 463](<rcm1-1_images/imageFile463.png>)

![image 464](<rcm1-1_images/imageFile464.png>)

where 1 < D = q/(t − s) < ∞. We substitute this into (5.68) to obtain that

c2(r) nd−1+ 2(r) , n ≥ 1,

(5.74) φr0,q(An) ≤

![image 465](<rcm1-1_images/imageFile465.png>)

for some strictly positive and ﬁnite c2(r) and 2(r). This holds for all r < pc(q), and is an improvement in order of magnitude over (5.73).

We obtain next an improvement of (5.74). Let m be a positive integer, and let Ri = im for i = 0,1,. . ., K, where K = ⌊n/m⌋. Let Li = {∂ Ri ↔ ∂ Ri+1}, and let Fi = HLi, the minimal number of extra edges needed for Li to occur. Clearly,

K−1

(5.75) Hn ≥

Fi,

i=0

since every path from 0 to ∂ n traverses each annulus Ri+1 \ Ri. There exists a constant ρ ∈ [1,∞) such that |∂ R| ≤ ρRd−1 for all R. By the translationinvariance of φp0,q,

(5.76) φp0,q(Li) ≤ |∂ Ri|φp0,q(Am) ≤ ρnd−1φp0,q(Am).

Let 0 < r < s < pc(q), and let c2 = c2(s), 2 = 2(s) where the functions c2(p) and 2(p) are chosen as in (5.74). By (5.74) and (5.76),

1 2

(5.77) φs0,q(Li) ≤ ρnd−1 c2

≤

![image 466](<rcm1-1_images/imageFile466.png>)

![image 467](<rcm1-1_images/imageFile467.png>)

md−1+ 2

if (5.78) m = [(3ρc2)nd−1]1/(d−1+ 2), and we choose m accordingly (here and later, we take n to be large). Now Fi ≥ 1 if Li does not occur, whence

K−1

[1 − φs0,q(Li)] ≥ 21 K

(5.79) φs0,q(Hn) ≥

![image 468](<rcm1-1_images/imageFile468.png>)

i=0

by (5.75) and (5.77). Also, (5.80) K = ⌊n/m⌋ ≥ an 3 by (5.78), for appropriate constants a ∈ (0,∞) and 3 ∈ (0,1). By (5.68) and (5.79), (5.81) φr0,q(An) ≤ exp(−c3n 3), n ≥ 1,

where c3 = c3(r) ∈ (0,∞) and 3 = 3(r) ∈ (0,1).

Proof of Theorem 5.64. Assume the given hypothesis. We shall use an extension of an argument taken from [119]. Let n be the set of all paths of Ld joining the origin to ∂ n. With T(π) denoting the number of closed edges in a path π, we have that

1 |Cx ∩ π|

T(π) + 1 ≥

![image 469](<rcm1-1_images/imageFile469.png>)

x∈π

where the summation is over all vertices x of π, Cx is the open cluster at x, and |Cx ∩ π| is the number of vertices common to Cx and π. By Jensen’s inequality,

−1

T(π) + 1 |π|

1 |Cx|

1 |π| x∈π

1 |π| x∈π

|Cx|

≥

≥

.

![image 470](<rcm1-1_images/imageFile470.png>)

![image 471](<rcm1-1_images/imageFile471.png>)

![image 472](<rcm1-1_images/imageFile472.png>)

![image 473](<rcm1-1_images/imageFile473.png>)

Therefore,

1 Kn

Hn + 1 n ≥ inf

T(π) + 1 |π|

≥

, where

![image 474](<rcm1-1_images/imageFile474.png>)

![image 475](<rcm1-1_images/imageFile475.png>)

![image 476](<rcm1-1_images/imageFile476.png>)

π∈ n

1 |π| x∈π

Kn = sup

|Cx| .

![image 477](<rcm1-1_images/imageFile477.png>)

π∈ n

By (5.62), φp0,q(η ≥ K−1) = 1, where

1 |π| x∈π

sup

(5.82) K = lim sup

|Cx| : |π| = m .

![image 478](<rcm1-1_images/imageFile478.png>)

m→∞

The (inner) supremum is over all paths from the origin containing m vertices. We propose to show that φp0,q(K < ∞) = 1, whence η > 0 as required.

Let { Cx : x ∈ Zd} be a collection of independent subsets of Zd with the property that Cx has the same law as Cx. We claim, as in [119], that the family {|Cx| : x ∈ Zd} is dominated stochastically by {Mx : x ∈ Zd}, where

Mx = sup | Cy| : y ∈ Zd, x ∈ Cy ,

and we shall prove this inductively. Let v1,v2,. . . be a deterministic ordering of Zd. Given the random variables { Cx : x ∈ Zd}, we shall construct a family {Dx : x ∈ Zd} having the same joint law as {Cx : x ∈ Zd} and satisfying: for each x, there exists y such that Dx ⊆ Cy. First, we set Dv1 = Cv1. Given Dv1, Dv2,. . ., Dvn, we deﬁne E = ni=1 Dvi. If vn+1 ∈ E, we set Dvn+1 = Dvj for some j such that vn+1 ∈ Dvj . If vn+1 ∈/ E, we proceed as follows. Let

eE be the set of edges of Zd having exactly one endvertex in E. We may ﬁnd a (random) subset F of Cvn+1 such that F has the conditional law of Cvn+1 given that all edges in eE are closed; we now set Dvn+1 = F. We are using two

properties of φp0,q here. Firstly, the law of Cvn+1 given Cv1,Cv2,. . .,Cvn depends only on eE, and secondly, φp0,q is positively associated. We obtain the required stochastic domination accordingly.

By (5.82) (and subject to K and the Cx being deﬁned on the same probability space),

1 |π| x∈π

Mx : |π| = m a.s.

sup

K ≤ lim sup

![image 479](<rcm1-1_images/imageFile479.png>)

m→∞

By [119, Lemma 2],

1 |Ŵ| x∈Ŵ

| Cx|2 : |Ŵ| = m a.s.

sup

K ≤ 2 lim sup

![image 480](<rcm1-1_images/imageFile480.png>)

m→∞

where the (inner) supremum is over all animals Ŵ of Ld having m vertices and containing the origin. By the main result of [97], the right side is almost-surely ﬁnite so long as each | Cx|2 has ﬁnite (d + ǫ)th moment for some ǫ > 0. The required conclusion follows.

Proof of Theorem 5.60. Let q ∈ [1,∞) and p < pc(q). Find r such that p < r < pc(q). By Lemma 5.71, there exist c,  > 0 such that

φr0,q(An) ≤ exp(−cn ), n ≥ 1.

This implies that φr0,q(|C|2d+1) < ∞. By Theorem 5.64, η(r,q) > 0, and so r ≤ ptc(q). By Theorem 5.66, r ≤ pg(q), and the claim follows.

5.6 Exponential decay of volume

For percolation, there is a beautiful proof of the exponential decay of volume using only that of radius. This proof hinges on the independence of the states of different edges, and may therefore not be extended at present to general randomcluster models, see [154, Thm 6.78]. We shall instead make use here of the block arguments of [209], obtaining thereby the exponential decay of volume subject to a condition on p believed but not known to hold throughout the subcritical phase. This condition differs slightly from that of the last section in that it involves the decay rate of certain ﬁnite-volume probabilities.

Let a ≥ 1, and let (5.83) La(p,q) = lim sup

nd−1φ1 an,p,q(0 ↔ ∂ n) . As at (5.57), La(p,q) is non-decreasing in p, and therefore,

n→∞

La(p,q) = 0 if p < pca(q), ∈ (0,∞] if p > pca(q),

120 Phase Transition [5.6]

where (5.84) pca(q) = sup p : La(p,q) = 0 . Clearly pca(q) is non-decreasing in a, and furthermore pca(q) ≤ pc(q) for all a ≥ 1. We set

pca(q). It is elementary that pc∞(q) ≤ pc(q), and we conjecture that equality holds. (5.85) Conjecture. If q ∈ [1,∞), then pc∞(q) = pc(q).

pc∞(q) = lim

a→∞

Here is the main result of this section.

(5.86) Theorem. Let q ∈ [1,∞). There exists ρ(p,q), satisfying ρ(p,q) > 0 when p < pc∞(q), such that

φp0,q(|C| ≥ n) ≤ e−nρ, n ≥ 1.

The hypothesis p < pc∞(q) is slightly stronger than that of Theorem 5.60, and so is the conclusion, since φp0,q(rad(C) ≥ n) ≤ φp0,q(|C| ≥ n). Proof. We adapt the arguments of [209, Section 2], from which we extract the main steps. For N ≥ 1 and i = 1,2,. . . ,d, we deﬁne the box

TN(i) = [0,3N]i−1 × [0, N] × [0,3N]d−i.

For ω ∈ , an i-crossing of TN(i) is an open path x0,e0, x1,e1,. . .,em of alternating vertices and edges of TN(i) such that the ith coordinate of x0 (respectively, xm) is 0 (respectively, N). Such crossings are in the short direction. For b > 3, we deﬁne

(5.87) τNb = φ1 bN,p,q TN(i) has an i-crossing ,

noting by rotation-invariance that τNb does not depend on the value of i.

Let N be a ﬁxed positive integer. From Ld we construct a new lattice L as follows. First, LhasvertexsetZd. Twoverticesx,yofLaredeemedadjacentinL if andonlyif |xi −yi| ≤ 3 forall i = 1,2,. . .,d. The betterto distinguishvertices of Ld and L, we shall use bold letters to indicate the latter. Let ω ∈ . Vertex x of L is coloured white if there exists i ∈ {1,2,. . .,d} such that Nx + TN(i) has an i-crossing, and is coloured black otherwise. The event {x is white} is increasing, and is deﬁned in terms of the states of edges in the box  (x) = Nx + [0,3N]d.

The following lemma relates the size of the open cluster C at the origin of Ld to the sizes of white clusters of L. For x ∈ Zd, we write Wx for the connected cluster of white vertices of L containing x.

(5.88) Lemma [209]. Let ω ∈ . Assume that C contains some vertex v with

d

xj N,(xj + 1)N − 1 ,

v ∈

j=1

for some x = (x1, x2,. . ., xd) ∈ Zd satisfying (5.89) |xj| ≥ 2 for some j ∈ {1,2,. . .,d}. There exists a neighbour y of the origin 0 of L such that

(5.90) |Wy| ≥ 7−2d |C| − (4N)d Nd

![image 481](<rcm1-1_images/imageFile481.png>)

.

Proof. This may be derived from that of [209, Lemma 2].

Since 0 has fewer than 7d neighbours on L, (5.91) φp0,q(|C| ≥ n) ≤ 7dφp0,q(|W0| ≥ An − 1), where A = 7−2d N−d. Therefore, (5.92) φp0,q(|C| ≥ n) ≤ 7d

amMp,q(m),

m≥An−1

where am is the number of connected sets w of m vertices of L containing 0, and Mp,q(m) = max φp0,q(all vertices in w are white) : |w| = m . By the ﬁnal display of the proof of [209, Lemma 3], (5.93) am ≤ 72d(7de)m, and it remains to bound φp0,q(all vertices in w are white).

Fix b > 3, to be chosen later. Let w be as above with |w| = m. There exists a constantc = c(b) > 0 such that: w containsatleast t vertices y(1),y(2),. . .,y(t) such that t ≥ cm and the boxes Ny(r) + bN, r = 1,2,. . .,t, of Ld are disjoint. We may choose such a set {y(r) : r = 1,2,. . .,t} in a way which depends only on the set w. Then

(5.94) φp0,q(all vertices in w are white) ≤ φp0,q y(r) is white, r = 1,2,. . .,t . The events {y(r) is white}, r = 1,2,. . .,t, are dependent under φp0,q. However, by positive association, (5.95)

φp0,q y(r) is white, r = 1,2,. . .,t ≤ φp0,q y(r) is white, r = 1,2,. . .,t E ,

where E istheeventthateveryedgeehavingbothendverticesin Ny(r)+∂ bN, for any given r ∈ {1,2,. . .,t}, is open. Under the conditional measure φp0,q(· | E), the events {y(r) is white}, r = 1,2,. . .,t, are independent, whence by symmetry

(5.96) φp0,q y(r) is white, r = 1,2,. . .,t ≤ φ1 bN,p,q(0 is white) t

≤ (dτNb )t. By (5.92)–(5.96),

72d(7de)m(dτNb )⌊cm⌋.

(5.97) φp0,q(|C| ≥ n) ≤ 7d

m≥An−1

Let a > 1 and choose b > 3 + a, noting that x + aN ⊆ bN for all x ∈ Zd lying in the region R = [0,3N]d−1 × {0}. If TN(d) has a d-crossing, there exists x ∈ R such that x ↔ x + ∂ N. Since φ1 bN,p,q ≤st φ1 aN,p,q,

(5.98) φ1 bN,p,q(x ↔ x + ∂ N)

τNb ≤

x∈R

≤ |R|φ1 aN,p,q(0 ↔ ∂ N)

= (3N + 1)d−1φ1 aN,p,q(0 ↔ ∂ N).

Let p < pc∞(q), and choose a > 1 such that p < pca(q). With b > 3 + a, the right side of (5.98) may be made as small as required by a suitably large choice of N, and we choose N in such a way that 7de(dτNb )c < 21. Inequality (5.97) provides the required exponential bound.

![image 482](<rcm1-1_images/imageFile482.png>)

5.7 The supercritical phase and the Wulff crystal

Percolation theory is a source of intuition for the more general random-cluster model, but it has not always been possible to make such intuition rigorous. This is certainly so in the supercritical phase, where several of the basic questions remain unanswered to date. We shall work in this section with the free and wired measures, φp0,q and φp1,q, and we assume throughout that q ∈ [1,∞).

The ﬁrst property of note is the almost-sure uniqueness of the inﬁnite open cluster. A probability measure φ on ( ,F ) is said to have the 0/1-inﬁnite-cluster property if the number I of inﬁnite open clusters satisﬁes φ(I ∈ {0,1}) = 1. We recall from Theorem 4.33(c) that every translation-invariant member of the closed convex hull of Wp,q has the 0/1-inﬁnite-cluster property. By ergodicity, see Corollary 4.23, we arrive at the following.

(5.99) Theorem (Uniqueness of inﬁnite open cluster). Let p ∈ [0,1] and q ∈ [1,∞). We have for b = 0,1 that (5.100) φpb,q(I = 1) = 1 whenever θb(p,q) > 0.

Let q ∈ [1,∞) and p > pc(q). There exists (φpb,q-almost-surely) a unique inﬁnite open cluster. What may be said about the shapes and sizes of ﬁnite open clusters? One expects ﬁnite clusters to have properties broadly similar to those of supercritical percolation. Much progress has been made in recent years towards proofs of such statements, but a vital step remains unresolved. As was true formerly for percolation, the results in question are proved only for p exceeding a certain ‘slab critical point’ pc(q), and it is an important open problem to prove that pc(q) = pc(q) for all q ∈ [1,∞).

Here is an illustration. It is fundamental for supercritical percolation that the tails of the radius and volume of a ﬁnite open cluster decay exponentially in n and n(d−1)/d respectively, see [154, Thms 8.18, 8.65]. This provokes an important problem for the random-clustermodel whose full resolution remains open. Partial results are known when p > pc(q), see Theorems 5.104 and 5.108.

(5.101) Conjecture. Let p ∈ [0,1] and q ∈ [1,∞). There exist σ = σ(p,q), γ = γ(p,q), satisfying σ(p,q),γ(p,q) > 0 when p > pc(q), such that

φp1,q(n ≤ rad(C) < ∞) ≤ e−nσ, φp1,q(n ≤ |C| < ∞) ≤ e−γn(d−1)/d, n ≥ 1.

We turn next to a discussion of the so-called ‘Wulff construction’. Much attention has been paidto the sizes andshapes of clustersformedin modelsof statistical mechanics. When a cluster C is inﬁnite with a strictly positive probability, but is constrained to have some large ﬁnite size N, then C is said to form a large ‘droplet’. The asymptotic shape of such a droplet, in the limit of large N, is prescribed in general terms by the theory of the so-called Wulff crystal5. In the case of the random-cluster model, we ask for properties of the open cluster C at the origin, conditionalon the event {N ≤ |C| < ∞} for large N. The rigorouspicture is not yet complete, but techniques have emerged through the work of Cerf and Pisztora, [83, 84, 276], which may be expected to reveal in due course a complete account of the Wulff theory of large ﬁnite clusters in the random-clustermodel. A full account of this work would be too lengthy for inclusion here, and we content ourselves with a brief summary.

The study of the Wulff crystal is bound up with the law of the volume of a ﬁnite cluster, see Conjecture 5.101. It is straightforward to adapt the corresponding percolation proof (see [154, Thm 8.61]) to obtain that

φp1,q(|C| = n) ≥ e−γn(d−1)/d,

![image 483](<rcm1-1_images/imageFile483.png>)

5Such shapes are named after the author of [325]. The ﬁrst mathematical results on Wulff shapes were proved for the two-dimensional Ising model in [104], see the review [55].

for some γ satisfying γ < ∞ when pc(q) < p < 1. It is believed as noted above that this is the correct order for the rate of decay of φp1,q(|C| = n) when p > pc(q).

Before continuing, we make a commentconcerning the numberof dimensions. The case d = 2 is special (see Chapter 6). By the duality theory for planar graphs, the dual of a supercritical random-clustermeasure is a subcritical randomcluster measure, and this permits the use of special arguments. We shall therefore suppose for the majority of the rest of this section that d ≥ 3; some remarks about the two-dimensional case are made after Theorem 5.108.

A partial account of the Wulff construction and the decay of volume of a ﬁnite cluster is provided in [83], where the asymptotic shape of droplets is studied in the special case of the Ising model. The proofs to date rely on two assumptions on the value of p, namely that p is such that φp0,q = φp1,q, cf. Conjecture 5.34, and secondly that p exceeds a certain ‘slab critical point’ pc(q) which we introduce next.

Fix q ∈ [1,∞) and let d ≥ 3. Let S(L,n) be the slab given as S(L,n) = [0, L − 1] × [−n,n]d−1,

and let ψpL,,qn = φS0(L,n),p,q be the random-clustermeasure on S(L,n) with parameters p, q, and with free boundaryconditions. We denote by  (p, L) the property that:

there exists α > 0 such that, for all n and all x ∈ S(L,n),ψpL,,qn(0 ↔ x) > α.

It is not hard to see that  (p, L) ⇒  (p′, L′) if p ≤ p′ and L ≤ L′, and it is thus natural to deﬁne the quantities

(5.102) pc(q, L) = inf p :  (p, L) occurs , pc(q) = lim

pc(q, L).

L→∞

Clearly, pc(q) ≤ pc(q) < 1. It is believed that equality holds in that pc(q) = pc(q), and it is a major open problem to prove this6.

(5.103) Conjecture [276]. Let q ∈ [1,∞) and d ≥ 3. Then pc(q) = pc(q).

Thecase q = 1 ofConjecture5.103isspecial, since percolationenjoysa spatial independence not shared with general random-cluster models. This additional property has been used in the formulation of a type of ‘dynamic renormalization’, which has in turn yielded a proof that pc(1) = pc(1) for percolation in three or more dimensions, see [24], [154, Chapter 7], [161]. Such arguments have been adapted by Bodineau to the Ising model, resulting in proofs that pc(2) = pc(2) and that the pure phases are the unique extremalGibbs states when p  = pc(2), see

![image 484](<rcm1-1_images/imageFile484.png>)

6OnemayexpectthemethodsofSection7.5toyieldaproofthat pc(q) = pc(q)forsufﬁciently large q.

[53, 54]. Such arguments do not to date have a full random-cluster counterpart. Instead, in the random-cluster setting, one exploits what might be termed ‘static renormalization’methods, or ‘block arguments’, see [83, 276]. One divides space into blocks, constructs events of an appropriate nature on such blocks, having large probabilities, and then allows these events to combine across space. There have been substantial successes using this technique, of which the most striking is the resolution (subject to side conditions) of the Wulff construction for the Ising model.

We state next an exponential-decay theorem for the radius of a ﬁnite cluster; the proof is given at the end of this section. It is an immediate corollary that the ‘truncated two-point connectivity function’ φp1,q(x ↔ y, x ↔/ ∞) decays exponentially in the distance x − y , whenever p > pc(q).

(5.104) Theorem. Let q ∈ [1,∞), d ≥ 3, and p > pc(q). There exists σ = σ(p,q) > 0 such that

φp1,q(n ≤ rad(C) < ∞) ≤ e−nσ, n ≥ 1.

We turn now to the Wulff construction. Subject to a veriﬁcation of Conjecture 5.103, and of a positive answerto the questionof the uniquenessof random-cluster measureswhen p > pc(q),theblockargumentsofCerfandPisztorayieldalargely complete picture of the Wulff theory of random-cluster models with q ∈ [1,∞), see [83, 276] and also [84]. Paper [81] is a ﬁne review of Wulff constructions for percolation, Ising, and random-cluster models.

The reader is referred to [81] for an introductory discussion to the physical background of the Wulff construction. It may be summarized as follows for random-cluster models. Let n = [−n,n]d, and consider the wired randomcluster measure φ1 n,p,q with p > pc(q). The larger an open cluster, the more likely it is to be joined to the boundary ∂ n. Suppose that we condition on the event that there exists in n an open cluster C that does not intersect ∂ n and that has volume of the order of the volume nd of the box. What can be said about the shape of C? Since p > pc(q), there is little cost in having large volume, and the price of such a cluster accumulates around its external boundary. It turns out that the price may be expressed as a surface integral of an appropriate function termed ‘surface tension’. This ‘surface tension’ may be speciﬁed as the exponential rate of decay of a certain probability. The Wulff prediction for the shape of C is that, when re-scaled in the limit of large n, it converges to the solution of a certain variational problem, that is, the limit shape is obtained by minimizing a certain surface integral subject to a constraint on its volume.

For A ⊆ Zd, let ρ(A) be the number of vertices x ∈ A such that x ↔ ∂ A. When p > pc(q), ρ( n) has order | n|. Let C be the open cluster at the origin, and suppose we condition on the event {|C| ≥ αnd, C ∩∂ n = ∅} where α > 0. This conditioning implies a change in value of ρ( n)/| n| amounting to a large deviation. The link between Wulff theory and large deviations is made more concrete in the next theorem. The set Dq is given in Theorem 4.63 as the (at most

(5.106) Theorem [81]. Let q ∈ [1,∞) and d ≥ 3. Let p ∈ ( pc(q),1) be such that p ∈/ Dq. There exists a bounded, closed, convex set W of Rd containing the origin in its interior such that the following holds. Under the conditionalmeasure obtained from φp1,q by conditioning on the event {nd ≤ |C| < ∞}, the random measure

1 nd x∈C

δx/n

![image 485](<rcm1-1_images/imageFile485.png>)

converges in probability, with respect to the bounded, uniformly continuous functions, towards the set {θ1W(a + x)dx : a ∈ R} of measures, where θ = θ1(p,q). The probabilities of deviations are of order exp(−cnd−1).

The meaning of the conclusion is as follows. For k ≥ 1, for any bounded, uniformly continuous function f : Rd → Rk, and for any ǫ > 0, there exists c = c(d,k, p,q, f,ǫ) > 0 such that

1 nd x∈C

φ1p,q ∃a ∈ Rd s.t.

(5.107) f (a + x)dx ≤ ǫ

f (x/n) − θ

![image 486](<rcm1-1_images/imageFile486.png>)

![image 487](<rcm1-1_images/imageFile487.png>)

x∈W

≥ 1 − e−cnd−1, n ≥ 1,

where φ1p,q is the measure obtained from φp1,q by conditioning on the event {nd ≤ |C| < ∞}, and | · | is the Euclidean norm on Rk. This is a way of saying that the external boundary of a large ﬁnite open cluster with cardinality approximately nd resembles the boundary of a translate of nW. Within this boundary, the open cluster has density approximately θ, whilst the density outside is zero. It is presumably the case that the a in (5.107) may be chosen independently of f and ǫ, but this has not yet been proved.

![image 488](<rcm1-1_images/imageFile488.png>)

One important consequence of the analysis of [83] is an exact asymptotic for the probability that |C| is large. (5.108) Theorem [81]. Let q ∈ [1,∞) and d ≥ 3. Let p ∈ ( pc(q),1) be such that p ∈/ Dq. There exists γ = γ(p,q) ∈ (0,∞) such that

1 nd−1

logφp1,q(nd ≤ |C| < ∞) → −γ as n → ∞.

![image 489](<rcm1-1_images/imageFile489.png>)

The above results are valid in two dimensions also although, as noted earlier, this case is special. When d = 2, the slab critical point pc(q) is replaced by the inﬁmumofvalues patwhichthedualprocesshasexponentialdecayofconnections (see (6.5) for the relation between the dual and primal parameter-values). That is, when d = 2,

q(1 − pg(q)) pg(q) + q(1 − pg(q))

pc(q) =

![image 490](<rcm1-1_images/imageFile490.png>)

where pg(q) is given at (5.65). Fluctuations in droplet shape for random-cluster models in two dimensions have been studied in [17, 18].

ProofofTheorem5.104. Weadapttheproofof[87]asreportedin[154,Thm8.21]. We shall build the cluster C at the origin (viewed as a set of open edges) step by step, in a manner akin to the proof of Proposition 5.30. First, we order the edges of Ld in some arbitrary but deterministic way, and we write ei for the ith edge in this ordering. Let ω ∈ . We shall construct a sequence (C0, D0),(C1, D1),. . . of pairs of (random) edge-sets such that Ci ⊆ Ci+1 and Di ⊆ Di+1 for each i. Every edge in each Ci (respectively, Di) will be open (respectively, closed). Let C0 = D0 = ∅. Having found (Cm, Dm) for m = 0,1,. . .,n, we ﬁnd the earliest edge e ∈/ Cn ∪ Dn in the above ordering such that e has an endvertex in common with some member of Cn; if Cn = ∅ we take e ∈/ Dn to be the earliest edge incident to the origin if such an edge exists. We now deﬁne

(Cn+1, Dn+1) =

(Cn ∪ {e}, Dn) if e is open, (Cn, Dn ∪ {e}) if e is closed.

This process is continued until no candidate edge e may be found, which is to say that we have exhausted the open cluster C. If Cn = C for some n then we deﬁne Cl = C for l ≥ n, so that

(5.109) C = lim

Cn.

n→∞

Let Hn = {x ∈ Zd : x1 = n}, and let Gn be the event that the origin belongs to a ﬁnite cluster that intersects Hn. The box n has 2d faces, whence, by the rotation-invariance of φp0,q,

(5.110) φp1,q 0 ↔ ∂ n, |C| < ∞ ≤ 2dφp1,q(Gn). We shall prove that, for p > pc(q), there exists γ > 0 such that (5.111) φp1,q(Gn) ≤ e−nγ , n ≥ 1, and the claim of the theorem is an immediate consequence.

The idea of the proof of (5.111) is as follows. Since p > pc(q) by assumption, we may ﬁnd an integer L such that p > pc(q, L). Write S(L) = [0, L) × Zd−1, and

(5.112) Si(L) = S(L) + (i − 1)Le1 = (i − 1)L,iL × Zd−1,

where e1 = (1,0,0,. . .,0). Suppose that GmL occurs for some m ≥ 1. Then each of the regions Si(L), i = 1,2,. . .,m, is traversedby an open path π from the origin. Since p > pc(q, L), there is φS0i(L),p,q-probability 1 that Si(L) contains an inﬁnite open cluster, and π must avoid all such clusters for i = 1,2,. . .,m.

Let S(L, N) = [0, L)×[−N, N]d−1. Since p > pc(q, L), we may ﬁnd α > 0 such that

φS0(L,N),p,q(0 ↔ v) > α, v ∈ S(L, N). By positive association,

(5.113) φS0(L,N),p,q(v ↔ ∂ M) > α2, v ∈ S(L, N), 0 < M ≤ N.

Let n be a positive integer satisfying n ≥ L, and write n = rL + s where 0 ≤ s < L. Let n < M < N, and consider the probability ψN(Gn,M) where ψN = φ1 N,p,q and Gn,M = {0 ↔ Hn, 0 ↔/ ∂ M}. Later, we shall take the limit as M, N → ∞. On the event Gn,M, we have that T ≥ r, and vi ↔/ ∂ M in Si(L), for i = 1,2,. . .,r. Therefore,

(5.114) ψN(Gn,M) ≤ ψN(Ar), where

j

vi ↔/ ∂ M in Si(L) .

Aj = {T ≥ j} ∩

i=1

Now A0 = , and Aj ⊇ Aj+1 for j ≥ 1, whence

r

(5.115) ψN(Gn,M) ≤ ψN(A1)

ψN(Aj | Aj−1).

j=2

Let j ∈ {2,3,. . .,r}, and consider the conditionalprobability ψN(Aj | Aj−1); the case j = 1 is similar. We have that

ψN(Aj | Aj−1) ≤

ψN v ↔/ ∂ M in Sj(L) vj = v, T ≥ j, Aj−1 ×ψN(vj = v | T ≥ j, Aj−1)ψN(T ≥ j | Aj−1).

v∈H(j−1)L

We claim that (5.116) ψN v ↔/ ∂ M in Sj(L) vj = v, T ≥ j, Aj−1 ≤ 1 − α2. This will imply that

ψN(Aj | Aj−1) ≤ (1 − α2)

ψN(vj = v | T ≥ j, Aj−1)

v∈H(j−1)L

= 1 − α2, yielding in turn by (5.114)–(5.115) that ψN(Gn,M) ≤ (1 − α2)r.

[5.8] Uniqueness when q < 1 131

Let N → ∞ and M → ∞ to obtain that

φp1,q(0 ↔ Hn, 0 ↔/ ∞) ≤ (1 − α2)⌊n/L⌋, n ≥ 1, and (5.111) follows as required.

It remains to prove (5.116), which we do by a coupling argument. Suppose that we have ‘built’ the cluster at the origin until the ﬁrst epoch m = mj at which Cm touches Sj(L) and, in so doing, we have discovered that vj = v, T ≥ j, and Aj−1 occurs. The event Ev = {v ↔/ ∂ M in Sj(L)} is measurable on the σ-ﬁeld generated by the edge-states in Sj(L), and the conﬁguration on Sj(L) is governed by a certain conditional probability measure, namely that featuring in (5.116). This conditional measure on Sj(L) dominates (stochastically) the free random-cluster measure on Sj(L) ∩ N = S(L, N) + (j − 1)Le1. Since the last region is a translate of S(L, N),

ψN(Ev | vj = v, T ≥ j, Aj−1) ≤ 1 − α2, by (5.113), and (5.116) is proved.

5.8 Uniqueness when q < 1

Only a limited amount is known about the (non-)uniqueness of random-cluster measures on Ld when q < 1, owing to the absence of stochastic ordering and the failure of positive association. By Theorems 4.31 and 4.33, there exists at least one translation-invariant member of coWp,q, and this measure is a DLRrandom-cluster measure. One may glean a little concerning uniqueness from the comparison inequalities, Theorem 3.21, from which we extract the facts that, for the random-cluster measure φG,p,q on a ﬁnite graph G = (V, E),

![image 491](<rcm1-1_images/imageFile491.png>)

(5.117) φG,p1,1 ≤st φG,p2,q if q ≤ 1, p1 ≤ p2, φG,p1,1 ≥st φG,p2,q if q ≤ 1,

p1 1 − p1 ≥

p2 q(1 − p2)

(5.118) .

![image 492](<rcm1-1_images/imageFile492.png>)

![image 493](<rcm1-1_images/imageFile493.png>)

Onemaydeducethefollowingbymakingcomparisonswiththepercolationmodel. (5.119) Theorem. For d ≥ 2, there exists p′ = p′(d) < 1 such that the following holds. Let p ∈ (0,1), q ∈ (0,1], and write π = p/[p + q(1 − p)]. We have that |Wp,q| = |Rp,q| = 1 whenever either θ(π,1) = 0 or p > p′.

Exponential decay holds similarly when q ∈ (0,1) and π < pc(1). That is,

there exists ψ = ψ(p,q) > 0 such that φp0,q(|C| = n) ≤ e−nψ, see the comment in the proof of Theorem 5.55.

Proof7. The proof is similar to that of Proposition 5.30 and is therefore only sketched. Let p, q be such that q ∈ (0,1) and θ(π,1) = 0, and let and be

![image 494](<rcm1-1_images/imageFile494.png>)

7See also [8, 156, 281].

132 Phase Transition [5.8]

boxes satisfying ⊆ . A cutset is deﬁned to be a subset S of E \ E such that: every path joining to ∂  uses at least one edge of S, and S is minimal with this property. For a cutset S, we write int S for the set of edges of E possessing no endvertex x such that x ↔ ∂  off S, and we write S = S ∪ int S. There is a partial order on cutsets given by S1 ≤ S2 if S1 ⊆ S2.

Let A ∈ F . Let , be boxes such that ⊆ ⊆ , and let ξ,τ ∈ . By (5.118), there exists a probability measure ψ on {0,1}E × {0,1}E × {0,1}E such that the following hold.

- (i) The set of triples (ω1,ω2,ω3) satisfying ω1 ≤ ω3 and ω2 ≤ ω3 has ψ probability 1.
- (ii) The ﬁrst marginal of ψ is φ ,ξ p,q, the second marginal restricted to E is φ ,τ p,q, and the third marginal is the product measure φ ,π.
- (iii) Let M denote the maximal cutset of every edge of which is closed in ω3, and note that M exists if and only if ω3 ∈ {∂  ↔/ ∂ }. Conditional on M, the marginal law of both {ω1(e) : e ∈ int M} and {ω2(e) : e ∈ int M} is the free measure φint0 M,p,q.


By conditioning on M, (5.120) φ ,ξ p,q(A) − φ ,τ p,q(A) ≤ φ ,π(∂  ↔ ∂ ).

By Theorem 4.17(a), there exists a probability measure ρ ∈ Wp,q, and we choose τ ∈ and an increasing sequence = ( n : n = 1,2,. . .) such that

φτ n,p,q ⇒ ρ as n → ∞. Suppose thatρ′ ∈ Wp,q and ρ′  = ρ. Thereexists ξ ∈ and an increasing sequence = ( n : n = 1,2,. . .) such that φξ n,p,q ⇒ ρ′.

For m sufﬁcientlylargethat ⊆ m, let n = nm satisfy m ⊆ n. By (5.120) with = m, = n, (5.121) φξ n,p,q(A) − φτ m,p,q(A) ≤ φ n,π(∂  ↔ ∂ m).

Let n → ∞ and m → ∞ in that order. Since θ(π,1) = 0, the right side tends to zero, and therefore ρ′(A) = ρ(A). This holds for all cylinders A, and therefore ρ′ = ρ, a contradiction. It follows that |Wp,q| = 1. An alternative argument uses the method of [117].

Suppose next that φ ∈ Rp,q so that, for any box ,

φ(A | T )(ξ) = φ ,ξ p,q(A) φ-a.s. By (5.120) with = = m and ρ as above, |φ(A) − ρ(A)| = lim

φ(φ(A | T m)) − φτ m,p,q(A) ≤ lim

m→∞

φ m,π(∂  ↔ ∂ m) = 0, whence Rp,q = {ρ}.

m→∞

Asimilarproofofuniquenessisvalidforlarge p, using(5.117)andtheapproach taken for Theorem 5.33(b).

## Chapter 6 In Two Dimensions

Summary. The dual of the random-cluster model on a planar graph is a random-cluster model also. The self-duality of the square lattice gives rise to the conjecture that pc(q) = psd(q) for q ∈ [1,∞), where psd(q) denotes the self-dual point √q/(1+

√q). Using duality, one obtains the uniqueness of random-cluster measures for p  = psd(q) and q ∈ [1, ∞). The phase transition is discontinuous if q is sufﬁciently large. Results similar to those for the square lattice may be obtained for the triangular and hexagonal lattices, using the star–triangle transformation. It is expected when q ∈ [1,4) that the critical process may be described by a stochastic Lowner evolution.¨

![image 495](<rcm1-1_images/imageFile495.png>)

![image 496](<rcm1-1_images/imageFile496.png>)

6.1 Planar duality

The duality theory of planar graphs provides a technique for studying randomcluster models in two dimensions. We shall see that, for a dual pair (G, Gd) of ﬁnite planar graphs, the measures φG,p,q and φGd,pd,q are dual measures in a certain sense to be explained soon, where p and pd are related by pd/(1 − pd) = q(1 − p)/p. Such a duality survives the passage to a thermodynamic limit, and may therefore be applied also to inﬁnite planar graphs including the square lattice L2. The square lattice has the further property of being isomorphic to its (inﬁnite) dual, and this observation leads to many results of signiﬁcance for the associated model. We begin with an account of planar duality in the random-cluster context.

A graph is called planar if it may be embedded in R2 in such a way that two edges intersect only at a common endvertex. Let G = (V, E) be a planar (ﬁnite or inﬁnite) graph embedded in R2. We obtain its dual graph Gd = (Vd, Ed) as follows1. We place a dual vertex within each face of G, including any inﬁnite face of G if such exist. For each e ∈ E we place a dual edge ed = xd, yd joining the two dual vertices lying in the two faces of G abutting e; if these two faces are the same, then xd = yd and ed is a loop. Thus, Vd is in one–one correspondence with

![image 497](<rcm1-1_images/imageFile497.png>)

1The roman letter ‘d’ denotes ‘dual’ rather than ‘dimension’.

138 In Two Dimensions [6.2]

6.2 The value of the critical point

It is conjectured that the critical point and the self-dual point of the square lattice are equal.

(6.15) Conjecture. The critical value pc(q) of the square lattice L2 is given by (6.16) pc(q) =

√q 1 +

![image 498](<rcm1-1_images/imageFile498.png>)

, q ∈ [1,∞).

√q

![image 499](<rcm1-1_images/imageFile499.png>)

![image 500](<rcm1-1_images/imageFile500.png>)

Thishasbeen provedwhenq = 1, q = 2, and when q ≥ 25.72. The q = 1 case was answered by Kesten, [207], in his famous proof that the critical probability of bond percolation on L2 is 21. For q = 2, the value of pc(2) given above agrees with the Kramers–Wannier [221] and Onsager [264] calculations of the critical temperature of the Ising model on Z2, and is implied by probabilistic results in the modern vernacular, see [5] and Section 9.3. The formula (6.16) for pc(q) has been established rigorously in [224, 225] for sufﬁciently large (real) values of q, speciﬁcally q ≥ 25.72 (see also [153]). This is explored further in Section 6.4, see Theorem 6.35.

![image 501](<rcm1-1_images/imageFile501.png>)

Several other remarkable conjectures about the phase transition on L2 may be found in the physics literature as consequences of ‘exact’ but non-rigorous arguments involving ice-type models, see [26]. These include exact formulae for the asymptotic behaviour of the partition function lim ↑Z2{Z (p,q)}1/| |, and also for the edge-densities at the self-dual point psd(q), that is, the quantities hb(q) = φbp

sd(q),q(e is open) for b = 0,1. These formulae are summarized in Section 6.6.

Conjecture 6.15 asserts that pc(q) = psd(q) for q ∈ [1,∞). One part of this equality is known. Recall that θ0(p,q) = φp0,q(0 ↔ ∞). (6.17) Theorem [152, 314]. Consider the square lattice L2, and let q ∈ [1,∞).

(a) We have that θ0(psd(q),q) = 0, whence pc(q) ≥ psd(q). (b) There exists a unique random-cluster measure if p  = psd(q), that is,

√q 1 +

![image 502](<rcm1-1_images/imageFile502.png>)

|Rp,q| = |Wp,q| = 1 if p  =

√q

.

![image 503](<rcm1-1_images/imageFile503.png>)

![image 504](<rcm1-1_images/imageFile504.png>)

The complementary inequality pc(q) ≤ psd(q) has eluded mathematicians despiteprogressbyphysicists,[183]. Hereisanintuitiveargumenttojustifythelatter inequality. Supposeonthe contrarythat pc(q) > psd(q), so that pc(q)d < psd(q). For p ∈ (pc(q)d, pc(q)) we have also that pd ∈ (pc(q)d, pc(q)). Therefore, for p ∈ (pc(q)d, pc(q)), both primal and dual processes comprise (almost surely) the union of ﬁnite open clusters. This contradicts the intuitive picture, supported for p  = pc(q) by our knowledge of percolation, of ﬁnite open clusters of one process ﬂoating in an inﬁnite open ocean of the other process.

Conjecture 6.15 would be proven if one could show the sufﬁciently fast decay

of φp0,q(0 ↔ ∂ (n)) as n → ∞. An example of such a statement may be found at Lemma 6.28, and another follows. Recall from Section 5.5 the quantity pc(q).

- (6.18) Theorem [163]. Let q ∈ [1,∞) and suppose that, for all p < pc(q), there exists A = A(p,q) < ∞ with
- (6.19) φp0,q(0 ↔ ∂ (n)) ≤


A n

, n ≥ 1.

![image 505](<rcm1-1_images/imageFile505.png>)

Then pc(q) = pc(q) = psd(q).

Rigorous numerical upper bounds of impressive accuracy have been achieved for the square lattice and certain other two-dimensional lattices. (6.20) Theorem [15]. The critical point pc(q) of the square lattice L2 satisﬁes

√q 1 − q−1 +

![image 506](<rcm1-1_images/imageFile506.png>)

(6.21) pc(q) ≤

, q ∈ [2,∞).

√q

![image 507](<rcm1-1_images/imageFile507.png>)

![image 508](<rcm1-1_images/imageFile508.png>)

![image 509](<rcm1-1_images/imageFile509.png>)

For example, when q = 10, we have that 0.760 ≤ pc(10) ≤ 0.769, to be compared with the conjecture that pc(10) =

√10) ≃ 0.760. The upper bound in (6.21) is the dual value of psd(q − 1). See also Theorem 6.30.

√10/(1 +

![image 510](<rcm1-1_images/imageFile510.png>)

![image 511](<rcm1-1_images/imageFile511.png>)

Exact values for the critical points of the triangular and hexagonal lattices may be conjectured similarly, using graphical duality together with the star–triangle transformation; see Section 6.6.

Proof of Theorem6.17. (a) There are at least two ways of provingthis. One way is to use the circuit-constructionargumentpioneeredby Harris, [181], anddeveloped further in [47, 130], see Theorem 6.47. We shall instead adapt an argument of Zhang using the 0/1-inﬁnite-cluster property, see [154, p. 289]. Let p = psd(q), so that φp0,q and φp1,q are dual measures in the sense of Theorem 6.13.

For n ≥ 1, let Al(n) (respectively Ar(n), At(n), Ab(n)) be the event that some vertex on the left (respectively right, top, bottom) side of the square T(n) = [0,n]2 lies in an inﬁnite open path of L2 using no other vertex of T(n). Clearly Al(n), Ar(n), At(n), and Ab(n) are increasingeventswhose unionequalsthe event {T(n) ↔ ∞}. Furthermore, by rotation-invariance,

(6.22) for b = 0,1 and n ≥ 1, φpb,q(Au(n)) is constant for u = l,r,t,b.

Supposethatθ0(p,q) > 0, whencebystochasticordering θ1(p,q) > 0. Since the φpb,q have the 0/1-inﬁnite-cluster property,

φpb,q Al(n) ∪ Ar(n) ∪ At(n) ∪ Ab(n) → 1 as n → ∞. By positive association,

φpb,q(T(n) ↔/ ∞) ≥ φpb,q Al(n) φpb,q Ar(n) φpb,q At(n) φpb,q Ab(n) ,

![image 512](<rcm1-1_images/imageFile512.png>)

![image 513](<rcm1-1_images/imageFile513.png>)

![image 514](<rcm1-1_images/imageFile514.png>)

![image 515](<rcm1-1_images/imageFile515.png>)

giving that φpb,q(A) ≥ 21 for b = 0,1.

![image 516](<rcm1-1_images/imageFile516.png>)

Wenowusethefactthateveryrandom-clustermeasure φpb,q hasthe0/1-inﬁnitecluster property, see Theorem 4.33(c). If A occurs, then L2 \ T(N) contains two disjoint inﬁnite open clusters, since the clusters in questions are separated by inﬁnite open paths of the dual; any open path of L2 \ T(N) joining these two clusters would contain an edge which crosses an open edge of the dual, and no such edge can exist. Similarly, on A, the graph L2d \ T(N)d contains two disjoint inﬁnite open clusters, separated physically by inﬁnite open paths of L2 \ T(N). The whole lattice L2 contains (almost surely) a unique inﬁnite open cluster, and it follows that there exists (almost surely on A) an open connection π of L2 between the fore-mentioned inﬁnite open clusters. By the geometry of the situation (see Figure 6.5), this connection forms a barrier to possible open connections of the dual joining the two inﬁnite open dual clusters. Therefore, almost surely on A, the dual lattice contains two or more inﬁnite open clusters. Since the latter event has probability 0, it follows that φpb,q(A) = 0 in contradiction of the inequality φpb,q(A) ≥ 21. The initial hypothesis that θ0(p,q) > 0 is therefore incorrect, and the proof is complete. (b) By part (a), θ1(p,q) = 0 for p < psd(q), whence, by Theorem 5.33(a), |Rp,q| = |Wp,q| = 1 for p < psd(q).

![image 517](<rcm1-1_images/imageFile517.png>)

Suppose now that p > psd(q) so that, by (6.5), pd < psd(q). By part (a) and Theorem 4.63,

φ0pd,q(ed is closed) = φ1pd,q(ed is closed), e ∈ E2, and by Theorem 6.13,

![image 518](<rcm1-1_images/imageFile518.png>)

![image 519](<rcm1-1_images/imageFile519.png>)

φpb,q(e is open) = φ1p−d,bq(ed is closed), b = 0,1.

![image 520](<rcm1-1_images/imageFile520.png>)

Therefore, φp0,q(e is open) = φp1,q(e is open), and the claim follows by Theorem 4.63.

ProofofTheorem6.18. Underthegivenhypothesis, pc(q) = pc(q). Supposethat psd(q) < pc(q), and that (6.19) holds with p = psd(q) and A = A(psd(q),q). By Theorem 5.33, φ0p

sd(q),q, implying (6.19) with φ0p

sd(q),q = φ1p

sd(q),q replaced by φ1p

sd(q),q.

If, for illustration, A < 21, then, by a consideration of the left endvertex of a crossing of S(n),

![image 521](<rcm1-1_images/imageFile521.png>)

1 2

A n + 1

(6.27) φ0psd(q),q(LR(n)) = φ1psd(q),q(LR(n)) < (n + 1)

<

,

![image 522](<rcm1-1_images/imageFile522.png>)

![image 523](<rcm1-1_images/imageFile523.png>)

in contradiction of Theorem 6.14. Therefore psd(q) = pc(q). More generally, by Theorem 5.60, φ0p

sd(q),q(0 ↔ ∂ (n)) decays exponentially as n → ∞. Exponential decay holds for φ1p

sd(q),q also, as above, and (6.27) follows for large n. Therefore, psd(q) = pc(q) as claimed.

142 In Two Dimensions [6.2]

We precede the proof of Theorem 6.20 with a lemma.

(6.28) Lemma. Let q ∈ [1,∞), and let p and pd satisfy (6.5). With C the open cluster at the origin and b ∈ {0,1},

if φpbd,q(rad(C)) < ∞ then θ1−b(p,q) > 0. In particular, pc(q) = psd(q) under the condition:

φp0,q(rad(C)) < ∞, p < psd(q). Proof4. Let  (n) = [−n,n]2, and let 1 ≤ r < t < ∞. By Theorem 6.13,

t−1

φp1−,qb ∂ (r) ↔/ ∂ (t) = φbpd,q

As(r,t) ,

![image 524](<rcm1-1_images/imageFile524.png>)

s=r

where As(r,t) is the event that (s + 21, 12) belongs to an open circuit of the dual, lyingin  (t)d\ (r)d andhaving (r)in itsinterior. By thetranslation-invariance of random-cluster measures, Theorem 4.19(b),

![image 525](<rcm1-1_images/imageFile525.png>)

![image 526](<rcm1-1_images/imageFile526.png>)

t−1

φbpd,q rad(Cd) ≥ r + s ,

φp1−,qb ∂ (r) ↔/ ∂ (t) ≤

![image 527](<rcm1-1_images/imageFile527.png>)

s=r

where Cd is the open cluster at the origin of the dual lattice. Letting t → ∞,

∞

(6.29) φp1−,qb ∂ (r) ↔/ ∞ ≤

φpbd,q rad(C) ≥ r + s .

s=r

Suppose that φpbd,q(rad(C)) < ∞, and pick R such that

∞

φpbd,q rad(C) ≥ s < 1.

s=2R

By (6.29), φp1−,qb(∂ (R) ↔/ ∞) < 1, whence θ1−b(p,q) > 0 as required.

Proof of Theorem 6.20. Let q ∈ [2,∞) and b ∈ {0,1}. By the forthcoming Theorem 6.30, φp1d,q(rad(C)) < ∞ when pd < psd(q − 1). By Lemma 6.28, θ0(p,q) > 0 whenever

√q 1 − q−1 +

![image 528](<rcm1-1_images/imageFile528.png>)

p > psd(q − 1) d =

.

√q

![image 529](<rcm1-1_images/imageFile529.png>)

![image 530](<rcm1-1_images/imageFile530.png>)

![image 531](<rcm1-1_images/imageFile531.png>)

![image 532](<rcm1-1_images/imageFile532.png>)

4An alternative proof appears in [141]. See also [314].

[6.3] Exponential decay 143

6.3 Exponential decay

A valuable consequence of the comparison methods developed in [15] is the exponential decay of connectivity functions when q ∈ [2,∞) and

√q − 1 1 +

![image 533](<rcm1-1_images/imageFile533.png>)

p < psd(q − 1) =

√q − 1

.

![image 534](<rcm1-1_images/imageFile534.png>)

![image 535](<rcm1-1_images/imageFile535.png>)

(6.30) Theorem (Exponential decay) [15]. Let q ∈ [2,∞), and consider the random-cluster model on the box  (n) = [−n,n]2. There exists α = α(p,q) satisfying α(p,q) > 0 when p < psd(q − 1) such that

φ (1 n),p,q(0 ↔ ∂ (n)) ≤ e−αn, n ≥ 1. By stochastic ordering,

φ (1 n),p,q(0 ↔ ∂ (m)) ≤ φ (1 m),p,q(0 ↔ ∂ (m)), m ≤ n, and therefore, on taking the limit as n → ∞,

φp1,q(0 ↔ ∂ (m)) ≤ e−αm, p < psd(q − 1), q ≥ 2, m ≥ 1, by the above theorem. In summary,

psd(q − 1) ≤ pc(q) ≤ psd(q), q ≥ 2,

where pc(q) is the threshold for exponential decay, see (5.65) and (5.67). We recall the conjecture that pc(q) = pc(q).

Proof. We use the comparison between the random-cluster model and the Ising modelwith externalﬁeld, as describedin Section 3.7. Considerthe wired randomcluster measure on a box with q ∈ [2,∞). By Theorem 3.79 and the note following (3.83), the set of vertices that are joined to ∂  by open paths is stochastically smaller than the set of + spins in the Ising model on with + boundary conditions and parameters β′, h′ satisfying (3.80). The maximum vertex degree of L2 is = 4 and, by (3.82),

q − 2

![image 536](<rcm1-1_images/imageFile536.png>)

eβ4 =

√q − 1 − 1 = 1 + q − 1, so that

![image 537](<rcm1-1_images/imageFile537.png>)

![image 538](<rcm1-1_images/imageFile538.png>)

√q − 1 1 +

![image 539](<rcm1-1_images/imageFile539.png>)

1 − e−β4 =

√q − 1 = psd(q − 1). Let p = 1 − e−β < psd(q − 1). By (3.83), h′ < 0. By stochastic domination, (6.31) φ ,1 p,q(0 ↔ ∂ ) ≤ π ,β+ ′,h′(0 ↔+ ∂ ),

![image 540](<rcm1-1_images/imageFile540.png>)

![image 541](<rcm1-1_images/imageFile541.png>)

where {0 ↔+ ∂ } is the event that there exists a path of joining 0 to some vertex of ∂  all of whose vertices have spin +1. By results of [88, 182] (see the discussion in [15, p. 438]), the right side of (6.31) decays exponentially in the shortest side-length of .

6.4 First-order phase transition

The q = 1 case of the random-cluster measure is the percolation model, with associated product measure φp = φp,1. One of the outstanding problems for percolation isto prove the continuityforall d of the percolation probability θ(p) = φp(0 ↔ ∞) at the critical point pc = pc(1), see [154, Section 8.3]. By a standard argument of semi-continuity, this amounts to proving that θ(pc) = 0, which is to say that there exists (almost surely) no inﬁnite open cluster at the critical point. The situation for general q is quite different. It turns out that θ1(pc(q),q) > 0 for all large q.

(6.32) Conjecture. Consider the d-dimensional lattice Ld where d ≥ 2. (a) θ0(pc(q),q) = 0 for q ∈ [1,∞). (b) There exists Q = Q(d) ∈ (1,∞) such that

θ1(pc(q),q) = 0 if q < Q, > 0 if q > Q.

In the vernacular of statistical physics, we speak of the phase transition as being of second order if θ1(pc(q),q) = 0, and of ﬁrst order otherwise. Thus the random-cluster transition is expected to be of ﬁrst order if and only if q is sufﬁcientlylarge. Therearetwoissues: toprovetheexistenceofa‘sharptransition in q’, and to calculate the ‘critical value’ Q(d) of q. The ﬁrst problem is strangely difﬁcult. It is natural to seek some monotonicity, perhaps of the function f (q) = θ1(pc(q),q), but this has proved elusive even in two dimensions. As for the value of Q(d), it is believed5 that Q(d) is non-increasing in d and satisﬁes

(6.33) Q(d) =

4 if d = 2, 2 if d ≥ 6.

Aﬁrst-ordertransitionischaracterizedbyadiscontinuityintheorder-parameter θ1(p,q). Two further indicators of ﬁrst-order transition are: discontinuity of the edge-densities hb(p,q) = φpb,q(e is open), b = 0,1, and the existence of a socalled ‘non-vanishing mass gap’. The edge-densities are sometimes termed the ‘energy’ functions, since they arise thus in the Potts model.

The term ‘mass gap’ arises in the study of the exponential decay of correlations in the subcritical phase, in the limit as p ↑ pc(q). Of the various ways of expressing this, we choose to work with the probability φp0,q(0 ↔ ∂ (n)), where  (n) = [−n,n]d. Recall from Theorem 5.45 that there exists a function ψ = ψ(p,q) such that

φp0,q(0 ↔ ∂ (n)) ≈ e−nψ as n → ∞,

![image 542](<rcm1-1_images/imageFile542.png>)

5See [26, 324] and the footnote on page 183.

[6.4] First-order phase transition 145

where ‘≈’ denotes logarithmic asymptotics. Clearly, ψ(p,q) is a non-increasing function of p, and ψ(p,q) = 0 if θ0(p,q) > 0. It is believed that ψ(p,q) > 0 if p < pc(q). We speak of the limit

µ(q) = lim

ψ(p,q)

p↑pc(q)

as the mass gap. It is believed that the transition is of ﬁrst order if and only if there is a non-vanishing mass gap, that is, if µ(q) > 0.

(6.34) Conjecture. Consider the d-dimensional lattice Ld where d ≥ 2. Then

µ(q) = 0 if q < Q(d),

> 0 if q > Q(d), where Q(d) is given in Conjecture 6.32.

The ﬁrst proof of ﬁrst-order phase transition for the Potts model with large q was discovered by Kotecky and Shlosman, [220].´ Amongst the later proofs is that of [225], and this is best formulated in the language of the random-cluster model, [224]. It takes a very simple form in the special case d = 2, as shown in this section. The general case of d ≥ 2 is treated in Chapter 7.

There follows a reminder concerning the number an of self-avoiding walks on

L2 beginning at the origin. It is standard, [244], that an1/n → κ as n → ∞, for some constant κ termed the connective constant of the lattice. Let

4

Q = 2 1 κ + κ2 − 4

![image 543](<rcm1-1_images/imageFile543.png>)

. We have that 2.620 < κ < 2.696, see [302], whence 21.61 < Q < 25.72. Let ψ(q) =

![image 544](<rcm1-1_images/imageFile544.png>)

√q)4 qκ4

(1 +

1 24

![image 545](<rcm1-1_images/imageFile545.png>)

log

,

![image 546](<rcm1-1_images/imageFile546.png>)

![image 547](<rcm1-1_images/imageFile547.png>)

noting that ψ(q) > 0 if and only if q > Q. (6.35) Theorem (Discontinuous phase transition when d = 2) [153, 225]. Consider the square lattice L2, and let q > Q.

√q/(1 +

√q).

(a) Critical point. The critical point is given by pc(q) =

![image 548](<rcm1-1_images/imageFile548.png>)

![image 549](<rcm1-1_images/imageFile549.png>)

(b) Discontinuous transition. We have that θ1(pc(q),q) > 0. (c) Non-vanishing mass gap. For any ψ < ψ(q) and all large n,

φ0pc(q),q(0 ↔ ∂ (n)) ≤ e−nψ. (d) Discontinuous edge-densities. The functions hb(p,q) = φpb,q(e is open), b = 0,1, are discontinuous functions of p at p = pc(q).

Similar conclusions may be obtained for general d ≥ 2 when q is sufﬁciently large (q > Q(d) for suitable Q(d)). Whereas, in the case d = 2, planar duality provides an especially simple proof, the proof for general d utilizes nested

sequences of surfaces of Rd and requires a control of the effective boundary conditions within the surfaces. See Section 7.5.

By Theorem 6.17(b), whenever q is such that the phase transition is of ﬁrst order, then necessarily pc(q) = psd(q).

The idea of the proof of the theorem is as follows. There is a partial order on circuits Ŵ of L2 given by: Ŵ ≤ Ŵ′ if the bounded component of R2 \ Ŵ is a subset of that of R2 \ Ŵ′. We work at the self-dual point p = psd(q), and with the box  (n) with wired boundary conditions. Roughly speaking, an ‘outer contour’ is deﬁned to be a circuit Ŵ of the dual graph  (n)d all of whose edges are open in the dual (that is, they traverse closed edges in the primal graph  (n)), and that is maximal with this property. Using self-duality, one may show that

|Ŵ|/4

1 q

q (1 +

φ (1 n),psd(q),q(Ŵ is an outer circuit) ≤

√q)4

,

![image 550](<rcm1-1_images/imageFile550.png>)

![image 551](<rcm1-1_images/imageFile551.png>)

![image 552](<rcm1-1_images/imageFile552.png>)

for any given circuit Ŵ of  (n)d. Combined with a circuit-counting argument of Peierls-type involving the connective constant, this estimate implies after a little work the claims of Theorem 6.35. The idea of the proof appeared in [225] in the context of Potts models, and the random-cluster formulation may be found in [153]; see also Section 7.5 of the current work.

Proof of Theorem 6.35. This proof carries a health warning. The use of twodimensionaldualityraisescertainissueswhicharetedioustoresolvewithcomplete rigour, and we choose not to do so here. Such issues may be resolved either by the methods of [210, p. 386] when d = 2, or by those expounded in Section 7.2 for general d ≥ 2. Let n ≥ 1, let =  (n) = [−n,n]2, and let d = [−n,n−1]2+(21, 21) be those verticesof the dualof that lie inside (thatis, we omitthedualvertexintheinﬁnitefaceof ). Weshallworkwith‘wired’boundary conditions on , and we let ω ∈ = {0,1}E . The exterior (respectively, interior) of a given circuit Ŵ of either L2 or its dual L2d is deﬁned to be the unbounded (respectively, bounded) component of R2 \ Ŵ. A circuit Ŵ of d is called an outer circuit of a conﬁguration ω ∈ if the following hold:

![image 553](<rcm1-1_images/imageFile553.png>)

![image 554](<rcm1-1_images/imageFile554.png>)

(a) all edges of Ŵ are open in the dual conﬁguration ωd, which is to say that

they traverse closed edges of , (b) the origin of L2 is in the interior of Ŵ, (c) every vertex of lying in the exterior of Ŵ, but within distance of 1/

√2 of some vertex of Ŵ, belongs to the same component of ω.

![image 555](<rcm1-1_images/imageFile555.png>)

See Figure 6.6 for an illustration of the meaning of ‘outer circuit’. Each circuit Ŵ of d partitions the set E of edges of into three sets, namely

E = {e ∈ E : e lies in the exterior of Ŵ},

I = {e ∈ E : e lies in the interior of Ŵ}, Ŵ′ = {e ∈ E : ed ∈ Ŵ}.

[6.4] First-order phase transition 149

√q). By (6.36)–(6.40) and (6.11),

√q/(1 +

Set p = psd(q) =

![image 556](<rcm1-1_images/imageFile556.png>)

![image 557](<rcm1-1_images/imageFile557.png>)

Z1E ZI Z1

φ ,1 p,q(OC(Ŵ)) = (1 − p)|Ŵ|

(6.41)

![image 558](<rcm1-1_images/imageFile558.png>)

= (1 − p)|Ŵ|qm−1−21|I| Z1E Z1Id

![image 559](<rcm1-1_images/imageFile559.png>)

![image 560](<rcm1-1_images/imageFile560.png>)

Z1 ≤ (1 − p)|Ŵ|qm−1−21|I|.

![image 561](<rcm1-1_images/imageFile561.png>)

Since each vertex of (inside Ŵ) has degree 4,

4m = 2|I| + |Ŵ|, whence

1 q

(6.42) φ ,1 p,q(OC(Ŵ)) ≤ (1 − p)|Ŵ|q 41|Ŵ|−1 =

![image 562](<rcm1-1_images/imageFile562.png>)

![image 563](<rcm1-1_images/imageFile563.png>)

q (1 +

√q)4

![image 564](<rcm1-1_images/imageFile564.png>)

![image 565](<rcm1-1_images/imageFile565.png>)

|Ŵ|/4

.

The number of dual circuits of having length l and containing the origin in their interior is no greater than lal, where al is the number of self-avoiding walks of L2 beginning at the origin with length l. Therefore,

∞

l/4

q (1 +

lal q

φ ,1 p,q(OC(Ŵ)) ≤

√q)4

.

![image 566](<rcm1-1_images/imageFile566.png>)

![image 567](<rcm1-1_images/imageFile567.png>)

![image 568](<rcm1-1_images/imageFile568.png>)

l=4

Ŵ

Nowl−1 logal → κ asl → ∞, whereκ is theconnectiveconstantofL2. Suppose that q > Q, so that qκ4 < (1 +

√q)4. There exists A(q) < ∞ such that

![image 569](<rcm1-1_images/imageFile569.png>)

Ŵ

φ ,1 p,q(OC(Ŵ)) < A(q), n ≥ 1.

If A(q) < 1 (which holdsforsufﬁciently large q) then, by the assumption of wired boundary conditions,

φ ,1 p,q(0 ↔ ∂ ) = φ ,1 p,q(OC(Ŵ) occurs for no Ŵ) ≥ 1 − A(q) > 0.

On letting n → ∞, we obtain by Proposition 5.11 that θ1(p,q) > 0 when p =

√q/(1 +

√q). By Theorem 6.17(a), this implies parts (a) and (b) of the theorem when q is sufﬁciently large.

![image 570](<rcm1-1_images/imageFile570.png>)

![image 571](<rcm1-1_images/imageFile571.png>)

For general q > Q, we have only that A(q) < ∞. In this case, we ﬁnd N < n such that

φ ,1 p,q(OC(Ŵ)) < 21,

![image 572](<rcm1-1_images/imageFile572.png>)

Ŵ: Ŵ outside  (N)

c Springer-Verlag 2006

152 In Two Dimensions [6.5]

6.5 General lattices in two dimensions

Planar duality is an important technique in the study of interacting systems on a two-dimensional lattice L, but it is no panacea. It may be summarized in the two statements: the external boundary of a bounded connected subgraph of L is topologically one-dimensional, and the statistical mechanics of the boundary may be studied via an appropriate stochastic model on a certain dual lattice Ld. Duality provides a relation between a primal model on L and a dual model on Ld. In situations in which the dual model is related to the primal, or to some other known system, one may sometimes obtain exact results. The exact calculations of criticalprobabilitiesofpercolationmodelsonthesquare,triangular,andhexagonal lattices are examples of this, see [154, Chapter 11]. Individuals less burdened by the pulse for mathematical rigour have exploited duality to obtain exact but nonrigorous predictions for other two-dimensionalprocesses (see, for example, [26]), of which a major example is the conjecture that pc(q) =

√q) for the random-cluster model on L2. Such predictions are often beautiful and usually provocative to mathematicians.

√q/(1 +

![image 573](<rcm1-1_images/imageFile573.png>)

![image 574](<rcm1-1_images/imageFile574.png>)

Weshallnotexploredualityingeneralhere,notingonlyinpassingtheexistence of many open problems of signiﬁcance in extending known results for, say, the square lattice to general primal/dual pairs. We discuss instead two speciﬁc issues relating, in turn, to the critical points of a general primal/dual pair, and in the next section to exact calculations for the triangular and hexagonal lattices.

Here is ourdeﬁnition of a lattice, [154, Section 12.1]. A lattice in d dimensions is a connected loopless graph L, with bounded vertex degrees, that is embedded in Rd in such a way that:

(a) the translations x  → x + e are automorphisms of L for each unit vector e

parallel to a coordinate axis, (b) all edges are of non-zero length, and (c) every compact subset of Rd intersects only ﬁnitely many edges.

Let L = (V,E) be a planar two-dimensional lattice, and let Ld be its dual lattice, deﬁned as in Section 6.1. We shall require some further symmetries of L, namely that:

(d) the reﬂection mappings ρh,ρv : R2 → R2 given by

ρh(x, y) = (−x, y), ρv(x, y) = (x,−y), (x, y) ∈ R2, are automorphisms of L.

Let p ∈ [0,1] and q ∈ [1,∞). Underthe aboveconditions, the random-cluster measures φLb ,p,q exist for b = 0,1, and are invariant under horizontal and vertical translations, andunderhorizontaland verticalaxis-reﬂection. Theyare in addition ergodic with respect to horizontal and vertical translation (separately), and they are positively associated. Such facts may be proved in exactly the same manner as were the corresponding statements for the hypercubic lattice Ld in Chapter 4.

Let pc(q,L) denote the critical value of the random-cluster model on L.

[6.5] General lattices in two dimensions 153

(6.47) Theorem. The critical points pc(q,L), pc(q,Ld) satisfy the inequality (6.48) pc(q,L) ≥ pc(q,Ld) d.

Proof. Let p > pc(q,L), so that φL1 ,p,q(0 ↔ ∞) > 0. The argumentsleading to the mainresult of[130]may be adaptedto the currentsetting6 to showthatall open clusters in the duallattice Ld are almost-surelyﬁnite. Therefore, pd ≤ pc(q,Ld), whence p ≥ pc(q,Ld) d as required.

Equality may be conjectured in (6.48). Suppose that L and Ld are isomorphic or, weaker, that pc(q,L) = pc(q,Ld). Inequality (6.48) implies then that pc(q,L) ≥ psd(q) (see Theorem 6.17(a) for the case of the square lattice). If (6.48) were to hold with equality, we would obtain that pc(q,L) = psd(q).

Theorem6.47may be used to provethe uniquenessofrandom-clustermeasures for p  = pc(q,L). Some further notation must ﬁrst be introduced to deal with case when L is not edge-transitive7. Let S = [0,1)2 ⊆ R2. Let IS be the set of edges of L with both endvertices in S, and ES the set of edges with exactly one endvertex in S. Let

(6.49) NS(ω) =

ω(e) +

e∈ES

e∈IS

and deﬁne the edge-density by

1 2ω(e), ω ∈ = {0,1}E,

![image 575](<rcm1-1_images/imageFile575.png>)

(6.50) hbL(p,q) =

1 NS(1)

φLb ,p,q(NS), b = 0,1.

![image 576](<rcm1-1_images/imageFile576.png>)

If L is edge-transitive, it is easily seen that hbL(p,q) is simply the probability under φL1 ,p,q that a given edge is open.

(6.51) Theorem. Let L, Ld be a primal/dual pair of planar lattices in two dimensions and suppose L satisﬁes (a)–(d) above. Let p ∈ [0,1] and q ∈ [1,∞), and assume that p  = pc(q,L).

- (i) The edge-density hbL(x,q) is a continuous function of x at the point x = p, for b = 0,1.
- (ii) It is the case that h0L(p,q) = h1L(p,q). (iii) There is a unique random-cluster measure on L with parameters p and q, that is, |Wp,q(L)| = |Rp,q(L)| = 1, in the natural notation.


In the notationof Theorem4.63, we have that Dq ⊆ {pc(q,L)}. In particular8, if there exists a ﬁrst-order phase transition at some value p, then necessarily

![image 577](<rcm1-1_images/imageFile577.png>)

- 6Paper [130] treats vertex-models on Z2 governed by measures with certain properties of translation/rotation-invariance, ergodicity, and positive association. The arguments are however more general and apply also to edge-models on planar graphs with corresponding properties.
- 7A graph G = (V, E) is called edge-transitive if: for every pair e, f ∈ E, there exists an automorphism of G mapping e to f . See Sections 3.3 and 10.12 for a related notion of transitivity.
- 8Related matters for Potts models are discussed in [47].


154 In Two Dimensions [6.6]

p = pc(q,L). As in Theorem 5.16, the percolation probabilities θLb (·,q) = φLb ,p,q(0 ↔ ∞), b = 0,1, are continuous9 except possibly at the value p = pc(q,L).

Proof. (i) For p < pc(q,L), this follows as in Theorems 4.63 and 5.33(a). When p > pc(q,L), we have from (6.48) that pd < pc(q,Ld). As in Theorem 6.13,

hbL(p,q) + h1L−db(pd,q) = 1.

By part (i) applied to the dual lattice Ld, each hbL(x,q) is continuous at the point x = pd. Parts (ii) and (iii) follow as in Theorem 4.63, see also the proof of Theorem 6.17(b).

6.6 Square, triangular, and hexagonal lattices

There is a host of exact but non-rigorous ‘results’ for two-dimensional models which, while widely accepted by physicists, continue to be subjected to mathematical investigations. Some of these claims have been made rigorous and, in so doing, mathematicians have discovered new structures of beauty and complexity. The outstanding contemporary example of new structure provoked by physics is the theory of stochastic Lowner¨ evolutions (SLE). This has had considerable impact on percolation, Brownian motion, and on other systems with a property of conformal invariance; see Section 6.7 for a short account of SLE in the randomcluster context.

Amongst ‘exact’ but non-rigorous results for the random-cluster model is the claim that, for the square lattice, pc(q) =

√q). Baxter’s 1982 book [26] remains a good source for this and related statements, usually in the context of Potts models but extendable to random-cluster models with q ∈ [1,∞). Such statements are achieved typically by following a sequence of transformations between models, arriving thus at a ‘soluble ice-type model’ on a new graph termed the ‘medial graph’. It has proved difﬁcult to ascertain whether such methods are entirely rigorous, since they involve chains of argument which may seem individually innocuous but which omit signiﬁcant analytical details. We attempt no more here than brief accounts of some of the conclusions together with a partial mathematical commentary.

√q/(1 +

![image 578](<rcm1-1_images/imageFile578.png>)

![image 579](<rcm1-1_images/imageFile579.png>)

Considerthesquarelattice L2. Insteadofworkingwith a singleedge-parameter p, we allow greater generality by associating with each horizontal (respectively, vertical) edge the parameter ph (respectively, pv), and we write p = (ph, pv). It will be convenient as in (6.7)–(6.8) to work instead with the parameters x = (xh, xv) given by

q−21 ph 1 − ph

q−21 pv 1 − pv

![image 580](<rcm1-1_images/imageFile580.png>)

![image 581](<rcm1-1_images/imageFile581.png>)

xh =

, xv =

,

![image 582](<rcm1-1_images/imageFile582.png>)

![image 583](<rcm1-1_images/imageFile583.png>)

![image 584](<rcm1-1_images/imageFile584.png>)

9This may also be proved directly for a primal/dual pair, using the arguments of Theorems 5.33 and 6.47.

and their dual values xh,d, xv,d satisfying xhxh,d = 1, xvxv,d = 1.

Write φGb ,x,q for a corresponding random-cluster measure on a graph G, and moreover

φ ,b x,q, θb(x,q) = φxb,q(0 ↔ ∞).

φxb,q = lim

↑L2

ThedualitymapofSection6.1mapsa random-clustermodelon L2 withparam-

eterx = (xh, xv)toarandom-clustermodelon L2dwithparameter xd = (xv,d, xh,d). The primal and dual models have the same parameters whenever xh = xv,d and xv = xh,d, which is to say that

(6.52) xhxv = 1, and we refer to the model as ‘self-dual’ if (6.52) holds. The following conjecture generalizes Conjecture 6.15. (6.53) Conjecture. Let xh, xv ∈ (0,∞) and q ∈ [1,∞). For b = 0,1,

θb(x,q) = 0 if xhxv < 1, > 0 if xhxv > 1.

The proof in the case of percolation (when q = 1) may be found at [154, Thm 11.115]. Partial progress in the direction of the general conjecture is provided by the next theorem.

(6.54) Theorem. Let xh, xv ∈ (0,∞) and q ∈ [1,∞). Then

θ0(x,q) = 0 if xhxv ≤ 1.

Proof. Let n ≥ 1, and let

D(n) = y ∈ Z2 : |y1| + |y2 − 12| ≤ n + 21

![image 585](<rcm1-1_images/imageFile585.png>)

![image 586](<rcm1-1_images/imageFile586.png>)

be the ‘offset diamond’ illustrated in Figure 6.10. The proof follows that of Theorem 6.17(a), but working with D(n) in place of T(n). We omit the details, noting only that the proof uses the 0/1-inﬁnite-cluster property of the measures φxb,q, and the symmetry of the model under reﬂection in both the vertical axis of R2 and the line {(y1, 21) : y1 ∈ R}.

![image 587](<rcm1-1_images/imageFile587.png>)

Here are two exact but non-rigorous claims for this model. We recall from Theorem 4.58 the ‘pressure’ function G given in the current context as

G(x,q) = lim

↑Z2

1 |E |

logY (p,q) , (x,q) ∈ (0,∞)2 × [1,∞),

![image 588](<rcm1-1_images/imageFile588.png>)

(ii) When q = 4, let τ = x/(1 + x), and then

e−y y

∞

sechy sinh(2τy)dy.

ψ(x) =

![image 589](<rcm1-1_images/imageFile589.png>)

0

(iii) When q > 4, choose λ > 0 and β ∈ (0,λ) by

sinh β sinh(λ − β)

√q, x =

2 cosh λ =

![image 590](<rcm1-1_images/imageFile590.png>)

,

![image 591](<rcm1-1_images/imageFile591.png>)

and then

∞

e−nλ n

sech(nλ)sinh(2nβ).

ψ(x) = β +

![image 592](<rcm1-1_images/imageFile592.png>)

n=1

Our second exact asymptotic relation concernsthe mean density of open edges,

hb(p,q) = lim

↑Z2

1 |E |

φ ,b p,q(|η|) , b = 0,1.

![image 593](<rcm1-1_images/imageFile593.png>)

By the translation-invariance of the inﬁnite-volume measures, the mean numbers of open horizontal and vertical edges satisfy

2 |E |

φ ,b p,q(|ηh|) → hbh(p,q) = φpb,q(eh is open), 2 |E |

![image 594](<rcm1-1_images/imageFile594.png>)

(6.56)

φ ,b p,q(|ηv|) → hbv(p,q) = φpb,q(ev is open),

![image 595](<rcm1-1_images/imageFile595.png>)

as ↑ Z2, where eh (respectively, ev) is a representative horizontal (respectively, vertical) edge of L2. Therefore,

hb(p,q) = 21 hbh(p,q) + hbv(p,q) .

![image 596](<rcm1-1_images/imageFile596.png>)

As before, except possibly on the self-dual curve xhxv = 1, the functions hbh(·,q), hbv(·,q) are continuous and h0h/v(p,q) = h1h/v(p,q). [We write h/v to indicate that either possibility, chosen consistently within a given equation, is valid.] In addition, as in Proposition4.28, the h0h/v(·,q) are left-continuousand the h1h/v(·,q) right-continuous everywhere, in that

h0h/v(p,q) = lim p′↑p

h0h/v(p′,q), h1h/v(p,q) = lim p′↓p

h1h/v(p′,q), p ∈ (0,1)2.

By duality as in Theorem 6.13,

(6.57) h0h/v(p,q) + h1v/h(pd,q) = 1, p ∈ (0,1)2.

being similar. Assume then that (b) holds, and suppose for deﬁniteness that the conﬁguration ω is such that: A and B are joined off T, but C is joined off T to neither A nor B. By Theorem 3.1, the probabilities of connections internal to T are given as follows:

(6.65)

where

PωT (A ↔ B and B ↔/ C in T) =

PωT (A ↔/ B and B ↔ C in T) =

PωT (A ↔/ B and A ↔ C in T) =

PωT (A ↔ B ↔ C in T) =

1 Y

y1q2,

![image 597](<rcm1-1_images/imageFile597.png>)

1 Y

y2q,

![image 598](<rcm1-1_images/imageFile598.png>)

1 Y

y3q,

![image 599](<rcm1-1_images/imageFile599.png>)

1 Y

(y1y2y3 + y1y2 + y2y3 + y3y1)q,

![image 600](<rcm1-1_images/imageFile600.png>)

(6.66) Y = (y1y2y3 + y1y2 + y2y3 + y3y1 + y2 + y3)q + (1 + y1)q2.

Note that the eventsin question concern the existence (ornot) of open paths within T only. The remaining term PωT (A ↔/ B ↔/ C in T) is given by the fact that the sum of the probabilities of all such conﬁgurations on T equals 1.

The corresponding probabilities for connections internal to S are:

(6.67)

PωS(A ↔ B and B ↔/ C in S) =

PωS(A ↔/ B and B ↔ C in S) =

PωS(A ↔/ B and A ↔ C in S) =

PωS(A ↔ B ↔ C in S) =

where (6.68) Y′ = (y′

1y′

2y′

3)q + (y′

1y′

2 + y′

1y′

3 + y′

2y′

1 Y′

y′

2y′

![image 601](<rcm1-1_images/imageFile601.png>)

1 Y′

y′

1y′

![image 602](<rcm1-1_images/imageFile602.png>)

1 Y′

y1′ y2′q,

![image 603](<rcm1-1_images/imageFile603.png>)

1 Y′

1y′

y′

![image 604](<rcm1-1_images/imageFile604.png>)

1 + y′

3 + y′

3q2,

3q,

2y′

3q,

3)q2 + q3.

2 + y′

It is left to the reader to check that, under (6.60)–(6.61), the probabilities in (6.65) and (6.67) are equal. Similar computations are valid in cases (a) and (c) also, and it follows that, in loose terms, the replacement of T by S is ‘invisible’ to connections elsewhere in the graph G.

Lemma 6.64 allows us to replace one grey triangle of G by a star. This process may be iterated until every grey triangle of G has been thus replaced. If G is itself a union of grey triangles, then the resulting graph is a subgraph of the hexagonal lattice H. By working on a square region of T and passing to the

162 In Two Dimensions [6.6]

limit as ↑ T, we ﬁnd in particular that connections on T have the same probabilities as connectionson H so long as the edge-parameterson T satisfy (6.60) and the corresponding parameters on H satisfy (6.61). In particular the percolation probabilities are the same. We now make the last statement more speciﬁc.

Write ET (respectively, EH) for the edge-set of T (respectively, H). Let p = (pe : e ∈ ET) ∈ (0,1)E

T, and let ye = pe/(1 − pe). We speak of p as being of type γ if, for every grey triangle T, the three parameters y1, y2, y3 of the edges of T satisfy ψT(y1, y2, y3) = γ. Suppose that p is of type 0, as in (6.60). Applying the star–triangle transformation to every grey triangle of T, we obtain a copy H of the hexagonal lattice, and we choose the parameters p′ = (pe′ : e ∈ EH) of edges of this lattice in such a way that (6.61) holds. By the above discussion, the percolation probabilities θTb and θHb satisfy

(6.69) θTb(p,q) = θHb(p′,q), b = 0,1, whenever q ∈ [1,∞).

Alabelledlattice isa latticeLtogetherwith arealvector pindexedbytheedgeset of L. An automorphism of a labelled lattice (L,p) is a graph automorphism τ of L such that pτ(e) = pe for every edge e.

Equation (6.69) leads to a proposal for the so-called ‘critical surfaces’ of the triangular and hexagonal lattices. The crude argument is as follows. Suppose that p, p′ are as above. If θT0(p,q) > 0 then, by (6.69), θH0(p′,q) > 0 also. If we accept a picture of an inﬁnite primal ocean of H encompassing bounded islands of its dual, then it follows that θH1d((p′)d,q) = 0. If the initial labelled lattice (T,p) has a sufﬁciently large automorphism group then it may, by (6.61), be the case that (Hd,(p′)d) is isomorphic to (T,p), in which case

0 = θH1d((p′)d,q) = θT1(p,q). This is a contradiction, and we deduce that θT0(p,q) = 0 whenever p is of type 0.

On the other hand, some readers may be able to convince themselves that there should exist no non-empty interval (α,β) ⊆ R such that: neither T nor its dual lattice possesses an inﬁnite cluster whenever the type of p lies in (α,β). One arrives via these non-rigorous arguments at the (unproven) statement that

(6.70) θT0(p,q) = 0 if p is of non-positive type,

> 0 if p is of strictly positive type, with a similar conjecture for the hexagonal lattice.

Let p1, p2, p3 ∈ (0,1)and let yi = pi/(1− pi). We restrictthe discussion now to the situation in which every grey triangle of T has three edges with parameters p1, p2, p3, in some order. The corresponding process on H has parameters pi′ where the y′

i = p′

i/(1 − p′

i) satisfy (6.61). The assertions above motivate the proposals that:

(6.71)

T has critical surface y1y2y3 + y1y2 + y2y3 + y3y1 − q = 0, H has critical surface y′

3) − q2 = 0,

1y′

2y′

3 − q(y′

1 + y′

2 + y′

in the sense that

θT0(p,q) = 0 if ψT(y) ≤ 0, > 0 if ψT(y) > 0,

with a similar statement for H. It is not known how to make (6.71) rigorous, neither is it even accepted that the above statements are true in generality, since no explicit assumption has been made about the automorphismgroups of the labelled lattices in question.

We move now to the special case of the homogeneous random-cluster model on T, with constant edge-parameter pe = p for every edge e. One part of the above discussion may be made rigorous, as follows.

#### (6.72) Theorem. Let q ∈ [1,∞).

(a) Consider the random-cluster model on the triangular lattice T, and let p be

such that y = p/(1 − p) satisﬁes y3 + 3y2 − q = 0. Then θT0(p,q) = 0, and therefore pc(q,T) ≥ p.

(b) Considerthe random-clustermodelon the hexagonallattice H, and let p′ be

such that y = p′/(1− p′) satisﬁes y3−3qy −q2 = 0. Then θH0(p′,q) = 0, and therefore pc(q,H) ≥ p′.

Proof. This may be proved either by adapting the argument used to prove Theorems 6.17(a) and 6.54, or by following the proof of Theorem 6.47. The former approach utilizes the 0/1-inﬁnite-cluster property, and the latter approach makes use of the circuit-generation procedure pioneered in [181] and extended in [130]. Under either method, it is important that the labelled lattices be invariant under translations and possess axes of mirror-symmetry.

It is generally believed that the critical values of T and H are the values given in Theorem 6.72. To prove this, it would sufﬁce to have a reasonable upper bound for φT0,p,q(0 ↔ ∂ (n)), where  (n) = [−n,n]2. See the related Theorem 6.18 and Lemma 6.28.

We close this section with an open problem. Arguably the simplest system on the triangular lattice which possesses insufﬁcient symmetry for the above proof is thatin which everyhorizontal(respectively,vertical, diagonal)edgeofT hasedgeparameter ph (respectively, pv, pd). The ensuing labelled lattice has properties of translation-invariancebuthas no axisof mirror-symmetry. Instead, it is symmetric under reﬂections in the origin. We conjecture11 that the equivalent of Theorem 6.72 holds for this process, namely that

(6.73) θT0(p,q) = 0 if ψT(ph, pv, pd) = 0.

Indeed, one expects that the critical surface is given by ψT(ph, pv, pd) = 0. The proof of the corresponding statement for the percolation model may be found at [154, Thm 11.116].

![image 605](<rcm1-1_images/imageFile605.png>)

11Note added at reprinting: this conjecture has been veriﬁed in [327].

6.7 Stochastic L¨owner evolutions

Many exact calculations are ‘known’ for critical processes in two dimensions, but the required physical arguments have sometimes appeared in varying degrees magical or revelationary to mathematicians. The recently developed technology of stochastic Lowner¨ evolutions (SLE), discovered by Schramm [294], promises a rigorous underpinning of many such arguments in a manner consonant with modern probability theory. Roughly speaking, the theory of SLE informs us of the correctweak limit of a critical process in the limit of large spatial scales, and in addition provides a mechanism for performing calculations for the limit process.

Let U = (−∞,∞) × (0,∞) denote the upper half-plane of R2, with closure U. We view U and U as subsets of the complex plane. Consider the ordinary differential equation

![image 606](<rcm1-1_images/imageFile606.png>)

![image 607](<rcm1-1_images/imageFile607.png>)

2 gt(z) − Bκt

d dt

, z ∈ U \ {0},

gt(z) =

![image 608](<rcm1-1_images/imageFile608.png>)

![image 609](<rcm1-1_images/imageFile609.png>)

![image 610](<rcm1-1_images/imageFile610.png>)

subject to the boundary condition g0(z) = z, where t ∈ [0,∞), κ is a positive constant, and (Bt : t ≥ 0) is a standard Brownian motion. The solution exists when gt(z) is bounded away from Bκt. More speciﬁcally, for z ∈ U, let τz be the inﬁmum of all times τ such that 0 is a limit point of gs(z) − Bκs in the limit as s ↑ τ. We let

![image 611](<rcm1-1_images/imageFile611.png>)

Ht = {z ∈ U : τz > t}, Kt = {z ∈ U : τz ≤ t},

![image 612](<rcm1-1_images/imageFile612.png>)

so that Ht is open, and Kt is compact. It may now be seen that gt is a conformal homeomorphism from Ht to U.

We call (gt : t ≥ 0) a stochastic Lo¨wner evolution (SLE) with parameter κ, written SLEκ, and we call the Kt the hulls of the process. There is good reason to believe that the family K = (Kt : t ≥ 0) provides the correct scaling limit of a variety of random spatial processes, the value of κ being chosen according to the process in question. General properties of SLEκ, viewed as a function of κ, have been studied in [284, 316], and a beautiful theory has emerged. For example, the hulls K form (almost surely) a simple path if and only if κ ≤ 4. If κ > 8, then SLEκ generates (almost surely) a space-ﬁlling curve.

Schramm [294, 295] has identiﬁed the relevant value of κ for several different processes, and has indicated that percolation has scaling limit SLE6. Full rigorous proofsare not yet known even for generalpercolationmodels. For the special case of site percolation on the triangular lattice T, Smirnov [304, 305] has proved the very remarkable result that the crossing probabilities of re-scaled regions of R2 satisfy Cardy’s formula, and he has outlined a connection to a ‘full scaling limit’ and to the process SLE6. (This last statement is illustrated and partly explained in Figure 6.14.) The full scaling limit for critical percolation on T as an SLE6-based loop process was announced by Camia and Newman in [75] and the proofs may be found in [76].

explorer and the interface of the discrete Gaussian free ﬁeld have common limit SLE4, see [296, 297].

We turn now to the random-cluster model on L2 with parameters p and q. For q ∈ [1,4), it is believed as in Conjectures 6.15 and 6.32 that the percolation probability θ(p,q), viewed as a function of p, is continuous at the critical point pc(q), and furthermore that pc(q) =

√q). It seems likely that, when re-scaled in the manner similar to that of percolation, the cluster-boundaries of the model converge to a limit process of SLE type. It will remain only to specify the parameter κ of the limit in terms of q. It has been conjectured in [284] that κ = κ(q) satisﬁes

√q/(1 +

![image 613](<rcm1-1_images/imageFile613.png>)

![image 614](<rcm1-1_images/imageFile614.png>)

√q, κ ∈ (4,8).

cos(4π/κ) = −12

![image 615](<rcm1-1_images/imageFile615.png>)

![image 616](<rcm1-1_images/imageFile616.png>)

This value is consistent with the above observation that κ(1) = 6, and also with the ﬁnding of [231]that the scaling limit of the uniformspanning-treePeano curve is SLE8. We recall from Theorem 1.23 that the uniform spanning-tree measure is obtained as a limit of the random-cluster measure as p,q ↓ 0.

There are uncertainties over how this programme will develop. For a start, the theory of random-clustermodelsisnotso complete asthatof percolationandofthe uniformspanningtree. Secondly, the existenceof spatial limits is currentlyknown only in certain specialcases. The programme ishoweverambitiousandpromising, and may ultimately yield a full picture of the critical behaviour, including the numerical values of critical exponents, of random-cluster models with q ∈ [1,4), and hence of Ising/Pottsmodelsalso. There isgood reason to expectearlyprogress for the case q = 2, for which the random-cluster interface should converge to SLE16/3, and the Ising (spin) interface to SLE3, [306]. The reader is referred to [295] for a survey of open problems and conjectures concerning SLE.

## Chapter 7 Duality in Higher Dimensions

Summary. The boundaries of clusters in d dimensions are (topologically) (d − 1)-dimensional and, in their study, one encounters new geometrical difﬁculties when d ≥ 3. By representing the random-cluster model as a sequence of nested contours with alternately wired and free boundary conditions, one arrives at the proof that the phase transition is discontinuous for sufﬁciently large q. There is a random-cluster analysis of non-translationinvariant states of Dobrushin-type when d ≥ 3, q ∈ [1, ∞), and p is sufﬁciently large.

7.1 Surfaces and plaquettes

Dualityisafundamentaltechniqueinthestudyofanumberofstochasticmodelson a planar graph G = (V, E). Domains of G which are ‘switched-on’ in the model are surrounded by contours of the dual graph Gd which are ‘switched-off’. We make this more concrete as follows. We take as sample space the set = {0,1}E where, as usual, an edge e is called open in ω ∈ if ω(e) = 1. There exists no open path between two vertices x, y of G if and only if there exists a contourin the dual graph that separates x and y and that traverses closed edges only. Such facts have been especially fruitful in the case of percolation, because the dual process of closed edges is itself a percolationprocess. We saw similarly in Section 6.1 that the dual of a random-clustermodel on a planar graph G is a random-clustermodel on the dual graph Gd, and this observation led to a largely complete theory of the random-cluster model on the square lattice. When d = 2, one may summarize this with the facile remark that 2 = 1 + 1, viewed as an expression of the fact that the co-dimension of a line in R2 is 1. The situation in three and more dimensions is much more complicated since the co-dimension of a line in Rd is d − 1, and one is led therefore to a consideration of surfaces and their geometry.

We begin with a general description of duality in three dimensions (see, for example, [6, 139]) and we consider for the moment the three-dimensional cubic lattice L3. The dual lattice L3d is obtained by translating L3 by the vector

iciently large, [224]. The second component is the proof in Sections 7.6–7.11 of the existence of ‘Dobrushin interfaces’ for all random-cluster models with d ≥ 3, q ∈ [1,∞), and sufﬁciently large p. This generalizes Dobrushin’s work on nontranslation-invariant Gibbs states for the Ising model, [103], and extends even to the percolation model. A considerable amount of geometry is required for this, and the account given here draws heavily on the original paper, [139].

7.2 Basic properties of surfaces

The principal target of this section is to study the geometry of the dual surface corresponding to the external boundary of a ﬁnite connected subgraph of Ld. The results are presented for d ≥ 3, but the reader is advised to concentrate on the case d = 3. We write Ldd for the dual lattice of Ld, being the translate of Ld by the vector 12 = (21, 21,. . ., 21).

![image 617](<rcm1-1_images/imageFile617.png>)

![image 618](<rcm1-1_images/imageFile618.png>)

![image 619](<rcm1-1_images/imageFile619.png>)

![image 620](<rcm1-1_images/imageFile620.png>)

Let d ≥ 3 and let B0 = [0,1]d, viewed as a subset of Rd. The elementary cubes of Ldd are translates by integer vectors of the cube B0 − 21 = [−21, 21]d. The boundary of B0 − 21 is the union of the 2d sets Pi,u given by

![image 621](<rcm1-1_images/imageFile621.png>)

![image 622](<rcm1-1_images/imageFile622.png>)

![image 623](<rcm1-1_images/imageFile623.png>)

![image 624](<rcm1-1_images/imageFile624.png>)

(7.1) Pi,u = [−21, 21]i−1 × {u − 21} × [−21, 21]d−i,

![image 625](<rcm1-1_images/imageFile625.png>)

![image 626](<rcm1-1_images/imageFile626.png>)

![image 627](<rcm1-1_images/imageFile627.png>)

![image 628](<rcm1-1_images/imageFile628.png>)

![image 629](<rcm1-1_images/imageFile629.png>)

for i = 1,2,. . .,d and u = 0,1. A plaquette (in Rd) is deﬁned to be a translate by an integer vector of some Pi,u. We point out that plaquettes are (topologically) closed(d−1)-dimensionalsubsetsofRd, andthatplaquettesarelineswhen d = 2, and are unit squares when d = 3 (see Figure 7.1). Let H denote the set of all plaquettes in Rd. The straight line-segmentjoining the vertices of an edge e = x, y passes through the middle of a plaquette denoted by h(e), which we call the dual plaquette of e. More precisely, if y = x +ei where ei = (0,. . .,0,1,0,. . . ,0) is the unit vector in the direction of increasing ith coordinate, then h(e) = Pi,1 + x.

Let s ∈ {1,2,. . .,d − 2}. Two distinct plaquettes h1 and h2 are said to be s-connected, written h1 ∼s h2, if h1 ∩ h2 contains a homeomorphic image of the s-dimensional unit cube [0,1]s. We say that h1 and h2 are 0-connected, written

h1 ∼0 h2, ifh1∩h2  = ∅. Notethath1 d∼−2 h2 ifandonlyifh1∩h2 ishomeomorphic to [0,1]d−2. A set of plaquettes is said to be s-connected if they are connected

when viewed as the vertex-set of a graph with adjacency relation ∼s . Of particular importance is the case s = d − 2. The distance h1,h2 between two plaquettes h1, h2 is deﬁned to be the L∞ distance between their centres. For any set H of plaquettes, we write E(H) for the set of edges of Ld to which they are dual.

We consider next some geometricalmatters. The words ‘connected’and ‘component’ should be interpreted for the moment in their topological sense. Let T ⊆ Rd, and write T for the closure of T in Rd. We deﬁne the inside ins(T) to be the union of all bounded connected components of Rd \ T; the outside out(T) is the union of all unbounded connected components of Rd \ T. The set T is said to

![image 630](<rcm1-1_images/imageFile630.png>)

separate Rd if Rd \ T has more than one connected component. For a set H ⊆ H of plaquettes, we deﬁne the set [H] ⊆ Rd by

(7.2) [H] = {x ∈ Rd : x ∈ h for some h ∈ H}. We call a ﬁnite set H of plaquettes a splitting set if it is (d − 2)-connected and Rd \ [H] contains at least one bounded connected component.

The two theorems that follow are in a sense dual to one another. The ﬁrst is an analogue1 in a general number of dimensions of Proposition 2.1 of [210, Appendix], where two-dimensional mosaics were considered.

(7.3) Theorem [139]. Let d ≥ 3, and let G = (V, E) be a ﬁnite connected subgraph of Ld. There exists a splitting set Q of plaquettes such that:

(i) V ⊆ ins([Q]), (ii) every plaquette in Q is dual to some edge of Ed with exactly one endvertex in V,

(iii) if W is a connected set of vertices of Ld such that V ∩ W = ∅, and there exists an inﬁnite path on Ld starting in W that uses no vertex in V, then W ⊆ out([Q]).

For any set δ of plaquettes, we deﬁne its closure δ to be the set (7.4) δ = δ ∪ h ∈ H : h is (d − 2)-connected to some member of δ .

![image 631](<rcm1-1_images/imageFile631.png>)

![image 632](<rcm1-1_images/imageFile632.png>)

Let δ = {h(e) : e ∈ D} be a (d − 2)-connected set of plaquettes. Consider the subgraph (Zd,Ed \ D) of Ld, and let C be a component of this graph. Let

v,δC denote the set of all vertices v in C for which there exists w ∈ Zd with h( v,w ) ∈ δ, and let e,δC denotethe set of edges f of C forwhich h( f ) ∈ δ\δ. Note that edges in e,δC have both endvertices belonging to v,δC.

![image 633](<rcm1-1_images/imageFile633.png>)

![image 634](<rcm1-1_images/imageFile634.png>)

(7.5) Theorem [139]. Let d ≥ 3. Let δ = {h(e) : e ∈ D} be a (d − 2)-connected set of plaquettes, and let C = (VC, EC) be a ﬁnite connected component of the graph (Zd,Ed \ D). There exists a splitting set Q = QC of plaquettes such that:

(i) VC ⊆ ins([Q]), (ii) Q ⊆ δ,

(iii) every plaquette in Q is dual to some edge of Ed with exactly one endvertex in C. Furthermore, the graph ( v,δC, e,δC) is connected.

This theorem will be used later to show that, for a suitable (random) set δ of plaquettes, the random-cluster measure within a bounded connected component of Rd \ [δ] is that with wired boundary condition. The argument is roughly as follows. Let ω ∈ , and let δ = {h(e) : e ∈ D} be a maximal (d − 2)-connected

![image 635](<rcm1-1_images/imageFile635.png>)

1This answers a question which arose in 1980 during a conversation with H. Kesten.

set of plaquettes that are open (in the sense that they are dual to ω-closed edges of Ld, see (7.9)). Let h = h( f ) ∈ δ \ δ. It must be the case that f is open, since if f were closed then h( f ) would be open, which would in turn imply that h( f ) ∈ δ, a contradiction. That is to say, for any ﬁnite connected component C of (Zd,Ed \ D), every edge in e,δC is open. By Theorem 7.5, the boundary v,δC, when augmented by the set e,δC of edges, is a connected graph. The randomcluster measure on C, conditional on the set δ, is therefore a wired measure.

![image 636](<rcm1-1_images/imageFile636.png>)

We shall require one further theorem of similar type.

(7.6)Theorem. Letd ≥ 3andlet δ = {h(e) : e ∈ D}beaﬁnite(d−2)-connected set of plaquettes. Let C = (V, E) be the subgraph of (Zd,Ed \ D) comprising all vertices and edges lying in out([δ]). There exists a subset Q of δ such that:

(i) Q is (d − 2)-connected, (ii) every plaquette in Q is dual to some edge of Ed with at least one endvertex in C. Furthermore, the graph ( v,δC, e,δC) is connected.

ProofofTheorem7.3. Relatedresultsmaybefoundin[82, 101, 159]. Thetheorem may be proved by extending the proof of [159, Lemma 7.2], but instead we adapt the proof given for three dimensions in [139]. Consider the set of edges of Ld with exactly one endvertex in V, and let P be the corresponding set of plaquettes.

Let x ∈ V. We show ﬁrst that x ∈ ins([P]). Let U be the set of all closed unit cubes of Rd having centresin V. Since all relevantsets in this proofare simplicial, the notions of path-connectednessand arc-connectednesscoincide. Recall that an unbounded path of Rd from x is a continuous mapping γ : [0,∞) → Rd with γ(0) = x and unbounded image. For any such path γ satisfying |γ(t)| → ∞ as t → ∞, γ has a ﬁnal point z(γ) belonging to the (closed) union of all cubes in U. Now z(γ) ∈ [P] for all such γ, and therefore x ∈ ins([P]).

Let λs denote s-dimensional Lebesgue measure, so that, in particular, λ0(S) = |S|. A subset S of Rd is called:

thin if λd−3(S) < ∞, fat if λd−2(S) > 0.

Let P1, P2,. . ., Pn be the (d − 2)-connected components of P. Note that [Pi] ∩ [Pj] is thin, for i  = j. We show next that there exists i such that x ∈ ins([Pi]). Suppose for the sake of contradiction that this is false, which is to say that x ∈/ ins([Pi]) for all i. Then x ∈/ Pi = [Pi] ∪ ins([Pi]) for i = 1,2,. . .,n. Note that each Pi is a closed set which does not separate Rd.

![image 637](<rcm1-1_images/imageFile637.png>)

![image 638](<rcm1-1_images/imageFile638.png>)

Let i  = j. We claim that: (7.7) either Pi ∩ Pj is thin, or one of the sets Pi, Pj is a subset of the other. To see this, suppose that Pi ∩ Pj is fat; we shall deduce as required that either Pi ⊆ Pj or Pi ⊇ Pj.

![image 639](<rcm1-1_images/imageFile639.png>)

![image 640](<rcm1-1_images/imageFile640.png>)

![image 641](<rcm1-1_images/imageFile641.png>)

![image 642](<rcm1-1_images/imageFile642.png>)

![image 643](<rcm1-1_images/imageFile643.png>)

![image 644](<rcm1-1_images/imageFile644.png>)

![image 645](<rcm1-1_images/imageFile645.png>)

![image 646](<rcm1-1_images/imageFile646.png>)

![image 647](<rcm1-1_images/imageFile647.png>)

![image 648](<rcm1-1_images/imageFile648.png>)

Suppose further that Pi ∩[Pj] is fat. Since [Pj] is a union of plaquettes and Pi is a union of plaquettes and cubes, all with cornersin Zd + 21, there exists a pair h1, h2 of plaquettesofLdd such thath1 d∼−2 h2, and g = h1∩h2 satisﬁes g ⊆ Pi ∩[Pj]. We cannot have g ⊆ [Pi] since [Pi] ∩ [Pj] is thin, whence int(g) ⊆ ins([Pi]), where int(g) denotes the interior of g viewed as a subset of Rd−2. Now, [Pj] is (d − 2)-connected and [Pi] ∩ [Pj] is thin, so that [Pj] is contained in the closure of ins([Pi]), implying that [Pj] ⊆ Pi and therefore Pj ⊆ Pi.

![image 649](<rcm1-1_images/imageFile649.png>)

![image 650](<rcm1-1_images/imageFile650.png>)

![image 651](<rcm1-1_images/imageFile651.png>)

![image 652](<rcm1-1_images/imageFile652.png>)

![image 653](<rcm1-1_images/imageFile653.png>)

![image 654](<rcm1-1_images/imageFile654.png>)

![image 655](<rcm1-1_images/imageFile655.png>)

Suppose next that Pi ∩ [Pj] is thin but Pi ∩ ins([Pj]) is fat. Since [Pi] is (d − 2)-connected, it has by deﬁnition no thin cutset. Since [Pi] ∩ [Pj] is thin, either [Pi] ⊆ Pj or [Pi] is contained in the closure of the unbounded component of Rd \[Pj]. The latter cannot hold since Pi ∩ ins([Pj]) is fat, whence [Pi] ⊆ Pj and therefore Pi ⊆ Pj. Statement (7.7) has been proved.

![image 656](<rcm1-1_images/imageFile656.png>)

![image 657](<rcm1-1_images/imageFile657.png>)

![image 658](<rcm1-1_images/imageFile658.png>)

![image 659](<rcm1-1_images/imageFile659.png>)

![image 660](<rcm1-1_images/imageFile660.png>)

![image 661](<rcm1-1_images/imageFile661.png>)

![image 662](<rcm1-1_images/imageFile662.png>)

By (7.7), we may write R = ni=1 Pi as the union of distinct closed bounded sets Pi, i = 1,2,. . .,k, where k ≤ n, that do not separate Rd and such that Pi ∩ Pj is thin for i  = j. By Theorem 11 of [223, §59, Section II]2, R does not separate Rd. By assumption, x ∈/ R, whence x lies in the unique component of the complement Rd \ R, in contradiction of the assumption that x ∈ ins([P]). We deduce that there exists k such that x ∈ ins([Pk]), and we deﬁne Q = Pk.

![image 663](<rcm1-1_images/imageFile663.png>)

Consider now a vertex y ∈ V. Since G = (V, E) is connected, there exists a path in Ld that connects x with y using only edges in E. Whenever u and v are two consecutive vertices on this path, h( u,v ) does not belong to P. Therefore, y lies in the inside of [Q]. Claims (i) and (ii) are now proved with Q as given, and it remains to prove (iii).

Let W be as in (iii), and let w ∈ W be such that: there exists an inﬁnite path on Ld with endvertex w and using no vertex of V. Whenever u and v are two consecutive vertices on such a path, the plaquette h( u,v ) does not lie in P. It follows that w ∈ out([P]), and therefore w ∈ out([Q]).

Proof of Theorem 7.5. Let H = ( v,δC, e,δC). Let x ∈ v,δC, and write Hx for the connected component of H containing x. We claim that there exists a plaquette hx = h( y, z ) ∈ δ such that y ∈ Hx.

The claim holds with y = x and hx = h( x, z ) if x has a neighbour z with h( x, z ) ∈ δ. Assume thereforethat x hasnosuch neighbourz. Since x ∈ v,δC, x has some neighbour u in Ld with h( x,u ) ∈ δ \ δ. Following a consideration

![image 664](<rcm1-1_images/imageFile664.png>)

of the various possibilities, there exists h ∈ δ such that h d∼−2 h( x,u ), and

either (a) h = h( u, z ) for some z, or (b) h = h( v, z ) for some v, z satisfying v ∼ x, z ∼ u.

![image 665](<rcm1-1_images/imageFile665.png>)

2This theorem states, subject to a mild change of notation, that: “If none of the closed sets F0 and F1 cuts Sd between the points p and q and if dim(F0 ∩ F1) ≤ d − 3, their union F0 ∪ F1 does it neither”. Here, Sd denotes the d-sphere.

If (a) holds, we take y = u (∈ Hx) and hx = h. If (a) does not hold but (b) holds for some v, z, we take y = v (∈ Hx) and hx = h.

We apply Theorem 7.3 with G = Hx to obtain a splitting set Qx, and we claim

that (7.8) Qx ∩ δ  = ∅.

This we prove as follows. If hx ∈ Qx, the claim is immediate. Suppose that hx ∈/ Qx, so that [hx] ∩ ins([Qx])  = ∅, implying that δ intersects both ins([Qx]) and out([Qx]). Since both δ and Qx are (d − 2)-connected sets of plaquettes, it follows that δ ∪ Qx is (d − 2)-connected. Therefore, there exist h′ ∈ δ, h′′ ∈ Qx such that h′ d∼−2 h′′. If h′′ ∈ δ, then (7.8) holds, so we may assume that h′′ ∈/ δ, and hence h′′ ∈ δ \ δ. Then h′′ = h( v,w ) for some v ∈ Hx, and therefore w ∈ Hx, a contradiction. We conclude that (7.8) holds.

![image 666](<rcm1-1_images/imageFile666.png>)

Now, (7.8) implies that Qx ⊆ δ. Suppose on the contrary that Qx  ⊆ δ, so that

there exist h′ ∈ δ, h′′ ∈ Qx \ δ such that h′ d∼−2 h′′. This leads to a contradiction by the argument just given, whence Qx ⊆ δ.

Suppose now that x and y are vertices of H such that Hx and Hy are distinct connected components. Either Hx lies in out([Qy]), or Hy lies in out([Qx]). Since Qx, Qy ⊆ δ, either possibility contradicts the assumption that x and y are connected in C. Therefore, Hx = Hy as claimed. Part (i) of the theorem holds with Q = Qx.

Proof of Theorem 7.6. This makes use the methods of the last two proofs, and is only sketched. Let Q ⊆ H be the set of plaquettes that are dual to edges of Ed \ E with at least one endvertex in V. By the deﬁnition of the graph C = (V, E), Q ⊆ δ. Let Q1, Q2,. . . , Qm be the (d − 2)-connected components of Q. If m ≥ 2, there exists a non-empty subset H ⊆ δ \ Q such that Q ∪ H is (d − 2)-connected but no strict subset of Q ∪ H is (d − 2)-connected. Each h = h(e) ∈ H must be such that at least one vertex of e lies in out(Q), in contradiction of the deﬁnition of Q. It follows that Q is (d − 2)-connected.

The connectivity of ( v,δC, e,δC) may be provedin very much the same way as in the proof of Theorem 7.5.

7.3 A contour representation

The dual of a two-dimensional random-cluster model is itself a random-cluster model, as explained in Chapter 6. The corresponding statement is plainly false in three or more dimensions, since the geometry of plaquettes differs from that of edges. Consider an edge-conﬁguration ω ∈ = {0,1}Ed, and the corresponding plaquette-conﬁguration π = (π(h) : h ∈ H) given by

(7.9) π(h(e)) = 1 − ω(e), e ∈ Ed.

174 Duality in Higher Dimensions [7.3]

Thus, h(e) is open if and only if e is closed. The open plaquettes form surfaces, or ‘contours’, and one seeks to understand the geometry of the original process througha study of the probable structure of such contours. Contoursare objectsof some geometrical complexity, and they demand a proper study in their own right, of which the results of Section 7.2 form part.

The study of contours for the random-cluster model has as principal triumph a fairly complete analysis of the model for large q. The central feature of this analysis is the proof that, at the critical point p = pc(q) for sufﬁciently large q, the contour measures of both free and wired models have convergent cluster expansions. This implies a discontinuousphase transition, the existence of a mass gap, and a number of other facts presented in Section 7.5.

Cluster (or ‘polymer’) expansions form a classical topic of statistical mechanics, and their theory is extensive and well understood by experts. Rather than developingthe theory from scratch here, we shall in the next section abstract those ingredients that are relevant for the current application. Meanwhile, we concentrate on formulating the random-clustermodel in a manner resonant with polymer expansions. The account given here is an expansion and elaboration of that found in [224]. A further treatment may be found in [65, 66].

Henceforthin this chapterwe shall assume, unless otherwise stated, that d = 3. Similar results are valid whenever d ≥ 3, and stronger results hold when d = 2. A plaquette is taken to be a closed unit square of the dual lattice L3d, and each plaquette h = h(e) is pierced by a unique edge e of L3.

Since the random-cluster model involves probability measures on the set of edge-conﬁgurations, we shall consider functions on the power set of the edgeset E3 rather than of the vertex-set Z3. Let E be a ﬁnite subset of E3, and let LE = (VE, E) denote the induced subgraph of L3. We shall consider the partition functions of the wired and free random-cluster measures on this graph, and to this end we introduce various notions of ‘boundary’. Let D be a (ﬁnite or inﬁnite) subset of E3, and write D = E3 \ D for its complement.

![image 667](<rcm1-1_images/imageFile667.png>)

(i) The vertex-boundary ∂D is the set of all x ∈ VD such that there exists an edge e = x, z with e ∈/ D. Note that ∂D = ∂D.

![image 668](<rcm1-1_images/imageFile668.png>)

We shall require three (related) types of ‘edge-boundaries’ of D. (ii) The 1-edge-boundary ∂eD is deﬁned3 to be the set of all edges e ∈ D such that there exists f ∈/ D with the property that h(e) ∼1 h( f ). (iii) The external edge-boundary extD is the set of all edges e ∈/ D that are incident to some vertex in ∂D.

(iv) The internal edge-boundary intD is the external edge-boundary of the complement D, that is, intD = extD. In other words, intD includes every edge e ∈ D that is incident to some x ∈ ∂D.

![image 669](<rcm1-1_images/imageFile669.png>)

![image 670](<rcm1-1_images/imageFile670.png>)

![image 671](<rcm1-1_images/imageFile671.png>)

3When working with Ld for general d, ∂eD would be taken to be the (d − 2)-edge-boundary, given similarly but with 1 replaced by d − 2.

Let p ∈ (0,1), q ∈ (0,∞), and r = p/(1 − p). As is usual in classical statistical mechanics, it is the partition functions which play leading roles. Henceforth, we take E to be a ﬁnite subset of E3. We consider ﬁrst the wired measure on LE, which we deﬁne via its partition function4

r|D|qk1(D,E),

(7.10) Z1(E) =

D: D⊆E D⊇∂eE

where k1(D, E) denotes the number of connected components (including the inﬁnite cluster and any isolated vertices) of L3 after the removalof edges in E \ D. This deﬁnition (7.10) differs slightly from that of (4.12) with ξ = 1, but it may be seen via Theorem 7.5 that the corresponding probability measure amounts to the wired measure on the edge-set E \ ∂eE. It is presented in the above manner in order to facilitate certain relations to be derived soon.

We deﬁne similarly the free partition function on LE by (7.11) Z0(E) =

r|D|qk0(VE\∂E,D),

D: D⊆E D∩ intE=∅

where k0(G) denotesthe numberof connectedcomponentsof a graph G including isolated vertices5. Since intE includes every edge e ∈ E that is incident to some vertex x ∈ ∂E, every x ∈ ∂E is isolated for all sets D contributing to the summation in (7.11), and these vertices are not included in the cluster-count k(VE \ ∂E, D). The measure deﬁned by (7.11) differs slightly from that given at (4.11)–(4.12) with ξ = 0, but it may be seen that the corresponding probability measure amounts to the free measure on the graph (VE, E \ intE).

By an argument similar to that of Theorem 4.58, there exists a function F, termed the pressure, such that

1 |E|

1 |E|

log Z1(E) = lim

log Z0(E) ,

(7.12) F(p,q) = lim

![image 672](<rcm1-1_images/imageFile672.png>)

![image 673](<rcm1-1_images/imageFile673.png>)

E↑E3

E↑E3

where the limit is taken in a suitable ‘van Hove’ sense.

We introduce next the classes of ‘wired’ and ‘free’ contours of the lattice L3. For s ∈ {0,1} and e, f ∈ E3, we write e ∼s f if h(e) ∼s h( f ). A subset D of E3 is said to be s-connected if it is connected when viewed as a graph with adjacency relation ∼s . Thus, D is s-connected if and only if the set {h( f ) : f ∈ D} of plaquettes is s-connected. Let D ⊆ E3, and consider its external edge-boundary γ = extD. We call the set γ a wired contour (respectively, free contour) if it is

![image 674](<rcm1-1_images/imageFile674.png>)

- 4It is convenient in the present setting to think of a conﬁguration as a subset of edges rather than as a 0/1-vector. We adopt the convention that Z1(∅) = 1.
- 5We set Z0(E) = 1 if E \ intE = ∅. In particular, Z0(∅) = 1.


It may be seen by Theorem 7.5 that (7.18) intγ = γ, γ ∈ Cw.

![image 675](<rcm1-1_images/imageFile675.png>)

Two contours γ1, γ2 of the same class are said to be compatible if γ1 ∪γ2 is not 1-connected. We call the pair γ1, γ2 externally compatible if they are compatible and in additionγ1 ⊆ ext(γ2) and γ2 ⊆ ext(γ1). IfŴ = {γ1,γ2,. . .,γn} is a family of pairwise externally-compatiblecontoursof the same class, we write Ŵ = i γi, ext(Ŵ) = E3 \ Ŵ, and int(Ŵ) = Ŵ \ Ŵ. Here, we have used Ŵ to denote the set of edges in the union of the γi.

![image 676](<rcm1-1_images/imageFile676.png>)

![image 677](<rcm1-1_images/imageFile677.png>)

![image 678](<rcm1-1_images/imageFile678.png>)

![image 679](<rcm1-1_images/imageFile679.png>)

![image 680](<rcm1-1_images/imageFile680.png>)

![image 681](<rcm1-1_images/imageFile681.png>)

LetŴw = {γ1,γ2,. . .,γm} bea familyof pairwiseexternally-compatiblewired contours. It may be seen that

and, by (7.11),

m

![image 682](<rcm1-1_images/imageFile682.png>)

intŴ =

i=1

intγi,

![image 683](<rcm1-1_images/imageFile683.png>)

m

(7.19) Z0(Ŵw) =

Z0(γi).

![image 684](<rcm1-1_images/imageFile684.png>)

![image 685](<rcm1-1_images/imageFile685.png>)

i=1

Similarly, if Ŵf = {γ1,γ2,. . .,γn} is a family of pairwise externally-compatible free contours, then

n

∂e(intγi),

∂e(intŴf) =

i=1

and, by (7.10),

(7.20) qn−1Z1(intŴf) =

n

Z1(intγi).

i=1

A key step in the transformation of the random-cluster model to a polymer model is the derivation of recursive expressions for Z1(E) and Z0(E) in terms of partition functions of subsets of E. We describe this ﬁrst for the wired partition function Z1(E). The subset E ⊆ E3 is called co-connected if |E| < ∞ and E3\E is connected. Let E be co-connected. Let D ⊆ E be such that ∂eE ⊆ D. Let D∞ be the set of edges in the unique inﬁnite connected component of D ∪ Ec, and let Ŵ(D) = extD∞. The set Ŵ(D) may be expressed as a union of maximal 1-connected sets γi, i = 1,2,. . .,m, which are pairwise externally-compatible wired contours, and we write Ŵw(D) = {γ1,γ2,. . . ,γm}. Note that every edge in Ŵ(D) belongs to E \ ∂eE. Thus, to each set D there corresponds a collection Ŵw(D), and the summation in (7.10) may be partitioned according to the value of Ŵw(D). For a given family Ŵw = {γ1,γ2,. . .,γm} of pairwise externallycompatible wired contours in E \ ∂eE, the corresponding part of the summation

178 Duality in Higher Dimensions [7.3]

in (7.10) is over sets D with Ŵw(D) = Ŵw, and the constraints on such D are as follows:

- 1. D contains no edge in any γi,
- 2. D contains every edge of E not belonging to Ŵw. This leads via (7.18) and (7.19) to the formula


![image 686](<rcm1-1_images/imageFile686.png>)

(7.21) Z1(E) =

r|E\Ŵw|qZ0(Ŵw)

![image 687](<rcm1-1_images/imageFile687.png>)

![image 688](<rcm1-1_images/imageFile688.png>)

Ŵw⊂E\∂eE

where the summation is over all families Ŵw of pairwise externally-compatible wired contours contained in E \ ∂eE. By Theorems 7.3 and 7.5, each such Ŵw is co-connected.

![image 689](<rcm1-1_images/imageFile689.png>)

We turn now to the free partition function Z0(E). Let D ⊆ E \ intE. Let D∞c be the set of edges in the unique inﬁnite 1-connected component of Dc = E3 \ D, and let Ŵ(D) = intD∞c . The set Ŵ(D) may be expressed as a union of maximal 1-connected sets γi, i = 1,2,. . .,n, which are pairwise externally-compatible free contours, and we write Ŵf(D) = {γ1,γ2,. . .,γn}. We note that every edge in Ŵ(D) belongs to E. Thus, to each set D there corresponds a collection Ŵf(D), and the summation in (7.11) may be partitioned according to the value of Ŵf(D). For a given family Ŵf = {γ1,γ2,. . .,γn} of pairwise externally-compatible free contours in E, one sums over sets D with Ŵf(D) = Ŵf, and the constraints on such D are as follows:

- 1. D ⊆ intŴf,
- 2. for i = 1,2,. . .,n, D contains every edge in intγi that is 1-connected to some edge in γi. This leads by (7.11), (7.20), and Theorem 7.5 to the formula


(7.22) Z0(E) =

q|VE\∂E|−|VintŴf|qn−1Z1(intŴf),

Ŵf⊂E

where the summation is over all families Ŵf of pairwise externally-compatible free contours γ contained in E. By Theorems 7.3 and 7.5, each such intŴf is co-connected.

The nextstep is to transformthe random-clustermodelinto a so-called polymer model of statistical mechanics. To the latter model we shall apply certain standard results summarized in the next section, and we shall return to the random-cluster application in Section 7.5.

7.4 Polymer models

The partition function of a lattice model in a ﬁnite volume of Rd may generally be written in the form

(7.23) Z( ) =

⊂ γ∈

 (γ),

where the summation7 is overall compatible families in (includingthe empty family, which contributes 1) comprising certain types of geometrical objects γ called ‘polymers’. The nature of these polymers, of the weight function (which weshallassumetobenon-negative),andofthemeaningof‘compatibility’,depend on the particular model in question. We summarize some basic properties of such polymer models in this section, and shall apply these results to random-cluster models in the next section. The current target is to communicate the theory in the broad. The details of this theory have the potential to complicate the message, and they will therefore be omitted in almost their entirety. In the interests of brevity, certain liberties will be taken with the level of rigour. The theory of polymer models is well developed in the literature of statistical mechanics, and the reader may consult the papers [85, 216, 219, 274, 275, 326], the book [301], and the references therein.

The discontinuityof the Potts phase transition was provedﬁrst in [220]via a socalled chessboard estimate. This striking result, combined with the work of [218], inspired the proof via polymer models of the discontinuity of the random-cluster phase transition, [224]. The last paper is the basis for the present account.

The study of polymer models is wider than is required for our speciﬁc applications, and a general approachmay be found in [219]. For the sake of concreteness, we note the following. Our applications will involve co-connected subsets of E3. Our polymers will be either wired or free contours in the sense of the last section, and ‘compatible’ shall be interpreted in the sense of that section. Our weight functions will be assumed henceforth to be strictly positive and automorphisminvariant, in that  (γ) =  (τγ) for any automorphism τ of L3.

One seeks conditions under which the limit

1 | |

logZ( )

(7.24) f ( ) = lim

![image 690](<rcm1-1_images/imageFile690.png>)

↑E3

exists, together with bounds on the deviation (7.25) σ( , ) = | | f ( ) − logZ( ).

These are obtained by elementary arguments under the assumption that the  (γ) decay exponentially in the size of γ, with a sufﬁciently negative exponent. With

![image 691](<rcm1-1_images/imageFile691.png>)

7We adopt the convention that Z(∅) = 1.

180 Duality in Higher Dimensions [7.4]

each polymer γ we associate a natural measure of ‘size’ denoted by γ and, for τ ∈ (0,∞), we call a τ-functional if

(7.26)  (γ) ≤ e−τ γ for all γ.

Theprincipalconclusionsthatfollowarenotstatedunambiguouslyasatheorem since their exact hypotheses will not be speciﬁed. Throughout this and the next section, the terms c and ci are positive ﬁnite constants which depend only on the particular type of model and not on the function . These constants may depend on the underlying lattice (which we shall take to be L3), and may therefore vary with the number d of dimensions.

(7.27) ‘Theorem’. There exist c,c1,c2 ∈ (0,∞) such that the following holds. Let be a τ-functional with τ > c.

(a) The limit f ( ) exists in (7.24), and satisﬁes 0 ≤ f ( ) ≤ e−c1τ. (b) The deviation in (7.25) satisﬁes |σ( , )| ≤ |∂ |e−c2τ for all ﬁnite .

The polymer model is said to be convergent when the condition of the above ‘Theorem’ is satisﬁed. Sketch proof. Here are some commentson the proof. The existence of the pressure

f ( ) in part(a) may be shown using subadditivityin a mannersimilar to the proof ofTheorem4.58. Thispartoftheconclusionisvalidirrespectiveoftheassumption that be a τ-functional, although it may in general be the case that f ( ) = ∞. One obtains a formula for the limit function f ( ) in the following manner. Let

(7.28) ψ(E) =

(−1)|E\ | logZ( ), E ⊆ E3, |E| < ∞.

⊆E

By the inclusion–exclusion principle8,

(7.29) logZ( ) =

E⊆

ψ(E).

By (7.23), Z( 1 ∪ 2) = Z( 1)Z( 2) if 1 and 2 have no common vertex. By (7.28), ψ is automorphism-invariant and satisﬁes

(7.30) ψ(E) = 0 if E is not connected. Under the assumption of ‘Theorem’ 7.27, one may obtain after a calculation that (7.31) |ψ(E)| ≤ e−c3τ E for a suitable deﬁnition of the size E and for some c3 ∈ (0,∞).

![image 692](<rcm1-1_images/imageFile692.png>)

8As in [144].

Formula (7.29) motivates the proposal that, for any given e ∈ E3,

1 | |

ψ(E) |E|

f ( ) = lim

logZ( ) =

,

![image 693](<rcm1-1_images/imageFile693.png>)

![image 694](<rcm1-1_images/imageFile694.png>)

↑E3

E: e∈E

and this may be proved rigorously by use of (7.31) with sufﬁciently large τ. The inequality of part (a) follows. By (7.29) again,

ψ(E) |E|

1{E∩ c =∅}

σ( , ) =

,

![image 695](<rcm1-1_images/imageFile695.png>)

e∈ E: e∈E

and, by (7.30),

|ψ(E)|.

|σ( , )| ≤

x∈∂  E: x∈VE

Part (b) follows by (7.31) and a combinatorial estimate.

Turning to probabilities, the partition function Z( ) gives rise to a probability measure κ on the set of compatible families in , namely

1 Z( )

 ( ), ⊂  ,

κ( ) =

![image 696](<rcm1-1_images/imageFile696.png>)

where  ( ) = γ∈  (γ). The following elementary result will be useful later. (7.32) Theorem (Peierls estimate). Let γ be a polymer of . The κ-probability that γ belongs to a randomly chosen compatible family satisﬁes

κ { : γ ∈ } ≤  (γ).

Proof. We write ⊥ γ to mean that is a compatible family satisfying: γ ∈/ , and ∪ {γ} is a compatible family. Then,

1 Z( ) : ⊥γ

κ { : γ ∈ } =

 ( ) (γ)

![image 697](<rcm1-1_images/imageFile697.png>)

 ( ) (γ)

≤ : ⊥γ

≤  (γ).

![image 698](<rcm1-1_images/imageFile698.png>)

 ( )[1 +  (γ)]

: ⊥γ

7.5 Discontinuous phase transition for large q

It is a principal theorem for Potts and random-cluster models that the phase transition is discontinuous when q is sufﬁciently large, see [68, 220, 251] for Potts models and [224] for random-cluster models. This is proved for random-cluster models by showing that the maximal contours of both wired and free models at p = pc(q) have the same laws as those of certain convergent polymer models. Such use of contour expansions is normally termed a ‘Pirogov–Sinai’ approach9, after the authors of [274, 275].

Here are the main results, expressed for a general number d of dimensions.

(7.33) Theorem (Discontinuous phase transition) [224]. Let d ≥ 2. There exists Q = Q(d) such that following hold when q > Q.

(a) The edge-densities hb(p,q) = φpb,q(e is open), b = 0,1,

are discontinuous functions of p at the critical point pc(q). (b) The percolation probabilities satisfy

θ0(pc(q),q) = 0, θ1(pc(q),q) > 0. (c) There is a unique random-cluster measure when p  = pc(q), and at least two random-cluster measures when p = pc(q), in that φ0pc(q),q  = φ1pc(q),q. (d) If p < pc(q), there is exponential decay and a non-vanishing mass gap, in that the unique random-cluster measure satisﬁes

φp,q(0 ↔ x) ≤ e−α|x|, x ∈ Zd, for some α = α(p,q) satisfying α ∈ (0,∞) and

lim

α(p,q) > 0.

p↑pc(q)

The large-q behaviour of pc(q) is given as follows. One may obtain an expansion of pc(q) in powers of q−1/d by pursuing the proof further. (7.34) Theorem [224]. For d ≥ 3,

pc(q) = 1 − q−1/d + O(q−2/d) as q → ∞. This may be compared to the exact value pc(q) =

√q) when d = 2 andq islarge, seeTheorem6.35. For d ≥ 3andlargeq, thereexistnon-translationinvariant random-cluster measures at the critical point pc(q).

√q/(1 +

![image 699](<rcm1-1_images/imageFile699.png>)

![image 700](<rcm1-1_images/imageFile700.png>)

![image 701](<rcm1-1_images/imageFile701.png>)

9An overview of contour methods may be found in [217].

(7.35) Theorem (Non-translation-invariant measure at pc(q)) [85, 254]. Let d ≥ 3. There exists Q = Q(d) such that there exists a non-translationinvariant DLR-random-cluster measure when p = pc(q) and q > Q.

It is not especially fruitful to seek numerical estimates on the Q(d) above. Such estimates may be computed, but they turn out to be fairly distant from those anticipated, namely10

(7.36) Q(2) = 4, Q(d) = 2 for d ≥ 6. No proof of Theorem 7.35 is included here, and the reader is referred for more details to the given references.

Numerous facts for Potts models with large q follow from the above. Let d ≥ 2 and p = 1 − e−β, and consider the q-state Potts model on Ld with inversetemperature β. Let q be large. When β < βc(q) (respectively, β > βc(q)), the number of distinct translation-invariant Gibbs states is 1 (respectively, q). When β = βc(q), there are q + 1 distinct extremal translation-invariant Gibbs states, correspondingto the free measure and the ‘b-boundary-condition’measure for b ∈ {1,2,. . .,q}, and every translation-invariant Gibbs state is a convex combination of these q + 1 states. When d ≥ 3, there exist in addition an inﬁnityofnon-translation-invariantGibbsstatesatthecriticalpointβc(q). Further discussion may be found in [65, 66, 68, 136, 224, 251, 254].

In preparation for the proofs of Theorems 7.33 and 7.34, we introduce an extension of the polymer model of the last section, in the context of the wired and free contours of Section 7.3. For a ﬁnite subset E of E3, let

(7.37) Z(E;  ) =

⊂E γ∈

 (γ)

be the partition function of a polymer model on E. The admissible families of polymers will be either families of wired contours (lying in E \ ∂eE) or families of free contours (lying in E); in either case they are required to be pairwise compatible. By a standard iterative argument, the sum in (7.37) may be restricted to families Ŵ of pairwise externally-compatible contours, and (7.37) becomes

(7.38) Z(E;  ) =

 (γ)

Ŵ⊂E γ∈Ŵ

where (7.39)  (γ) =  (γ)Z(intγ;  ).

![image 702](<rcm1-1_images/imageFile702.png>)

10Some progress has been made towards bounds on the value of Q(d). It is proved in [45] that the 3-state Potts model has a discontinuous transition for large d, and in [46] that discontinuity occurs when d = 3 for a long-range Potts model with exponentially decaying interactions. See [140] for related work when d = 2.

The letter (respectively, Ŵ) will always denote a family of pairwise compatible contours (respectively, pairwise externally-compatible contours).

Let β ∈ R. In either of the cases above, we deﬁne

(7.40) eβ|γ| (γ)

Z(E;  ,β) =

![image 703](<rcm1-1_images/imageFile703.png>)

Ŵ⊂E γ∈Ŵ

eβ|γ| (γ)Z(intγ;  ),

![image 704](<rcm1-1_images/imageFile704.png>)

=

Ŵ⊂E γ∈Ŵ

and we say that this new model has parameters (β, ).

We shall consider a pair of such models. The ﬁrst has parameters (βw, w), and its polymerfamilies comprise pairwise compatiblewired contours; the second has parameters (βf, f) and it involvesfree contours. They are deﬁned as follows. Let p ∈ (0,1), q ∈ [1,∞), r = p/(1 − p), and βw,βf ∈ [0,∞). The weight functions w(γ) = βww(γ), f(γ) = βf f(γ) are deﬁned inductively on the size of γ by: (7.41)

![image 705](<rcm1-1_images/imageFile705.png>)

βw w (γ)Z(intγ; βww) = w βw(γ) = (reβw)−|γ|Z0(γ), γ ∈ Cw,

![image 706](<rcm1-1_images/imageFile706.png>)

![image 707](<rcm1-1_images/imageFile707.png>)

βf f (γ)Z(intγ; βf f) = f βf(γ) = e−βf|γ|q−|Vintγ|Z1(intγ), γ ∈ Cf.

![image 708](<rcm1-1_images/imageFile708.png>)

These functionsgiverise to polymermodelswhichare relatedto thefreeand wired random-cluster models, as described in the ﬁrst part of the next theorem. They

have related pressure functions f ( βww), f ( βf f) given as in (7.24). The theorem is stated for general d ≥ 2, but the reader is advised to concentrate on the case

d = 3. (7.42) Theorem [224]. Let d ≥ 2, p ∈ (0,1), q ∈ [1,∞), and r = p/(1 − p). For βw,βf ∈ [0,∞) and a co-connected set E,

Z1(E) = r|E|qZ(E; βww,βw), Z0(E) = q|VE\∂E|Z(E; βf f,βf).

(7.43)

Let

(7.44) τ =

1 8d

logq − 5.

![image 709](<rcm1-1_images/imageFile709.png>)

There exists Q = Q(d) such that the following hold when q > Q.

(a) There exist reals bw,bf ∈ [0,∞) such that bww and bff are τ-functionals with τ > c, with c as in the hypothesis of ‘Theorem’ 7.27, and that the pressure F(p,q) of (7.12) satisﬁes

F(p,q) = f ( bww) + bw + logr = f ( bff) + bf +

1 d

logq. (7.45)

![image 710](<rcm1-1_images/imageFile710.png>)

(b) There exists a unique value p = p(q) such that the values bw, bf in part (a) satisfy:

if p < p, then bw > 0, bf = 0, if p = p, then bw = 0, bf = 0, if p > p, then bw = 0, bf > 0.

(7.46)

Proof of Theorem 7.42. We follow the scheme of [224] which in turn makes use of [218, 326]. For any given βw,βf ∈ [0,∞), equations (7.41) may be combined with (7.19)–(7.22) to obtain (7.43).

For βw,βf ∈ [0,∞), let w = βww, f = βf f be given by (7.41). Let τ = τ(q) be as in (7.44), and choose Q′ such that τ(Q′) > c where c is the constant in the hypothesis of ‘Theorem’ 7.27. We assume henceforth that (7.47) q > Q′. We deﬁne the τ-functionals

βw

(7.48) w (γ) = min{ βww(γ),e−τ γ }, γ ∈ Cw,

![image 711](<rcm1-1_images/imageFile711.png>)

βf (7.49) f (γ) = min{ βf f(γ),e−τ γ }, γ ∈ Cf, and let (7.50)

![image 712](<rcm1-1_images/imageFile712.png>)

bw = sup Bw where Bw = βw ≥ 0 : f ( βww) + βw + logr ≤ F(p,q) ,

![image 713](<rcm1-1_images/imageFile713.png>)

bf = sup Bf where Bf = βf ≥ 0 : f ( βf f) + βf + d−1 logq ≤ F(p,q) . We make three observations concerning the deﬁnition of bw; similar reasoning applies to bf. Firstly, since 0w ≤ 0w,

![image 714](<rcm1-1_images/imageFile714.png>)

![image 715](<rcm1-1_images/imageFile715.png>)

Z1(E) ≥ r|E|Z(E; 0w,0) = r|E|Z(E; 0w), by (7.43). Applying ‘Theorem’ 7.27 to the τ-functional 0w,

![image 716](<rcm1-1_images/imageFile716.png>)

![image 717](<rcm1-1_images/imageFile717.png>)

![image 718](<rcm1-1_images/imageFile718.png>)

F(p,q) ≥ logr + f ( 0w),

![image 719](<rcm1-1_images/imageFile719.png>)

whence 0 ∈ Bw. Secondly, by ‘Theorem’ 7.27 again, f ( 0w) ≤ e−c1τ, whence β ∈/ Bw for large β. The third observation is contained in the next lemma which is based on the corresponding step of [218]. The lemma will be used later also, and its proof is deferred until that of Theorem 7.42 is otherwise complete.

![image 720](<rcm1-1_images/imageFile720.png>)

(7.51) Lemma. Let α ∈ (0,∞). There exists Q′′ = Q′′(α) ≥ Q′ such that the following holds. If q > Q′′, the functions h(β,r) = f ( βw), f ( βf ) have the Lipschitz property: for β,β′ ∈ [0,∞) and r,r′ ∈ (0,∞),

![image 721](<rcm1-1_images/imageFile721.png>)

![image 722](<rcm1-1_images/imageFile722.png>)

|r − r′| r ∧ r′

h(β,r) − h(β′,r′) ≤ α |β − β′| +

.

![image 723](<rcm1-1_images/imageFile723.png>)

Assume henceforth that

(7.52) q > Q′′ = Q′′(21).

![image 724](<rcm1-1_images/imageFile724.png>)

By Lemma 7.51, the pressure f ( βww) (respectively, f ( βf f)) is continuous in βw (respectively, βf), and it follows by the prior observations that the suprema in (7.50) are attained, and hence

![image 725](<rcm1-1_images/imageFile725.png>)

![image 726](<rcm1-1_images/imageFile726.png>)

1 d

(7.53) F(p,q) = f ( bww) + bw + logr = f ( bff) + bf +

logq.

![image 727](<rcm1-1_images/imageFile727.png>)

![image 728](<rcm1-1_images/imageFile728.png>)

![image 729](<rcm1-1_images/imageFile729.png>)

By Lemma 7.51 and the continuity in p of F(p,q), Theorem 4.58, (7.54) bw = bw(p) and bf = bf(p) are continuous functions of p ∈ (0,1).

Havingchosenthevaluesbwandbf, weshallhenceforthsuppresstheirreference in the notation for the weight functions w, f, w, f, and we prove next that

![image 730](<rcm1-1_images/imageFile730.png>)

![image 731](<rcm1-1_images/imageFile731.png>)

(γ) ≤ e−τ γ , γ ∈ Cw, f(γ) ≤ e−τ γ , γ ∈ Cf.

(7.55) w

This implies in particular that w = w and f = f, and then (7.45) follows from (7.53). We shall prove (7.55) by induction on |γ|.

![image 732](<rcm1-1_images/imageFile732.png>)

![image 733](<rcm1-1_images/imageFile733.png>)

![image 734](<rcm1-1_images/imageFile734.png>)

It is not difﬁcult to see that (7.55) holds for γw ∈ Cw with |γw| ≤ 1, and for γf ∈ Cf with |γf| ≤ 2. This is trivial in the latter case since the free contour γf with smallest γf has γf = 2(2d −1), and it is proved in the former case as follows. Let γw ∈ Cw be such that |γw| = 1, which is to say that γw comprises a single edge. By (7.41), w(γw) = (rebw)−1. By (7.12), F(p,q) ≥ d−1 logq, and the claim follows by (7.53) and the fact that f ( w) ≤ 1, see ‘Theorem’ 7.27(a).

![image 735](<rcm1-1_images/imageFile735.png>)

![image 736](<rcm1-1_images/imageFile736.png>)

![image 737](<rcm1-1_images/imageFile737.png>)

![image 738](<rcm1-1_images/imageFile738.png>)

Let k ≥ 1 and assume that (7.55) holds for all γw ∈ Cw satisfying |γw| ≤ k and all γf ∈ Cf satisfying |γf| ≤ k + 1. Let γw be a wired contour with |γw| = k + 1.

![image 739](<rcm1-1_images/imageFile739.png>)

![image 740](<rcm1-1_images/imageFile740.png>)

![image 741](<rcm1-1_images/imageFile741.png>)

Any contour γw′ ∈ Cw contributing to Z(intγw; w) satisﬁes |γw′ | ≤ k. By the induction hypothesis, (7.56) Z(intγw; w) = Z(intγw; w)

![image 742](<rcm1-1_images/imageFile742.png>)

![image 743](<rcm1-1_images/imageFile743.png>)

= exp |intγw| f ( w) − σ(intγw, w) , where

![image 744](<rcm1-1_images/imageFile744.png>)

![image 745](<rcm1-1_images/imageFile745.png>)

σ(E, ) = |E| f ( ) − logZ(E;  )

as in (7.25). Any contour γf ∈ Cf contributing to Z(γw; f) is a subset of γw, and therefore satisﬁes |γf| ≤ k + 1. By the induction hypothesis as above,

![image 746](<rcm1-1_images/imageFile746.png>)

![image 747](<rcm1-1_images/imageFile747.png>)

![image 748](<rcm1-1_images/imageFile748.png>)

(7.57) Z(γw; f) = Z(γw; f)

![image 749](<rcm1-1_images/imageFile749.png>)

![image 750](<rcm1-1_images/imageFile750.png>)

![image 751](<rcm1-1_images/imageFile751.png>)

= exp |γw| f ( f) − σ(γw, f) .

![image 752](<rcm1-1_images/imageFile752.png>)

![image 753](<rcm1-1_images/imageFile753.png>)

![image 754](<rcm1-1_images/imageFile754.png>)

![image 755](<rcm1-1_images/imageFile755.png>)

By (7.41),

Z0(γw) Z(intγw; w)

![image 756](<rcm1-1_images/imageFile756.png>)

w(γw) = (rebw)−|γw|

![image 757](<rcm1-1_images/imageFile757.png>)

![image 758](<rcm1-1_images/imageFile758.png>)

= (rebw)−|γw|q|V(γw)\∂γw| Z(γw; f,bf) Z(intγw; w)

![image 759](<rcm1-1_images/imageFile759.png>)

by (7.43)

![image 760](<rcm1-1_images/imageFile760.png>)

![image 761](<rcm1-1_images/imageFile761.png>)

![image 762](<rcm1-1_images/imageFile762.png>)

![image 763](<rcm1-1_images/imageFile763.png>)

≤ (rebw)−|γw|q|V(γw)\∂γw|ebf|γw| Z(γw; f) Z(intγw; w)

![image 764](<rcm1-1_images/imageFile764.png>)

![image 765](<rcm1-1_images/imageFile765.png>)

![image 766](<rcm1-1_images/imageFile766.png>)

![image 767](<rcm1-1_images/imageFile767.png>)

![image 768](<rcm1-1_images/imageFile768.png>)

![image 769](<rcm1-1_images/imageFile769.png>)

= exp −|γw| logr + bw − bf − f ( f)

![image 770](<rcm1-1_images/imageFile770.png>)

![image 771](<rcm1-1_images/imageFile771.png>)

+ |V(γw) \ ∂γw| logq − |intγw| f ( w)

![image 772](<rcm1-1_images/imageFile772.png>)

![image 773](<rcm1-1_images/imageFile773.png>)

![image 774](<rcm1-1_images/imageFile774.png>)

× exp σ(intγw, w) − σ(γw, f) by (7.56)–(7.57). We use (7.13)–(7.14) and (7.53) to obtain that

![image 775](<rcm1-1_images/imageFile775.png>)

![image 776](<rcm1-1_images/imageFile776.png>)

![image 777](<rcm1-1_images/imageFile777.png>)

(7.58) w(γw) ≤ q− γw /(2d) exp |γw| f ( w) + σ(intγw, w) − σ(γw, f) .

![image 778](<rcm1-1_images/imageFile778.png>)

![image 779](<rcm1-1_images/imageFile779.png>)

![image 780](<rcm1-1_images/imageFile780.png>)

![image 781](<rcm1-1_images/imageFile781.png>)

By ‘Theorem’ 7.27, f ( w) ≤ e−c1τ ≤ 1, and

![image 782](<rcm1-1_images/imageFile782.png>)

|σ(E, w)| ≤ |∂E|e−c2τ, |σ(E, f)| ≤ |∂E|e−c2τ for co-connected sets E. By (7.58), (7.16), and (7.44), (7.59) w(γw) ≤ q− γw /(2d)e5 γw ≤ e−τ γw , as required in the induction step.

![image 783](<rcm1-1_images/imageFile783.png>)

![image 784](<rcm1-1_images/imageFile784.png>)

We consider now a free contour γf with |γf| = k + 2. By an elementary geometric argument, (7.60) γf ≥ 2(2d − 1). Arguing as in the wired case above, we obtain subject to the induction hypothesis that (7.61) f(γf) ≤ q · q− γf /(2d) exp σ(intγf, f) − σ(intγf, w) , by (7.15). By (7.17),

![image 785](<rcm1-1_images/imageFile785.png>)

![image 786](<rcm1-1_images/imageFile786.png>)

![image 787](<rcm1-1_images/imageFile787.png>)

f(γf) ≤ q · q− γf /(2d)e5 γf . By (7.60) and the fact that d ≥ 2,

γf − 2d ≥ 41 γf ,

![image 788](<rcm1-1_images/imageFile788.png>)

whence

f(γf) ≤ e−τ γf , and the induction proof of (7.55) is complete.

We turn now to part (b) of the theorem, and we prove next that, for any given p ∈ (0,1), (7.62) min{bw,bf} = 0. Suppose conversely that p ∈ (0,1) is such that bw,bf > 0. By (7.53) and Lemma 7.51 with α = 21, there exist βw ∈ (0,bw), βf ∈ (0,bf), and ǫ > 0 such that (7.63) F(p,q) − ǫ = f ( βww) + βw + logr = f ( βf f) + βf +

![image 789](<rcm1-1_images/imageFile789.png>)

1 d

logq.

![image 790](<rcm1-1_images/imageFile790.png>)

![image 791](<rcm1-1_images/imageFile791.png>)

![image 792](<rcm1-1_images/imageFile792.png>)

We use this in place of (7.53) in the argument above, to obtain that βww = βww and βwf = βf f. Equation (7.63) implies that

![image 793](<rcm1-1_images/imageFile793.png>)

![image 794](<rcm1-1_images/imageFile794.png>)

1 d

(7.64) F(p,q) > f ( βww) + βw + logr = f ( βf f) + βf +

logq.

![image 795](<rcm1-1_images/imageFile795.png>)

However, by (7.43),

Z1(E) = r|E|qZ(E; βww,βw) ≤ (reβw)|E|qZ(E; βww), whence

F(p,q) ≤ logr + βw + f ( βww) in contradiction of (7.64). Therefore, (7.62) holds.

Next we show that there exists a unique p such that bw(p) = bf(p) = 0. The proof is deferred until later in the section.

- (7.65) Lemma. There exists Q′′′ ≥ Q′′ such that the following holds. For q > Q′′′, there is a unique p′ ∈ (0,1) such that bw(p′) = bf(p′) = 0. The ratio r′ = p′/(1 − p′) satisﬁes
- (7.66) r′ = q1/d exp f ( 0f ) − f ( 0w) . Let q > Q = Q′′′ and p = p′, where Q′′′ and p′ are as given in this lemma.


By (7.45) and the fact that F(p,q) → d−1 logq as p ↓ 0, f ( bff) → 0 and bf(p) → 0 as p ↓ 0. Similarly, bw(p) → ∞ as p ↓ 0. By a similar argument for p close to 1, bw(p) → 0 and bf(p) → ∞ as p ↑ 1. Statement (7.46) follows by Lemma 7.65 and the continuity of bw(p) and bf(p), (7.54). This completes the proof of Theorem 7.42.

Proof of Lemma 7.51. We give the proof in the wired case, the other case being similar. Write = βw and let E be co-connected. For any contour γ ⊆ E and

any family of compatible contours in E, we write ⊥ γ if γ ∈/ and ∪{γ} is a compatible family of contours. Since  (γ) is a smooth function of β, is piecewise-differentiable in β (see (7.48)).

![image 796](<rcm1-1_images/imageFile796.png>)

Let α ∈ (0,∞). We prove ﬁrst that the function

1 |E|

logZ(E; βw)

zwE(β,r) =

![image 797](<rcm1-1_images/imageFile797.png>)

![image 798](<rcm1-1_images/imageFile798.png>)

satisﬁes (7.67) zwE(β,r) − zwE(β′,r) ≤ α|β − β′|, β,β′ ∈ [0,∞), forsufﬁcientlylarge q, uniformlyinr and E. We ﬁxr ∈ (0,∞)and shallsuppress reference to r for the moment. If zwE is differentiable at β then, by (7.37),

1 |E|Z(E;  ) ⊂E γ∈

d dβ

zwE =

![image 799](<rcm1-1_images/imageFile799.png>)

![image 800](<rcm1-1_images/imageFile800.png>)

![image 801](<rcm1-1_images/imageFile801.png>)

![image 802](<rcm1-1_images/imageFile802.png>)

 ( )  (γ) · ′(γ),

![image 803](<rcm1-1_images/imageFile803.png>)

![image 804](<rcm1-1_images/imageFile804.png>)

![image 805](<rcm1-1_images/imageFile805.png>)

where g′ denotes the derivative of a function g with respect to β, and g( ) = γ∈ g(γ). Therefore, for any given edge e,

(7.68)

1 |E| γ⊆E

Z1(E \ γ;  ) Z(E;  )

d dβ

![image 806](<rcm1-1_images/imageFile806.png>)

| ′(γ)|

zwE =

![image 807](<rcm1-1_images/imageFile807.png>)

![image 808](<rcm1-1_images/imageFile808.png>)

![image 809](<rcm1-1_images/imageFile809.png>)

![image 810](<rcm1-1_images/imageFile810.png>)

![image 811](<rcm1-1_images/imageFile811.png>)

| ′(γ)| |γ|

![image 812](<rcm1-1_images/imageFile812.png>)

≤

,

![image 813](<rcm1-1_images/imageFile813.png>)

γ: e∈γ

where

 ( ) ≤ Z(E;  ).

Z1(E \ γ;  ) =

![image 814](<rcm1-1_images/imageFile814.png>)

![image 815](<rcm1-1_images/imageFile815.png>)

![image 816](<rcm1-1_images/imageFile816.png>)

⊂E: ⊥γ

Let γ ∈ Cw. We claim that (7.69) | ′(γ)| ≤ 2|γ| (γ)

![image 817](<rcm1-1_images/imageFile817.png>)

![image 818](<rcm1-1_images/imageFile818.png>)

![image 819](<rcm1-1_images/imageFile819.png>)

whenever the derivative exists. By (7.48), either the left side equals 0, or it equals | ′(γ)|, and we may assume that the latter holds. Write Y(γ) = Z(intγ;  ). The function = w β satisﬁes  (γ) =  (γ)Y by (7.41), and also

(7.70) ′(γ) = −|γ| (γ) = −|γ| (γ)Y(γ). Hence, (7.71) ′(γ) =

![image 820](<rcm1-1_images/imageFile820.png>)

![image 821](<rcm1-1_images/imageFile821.png>)

′(γ) −  (γ)Y′(γ) Y(γ) = − (γ) |γ| +

Y′(γ) Y(γ)

.

![image 822](<rcm1-1_images/imageFile822.png>)

![image 823](<rcm1-1_images/imageFile823.png>)

![image 824](<rcm1-1_images/imageFile824.png>)

By an argument similar to that above,

′(ν)  (ν)

d dβ Ŵ⊂intγ

Y′(γ) =

 (Ŵ) =

#####  (Ŵ)

![image 825](<rcm1-1_images/imageFile825.png>)

![image 826](<rcm1-1_images/imageFile826.png>)

Ŵ⊂intγ

ν∈Ŵ

![image 827](<rcm1-1_images/imageFile827.png>)

= −

|Ŵ| (Ŵ),

Ŵ⊂intγ

whence (7.72) |Y′(γ)| ≤ |γ|Y(γ). Claim (7.69) follows from (7.71)–(7.72).

![image 828](<rcm1-1_images/imageFile828.png>)

Returning to (7.68), by (7.69),

(7.73)

d dβ

zwE ≤

![image 829](<rcm1-1_images/imageFile829.png>)

γ: e∈γ

2|γ| |γ|

2|γ| |γ|

![image 830](<rcm1-1_images/imageFile830.png>)

![image 831](<rcm1-1_images/imageFile831.png>)

e−τ γ ,

![image 832](<rcm1-1_images/imageFile832.png>)

 (γ) ≤

![image 833](<rcm1-1_images/imageFile833.png>)

![image 834](<rcm1-1_images/imageFile834.png>)

γ: e∈γ

since is a τ-functional. The Lipschitz inequality (7.67) follows by integration for τ = τ(q) sufﬁciently large.

![image 835](<rcm1-1_images/imageFile835.png>)

More or less the same argument may be used as follows to obtain that

(7.74) zwE(β,r) − zwE(β,r′) ≤ α|r − r′|

, r,r′ ∈ (0,∞),

![image 836](<rcm1-1_images/imageFile836.png>)

r ∧ r′

for large q, uniformly in β and E. We now denote by g′ the derivative of a function g(r) with respect to r. Equation (7.68) remains valid in this new setting. Inequality (7.69) becomes

and (7.73) is replaced by

2 r |γ| (γ)

| ′(γ)| ≤

![image 837](<rcm1-1_images/imageFile837.png>)

![image 838](<rcm1-1_images/imageFile838.png>)

![image 839](<rcm1-1_images/imageFile839.png>)

![image 840](<rcm1-1_images/imageFile840.png>)

2|γ| r|γ|

2|γ| r|γ|

d dr

![image 841](<rcm1-1_images/imageFile841.png>)

![image 842](<rcm1-1_images/imageFile842.png>)

zwE ≤

e−τ γ .

(7.75)

![image 843](<rcm1-1_images/imageFile843.png>)

 (γ) ≤

![image 844](<rcm1-1_images/imageFile844.png>)

![image 845](<rcm1-1_images/imageFile845.png>)

![image 846](<rcm1-1_images/imageFile846.png>)

γ: e∈γ

γ: e∈γ

The right side may be made small by choosing q large, and (7.74) follows by integration.

The claim of the lemma is a consequence of (7.67) and (7.74), on using the triangle inequality and passing to the limit as E ↑ Ed.

Proof of Lemma 7.65. Let p ∈ (0,1) be such that bw = bf = 0, and let r = p/(1 − p). By (7.45), r is a root of the equation h1(r) = h2(r) where

1 d

h1(r) = f ( 0w) + logr, h2(r) = f ( 0f ) +

logq,

![image 847](<rcm1-1_images/imageFile847.png>)

By Lemma 7.51, there exists Q′′′ ≥ Q1 such that, if q > Q′′′,

|r − r′| 8( r − a)

|r − r′| 8( r − a)

, | ff(r) − ff(r′)| ≤

| fw(r) − fw(r′)| ≤

,

![image 848](<rcm1-1_images/imageFile848.png>)

![image 849](<rcm1-1_images/imageFile849.png>)

for r,r′ ≥ r − a. Hence, by (7.76),

1 2 ·

r2 − r1 4( r − a) ≤

r2 − r1 r

|δ(r2) − δ(r1)| ≤

.

![image 850](<rcm1-1_images/imageFile850.png>)

![image 851](<rcm1-1_images/imageFile851.png>)

![image 852](<rcm1-1_images/imageFile852.png>)

This contradicts (7.77), whence such distinct r1, r2 do not exist.

Proof of Theorem 7.33. Let p ∈ (0,1) and q > Q where Q, τ = τ(q), bw = bw(p,q), bf = bf(p,q), and p = p(q) are given as in Theorem 7.42. Let be a box of Ld, and let φ1 (respectively, φ0 ) be the wired random-cluster measure on E generated by the partition function Z1(E ) of (7.10) (respectively, the free measure generated by the partition function Z0(E ) of (7.11)).

Consider ﬁrst the wired measure φ1 . As in (7.21), there exists a family of maximal closed wired contours Ŵ of E (maximal in the sense of the partial order γ1 ≤ γ2 if γ1 ⊆ γ2) and, by (7.40)–(7.41), Ŵ has law

![image 853](<rcm1-1_images/imageFile853.png>)

![image 854](<rcm1-1_images/imageFile854.png>)

1 Z( ; bww,bw)

κ ,bww(Ŵ) =

ebw|Ŵ| bw

![image 855](<rcm1-1_images/imageFile855.png>)

w (Ŵ).

![image 856](<rcm1-1_images/imageFile856.png>)

Let p ≥ p, so that bw = 0. Then κ ,bww = κ ,0 w is the law of the family of maximal contours in the wired contour model on with weight function 0w.

Let x, y ∈ , and consider the event F (x, y) = {x ↔ y, x ↔/ ∂ }.

If F (x, y) occurs, then x, y ∈ Vintγ for some maximal closed wired contour γ. This event has the same probability as the event that x, y ∈ Vintν for some contour ν of the wired contour model with weight function 0w. Therefore,

(7.78) φ1 (F (x, y)) ≤ κ ,0 w(x, y ∈ Vintν for some contour ν) ≤

0 w(ν)

ν: x,y∈Vintν

e−τ ν ,

≤

ν: x,y∈Vintν

by Theorem 7.32 and the fact that 0w is a τ-functional. The numberof such wired contours ν with ν = n grows at most exponentially in n. The leading term in the aboveseries arises from the contour ν having smallest ν , and such ν satisﬁes

[7.5] Discontinuous phase transition for large q 193

ν ≥ b(1 + |x − y|) for some absolute constant b > 0. We may therefore ﬁnd absolute constants Q′ ≥ Q and a > 0 such that, for q ≥ Q′, (7.79) φ1 (F (x, y)) ≤ e−aτ(1+|x−y|).

Take x = y in (7.79), and let ↑ Zd to obtain by Proposition 5.11 that

φp1,q(x ↔/ ∞) < 1 whence p ≥ pc(q). It follows that (7.80) p ≥ pc(q).

Considernextthefreemeasure φ0 . Let p ≤ p, sothatbf = 0. Byanadaptation of the argument above, there exists Q′′ ≥ Q′ and k > 0 such that, for q ≥ Q′′, x, y ∈ Zd, and all large ,

(7.81) φ0 (x ↔ y) ≤ e−kτ|x−y|.

By Proposition 5.12 applied to φp0,q,

(7.82) φ0 (x ↔ y) ≤ e−kτ|x−y|, x, y ∈ Zd.

φp0,q(x ↔ y) = lim

↑Zd

Hence p ≤ pc(q), and so (7.83) p ≤ pc(q). By (7.80) and (7.83), p = pc(q). By (7.82), there is exponential decay of connectivity11 for p ≤ pc(q), and a non-vanishing mass gap.

Parts (b) and (d) of the theorem have been proved for q ≥ Q′′. Part (b) implies

that φ0pc(q),q  = φ1pc(q),q, and hence (a) via Theorem 4.63. The uniqueness of random-cluster measures holds generally when p < pc(q), Theorem 5.33. The proof of uniqueness when p > pc(q) has much in common with the proofs of Proposition 5.30 and Theorem 11.40, and so we present a sketch only.

Letq ≥ Q′′ and p ∈ (pc(q),1). Weshallshowthath1(p,q) = φp1,q(e is open) satisﬁes (7.84) h1(p − ǫ,q) ↑ h1(p,q) as ǫ ↓ 0, and the claim will follow by Proposition 4.28(b) and Theorem 4.63.

![image 857](<rcm1-1_images/imageFile857.png>)

11The related issue of ‘restricted complete analyticity’ is considered in [110] for the case of two dimensions.

Letǫ be such that pc(q) < p−ǫ < p, and letη ∈ (0,1). Write φn1,p = φ1 n,p,q

where n = [−n,n]d. For n > 23m ≥ 2, let Em,n be the event that, for every x ∈ ∂ m, if ν = νx is a maximal closed wired contour of n with x ∈ Vintν, then

![image 858](<rcm1-1_images/imageFile858.png>)

ν ⊆ x + E m/4. As in (7.78)–(7.79), there exists γ = γ(q) > 0 such that

φn1,p−ǫ(Em,n) ≥ 1 − |∂ m|e−γm, and we choose m = m(q) ≥ 8 such that

(7.85) φn1,p−ǫ(Em,n) > 1 − η, n > 32m.

![image 859](<rcm1-1_images/imageFile859.png>)

Let z denote the vertex (1,0,0,. . . ,0). A cutset σ of m is deﬁned to be a subsetof m\{0, z} such that: everypath fromeither0 or z to ∂ m passesthrough at least one vertex in σ, and σ is minimal with this property. For any cutset σ, we write int(σ) for the set of vertices reachable from either 0 and z along paths not

intersecting σ, and out(σ) = Zd \ int(σ). For n > 23m and a cutset σ, we write ‘σ  ⇒ ∂ n in ω’ if every vertex in σ is connected to ∂ n by an ω-open path of out(σ). We shall see below that, for ω ∈ Em,n, there exists a (random) cutset

![image 860](<rcm1-1_images/imageFile860.png>)

=  (ω) ⊆ m \ m/2 such that  ⇒ ∂ n in ω.

Let e = 0, z and n > 23m. We couple the measures φn1,p−ǫ and φn1,p in such a way that the ﬁrst lies beneath the second, and we do this by a sequential examination of the (paired) states of edges in n. We will follow the recipe of the proof of Theorem 3.45 (see also Proposition 5.30), but subject to a special ordering of the edges. The outcome will be a pair ω0,ω1 ∈ 1 n such that: ω0 has law φn1,p−ǫ, ω1 has law φn1,p, and ω0 ≤ ω1. First, we determine the states ω0(e), ω1(e) of edges e with both endvertices in n \ m−1, using some arbitrary ordering of these edges. If ∂ m  ⇒ ∂ n in ω0, we set = ∂ m and we complete the construction of ω0 and ω1 according to an arbitrary ordering of the remaining edges in m.

![image 861](<rcm1-1_images/imageFile861.png>)

Suppose that ∂ m  ⇒/ ∂ n in ω0. Let A be the set of edges in ∂ m that are closed in ω0. If A = ∅, we sample the states of the remaining edges of m in an arbitrary order as above. Suppose A  = ∅. Pick f ∈ A, and sample the states of edges in the (d − 2)-connected closed cluster Ff = Ff (ω0) of f in the lower conﬁguration ω0. When this has been done for every f ∈ A, we complete the construction of ω0 and ω1 according to an arbitrary ordering of the remaining edges in m.

In examining the statesofedgesin Ff we willdiscovera set  (Ff )of edges,not belonging to Ff but (d −2)-connected to Ff , such that ω0(g) = 1 for g ∈  (Ff ). Let v, f be the set of all vertices v ∈ n lying in the inﬁnite component of (Zd,Ed \ Ff ) and such that there exists w ∈ n with v,w ∈  (Ff ) ∪ Ff . Let

e, f be the set of edges of Ff joining pairs of vertices in v, f . By Theorem 7.6, the graph ( v, f , e,f ) is connected.

Suppose ω0 ∈ Em,n. By the above, ∂ m ∪ f∈A v, f contains a (random) cutset =  (ω0) such that:  ⇒ ∂ n in ω0 and, conditional on and the

states of edges of out( ), the coupled conditional measures of φn1,p−ǫ and φn1,p on the remaining edges of ∪ int( ) are the appropriate wired measures.

Therefore, hn(p) = φn1,p(Je) satisﬁes

φσ,1 p(Je) − φσ,1 p−ǫ(Je) φn1,p−ǫ(  = σ) ≤ η + max

hn(p) − hn(p − ǫ) ≤ η +

σ∈C

φσ,1 p(Je) − φσ,1 p−ǫ(Je) ,

σ∈C

where C is the set of all cutsets of m and φσ,1 p denotes the wired random-cluster measure on σ ∪ int(σ). Since m is ﬁxed, C is bounded, and (7.84) follows on letting n → ∞, ǫ ↓ 0, and η ↓ 0 in that order.

Proof of Theorem7.34. Let q be large. Then pc(q) = r′/(1+r′) wherer′ is given in Lemma 7.65 and satisﬁes (7.66). Let p = pc(q). By (7.44) and ‘Theorem’ 7.27, f ( 0f ), f ( 0w) → 0 as q → ∞, and therefore r′ ∼ q1/d. We sketch a derivation of the errortermO(q−2/d). The rate atwhich f ( 0f ) → 0 (respectively,

f ( 0w) → 0) is determined by the value 0f (γf) (respectively, 0w(γw)) on the smallest free contour γf (respectively, smallest wired contour γw). The smallest free contour is the external edge-boundary γf of a single edge, and it is easily seen from (7.41) that 0f (γf) = r′q−1 ∼ q−1+(1/d). The shortest wired contour γw is a single edge, and 0w(γw) = 1/r′ ∼ q−1/d. By (7.24), as q → ∞,

f ( 0w) = O(q−1/d), f ( 0f ) = O(q−1+(1/d)), and the claim follows by (7.66).

7.6 Dobrushin interfaces

Until now in this chapter we have studied the critical random-cluster model for large q. We turn now to the model with q ∈ [1,∞) and with large p, and we prove the existence of so-called Dobrushin interfaces.

Consider for illustration the Ising model on Z3 with ‘inverse-temperature’ β and zero external-ﬁeld. There is a critical value βc marking the point at which long-range correlations cease to decay to zero. As β increases to ∞, pairs of vertices have an increasing propensity to acquire the same state, either both + or both −. Suppose we are working on a large cube L = [−L, L]3, to the boundary of which we give a so-called ‘Dobrushin boundary condition’; that is, the upper boundary ∂+ L = {x ∈ ∂ L : x3 > 0} is allocated the spin +, and the lower boundary ∂− L = {x ∈ ∂ L : x3 ≤ 0} receives spin −. There is a competition between the + spins and the − spins. There is an ‘upper’ domain of + spins containing ∂+ L, and a ‘lower’ domain of − spins containing ∂− L, and these domains are separated by a (random) interface = L. It is a famous

196 Duality in Higher Dimensions [7.6]

result of Dobrushin, [103], that, for large β in the limit as L → ∞, L deviates only locally from the horizontal plane through the centre of L. This implies in particular that there exist non-translation-invariant Gibbs measures for the threedimensional Ising model with large β. The argument is valid in all dimensions of three or more, but not in two dimensions, for which case the interface may be thought of as a line subject to Gaussian ﬂuctuations (see [127, 137, 187]).

Dobrushin’s proof was the starting point for the study of interfaces in spin systems. His conclusions may be reformulated and generalized in the context of the random-cluster model in three or more dimensions with q ∈ [1,∞). This generalization of Dobrushin’s theorem is achieved by deﬁning a family of conditioned random-cluster measures, and by showing the stiffness of the ensuing interface. It is a striking fact that the conclusions hold even for the percolation model.

When cast in the more general setting of the random-clustermodel on a box , the correct interpretation of the boundary condition is as follows. The vertices on the upper (respectively, lower) hemisphere of are wired together into a single composite vertex labelled ∂+ (respectively, ∂− ). Let D be the event that no open path of exists joining ∂− to ∂+ , and let φ ,p,q be the random-cluster measure on with the above boundary condition and conditioned on the event D. It is a geometrical fact that, under φ ,p,q, there exists an interface separating an upper region of containing ∂+ and a lower region containing ∂− , and each of these regions is in the wired phase. Dobrushin’s theorem amounts to the statement that, when q = 2 and p is sufﬁciently large, this interface deviates only locally from the horizontal plane through the equator of . It was proved in [139] that the same conclusion is valid for all q ∈ [1,∞) and all sufﬁciently large p, and this result is presented in the remainder of this chapter. The geometry of the interfaces for the random-cluster model is notably different from that of a spin model since the conﬁgurations are indexed by edges rather than by vertices, and this leads to difﬁculties not encountered in the Ising model.

![image 862](<rcm1-1_images/imageFile862.png>)

![image 863](<rcm1-1_images/imageFile863.png>)

Although such arguments are valid whenever d ≥ 3, we shall assume for simplicity that d = 3. It is striking that the results are valid for high-density percolation on Zd with d ≥ 3, being the random-cluster model with q = 1. A corresponding question for supercritical percolation in two dimensions has been studied in depth in [77], where it is shown effectively that the (one-dimensional) interface converges when re-scaled to a Brownian bridge.

We have spoken above of interfaces which ‘deviate only locally’ from a plane, an expression made more rigorous in Section 7.11 where the principal Theorem 7.142 is presented. We include at Theorem 7.87 a weaker version of the main result which does not make use of the notation developed in later sections.

Theresultsareprovedundertheassumptionthat q ∈ [1,∞)and pissufﬁciently large. It is a majoropen questionto determine whetheror not such results are valid underthe weakerassumption that pexceedsthe criticalvalue pc(q)of the randomcluster model. The answer may be expected to depend on the value of q and the number d of dimensions. Since the percolation measure φ ,p,1 is a conditioned product measure, it may be possible to gain insight into the existence or not of

![image 864](<rcm1-1_images/imageFile864.png>)

such a ‘rougheningtransition’ by concentrating on the special case of percolation. The two core problems here are the following. Let p(q) be the inﬁmum of all values of p at which the above interface is localized (a rigorous interpretation of this deﬁnition is evident after reading Theorems 7.87 and 7.142).

![image 865](<rcm1-1_images/imageFile865.png>)

I. Is it the case that the interface is localized for all p > p(q)? II. For what q and d does strict inequality of critical points hold in the sense that pc(q) < p(q)?

![image 866](<rcm1-1_images/imageFile866.png>)

![image 867](<rcm1-1_images/imageFile867.png>)

In the case of the Ising model (q = 2), it is generally believed that pc(2) < p(2) if and only if d = 3.

![image 868](<rcm1-1_images/imageFile868.png>)

A certain amount of notation and preliminary work is required before the main theoremsmay be stated (in Section 7.11). In orderto whet appetites, a preliminary result is included towards the end of the current section. Sections 7.7–7.8 contain some preliminary facts about random-cluster measures and interfaces. A detailed geometrical analysis of interfaces is included in Section 7.9 along the lines of Dobrushin’s classiﬁcation of ‘walls’ and ‘ceilings’. This is followed in Section 7.10 by an exponential bound for the probability of ﬁnding local perturbations of a ﬂat interface.

The upper and lower boundaries of a set of vertices are deﬁned as

∂+ = {x ∈ : x3 > 0, x ∼ z for some z ∈ }, ∂− = {x ∈ : x3 ≤ 0, x ∼ z for some z ∈ },

![image 869](<rcm1-1_images/imageFile869.png>)

![image 870](<rcm1-1_images/imageFile870.png>)

where = Zd \ . For positive integers L, M, let L,M denote the box [−L, L]2 × [−M, M], and write EL,M for the set of edges having at least one endvertex in L,M. We write L = L,L, the cube of side-length 2L, and

![image 871](<rcm1-1_images/imageFile871.png>)

L = [−L, L]2 ×Z, an inﬁnite cylinder. The equator of the box M,N is deﬁned

to be the circuit of L,M \ L−1,M comprising all vertices x with x3 = 21, with a similar deﬁnition for the cylinder L.

![image 872](<rcm1-1_images/imageFile872.png>)

We shall be particularly concerned with a boundary condition D corresponding to the mixed ‘Dobrushin boundary’ of [103]. Let D ∈ be given by (7.86)

0 if e = x, y for some x = (x1, x2,0) and y = (x1, x2,1), 1 otherwise.

D(e) =

See Figure 7.4. Let DL,M be the set of conﬁgurations ω ∈ such that ω( f ) = D( f ) if f ∈/ EL,M, and let IL,M be the event that there exists no open path connecting a vertex of ∂+ L,M to a vertex of ∂− L,M. The probability measure of current interest is the random-cluster measure φD M,N,p,q conditioned on the event IL,M, which we denote by φD L,M,p,q.

![image 873](<rcm1-1_images/imageFile873.png>)

Many of the calculations concern the box L,M and the measure φD L,M,p,q. We choose however to express our conclusions in terms of the inﬁnite cylinder

![image 874](<rcm1-1_images/imageFile874.png>)

L = L,∞ and the weak limit φL,p,q = limM→∞ φD L,M,p,q.

![image 875](<rcm1-1_images/imageFile875.png>)

![image 876](<rcm1-1_images/imageFile876.png>)

consequence of Theorems 7.87 and 7.142 that, for sufﬁciently large p, any such weak limit is non-translation-invariant.

(7.89) Theorem [139]. Let q ∈ [1,∞) and p > p(21), where p(21) is given in Theorem 7.87. The family {φL,p,q : L = 1,2,. . .} possesses at least one non-translation-invariant weak limit.

![image 877](<rcm1-1_images/imageFile877.png>)

![image 878](<rcm1-1_images/imageFile878.png>)

![image 879](<rcm1-1_images/imageFile879.png>)

It is shown in addition at Theorem 7.144 that there exists a geometric bound, uniformly in L, on the tail of the displacement of the interface from the ﬂat plane.

By making use of the relationship between random-cluster models and Potts models (see Sections 1.4 and 4.6), one obtains a generalization of the theorem of Dobrushin [103] to include percolation and Potts models.

The measure φL,p,q is not a random-cluster measure in the sense of Chapter 3, even though it corresponds to a Gibbs measure when q ∈ {2,3,. . .}. It may instead be termed a ‘conditioned’ random-cluster measure, and such measures will be encountered again in Chapter 11.

![image 880](<rcm1-1_images/imageFile880.png>)

The strategy of the proofs is to follow the milestones of the paper of Dobrushin [103]. Although Dobrushin’s work is a helpful indicator of the overall route to the results, a considerable amount of extra work is necessary in the context of the random-cluster model, much of which arises from the fact that the geometry of interfaces is different for the random-cluster model from that for spin systems. Heavy use is made in the remainder of this chapter of the material in [139].

7.7 Probabilistic and geometric preliminaries

We shall require two general facts about random-cluster measures, and we state these next. The ﬁrst is a formula for the partition function in terms of the edge densities. For E ⊆ E3, let VE denote the set of endvertices of members of E. As usual, Je denotes the event that the edge e is open, and ZGζ (p,q) is given as in (4.12). Let ζE1 be the conﬁguration obtained from ζ ∈ by declaring every edge in E to be open, and k(ζE1, E) the number of components of ζE1 that intersect VE. (7.90) Lemma. Let E be a ﬁnite subset of E3, and G = (VE, E). Then

log ZGζ (p,q) = k(ζE1, E)logq +

gGζ ,p,q(e), ζ ∈  , where

e∈E

r − φGζ ,r,q(Je) r(1 − r)

1

(7.91) gGζ ,p,q(e) =

dr.

![image 881](<rcm1-1_images/imageFile881.png>)

p

Proof. As in the proofs of Theorems 3.73 and 4.58,

d dr

log ZGζ (r,q) =

![image 882](<rcm1-1_images/imageFile882.png>)

e∈E

φGζ ,r,q(Je) − r r(1 − r)

.

![image 883](<rcm1-1_images/imageFile883.png>)

200 Duality in Higher Dimensions [7.7]

This we integrate from p to 1, noting that log ZGζ (1,q) = k(ζE1, E)logq. Let q ∈ [1,∞). By Theorem 3.1, r

r + q(1 − r) ≤ φGζ ,r,q(Je) ≤ r. By substitution into (7.91),

![image 884](<rcm1-1_images/imageFile884.png>)

(7.92) 0 ≤ gGζ ,p,q(e) ≤

1

(q − 1)dr = (1 − p)(q − 1), e ∈ E,

p

uniformly in E and ζ. The above inequalities are reversed if q < 1.

Let n = n,n and write n(e) = e + n for the set of translates of the endvertices of the edge e by vectors in n.

(7.93) Lemma. Let q ∈ [1,∞). There exists p∗ = p∗(q) < 1 and a constant α > 0 such that the following holds. Let E1 and E2 be ﬁnite edge-sets of L3 such that e ∈ E1 ∩ E2, and let n ≥ 1 be such that E1 ∩ n(e) = E2 ∩ n(e). If p > p∗,

gG1 1,p,q(e) − gG1 2,p,q(e) ≤ e−αn,

where Gi = (VEi, Ei). Proof. Let Ke be the event that the endverticesof the edge e are joined by an open path of Ed \ {e}. By (3.3),

(q − 1)(1 − φG1 ,r,q(Ke)) r + q(1 − r)

r − φG1 ,r,q(Je) r(1 − r) =

,

![image 885](<rcm1-1_images/imageFile885.png>)

![image 886](<rcm1-1_images/imageFile886.png>)

whence

(7.94) gG1 1,p,q(e) − gG1 2,p,q(e) ≤

1

(q − 1) r + q(1 − r)

φG1 1,r,q(Ke) − φG1 2,r,q(Ke) dr.

![image 887](<rcm1-1_images/imageFile887.png>)

p

Let n ≥ 1. We pursue the method of proof of Theorem 5.33(b), and shall use the notation therein. Let V be the set of vertices that are incident in L3 to edges of both n(e) and its complement. We deﬁne B to be the union of V together with all vertices x0 ∈ Z3 for which there exists a path x0, x1,. . ., xm of L such that x0, x1,. . ., xm−1 ∈/ V, xm ∈ V, and x0, x1,. . ., xm−1 are black. Let Wn be the event that there exists no x ∈ B such that x − z ≤ 10, say, where z is the centre of e. By (5.36)–(5.37) together with estimates at the beginning of the proof of [211, Lemma (2.24)],

(7.95) φ0 n(e),r,q(Wn) ≥ 1 − cn(1 − ρ)en,

where c and e are absolute positive constants, and ρ = r/[r + q(1 − r)]. Since Wn is an increasing event,

(7.96) φG1 1,r,q(Wn) ≥ 1 − cn(1 − ρ)en. Let H = E1 ∩ n(e). As in the proof of Theorem 5.33, and by coupling,

0 ≤ φ1H,r,q(Ke) − φG1 1,r,q(Ke) ≤ 1 − φG1 1,r,q(Wn). The claim follows by (7.94), (7.96), and the triangle inequality.

As explained in Sections 7.1–7.2, the dual of the random-cluster model on L3 is a certain probability measure associated with the plaquettes of the dual lattice L3d. The straight line-segment joining the vertices of an edge e = x, y passes through the middle of exactly one plaquette, denoted by h(e), which we call the dual plaquette of e. We declare this plaquette open (respectively, closed) if e is closed (respectively, open), see (7.9). The plaquette h(e) is called horizontal if y = x + (0,0,±1), and vertical otherwise.

The regular interface of L3 is the set δ0 of plaquettes given by δ0 = h ∈ H : h = h( x, y ) for some x = (x1, x2,0) and y = (x1, x2,1) .

The interface  (ω) of a conﬁguration ω ∈ IL,M ∩ DL,M is deﬁned to be the maximal 1-connected set of open plaquettes containing the plaquettes in the set

δ0 \ {h(e) : e ∈ EL,M}. The set of all interfaces is

(7.97) DL,M =  (ω) : ω ∈ IL,M ∩ DL,M .

It is tempting to think of an interface as part of a deformed plane. Interfaces may however have more complex geometry involving cavities and attachments, see Figure 7.4. The following proposition conﬁrms that the interfaces in DL,M separate the top of L,M from its bottom.

(7.98) Lemma. The event IL,M ∩ DL,M comprises those conﬁgurations ω ∈ D L,M for which there exists δ ∈ DL,M satisfying: ω(e) = 0 whenever h(e) ∈ δ.

For δ ∈ DL,M, we deﬁne its extended interface (or closure) δ to be the set (7.99) δ = δ ∪ h ∈ H : h is 1-connected to some member of δ . See (7.4). It will be useful to introduce the ‘maximal’ (denoted by ωδ) and ‘minimal’ (denoted by ωδ) conﬁgurations in DL,M that are compatible with δ:

![image 888](<rcm1-1_images/imageFile888.png>)

![image 889](<rcm1-1_images/imageFile889.png>)

![image 890](<rcm1-1_images/imageFile890.png>)

![image 891](<rcm1-1_images/imageFile891.png>)

(7.100) ωδ(e) =

![image 892](<rcm1-1_images/imageFile892.png>)

0 if e ∈ δ, 1 otherwise,

 

ωδ(e) =



![image 893](<rcm1-1_images/imageFile893.png>)

D(e) if e ∈/ EL,M, 1 if e ∈ EL,M ∩ (δ \ δ), 0 otherwise.

![image 894](<rcm1-1_images/imageFile894.png>)

Proof of Lemma 7.98. If ω ∈ IL,M ∩ DL,M, then ω(e) = 0 whenever h(e) ∈  (ω). Suppose conversely that δ ∈ DL,M, and let ω ∈ DL,M satisfy ω(e) = 0 whenever h(e) ∈ δ. Since ω ≤ ωδ, it sufﬁces to show that ωδ ∈ IL,M. Since δ ∈ DL,M, there exists ξ ∈ IL,M ∩ DL,M such that δ =  (ξ). Note that ξ ≤ ωδ. Suppose for the sake of obtaining a contradiction that ωδ ∈/ IL,M, and think of ωδ as being obtained from ξ by declaring, in turn, a certain sequence e1,e2,. . . ,er with ξ(ei) = 0, i = 1,2,. . .,r, to be open. Let ξk be obtainedfrom ξ by η(ξk) = η(ξ) ∪ {e1,e2,. . . ,ek}. By assumption, there exists K such that ξK ∈ IL,M but ξK+1 ∈/ IL,M. For ψ ∈ DL,M, let J(ψ) denote the set of edges e having endvertices in L,M, with ψ(e) = 1, and both of whose endvertices are attainable from ∂+ L,M by open paths of ψ. We apply Theorem 7.3 to the ﬁnite connected graph induced by J(ξK) to ﬁnd that there exists a splitting set Q of plaquettes such that: ∂+ L,M ⊆ ins([Q]), ∂− L,M ⊆ out([Q]), and ξK(e) = 0 whenever e ∈ EL,M and h(e) ∈ Q. It must be the case that h(eK+1) ∈ Q, since ξK+1 ∈/ IL,M. By the 1-connectedness of Q, there exists a sequence

![image 895](<rcm1-1_images/imageFile895.png>)

![image 896](<rcm1-1_images/imageFile896.png>)

![image 897](<rcm1-1_images/imageFile897.png>)

![image 898](<rcm1-1_images/imageFile898.png>)

![image 899](<rcm1-1_images/imageFile899.png>)

f1 = eK+1, f2, f3,. . . , ft of edges such that: (i) h( fi) ∈ Q for all i, (ii) fi ∈ EL,M for i = 1,2,. . .,t − 1, ft = h( x, x − (0,0,1) ) for some x = (x1, x2,1) ∈ ∂+ L,M, and

(iii) h( fi) ∼1 h( fi+1) for i = 1,2,. . .,t − 1. It follows that h( fi) ∈ δ for i = 1,2,. . . ,t. In particular, h(eK+1) ∈ δ and so ωδ(eK+1) = 0, a contradiction. Therefore ωδ ∈ IL,M as claimed.

![image 900](<rcm1-1_images/imageFile900.png>)

![image 901](<rcm1-1_images/imageFile901.png>)

7.8 The law of the interface

For conciseness of notation, we abbreviate φD L,M,p,q to φL,M, and φD L,M,p,q to φL,M. Let δ ∈ DL,M. The better to study φL,M(δ) = φL,M(  = δ), we develop next an expression for this probability. Consider the connected components of the graph (Z3,η(ωδ)), and denote these components by (Sδi,Uδi), i = 1,2,. . .,kδ, where kδ = k(ωδ). Note that Uδi is empty whenever Sδi is a singleton. Let W(δ) be the edge-set EL,M \ {e ∈ E3 : h(e) ∈ δ}.

![image 902](<rcm1-1_images/imageFile902.png>)

![image 903](<rcm1-1_images/imageFile903.png>)

![image 904](<rcm1-1_images/imageFile904.png>)

![image 905](<rcm1-1_images/imageFile905.png>)

![image 906](<rcm1-1_images/imageFile906.png>)

Let ω ∈ IL,M ∩ DL,M be such that  (ω) = δ, so that

(7.101) ω(e) =

0 if h(e) ∈ δ, 1 if h(e) ∈ δ \ δ.

![image 907](<rcm1-1_images/imageFile907.png>)

Let D be the set of edges with both endvertices in L+2,M+2 that either are dual to plaquettes in δ or join a vertex of L+1,M+1 to a vertex of ∂ L+2,M+2. We apply Theorem 7.5 to the set D, and deduce that there are exactly kδ components of the graph (Z3,η(ω)) having a vertex in V(δ).

![image 908](<rcm1-1_images/imageFile908.png>)

We have that

1 Z(EL,M)

![image 909](<rcm1-1_images/imageFile909.png>)

(7.102) p|δ\δ|(1 − p)|δ|

φL,M(δ) =

![image 910](<rcm1-1_images/imageFile910.png>)

pω(e)(1 − p)1−ω(e) qk(ω)

×

e∈W(δ)

ω∈ DL,M:  (ω)=δ

Z1(δ) Z(EL,M)

p|δ\δ|(1 − p)|δ|qkδ−1,

![image 911](<rcm1-1_images/imageFile911.png>)

=

![image 912](<rcm1-1_images/imageFile912.png>)

where Z(EL,M) = ZD L,M(p,q) and Z1(δ) = ZW1 (δ)(p,q). In this expression and later, for H ⊆ H, |H| is the cardinality of the set H ∩ {h(e) : e ∈ EL,M}. The term qkδ−1 arises since the application of ‘1’ boundary conditions to δ has the effect of uniting the boundaries of the cavities of δ, whereby the number of clusters diminishes by kδ − 1.

For x ∈ Z3, we denote by τx : Z3 → Z3 the translate given by τx(y) = x + y. The translate τx acts on edges and subgraphs of L3 in the natural way, see Section 4.3. For sets A, B of edges or vertices of L3, we write A ≃ B if B = τx A for some x ∈ Z3. Note that two edges e, f satisfy {e} ≃ { f } if and only if they are parallel, in which case we write e ≃ f .

We shall exploit properties of the partition functions Z(·) in order to rewrite (7.102). For i = 1,2, let Li, Mi > 0, δi ∈ DLi,Mi, and ei ∈ E(δi) ∩ ELi,Mi, and (7.103) G(e1,δ1, EL1,M1; e2,δ2, EL2,M2)

= sup L : L(e1) ∩ EL1,M1 ≃ L(e2) ∩ EL2,M2 and L(e1) ∩ E(δ1) ≃ L(e2) ∩ E(δ2)

,

where L(e) = e + L as before. Let Z1(EL,M) = Z1 L,M(p,q). (7.104) Lemma. Let L, M ≥ 1 and δ ∈ DL,M. We may write φL,M(δ) as (7.105)

Z1(EL,M) Z(EL,M)

p|δ\δ|(1 − p)|δ|qkδ−1 exp

![image 913](<rcm1-1_images/imageFile913.png>)

fp(e,δ, L, M) ,

φL,M(δ) =

![image 914](<rcm1-1_images/imageFile914.png>)

e∈E(δ)∩EL,M

for functions fp(e,δ, L, M) with the following properties. For q ∈ [1,∞), there exist p∗ < 1 and constants C1, C2, γ > 0 such that, if p > p∗,

- (7.106) | fp(e,δ, L, M)| < C1, fp(e1,δ1, L1, M1) − fp(e2,δ2, L2, M2) ≤ C2e−γG, e1 ∈ δ1, e2 ∈ δ2, e1 ≃ e2,
- (7.107)


where G = G(e1,δ1, EL1,M1; e2,δ2, EL2,M2). Inequalities (7.106) and (7.107) are valid for all relevant values of their arguments.

Proof. By Lemma 7.90, (7.108)

Z1(δ) Z1(EL,M) =

log

![image 915](<rcm1-1_images/imageFile915.png>)

f ∈W(δ)

g( f, EL,M),

g( f, W(δ)) − g( f, EL,M) −

f ∈E(δ)

![image 916](<rcm1-1_images/imageFile916.png>)

where g( f, D) = g1D,p,q( f ). The summations may be expressed as sums over edges e ∈ E(δ) in the following way. The set E3 may be ordered according to the lexicographic ordering of the centres of edges. Let f ∈ EL,M and δ ∈ DL,M. Amongst all edges in E(δ) ∩ EL,M that are closest to f (in the sense that their centresare closest in the L∞ norm), let ν( f,δ) be the earliest edgein this ordering. By (7.108),

(7.109) log

Z1(δ) Z1(EL,M) =

fp(e,δ, L, M)

![image 917](<rcm1-1_images/imageFile917.png>)

e∈E(δ)∩EL,M

where (7.110)

fp(e,δ, L, M) =

f ∈W(δ): ν( f,δ)=e

g( f, EL,M).

g( f, W(δ)) − g( f, EL,M) −

f ∈E(δ): ν( f,δ)=e

![image 918](<rcm1-1_images/imageFile918.png>)

This implies (7.105) via (7.102).

It remains to show (7.106)–(7.107). Let e = ν( f,δ) and set r = e, f . Then r−2( f ) does not intersect δ, implying by Lemma 7.93 that

![image 919](<rcm1-1_images/imageFile919.png>)

(7.111) g( f, W(δ)) − g( f, EL,M) ≤ e−α e, f +2α, p > p∗,

where p∗ and α are given as in that lemma. Secondly, there exists an absolute constant K such that, for all e and δ, the number of edges f ∈ E(δ) with e = ν( f,δ) is no greater than K. Therefore, by (7.92),

![image 920](<rcm1-1_images/imageFile920.png>)

| fp(e,δ, L, M)| ≤

e−α e,f +2α + K(1 − p)(q − 1)

f ∈E3

as required for (7.106).

Finally, we show (7.107) for p > p∗ and appropriate C2, γ. Let e ∈ δ1, e2 ∈ δ2, and let G be given by (7.103); we may suppose that G > 9. By assumption, e1 ≃ e2, whence there exists a translate τ of L3 such that τe1 = e2. For f ∈ W(δ1) ∩ G/3(e1),

(7.112) τ[ G/3( f ) ∩ EL1,M1] = G/3(τ f ) ∩ EL2,M2, (7.113) τ[ G/3( f ) ∩ δ1] = G/3(τ f ) ∩ δ2,

and

(7.114) for f,e1 ≤ 31G, ν( f,δ1) = e1 if and only if ν(τ f,δ2) = e2. By the deﬁnition (7.110) of the functions fp,

![image 921](<rcm1-1_images/imageFile921.png>)

(7.115)

fp(e1,δ1, L1, M1) − fp(e2,δ2, L2, M2)

g( f, W(δ1)) − g(τ f, W(δ2))

≤

+ g( f, EL1,M1) − g(τ f, EL2,M2)

f ∈W(δ1)∩ G/3(e1): ν( f,δ1)=e1

g( f, W(δ1)) − g( f, EL1,M1)

+

f ∈W(δ1)\ G/3(e1): ν( f,δ1)=e1

g( f, W(δ2)) − g( f, EL2,M2) + S,

+

f ∈W(δ2)\ G/3(e2): ν( f,δ2)=e2

where

g( f, EL1,M1) −

g( f, EL2,M2) .

S =

f ∈E(δ1): ν( f,δ1)=e1

f ∈E(δ2): ν( f,δ2)=e2

![image 922](<rcm1-1_images/imageFile922.png>)

![image 923](<rcm1-1_images/imageFile923.png>)

By (7.112)–(7.113)and Lemma 7.93, the ﬁrst summation in (7.115)is bounded

above by 2G3e−31αG. By the deﬁnition of the ν( f,δi), the second and third summations are bounded above, respectively, by

![image 924](<rcm1-1_images/imageFile924.png>)

e−α f,ei +2α ≤ C′e−31αG+2α,

![image 925](<rcm1-1_images/imageFile925.png>)

f ∈/ G/3(ei)

for some C′ < ∞, as in (7.111). By (7.114),

S =

g( f, EL1,M1) − g(τ f, EL2,M2) ≤ Ke−31αG,

![image 926](<rcm1-1_images/imageFile926.png>)

f ∈E(δ1): ν( f,δ1)=e1

![image 927](<rcm1-1_images/imageFile927.png>)

and (7.107) follows for an appropriate choice of γ.

In the second part of this section, we consider measures and interfaces for the inﬁnite cylinder L = L,∞ = [−L, L]2 × Z. Note ﬁrst by stochastic ordering that, if q ∈ [1,∞), then φL,M+1 ≤st φL,M, whence the (decreasing) weak limit

(7.116) φL = lim

φL,M

M→∞

exists. Let DL be the set of all conﬁgurations ω such that ω(e) = D(e) for e ∈/ EL = limM→∞ EL,M, and let IL be the event that no vertex of ∂ +L is joined by an open path to a vertex of ∂ −L . The set of interfaces on which we concentrate isDL = M DL,M = limM→∞ DL,M. Thus,DL isthesetofinterfacesthatspan

L, and every member of DL is bounded in the direction of the third coordinate. It is easy to see that IL ⊇ limM→∞ IL,M, and it is a consequence of the next lemma that the difference between these two events has φL-probability zero.

(7.117) Lemma. Let q ∈ [1,∞). The weak limit φL,M(· | IL,M) ⇒ φL(· | IL) holds as M → ∞, and

IL,M = 0.

φL IL lim

M→∞

For Li > 0, δi ∈ DLi, and ei ∈ E(δi) ∩ ELi, let G(e1,δ1, EL1; e2,δ2, EL2) = G(e1,δ1, EL1,∞; e2,δ2, EL2,∞).

On the event IL, is deﬁned as before to be the maximal 1-connected set of open plaquettes that intersects δ0 \ EL.

#### (7.118) Lemma.

(a) Suppose L > 0, δ ∈ DL, and e ∈ E(δ) ∩ EL. The functions fp given in (7.110) are such that the limit

fp(e,δ, L, M) (7.119) exists. Furthermore, if p > p∗,

fp(e,δ, L) = lim

M→∞

| fp(e,δ, L)| < C1, (7.120) and, for Li > 0, δi ∈ DLi, and ei ∈ E(δi) ∩ ELi satisfying e1 ≃ e2,

fp(e1,δ1, L1) − fp(e2,δ2, L2) ≤ C2e−γG,

where G = G(e1,δ1, EL1; e2,δ2, EL2) and p∗, C1, C2, γ are as in Lemma 7.104.

(b) For q ∈ [1,∞) and δ ∈ DL, the probability φL(δ | IL) = φL(  = δ | IL) satisﬁes

1 ZL

p|δ\δ|(1 − p)|δ|qkδ exp

![image 928](<rcm1-1_images/imageFile928.png>)

fp(e,δ, L) , (7.121)

φL(δ | IL) =

![image 929](<rcm1-1_images/imageFile929.png>)

e∈E(δ)∩EL

where ZL is the appropriate normalizing constant. Proof of Lemma 7.117. It sufﬁces for the claim of weak convergence that (7.122) φL,M(F ∩ IL,M) → φL(F ∩ IL) for all cylinder events F.

Let AL,M = [−L, L]2 × {−M} and BL,M = [−L, L]2 × {M}, and let TL,M be the event that no open path exists between a vertex of ∂ +L,M \ BL,M and a vertex of ∂ −L,M \ AL,M. Note that TL,M → IL as M → ∞. Let F be a cylinder event. Then

(7.123) φL,M(F ∩ IL,M) ≤ φL,M(F ∩ TL,M′) for M′ ≤ M → φL(F ∩ TL,M′) as M → ∞

→ φL(F ∩ IL) as M′ → ∞.

In order to obtain a corresponding lower bound, we introduce the event Kr that all edges of EL, both of whose endvertices have third coordinate equal to ±r, are open. We may suppose without loss of generality that p > 0. By the comparison inequality (Theorem 3.21), φL,M dominates product measure with density π = p/[p + q(1 − p)], whence there exists β = βL < 1 such that

φL,M

R

Kr ≥ 1 − βR, R < M.

r=1

Now IL,M ⊆ TL,M, and TL,M \ IL,M ⊆ r M=−11 Kr, whence (7.124) φL,M(F ∩ IL,M) ≥ φL,M(F ∩ TL,M) − βM−1

![image 930](<rcm1-1_images/imageFile930.png>)

≥ φL,M(F ∩ IL) − βM−1

→ φL(F ∩ IL) as M → ∞.

Equation (7.122) holds by (7.123)–(7.124). The second claim of the lemma follows by taking F = , the entire sample space.

Proof of Lemma 7.118. (a) The existence of the limit follows by the monotonicity of g( f, Di) for an increasing sequence {Di}, and the proof of (7.106). The inequalities are implied by (7.106)–(7.107).

(b) Let δ ∈ DL, so that δ ∈ IL,M for all large M. By Lemma 7.117, φL(δ | IL) = lim

φL,M(δ | IL,M).

M→∞

Let M → ∞ in (7.105), and use part (a) to obtain the claim.

7.9 Geometry of interfaces

A taxonomy of interfaces is required, and this is the topic of this section. Let δ ∈ DL. While it was natural in Section 7.7 to introduce the extended interface δ, it turns out to be useful when studying the geometry of δ to work with its semi-extended interface

![image 931](<rcm1-1_images/imageFile931.png>)

δ∗ = δ ∪ h ∈ H : h is a horizontal plaquette that is 1-connected to δ .

Let x = (x1, x2, x3) ∈ Z3. The projection π(h) of a horizontal plaquette h = h( x, x + (0,0,1) ) onto the regular interface δ0 is deﬁned to be the plaquette

π(h) = h (x1, x2,0),(x1, x2,1) . The projection of the vertical plaquette h = h( x, x + (1,0,0) ) is the interval

π(h) = (x1 + 21, x2 − 12, 21),(x1 + 12, x2 + 21, 21) , and, similarly, h = h( x, x + (0,1,0) ) has projection

![image 932](<rcm1-1_images/imageFile932.png>)

![image 933](<rcm1-1_images/imageFile933.png>)

![image 934](<rcm1-1_images/imageFile934.png>)

![image 935](<rcm1-1_images/imageFile935.png>)

![image 936](<rcm1-1_images/imageFile936.png>)

![image 937](<rcm1-1_images/imageFile937.png>)

π(h) = (x1 − 21, x2 + 21, 21),(x1 + 21, x2 + 12, 21) .

![image 938](<rcm1-1_images/imageFile938.png>)

![image 939](<rcm1-1_images/imageFile939.png>)

![image 940](<rcm1-1_images/imageFile940.png>)

![image 941](<rcm1-1_images/imageFile941.png>)

![image 942](<rcm1-1_images/imageFile942.png>)

![image 943](<rcm1-1_images/imageFile943.png>)

Ahorizontalplaquetteh ofthesemi-extendedinterfaceδ∗iscalledac-plaquette if h is the uniquememberof δ∗ with projection π(h). All otherplaquettesof δ∗ are called w-plaquettes. A ceiling of δ is a maximal 0-connected set of c-plaquettes. The projection of a ceiling C is the set π(C) = {π(h) : h ∈ C}. Similarly, we deﬁne a wall W of δ as a maximal 0-connected set of w-plaquettes, and its projection as

π(W) = π(h) : h is a horizontal plaquette of W .

#### (7.125) Lemma. Let δ ∈ DL.

- (i) The set δ∗ \ δ contains no c-plaquette.
- (ii) All plaquettes of δ∗ that are 1-connectedto some c-plaquette are horizontal plaquettes of δ. All horizontal plaquettes that are 0-connected to some c-plaquette belong to δ∗.
- (iii) Let C be a ceiling. There is a unique plane parallel to the regular interface that contains all the c-plaquettes of C.
- (iv) Let C be a ceiling. Then C = {h ∈ δ∗ : π(h) ⊆ [π(C)]}. (v) Let W be a wall. Then W = {h ∈ δ∗ : π(h) ⊆ [π(W)]}.


- (vi) For each wall W, δ0 \ π(W) has exactly one maximal inﬁnite 0-connected component (respectively, 1-connected component).
- (vii) Let W be a wall, and suppose that δ0 \ π(W) comprises n maximal 0-connected sets H1, H2,. . ., Hn. The set of all plaquettes h ∈ δ∗ \ W


that are 0-connected to W comprises only c-plaquettes, which belong to the union of exactly n distinct ceilings C1,C2,. . .,Cn such that

π(h) : h is a c-plaquette of Ci ⊆ Hi.

(viii) The projections π(W1) and π(W2) of two different walls W1 and W2 of δ∗ are not 0-connected.

(ix) The projection π(W) of any wall W contains at least one plaquette of δ0.

Thedisplacementoftheplanein(iii)fromtheregularinterface,countedpositive or negative, is called the height of the ceiling C.

Proof. (i) Let h be a c-plaquette of δ∗ with π(h) = h0. Since δ ∈ DL, δ contains at least one plaquette with projection h0. Yet, according to the deﬁnition of a c-plaquette, there is no such a plaquette besides h. Therefore h ∈ δ.

(ii) Suppose h is a c-plaquette. Then h belongs to δ, and any horizontal plaquette that is 1-connected to h belongs to δ∗. It may be seen in addition that any vertical plaquette that is 1-connected to h lies in δ \ δ. Suppose, on the contrary, that some such vertical plaquette h′ lies in δ. Then the horizontal plaquettes that are 1-connected to h′ lie in δ∗. One of these latter plaquettes has projection π(h), in contradiction of the assumption that h is a c-plaquette.

![image 944](<rcm1-1_images/imageFile944.png>)

We may now see as follows that any horizontalplaquette h′′ that is 1-connected to h must lie in δ. Suppose, on the contrary, that some such plaquette h′′ lies in δ\δ. We may construct a path of open edges on (Z3,η(ωδ)) connecting the vertex x just above h to the vertex x − (0,0,1) just below h, using the open edges of ωδ corresponding to the three relevant plaquettes of δ \ δ. This contradicts the assumption that h is a c-plaquette of the interface δ.

![image 945](<rcm1-1_images/imageFile945.png>)

![image 946](<rcm1-1_images/imageFile946.png>)

![image 947](<rcm1-1_images/imageFile947.png>)

![image 948](<rcm1-1_images/imageFile948.png>)

The second claim of (ii) follows immediately, by the deﬁnition of δ∗.

- (iii) The ﬁrst part follows by the deﬁnition of ceiling, since the only horizontal plaquettesthatare0-connectedwithagivenc-plaquetteh lieintheplanecontaining h.
- (iv) Assume that h ∈ δ∗ and π(h) ⊆ [π(C)]. If h is horizontal, the conclusion holds by the deﬁnition of c-plaquette. If h is vertical, then h ∈ δ, and all 1-connectedhorizontalplaquetteslie in δ∗. At least two such horizontalplaquettes project onto the same plaquette in π(C), in contradiction of the assumption that C is a ceiling.
- (v) Let C be a ceiling and let γ1,γ2,. . .,γn be the maximal 0-connected sets of plaquettes of δ0 \ π(C). Let δi∗ = {h ∈ δ∗ : π(h) ⊆ [γi]}, and let


βi∗ = h ∈ δi∗ : h horizontal,h ∼0 h′ for some h′ ∈ C .

We note that13 βi∗ is a 0-connected subset of δi∗.

![image 949](<rcm1-1_images/imageFile949.png>)

13This is a consequence of [311, eqn (5.3)], see also [286, p. 40, footnote 2].

By part (iv), δ∗ = C ∪ ni=1 δi∗ . We claim that each δi∗ is 0-connected, and we prove this as follows. Let h1,h2 ∈ δi∗. Since δ∗ is 0-connected, it contains a sequence h1 = f0, f1,. . ., fm = h2 of plaquettes such that fi−1 ∼0 fi for i = 1,2,. . .,m. We need to show that such a sequence exists containing no plaquettes in C. Suppose on the contrary that the sequence ( fi) has a non-empty intersection with C. Let k = min{i : fi ∈ C} and l = max{i : fi ∈ C}, and note that 0 < k ≤ l < n.

If fk−1 and fl+1 are horizontal, then fk−1, fl+1 ∈ βi∗, whence they are 0-connected by a path of horizontal plaquettes of βi∗, and the claim follows. A similarargumentisvalidif eitherorbothof fk−1 and fl+1 is vertical. Forexample, if fk−1 is vertical, by (ii) it cannot be 1-connected to a plaquette of C. Hence, it is 1-connected to some horizontal plaquette in δ∗ \ C that is itself 1-connected to a plaquette of C. The same conclusion is valid for fl+1 if vertical. In any such case, as above there exists a 0-connected sequence of w-plaquettes connecting

fk−1 with fl+1, and the claim follows. To prove (v), we note by the above that the wall W is a subset of one of the

sets δi∗, say δ1∗. Next, we let C1 be a ceiling contained in δ1∗, if this exists, and we repeat the above procedure. Consider the 0-connected components of γ1 \π(C1),

and use the fact that δ1∗ is 0-connected, to deduce that the set of plaquettes that project onto one of these components is itself 0-connected. This procedure is

repeated until all ceilings have been removed, the result being a 0-connected set of w-plaquettes of which, by deﬁnition of a wall, all members belong to W.

Claim(vi)isasimpleobservationsincewallsareﬁnite. Claim(vii)isimmediate from claim (ii) and the deﬁnitions of wall and ceiling. Claim (viii) follows from (v) and (vii), and (ix) is a consequence of the deﬁnition of the semi-extended interface δ∗.

The properties described in Lemma 7.125 allow us to describe a wall W in more detail. By (vi) and (vii), there exists a unique ceiling that is 0-connected to W and with projection in the inﬁnite 0-connected component of δ0 \ π(W). We call this ceiling the base of W. The altitude of W is the height of the base of W, see (iii). The height D(W) of W is the maximum absolute value of the displacement in the third coordinate direction of [W] from the horizontal plane {(x1, x2,s + 21) : x1, x2 ∈ Z}, where s is the altitude of W. The interior int(W) (of the projection π(W)) of W is the complement in δ0 of the unique maximal inﬁnite 0-connected component of δ0 \ π(W), see (vi).

![image 950](<rcm1-1_images/imageFile950.png>)

Let S = (A, B) where A, B are sets of plaquettes. We call S a standard wall if there exists δ ∈ DL such that A ⊆ δ, B ⊆ δ∗ \ δ, and A ∪ B is the unique wall of δ. If S = (A, B) is a standard wall, we refer to plaquettes of either A or B as plaquettes of S, and we write π(S) = π(A ∪ B).

(7.126) Lemma. Let S = (A, B) be a standard wall. There exists a unique δ ∈ DL such that: A ⊆ δ, B ⊆ δ∗ \ δ, and A ∪ B is the unique wall of δ.

This will be provedsoon. Let δS denote the unique such δ ∈ DL corresponding

tothestandardwall S. Weshallseethatstandardwallsarethebasicbuildingblocks for a general interface. Notice that the base of a standard wall is a subset of the regular interface. Suppose we are provided with an ordering of the plaquettes of δ0, and let the origin of the standard wall S be the earliest plaquette in π(S) that is 1-connected to some plaquette of δ0 \ π(S). Such an origin exists by Lemma 7.125(ix), and the origin belongs to S by (ii). For h ∈ δ0, let Sh be the set of all standard walls with origin h. To Sh is attached the empty wall Eh, interpreted as a wall with origin h but containing no plaquettes.

A family {Si = (Ai, Bi) : i = 1,2,. . .,m} of standard walls is called admissible if:

(i) fori  = j, there exists no pair h1 ∈ π(Si) and h2 ∈ π(Sj) such that h1 ∼0 h2, (ii) if, for some i, h(e) ∈ Si where e ∈/ EL, then h(e) ∈ Ai if and only if

D(e) = 0.

The membersof anysuch familyhave distinctorigins. Forour futureconvenience, each Si is labelled according to its origin h(i), and we write {Sh : h ∈ δ0} for the family, where Sh is to be interpreted as Eh when h is the origin of none of the Si. We adopt the convention that, when a standard wall is denoted as Sh for some h ∈ δ0, then Sh ∈ Sh.

We introduce next the concept of a group of walls. Let h ∈ δ0, δ ∈ DL, and denote by ρ(h,δ) the number of (vertical or horizontal) plaquettes in δ whose projection is a subset of h. Two standard walls S1, S2 are called close if there exist h1 ∈ π(S1) and h2 ∈ π(S2) such that

![image 951](<rcm1-1_images/imageFile951.png>)

![image 952](<rcm1-1_images/imageFile952.png>)

h1,h2 < ρ(h1,δS1) + ρ(h2,δS2).

A family G of non-empty standard walls is called a group of (standard) walls if it is admissible and if, for any pair S1, S2 ∈ G, there exists a sequence T0 = S1, T1, T2,. . ., Tn = S2 of members of G such that Ti and Ti+1 are close for i = 0,1,. . .,n − 1.

The origin of a group of walls is deﬁned to be the earliest of the origins of the standard walls therein. Let Gh denote the set of all possible groups of walls with origin h ∈ δ0. As before, we attach to Gh the empty group Eh with origin h but containing no standard wall. A family {Gi : i = 1,2,. . .,m} of groups of walls is called admissible if, for i  = j, there exists no pair S1 ∈ Gi, S2 ∈ Gj such that S1 and S2 are close.

We adopt the conventionthat, when a group of walls is denoted as Gh for some h ∈ δ0, then Gh ∈ Gh. Thus, a family of groups of walls may be written as a collection G = {Gh : h ∈ δ0} where Gh ∈ Gh.

(7.127) Lemma. The set DL is in one–one correspondence with both the collection of admissible families of standard walls, and with the collection of admissible families of groups of walls.

Just as important as the existence of these one–one correspondences is their nature, as described in the proof of the lemma. Let δG (respectively, δG) denote

the interface corresponding thus to an admissible family G of standard walls (respectively, an admissible family G of groups of walls).

Proof of Lemma 7.126. Let δ ∈ DL have unique wall S = (A, B). By deﬁnition, every plaquette of δ∗ other than those in A ∪ B is a c-plaquette, so that = δ∗ \ (A ∪ B) is a union of ceilings C1,C2,. . .,Cn. Each Ci contains some plaquette hi that is 1-connected to some h′

i ∈ A, whence, by Lemma 7.125(iii), the height of Ci is determined uniquely by knowledge of S. Hence δ is unique.

Proof of Lemma 7.127. Let δ ∈ DL. Let W1, W2,. . ., Wn be the non-emptywalls of δ∗, and write Wi = (Ai, Bi) where Ai = Wi ∩ δ, Bi = Wi ∩ (δ∗ \ δ). Let si be the altitude of Wi. We claim that τ(0,0,−si)Wi is a standard wall, and we prove this asfollows. LetCij , j = 1,2,. . .,k, be the ceilingsthatare 0-connected to Wi, and let Hij be the maximal 0-connected set of plaquettes in δ0 \π(Wi) onto which Cij projects. See Lemma 7.125(vii). It sufﬁces to construct an interface δ(Wi) having τ(0,0,−si)Wi as its unique wall. To this end, we add to τ(0,0,−si)Ai the plaquettes in τ(0,0,−si)Cij , j = 1,2,. . .,k, together with, for each j, the horizontal plaquettes in the maximal 0-connected set of horizontal plaquettes that contains τ(0,0,−si)Cij and elements of which project onto Hij .

We now deﬁne the family {Sh : h ∈ δ0} of standard walls by

τ(0,0,−si)Wi if h is the origin of τ(0,0,−si)Wi, Eh if h is the origin of no τ(0,0,−si)Wi.

Sh =

More precisely, in the ﬁrst case, Sh = (Ah, Bh) where Ah = τ(0,0,−si)Ai and Bh = τ(0,0,−si)Bi. Thatthisis anadmissible familyof standardwalls followsfrom Lemma 7.125(viii) and from the observation that si = 0 when E(Wi) ∩ EL  = ∅.

![image 953](<rcm1-1_images/imageFile953.png>)

Conversely, let {Sh = (Ah, Bh) : h ∈ δ0} be an admissible family of standard walls. We shall show that there is a unique interface δ corresponding in a certain way to this family. Let S1, S2 . . ., Sn be the non-empty walls of the family, and let δi be the unique interface in DL having Si as its only wall.

Consider the partial ordering on the walls given by Si < Sj if int(Si) ⊆ int(Sj), and re-order the non-emptywalls in such a way that Si < Sj implies i < j. When it exists, we take the ﬁrst index k > 1 such that S1 < Sk and we modify δk as follows. First, we remove the c-plaquettes that project onto int(S1), and then we add translates of the plaquettes of A1. This is done by translating these plaquettes so that the base of S1 is raised (or lowered) to the plane containing the ceiling that is 0-connected to Sk and that projects on the maximal 0-connected set of plaquettes in δ0 \ π(Sk) containing π(S1). See Lemma 7.125(viii). Let δk′ denote the ensuing interface. We now repeat this procedure starting from the set of standard walls S2, S3,. . ., Sn and interfaces δ2,δ3,. . . ,δk−1,δk′ ,δk+1,. . .,δn. If nosuchk exists, wecontinuetheprocedurewiththereducedsequence ofinterfaces δ2,δ3,. . .,δk−1,δk,δk+1,. . .,δn.

We continue this process until we are left with interfaces δi′′l, l = 1,2,. . . ,r, having indices that refer to standard walls that are smaller than no other wall. The

ﬁnal interface δ is constructed as follows. For each l, we remove from the regular interface δ0 all horizontal plaquettes contained in int(Sil ), and we replace them by the plaquettes of δi′′l that project onto int(Sil ).

Theﬁnalassertionconcerningadmissiblefamiliesofgroupsofwallsisstraightforward.

We derive next certain combinatorial properties of walls. For S = (A, B) a standard wall, let N(S) = |A| and  (S) = N(S) − |π(S)|. For an admissible set F = {S1, S2,. . ., Sm} of standard walls, let

m

m

m

π(Si).

N(Si), π(F) =

 (Si), N(F) =

 (F) =

i=1

i=1

i=1

(7.128) Lemma. Let S = (A, B) be a standard wall, and D(S) its height.

(i) N(S) ≥ 1314|π(S)|. Consequently,  (S) ≥ 131 |π(S)| and  (S) ≥ 141 N(S). (ii) N(S) ≥ 15|S|. (iii)  (S) ≥ D(S).

![image 954](<rcm1-1_images/imageFile954.png>)

![image 955](<rcm1-1_images/imageFile955.png>)

![image 956](<rcm1-1_images/imageFile956.png>)

![image 957](<rcm1-1_images/imageFile957.png>)

Proof. (i) For each h0 ∈ δ0, let U(h0) = {h ∈ δ0 : h = h0 or h ∼1 h0}. We call two plaquettes h1,h2 ∈ δ0 separated if U(h1) ∩ U(h2) = ∅. Denote by Hsep = Hsep(S) ⊆ π(S) a set of pairwise-separated plaquettes in π(S) having maximum cardinality, and let H = h1∈Hsep[U(h1) ∩ π(S)]. Note that

(7.129) |Hsep| ≥ 131 |π(S)|.

![image 958](<rcm1-1_images/imageFile958.png>)

For every h0 ∈ π(S), there exists a horizontal plaquette h1 ∈ δS such that π(h1) = h0. Since A ∪ B contains no c-plaquette of δS, h1 is a w-plaquette, whence h1 ∈ A. In particular, N(S) ≥ |π(S)|.

For h0 = π(h1) ∈ Hsep where h1 ∈ A, we claim that (7.130) h ∈ A : either π(h) ⊆ [h0] or π(h) ∈ U(h0) ≥ |U(h0)∩π(S)|+1. By (7.129)–(7.130),

|U(h0) ∩ π(S)| + 1 + |π(S) \ H|

N(S) ≥

h0∈Hsep

= |H| + |Hsep| + |π(S)| − |H| ≥ 1314|π(S)|.

![image 959](<rcm1-1_images/imageFile959.png>)

In order to prove (7.130), we argue ﬁrst that U(h0)∩π(S) contains at least one (horizontal) plaquette besides h0. Suppose that this is not true. Then U(h0) \ h0 contains the projections of c-plaquettes of δ∗S only. By Lemma 7.125(ii, iii), these c-plaquettes belong to the same ceiling C and therefore lie in the same plane. Since h1 is by assumption a w-plaquette, there must be at least one other

horizontal plaquette of δ∗S projecting onto h0. Only one such plaquette, however, is 1-connectedwith the c-plaquettes. Since δ∗S is 1-connected, the other plaquettes projecting onto h0 must be 1-connected with at least one other plaquette of δ∗S. Each of these further plaquettes projects into π(C), in contradiction of Lemma 7.125(iv).

We now prove (7.130) as follows. Since h1 is a w-plaquette, there exists h2 ∈ A ∪ B, h2  = h1, such that π(h2) = h0. If there exists such h2 belonging to A, then (7.130) holds. Suppose the contrary, and let h2 be such a plaquette with h2 ∈ B. Since h1 ∈ A, for every η ∈ U(h0) ∩ π(S), η  = h0, there exists

η′ ∈ A such that π(η′) ⊆ [η] and η′ ∼1 h1. [If this were false for some η then, as in the proof of Lemma 7.125(ii), in any conﬁguration with interface δS, there would exist a path of open edges joining the vertex just above h1 to the vertex just beneath h1. Since, by assumption, all plaquettes of A ∪ B other than h1, having projection h0, lie in B, this would contradict the fact that δS is an interface.] If any such η′ is vertical, then (7.130) follows. Assume that all such η′ are horizontal.

Since h2 ∈ B, there exists h3 ∈ A such that h3 ∼1 h2, and (7.130) holds in this case also.

- (ii) The second part of the lemma follows from the observation that each of the plaquettes in A is 1-connected to no more than four horizontal plaquettes of B.
- (iii) Recall from the remark after (7.129) that A contains at least |π(S)| horizontal plaquettes. Furthermore, A must contain at least D(S) vertical plaquettes, and the claim follows.


Finally inthissection, we derivean exponentialboundforthenumberof groups of walls satisfying certain constraints. (7.131) Lemma. Let h ∈ δ0. There exists a constant K such that: for k ≥ 1, the number of groups of walls G ∈ Gh satisfying  (G) = k is no greater than Kk. Proof. Let G = {S1, S2,. . . , Sn} ∈ Gh where the Si = (Ai, Bi) are non-empty standard walls and S1 ∈ Sh. For j ∈ δ0, let

Rj = h′ ∈ δ0 : j,h′ ≤ ρ(j,δG) \ π(G),

![image 960](<rcm1-1_images/imageFile960.png>)

n

(Ai ∪ Bi) ∪

Rj .

G =

i=1

j∈π(G)

There exist constants C′ and C′′ such that, by Lemma 7.128, | G| ≤ |G| + C′

ρ(j,δG) ≤ C′′|G| ≤ 5 · 14C′′ (G),

j∈π(G)

where |G| = i(Ai ∪ Bi) .

Itmaybe seen that G is a 0-connectedsetof plaquettescontainingh. Moreover, the 0-connected sets obtained by removing all the horizontal plaquettes h′ ∈ G,

for which there exists no other plaquette h′′ ∈ G with π(h′′) = π(h′), are the standard walls of G. Hence, the number of such groups of walls with  (G) = k is no greaterthan the numberof 0-connectedsets of plaquettescontainingno more than 70C′′k elements including h. It is proved in [103, Lemma 2] that there exists ν < ∞ such that the number of 0-connected sets of size n containing h is no larger than νn. Given any such set, there are at most 2n ways of partitioning the plaquettes between the Ai and the Bi. The claim of the lemma follows.

7.10 Exponential bounds for group probabilities

The probabilistic expressions of Section 7.8 may be combined with the classiﬁcation of Section 7.9 to obtain an estimate concerning the geometry of the interface. Let G = {Gh : h ∈ δ0} be a family of groups of walls. If G is admissible, there exists by Lemma 7.127 a unique corresponding interface δG. We may pick a random family ζ = {ζh : h ∈ δ0} of groups of walls according to the probability measure PL induced by φL thus:

![image 961](<rcm1-1_images/imageFile961.png>)

PL(ζ = G) =

φL(  = δG) if G is admissible, 0 otherwise.

![image 962](<rcm1-1_images/imageFile962.png>)

(7.132) Lemma. Let q ∈ [1,∞), and let p∗ be as in Lemma 7.104. There exist constants C3, C4 such that

PL ζh′ = Gh′ ζh = Gh for h ∈ δ0, h  = h′ ≤ C3[C4(1 − p)] (Gh′),

for p > p∗, and for all h′ ∈ δ0, Gh′ ∈ Gh′, L > 0, and for any admissible family {Gh : h ∈ δ0, h  = h′} of groups of walls.

Proof. The claim is trivial if G = {Gh : h ∈ δ0} is not admissible, and therefore we may assume it to be admissible. Let h′ ∈ δ0, and let G′ agree with G except at h′, where Gh′ is replaced by the empty group Eh′. Then

![image 963](<rcm1-1_images/imageFile963.png>)

φL(δ) φL(δ′)

(7.133) PL ζh′ = Gh′ ζh = Gh for h ∈ δ0, h  = h′ ≤

,

![image 964](<rcm1-1_images/imageFile964.png>)

![image 965](<rcm1-1_images/imageFile965.png>)

where δ = δG and δ′ = δG′.

In using (7.121) to bound the right side of this expression, we shall require bounds for |δ| − |δ′|, |δ \ δ| − |δ′ \ δ′|, kδ − kδ′, and (7.134)

![image 966](<rcm1-1_images/imageFile966.png>)

![image 967](<rcm1-1_images/imageFile967.png>)

fp(e,δ′, L).

fp(e,δ, L) −

e∈E(δ′)∩EL

e∈E(δ)∩EL

It is easy to see from the deﬁnition of δ that |δ| = |δ0| +

N(Gh) − |π(Gh)| ,

h∈δ0

216 Duality in Higher Dimensions [7.10]

and therefore,

(7.135) |δ| − |δ′| = N(Gh′) − |π(Gh′)| =  (Gh′).

A little thought leads to the inequality

(7.136) |δ \ δ| − |δ′ \ δ′| ≥ 0,

![image 968](<rcm1-1_images/imageFile968.png>)

![image 969](<rcm1-1_images/imageFile969.png>)

and the reader may be prepared to omit the explanation that follows. We claim that (7.136) follows from the inequality

(7.137) |P(δ)| − |P(δ′)| ≥ 0,

![image 970](<rcm1-1_images/imageFile970.png>)

![image 971](<rcm1-1_images/imageFile971.png>)

where P(δ) (respectively, P(δ′)) is the set of plaquettes in δ \ δ (respectively, δ′ \ δ′) that project into [π(Gh′)]. In order to see that (7.137) implies (7.136), we argue as follows. The extended interface δ may be constructed from δ′ in the following manner. First, we remove all the plaquettes from δ′ that project into [π(Gh′)], and we ﬁll the gaps by introducing the walls of Gh′ one by one along the lines of the proof of Lemma 7.127. Then we add the plaquettes of δ \ δ that project into [π(Gh′)]. During this operation on interfaces, we remove P(δ′) and add P(δ), and the claim follows.

![image 972](<rcm1-1_images/imageFile972.png>)

![image 973](<rcm1-1_images/imageFile973.png>)

![image 974](<rcm1-1_images/imageFile974.png>)

![image 975](<rcm1-1_images/imageFile975.png>)

![image 976](<rcm1-1_images/imageFile976.png>)

![image 977](<rcm1-1_images/imageFile977.png>)

![image 978](<rcm1-1_images/imageFile978.png>)

![image 979](<rcm1-1_images/imageFile979.png>)

![image 980](<rcm1-1_images/imageFile980.png>)

![image 981](<rcm1-1_images/imageFile981.png>)

By Lemma 7.125(viii), there exists no vertical plaquette of δ′ \ δ′ that projects into [π(Gh′)] and is in addition 1-connected to some wall not belonging to Gh′. Moreover, since all the horizontal plaquettes of δ′ belong to the semi-extended interface δ′∗, those that project onto [π(Gh′)] are c-plaquettes of δ′∗; hence, such plaquettes lie in δ′. It follows that P(δ′) comprises the vertical plaquettes that are 1-connected with π(Gh′).

![image 982](<rcm1-1_images/imageFile982.png>)

![image 983](<rcm1-1_images/imageFile983.png>)

![image 984](<rcm1-1_images/imageFile984.png>)

It is therefore sufﬁcient to construct an injective map T that maps each vertical plaquette, 1-connected with π(Gh′), to a different vertical plaquette in P(δ). We noted in the proof of Lemma 7.128(i) that, for every h0 ∈ π(G′

![image 985](<rcm1-1_images/imageFile985.png>)

h), there exists a horizontal plaquette h1 ∈ δ with π(h1) = h0. For every vertical plaquette hv ∼1 h0, there exists a translate hv1 ∼1 h1. Suppose hv lies above δ0. If hv1 ∈ δ \ δ, we set T(hv) = hv1. If hv1 ∈ δ, we consider the (unique) vertical plaquette ‘above’ it, which we denote by hv2. We repeat this procedure up to the ﬁrst n for which we meet a plaquette hvn ∈ δ \ δ, and we set T(hv) = hvn. When hv lies below δ0, we act similarly to ﬁnd a plaquette T(hv) of δ \ δ beneath hv. The resulting T is as required.

![image 986](<rcm1-1_images/imageFile986.png>)

![image 987](<rcm1-1_images/imageFile987.png>)

![image 988](<rcm1-1_images/imageFile988.png>)

We turn now to the quantity kδ − kδ′, and we shall use the notation around (7.101). Note that exactly two of the components (Sδi,Uδi) are inﬁnite, and these may be taken as those with indices 1 and 2. For i = 3,4,. . .,kδ, let H(Sδi) be the set of plaquettes that are dual to edges having exactly one endvertex in Sδi. The ﬁnite component (Sδi,Uδi) is in a natural way surrounded by a particular

wall, namely that to which all the plaquettes of H(Sδi) belong. This follows from Lemma 7.125(v, viii) and the facts that

Pi = π h( x, x + (0,0,1) ) : x ∈ Sδi

is a 1-connected subset of δ0, and that [π(H(Sδi))] = [Pi].

Therefore, (7.138) kδ − kδ′ = kδ′′ − 2, where δ′′ = δGh′. It is elementary by Lemma 7.128(i) that (7.139) kδ′′ ≤ 2N(Gh′) ≤ 28 (Gh′).

Finally, we estimate (7.134). Let H1, H2,. . ., Hr be the maximal 0-connected

sets of plaquettesin δ0\π(Gh′), and let δi (respectively, δi′) be the set of plaquettes of δ (respectively, δ′) that project into [Hi]. Recalling the construction of an interface from its standard walls in the proof of Lemma 7.127, there is a natural

one–one correspondence between the plaquettes of δi and those of δi′, and hence between the plaquettes in U = ri=1 δi and those in U′ = ri=1 δi′. We denote by T the correspondingbijection mapping an edge e with h(e) ∈ ri=1 δi to the edge T(e) with corresponding dual plaquette in ri=1 δi′. Note that T(e) is a vertical translate of e.

If e is such that h(e) ∈ U,

G(e,δ, EL; T(e),δ′, EL) ≥ π′(h(e)),π(Gh′) − 1, where π′(h) is the earliest plaquette h′′ of δ0 such that π(h) ⊆ [h′′], and

h1, H = min h1,h2 : h2 ∈ H . Let p > p∗. In the notation of Lemmas 7.104 and 7.118,

(7.140)

fp(e,δ′, L)

fp(e,δ, L) −

e∈E(δ′)∩EL

e∈E(δ)∩EL

fp(e,δ, L) − fp(T(e),δ′, L)

≤

e∈E(U)∩EL

fp(e,δ′, L)

fp(e,δ, L) +

+

e∈E(δ\U)∩EL

e∈E(δ′\U′)∩EL

exp − γ π′(h(e)),π(Gh′) + C1 N(Gh′) + |π(Gh′)| .

≤ C2eγ

e∈E(U)∩EL

By Lemma 7.128, the second term of the last line is no greater than C5 (Gh′) for some constant C5. Using the same lemma and the deﬁnition of a group of walls, the ﬁrst term is no larger than

C2eγ

(7.141) ρ(h,δ)exp −γ h,π(Gh′)

h∈δ0\π(Gh′)

h,π(Gh′) 2 exp −γ h,π(Gh′)

≤ C2eγ

h∈δ0\π(Gh′)

h,h′′ 2 exp −γ h,h′′

≤ C2eγ

h′′∈π(Gh′) h∈δ0\π(Gh′)

≤ C6|π(Gh′)| ≤ 13C6 (Gh′),

for some constant C6. The required conditional probability is, by (7.121) and (7.133), p|δ\δ|−|δ′\δ′|(1 − p)|δ|−|δ′|qkδ−kδ′

![image 989](<rcm1-1_images/imageFile989.png>)

![image 990](<rcm1-1_images/imageFile990.png>)

fp(e,δ′, L) ,

× exp

fp(e,δ, L) −

e∈E(δ)∩EL

e∈E(δ′)∩EL

which, by (7.135)–(7.141), is bounded as required.

7.11 Localization of interface

The principal theorem states in rough terms the following. Let q ∈ [1,∞) and let p be sufﬁciently large. With φL-probability close to 1, the interface  (ω) deviates from the ﬂat plane δ0 only through local perturbations. An ant living on  (ω) is able, with large probability, to visit a positive density of the interface via horizontal meanderings only.

![image 991](<rcm1-1_images/imageFile991.png>)

Let h ∈ δ0. For ω ∈ DL, we write h ↔ ∞ if there exists a sequence

h = h0,h1,. . .,hr of plaquettes in δ0 such that: (a) hi ∼1 hi+1 for i = 0,1,. . .,r − 1, (b) each hi is a c-plaquette of  (ω), and (c) hr = h(e) for some e ∈/ EL.

- (7.142) Theorem [139]. Let q ∈ [1,∞). For ǫ > 0, there exists p = p(ǫ) < 1 such that, if p > p,
- (7.143) φL(h ↔ ∞) > 1 − ǫ, h ∈ δ0, L ≥ 1.


![image 992](<rcm1-1_images/imageFile992.png>)

Since, following Theorem 7.142, h ∈ δ0 is a c-plaquette with high probability, the vertexof Z3 immediatelybeneath(respectively,above)the centre of h is joined

to ∂− L (respectively, ∂+ L) with high probability. Theorem 7.87 follows. Furthermore, since h ↔ ∞ with high probability, such connectionsmay be found within the plane of Z3 comprising vertices x with x3 = 0 (respectively, x3 = 1).

The existence of non-translation-invariant (conditioned) random-cluster measures follows from Theorem 7.142, as in the following sketch argument. For e ∈ E3, let e± = e ± (0,0,1), and let ω ∈ . If h = h(e) ∈ δ0 is a c-plaquette of =  (ω), then e is closed, and h(e±) ∈/ . The conﬁgurations in the two regions above and below are governed by wired random-cluster measures14. Therefore, under (7.143),

![image 993](<rcm1-1_images/imageFile993.png>)

(1 − ǫ)p p + q(1 − p)

φL(e is open) ≤ ǫ, φL(e± is open) ≥

![image 994](<rcm1-1_images/imageFile994.png>)

![image 995](<rcm1-1_images/imageFile995.png>)

,

![image 996](<rcm1-1_images/imageFile996.png>)

by stochastic ordering. Note that these inequalities concern the probabilities of cylinder events. This implies Theorem 7.89.

Our second main result concerns the vertical displacement of the interface, and asserts the existence of a geometric bound on the tail of the displacement, uniformly in L. Let δ ∈ DL, (x1, x2) ∈ Z2, and x = (x1, x2, 21). We deﬁne the displacement of δ at x by

![image 997](<rcm1-1_images/imageFile997.png>)

D(x,δ) = sup |z − 21| : (x1, x2, z) ∈ [δ] .

![image 998](<rcm1-1_images/imageFile998.png>)

(7.144) Theorem [139]. Let q ∈ [1,∞). There exists p < 1 and α(p) satisfying α(p) > 0 when p > p such that

φL(D(x, ) ≥ z) ≤ e−zα(p), z ≥ 1, (x1, x2) ∈ Z2, L ≥ 1.

![image 999](<rcm1-1_images/imageFile999.png>)

Proof of Theorem 7.142. Let h ∈ δ0. We have not so far speciﬁed the ordering of plaquettes in δ0 used to identify the origin of a standard wall or of a groupof walls. We assume henceforth that this ordering is such that: for h1,h2 ∈ δ0, h1 > h2 implies h,h1 ≥ h,h2 .

For any standard wall S there exists, by Lemma 7.125(vi), a unique maximal

inﬁnite 1-connected component I(S) of δ0 \ π(S). Let ω ∈ DL. The interface  (ω) gives rise to a family of standard walls, and h ↔ ∞ if and only if15, for

each such wall S, h belongs to I(S). Suppose on the contrary that h ∈/ I(Sj) for some such standard wall Sj, for some j ∈ δ0, belonging in turn to some maximal admissible group Gh′ ∈ Gh′ of walls of , for some h′ ∈ δ0. By Lemma 7.128 and the above ordering of δ0,

13 (Gh′) ≥ |π(Gh′)| ≥ |π(Sj)| ≥ h, j + 1 ≥ h,h′ + 1.

![image 1000](<rcm1-1_images/imageFile1000.png>)

14We have used Lemma 7.117 here. 15This is a consequence of a standard property of Z2, see [210, Appendix].

Let K be as in Lemma 7.131, and p∗, C4 as in Lemma 7.132. Let p be sufﬁciently large that p > p∗ and that

λ = λ(p) = −131 log[KC4(1 − p)] satisﬁes λ( p) > 0. By the last lemma, when p > p,

![image 1001](<rcm1-1_images/imageFile1001.png>)

PL  (ζh′) ≥ 131 [ h,h′ + 1]

1 − φL(h ↔ ∞) ≤

![image 1002](<rcm1-1_images/imageFile1002.png>)

![image 1003](<rcm1-1_images/imageFile1003.png>)

h′∈δ0

PL(ζh′ = G)

≤

h′∈δ0 n≥( h,h′ +1)/13 G∈Gh′:  (G)=n

KnC3[C4(1 − p)]n

≤

h′∈δ0 n≥( h,h′ +1)/13

exp −λ( h,h′ + 1) ≤ C7e−λ,

≤ C3

h′∈δ0

for appropriate constants Ci. The claim follows on choosing p sufﬁciently close to 1.

Proof of Theorem 7.144. If D(x, ) ≥ z, there exists r satisfying 1 ≤ r ≤ z such thatthefollowingstatementholds. Thereexistdistinctplaquettesh1,h2,. . .,hr ∈ δ0, and maximal admissible groups Ghi, i = 1,2,. . .,r, of walls of such that: x = (x1, x2, 21) lies in the interior of one or more standard wall of each Ghi, and

![image 1004](<rcm1-1_images/imageFile1004.png>)

r

 (Ghi) ≥ z.

i=1

Recall Lemma 7.128(iii). Let mi = ⌊131 ( x,hi + 1)⌋ where x,h = x − y and y is the centre of h. By Lemma 7.132, and as in the previous proof,

![image 1005](<rcm1-1_images/imageFile1005.png>)

φL(D(x, ) ≥ z) ≤

![image 1006](<rcm1-1_images/imageFile1006.png>)

 (ζhi) ≥ z,  (ζhi) ≥ mi ∨ 1

PL

i

h1,h2,...,hr 1≤r≤z

∞

PL  (ζhi) = zi for i = 1,2,. . .,r

=

s=z z1,z2,...,zr:

h1,h2,...,hr 1≤r≤z

z1+z2+···+zr=s zi≥mi∨1

C8[KC4(1 − p)]s

1,

≤

hi s≥z

z1,z2,...,zr: z1+z2+···+zr=s zi≥mi∨1

for some constant C8. The last summation is the number of ordered partitions of the integer s into r parts, the ith of which is at least mi ∨ 1. By adapting the classical solution to this enumeration problem when mi = 1 for all i, we ﬁnd that

s − 1 − i(mi ∨ 1) r − 1 ≤ 2s−1− i(mi∨1) ≤ 2s−1− i mi,

1 ≤

z1,z2,...,zr: z1+z2+···+zr=s zi≥mi∨1

whence, for some C9,

φL(D(x, ) ≥ z) ≤ C9

![image 1007](<rcm1-1_images/imageFile1007.png>)

∞

[2KC4(1 − p)]s

s=z

2−⌊ x,h /13⌋

h∈δ0

z

, z ≥ 1.

The right side decays exponentially as z → ∞ when 2KC4(1 − p) is sufﬁciently small.

## Chapter 8 Dynamics of Random-Cluster Models

Summary. Onemayassociatetime-dynamicswiththerandom-clustermodel in a variety of natural ways. Amongst Glauber-type processes, the Gibbs sampler is especially useful and is well suited to the construction of a ‘coupling from the past’ algorithm resulting in a sample with the randomcluster measure as its (exact) law. In the Swendsen–Wang algorithm, one interleaves transitions of the random-cluster model and the associated Potts model. The random-cluster model for different values of p may be coupled together via a certain Markov process on a more general state space. This provides a mechanism for studying the ‘equilibrium’ model.

8.1 Time-evolution of the random-cluster model

The random-cluster model as studied so far is random in space but not in time. Therearea varietyof waysofintroducingtime-dynamicsinto themodel,andsome good reasons for so doing. The principal reason is that, in our 3 + 1 dimensional universe, the time-evolution of processes is fundamental. It entails the concepts of equilibrium and convergence,of metastability, and of chaos. A rigorous theory of time-evolution in statistical mechanics is one of the major achievements of modern probability theory with which the names Dobrushin, Spitzer, and Liggett are easily associated.

There is an interplay between the time-dynamics of an ergodic system and its equilibrium measure. The equilibrium is determined by the dynamics, and thus, in models where the equilibrium may itself be hard of access, the dynamics may allow an entrance. Such difﬁculties arise commonly in applications of Bayesian statistics, in situations where one wishes to sample from a posterior distribution µ having complex structure. One way of doing this is to construct a Markov chain with invariant measure µ, and to follow the evolution of this chain as it approaches equilibrium. The consequent ﬁeld of ‘Monte Carlo Markov chains’ is nowestablished as a key area of modernstatistics. Similarly, the dynamicaltheory of the random-clustermodelallows an insight into the equilibrium random-cluster

[8.1] Time-evolution of the random-cluster model 223

measures. It provides in addition a mechanism for studying the way in which the system ‘relaxes’ to its equilibrium. We note that the simulation of a Markov chain can, after some time, result in samples whose distribution is close to the invariant measure µ. Such samples will in general have laws which differ from µ, and it can be a difﬁcult theoretical problem to obtain a useful estimate of the distance between the actual sample and µ.

Considerﬁrst the random-clustermodelon a ﬁnite graph G with givenvaluesof p and q. Perhaps the most obvioustype of dynamic is a so-called Glauber process in which single edges change their states at rates chosen in such a way that the equilibrium measure is the random-cluster measure on G. These are the spin-ﬂip processes which, in the context of the Ising model and related systems, have been studied in many works including Liggett’s book [235]. There is a difﬁculty in constructing such a process on an inﬁnite graph, since the natural speed functions are not continuous in the product topology.

There is a special Glauber process, termed the ‘Gibbs sampler’ or ‘heat-bath algorithm’, which we describe in Section 8.3 in discrete time. This is particularly suited to the exposition in Section 8.4 of the method of ‘coupling from the past’. This beautiful approach to simulation results in a sample having the exact target distribution, unlike the approximate samples produced by Monte Carlo Markov chains. The random-cluster model is a natural application for the method when q ∈ [1,∞), since φG,p,q is monotonic: the model has ‘smallest’ and ‘largest’ conﬁgurations, and the target measure is attained at the moment of coalescence of the two trajectories beginning respectively at these extremes.

The speed of convergence of Glauber processes has been studied in detail for Ising and related models, and it turns out that the rate of convergenceto the unique invariant measure can be very slow. This occurs for example if the graph is a large box of a lattice with, say, + boundary conditions, the initial conﬁguration has − everywhere in the interior, and the temperature is low. The process remains for a long time close to the − state; then it senses the boundary, and converges duly to the + state. There is an alternative dynamic for the Ising (and Potts) model, termed Swendsen–Wang dynamics, which converges rather faster to the unique equilibrium so long as the temperature is different from its critical value. This method proceeds by a progressive coupling of the Ising/Potts system with the random-cluster model, and by interleaving a Markovian transition for these two systems in turn. It is described in Section 8.5.

The remaining sections of this chapter are devoted to an exposition of Glauber dynamics on ﬁnite and inﬁnite graphs, implemented in such a way as to highlight the effect of varying the parameter p. We begin in Section 8.6 with the case of a ﬁnite graph, and proceed in Sections 8.7–8.8 to a process on the inﬁnite lattice which incorporatesin a monotonemannera time-evolvingrandom-clusterprocess for every value of p ∈ (0,1). The unique invariant measure of this composite Markov process may be viewed as a coupling of random-cluster measures on the lattice for different values of p. One consequence of this approach is a proof of the left-continuity of the percolation probability for random-cluster models with

224 Dynamics of Random-Cluster Models [8.2]

q ∈ [1,∞), see Theorem 5.16. It leads in Section 8.9 to an open question of ‘simultaneous uniqueness’ of inﬁnite open clusters.

8.2 Glauber dynamics

Let G = (V, E) be a ﬁnite graph, with = {0,1}E as usual. Let p ∈ (0,1) and q ∈ (0,∞). We shall construct a reversible Markov chain in continuous time having as unique invariant measure the random-cluster measure φp,q on . A feature of the Glauber dynamics of this section is that the set of permissible jumps comprises exactly those in which the state of a single edge, e say, changes. To this end, we recall ﬁrst the notation of (1.25). For ω ∈ and e ∈ E, let ωe and ωe be the conﬁgurationsobtainedby ‘switching e on’ and‘switching e off’, respectively.

Let X = (Xt : t ≥ 0) be a continuous-time Markov chain, [164, Chapter 6], on the state space with generator Q = (qω,ω′ : ω,ω′ ∈  ) satisfying (8.1) qωe,ωe = p, qωe,ωe = (1 − p)qD(e,ωe), ω ∈  , e ∈ E,

where D(e,ξ) is the indicator function of the event that the endvertices of e are joined by no open path of ξ. Equations (8.1) specify the rates at which single edges are acquired or lost by the present conﬁguration. We set qω,ξ = 0 if ω and ξ differ on two or more edges, and we choose the diagonal elements qω,ω in such a way that Q, when viewed as a matrix, has row-sums zero, that is,

qω,ξ, ω ∈  .

qω,ω = −

ξ: ξ =ω

Note that X proceeds by transitions in which single edges change their states, it is not permissible for two or more edge-states to change simultaneously. We say in this regard that X proceeds by ‘local moves’.

It is elementary that the so-called ‘detailed balance equations’ (8.2) φp,q(ω)qω,ω′ = φp,q(ω′)qω′,ω, ω,ω′ ∈  ,

hold, whence X is reversiblewith respectto the random-clustermeasure φp,q. It is easily seen that the chain is irreducible, and therefore φp,q is the unique invariant measure of the chain and, in particular, Xt ⇒ φp,q as t → ∞, where ‘⇒’ denotes weak convergence. There are of course many Markov chains with generators satisfying the detailed balance equations (8.2). It is important only that the ratio qω,ω′/qω′,ω satisﬁes

(8.3)

qω,ω′ qω′,ω

=

![image 1008](<rcm1-1_images/imageFile1008.png>)

φp,q(ω′) φp,q(ω)

, ω,ω′ ∈  .

![image 1009](<rcm1-1_images/imageFile1009.png>)

We call a Markov chain on a Glauber process if it proceeds by local moves and has a generator Q satisfying (8.3), see [235, p. 191]. We have concentrated

[8.3] Gibbs sampler 225

here on continuous-time processes, but Glauber processes may be constructed in discrete time also.

Two extensions of this dynamical structure which have proved useful are as follows. The evolution may be speciﬁed in terms of a so-called graphical representation, constructed via a family of independent Poisson processes. This allows a natural coupling of the measures φp,q for different p and q. Such couplings are monotone in p when q ∈ [1,∞). One may similarly couple the unconditional measure φp,q(·) and the conditioned measure φp,q(· | A). Such couplings permit probabilistic interpretations of differences of the form φp′,q(B | A) − φp,q(B) when q ∈ [1,∞), p ≤ p′, and A and B are increasing, and this can be useful in particular calculations, see [39, 151, 152].

One needs to be more careful when G is an inﬁnite graph. In this case, one may construct a Glauber process on a ﬁnite subgraph H of G, and then pass to the thermodynamic limit as H ↑ G. Such a limit may be justiﬁed when q ∈ [1,∞) using the positiveassociation of random-clustermeasures, [152]. We shall discuss such limits in Section 8.8 in the more general context of ‘coupled dynamics’. For a reason which will emerge later, we will give the details for the Gibbs sampler of Section 8.3, rather than for the Glauber process of (8.1). The latter case may however be treated in an essentially identical manner.

Note that the generator (8.1) of the Markov chain given above depends on the random variable D(e,ωe), and that this randomvariable is ‘non-local’in the sense that it is not everywhere continuous in ω. It is this feature of non-locality which leads to an interesting complication when the graph is inﬁnite, linked in part to the 0/1-inﬁnite-cluster property introduced before Theorem 4.31. Further discussion may be found in [152, 272].

8.3 Gibbs sampler

Once again we take G = (V, E) to be a ﬁnite graph, and we let p ∈ (0,1) and q ∈ (0,∞). We consider in this section a special Glauber process termed the Gibbs sampler (or heat-bath algorithm). This is a Markov chain X on the state space = {0,1}E which proceedsby local moves. Its basic rule is as follows. We choose an edge e at random, and we set the state of e according to the conditional measure of ω(e) given the current states of the other edges. This may be done in either discrete or continuous time, we give the details for continuous time here and shall return to the case of discrete time in Section 8.4.

Let X = (Xt : t ≥ 0) be the Markov chain on the state space with generator Q = (qω,ω′; ω,ω′ ∈  ) given by

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

qωe,ωe =

,

![image 1010](<rcm1-1_images/imageFile1010.png>)

(8.4)

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

qωe,ωe =

,

![image 1011](<rcm1-1_images/imageFile1011.png>)

226 Dynamics of Random-Cluster Models [8.3]

for ω ∈ and e ∈ E. Thus, each edge is selected at rate 1, and the state of that edge is changed according to the correct conditional measure. It is evident that the detailed balance equations (8.2) hold as before, whence X is reversible with respect to φp,q. By irreducibility, φp,q is the unique invariantmeasure of the chain and thus, in particular, Xt ⇒ φp,q as t → ∞.

There is a useful way of formulating the transition rules (8.4). With each edge e is associated an ‘exponential alarm clock’ that rings at the times of a Poisson process with intensity 1. Suppose that the alarm clock at e rings at time T, and let U be a random variable with the uniform distribution on the interval [0,1]. Let XT− = ω denote the current state of the process. The state of e jumps to the value XT (e) given as follows:

(8.5)

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

when ω(e) = 1, we set XT(e) = 0 if U ≤

,

![image 1012](<rcm1-1_images/imageFile1012.png>)

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

when ω(e) = 0, we set XT(e) = 1 if U >

.

![image 1013](<rcm1-1_images/imageFile1013.png>)

The state of e is unchanged if the appropriate inequality is false. It is easily checked that this rule generates a Markov chain which satisﬁes (8.4) and proceeds by local moves. This version of such a chain has two attractive properties. First, it is a neat way of implementing the Gibbs sampler in practice since it requires only two random mechanisms: one that samples edges at random, and a second that produces uniformly distributed random variables.

AsecondbeneﬁtisthatitprovidesacouplingofavarietyofsuchMarkovchains with different values of p and q, and with different initial states. We explain this next. Suppose that 0 < p1 ≤ p2 < 1 and q1 ≥ q2 ≥ 1. It is easily checked, as in Section 3.4, that

(8.6)

φp1,q1(ωe) φp1,q1(ωe) + φp1,q1(ωe) ≥

φp2,q2(ξe) φp2,q2(ξe) + φp2,q2(ξe)

, ω ≤ ξ.

![image 1014](<rcm1-1_images/imageFile1014.png>)

![image 1015](<rcm1-1_images/imageFile1015.png>)

Let U(e) = (Uj(e) : j = 1,2,. . .), e ∈ E, be independent families of independent random variables each having the uniform distribution on [0,1]. Let

Xi = (Xti : t ≥ 0), i = 1,2, be Markov processes on constructed as follows. The process Xi evolves according to the above rules, with parameters pi, qi, and using the value Uj(e) at the jth ring of the alarm clock at the edge e. By (8.5)– (8.6), if X01 ≤ X02, then Xt1 ≤ Xt2 for all t ≥ 0. We have therefore constructed a coupling which preserves ordering between processes with different parameters p, q, and with different initial conﬁgurations. The key to this ordering is the fact that the coupled processes utilize the same variables Uj(e). This discussion will be developed in the next section.

[8.4] Coupling from the past 227

8.4 Coupling from the past

When performing simulations of the random-cluster model, one is required to sample from the probability measure φp,q. The Glauber processes of the last two sections certainly converge weakly to φp,q as t → ∞, but this is not as good as having a sample with the exact distribution. The Propp–Wilson approach to sampling termed ‘coupling from the past’, [282], provides a mechanism for obtaining samples with the correct distribution, and is in addition especially well suited to the random-cluster model when q ∈ [1,∞). We describe this here. Some illustrations of the method in practice may be found in [173, 195, 243].

Let G = (V, E) be a ﬁnite graph and let p ∈ (0,1) and q ∈ (0,∞). We shall later restrict ourselves to the case q ∈ [1,∞), since this will be important in the subsequent analysis of the algorithm. We provide ourselves ﬁrst with a discretetime reversible Markov chain Z = (Zn : n = 0,1,2,. . . ) with state space and having unique invariant measure φp,q. The discrete-time Gibbs sampler provides a suitable example of such a chain, and proceeds as follows, see Section 8.3 and [175]. At each stage, we pick a random edge e, chosen uniformly from E and independently of all earlier choices, and we make e open with the correct conditional probability, given the conﬁguration on the other edges. This Markov chain proceedsby localmoves, and hastransition matrix = (πω,ω′ : ω,ω′ ∈  ) satisfying

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

1 |E|

·

πωe,ωe =

,

![image 1016](<rcm1-1_images/imageFile1016.png>)

![image 1017](<rcm1-1_images/imageFile1017.png>)

1 |E|

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

πωe,ωe =

·

,

![image 1018](<rcm1-1_images/imageFile1018.png>)

![image 1019](<rcm1-1_images/imageFile1019.png>)

for ω ∈ and e ∈ E. A neat way to implement this is to follow the recipe of the last section. Suppose that Zn = ω. Let en be a random edge of E, and let Un be uniformly distributed on the interval [0,1], these variables being chosen independently of all earlier choices. We obtain Zn+1 by retaining the states of all edges except possibly that of en, and by setting

φp,q(ωen) φp,q(ωen) + φp,q(ωen)

(8.7) Zn+1(en) = 0 if and only if Un ≤

.

![image 1020](<rcm1-1_images/imageFile1020.png>)

The evolution of the chain is determined by the sequences en, Un, and the initial state Z0. One may make this construction explicit by writing

Zn+1 = ψ(Zn,en,Un) for some deterministic function ψ : × E × [0,1] → .

We highlight a certain monotonicity of ψ, valid when q ∈ [1,∞). Fix e ∈ E and u ∈ [0,1]. The conﬁguration ω = ψ(ω,e,u), viewed as a function of ω, is constant on edges f  = e, and takes values 0, 1 on e with

φp,q(ωe) φp,q(ωe) + φp,q(ωe)

ω(e) = 0 if and only if u ≤

, ω ∈  .

![image 1021](<rcm1-1_images/imageFile1021.png>)

228 Dynamics of Random-Cluster Models [8.4]

As in (8.6), when q ∈ [1,∞), φp,q(ωe) φp,q(ωe) + φp,q(ωe) ≥

φp,q(ξe) φp,q(ξe) + φp,q(ξe)

, ω ≤ ξ,

![image 1022](<rcm1-1_images/imageFile1022.png>)

![image 1023](<rcm1-1_images/imageFile1023.png>)

implying that ω(e) ≤ ξ(e), and hence (8.8) ψ(ω,e,u) ≤ ψ(ξ,e,u), ω ≤ ξ. Let Zν = (Znν : n = 0,1,2,. . .) be the Markov chain constructed via (8.7) with initial state Z0 = ν. By (8.8), (8.9) Znω ≤ Znξ for all n, if ω ≤ ξ and q ∈ [1,∞), which is to say that the coupling is monotone in the initial state: if one such chain starts below another, then it remains below for all time.

Instead of running the chain Z ‘forwards’ in time in order to approximate the invariant measure φp,q, we shall run it ‘backwards’ in time in a certain special manner which results in a sample with the exact target distribution. Let W = (W(ω) : ω ∈  ) be a vector of random variables such that each W(ω) has the law of Z1 conditional on Z0 = ω,

P(W(ω) = ξ) = πω,ξ, ω,ξ ∈  .

Following the scheme described above, we may take W(ω) = ψ(ω,e,U) where e and U are chosen uniformly at random. Let W−m, m = 1,2,. . ., be independent random vectors distributed as W, that is, W−m(·) = ψ(·,em,Um) where the set {(em,Um) : m = 1,2,. . .} comprises independent pairs of independent uniformly-distributed random variables. We construct a sequence Y−n, n = 1,2,. . ., of random maps from to by the following inductive procedure. First, we deﬁne Y0 : → to be the identity mapping. Having found Y0,Y−1,Y−2,. . .,Y−m for m = 0,1,2,. . ., we deﬁne

Y−m−1(ω) = Y−m(W−m−1(ω)).

That is, Y−m−1(ω) is obtained from ω by passing in one step to W−m−1(ω), and thenapplyingY−m tothisnewstate. Theexactdependencestructureofthisscheme is an important ingredient of its analysis.

We terminate the process Y at the earliest time M of coalescence,

(8.10) M = min m : Y−m(·) is a constant function .

By the deﬁnition of M, the value Y−M = Y−M(ω) does not depend on the choice of ω. The process of coalescence is illustrated in Figure 8.1. We prove next that Y−M has law φp,q.

230 Dynamics of Random-Cluster Models [8.5]

We extend the notation prior to (8.10) as follows. Let (Y−s,−t : 0 ≤ t ≤ s) be functions mapping to given by:

(i) Y−t,−t is the identity map, for t = 0,1,2,. . . , (ii) Y−s,−t(ω) = Y−s+1,−t(W−s(ω)), for t = 0,1,. . .,s − 1.

The map Y−s,−t depends only on the set {(em,Um, W−m) : t < m ≤ s} of random variables. Therefore, the maps Y−kL,−(k−1)L, k = 1,2,. . ., are independent and identically distributed. Since each is a constant function with some ﬁxed positive probability, there exists almost surely a (random) integer K such that Y−KL,−(K−1)L is a constant function. It follows that M ≤ K L, whence P(M < ∞) = 1.

Let C be chosen randomly from with law φp,q, and write Cm = Y−m(C). Since the law of C is the unique invariant measure φp,q of the Gibbs sampler, Cm has law φp,q for all m = 0,1,2,. . . . By the deﬁnition of M,

Y−M = Cm on the event {M ≤ m}. For ω ∈ and m = 0,1,2,. . . ,

P(Y−M = ω) = P(Y−M = ω, M ≤ m) + P(Y−M = ω, M > m)

= P(Cm = ω, M ≤ m) + P(Y−M = ω, M > m) ≤ φp,q(ω) + P(M > m),

and similarly,

φp,q(ω) = P(Cm = ω) ≤ P(Y−M = ω) + P(M > m). We combine these two inequalities to obtain that

P(Y−M = ω) − φp,q(ω) ≤ P(M > m), ω ∈  , and we let m → ∞ to obtain the result.

8.5 Swendsen–Wang dynamics

It is a major target of statistical physics to understand the time-evolution of disordered systems, and a prime example lies in the study of the Ising model. A multiplicity of types of dynamics have been proposed. The majority of these share a property of ‘locality’ in the sense that the evolution involves changes to the states of vertices in close proximity to one another, perhaps single spinﬂips or spin-exchanges. The state space is generally large, of size 2N where N is the number of vertices, and the Hamiltonian may have complicated structure. When subjected to ‘local dynamics’, the process may approach equilibrium quite

[8.5] Swendsen–Wang dynamics 231

slowly2. Other forms of dynamics are ‘non-local’ in that they permit large moves around the state space relatively unconstrained by neighbourly relations, and such processes can approach equilibrium faster. The random-cluster model has played a role in the development of a simple but attractive system of non-local dynamics proposed by Swendsen and Wang [310] and described as follows for the Potts model with q states.

As usual, G = (V, E) is a ﬁnite graph, typically a large box in Zd, and we let q ∈ {2,3,. . .}. Consider a q-state Potts model on G, with state space = {1,2,. . .,q}V and parameter β ∈ (0,∞). The corresponding random-cluster model has state space = {0,1}E and parameter p = 1 − e−β. The Swendsen– Wang evolution for the Potts model is as follows.

Suppose that, at some time n, we have obtained a conﬁguration σn ∈ . We construct σn+1 as follows.

I. Let ωn ∈ be given by: for all e = x, y ∈ E, if σn(x)  = σn(y), let ωn(e) = 0, if σn(x) = σn(y), let ωn(e) =

1 with probability p, 0 otherwise,

different edges receiving independent states. The edge-conﬁguration ωn is carried forward to the next stage.

II. To each cluster C of the graph (V,η(ωn)) we assign an integer chosen uniformly at random from the set {1,2,. . .,q}, different clusters receiving independent labels. Let σn+1(x) be the value thus assigned to the cluster containing the vertex x.

(8.13) Theorem [310]. The Markov chain σ = (σn : n = 0,1,2,. . . ) has as unique invariant measure the q-state Potts measure on with parameter β.

Proof. There is a strictly positive probability that ωn(e) = 0 for all e ∈ E. Therefore, P(σn+1 = σ | σn = σ′) > 0 for all σ,σ′ ∈ , so that the chain is irreducible. The invariance of φp,q is a consequence of Theorem 1.13.

The Swendsen–Wangalgorithmgeneratesa Markovchain (σn : n = 0,1,. . .). It is generally the case that this chain converges to the equilibrium Potts measure faster than time-evolutions deﬁned via local dynamics. This is especially evident in the ‘high β’ (or ‘low temperature’) phase, for the following reason. Consider for example the simulation of an Ising model on a ﬁnite box with free boundary conditions, and suppose that the initial state is +1 at all vertices. If β is large, local dynamics result in samples that remain close to the ‘+ phase’ for a very long time. Only after a long delay will the process achieve an average magnetization close to 0. Swendsen–Wang dynamics, on the other hand, can achieve large jumps in average magnetization eveninasinglestep,since the spin allocated to agivenlarge

![image 1024](<rcm1-1_images/imageFile1024.png>)

2See [249, 292] for accounts of recent work of relevance.

232 Dynamics of Random-Cluster Models [8.6]

cluster of the corresponding random-cluster model is equally likely to be either of the two possibilities. A rigorous analysis of rates of convergence is however incomplete. It turns out that, at the critical point, Swendsen–Wang dynamics approach equilibrium only slowly, [64]. A further discussion may be found in [136].

Algorithms of Swendsen–Wang type have been described for other statistical mechanicalmodelswithgraphicalrepresentationsofrandom-cluster-type,see[93, 94]. Related work may be found in [322].

8.6 Coupled dynamics on a ﬁnite graph

Let G = (V, E) be a graph, possible inﬁnite. Associated with G there is a family φG,p,q of random-cluster measures indexed by the parameters p ∈ [0,1] and q ∈ (0,∞); we defer a discussion of boundary conditions to the next section. It has proved fruitful to couple these measures, for ﬁxed q, by ﬁnding a family (Zq(e) : e ∈ E) of random variables taking values in [0,1] whose ‘level-sets’ are governed by the φG,p,q. It might be the case for example that, for any given p ∈ (0,1), the conﬁguration (Zp,q(e) : e ∈ E) given by

Zp,q(e) =

1 if Zq(e) ≤ p, 0 otherwise,

has law φG,p,q. Such a coupling has been valuable in the study of percolation theory (that is, when q = 1), where one may simply take a family of independent random variables Z(e) with the uniform distribution on the interval [0,1], see [154, 178]. The picture for random-cluster measures is more complex owing to the dependence structure of the process. Such a coupling has been explored in detail in [152] but we choose here to follow a minor variant which might be termed a ‘coupled Gibbs sampler’. We shall assume for the moment that G is ﬁnite, returning in the next two sections to the case of an inﬁnite graph G.

Let G = (V, E) be ﬁnite, and let q ∈ [1,∞). Let X = [0,1]E, and let B be the Borel σ-ﬁeld of subsets of X, that is, the σ-ﬁeld generated by the open subsets. We shall construct a Markov process Z = (Zt : t ≥ 0) on the state space X, and we do this via a so-called graphical construction. We shall consider the states of edges chosen at random as time passes, and to this end we provide ourselves with a family of independent Poisson processes termed ‘alarm clocks’. For each arrival-time of these processes, we shall require a uniformly distributed random variable.

- (a) For each edge e ∈ E, let A(e) = (An(e) : n = 1,2,. . .) be the (increasing) sequence of arrival times of a Poisson process with intensity 1.
- (b) Let (αn(e) : e ∈ E, n = 1,2,. . .) be a family of independent random variables each of which is uniformly distributed on the interval [0,1].


[8.6] Coupled dynamics on a ﬁnite graph 235

the aboveconstructionmaybeextendedinorderto coupletogetherrandom-cluster processes with differentvalues of p and differentvalues of q ∈ [1,∞). Secondly, some of the arguments of this section may be re-cast in the ‘non-FKG’ case when q ∈ (0,1).

It is noted that the level-set processes are reversible, unlike the process Z. Proof of Theorem 8.24. (a) We begin with a calculation involving the function F deﬁned in (8.14). Let e ∈ E, ν ∈ X, and let γ = pν ∈ . We claim that (8.26) F(e,ν) > p if and only if γ = pν ∈ De,

where De ⊆ is the set of conﬁgurations in which the endvertices of e are joined by no open path of E \ {e}. This may be seen from (8.14) by noting that: F(e,ν) > p if and only if, for every π ∈ Pe, there exists an edge f ∈ π such that ν( f ) > p.

The projected process pZ changes its value only when Z changes its value. Assume that Zt = ν and pZt = pν = γ. Let γ′ ∈ . By the discussion around (8.16)–(8.18), the rate at which pZ jumps subsequently to the new state γ′ depends only on:

(i) the arrival-times of the Poisson processes A(e) subsequent to t, (ii) the associated values of the random variables α, and

(iii) the set Fν = {e ∈ E : F(e,ν) > p} of edges.

By (8.26), Fν = {e ∈ E : γ ∈ De}, which depends on γ only and not further on ν. It follows that pZ = ( pZt : t ≥ 0) is a time-homogeneous Markov chain on . This argument is expanded in the following computation of the jump rates.

Let Q = (qγ,ω : γ,ω ∈  ) denote the generator of the process pZ. Since Z proceeds by local moves,

qγ,ω = 0 if H(γ,ω) ≥ 2,

where H denotes Hamming distance. It remains to calculate the terms qγe,γe and qγe,γe for γ ∈ and e ∈ E. Consider ﬁrst qγe,γe. By (8.17),

P pZt+h = γe pZt = γe = hHe,ν(p) + o(h) as h ↓ 0, whence, by (8.18) and (8.26),

p p + q(1 − p)

if γ ∈ De, p if γ ∈/ De.

![image 1025](<rcm1-1_images/imageFile1025.png>)

(8.27) qγe,γe = He,ν(p) =

By a similar argument,

 

q(1 − p) p + q(1 − p)

if γ ∈ De, 1 − p if γ ∈/ De.

![image 1026](<rcm1-1_images/imageFile1026.png>)

(8.28) qγe,γe = 1 − He,ν(p) =



236 Dynamics of Random-Cluster Models [8.6]

Therefore,

(8.29)

qγe,γe qγe,γe

![image 1027](<rcm1-1_images/imageFile1027.png>)

 

He,ν(p) 1 − He,ν(p) =

=

![image 1028](<rcm1-1_images/imageFile1028.png>)



φp,q(γe) φp,q(γe)

=

.

![image 1029](<rcm1-1_images/imageFile1029.png>)

p q(1 − p)

if γ ∈ De, p 1 − p

![image 1030](<rcm1-1_images/imageFile1030.png>)

if γ ∈/ De,

![image 1031](<rcm1-1_images/imageFile1031.png>)

It followsas in (8.3) that the detailed balance equationshold, and the process pZ is reversible with respect to φp,q. That φp,q is the unique invariant measure is a consequence of the irreducibility of the chain. Inequality (8.25) follows by (8.23). (b) A similar argument is valid with p replaced by p, and (8.26) by

(8.30) F(e,ν) ≥ p if and only if γ = pν ∈ De,

and on replacing He,ν(p) by

He,ν(p−) = lim u↑p

He,ν(u)

in the calculations (8.27)–(8.29).

We turn now to the proof of Theorem 8.19, which is preceeded by a lemma. The product space X = [0,1]E is equipped with the Borel σ-ﬁeld B. An event A ∈ B is called increasing if it has the property that ν′ ∈ A whenever there exists ν ∈ A such that ν ≤ ν′, and it is called decreasing if its complement is increasing. For ζ ∈ X, let Zζ = (Ztζ : t ≥ 0) denote the above Markov process with initial state Z0 = ζ.

(8.31) Lemma. (a) If ζ ≤ ν then Ztζ ≤ Ztν for all t. (b) Let E be an increasing event in B. The function gb(t) = P(Ztb ∈ E) is

non-decreasing in t if b = 0, and is non-increasing if b = 1.

Proof of Lemma 8.31. (a) This follows from the transition rules (8.15)–(8.16) together with the fact that F(e,ν) is non-decreasing in ν. (b) Using conditional expectation,

gb(s + t) = P P(Zsb+t ∈ E | Zsb) , b = 0,1.

By the time-homogeneity of the processes (A,α), the fact that 0 ≤ Zsb ≤ 1, and part (a),

gb(s + t) ≥ gb(t) if b = 0, ≤ gb(t) if b = 1.

Proof of Theorem 8.19. In order to prove the existence of a unique invariant probability measure µ, we shall prove that Zt converges weakly as t → ∞, and we shall write µ for the weak limit. By Lemma 8.31(a),

(8.32) Zt0 ≤ Ztν ≤ Zt1, t ≥ 0, ν ∈ X.

By Lemma 8.31(b), Ztb is stochastically increasing in t if b = 0, and stochastically decreasing if b = 1. It therefore sufﬁces to show that

(8.33) Zt1 − Zt0 ⇒ 0 as t → ∞. Let ǫ > 0, and write E = {k/N : k = 1,2,. . ., N − 1} where N is a positive integer satisfying N−1 < ǫ. Then

P |Zt1(e) − Zt0(e)| > ǫ for some e ∈ E ≤

Now,

P Zt0(e) < p < Zt1(e) .

e∈E p∈E

P Zt0(e) < p < Zt1(e) ≤ P( pZt0(e) = 1) − P( pZt1(e) = 1)

→ 0 as t → ∞

by the ergodicity of the Markov chain pZ, see Theorem 8.24.

8.7 Box dynamics with boundary conditions

In the last section, we constructed a Markov process Z on the state space X = [0,1]E for a ﬁnite edge-set E. In moving to an inﬁnite graph, we shall require a discussion of boundaryconditions. Let d ≥ 1 and X = [0,1]Ed, a compactmetric space when equipped with the Borel σ-ﬁeld B generated by the open sets.

Since our target is to study processes on the lattice Ld = (Zd,Ed), we shall assume for convenience that our ﬁnite graphs are boxes in this lattice. Let be such a box. For ζ ∈ X, let

(8.34) Xζ = ν ∈ X : ν(e) = ζ(e) for e ∈/ E .

As in (8.14), we deﬁne F : Ed × X → R by

ν( f ), e = x, y ∈ Ed, ν ∈ X,

(8.35) F(e,ν) = inf

max

f ∈π

π∈Pe

where Pe is the (inﬁnite) set of all (ﬁnite) paths of Ed \ {e} that join x to y.

238 Dynamics of Random-Cluster Models [8.7]

Let q ∈ [1,∞). We provide ourselves4 with a family of independent Poisson processes A(e) = (An(e) : n = 1,2,. . .), e ∈ Ed, with intensity 1, and an associated collection (αn(e) : e ∈ Ed, n = 1,2,. . .) of independent random variables with the uniform distribution on [0,1]. Let ζ ∈ X. The above variables maybeusedasinthelastsectiontoconstructafamilyofcoupledMarkovprocesses

Zζ = (Z ,ζ t : t ≥ 0) taking values in Xζ and indexed by the pair , ζ. The process Zζ has generator Sζ given by (8.17)–(8.18) for ν ∈ Xζ and with F = F(e,ν) given in (8.35).

As in Lemma 8.31(a),

(8.36) Z ,ζ t ≤ Z ,ν t, ζ ≤ ν, t ≥ 0.

For ν,ζ ∈ X and a box , we denote by (ν,ζ) [= (ν,ζ) ∈ X] the composite conﬁgurationthat agrees with ν on E and with ζ off E . We sometimes suppress the subscript when using this notation. For example, the expression Z ,(ν,ζ)t denotes the value of the process on the box at time t, with initial value (ν,ζ) . Finally, with p, p given as in (8.20)–(8.21), we write ϒp for the set of all ζ ∈ X with the property that p[(1,ζ) ] has at most one inﬁnite cluster.

(8.37) Theorem. Let ζ ∈ X and let be a box of Ld. The Markov process Z(ν,ζ) = (Z ,(ν,ζ)t : t ≥ 0), viewed as a process on (X,B), has a unique invariant measure µζ and, in particular, Z ,(ν,ζ)t ⇒ µζ as t → ∞.

We turnasbeforetothe projectedprocesses pZζ and pZζ . Acomplication arises in the case of the ﬁrst of these, depending on whether or not ζ ∈ ϒp . (8.38) Theorem. Let p ∈ (0,1), ζ ∈ X, and let be a box of Ld.

(a) The process pZζ = ( pZ ,ζ t : t ≥ 0) is a Markov chain on the state

space pXζ with unique invariant measure φ , ppζ,q, and it is reversible with respect to this measure. Furthermore,

p1Z ,ζ t ≤ p2 Z ,ζ t for t ≥ 0, if p1 ≤ p2. (8.39)

(b) Assume that ζ ∈ ϒp . Statement (a) is valid with the operator p replaced throughout by p.

We note two further facts for future use. First, there is a sample-path monotonicity of the graphical representation which will enable us to pass to the limit of the processes Zζ as ↑ Zd. Secondly, if ν and ζ are members of X that are close

to one another, then so are Z ,(ν,tb) and Z ,(ζ,tb), for b ∈ {0,1}. These observations are made formal as follows.

![image 1032](<rcm1-1_images/imageFile1032.png>)

4We make the same assumption as in the footnote on page 233.

#### (8.40) Lemma.

(a) Let and be boxes satisfying ⊆ . Then:

Z ,(ζ,t0) ≤ Z ,(ζ,t0), ζ ∈ X, t ≥ 0, (8.41) Z ,(ζ,t1) ≥ Z ,(ζ,t1), ζ ∈ X, t ≥ 0. (8.42)

(b) Let be a box, b ∈ {0,1}, and ν,ζ ∈ X. Then:

Z ,(ν,tb)(e) − Z ,(ζ,tb)(e) ≤ max

|ν( f ) − ζ( f )| , t ≥ 0, e ∈ E . (8.43)

f ∈E

Proof of Theorem 8.38. (a) The projected process ( pZ ,ζ t : t ≥ 0) takes values in the state space pζ = pXζ . The proof now follows that of Theorem 8.24(b), the key observation being that (8.30) remains valid with De the set of all conﬁgurationsin = {0,1}Ed such that the endverticesof e are joined by no open path of Ed \ {e}. (b) The claim will follow as in Theorem 8.24(a) once we have proved (8.26) for ν ∈ ϒp . We are thus required to show that:

(8.44) for ν ∈ ϒp , F(e,ν) > p if and only if γ = pν ∈ De.

Let e ∈ E and ν ∈ X. If F(e,ν) > p, then pν ∈ De. Suppose conversely that ν ∈ ϒp and pν ∈ De. By the deﬁnition (8.20) of pν, the function µ : Pe → [0,1] given by

µ(π) = max

ν( f ), π ∈ Pe,

f ∈π

satisﬁes

µ(π) > p, π ∈ Pe. By (8.35), F(e,ν) ≥ p. Suppose F(e,ν) = p. There exists an inﬁnite sequence (πn : n = 1,2,. . .) of distinct paths in Pe such that µ(πn) > p and µ(πn) → p as n → ∞. Let E be the set of edges belonging to inﬁnitely many of the paths πn. Now,

ν( f ) ≤ lim

µ(πn) = p, f ∈ E, so that pν( f ) = 1 for f ∈ E.

n→∞

Write e = x, y , and let C(x) (respectively, C(y)) denote the set of vertices of Ld joined to x (respectively, y) by paths comprising edges f with pν( f ) = 1. By a counting argument, we have that x (respectively, y) lies in some inﬁnite path of E, and therefore |C(x)| = |C(y)| = ∞. Since ν ∈ ϒp , pν has at most one inﬁnite cluster. Therefore, C(x) = C(y), whence pν ∈/ De, a contradiction. This proves that F(e,ν) > p, as required for (8.44).

Proof of Theorem 8.37. This follows the proof of Theorem 8.19, with Theorem 8.38 used in place of Theorem 8.24.

Proof ofLemma 8.40. (a)We shallconsider(8.41), inequality(8.42)beingexactly analogous. Certainly,

0 = Z ,(ζ,t0)(e) ≤ Z ,(ζ,t0)(e), e ∈ Ed \ E .

Let e ∈ E , and note that Z ,(ζ,00)(e) = Z ,(ζ,00)(e), since ⊆ . It sufﬁces to check that, at each ring of the alarm clock on the edge e, the process Z ,(ζ,·0)(e) cannot jump above Z ,(ζ,·0)(e). As in Lemma 8.31(a), this is a consequence of the transition rules (8.15)–(8.16) on noting that F(e,ν) is non-decreasing in ν. (b) Let b ∈ {0,1} and ν,ζ ∈ X. It sufﬁces to show that

Z ,(ν,tb)( f ) − Z ,(ζ,tb)( f )

(8.45) Mt = max

f ∈E

is a non-increasingfunction of t. Now, Mt is constant except when an alarm clock rings. Suppose that AN(e) = T for some N ≥ 1 and e ∈ E . It is enough to show that

(8.46) Z ,(ν,Tb)(e) − Z ,(ζ,Tb)(e) ≤ MT−. By (8.35),

F(e,ξ) − F(e,ξ′) ≤ max f ∈Ed

and (8.46) follows by (8.16).

|ξ( f ) − ξ′( f )| , ξ,ξ′ ∈ X,

8.8 Coupled dynamics on the inﬁnite lattice

The reader is reminded of the assumption that q ∈ [1,∞). We have constructed two Markov processes Zb = (Z ,b t : t ≥ 0) on the state space X = [0,1]Ed, indexed by the ﬁnite box and the boundary condition b ∈ {0,1}. Similar processes may be constructedon the inﬁnite lattice Ld by passing to limits ‘pathwise’, and exploiting the monotonicity in of the processes Zb .

The following (monotone) limits exist by Lemma 8.40,

(8.47) Zt(ζ,0) = lim

↑Zd

and satisfy

Z ,(ζ,t1),

Z ,(ζ,t0), Zt(ζ,1) = lim

↑Zd

(8.48) Zt(ζ,0) ≤ Zt(ζ,1), ζ ∈ X, t ≥ 0.

We write in particular

(8.49) Zt0 = Zt(0,0), Zt1 = Zt(1,1).

It is proved in this section that the processes Zb = (Ztb : t ≥ 0), b = 0,1, are Markovian, and that their level-set invariant measures are the free and wired

random-cluster measures φpb,q. The arguments of this section are those of [152], where closely related results are obtained.

The state space X = [0,1]Ed is a compactmetric space equippedwith the Borel σ-ﬁeld B generated by the open sets. Let B(X) denote the space of bounded measurable functions from X to R, and C(X) the space of continuous functions.

We now introduce two transition functions and semigroups, as follows5. For b ∈ {0,1} and t ≥ 0, let

(8.50) Ptb(ζ, A) = P(Zt(ζ,b) ∈ A), ζ ∈ X, A ∈ B,

and let Stb : B(X) → B(X) be given by

- (8.51) Stbg(ζ) = P(g(Zt(ζ,b))), ζ ∈ X, g ∈ B(X).
- (8.52) Theorem. Let b ∈ {0,1}. The process Zb = (Ztb : t ≥ 0) is a Markov process with Markov transition functions (Ptb : t ≥ 0).
- (8.53) Theorem. There exists a translation-invariant probability measure µ on (X,B) that is the unique invariant measure of each of the two processes Z0, Z1. In particular, Zt0, Zt1 ⇒ µ as t → ∞.


By the last theorem and monotonicity (see (8.36) and (8.47)),

(8.54) Zt(ζ,b) ⇒ µ as t → ∞, ζ ∈ X, b = 0,1.

The ‘level-set processes’ of Zt0 and Zt1 are given as follows. Let p ∈ (0,1), and write

(8.55) L0p,t = pZt1, L1p,t = pZt0, t ≥ 0,

where the projections p and p are deﬁned in (8.20)–(8.21). Note the apparent reversal of boundary conditions in (8.55).

![image 1033](<rcm1-1_images/imageFile1033.png>)

5A possible alternative to the methodology of this section might be the ‘martingale method’ described in [186, 235]. For general accounts of the theory of Markov processes, the reader may consult the books [51, 113, 235, 299].

#### (8.56) Theorem.

- (a) Let b ∈ {0,1} and p ∈ (0,1). The process Lbp is a Markov process on the state space = {0,1}Ed, with as unique invariant measure the randomcluster measure φpb,q on Ld. The process Lbp is reversible with respect to φpb,q.
- (b) The measures φpb,q, b = 0,1, are ‘level-set’ measures of the invariant measure µ of Theorem 8.53 in the sense that, for A ∈ F ,


φp0,q(A) = µ {ζ : pζ ∈ A} , φp1,q(A) = µ {ζ : pζ ∈ A} . (8.57) We make several remarks before proving the above theorems. First, the invari-

ant measures φp0,q and φp1,q of Theorem 8.56 are identical if and only if p ∈/ Dq, where Dq is that of Theorem 4.63.

Secondly, with µ as in Theorem 8.53, and e ∈ Ed, let J : [0,1] → [0,1] be given by (8.58) J(x) = µ {ζ ∈ X : ζ(e) = x} , x ∈ [0,1].

Thus, J is the atomic component of the marginal measure of µ at the edge e and, by translation-invariance, it does not depend on the choice of e. We recall from (4.61) the edge-densities

hb(p,q) = φpb,q(e is open), b = 0,1. (8.59) Proposition. It is the case that

J(p) = h1(p,q) − h0(p,q), p ∈ (0,1).

We deduce by Theorem 4.63 that p ∈ Dq if and only if J(p)  = 0, thereby providing a representation of Dq in terms of atoms of the weak limit µ. This may be used to prove the left-continuity of the percolation probability θ0(·,q). See Theorem 5.16(a), the proof of which is included at the end of the current section.

As discussed after Theorem 4.63, it is believed that there exists Q = Q(d) such that

∅ if q < Q, {pc(q)} if q > Q,

Dq =

and it is a ﬁrst-rate challenge to prove this. The above results provide some incomplete probabilistic justiﬁcation for such a claim, as follows. The set Dq is the set of atoms of the one-dimensional marginal measure of µ. Such atoms arise presumablythroughanaccumulationofedges ehavingthesamevalue Ztb(e). Two edges e and f acquirethe same state in the process Z by way of transitionsat some time T for which, say, the alarm clock at e rings and F = F(e, ZT−) = ZT−( f ). Discounting events with probability zero, this can occur only when the new state

at e is at the (unique) atom of the function He,ν in (8.18), where ν = ZT−. The size of this atom is

F F + q(1 − F)

F −

![image 1034](<rcm1-1_images/imageFile1034.png>)

which is an increasing function of q. This is evidence that the number of pairs e, f of edges having the same state increases with q.

Finally, we describe the transition rulesof the projected processes L0p and L1p. It turns out that the transition mechanismsof these two chains differin an interesting but ultimately unimportant regard. It is convenient to summarize the following discussion by writing down the two inﬁnitesimal generators.

Let e = x, y ∈ Ed. As in (8.35), let Pe be the set of all paths of Ed \ {e} that join x to y. Let Qe be the set of all pairs α = (α1,α2,. . .), β = (β1,β2,. . . ) of vertex-disjointsemi-inﬁnite paths (where αi and βj are the vertices of these paths) with α1 = x and β1 = y; we require αi  = βj for all i, j. Thus Qe comprises pairs (α,β) of paths and, for ω ∈ , we call an element (α,β) of Qe open if all the edges of both α and β are open.

For b = 0,1, let Gb be the linear operator, with domain a suitable subset of C( ), given by (8.60)

qω,ωb e{g(ωe) − g(ω)} + qω,ωb e{g(ωe) − g(ω)} , ω ∈  ,

Gbg(ω) =

e∈Ed

where

p p + q(1 − p)

qω,ωb e = p(1 − 1Db

(8.61) e,

1Db

e) +

![image 1035](<rcm1-1_images/imageFile1035.png>)

q(1 − p) p + q(1 − p)

qω,ωb e = 1 − qω,ωb e = (1 − p)(1 − 1Db

1Db (8.62) e, with (8.63) De0 = {no path in Pe is open}, (8.64) De1 = {no element in Pe ∪ Qe is open}.

e) +

![image 1036](<rcm1-1_images/imageFile1036.png>)

Note that Gbg is well deﬁned for all cylinder functions g, since the inﬁnite sum in (8.60) may then be written as a ﬁnite sum. However, Gbg is not generally continuous when q ∈ (1,∞), even for cylinder functions g. For example, let q ∈ (1,∞), let g be the indicator function of the event that a given edge e is open, and let ω be a conﬁguration satisfying:

(a) ω(e) = 1, (b) no path in Pe is open in ω, (c) some pair (α,β) in Qe is open in ω.

Then Gbg(ω) = −qω,ωb e. However, qω,ωb e is discontinuous at ω for b = 0,1 since, for every ﬁnite box , there exists ρ ∈ agreeing with ω on E such that

which implies (8.75). We deduce as required that λ = F(e,ν). (b) Let e = x, y ∈ Ed. Suppose ν ∈ X0 and ν ↑ ν as ↑ Zd. We prove ﬁrst that the increasing limit

(8.76) λ = lim

↑Zd

F(e,ν )

satisﬁes (8.77) λ ≥ G(e,ν). Let δ ∈ (0,1), and suppose G(e,ν) > δ; we shall deduce that λ > δ, thus obtaining (8.77).

A ﬁnite set S of edges of Ld is called a cutset (for e) if: (i) e ∈/ S,

(ii) every path in Pe contains at least one edge of S, (iii) S is minimal with the two properties above, in the sense that no strict subset

of S satisﬁes (i) and (ii). We claim that: (8.78) there exists a cutset S with ν( f ) > δ for all f ∈ S, and we prove this as follows. First, we write G(e,ν) = min{A, B} where (8.79) A = F(e,ν) = inf

max

ν( f ), B = inf

sup

ν( f ).

f ∈π

π∈Pe

π∈Qe

f ∈π

Since G(e,ν) > δ, we have that A, B > δ. For w ∈ Zd, let Cw(ν) denote the set of vertices of Ld that are connected to w by paths π of Ld satisfying:

(a) π does not contain the edge e, and (b) every edge f of π satisﬁes ν( f ) ≤ δ.

If x ∈ Cy(ν), then there exists π ∈ Pe with ν( f ) ≤ δ for all f ∈ π, which contradicts the fact that A > δ. Therefore x ∈/ Cy(ν). Furthermore, either Cx(ν) or Cy(ν) (or both) is ﬁnite, since if both were inﬁnite, then there would exist π = (α,β) ∈ Qe with ν( f ) ≤ δ for all f in α and β, thereby contradicting the fact that B > δ. We may suppose without loss of generality that Cx(ν) is ﬁnite, and we let R be the subset of Ed \ {e} containing all edges g with exactly one endvertex in Cx(ν). Certainly ν(g) > δ for all g ∈ R, and additionally every path in Pe contains some edge of R. However, R may fail to be minimal with the last property, in which case we replace R by a subset S ⊆ R that is minimal. The set S is the required cutset, and (8.78) is proved.

Since S is ﬁnite and ν( f ) > δ for all f ∈ S, for all large and all f ∈ S, ν ( f ) > δ,

Proof of Lemma 8.69. (i) By (8.35), p ≤ F(e,ν) if and only if every π ∈ Pe contains some edge f with ν( f ) ≥ p, which is to say that pν ∈ De0. (ii) Suppose that p < G(e,ν). For π ∈ Pe ∪Qe, there exists an edge f ∈ π such that ν( f ) > p. Therefore, pν ∈ De1.

Suppose conversely that pν ∈ De1. It is elementary that p ≤ G(e,ν). Suppose in addition that p = G(e,ν), and we shall derive a contradiction. Let e = x, y , and let Cx(ν) (respectively, Cy(ν)) be the set of vertices attainable from x (respectively, y) along open paths of pν not using e. Since pν ∈ De1, Cx(ν) and Cy(ν) are disjoint. We shall prove that Cx(ν) (and similarly Cy(ν)) is inﬁnite. Since p = G(e,ν), there exists an inﬁnite sequence (αn : n = 1,2,. . .) of distinct (ﬁnite or inﬁnite) paths of Ed \ {e} with endvertex x such that

ν( f ) ↓ p as n → ∞.

(8.81) sup

f ∈αn

If |Cx(ν)| < ∞, there exists some edge g  = e, having exactly one endvertex in Cx(ν), and belonging to inﬁnitely many of the paths αn. By (8.81), any such g has ν(g) ≤ p, in contradiction of the deﬁnition of Cx(ν). Therefore Cx(ν) (and similarly Cy(ν)) is inﬁnite.

Since Cx(ν) and Cy(ν) are disjoint and inﬁnite, there exists π = (α,β) ∈ Qe

such that ν( f ) ≤ p for f ∈ α ∪β, in contradiction of the assumption pν ∈ De1. The proof is complete.

Proof of Theorem 8.52. Let b ∈ {0,1}. The transitions of the process (Ztb : t ≥ 0) are given in terms of families of independent doubly-stochastic Poisson

processes. In order that Ztb be a Markov process, it sufﬁces therefore to prove that the conditional distribution of (Zsb+t : t ≥ 0), given (Zub : 0 ≤ u ≤ s), depends only on Zsb.

Here is an informal proof. We have that Zsb+t = lim ↑Zd Z ,b s+t, where the processes Z ,b s+t are given in terms of a graphical representation of compound Poisson processes. It follows that, given (Z ,b u, Zub : 0 ≤ u ≤ s, ⊆ Zd), (Zsb+t : t ≥ 0) has law depending only on the family (Z ,b s : ⊆ Zd). Write ζ = Z ,b s and ζ = lim ↑Zd ζ = Zsb. We need to show that the (conditional) law of (Zsb+t : t ≥ 0) does not depend on the family (ζ : ⊆ Zd) further than on its limit ζ. Lemma 8.40(b) is used for this.

Let s,t ≥ 0 and ν ∈ X. Denote by Y ,(ν,sb+)t the state (in Xb ) at time s + t obtained from the evolution rules given prior to (8.36), starting at time s in state (ν,b) = (ν,b) .

Suppose that b = 0, so that ζ ↑ ζ as → Zd. Let ǫ > 0 and let be a ﬁnite box. There exists a box ′ such that ′ ⊇ and

ζ(e) − ǫ ≤ ζ (e) ≤ ζ(e), e ∈ E , ⊇ ′. By Lemma 8.40(b),

Y ,(ζ,sb+)t − ǫ ≤ Y ,(ζs+ ,bt) ≤ Y ,(ζs+ ,bt) ≤ Y ,(ζ,sb+)t, ⊇ ′.

Now, Y ,(ζs+ ,bt) = Z ,b s+t, and we pass to the limits as ↑ Zd, ↑ Zd, ǫ ↓ 0, to obtain that

Y ,(ζ,sb+)t = Zsb+t,

(8.82) lim

↑Zd

implying as required that Zsb+t depends on ζ but not further on the family (ζ :

⊆ Zd). The same argument is valid when b = 1, with the above inequalities reversed and the sign of ǫ changed.

The Markov transition function of Ztb is the family (Qbs,t : 0 ≤ s ≤ t) given by

Qbs,t(ζ, A) = P(Ztb ∈ A | Zsb = ζ), ζ ∈ X, A ∈ B.

In the light of the remarks above and particularly (8.82),

Qbs,t(ζ, A) = Qb0,t−s(ζ, A)

= P(Zt(ζ,−sb) ∈ A) = Ptb−s(ζ, A).

Proof of Theorem 8.53. As in Lemma 8.31, the limits

ψb(A) = lim

P(Ztb ∈ A), b = 0,1,

t→∞

exist for any increasing event A ∈ B. The space X is compact, and the increasing events are convergence-determining, and therefore Zt0 and Zt1 converge weakly as t → ∞. It sufﬁces to show that

Zt1 − Zt0 ⇒ 0 as t → ∞.

Since we are working with the product topology on X, it will be enough to show that, for ǫ > 0 and f ∈ Ed,

(8.83) P |Zt1( f ) − Zt0( f )| > ǫ → 0 as t → ∞.

Let D = Dq be as in Theorem 4.63, and let ǫ > 0. Pick a ﬁnite subset E of D = (0,1)\D such that every interval of the form (δ,δ +ǫ) contains some point of E, as δ ranges over [0,1 − ǫ). By Theorem 4.63,

![image 1037](<rcm1-1_images/imageFile1037.png>)

(8.84) φp0,q = φp1,q, p ∈ E.

For f ∈ Ed,

P |Zt1( f ) − Zt0( f )| > ǫ ≤

P Zt0( f ) ≤ p ≤ Zt1( f )

p∈E

P Z ,0 t( f ) ≤ p ≤ Z ,1 t( f ) for all boxes

≤

p∈E

P pZ ,0 t( f ) = 1, pZ ,1 t( f ) = 0

=

p∈E

φ ,1 p,q(Jf ) − φ ,0 p,q(Jf ) as t → ∞

→

p∈E

φp1,q(Jf ) − φp0,q(Jf ) as ↑ Zd

→

p∈E

= 0 by (8.84), where Jf is the event that f is open.

The translation-invariance of the limit measure µ is a consequence of the fact that the limits in (8.47)–(8.48) do not depend on the way in which the increasing limit ↑ Zd is taken.

Proof of Theorem 8.56. (a) That the projected processes (Lbp,t : t ≥ 0), b = 0,1, are Markovian follows from Theorem 8.52 and the discussion after Lemma 8.69.

Let A ∈ F be increasing. As in Lemma 8.31, the limits

ψpb(A) = lim

P(Lbp,t ∈ A)

t→∞

exist for b = 0,1. Since L0p,t ≤ L1p,t, (8.85) ψp0(A) ≤ ψp1(A) for increasing A ∈ F . Let A ∈ F be an increasing cylinder event. Then

ψp0(A) = lim

P(L0p,t ∈ A) ≥ lim

t→∞

P( pZ ,1 t ∈ A) since L0p,t ≥ pZ ,1 t

t→∞

= φ ,0 p,q(A) by Theorem 8.38

→ φp0,q(A) as → Zd, and similarly

(8.86) ψp1(A) ≤ φp1,q(A).

Let Dq be given as in Theorem 4.63. Since φp0,q = φp1,q for p ∈/ Dq, we have by (8.85)–(8.86) that

φp0,q(A) = ψp0(A) = ψp1(A) = φp1,q(A), p ∈/ Dq.

Since F is generatedby the increasingcylinderevents, φpb,q is the uniqueinvariant measure of Lbp whenever p ∈/ Dq.

In order to show that

φp0,q(A) = ψp0(A), φp1,q(A) = ψp1(A),

for all p and any increasing cylinderevent A, it sufﬁces to show that ψp0(A) is leftcontinuous in p, and ψp1(A) is right-continuous (the conclusion will then follow by Proposition 4.28). We conﬁne ourselves to the case of ψp0(A), since the other case is exactly similar.

Let p ∈ (0,1), and let A ∈ F be an increasing cylinder event. Let

Bp = {ζ ∈ X : pζ ∈ A}, Cp = {ζ ∈ X : pζ ∈ A},

be the correspondingevents in B, and note from the deﬁnitions of p and p that Bp is decreasing and open, and that Cp is decreasing and closed. Furthermore, Cp−ǫ ⊆ Bp for ǫ > 0, and

(8.87) Bp \ Cp−ǫ → ∅ as ǫ ↓ 0.

By stochastic monotonicity, the limit limt→∞ P(Zt1 ∈ Bp) exists and, by weak convergence (see Theorem 8.53),

P(Zt1 ∈ Bp) ≥ µ(Bp). We claim further that P(Zt1 ∈ Bp) ≤ µ(Bp) for all t, whence (8.88) P(Zt1 ∈ Bp) → µ(Bp) as t → ∞. Suppose on the contrary that

lim

t→∞

P(ZT1 ∈ Bp) > µ(Bp) + η for some T and η > 0.

Now Zt1 ≤st ZT1 for t ≥ T, and hence

P(Zt1 ∈ Cp−ǫ) > µ(Cp−ǫ) + 21η for some ǫ > 0 and all t ≥ T, by (8.87). Since Cp−ǫ is closed, this contradicts the fact that Zt1 ⇒ µ.

![image 1038](<rcm1-1_images/imageFile1038.png>)

For h > 0,

ψp0(A) − ψp0−h(A) = lim

P(Zt1 ∈ Bp) − P(Zt1 ∈ Bp−h)

t→∞

= µ(Bp \ Bp−h) by (8.88).

The sets Bp and Bp−h are open, and Bp\Bp−h → ∅ ash ↓ 0. Henceψp0−h(A) → ψp0(A) as h ↓ 0.

In the corresponding argument for ψp1(A), the set Bp is replaced by the decreasing closed event Cp, and the difference Bp \ Bp−h is replaced by Cp+h \Cp.

We prove ﬁnally that L0p,t is reversible with respect to φp0,q; the argument is similar for L1p,t. Let f and g be increasing non-negative cylinder functions mapping to R, and let U ,0 t (respectively, Ut0) be the transition semigroup of the process pZ ,1 t (respectively, L0p,t = pZt1). For ⊆ ,

f (η)U ,0 tg(η) ≤ f (η)U ,0 tg(η) ≤ f (η)Ut0g(η), η ∈  , by Lemmas 8.31 and 8.40. Therefore,

φ ,0 p,q f (η)U ,0 tg(η) ≤ φ ,0 p,q f (η)U ,0 tg(η) ≤ φp0,q f (η)Ut0g(η) , ⊆  ,

since φ ,0 p,q ≤st φp0,q. Let ↑ Zd and ↑ Zd, and deduce by the monotone convergence theorem that

(8.89) φ ,0 p,q f (η)U ,0 tg(η) → φp0,q f (η)Ut0g(η) as ↑ Zd. The leftside of(8.89)isunchangedwhen f and g are exchanged,by the reversibility of pZ ,1 t, see Theorem 8.38. Therefore, the right side is unchanged by this exchange, implying the required reversibility (see [235, p. 91]). (b) It sufﬁces to prove (8.57) for increasing cylinder events A, since such events generate F . For such A, (8.57) follows from (8.88) in the case of φp0,q, and similarly for φp1,q. Proof of Proposition 8.59. This is a consequence of Theorem 8.56(b). (8.90) Proposition. Let q ∈ (1,∞) and p ∈ (0,1). The Markov processes L0p and L1p are not Feller processes.

Proof. For simplicity we take d = 2 and b = 0; a similar argument is valid for d > 2 and/or b = 1. Let e be the edge with endvertices (0,0) and (1,0), and let Je be the indicator function of the event that e is open. We shall show that the function Us0Je : → R is not continuous for sufﬁciently small positive values

lim ↑Zd K ,b t, a limit which exists by the usual monotonicity. We claim that there exist ǫ, η > 0, independent of the value of n, such that

(8.91) P Kη1(e) = 1, Kη0(e) = 0 > ǫ. Inequality (8.91) implies that

P(Kη1(e) = 1) − P(Kη0(e) = 1) > ǫ,

irrespective of the value of n, and therefore that the semigroup Us0 is not Feller.

In order to prove (8.91), we use a percolation argument. Let η > 0. As in Section 8.6, we consider a family of rate-1 alarm clocks indexed by E2. For each edge f , we set Bf = 0 if thealarm clockat f doesnotringduringthe time-interval [0,η], and Bf = 1 otherwise. Thus, (Bf : f ∈ E2) is a family of independent Bernoulli variables with common parameter 1 −e−η. Choose η sufﬁciently small such that

1 − e−η < 41,

![image 1039](<rcm1-1_images/imageFile1039.png>)

noting that 14 is less than the critical probability of bond percolation on the square lattice (see Chapter6 and [154]). Routine percolationargumentsmay now be used

![image 1040](<rcm1-1_images/imageFile1040.png>)

to obtain the existence of ǫ′ > 0 such that, for all boxes containing [−2n,2n]2,

P K ,1 t ∈/ De, K ,0 t ∈ De, for all t ∈ [0,η] Gη > ǫ′ P-a.s.,

where Gη is the σ-ﬁeld generated by the ringing times of the alarm clock at e up to time t, together with the associated values of α (in the language of Section 8.6).

Supposethatthe alarmclockat e ringsonceonlyduringthe time-interval[0,η], at the random time T, say. By (8.72)–(8.73), there exists ǫ′′ = ǫ′′(p,q) > 0 such that: there is (conditional) probability at least ǫ′′ that, for all ⊇ [−2n,2n]2, the edge e is declared closed at time T in the lower process K ,0 T but not in the upper process K ,1 T. The conditioning here is over all values of the doubly-stochastic Poisson processes indexed by edges other than e. Therefore,

P K ,η1 (e) = 1, K ,η0 (e) = 0 > ǫ′ǫ′′ηe−η,

for all containing [−2n,2n]2. Let ↑ Zd to obtain (8.91) with an appropriate value of ǫ.

Proof of Theorem 5.16(a). This was deferred from Section 5.2. We follow the argument of [36] as reported in [154]. For p ∈ (0,1] and ζ ∈ X, we say that an edgee is p-openif pζ(e) = 1, whichis to say thatζ(e) < p. LetCp = Cp(ζ)be the p-open cluster of Ld containing the origin, and note that Cp′ ⊆ Cp if p′ ≤ p.

By Theorem 8.56(b),

θ0(p,q) = µ(|Cp| = ∞),

[8.9] Simultaneous uniqueness 255

where µ is given in Theorem 8.53. Therefore,

(8.92)

θ0(p,q) − θ0(p−,q) = lim p′↑p

µ |Cp| = ∞, |Cp′| < ∞

= µ |Cp| = ∞, |Cp′| < ∞ for all p′ < p .

Assume that p > pc(q), and suppose |Cp| = ∞. If pc(q) < α < p, there exists (almostsurely)anα-openinﬁnitecluster Iα,andfurthermore Iα is(almostsurely)a subgraph of Cp, by the 0/1-inﬁnite-cluster property of the 0-boundary-condition random-cluster measures. Therefore, there exists a p-open path π joining the origin to some vertex of Iα. Such a path π has ﬁnite length and each edge e in π satisﬁes ζ(e) < p, whence β = max{ζ(e) : e ∈ π} satisﬁes β < p. If p′ satisﬁes p′ ≥ α and β < p′ < p then there exists a p′-open path joining the origin to some vertex of Iα, so that |Cp′| = ∞. However, p′ < p, implying that the event on the right side of (8.92) has probability zero.

8.9 Simultaneous uniqueness

One of the key facts for supercritical percolation is the (almost-sure) uniqueness of the inﬁnite open cluster, which may be stated in the following form. Let φp be the percolation (product) measure on = {0,1}Ed where d ≥ 2. We have that:

(8.93) for all p ∈ [0,1], φp has the 0/1-inﬁnite-cluster property.

Ithasbeenaskedwhetherornotthereexistsauniqueinﬁnite clustersimultaneously for all values of p. This question may be formulated as follows. First, we couple together the percolation processes for different values of p by deﬁning

1 if U(e) < p, 0 otherwise,

ηp(e) =

where the U(e), e ∈ Ed, are independentand uniformly distributed on the interval [0,1]. Let I(ω) be the number of inﬁnite open clusters in a conﬁguration ω ∈

. It is proved in [13] that there exists a deterministic non-decreasing function i : [0,1] → {0,1} such that (8.94) P I(ηp) = i(p) for all p ∈ [0,1] = 1, a statement to which we refer as ‘simultaneous uniqueness’. By (8.93) and the deﬁnition of the critical probability pc,

0 if p < pc, 1 if p > pc.

i(p) =

It is an open question to prove the conjecture that i(pc) = 0 irrespective of the number d of dimensions. See the discussion in [154, Section 8.2].

Simultaneous uniqueness may be conjectured for the random-cluster model also, using the coupling of the last section.

256 Dynamics of Random-Cluster Models [8.9]

(8.95) Conjecture (Simultaneous uniqueness). Let q ∈ [1,∞), and consider the coupling µ of the random-cluster measures φpb,q on Ld with parameter q. There exist non-decreasing functions iq,iq′ : [0,1] → {0,1} such that

µ I( pζ) = iq(p) and I( pζ) = iq′ (p), for all p ∈ [0,1] = 1.

It must be the case that iq(p) = iq′ (p) for p  = pc(q). Here is a sufﬁcient condition for simultaneous uniqueness. For r ∈ (0,1) and a box , let E (r) be the subset of the conﬁguration space X containing all ν with ν(e) < r for all e ∈ E . Thus, E (r) is the event that every edge in E is open in the conﬁguration rν. By [13, Thm 1.8], it sufﬁces to show that µ has a property termed ‘positive ﬁnite energy’. This is in turn implied by:

(8.96) µ(E (r) | T ) > 0, µ-a.s.

for all r ∈ (0,1) and boxes . Here as earlier, T is the σ-ﬁeld generated by the states of edges not belonging to E . It seems reasonable in the light of Theorem 4.17(b) to conjecture the stronger inequality

µ(E (r) | T ) ≥

r r + q(1 − r)

![image 1041](<rcm1-1_images/imageFile1041.png>)

|E |

, µ-a.s.

## Chapter 9 Flows in Poisson Graphs

Summary. The random-cluster partition function with integer q on a graph G may be transformed into the mean ﬂow-polynomial of a ‘Poissonian’ random graph obtained from G by randomizing the numbers of edges between neighbouring pairs. This leads to a ﬂow representation for the two-point Potts correlation function, and extends to general q the so-called ‘randomcurrent expansion’ of the Ising model. In the last case, one may derive the Simon–Lieb inequality together with largely complete solutions to the problems of exponential decay and the continuity of the phase transition. It is an open problem to adapt such methods to general Potts and random-cluster models.

9.1 Potts models and ﬂows

The Tutte polynomialis a function of two variables (see Section 3.6). For suitable values of these variables, one obtains counts of colourings, forests, and ﬂows, together with other combinatorial quantities, in addition to the random-cluster and Potts partition functions. The algebra of the Tutte polynomial may be used to obtain representations of the Potts correlation functions, which have in turn the potential to explain the decay of correlations in the two phases of an inﬁnitevolume Potts measure. It is thus that many beautiful results have been derived for the Ising model (when q = 2), see [3, 5, 9]. The cases q ∈ {3,4,. . .}, and more generally q ∈ (1,∞), remain largely unexplained. We summarize this methodology in this chapter, beginning with the deﬁnition of a ﬂow on a directed graph.

Let H = (W, F) be a ﬁnite graph with vertex-set W and edge-set F, and let q ∈ {2,3,. . .}. We permit H to have multiple edges and loops. To each edge e ∈ F we allocate a direction, turning H thus into a directed graph denoted by H = (W, F). When the edge e = u,v ∈ F is directed from u to v, we write

e = [u,v for the corresponding directed edge1, and we speak of u as the tail and v as the head of e. It will turn out that the choices of directions are immaterial to the principal conclusions that follow. A function f : F → {0,1,2,. . .,q − 1} is called a mod-q ﬂow on H if

(9.1)

f ( e) = 0 mod q, for all w ∈ W,

f ( e) −

e∈ F: e has head w

e∈ F: e has tail w

which is to say that ﬂow is conserved (modulo q) at every vertex. A mod-q ﬂow

f is called non-zero if f ( e)  = 0 for all e ∈ F. We write CH(q) for the number of non-zero mod-q ﬂows on H. It is standard (and an easy exercise) that CH(q) does not depend on the directions allocated to the edges of H, [313]. The function CH(q), viewed as a function of q, is called the ﬂow polynomial of H.

The ﬂow polynomialof H is an evaluation of its Tutte polynomial. Recall from Section 3.6 the (Whitney) rank-generating function and the Tutte polynomial,

- (9.2) ur(H′)vc(H′), u,v ∈ R,
- (9.3) TH(u,v) = (u − 1)|W|−k(H)WH (u − 1)−1,v − 1 ,


WH(u,v) =

F′⊆F

where r(H′) = |W| − k(H′) is the rank of the subgraph H′ = (W, F′), c(H′) = |F′| − |W| + k(H′) is its co-rank, and k(H′) is the number of its connected components (including isolated vertices). Note that

v|F′|(v/u)k(H′), u,v  = 0.

(9.4) WH(u,v) = (u/v)|W|

F′⊆F

The ﬂow polynomial of H satisﬁes (9.5) CH(q) = (−1)|F|WH(−1,−q)

= (−1)c(H)TH(0,1 − q), q ∈ {2,3,. . .}.

See[40, 313]. Whentheneedforadifferentnotationarises, weshallwriteC(H;q) for CH(q), and similarly for other polynomials.

We return now to the random-cluster and Potts models on the ﬁnite graph G = (V, E). It is convenient to allow a separate parameter for each edge of G, and thus we let J = (Je : e ∈ E) be a vectorof non-negativenumbers, and we take β ∈ (0,∞). For q ∈ {2,3,. . .}, the q-state Potts measure on the conﬁguration space = {1,2,. . .,q}V is written in this chapter as

1 ZP

(9.6) πβJ,q(σ) =

β Je(qδe(σ) − 1) , σ ∈  ,

exp

![image 1042](<rcm1-1_images/imageFile1042.png>)

e∈E

![image 1043](<rcm1-1_images/imageFile1043.png>)

1This is not a good notation since H may have multiple edges.

where, for e = x, y ∈ E,

δe(σ) = δσx,σy =

and ZP is the partition function

1 if σx = σy, 0 otherwise,

(9.7) ZP =

exp

β Je(qδe(σ) − 1) .

e∈E

σ∈

This differs slightly from (1.5)–(1.6) in that different edges e may have different interactions Je, and these interactions have been ‘re-parametrized’ by the factor q. The reason for deﬁning πβJ,q thus will emerge in the calculations that follow.

The corresponding two-point correlation function is given as in (1.14) by

(9.8) τβJ,q(x, y) = πβJ,q(σx = σy) −

1 q

, x, y ∈ V.

![image 1044](<rcm1-1_images/imageFile1044.png>)

We shall work often with the quantity qτβJ,q(x, y) = πβJ,q(qδσx,σy − 1) and, for ease of notation in the following, we write

(9.9) σ(x, y) = qτβJ,q(x, y), x, y ∈ V,

thereby suppressing reference to the parameters βJ and q. Note that, for the Ising case with q = 2, σ(x, y) is simply the mean of the product σxσy of the Ising spins at x and at y, see (1.7).

From the graph G = (V, E) we constructnext a certain random graph. For any vector m = (m(e) : e ∈ E) of non-negative integers, let Gm = (V, Em) be the graph with vertex set V and, for each e ∈ E, with exactly m(e) edges in parallel joining the endvertices of the edge e [the original edge e is itself removed]. Note that

(9.10) |Em| =

m(e).

e∈E

Let λ = (λe : e ∈ E) be a family of non-negative reals, and let P = (P(e) : e ∈ E) be a family of independent random variables such that P(e) has the Poisson distribution with parameter λe. We now consider the random graph GP = (V, EP), which we call a Poisson graph with intensity λ. Write Pλ and Eλ for the corresponding probability measure and expectation operator.

For x, y ∈ V, x  = y, we denote by GxP,y the graph obtained from GP by adding an edge with endvertices x, y. If x and y are already adjacent in GP, we add exactly one further edge between them. Potts-correlations and ﬂows are related by the following theorem2.

![image 1045](<rcm1-1_images/imageFile1045.png>)

2The relationship between ﬂows and correlation functions has been explored also in [112, 246, 247].

- (9.11) Theorem [146, 157]. Let q ∈ {2,3,. . .} and λe = β Je. Then
- (9.12) σ(x, y) =


Eλ(C(GxP,y; q)) Eλ(C(GP; q))

, x, y ∈ V.

![image 1046](<rcm1-1_images/imageFile1046.png>)

This formula takes an especially simple form when q = 2, since non-zero mod-2 ﬂows necessarily take the value 1 only. A ﬁnite graph H = (W, F) is called even if the degree of every vertex w ∈ W is even. It is elementary that CH(2) = 1 (respectively, CH(2) = 0) if H is even (respectively, not even), and therefore

- (9.13) Eλ(CH(2)) = Pλ(H is even). By (9.12), for any graph G,
- (9.14) σ(x, y) =


Pλ(GxP,y is even) Pλ(GP is even)

,

![image 1047](<rcm1-1_images/imageFile1047.png>)

when q = 2. Observations of this sort have led to the so-called ‘randomcurrent’ expansion for Ising models, thereby after some work [3, 5, 9] yielding proofs amongst other things of the exponential decay of correlations in the hightemperature regime. We return to the case q = 2 in Sections 9.2–9.4.

Whereas Theorem 9.11 concerns Potts models only, there is a random-cluster generalization. We restrict ourselves here to the situation in which every edge has the same parameter p, but we note that the result is easily generalized to allowing different parameters for each edge. Recall that φG,p denotes product measure on

= {0,1}E with density p.

(9.15) Theorem [146, 157]. Let p ∈ [0,1) and q ∈ (0,∞). Let λe = λ for all e ∈ E, where p = 1 − e−λq.

(a) For x, y ∈ V,

Eλ (−1)c(EP∪ x,y )T(GxP,y; 0,1 − q) Eλ (−1)c(EP)T(GP; 0,1 − q)

(q −1)φG,p,q(x ↔ y) =

, (9.16)

![image 1048](<rcm1-1_images/imageFile1048.png>)

where c(F) is the co-rank of the graph (V, F). In particular,

Eλ(C(GxP,y; q)) Eλ(C(GP; q))

, q ∈ {2,3,. . .}. (9.17)

(q − 1)φG,p,q(x ↔ y) =

![image 1049](<rcm1-1_images/imageFile1049.png>)

(b) For q ∈ {2,3,. . .},

φG,p(qk(ω)) = (1 − p)|E|(q−2)/qq|V|Eλ(C(GP; q)). (9.18) When q = 2, equation (9.18) reduces by (9.13) to

(9.19) φG,p(2k(ω)) = 2|V|Pλ(GP is even).

This may be simpliﬁed further. Let ζ(e) = P(e) modulo 2. It is easily seen that GP is even if and only if Gζ is even, and that the ζ(e), e ∈ E, are independent Bernoulli variables with

Pλ(ζ(e) = 1) = 21(1 − e−2λ) = 12 p. Equation (9.18) may therefore be written as (9.20) φG,p(2k(ω)) = 2|V|φG,p/2(the open subgraph of G is even). Proof ofTheorem 9.11. Since the parameter β appearsalways with the multiplicative factor Je, we may without loss of generality take β = 1.

![image 1050](<rcm1-1_images/imageFile1050.png>)

![image 1051](<rcm1-1_images/imageFile1051.png>)

We begin with a calculation involving the Potts partition function ZP given in (9.7). Let Z+ = {0,1,2,. . .} and consider vectors m = (me : e ∈ E) ∈ Z+E. By a Taylor expansion in the variables Je,

Jeme me!

e−Je ∂mZP

(9.21)

exp −

Je ZP =

![image 1052](<rcm1-1_images/imageFile1052.png>)

J=0

m∈Z+E e∈E

e∈E

= Eλ ∂P ZP

J=0

where

∂me ∂ Jeme

∂mZP =

ZP, m ∈ Z+E. By (9.7) with β = 1, and similarly to the proof of Theorem 1.10(a), ∂mZP

![image 1053](<rcm1-1_images/imageFile1053.png>)

e∈E

(9.22) (qδe(σ) − 1)me

=

J=0

σ∈ e∈E

(qδe(σ) − 1)

=

σ∈ e∈Em

[−δne,0 + δne,1qδe(σ)]

=

σ∈ e∈Em ne∈{0,1}

(−1)|{e:ne=0}|q|{e:ne=1}|

δe(σ)ne

=

e∈Em

n∈{0,1}Em σ∈

(−1)|{e:ne=0}|q|{e:ne=1}|qk(m,n),

=

n∈{0,1}Em

where k(m,n) is the numberof connected componentsof the graph obtained from Gm after deletion of all edges e with ne = 0. Therefore, by (9.4)–(9.5),

(9.23) (−q)|{e:ne=1}|qk(m,n)

= (−1)|Em|

∂mZP

J=0

n∈{0,1}Em

= (−1)|Em|q|V|WGm(−1,−q)

= q|V|C(Gm; q).

Combining (9.21)–(9.23), we conclude that

Je ZP = q|V|Eλ(C(GP; q)).

(9.24) exp −

e∈E

Note in passing that equation (9.18) follows as in (1.12).

Let x, y ∈ V. We deﬁne the unordered pair f = (x, y), and write δf (σ) = δσx,σy for σ ∈ . Then (9.25) σ(x, y) = πβJ,q(qδf (σ) − 1)

1 ZP σ∈

(qδf (σ) − 1)exp

β Je(qδe(σ) − 1) .

=

![image 1054](<rcm1-1_images/imageFile1054.png>)

e∈E

By an analysis parallel to (9.21)–(9.24),

(9.26) β Je(qδe(σ) − 1)

(qδf (σ) − 1)exp

exp −

Je

e∈E

e∈E

σ∈

= q|V|Eλ(C(GxP,y; q)), and (9.12) follows by (9.24) and (9.25). Proof of Theorem 9.15. This theorem may be proved directly, but we shall derive it from Theorem 9.11.

- (a) Equation (9.17) holds by Theorems 1.16 and 9.11. By (9.5), equation (9.16) holds for q ∈ {2,3,. . .}. Since both sides are the ratios of polynomials in q and e−λq of ﬁnite order, (9.16) is an identity in q ∈ (0,∞).
- (b) This was noted after (9.24) above.


9.2 Flows for the Ising model

Henceforth in this chapter we assume that q = 2, and we begin with a reminder. Let H = (W, F) be a ﬁnite graph, and let degF(w) denote the degree of the vertex w. We call H an even graphif degF(w) is evenforevery w ∈ W. Let H = (V, F) be a directed graph obtained from H by assigning a direction to each edge in F. Since a non-zero mod-2 ﬂow on H may by deﬁnition take only the value 1,

(9.27) CH(2) =

1 if H is even, 0 otherwise.

Consider the Ising modelon a ﬁnite graph G = (V, E) with parameters λe = β Je, e ∈ E. As in (9.14),

Pλ(GxP,y is even) Pλ(GP is even)

(9.28) σ(x, y) = 2τλ,2(x, y) =

.

![image 1055](<rcm1-1_images/imageFile1055.png>)

The value of such a representation will become clear in the following discussion, which is based on material in [3, 234, 300]. In advance of this, we make a remark concerning (9.28). In deciding whether GP or GxP,y is an even graph, we need only know the numbers P(e) when reduced modulo 2. That is, we can work with ζ ∈ = {0,1}E given by ζ(e) = P(e) mod 2. Since P(e) has the Poisson distribution with parameter λe, ζ(e) has the Bernoulli distribution with parameter

pe′ = Pλ(P(e) is odd) = 12(1 − e−2λe). We obtain thus from (9.28) that

![image 1056](<rcm1-1_images/imageFile1056.png>)

φp′(∂ζ = {x, y}) φp′(∂ζ = ∅)

(9.29) σ(x, y) =

,

![image 1057](<rcm1-1_images/imageFile1057.png>)

where p′ = (pe′ : e ∈ E), φp′ denotes product measure on with edge-densities pe′, and

∂ζ = v ∈ V :

ζ(e) is odd , ζ ∈  ,

e: e∼v

where the sum is over all edges e incident to v.

Let M = (Me : e ∈ E) be a sequence of disjoint ﬁnite sets indexed by E, and let me = |Me|. As noted in the last section, the vector M may be used to construct a multigraph Gm = (V, Em) in which each e ∈ E is replaced by me edges in parallel; we may take Me to be the set of such edges. For x, y ∈ V, we write ‘x ↔ y in m’ if x and y lie in the same component of Gm. We deﬁne the set ∂M of sources of M by

(9.30) ∂M = v ∈ V :

me is odd .

e: e∼v

Forexample, Gm is evenifandonlyif ∂M = ∅. Fromthe vector M we constructa vector N = (Ne : e ∈ E) by deleting each memberof each Me with probability 21, independentlyof all otherelements. Thatis, we let Bi, i ∈ e Me, be independent Bernoulli random variables with parameter 21, and we set

![image 1058](<rcm1-1_images/imageFile1058.png>)

![image 1059](<rcm1-1_images/imageFile1059.png>)

Ne = {i ∈ Me : Bi = 1}, e ∈ E. Let PM denote the appropriate probability measure.

The following technical lemma is pivotal for the computations that follow.

(9.31) Theorem. Let M and m be as above. If x, y ∈ V are such that x  = y and x ↔ y in m then, for A ⊆ V,

PM ∂N = {x, y}, ∂(M \ N) = A = PM ∂N = ∅, ∂(M \ N) = A △ {x, y} .

Proof. Take Me to be the set of edges of Gm parallel to e, and assume that x ↔ y in m. Let A ⊆ V. Let M be the set of all vectors n = (ne : e ∈ E) with ne ⊆ Me for e ∈ E. Let α be a ﬁxed path of Gm with endvertices x, y, viewed as a set of edges, and consider the map ρ : M → M given by

ρ(n) = n △ α, n ∈ M.

The map ρ is one–one, and maps {n ∈ M : ∂n = {x, y}, ∂(M \ n) = A} to {n′ ∈ M : ∂n′ = ∅, ∂(M \ n′) = A △ {x, y}}. Each member of M is equiprobable under PM, and the claim follows.

Let λ = (λe : e ∈ E) be a vector of non-negative reals, and recall the Poisson graph with parameter λ. The following is a fairly immediate corollary of the last theorem. Let M = (Me : e ∈ E) and M′ = (Me′ : e ∈ E) be vectors of disjoint ﬁnitesetssatisfying Me∩M′

f = ∅foralle, f ∈ E, andletme = |Me|, m′e = |Me′|, e ∈ E, beindependentrandomvariablessuchthateach meandm′e havethePoisson distribution with parameter λe. Let M ∪ M′ = (Me ∪ Me′ : e ∈ E), and write P for the appropriate probability measure. The following lemma is based on the so-called switching lemma of [3].

(9.32) Corollary (Switching lemma). If x, y ∈ V are such that x  = y and x ↔ y in m + m′ then, for A ⊆ V,

P ∂M = {x, y}, ∂M′ = A M ∪ M′

= P ∂M = ∅, ∂M′ = A △ {x, y} M ∪ M′ , P-a.s.

Proof. Conditional on the sets Me ∪ Me′, e ∈ E, the sets Me are selected by the independent removal of each element with probability 21. The claim follows from Theorem 9.31.

![image 1060](<rcm1-1_images/imageFile1060.png>)

We present two applications of Corollary 9.32 to the Ising model, as in [3]. For m = (me : e ∈ E) ∈ Z+E, let (9.33) ∂m = v ∈ V :

me is odd ,

e: e∼v

as in (9.30). In our study of the correlation functions τλ,2(x, y), we shall as before write

σ(x, y) = 2τλ,2(x, y) = πλ,2(2δσx,σy − 1), x, y ∈ V.

By (9.29), (9.34) σ(x, y) =

Pλ(∂P = {x, y}) Pλ(∂P = ∅)

. Let QA denote the law of P conditional on the event {∂P = A}, that is, QA(E) = Pλ(P ∈ E | ∂P = A).

![image 1061](<rcm1-1_images/imageFile1061.png>)

We shall require two independent copies P1, P2 of P with potentially different conditionings, and thus we write QA;B = QA × QB.

(9.35) Theorem [3]. Let x, y, z ∈ V be distinct vertices. Then:

σ(x, y)2 = Q∅;∅(x ↔ y in P1 + P2), σ(x, y)σ(y, z) = σ(x, z)Q{x,z};∅(x ↔ y in P1 + P2).

Proof. By (9.34) and Corollary 9.32,

Pλ × Pλ(∂P1 = {x, y}, ∂P2 = {x, y}) Pλ(∂P = ∅)2

σ(x, y)2 =

![image 1062](<rcm1-1_images/imageFile1062.png>)

Pλ × Pλ(∂P1 = {x, y}, ∂P2 = {x, y}, x ↔ y in P1 + P2) Pλ(∂P = ∅)2

=

![image 1063](<rcm1-1_images/imageFile1063.png>)

Pλ × Pλ(∂P1 = ∂P2 = ∅, x ↔ y in P1 + P2) Pλ(∂P = ∅)2

=

![image 1064](<rcm1-1_images/imageFile1064.png>)

= Q∅;∅(x ↔ y in P1 + P2).

Similarly, σ(x, y)σ(y, z)

Pλ × Pλ(∂P1 = {x, y}, ∂P2 = {y, z}) Pλ(∂P = ∅)2

=

![image 1065](<rcm1-1_images/imageFile1065.png>)

Pλ × Pλ(∂P1 = ∅, ∂P2 = {x, z}, x ↔ y in P1 + P2) Pλ(∂P = ∅)2

=

![image 1066](<rcm1-1_images/imageFile1066.png>)

Pλ(∂P2 = {x, z}) Pλ(∂P = ∅) · Pλ × Pλ x ↔ y in P1 + P2 ∂P1 = ∅, ∂P2 = {x, z}

=

![image 1067](<rcm1-1_images/imageFile1067.png>)

= σ(x, z)Q{x,z};∅(x ↔ y in P1 + P2).

Theorem9.35 leads to an importantcorrelationinequalityknown as the ‘Simon inequality’. Let x, z ∈ V be distinct vertices. A subset W ⊆ V is said to separate x and z if x, z ∈/ W and every path from x to z contains some vertex of W.

(9.36) Corollary (Simon inequality) [300]. Let x, z ∈ V be distinct vertices, and let W separate x and z. Then

σ(x, z) ≤

σ(x, y)σ(y, z).

y∈W

Proof. By Theorem 9.35,

σ(x, y)σ(y, z) σ(x, z) =

Q{x,z};∅(x ↔ y in P1 + P2)

![image 1068](<rcm1-1_images/imageFile1068.png>)

y∈W

y∈W

= Q{x,z};∅ |{y ∈ W : x ↔ y in P1 + P2}| .

Assume that the event ∂P1 = {x, z} occurs. On this event, x ↔ z in P1 + P2. Since W separates x and z, the set {y ∈ W : x ↔ y in P1 + P2} is non-empty on this event. Therefore, its mean cardinality is at least one under the measure Q{x,z};∅, and the claim follows.

The Ising model on G = (V, E) corresponds as described in Chapter 1 to a

random-cluster measure φG,p,q with q = 2. By Theorem 1.10, if λe = λ for all e, σ(x, y) = 2τλ,2(x, y) = φG,p,q(x ↔ y),

where p = 1−e−λq and q = 2. Therefore, the Simon inequality3 may be written in the form

(9.37) φG,p,q(x ↔ z) ≤

φG,p,q(x ↔ y)φG,p,q(y ↔ z)

y∈W

whenever W separates x and z. It is a curious fact that this inequality holds also when q = 1, as noticed by Hammersley [177]; see [154, Chapter 6]. It may be conjectured that it holds whenever q ∈ [1,2].

The Simon inequality has an important consequence for the random-cluster model with q = 2 on an inﬁnite lattice, namely that the two-point correlation function decays exponentially whenever it is summable. Let φp,q be the randomcluster measure on Ld where d ≥ 2. We shall consider only the case p < pc(q), and it is therefore unnecessary to mention boundary conditions.

(9.38) Corollary [300]. Let d ≥ 2, q = 2, and let p be such that (9.39)

φp,q(0 ↔ x) < ∞.

x∈Zd

There exists γ = γ(p,q) ∈ (0,∞) such that φp,q(0 ↔ z) ≤ e− z γ(p,q), z ∈ Zd.

By the corollary, condition (9.39) is both necessary and sufﬁcient for exponential decay. Related results for exponential decay appear in Section 5.4–5.6. Proof. We use the Simon inequality in the form (9.37) as in [177, 300]. Let

n = [−n,n]d and ∂ n = n \ n−1, and take q = 2. By (9.37) with G = n, and Proposition 5.12,

(9.40) φp,q(x ↔ z) ≤

φp,q(x ↔ y)φp,q(y ↔ z),

y∈W

![image 1069](<rcm1-1_images/imageFile1069.png>)

3In association with related inequalities of Hammersley [177] and Lieb [234], see Theorem 9.44(b), this is an example of what is sometimes called the Hammersley–Simon–Lieb inequality. The Simon inequality is a special case of the Boel–Kasteleyn inequalities, [56, 57].

for x, z ∈ Zd and any ﬁnite separating set W. By (9.39), there exists c ∈ (0,1) and N ≥ 1 such that

φp,q(0 ↔ x) < c.

x∈∂ N

For any integer k > 1 and any vertex z ∈ ∂ kN, we have by progressive use of (9.40) and the translation-invariance of φp,q (see Theorem 4.19(b)) that

φp,q(0 ↔ z) ≤

φp,q(0 ↔ x1)φp,q(x1 ↔ z)

x1: x1 =N

φp,q(0 ↔ x1)φp,q(x1 ↔ x2)φp,q(x2 ↔ z)

≤

x2: x2−x1 =N

x1: x1 =N

φp,q(0 ↔ x1)···φp,q(xk−1 ↔ xk)φp,q(xk ↔ z)

≤

···

x1: x1 =N

xk: xk−xk−1 =N

≤ ck. Therefore, there exists g > 0 such that

φp,q(0 ↔ z) ≤ e− z g if z is a multiple of N. More generally, let z ∈ Zd and write z = kN + l where 0 ≤ l < N. By (9.40),

φp,q(0 ↔ x)φp,q(x ↔ z) ≤ e−kNg.

φp,q(0 ↔ z) ≤

x: x =kN

Furthermore, φp,q(0 ↔ z) < 1 for z  = 0, and the claim follows.

We close this section with an improvementof the Simon inequality due to Lieb [234]. This improvement may seem at ﬁrst sight to be slender, but it leads to a signiﬁcant conclusion termed the ‘vanishing of the mass gap’.

We ﬁrst re-visit Theorem 9.31. As usual, G = (V, E) is a ﬁnite graph, and we partition E as E = F ∪ H, where F ∩ H = ∅. Let M = (Me : e ∈ E) be a vector of disjoint ﬁnite sets with cardinalities me = |Me|. We write MF = (Me : e ∈ F) and deﬁne the vector mF by

me if e ∈ F, 0 otherwise,

meF =

and similarly for MH and mH. It is elementary that m = mF + mH, and that the sets of sources of MF and MH are related by

(9.41) ∂MF △ ∂MH = ∂M.

As before Theorem 9.31, we select subsets Ne from the Me by deleting each member independentlyat random with probability 21. For given M, the associated probability measure is denoted by PM.

![image 1070](<rcm1-1_images/imageFile1070.png>)

(9.42) Theorem. Let F, H, M, and m be as above. If x, y ∈ V are such that x  = y and x ↔ y in mF then, for A ⊆ V,

PM ∂NF = {x, y}, ∂NH = ∅, ∂(M \ N) = A

= PM ∂NF = ∅, ∂NH = ∅, ∂(M \ N) = A △ {x, y} .

Proof. This follows that of Theorem 9.31. Let α be a ﬁxed path of GmF with endvertices x and y, and consider the map ρ(n) = n △ α, n ∈ M. This map is a one–one correspondence between the two subsets of M corresponding to the two events in question.

We obtain as in the switching lemma, Corollary 9.32, the following corollary involving the two independent random vectors M and M′, each being such that me = |Me| and m′e = |Me′| have the Poisson distribution with parameter λ ∈ [0,∞). The proof follows that of Corollary 9.32.

(9.43) Corollary. Let E be partitioned as E = F ∪ H. If x, y ∈ V are such that x  = y and x ↔ y in mF + m′F then, for A ⊆ V,

P ∂MF = {x, y}, ∂MH = ∅, ∂M′ = A M ∪ M′

= P ∂MF = ∅, ∂MH = ∅, ∂M′ = A △ {x, y} M ∪ M′ , P-a.s.

Let P1 and P2 be independent copies of the Poisson ﬁeld P, with intensity λ ∈ [0,∞), and let E be partitioned as E = F ∪ H. We write QA,B;C for the probability measure governing the pair P1, P2 conditional on the event {∂P1F = A} ∩ {∂P1H = B} ∩ {∂P2 = C}. We recall from (9.28) that σ(x, y) denotes a certain correlation function associated with the graph G = (V, E), and we write σ F(x, y) for the quantity deﬁned similarly on the smaller graph (V, F).

(9.44) Theorem. Let x, y, z ∈ V be distinct vertices, and let F ⊆ E.

(a) We have that

σ F(x, y)σ(y, z) = σ(x, z)Q∅,∅;{x,z}(x ↔ z in P1F + P2F). (b) Lieb inequality [234]. Let W separate x and z, and let F be the set of edges with at least one endvertex not separated by W from x. Then σ(x, z) ≤

σ F(x, y)σ(y, z).

y∈W

Thesets W and F ofpart(b)are illustratedin Figure9.1. By the random-cluster representation of Theorem 1.16 and positive association,

σ F(x, y) = φG,p,q(x ↔ y | all edges in E \ F are closed) ≤ φG,p,q(x ↔ y) = σ(x, y),

where q = 2. Condition (9.45) is a ‘ﬁnite-volume condition’ in that it uses probability measures on ﬁnite graphs only. We arrive thus at the following result, sometimes termed the ‘vanishing of the mass gap’. Let q = 2 and

1 n

logφp0,q(0 ↔ ∂ n)

ψ(p,q) = lim

−

![image 1071](<rcm1-1_images/imageFile1071.png>)

n→∞

asinTheorem5.45. Itisclearthatψ(p,q)isnon-increasingin p,andψ(p,q) = 0 if p > pc(q). One of the characteristics of a ﬁrst-order phase transition is the (strict) exponentialdecay of free-boundary-conditionconnectivityprobabilities at the critical point, see Theorems 6.35(c) and 7.33.

(9.46) Theorem (Vanishing mass gap) [234]. Let q = 2. Then ψ(p,q) decreases to 0 as p ↑ pc(q). In particular, ψ(pc(q),q) = 0.

Proof. We consider only values of p satisfying ǫ < p < 1 − ǫ where ǫ > 0 is ﬁxed and small. Let k ≥ 1, and let η(ω) be the set of open edgesof a conﬁguration ω. By Theorem 3.12 and the Cauchy–Schwarz inequality, with q = 2 throughout,

d dp x∈∂ 

φ k,p,q(0 ↔ x)

0 ≤

![image 1072](<rcm1-1_images/imageFile1072.png>)

k

1 ǫ(1 − ǫ)

covk(|η|,1{0↔x})

≤

![image 1073](<rcm1-1_images/imageFile1073.png>)

x∈∂ k

1 ǫ(1 − ǫ)

![image 1074](<rcm1-1_images/imageFile1074.png>)

φ k,p,q(|η|2)

≤

![image 1075](<rcm1-1_images/imageFile1075.png>)

x∈∂ k

≤ C1k2d−1,

for some constant C1 = C1(ǫ), where covk denotes covariance with respect to φ k,p,q. Therefore, for ǫ < p < p′ < 1 − ǫ,

φ k,p′,q(0 ↔ x) ≤ C1k2d−1(p′ − p) +

x∈∂ k

φ k,p,q(0 ↔ x).

x∈∂ k

Itfollowsthat, if(9.45)holdsforsome p ∈ (ǫ,1−ǫ), thenitholdsforsome p′ > p. That is, if φp,q(0 ↔ z) decays exponentially as z → ∞, then the same holds for some p′ satisfying p′ > p. The set {p ∈ (0,1) : ψ(p,q) > 0} is therefore open. Since ψ(p,q) = 0 for p > pc(q), we deduce that ψ(pc(q),q) = 0.

By Theorem 4.28(c) and the second inequality of (5.46), ψ(p,q) is the limit from above of upper-semicontinuous functions of p. Therefore, ψ(p,q) is itself upper-semicontinuous, and hence left-continuous.

Could some of the results of this section be valid for more general values of q than simply q = 2? It is known that the mass gap vanishes when q = 1, [154, Thm 6.14], and does not vanish for sufﬁciently large values of q (and any d ≥ 2),

[9.2] Flows for the Ising model 271

see [224] and Section 7.5. Therefore, Theorem 9.44(b) is not generally true for large q. It seems possible that the conclusions hold for sufﬁciently small q, but this is unproven.

One may ask whether the weaker Simon inequality, Corollary 9.36, might hold for more generalvalues of q. The followingexamplewould need to be assimilated in any such result.

- (9.47) Example4. Let G = (V, E) be a cycle of length m, illustrated in Figure 9.2. We work with the partition function
- (9.48) Y =


|η(ω)|

p 1 − p

qk(ω),

![image 1076](<rcm1-1_images/imageFile1076.png>)

ω∈

where = {0,1}E as usual. Since

1 if η(ω) = E, m − |η(ω)| otherwise,

k(ω) =

we have that

m−1

m j

(9.49) αjqm−j + αmq = (α + q)m − αm + αmq

Y =

j=0

= Qm + (q − 1)αm. where

p 1 − p

, Q = q + α.

α =

![image 1077](<rcm1-1_images/imageFile1077.png>)

Let x, y ∈ V, let P1, P2 be the two paths joining x and y, and let k and l be their respective lengths. Conﬁgurations which contain P1 but not P2 contribute

l−1

Y1 =

j=0

l j

l−1

αk+jqm−k−j = αk

j=0

l j

αjql−j = αk(Ql − αl)

to the summation of (9.48), with a similar contribution Y2 from conﬁgurations containing P2 but not P1. The single conﬁguration containing both P1 and P2 contributes Y12 = qαm to the summation. Therefore,

Y1 + Y2 + Y12 Y

(9.50)

φp,q(x ↔ y) =

![image 1078](<rcm1-1_images/imageFile1078.png>)

(α/Q)k + (α/Q)l + (q − 2)(α/Q)m 1 + (q − 1)(α/Q)m

=

.

![image 1079](<rcm1-1_images/imageFile1079.png>)

![image 1080](<rcm1-1_images/imageFile1080.png>)

4Calculations by S. Janson, on 11 March 2003 at Melbourn.

w1

x y

w2

Figure 9.2. A cycle of length 8 with four marked vertices.

Consider now the speciﬁc example illustrated in Figure 9.2. Take m = 8, let x, y be opposite one another, and let w1, w2 be the intermediate vertices indicated in the ﬁgure. For ﬁxed q and small α, by (9.50),

(9.51) φp,q(x ↔ y) = 2

α Q

![image 1081](<rcm1-1_images/imageFile1081.png>)

4

+ (q − 2)

α Q

![image 1082](<rcm1-1_images/imageFile1082.png>)

8

+ O(α12).

[A corresponding expression is valid for ﬁxed α and large q.] Similarly,

φp,q(x ↔ wj) = φp,q(wj ↔ y) =

α Q

![image 1083](<rcm1-1_images/imageFile1083.png>)

2

+

Hence,

(9.52)

2

j=1

φp,q(x ↔ wj)φp,q(wj ↔ y) = 2

= 2

α Q

![image 1084](<rcm1-1_images/imageFile1084.png>)

α Q

![image 1085](<rcm1-1_images/imageFile1085.png>)

α Q

![image 1086](<rcm1-1_images/imageFile1086.png>)

6

+ O(α8), j = 1,2.

2

+

α Q

![image 1087](<rcm1-1_images/imageFile1087.png>)

6

+ O(α8)

2

4

+ 4

α Q

![image 1088](<rcm1-1_images/imageFile1088.png>)

8

+ O(α10).

Comparing (9.51)–(9.52), we see that

φp,q(x ↔ y) >

2

φp,q(x ↔ wj)φp,q(wj ↔ y)

j=1

if q > 6 and α is sufﬁciently small. This may be compared with (9.37).

![image 1089](<rcm1-1_images/imageFile1089.png>)

[9.3] Exponential decay for the Ising model 273

9.3 Exponential decay for the Ising model

In the remaining two sections of this chapter, we review certain aspects of the mathematics of the Ising model in two and more dimensions. Several of the outstandingproblemsforPottsandrandom-clustermodelshave rigoroussolutions in the Ising case, when q = 2, and it is a challenge of substance to extend such results (where valid) to the case of general q ∈ [1,∞). Our account of the Ising model will be restricted to the work of Aizenman, Barsky, and Fernandez´ as reported in two major papers [5, 9], of which we begin in this section with the ﬁrst. The principal technique of these papers is the so-called ‘random-current representation’, that is, the representation of the Ising random ﬁeld in terms of non-zero mod-2 ﬂows. See, for example, the representation (9.28) for the twopoint correlation function. Without more ado, we state the main theorem in the language of the random-cluster model.

#### (9.53) Theorem (Finite susceptibility for q = 2 random-cluster model) [5].

Let p ∈ [0,1], q = 2, d ≥ 2, and let φp1,q be the wired random-cluster measure on Ld. The open cluster C at the origin satisﬁes

φp1,q(|C|) < ∞, p < pc(q).

This implies exponential decay, by Theorem 9.38: if p < pc(q), the connectivity function φp1,q(0 ↔ z) decays exponentially to zero as z → ∞. When d = 2, it implies that pc(2) =

√2), see Theorem 6.18.

√2/(1 +

![image 1090](<rcm1-1_images/imageFile1090.png>)

![image 1091](<rcm1-1_images/imageFile1091.png>)

- (9.54)Theorem(Mean-ﬁeldbound)[5]. UndertheconditionsstatedinTheorem 9.53, there exists a constant c = c(d) > 0 such that the percolation probability θ1(p,q) = φp1,q(0 ↔ ∞) satisﬁes
- (9.55) θ1(p,2) ≥ c(p − pc)12, p > pc = pc(2).


![image 1092](<rcm1-1_images/imageFile1092.png>)

Throughtheuseofscalingtheory(see[154,Chapter9]), one isledtopredictions concerningtheexistenceofcriticalexponentsforquantitiesexhibitingsingularities at the critical point pc(q). It is believed in particular that the function θ(·,2) possesses a critical exponent5 in that there exists b ∈ (0,∞) satisfying

(9.56) θ1(p,2) = |p − pc|b(1+o(1)) as p ↓ pc = pc(2).

If this is true, then b ≤ 21 by Theorem 9.54. It turns out that the latter inequality is sharp in the sense that, when d ≥ 4, it is satisﬁed with equality; see Theorem

![image 1093](<rcm1-1_images/imageFile1093.png>)

9.58. Thevalueb = 21 isin additionthe‘mean-ﬁeld’valueofthecriticalexponent,

![image 1094](<rcm1-1_images/imageFile1094.png>)

![image 1095](<rcm1-1_images/imageFile1095.png>)

5We write b rather than the more usual β for the critical exponent associated with the percolation probability, in order to avoid duplication with the inverse-temperature of the Ising model.

274 Flows in Poisson Graphs [9.4]

as we shall see in Section 10.7 in the context of the random-cluster model on a complete graph.

Proofs of the above theorems may be found in [5], and are omitted from the current work since they are Ising-speciﬁc and have not (yet) been generalized to the random-clustersetting for general q. The key ingredientis the random-current representation of the last section, utilized with ingenuity.

Nevertheless, included here is the briefest sketch of the approach; there is a striking similarity to, but also striking differences from, that used to prove corresponding results for percolation, see [4], [154, Section 5.3]. First, one introduces an external ﬁeld h into the ferromagnetic Ising model with inverse-temperature β. This amounts in the context of the random-cluster model to the inclusion of a special vertex called by some the ‘ghost’, to which every vertex is joined by an edge with parameter γ = 1 − e−βh. One works on a ﬁnite box with ‘toroidal’ boundary conditions. An important step in the proof is the following differential inequality for the mean spin-value M (β,h) at the origin:

∂M

∂M ∂(βh) + M2 β

(9.57) M ≤ tanh(βh)

∂β + M . The proof of this uses the random-current representation.

![image 1096](<rcm1-1_images/imageFile1096.png>)

![image 1097](<rcm1-1_images/imageFile1097.png>)

Equation (9.57) is complemented by two further differential inequalities: ∂M ∂β ≤ J M

∂M ∂(βh)

∂M ∂(βh) ≤

M βh

,

.

![image 1098](<rcm1-1_images/imageFile1098.png>)

![image 1099](<rcm1-1_images/imageFile1099.png>)

![image 1100](<rcm1-1_images/imageFile1100.png>)

![image 1101](<rcm1-1_images/imageFile1101.png>)

Using an analysis presented in [4] for percolation, the three inequalities above imply Theorem 9.54.

9.4 The Ising model in four and more dimensions

Just as two-dimensionalsystems have special properties, so there are special arguments valid when the number d of dimensions is sufﬁciently large. For example, percolation in 19 and more dimensions is rather well understood through the work of Hara and Slade and others, [23], [154, Section 10.3], [179, 303], using the so-called ‘lace expansion’. One expects that results for percolation in high dimensions will be extended in due course to d > 6, and even in part to d ≥ 6. Key to this work is the so-called ‘triangle condition’, namely that T(pc) < ∞ where pc = pc(1) and

φp(0 ↔ x)φp(x ↔ y)φp(y ↔ 0).

T(p) =

x,y∈Zd

The situation for the Ising model, and therefore for the q = 2 random-cluster model, is also well understood,but this time underthe considerablyless restrictive

[9.4] The Ising model in four and more dimensions 275

assumption that d ≥ 4. The counterpart of the triangle condition is the ‘bubble condition’,namelythat B(βc) < ∞ where, in theusualnotationofthe Isingmodel without external ﬁeld,

σ0 σx 2.

B(β) =

x∈Zd

In the language of the random-clustermodel with p = 1−e−β, the corresponding quantity is

φp0,2(0 ↔ x)2.

B(β) =

x∈Zd

Once again, one introduces an external ﬁeld and then establishes a differential inequality via the random-current representation. We state the main result in the language of the random-cluster model.

(9.58) Theorem (Critical exponent for q = 2 random-cluster model) [9]. Let q = 2 and d ≥ 4. We have that

θ1(p,q) = (p − pc)21(1+o(1)) as p ↓ pc = pc(2).

![image 1102](<rcm1-1_images/imageFile1102.png>)

Thus, the critical exponent b exists when d ≥ 4, and it takes its ‘mean-ﬁeld’

value b = 21. This implies in particular that the percolation probability θ1(p,2) is a continuous function of p at the critical value pc(2). Continuity has been proved by classical methods in two dimensions6, and there remains only the d = 3 case for which the continuity of θ1(·,2) is as yet unproved. In summary, it is proved when d  = 3 that the phase transition is of second order, and this is believed to be so when d = 3 also.

![image 1103](<rcm1-1_images/imageFile1103.png>)

Similarly to the results of the last section, Theorem 9.58 is proved by an analysis of the model parametrized by the two variables β, h. This yields several further facts including an exact critical exponent for the behaviour of the Ising magnetization M(β,h) with β = βc and h ↓ 0, namely

M(βc,h) = h 13(1+o(1)) as h ↓ 0.

![image 1104](<rcm1-1_images/imageFile1104.png>)

We refer the reader to [5, 9] for details of the random-current representation in practice, for proofs of the above results and of more detailed asymptotics, and for a more extensive bibliography. The random-current representation is a key ingredient in the derivation of a lace expansion for the Ising model with either nearest-neighbour or spread-out interactions, [288]. This has led to asymptotic formulaeforthetwo-pointcorrelationfunctionwhen d > 4. Abroaderperspective on phase transitions may be found in [118].

![image 1105](<rcm1-1_images/imageFile1105.png>)

6Note added at reprinting: a probabilistic proof can be found in [329, 330].

## Chapter 10 On Other Graphs

Summary. Exact solutions are known for the random-cluster models on complete graphs and on regular trees, and these provide theories of meanﬁeld-type. There is a special argument for the complete graph which utilizes the theory of Erdos–R˝ enyi´ random graphs, and leads to exact calculations valid for all values of q ∈ (0, ∞). The transition is of ﬁrst order if and only if q ∈ (2, ∞). The (non-)uniqueness of random-cluster measures on a tree, when subject to a variety of boundary conditions, may be studied via an iterative formula permitting exact calculations of the critical value and the percolation probability. There is a discussion of the random-cluster model on a general non-amenable graph.

10.1 Mean-ﬁeld theory

The theory of phase transitions addresses primarily singularities associated with spaces of ﬁnite dimension. There are two reasons for considering a ‘mean-ﬁeld’ theory in which the number d of dimensions may be considered to take the value ∞. Firstly, the major problemsconfrontingthe mathematicslie in the geometrical constraints imposed by ﬁnite-dimensional Euclidean space; a solution for ‘inﬁnite dimension’ can cast light on the case of ﬁnite dimension. The second reason is the desire to understand better the d-dimensional process in the limit of large d. One is led thus to the problems of establishing the theory of a process viewed as ∞-dimensional, and to proving that this is the limit in an appropriate sense of the d-dimensional process. Progress is well advanced on these two problems for percolation (see [154, Chapter 10]) but there remains much to be done for the random-cluster model.

Being informed by progress for percolation, it is natural to consider as meanﬁeld modelsthe random-clustermodelsoncomplete graphsand on an inﬁnite tree. In the formercase, we consider the modelon the complete graph Kn on n vertices, and we pass to the limit as n → ∞. The vertex-degrees tend to ∞ as n → ∞, and some re-scaling is done in order to establish a non-trivial limit. The correct

way to do this is to set p = λ/n for ﬁxed λ > 0. The consequent theory may be regarded as an extension of the usual Erdos–R˝ enyi´ theory of random graphs, [61, 194]. This model is expounded in Section 10.2. The main results are described in Section 10.3, and are proved in Sections 10.4–10.6. The nature of the phase transition is discussed in Section 10.7, and the consequences for large deviations of cluster-counts are presented in Section 10.8. The principal reference1 is [62], of which heavy use is made in this chapter.

The random-cluster model on a ﬁnite tree is essentially trivial. Owing to the absenceofcircuits,arandom-clustermeasurethereonissimplyaproductmeasure. The tree is a more interesting setting when it is inﬁnite and subjected to boundary conditions. There is a continuum of random-cluster measures indexed by the set of possible boundaryconditions. The present state of knowledgeis summarizedin Sections 10.9–10.11. The relevant references are [160, 167, 196] but the current treatment is fundamentally different.

Trees are examples of graphs whose boxes have surface/volumeratios bounded away from 0. Such graphs are termed ‘non-amenable’ and, subject to further conditions, they may have three phases rather than the more usual two. A brief account of this phenomenon may be found in Section 10.12.

10.2 On complete graphs

Let n ≥ 1, and let Kn = (V, V(2)) be the complete graph on the vertex set V = Vn = {1,2,. . .,n}, withedge-settheset V(2) ofall n2 pairsofunorderedelements of V. We shall consider the random-cluster measure on Kn with parameters p ∈ (0,1) and q ∈ (0,∞). We deﬁne the ‘weight function’

(10.1) Pn,p,q(F) = p|F|(1 − p)(n2)−|F|qk(V,F), F ⊆ V(2), where k(V, F) denotes the number of components of the graph (V, F). The partition function is (10.2) Zn,p,q =

Pn,p,q(F)

F⊆V(2)

and the random-cluster measure on subsets of V(2) is then given by

Pn,p,q(F) Zn,p,q

, F ⊆ V(2).

(10.3) φn,p,q(F) =

![image 1106](<rcm1-1_images/imageFile1106.png>)

Thus, for any given n, p, q, the measure φn,p,q is the law of a random graph with n verticeswhich we denoteby Gn,p,q. We sometimeswrite φn,p,q(F) as φV,p,q(F).

![image 1107](<rcm1-1_images/imageFile1107.png>)

1The random-cluster model on the complete graph is related to the ‘ﬁrst-shell’ model of Whittle, [317, 318].

Itwillturn outthatthe proportionofverticesinthelargestcomponentisroughly constant, namely θ(λ,q), for large n. It is convenient to introduce a deﬁnition of θ immediately, namely

0 if λ < λc(q), θmax if λ ≥ λc(q),

(10.5) θ(λ,q) =

where θmax is the largest root of the equation (10.6) e−λθ =

1 − θ 1 + (q − 1)θ

. The roots of (10.6) are illustrated in Figure 10.2.

![image 1108](<rcm1-1_images/imageFile1108.png>)

We note some of the properties of θ(λ,q). Firstly, θ(λ,q) > 0 if and only if either: λ > λc(q), or: λ = λc(q) and q > 2,

see Lemma 10.12. Secondly, for all q ∈ (0,∞), θ(λ,q) is non-decreasing in λ, and it follows that θ(·,q) is continuous if q ∈ (0,2], and has a unique (jump) discontinuity at λ = λc(q) if q ∈ (2,∞). This jump discontinuity corresponds to a phase transition of ﬁrst order.

We say that ‘almost every (a.e.) Gn,p,q satisﬁes property ’, for a given sequence p = pn and a ﬁxed q, if

φn,p,q(Gn,p,q has  ) → 1 as n → ∞. We summarize the main results of the following sections as follows. (a) If 0 < λ < λc(q) and q ∈ (0,∞), then almost every Gn,λ/n,q has largest component of order log n.

- (b) If λ > λc(q) and q ∈ (0,∞), then almost every Gn,λ/n,q consists of a ‘giant component’ of order θ(λ,q)n, together with other components of order log n or smaller.
- (c) If λ = λc(q) and q ∈ (0,2], then almost every Gn,λ/n,q has largest component of order n2/3.


The behaviourof Gn,λ/n,q with q ∈ (2,∞) and λ = λn → λc(q)has been studied further in the combinatorial analysis of [238].

There are two main steps in establishing the abovefacts. The ﬁrst is to establish the relation (10.6) by studying the size of the largestcomponentof Gn,λ/n,q. When q ∈ (2,∞), (10.6) has three solutions for large λ, see Figure 10.2. In order to decide which of these is the density of the largest component, we shall study the number of edges in Gn,λ/n,q. That is to say, we shall ﬁnd the function ψ(λ,q) such that almost every Gn,λ/n,q has (order) ψ(λ,q)n edges. It will turn out that the function ψ(·,q) is discontinuous at the critical point of a ﬁrst-order phase transition.

The material presented here for the random-cluster model on Kn is taken from [62]. See also [238].

[10.3] Main results for the complete graph 281

10.3 Main results for the complete graph

Let q ∈ (0,∞) and p = λ/n where λ is a positive constant. For ease of notation, we shall sometimes suppress explicit reference to q. We shall make heavy use of the critical value λc(q) given in (10.4), and the function θ(λ) = θ(λ,q) deﬁned in (10.5)–(10.6). The properties of roots of (10.6) will be used in some detail, but these are deferred untilLemma 10.12. For the momentwe note only that θ(λ) = 0 if and only if: either λ < λc(q), or λ = λc(q) and q ≤ 2.

Therearethreeprincipaltheoremsdealingrespectivelywith the subcriticalcase λ < λc(q), the supercritical case λ > λc(q), and the critical case λ = λc(q). In the matter of notation, for a sequence (Xn : n = 1,2,. . .) of random variables, we write Xn = Op( f (n)) if Xn/f (n) is bounded in probability:

P |Xn| ≤ f (n)ω(n) → 1 as n → ∞

for any sequence ω(n) satisfying ω(n) → ∞ as n → ∞. Similarly, we write Xn = op( f (n)) if Xn/f (n) → 0 in probability as n → ∞:

P |Xn| ≤ f (n)/ω(n) → 1 as n → ∞ for some sequence ω(n) satisfying ω(n) → ∞. Convergence in probability is denoted by the symbol →P .

(10.7) Theorem (Subcritical case) [62]. Let q ∈ (0,∞) and λ < λc(q). (a) Almost every Gn,λ/n,q comprises trees and unicyclic components only. (b) There are Op(1)unicyclic componentswith a totalnumberOp(1)ofvertices. (c) Thelargestcomponentofalmostevery Gn,λ/n,q is atree with orderα logn+

Op(loglogn), where

1 α = − log(λ/q) +

λ q − 1 > 0.

![image 1109](<rcm1-1_images/imageFile1109.png>)

![image 1110](<rcm1-1_images/imageFile1110.png>)

(d) The number of edges in Gn,λ/n,q is λn/(2q) + op(n).

#### (10.8) Theorem (Supercritical case) [62]. Let q ∈ (0,∞) and λ > λc(q).

- (a) Almost every Gn,λ/n,q consists of a giant component, trees, and unicyclic components.
- (b) The number of vertices in the giant component is θ(λ)n + op(n), and the number of edges is


λθ(λ)

1 q +

![image 1111](<rcm1-1_images/imageFile1111.png>)

1 q

1 2 −

![image 1112](<rcm1-1_images/imageFile1112.png>)

![image 1113](<rcm1-1_images/imageFile1113.png>)

θ(λ) n + op(n).

(c) The largest tree in almost every Gn,λ/n,q has order α logn + op(logn), where

1 α = − logβ + β − 1 > 0, β =

λ q

(1 − θ(λ)).

![image 1114](<rcm1-1_images/imageFile1114.png>)

![image 1115](<rcm1-1_images/imageFile1115.png>)

282 On Other Graphs [10.3]

(d) There are Op(1)unicyclic componentswith a totalnumberOp(1)ofvertices. (e) The number of edges in Gn,λ/n,q is

λ 2q

![image 1116](<rcm1-1_images/imageFile1116.png>)

1 + (q − 1)θ(λ)2 n + op(n).

#### (10.9) Theorem (Critical case) [62]. Let q ∈ [1,2] and λ = λc(q).

(a) Almost every Gn,λ/n,q consists of trees, unicyclic components, and Op(1)

components with more than one cycle. (b) The largest component has order op(n). (c) The total number of vertices in unicyclic components is Op(n2/3). (d) The largest tree has order Op(n2/3).

More detailed asymptotics are available for Gn,λ/n,q by lookingdeeperinto the proofs. The last theorem has been extendedto the cases q ∈ (0,1) and q ∈ (2,∞) in [238], where a detailed combinatorial analysis has been performed.

The giant component, when it exists, has orderapproximatelyθ(λ)n, with θ(λ) given by (10.5)–(10.6). We study next the roots of (10.6). Note ﬁrst that θ = 0 satisﬁes (10.6) for all λ and q, and that all strictly positive roots satisfy 0 < θ < 1. Let

1 θ

log{1 + (q − 1)θ} − log(1 − θ) , θ ∈ (0,1),

(10.10) f (θ) =

![image 1117](<rcm1-1_images/imageFile1117.png>)

and note that θ ∈ (0,1) satisﬁes (10.6) if and only if f (θ) = λ. Here are two elementary lemmas concerning the function f .

(10.11)Lemma. Thefunction f isstrictlyconvexon(0,1),andsatisﬁes f (0+) = q and f (1−) = ∞.

(a) If q ∈ (0,2], the function f is strictly increasing. (b) If q ∈ (2,∞), there exists θmin ∈ (0,1) such that f is strictly decreasing

on (0,θmin) and strictly increasing on (θmin,1).

Proof. If t > −1 then (1 + tθ)−1 is a strictly convex function of θ on (0,1). Hence, the function

q−1

dt 1 + tθ is strictly convex. Furthermore,

f (θ) =

![image 1118](<rcm1-1_images/imageFile1118.png>)

−1

1 + (q − 1)θ 1 − θ = lim

q − (q − 1)ǫ ǫ = ∞,

lim

log

log

![image 1119](<rcm1-1_images/imageFile1119.png>)

![image 1120](<rcm1-1_images/imageFile1120.png>)

θ↑1

ǫ↓0

implying that f (1−) = ∞. Applying Taylor’s theorem about the point θ = 0, we ﬁnd that

1 θ

(q − 1)θ − 12(q − 1)2θ2 + θ + 21θ2 + O(θ3)

f (θ) =

![image 1121](<rcm1-1_images/imageFile1121.png>)

![image 1122](<rcm1-1_images/imageFile1122.png>)

![image 1123](<rcm1-1_images/imageFile1123.png>)

= q + 21q(2 − q)θ + O(θ2),

![image 1124](<rcm1-1_images/imageFile1124.png>)

[10.4] The fundamental proposition 285

Therefore, the probability that the red graph is (V1, E1) and the green graph is (V2, E2) equals

p|E1∪E2|(1 − p)(n2)−|E1∪E2|qk(V,E1∪E2) Zn,p,q

rk(V1,E1)(1 − r)k(V2,E2)

![image 1125](<rcm1-1_images/imageFile1125.png>)

= cφV1,p,rq(E1)φV2,p,(1−r)q(E2),

for some positive constant c = c(n, p,q,n1). Hence, conditional on R = V1 and the green subgraph being (V2, E2), the probability that the red subgraph is (V1, E1) is precisely φV1,p,rq(E1).

In this context, we shall write N rather than n1 for the (random) number of red vertices. Thus N is a random variable, and GN,p,rq is a random graph on a random number of vertices.

If q ∈ [1,∞) and r = q−1, the red subgraph is distributed as GN,p. Much is known about such a random graph, see [61, 194]. By studying the distribution of N and using known facts about GN,p, one may deduce much about the structure of Gn,p,q. Similarly, in order to study the random-cluster model with q ∈ (0,1), one applies Proposition 10.16 to Gn,p with r = q, obtaining that the red subgraph is distributed as GN,p,q. By using known facts about Gn,p, together with some distributional propertiesof N, we may derive results for Gm,p,q with m large. The details of the q ∈ (0,1) case are omitted but may be found in [62].

Here is a corollary which will be of use later.

(10.17) Lemma. Let q ∈ [1,∞). For any sequence p = pn, almost every Gn,p,q has at most one component with order at least n3/4.

Proof. Let L = L(G) be the number of components of a random graph G having order at least n3/4. Suppose L ≥ 2, and pick two of these in some arbitrary way. With probability r2 both of these are coloured red. Setting r = q−1, we ﬁnd by [61, Thm VI.9] that

r2φn,p,q(L ≥ 2) ≤

φm,p,1(L ≥ 2)φn,p,q(|R| = m)

n3/4≤m≤n

≤ max

φm,p,1(L ≥ 2)

n3/4≤m≤n

→ 0 as n → ∞.

10.5 The size of the largest component

We assume henceforth that q ∈ [1,∞). Let nn denote the number of vertices in the largest component of Gn,λ/n,q, and note that 0 < n ≤ 1. If two or more ‘largest components’ exist, we pick one of these at random. All other components are called ‘small’ and, by Lemma 10.17, all small components of almost every Gn,λ/n,q have orders less than n3/4.

ConsiderthecolouringschemeofProposition10.16withr = q−1, andsuppose that Gn,λ/n,q has components of order nn,ν2,ν3,. . .,νk where k is the total number of componentsand we shall assume that νi ≤ n3/4 for i ≥ 2. The number of red vertices in the small components has conditional expectation

k

νir = r(1 − n)n

i=2

and variance

k

k

νi2 ≤ n max

νi ≤ n7/4.

νi2r(1 − r) ≤

i≥2

i=2

i=2

Hence, there is a total ofr(1− n)n+op(n) red vertices in the small components.

Since the largest component may or may not be coloured red, there are two possibilities for the red graph:

(i) with probability r, it has

nn + r(1 − n)n + op(n) = [r + (1 − r) n]n + op(n) vertices, of which nn belong to the largest component,

(ii) with probability 1 − r, it has r(1 − n)n + op(n) vertices, and the largest component has order less than n3/4.

In the ﬁrst case, the red graph is distributed as a supercritical Gn′,λ′/n′ graph, and in the second case as a subcritical Gn′′,λ′′/n′′ graph. Here, n′ and n′′ are random integers and, with probability tending to 1, λ′ = n′ p > 1 > λ′′ = n′′ p. This leads to the next lemma.

(10.18) Lemma. If λ > q ≥ 1, there exists θ0 > 0 such that n ≥ θ0 for almost every Gn,λ/n,q. Proof. The assertionis wellknownwhen q = 1, see forexample[61, ThmVI.11]. Therefore, we may assume q > 1 and thus r < 1.

Let θ0 = (λ−q)/(2λ), πn = φn,p,q( n < θ0), and ǫ > 0. By considering the event that the largest component is not coloured red, we ﬁnd that, with probability at least (1 − r)πn + o(1), the number N of red vertices satisﬁes

N ≥ r(1 − θ0)n − ǫn,

[10.5] The size of the largest component 287

and there are no red components of order at least n3/4. When this happens,

(10.19) Np ≥ λ[r(1 − θ0) − ǫ] =

![image 1126](<rcm1-1_images/imageFile1126.png>)

1 2 +

λ 2q − ǫλ > 1

![image 1127](<rcm1-1_images/imageFile1127.png>)

for ǫ sufﬁciently small, and we pick ǫ accordingly. Conditional on the value N, almost every GN,p has a component of order at least δN (≥ δn/λ by (10.19)) for some δ > 0. Therefore, (1 − r)πn → 0 as n → ∞.

(10.20) Lemma. If q ∈ [1,∞) then, for any sequence λ = λn,

1 − n 1 + (q − 1) n

→P 0 as n → ∞.

e−λn n −

![image 1128](<rcm1-1_images/imageFile1128.png>)

Proof. For q = 1 and constant λ = λn, this follows from the well known fact that

→P θ where e−λθ = 1−θ, see [61, Thm VI.11] and the remark after [61, Thm V.7]. The case of varying λn is not hard to deduce by looking down convergent subsequences. We may express this by writing

n

n n − 1 →P 0 when q = 1,

e−pn nn + n

![image 1129](<rcm1-1_images/imageFile1129.png>)

for the random graph Gn,pn and any sequence (pn). Applying this to the red subgraph, on the event that it contains the largest component of Gn,λ/n,q, we obtain for general q ∈ [1,∞) that

n N − 1 + op(1)

e−λ n + r + (1 − n r) n − 1 = e−p nn + n

![image 1130](<rcm1-1_images/imageFile1130.png>)

![image 1131](<rcm1-1_images/imageFile1131.png>)

→P 0 as n → ∞, where N is the number of red vertices. The claim follows.

Combining these lemmas, we arrive at the following theorem. (10.21) Theorem [62].

(a) If q ∈ [1,2] and λ ≤ q, or if q ∈ (2,∞) and λ < λmin where λmin is given in Lemma 10.12(b), then n →P 0 as n → ∞. (b) Ifq ∈ [1,∞)and λ > q, then n →P θ(λ)where θ(λ)isthe unique (strictly) positive solution of (10.6).

This goes some way towards proving Theorems 10.7–10.8. Overlooking for the moment the more detailed asymptotical claims of those theorems, we note that the major remaining gap is when q ∈ (2,∞) and λmin ≤ λ ≤ q. In this case, by Lemma 10.20, n is approximately equal to one of the three roots of (10.6)

(including the trivial root θ = 0). Only after the analysis of the next two sections shall we see which root is the correct one for given λ.

Proof. The function

1 − θ 1 + (q − 1)θ is continuous on [0,1], and the set Z of zeros of φ is described in Lemma 10.12. Since φ( n) →P 0, by Lemma 10.20, it follows that, for all ǫ > 0,

φ(θ) = e−λθ −

![image 1132](<rcm1-1_images/imageFile1132.png>)

φn,p,q n ∈ Z + (−ǫ,ǫ) → 1 as n → ∞.

Under the assumption of (a), Z contains the singleton 0, and the claim follows. Under(b), Z containsa uniquestrictly positivenumberθ(λ), andthe claim follows by Lemma 10.18.

We turn now to the number of edges in the largest component. Let nn denote the number of edges of Gn,p,q. We pick one of its largest components at random, and write nn forthe numberof its edges. Let q ∈ (1,∞). Arguingas in Sections 10.4–10.5with r = q−1, almost every Gn,p,q has at most n3/4 edges in each small component (a ‘small’ component is any component except the largest, picked above)2. Furthermore, the total number of red edges in the small components is r( n − n)n + op(n). Hence, the red subgraph has either:

(i) with probability r, [ n + r(1 − n)]n + op(n) vertices and [ n + r( n − n)]n + op(n) edges, or (ii) otherwise, r(1 − n)n + op(n) vertices and r( n − n)n + op(n) edges. Assume that p = O(n−1). Since almost every GN,p has

N 2

p + Op(Np1/2) = 21 N2 p + op(N) edges, the following two equations follow from the two cases above,

![image 1133](<rcm1-1_images/imageFile1133.png>)

(10.22) n + r( n − n) n = 21 n + r(1 − n) 2n2 p + op(n), (10.23) r( n − n)n = 21[r(1 − n)]2n2 p + op(n), yielding when p = λ/n that

![image 1134](<rcm1-1_images/imageFile1134.png>)

![image 1135](<rcm1-1_images/imageFile1135.png>)

(10.24) n + r( n − n) = 21λ n + r(1 − n) 2 + op(1), (10.25) r( n − n) = 21λ[r(1 − n)]2 + op(1). We solve for n and n, and let n → ∞ to obtain the next theorem.

![image 1136](<rcm1-1_images/imageFile1136.png>)

![image 1137](<rcm1-1_images/imageFile1137.png>)

![image 1138](<rcm1-1_images/imageFile1138.png>)

2One needs here the corresponding result for q = 1, which follows easily from the corresponding result for the number of vertices used above, together with results on the components having more edges than vertices given in [61, 192, 193].

(10.26) Theorem [62]. If q ∈ (1,∞) and λ ∈ (0,∞) then, as n → ∞,

λ 2q

(10.27) 1 + (q − 1) 2n → P 0,

n −

![image 1139](<rcm1-1_images/imageFile1139.png>)

λ q n

(10.28) 1 + (21q − 1) n → P 0.

n −

![image 1140](<rcm1-1_images/imageFile1140.png>)

![image 1141](<rcm1-1_images/imageFile1141.png>)

Whereas we proved this theorem under the assumption that q > 1, its conclusions are valid for q = 1 also, by [61, Thms VI.11, VI.12].

10.6 Proofs of main results for complete graphs

The results derivedso far are combinednextwith a newargumentin orderto prove Theorems 10.7–10.9 for q ∈ [1,∞). The results are well known when q = 1 (see [61, Chapters V, VI] and [239]), and we assume henceforth that q ∈ (1,∞). The acyclic part of a graph is the union of all components that are trees, and the cyclic part is the union of the remaining components. A graph is called cyclic if its acyclic part is empty. We begin by showing that the cyclic part of almost every Gn,λ/n,q consists principally of the largest componentonly (when this component is cyclic).

(10.29) Lemma. The numbers of vertices and edges in the small cyclic components of Gn,λ/n,q are op(n).

Proof. Let k be an integer satisfying k ≥ q. In the colouring scheme of Section 10.4 with r = q−1, we introduce the reﬁnement that each component is coloured dark red with probability k−1 and light red with probability r − k−1. Let M be the number of edges in the small cyclic components of Gn,λ/n,q.

By a symmetry argument, with probability at least k−1, at least M/k of these edges are coloured dark red. To see this, let Mi be the number of such edges coloured χi when each component is coloured by a random colour from the set {χ1,χ2,. . .,χk}, each such colour having equal probability. If

1 k

, i = 1,2,. . .,k, then

φn,p,q(Mi ≥ M/k) <

![image 1142](<rcm1-1_images/imageFile1142.png>)

φn,p,q(Mi ≥ M/k for some i) < 1, in contradiction of the equality ki=1 Mi = M.

Therefore, with probability at least r/k, the red subgraph contains the largest componenttogetherwith smallcyclic componentshavingatleast M/k edges. The result now follows from the known case q = 1, see [60], [61, Thm VI.11].

Let Pn,p,q(m, j,k,l) be the sum of Pn,p,q(F) over edge-sets F that deﬁne a graph with |F| = m edges and a cyclic part with j components, k vertices, and l

edges. Since such graphs have an acyclic part with n −k vertices and m −l edges, and therefore n − k − m + l components, we obtain (10.30)

n k

c(j,k,l) f (n − k,m − l)pm(1 − p)(n2)−mqn−k−m+l+j

Pn,p,q(m, j,k,l) =

where c(j,k,l) is the number of cyclic graphs with j components, k labelled vertices, and l edges, and f (n,m) is the number of forests with n labelled vertices and m edges.

Assume now that n → ∞, that λ = np > 0 and q ∈ [1,∞) are ﬁxed, and that

(10.31) m/n → ψ, k/n → θ, l/n → ξ, j/n → 0,

where θ ≥ 0 satisﬁes (10.6), and

λ q

(10.32) θ 1 + (21q − 1)θ , ψ = ξ +

ξ =

![image 1143](<rcm1-1_images/imageFile1143.png>)

![image 1144](<rcm1-1_images/imageFile1144.png>)

λ 2q

(10.33) (1 − θ)2.

![image 1145](<rcm1-1_images/imageFile1145.png>)

See (10.27) and (10.28). If λ > q, we assume also that θ > 0, see Lemma 10.18 and Theorem 10.21(b).

Since

n 2

f (n,m) ≤

,

m

the total number of graphs with m edges on n vertices,

(10.34)

Pn,p,q(m, j,k,l)

≤

=

n k

n k

c(j,k,l)

c(j,k,l)

= c(j,k,l)

n k

= plc(j,k,l)

n k

= ple−lc(j,k,l)

n−k 2

pm(1 − p)(n2)−mqn−k−m+l+j

m − l

m−l e m − l

m−l

n − k 2

pmqn−k−m+le−21λn+o(n)

![image 1146](<rcm1-1_images/imageFile1146.png>)

![image 1147](<rcm1-1_images/imageFile1147.png>)

m−l

(n − k)2eλ 2(m − l)n

plqn−k−m+le−12λn+o(n)

![image 1148](<rcm1-1_images/imageFile1148.png>)

![image 1149](<rcm1-1_images/imageFile1149.png>)

m−l

(1 − θ)2λ 2(ψ − ξ)

qn−k−m+l exp m − l − 21λn + o(n)

![image 1150](<rcm1-1_images/imageFile1150.png>)

![image 1151](<rcm1-1_images/imageFile1151.png>)

n k

qn−k exp m − 21λn + o(n) ,

![image 1152](<rcm1-1_images/imageFile1152.png>)

where we used (10.33) in the last step.

We shall be interested only in values of λ and roots θ of (10.6) satisfying (10.35) either θ > 0, or θ = 0 and λ ≤ q. We claim that, under these assumptions, (10.34) is an equality in that

(10.36) Pn,p,q(m, j,k,l) = ple−lc(j,k,l)

n k

qn−k exp m − 21λn + o(n) .

![image 1153](<rcm1-1_images/imageFile1153.png>)

To see this when either θ > 0, or θ = 0 and λ < q, set n0 = n−k and m0 = m−l, and observe that

m − l n − k →

m0 n0 =

ψ − ξ 1 − θ =

![image 1154](<rcm1-1_images/imageFile1154.png>)

![image 1155](<rcm1-1_images/imageFile1155.png>)

![image 1156](<rcm1-1_images/imageFile1156.png>)

where we have used the fact that, by (10.6),

1 2

λ 2q

(1 − θ) <

,

![image 1157](<rcm1-1_images/imageFile1157.png>)

![image 1158](<rcm1-1_images/imageFile1158.png>)

qθ 1 − θ

λθ < eλθ − 1 =

, θ ∈ (0,∞).

![image 1159](<rcm1-1_images/imageFile1159.png>)

Hence in this case, the ‘ﬁxed edge-number’ random graph Gn0,m0 has average vertex-degree not exceeding 1 − ǫ for some positive constant ǫ independent of n,m,k,l. Therefore, there exists δ > 0 such that

P(Gn0,m0 is a forest) > δ, and hence

n0

2 m0

f (n0,m0) > δ

.

This implies (10.36), via (10.30) and (10.34). When θ = 0 and λ = q, we have that m0/n0 → ψ = 21, and hence

![image 1160](<rcm1-1_images/imageFile1160.png>)

n0

eo(n),

2 m0

(10.37) f (n0,m0) =

implying (10.36). To see (10.37) note that, with 0 < ǫ < 41 and s ≍ ǫn, f (n0,m0) ≥ (n0 − 1)s−1 f (n0 − s,m0 − s + 1) ≥ e−ǫnns0

![image 1161](<rcm1-1_images/imageFile1161.png>)

n0−s 2

m0 − s + 1 ≥ e2log(1−ǫ)n

n0

2 m0

,

for large n, by counting only forests where vertex 1 is an endvertex of an isolated path of length s − 1.

We estimate c(j,k,l) next. Suppose ﬁrst that θ = 0. Then c(j,k,l) is no greater than the total number of graphs with k vertices and l edges, that is,

l 1 l ! ≤

l

l k2 2

λn l

p e

ple−lc(j,k,l) ≤

![image 1162](<rcm1-1_images/imageFile1162.png>)

![image 1163](<rcm1-1_images/imageFile1163.png>)

![image 1164](<rcm1-1_images/imageFile1164.png>)

![image 1165](<rcm1-1_images/imageFile1165.png>)

= exp l{logλ − log(l/n)} = eo(n).

Equality holds here for some suitable triple j,k,l: just set j = k = l = 0, for which ple−lc(j,k,l) = 1. It is easily checked that nk = eo(n) when θ = 0, and therefore,

(10.38) ple−lc(j,k,l) ≤

n k

−1

eo(n)

with equality for some suitable j,k,l.

Ourestimate of c(j,k,l)when θ > 0 usesthe factthat Pn,p,q(·)isa probability measure when q = 1. Suppose θ > 0, deﬁne n1 = n1(θ) = ⌊θn + r(1 − θ)n⌋ where r = q−1 as usual, and set

m1 = l + r(m − l) + o(n) = [ξ + r(ψ − ξ)]n + o(n),

λ1 = [θ + r(1 − θ)]λ. Then,

1 2

m1 n1 → ψ1 =

ξ + r(ψ − ξ) θ + r(1 − θ) =

(10.39) λ1, k n1 → θ1 =

![image 1166](<rcm1-1_images/imageFile1166.png>)

![image 1167](<rcm1-1_images/imageFile1167.png>)

![image 1168](<rcm1-1_images/imageFile1168.png>)

θ θ + r(1 − θ)

(10.40) , l n1 → ξ1 =

![image 1169](<rcm1-1_images/imageFile1169.png>)

![image 1170](<rcm1-1_images/imageFile1170.png>)

j (10.41) n1 → 0. It is easy to check the analogues of (10.6) and (10.32)–(10.33), namely,

ξ θ + r(1 − θ)

,

![image 1171](<rcm1-1_images/imageFile1171.png>)

![image 1172](<rcm1-1_images/imageFile1172.png>)

![image 1173](<rcm1-1_images/imageFile1173.png>)

(10.42) e−λ1θ1 = 1 − θ1, ξ1 = λ1θ1(1 − 12θ1), ψ1 = ξ1 + 21λ1(1 − θ1)2. Now, (10.36) is valid with q = 1, since θ > 0. Hence, (10.43) 1 ≥ Pn1,p1,1(m1, j,k,l)

![image 1174](<rcm1-1_images/imageFile1174.png>)

![image 1175](<rcm1-1_images/imageFile1175.png>)

n1 k

exp m1 − 21λ1n1 + o(n)

= p1l e−lc(j,k,l)

![image 1176](<rcm1-1_images/imageFile1176.png>)

n1 k

eo(n)

= ple−lc(j,k,l)

by (10.39), where p1 = λ1/n1 = p(1 + O(n−1)). Therefore,

−1

n1 k

eo(n).

(10.44) ple−lc(j,k,l) ≤

We claim that there exist suitable j,k,l such that equality holds in (10.44). To see this, note that Gn1,p1 has n21 p1 + op(n1) edges, a giant component with θ1n1 + op(n1) vertices and ξ1n1 + op(n1) edges, Op(1) unicyclic components with a total of Op(1) vertices and edges, and no other cyclic components, see [61, Thm VI.11]. By considering the number of possible combinations of values of m1, j,k,l satisfying the above constraints, there exist m1, j,k,l such that

Pn1,p1,1(m1, j,k,l) ≥ n−4

for all large n. Combining this with (10.43), equality follows in (10.44) for some suitable j,k,l.

In conclusion, whatever the root θ of (10.6) (subject to (10.35)), inequality (10.44) holds with equality for some suitable j,k,l, and where n1 = n1(0) is interpreted as n (that is, when θ = 0). We substitute (10.44) into (10.34) to obtain

(10.45)

Pn,p,q(m, j,k,l)

−1 n k

n1 k

qn−k exp m − 21λn + o(n)

≤

![image 1177](<rcm1-1_images/imageFile1177.png>)

nn (n − k)n−k

(n1 − k)n1−k nn11

λ 2q

[1 + (q − 1)θ2]n − 21λn + o(n)

qn−k exp

=

![image 1178](<rcm1-1_images/imageFile1178.png>)

![image 1179](<rcm1-1_images/imageFile1179.png>)

![image 1180](<rcm1-1_images/imageFile1180.png>)

![image 1181](<rcm1-1_images/imageFile1181.png>)

[r(1 − θ)]r(1−θ) (1 − θ)1−θ[θ + r(1 − θ)]θ+r(1−θ)

=

![image 1182](<rcm1-1_images/imageFile1182.png>)

n

λ 2q

[1 + (q − 1)θ2] − 12λ + o(1)

× q1−θ exp

![image 1183](<rcm1-1_images/imageFile1183.png>)

![image 1184](<rcm1-1_images/imageFile1184.png>)

q − 1 2q

g(θ) 2q −

= exp n

λ + logq + o(1) ,

![image 1185](<rcm1-1_images/imageFile1185.png>)

![image 1186](<rcm1-1_images/imageFile1186.png>)

where (10.46) g(θ) = −(q −1)(2 −θ)log(1−θ)−[2 +(q −1)θ] log[1+(q −1)θ].

We have used (10.32)–(10.33) in order to obtain the second line of (10.45). To pass to the last line, we used the fact that θ is a root of (10.6), thus enabling the substitution

exp

λ 2q

[1 + (q − 1)θ2] = eλ/(2q)

![image 1187](<rcm1-1_images/imageFile1187.png>)

1 + (q − 1)θ 1 − θ

![image 1188](<rcm1-1_images/imageFile1188.png>)

(q−1)θ/(2q)

.

In addition, equality holds in (10.45) for at least one suitable choice of j,k,l. Let θ∗ = θ∗(λ) be the root3 of (10.6) that maximizes g(θ) and satisﬁes (10.35). By (10.45) and the equality observed above,

(10.47) Pn,p,q(m, j,k,l)

Zn,p,q =

m,j,k,l

g(θ∗) 2q −

q − 1 2q

λ + logq + o(1) ,

≥ exp n

![image 1189](<rcm1-1_images/imageFile1189.png>)

![image 1190](<rcm1-1_images/imageFile1190.png>)

whence

g(θ∗) 2q −

1 n

q − 1 2q

(10.48) lim inf

log Zn,p,q ≥

λ + logq.

![image 1191](<rcm1-1_images/imageFile1191.png>)

![image 1192](<rcm1-1_images/imageFile1192.png>)

![image 1193](<rcm1-1_images/imageFile1193.png>)

n→∞

On the other hand, by Lemmas 10.18 and 10.20, there exists a root θ of (10.6) satisfying (10.35), and a function ω(n) satisfying ω(n) → ∞, such that

φn,p,q | n − θ| < ω(n)−1 > 0.

(10.49) lim inf

n→∞

For such θ there exist, by Lemma 10.29 and Theorem 10.26, sequences m, j,k,l satisfying (10.31)–(10.33) such that

Pn,p,q(m, j,k,l) Zn,p,q ≥ n−4

1 ≥

![image 1194](<rcm1-1_images/imageFile1194.png>)

foralllarge n (thisisshown by considering the numberof possiblecombinationsof m, j,k,l satisfying(10.31)–(10.33)andtheabove-mentionedresults). By(10.45),

1 n

q − 1 2q

g(θ) 2q −

(10.50) lim sup

log Zn,p,q ≤

λ + logq,

![image 1195](<rcm1-1_images/imageFile1195.png>)

![image 1196](<rcm1-1_images/imageFile1196.png>)

![image 1197](<rcm1-1_images/imageFile1197.png>)

n→∞

which, by (10.48), implies g(θ) ≥ g(θ∗), and therefore θ = θ∗. Theorem 10.14 followsby(10.48)and(10.50). Furthermore,θ∗ istheonlyrootof(10.6)satisfying (10.35) such that (10.49) holds for some ω(n). Therefore,

(10.51) n →P θ∗ as n → ∞.

Next we calculate θ∗(λ). As in Theorem 10.21, when q ∈ [1,2], θ∗(λ) is the largestnon-negativerootof (10.6). Assume that q ∈ (2,∞). By a straightforward computation,

q − 2 q − 1 = 0, g′(0) = 0,

g(0) = g

![image 1198](<rcm1-1_images/imageFile1198.png>)

q(q − 1)[q − 2 − 2(q − 1)θ]θ (1 − θ)2[1 + (q − 1)θ]2

g′′(θ) = −

.

![image 1199](<rcm1-1_images/imageFile1199.png>)

![image 1200](<rcm1-1_images/imageFile1200.png>)

3We shall see that there is a unique such θ∗, except possibly when λ = λc(q) and q > 2.

[10.7] The nature of the singularity 295

Therefore, g′′(θ) has a unique zero in (0,1), at the point θ = 21(q − 2)/(q − 1). At this point, g′(θ) has a negative minimum. It follows that g(θ) < 0 on (0,θ0), and g(θ) > 0 on (θ0,1) where θ0 = (q − 2)/(q − 1).

![image 1201](<rcm1-1_images/imageFile1201.png>)

Substituting θ0 into (10.6), we ﬁnd that θ0 satisﬁes (10.6) if

q − 1 q − 2

log(q − 1),

λ = λc(q) = 2

![image 1202](<rcm1-1_images/imageFile1202.png>)

and, for this value of λ, the three roots of (10.6) are 0, 12θ0, θ0. Therefore, λmin < λc(q) < q, and

![image 1203](<rcm1-1_images/imageFile1203.png>)

θ∗ =

0 if λ < λc(q), θmax(λ) if λ > λc(q).

This completes the proof of the assertions concerning the order of the largest component. The claims concerning the numbers of edges in Gn,p,q and in the largest component follow by Theorem 10.26. Proofs of the remaining assertions about the structure of Gn,p,q are omitted, but may be obtained easily using the colouring argument and known facts for Gn,p, see [61, 239].

10.7 The nature of the singularity

It is an important problem of statistical physics to understand the nature of the singularity at a point of phase transition. For the mean-ﬁeld random-clustermodel on a complete graph, the necessary calculations may be performed explicitly, and the conclusions are as follows.

Let q ∈ [1,∞) be ﬁxed, and consider the functions θ(λ), given in (10.5), and ψ(λ), ξ(λ) deﬁned by

λ 2q

ψ(λ) =

![image 1204](<rcm1-1_images/imageFile1204.png>)

λ q

1 + (q − 1)θ(λ)2 , ξ(λ) =

![image 1205](<rcm1-1_images/imageFile1205.png>)

θ(λ) + (12q − 1)θ(λ)2 ,

![image 1206](<rcm1-1_images/imageFile1206.png>)

describingthe orderof the giantcomponent,and the numbers of edgesin the graph and in its giant component, respectively. All three functions are non-decreasing on (0,∞). In addition, ψ is strictly increasing, while θ(λ) and ξ(λ) equal 0 for λ < λc and are strictly increasing on [λc,∞).

A fourth function of interest is the pressure η(λ) given in Theorem 10.14. These four functions are real-analytic on (0,∞) \ {λc}. At the singularity λc, the following may be veriﬁed with reasonable ease.

(a) Let q ∈ [1,2). Then θ, ψ, ξ, and η are continuous at the point λc(q) = q. The functions θ and ξ have discontinuous ﬁrst derivatives at λc, with

2 q(2 − q)

θ′(λc−) = ξ′(λc−) = 0, θ′(λc+) = ξ′(λc+) =

.

![image 1207](<rcm1-1_images/imageFile1207.png>)

In particular,

2(λ − λc) q(2 − q)

as λ ↓ λc.

θ(λ) ∼

![image 1208](<rcm1-1_images/imageFile1208.png>)

Similarly, ψ′ and η′′ are continuous, but ψ′′ and η′′′ have discontinuities at λc, except when q = 1.

(b) Let q = 2. Once again, θ, ψ, ξ, and η are continuous at the point λc. In this case,

- 1

![image 1209](<rcm1-1_images/imageFile1209.png>)

- 2 as λ ↓ λc.


θ(λ) ∼ ξ(λ) ∼ 2 3(λ − λc)

![image 1210](<rcm1-1_images/imageFile1210.png>)

Thus, θ′(λc+) = ξ′(λc+) = ∞. The function ψ′ has a jump at λc in that ψ′(λc−) = 41, ψ′(λc+) = 1. Also, η′ is continuous, but η′′ has a jump at λc in that η′′(λc−) = 0, η′′(λc+) = 83. The functionsψ and η are real-analytic on (0,λc] and on [λc,∞).

![image 1211](<rcm1-1_images/imageFile1211.png>)

![image 1212](<rcm1-1_images/imageFile1212.png>)

(c) Let q ∈ (2,∞). Then θ, ψ, and ξ have jumps at λc, and it may be checked

that ψ(λc−) = λc/(2q) < 12 < ψ(λc+). The pressure η is continuous at λc, but its derivative η′ has a jump at λc,

![image 1213](<rcm1-1_images/imageFile1213.png>)

q − 1 2q

2q − 3 2q(q − 1)

η′(λc−) = −

, η′(λc+) = −

.

![image 1214](<rcm1-1_images/imageFile1214.png>)

![image 1215](<rcm1-1_images/imageFile1215.png>)

10.8 Large deviations

The partition function Zn,p,q of (10.2) may be written4 as the exponential expectation

Zn,p,q = φn,p,1(qk(ω)).

This suggests a link, via a Legendre transform, to the theory of large deviations of the cluster-count k(ω) in a random-cluster model. We summarize the consequent theory in this section, and we refer the reader to [62] for the proofs. Related arguments concerning the random-cluster model on a lattice may be found in [298].

Let5 q ∈ [1,∞), λ ∈ (0,∞), and let Cn be the number of components of the graph Gn,λ/n,q. Our target is to show how the exact calculation of pressure in Theorem10.14may be used to estimate probabilitiesof the form φn,p,q(Cn ≤ αn) andφn,p,q(Cn ≥ βn)forgivenconstantsα,β. Whenq = 1,thisgivesinformation about the probabilities of large deviations of Cn in an Erdos–R˝ enyirandom graph.´

As in the language of large-deviation theory, [99, 164], let

n,λ,q(ν) = logφn,p,q(eνCn/n), ν ∈ R,

![image 1216](<rcm1-1_images/imageFile1216.png>)

4See (3.59) also. 5The conclusions of this section are valid when q ∈ (0, 1) also, see [62].

[10.8] Large deviations 297

and note that

whence

n,λ,q(ν) = log

Zn,λ/n,qeν/n Zn,λ/n,q

![image 1217](<rcm1-1_images/imageFile1217.png>)

,

(10.52)

1 n n,λ,q

(nν) → λ,q(ν) = η(λ,qeν) − η(λ,q) as n → ∞,

![image 1218](<rcm1-1_images/imageFile1218.png>)

where η(λ,q) denotes the pressure function of Theorem 10.14. The Legendre transform ∗λ,q of λ,q is given by

(10.53) ∗

λ,q(x) = sup ν∈R

νx − λ,q(ν) , x ∈ R.

It may be proveddirectly, orsee [99, Lemma 2.3.9], that λ,q and ∗λ,q are convex functions, and that

(10.54) ∗

λ,q(x) = δx − λ,q(δ) if ′

λ,q(δ) = x.

Since we have an exactformulafor λ,q, see (10.15) and (10.52),we may compute its derivative whenever it exists. Consequently,

< ∞ if x ∈ [0,1],

∗ λ,q(x)

= ∞ otherwise.

A large-deviationprinciple (LDP) may be established for n−1Cn in terms of the

‘rate function’ ∗λ,q. The details of the LDP depend on the set of points x at which ∗ λ,q is strictly convex,and we investigate this next. There is a slight complication

arising from the discontinuity of the phase transition when q ∈ (2,∞). The function

∂η ∂q

(10.55) κ(λ,q) = q

,

![image 1219](<rcm1-1_images/imageFile1219.png>)

turns out to play a central role. This derivative exists except when λ = λc(q) and q ∈ (2,∞), and satisﬁes

1 n

κ(λ,q) = lim

(10.56) φn,λ/n,q(Cn)

![image 1220](<rcm1-1_images/imageFile1220.png>)

n→∞

λ 2q

= 1 − θ(λ) − [1 − θ(λ)]2

.

![image 1221](<rcm1-1_images/imageFile1221.png>)

When λ = λc(q) and q ∈ (2,∞), the limits

∂η ∂q

κ±(λ,q) = q

![image 1222](<rcm1-1_images/imageFile1222.png>)

(λ,q±)

exist with κ−(λ,q) < κ+(λ,q). Also, κ−(λ,q) is given by (10.56), and

λ 2q

κ+(λ,q) = 1 −

.

![image 1223](<rcm1-1_images/imageFile1223.png>)

Details of the above calculations may be found in [62]. We write Fλ,q for the set of ‘exposed points’ of ∗

λ,q, and one may see after some work that

(0,1) if λ ≤ 2, (0,1) \ [κ−(λ, Q),κ+(λ, Q)] if λ > 2,

(10.57) Fλ,q =

where Q is chosen to satisfy λ = λc(Q). The following LDP is a consequence of the Gartner–Ellis¨ theorem, [99, Thm 2.3.6].

#### (10.58) Theorem (Large deviations) [62]. Let q ∈ [1,∞) and λ ∈ (0,∞).

(a) For any closed subset F of R,

lim sup

n→∞

1 n

logφn,p,q(n−1Cn ∈ F) ≤ − inf x∈F

![image 1224](<rcm1-1_images/imageFile1224.png>)

(b) For any open subset G of R,

∗ λ,q(x).

lim inf

n→∞

1 n

logφn,p,q(n−1Cn ∈ G) ≥ − inf

![image 1225](<rcm1-1_images/imageFile1225.png>)

x∈G∩Fλ,q

∗ λ,q(x).

Ofespecialinterestarethecaseswhen F takestheform[0,α]or[β,1], analysed as follows using Theorem 10.58.

(i) Let q ∈ [1,2]. Then, as n → ∞,

1 n

logφn,p,q(Cn ≤ αn) → − ∗λ,q(α), (10.59)

![image 1226](<rcm1-1_images/imageFile1226.png>)

1 n

logφn,p,q(Cn ≥ βn) → − ∗λ,q(β), (10.60)

![image 1227](<rcm1-1_images/imageFile1227.png>)

whenever 0 < α ≤ κ(λ,q) ≤ β < 1. (ii) Let q ∈ (2,∞) and λ = λc(q). Then (10.59)–(10.60) hold for α, β satisfying

0 < α ≤ κ−(λ,q) < κ+(λ,q) ≤ β < 1.

(iii) Let q ∈ (2,∞) and λ  = λc(q). Let Q be such that λ = λc(Q). Then (10.59)–(10.60) hold for any α, β satisfying 0 < α ≤ κ(λ,q) ≤ β < 1 except possibly when

κ−(λ, Q) < α ≤ κ+(λ, Q) or κ−(λ, Q) ≤ β < κ+(λ, Q).

We note that κ+(λ, Q) < κ(λ,q) if Q < q, and κ−(λ, Q) > κ(λ,q) if Q > q, so that only one of these two cases can occur for any given q.

We summarize the above facts as follows. Excepting the special case when λ = λc(q) and q ∈ (2,∞), the limit

1 n

κ = lim

φn,p,q(Cn)

![image 1228](<rcm1-1_images/imageFile1228.png>)

n→∞

exists, and the probabilities φn,p,q(Cn ≤ αn), φn,p,q(Cn ≥ βn) decay at least as fast as exponentially when α < κ < β. The exact (exponential) rate of decay can be determined except when the levels αn and βn lie within the interval of discontinuity of a ﬁrst-order phase transition. In the exceptional case with λ = λc(q) and q ∈ (2,∞), a similar conclusion holds when α < κ− and β > κ+.

Since ﬁrst-order transitions occur only when q ∈ (2,∞), and since the critical λ-values of such q ﬁll the interval (2,∞), there is a weak sense in which the value λ = 2 marks a singularity of the asymptotics of the random graph Gn,λ/n,q. This holds for any value of q, including q = 1. That is, the Erdos–R˝ enyi´ random graph senses the existence of a ﬁrst-order phase transition in the random-cluster model, butonly throughits large deviations. Itis well knownthat the Erdos–R˝ enyi´ random graph undergoes a type of phase transition at λ = 1, and it follows from the above that it has a (weak) singularity at λ = 2 also.

10.9 On a tree

A random-cluster measure on a ﬁnite tree is simply a product measure — it is the circuits of a graph which cause dependence between the states of different edges and, when there are no circuits, there is no dependence. This may be seen explicitlyasfollows. Let p ∈ [0,1] andq ∈ (0,∞), andlet T = (V, E)be a ﬁnite tree. For ω ∈ = {0,1}E, the number of open clusters is k(ω) = |V| − |η(ω)|, so that the corresponding random-cluster measure φp,q satisﬁes

|η(ω)|

|η(ω)|

p q(1 − p)

π 1 − π

(10.61) φp,q(ω) ∝

=

, ω ∈  ,

![image 1229](<rcm1-1_images/imageFile1229.png>)

![image 1230](<rcm1-1_images/imageFile1230.png>)

where (10.62) π = π(p,q) =

p p + q(1 − p)

.

![image 1231](<rcm1-1_images/imageFile1231.png>)

Therefore,φp,q istheproductmeasureon withdensityπ. Thesituationbecomes more interesting when we introduce boundary conditions.

Let T be an inﬁnite labelled tree with root 0, and let R = R(T) be the set of all inﬁnite (self-avoiding) paths of T beginning at 0, termed 0-rays. We may think of a boundary condition on T as being an equivalence relation ∼ on R, the

0

Figure 10.4. Part of the inﬁnite binary tree T2.

‘physical’ meaning of which is that two rays ρ, ρ′ are considered to be ‘connected at inﬁnity’ whenever ρ ∼ ρ′. Such connections affect the counts of connected components of subgraphs. The two extremal boundary conditions are usually termed ‘free’ (meaning that there exist no connections at inﬁnity) and ‘wired’ (meaning that all rays are equivalent). The wired boundary condition on T has been studied in [167, 196], and general boundary conditions in [160]. There has been a similar development for Ising models on trees with boundary conditions, see for example [48, 49, 188] in the statistical-physics literature and [114, 248, 256] in the probability literature under the title ‘broadcasting on trees’.

We restrict ourselves to the so-called binary tree T = T2, the calculations are easily extended to a regular m-ary tree Tm with m ∈ {2,3,. . .}. Thus T = (V, E) is taken henceforth to be a regular labelled tree, with a distinguished root labelled 0, and such that every vertex has degree 3. See Figure 10.4.

We turn T into a directed tree by directing every edge away from 0. There follows some notation concerning the paths of T. Let x be a vertex. An x-ray is deﬁned to be an inﬁnite directed path of T with (unique) endvertex x. We denote by Rx the set of all x-rays of T, and we abbreviate R0 to R. We shall use the term ray to mean a member of some Rx. The edge of T joining vertices x and y is denoted by x, y when undirected, and by [x, y when directed from x to y. For any vertex x, we write R′x for the subset of R comprising all rays that pass through x. Any ray ρx ∈ Rx is a sub-ray of a unique ray ρx′ ∈ R, and thus there is a natural one–one correspondence ρx ↔ ρx′ between Rx and R′x.

Let E be the set of equivalencerelations on the set R. Any equivalencerelation ∼ on R may be extendedto an equivalencerelation on v∈V Rv by: for ρu ∈ Ru, ρv ∈ Rv, we have ρu ∼ ρv if and only if ρu′ ∼ ρv′ .

One may deﬁne the random-cluster measure corresponding to any given member ∼ of a fairly large sub-class of E, but for the sake of simplicity we shall concentrate in the main on the two extremal equivalence relations, as follows.

There is a partial order ≤ on E given by: (10.63) ∼1 ≤ ∼2 if: for all ρ,ρ′ ∈ R, ρ ∼2 ρ′ whenever ρ ∼1 ρ′.

There is a minimal (respectively, maximal) partial order which we denote by ∼0 (respectively, ∼1). The equivalence classes of ∼0 are singletons, whereas ∼1 has the single equivalence class R. We refer to ∼0 (respectively, ∼1) as the ‘free’ (respectively, ‘wired’) boundary condition.

Let be a ﬁnite subset of V, and let E be the set of edges of T having both endvertices in . For ξ ∈ = {0,1}E, we write ξ for the (ﬁnite) subset of

containing all conﬁgurations ω satisfying ω(e) = ξ(e) for e ∈ E \ E ; these are the conﬁgurations that agree with ξ off . For simplicity, we shall restrict ourselves to sets of a certain form. A subset C of V is called a cutset if every inﬁnite path from 0 intersects C, and C is minimal with this property. It may be seen by an elementary argument that every cutset is ﬁnite. Let C be a cutset, and write out(C) for the set of all vertices x such that: x ∈/ C and the (unique) path from 0 to x intersects C. A box is a set of the form V \ out(C) for some cutset C, and we write ∂  for the corresponding C.

Let be a box, and let ∼ ∈ E, ξ ∈ , and ω ∈ ξ . The conﬁguration ω gives rise to an ‘open graph’ on , namely G( ,ω) = ( ,η(ω) ∩ E ). We augment this graph by adding certain new edges representing the action of the equivalence relation ∼ in the presence of the externalconﬁguration ξ. Speciﬁcally, for distinct u,v ∈ ∂ , we add a new edge between the pair u, v if there exist ξ-open rays ρu ∈ Ru, ρv ∈ Rv satisfying ρu ∼ ρv. We write Gξ,∼( ,ω) for the resulting augmented graph, and we let kξ,∼( ,ω) be the number of connected components of Gξ,∼( ,ω). These deﬁnitions are motivated by the idea that each equivalence class of rays leads to a common ‘point at inﬁnity’ through which vertices may be connected by open paths.

We deﬁne next a random-clustermeasure correspondingto a given equivalence

relation ∼. Let ξ ∈ , and let p ∈ [0,1] and q ∈ (0,∞). We deﬁne φ ,ξ,∼p,q as the random-cluster measure on the box ( , E ) with boundary condition (ξ,∼).

More precisely, φ ,ξ,∼p,q is the probability measure on the pair ( ,F ) given by (10.64)

 

1 Z ,ξ,∼p,q e∈E

pω(e)(1 − p)1−ω(e) qkξ,∼( ,ω) if ω ∈ ξ ,

![image 1232](<rcm1-1_images/imageFile1232.png>)

φ ,ξ,∼p,q(ω) =



0 otherwise, where Z ,ξ,∼p,q is the appropriate normalizing constant,

pω(e)(1 − p)1−ω(e) qkξ,∼( ,ω).

(10.65) Z ,ξ,∼p,q =

ω∈ ξ e∈E

In the special case when ξ = 1 and ∼ = ∼1, we write φ ,1 p,q for φ ,ξ,∼p,q. This measure will be referred to as the random-cluster measure on with ‘wired’

boundary conditions, and it has been studied in a slightly disguised form in [167, 196].

For any ﬁnite subset ⊆ V, let T denote the σ-ﬁeld generated by the set {ω(e) : e ∈ E \ E } of states of edges having at least one endvertex outside . For e ∈ E, Te denotes the σ-ﬁeld generated by the states of edges other than e.

Let p ∈ [0,1], q ∈ (0,∞), and let ∼ be an equivalence relation that satisﬁes a certain measurability condition to be stated soon. A probability measure φ on ( ,F ) is called a (∼)DLR-random-cluster measure with parameters p and q if: for all A ∈ F and all boxes ,

(10.66) φ(A | T )(ξ) = φ ,ξ,∼p,q(A) for φ-a.e. ξ. The set of such measures is denoted by R∼p,q. The set R∼p,q is convex whenever it is non-empty (as in Theorem 4.34).

We introduce next the relevant measurability assumption on the equivalence relation ∼. Sincetheleftsideof(10.66)isameasurablefunctionof ξ,therightside must be measurable also. For a box and distinct vertices u,v ∈ ∂ , let Ku∼,v,  denote the set of ω ∈ such that there exist ω-open rays ρu ∈ Ru, ρv ∈ Rv satisfying ρu ∼ ρv. We call the equivalence relation ∼ measurable if Ku∼,v,  ∈ F for all such u, v, . It is an easy exercise to deduce, if ∼ is measurable, that φ ,ξ,∼p,q(A) is a measurable function of ξ, thus permitting condition (10.66). We write Em for the set of all measurable elements of E. It is easily seen that the extremal equivalence relations ∼0, ∼1 are measurable.

For simplicity of notation we write R∼p,0q = R0p,q and similarly R∼p,1q = R1p,q. Members of R0p,q (respectively, R1p,q) are called ‘free’ random-cluster measures (respectively, ‘wired’ random-cluster measures). There follows an existence theorem. Any probability measure µ on ( ,F ) is called automorphism-invariant if the vectors (ω(e) : e ∈ E) and (ω(τe) : e ∈ E) have the same laws under µ, for any automorphism τ of the tree T.

(10.67) Theorem [167]. Let p ∈ [0,1] and q ∈ (0,∞).

- (a) The set R0p,q of free random-cluster measures comprises the singleton φπ only, where π = π(p,q) is given in (10.62). The product measure φπ belongs to R1p,q if and only if π ≤ 21.

![image 1233](<rcm1-1_images/imageFile1233.png>)

- (b) The set R1p,q of wired random-cluster measures is non-empty. (c) If q ∈ [1,∞), the weak limit


φp1,q = lim ↑V

φ ,1 p,q (10.68)

exists and belongs to R1p,q. Furthermore, φp1,q is an extremal element of the convex set R1p,q and is automorphism-invariant.

Here are some comments on this theorem. Part (b) will be proved at Theorem 10.82(c). Parts (a) and (c) are proved later in the currentsection, and we anticipate

this with a brief discussion of the condition π ≤ 21. This will be recognized as the conditionforthe almost-sureextinctionof a branchingprocesswhose family-sizes

![image 1234](<rcm1-1_images/imageFile1234.png>)

have the binomial bin(2,π) distribution. That is, π ≤ 21 if and only if (10.69) φπ(0 ↔ ∞) = 0,

![image 1235](<rcm1-1_images/imageFile1235.png>)

see [164, Thm 5.4.5]. It turns out that the product measure φπ lies in R1p,q if and only if it does not ‘feel’ the wired boundary condition ∼1, that is to say, if there exist (φπ-almost-surely) no inﬁnite clusters6.

We turn brieﬂy to more general boundary conditions than merely the free and wired, see [160] for further details. The set R of rays may be viewed as a compact topological space with the product topology. Let ∼ be an equivalence relation on R. We call ∼ closed if the set {(ρ1,ρ2) ∈ R2 : ρ1 ∼ ρ2} is a closed subset of R2. It turns out that closed equivalence relations are necessarily measurable. For q ∈ [1,∞) and a closed relation ∼, the existence of the weak limit φp1,,∼q = lim ↑V φ ,1,∼p,q follows by stochastic ordering, and it may be shown that φp1,,∼q is a (∼)DLR-random-cluster measure.

Theorem 10.67 leaves open the questions of deciding when φπ = φp1,q, and

when R1p,q comprises a singleton only. We return to these questions in Sections 10.10–10.11.

Proof of Theorem 10.67. (a) Consider the free boundary condition ∼0, and let A be a cylinder event. By (10.61),

φ ,ξ,∼p0,q(A) = φπ(A)

for all boxes that are sufﬁciently large that A is deﬁned on the edge-set E . For φ ∈ R0p,q, by (10.66),

φ(A | T ) = φπ(A), φ-almost-surely, for all sufﬁciently large , and therefore

φ(A) = φ(φ(A | T )) = φπ(A)

as required. The second part of (a) is proved after the proof of (c). (c) The existence of the weak limit in (10.68) follows by positive assocation as in the proof of Theorem 4.19(a). In orderto show that the limit measure lies in R1p,q, we shall make use of the characterization of random-cluster measures provided by Proposition 4.37; this was proved with the lattice Ld in mind but is valid also in the present setting with the same proof.

For v ∈ V, let v be the set of inﬁnite undirected paths of T with endvertex v. Let e = x, y , and let Ke1 be the event that there exist open vertex-disjoint paths

![image 1236](<rcm1-1_images/imageFile1236.png>)

6See also [168].

νx ∈ x and νy ∈ y. For any box and ω ∈ , let ω1 denote the conﬁguration that agrees with ω on E and equals 1 elsewhere, which is to say that

ω1 (e) =

ω(e) if e ∈ E , 1 otherwise.

We deﬁne the event

Ke1,  = {ω ∈ : ω1 ∈ Ke1}. Note that Ke1,  is a cylinder event, and is decreasing in . It is easily checked that

(10.70) Ke1,  ↓ Ke1 as ↑ V.

We may now state the relevant conclusion of Proposition 4.37 in the current context, namely that φ ∈ R1p,q if and only if, for all e ∈ E,

e φ-almost-surely, where Je = {e is open}.

(10.71) φ(Je | Te) = π + (p − π)1K1

For ξ ∈ and W ⊆ V, write [ξ]W for the set of all conﬁgurations that agree

with ξ on EW. For e ∈ EW, let [ξ]W\e be an abbreviation for [ξ]EW\{e}. We shall omit explicit reference to the values of p and q in the rest of this proof. Thus, for

example, φ1 = φp1,q.

Bythemartingaleconvergencetheorem(see[164, Ex.12.3.9]), fore = x, y ∈ E and φ1-almost-every ξ,

(10.72)

φ1(Je, [ξ] \e) φ1([ξ] \e)

φ1(Je | Te)(ξ) = lim ↑V

![image 1237](<rcm1-1_images/imageFile1237.png>)

φ1 (Je, [ξ] \e) φ1 ([ξ] \e)

= lim

lim

![image 1238](<rcm1-1_images/imageFile1238.png>)

↑V

↑V

φ1 φ1 (Je | [ξ] \e) [ξ] \e

= lim

lim

↑V

↑V

φ1 (g | [ξ] \e),

= lim

lim

↑V

↑V

by Theorem 3.1, where

g (ξ) = π + (p − π)1K1

e, 

(ξ).

e . We claim that

By (10.70), g ↓ g as ↑ V, where g = π + (p − π)1K1

(10.73) φ1 (g | [ξ] \e) → φ1(g | [ξ] \e) as ↑ V,

and we prove this as follows. Let ′, ′′ be boxes satisfying ⊆ ′ ⊆ ⊆ ′′. Since ψ (·) = φ1 (· | [ξ] \e) is a random-cluster measure on an altered graph (see Theorem 3.1(a)) and since g is increasing on and non-increasing in , we have by positive association that

ψ ′′(g ) ≤ ψ (g ) ≤ ψ (g ′).

Let ′′ ↑ V, ↑ V, and ′ ↑ V, in that order, to conclude (10.73) by monotone convergence.

By the martingale convergence theorem again,

φ1(g | [ξ] \e) → g(ξ) as ↑ V, for φ1-a.e. ξ, and (10.71) follows by (10.72)–(10.73).

The extremality of φp1,q is a consequence of positive association, on noting that

φp1,q ≥st φ for all φ ∈ R1p,q. Let τ be an automorphism of the graph T. In the notation of Section 4.3, for any increasing cylinder event A and all boxes ,

φ ,1 p,q(A) = φτ ,1 p,q(τ−1A), and, by positive association,

φτ ,1 p,q(τ−1A) ≥ φ ,1 p,q(τ−1A) if ⊇ τ . Letting ↑ V, we obtain that

φ ,1 p,q(A) ≥ φp1,q(τ−1A),

so that φp1,q(A) ≥ φp1,q(τ−1A). Equality must hold here, and the claim of automorphism-invariance follows.

Turning to the ﬁnal statement of part (a), by the discussion around (10.71),

φπ ∈ R1p,q if and only if φπ(Ke1) = 0 for all e ∈ E. Since φπ is a product measure, this condition is equivalent to (10.69).

10.10 The critical point for a tree

We concentrate henceforth on the binary tree T = T2 = (V, E) and the wired equivalence relation ∼1. It is shown in this section how the series/parallel laws may be used to study random-cluster measures on T. Corresponding results are valid for the m-ary tree with m ≥ 2.

The results of this section are valid for all q ∈ (0,∞), and we begin by proving the existence of the wired weak-limit for all p and q, thereby extending part of Theorem 10.67(c). The limit as ↑ V is taken along an arbitrary increasing sequence of boxes.

and let fp,q, gq : [0,1] → [0,1] be given by

(10.79) fp,q(x) = Fp,q(x, x), gq(y) =

1 − (1 − y)3 1 + (q − 1)(1 − y)3

(10.80) .

![image 1239](<rcm1-1_images/imageFile1239.png>)

An important quantity is the maximal root ρ = ρ(p,q) in [0,1] of the equation

fp,q(x) = x. In particular, we will need to know under what conditions ρ(p,q) is strictly positive. (10.81) Proposition. Let p ∈ [0,1] and q ∈ (0,∞). Let ρ = ρ(p,q) be the maximal solution in the interval [0,1] of the equation fp,q(x) = x. Then:

ρ > 0 if and only if p

> κq when 0 < q ≤ 2, ≥ κq when q > 2.

The proof of this proposition is elementary and is omitted. Illustrations of the three cases q ∈ (0,1), q ∈ [1,2], q ∈ (2,∞) appear in Figure 10.5. We now state the main theorem of this section.

(10.82) Theorem. Let p ∈ [0,1] and q ∈ (0,∞). Then:

(a) θ(p,q) = gq(ρ) where ρ is the maximal root in [0,1] of the equation

fp,q(x) = x, (b) pc(q) = κq where κq is given in (10.78), (c) φp1,q ∈ R1p,q, (d) R1p,q = {φπ} whenever θ(p,q) = 0.

This theorem may be found in essence in [167] but with different proofs. In contrast to the direct calculations7 of this section, the proofs in [167] proceed via a representation of random-cluster measures on T in terms of a certain class of multi-type branching processes.

Proof of Theorem 10.74. We use the series/parallel laws of Theorem 3.89. The basic fact is that three edges in the conﬁguration on the left side of Figure 10.6, with parameter-values as given there, may be replaced as indicated by a single edge with parameter Fp,q(x, y). This is easy to check: the two lower edges in parallel may be replaced by a single edge with parameter 1 − (1 − x)(1− y), and the latter may then be combined with the upper edge in series.

Let n = {x ∈ V : |x| ≤ n}, where |x| denotes the number of edges in the path from 0 to x. We consider ﬁrst the measures φ1 n,p,q, in the limit as n → ∞.

Let Hr be the graph obtained from the ﬁnite tree ( r, E r) by adding two new edges [x, x′ , [x, x′′ to each terminal vertex x ∈ ∂ r. We colour these new

![image 1240](<rcm1-1_images/imageFile1240.png>)

7The current method was mentioned in passing in [160].

0

x

x′

x′′

Figure 10.7. To each boundary vertex x of the box 2 is attached two new (green) edges [x, x′ , [x, x′′ . The resulting graph is denoted by H2.

where φr1,∞ is the wired random-cluster measure on Hr in which the green edges have parameter ρ.

When q ∈ [1,∞), the random-cluster measure is positively associated, and (10.85) implies (10.75) for general . When q ∈ (0,1), a separate argument is needed in order to extend the limit in (10.85) to a general increasing sequence of boxes. Let be a box with ⊇ r+1, and let

a = a( ) = max{n : n ⊆ }, b = b( ) = min{n : ⊆ n}.

The measure φ ,1 p,q may be viewed as the random-cluster measure on 1b in which edges of E b \ E have parameter 1. We may reduce 1b to Hr1 via the series/parallel laws as above. Since Fp,q(x, y) is increasing in p, x, y, the green edges of Hr1 acquire parameter values lying between fp(,bq−r)(1) and fp(,aq−r)(1). Now a,b → ∞ as → V, and

f (b−r)

p,q (1) → ρ, f (a−r)

p,q (1) → ρ. It follows as above that

(10.86) φ ,1 p,q(E) → φr1,∞(E) as ↑ V.

There remains a detail. Each φ ,1 p,q is a probability measure on the compact state space . Therefore, the family of such φ ,1 p,q, as ranges over boxes, is tight. By Prohorov’s theorem, [42], every subsequence contains a convergent sub(sub)sequence. The limiting probabilityof any cylinderevent E is, by (10.86), independent of the choice of subsequence. Therefore, the weak limit in (10.75) exists, and the theorem is proved.

Proof of Theorem 10.82. (a) Let ρ be as given. We claim that

(10.87) φ1 n,p,q(0 ↔ ∂ n) → gq(ρ) as n → ∞. By series/parallel replacement as in the proof of Theorem 10.74,

θn(p,q) = φ1 n,p,q(0 ↔ ∂ n) satisﬁes

θn(p,q) = θ1( fp(,nq)(1),q).

By (10.83), θn(p,q) → θ1(ρ,q) as n → ∞. It is an easy calculation that θ1(z,q) = gq(z), and (10.87) follows.

The proof of Proposition 5.11 is valid in the current setting, whence θ(p,q) = lim

θn(p,q) = gq(ρ), whenever q ∈ [1,∞). This proves (a) for q ∈ [1,∞).

n→∞

Suppose that q ∈ (0,1). The situation is now harder since we may not appeal to positive association. Instead, we use the weaker inequalities (5.117)–(5.118) which we summarize as:

(10.88) φG,p,1 ≤st φG,p,q ≤st φG,π,1, for any ﬁnite graph G, where π = p/[p + q(1 − p)]. By Proposition 4.10(a), corresponding inequalities hold for the weak limits of random-cluster measures.

Let p ≤ κq, so that ρ = 0. Then π = p/[p + q(1 − p)] ≤ 21, and therefore φπ1(0 ↔ ∞) = 0. By (10.88), θ(p,q) = ρ = 0 as claimed.

![image 1241](<rcm1-1_images/imageFile1241.png>)

Let p > κq, so that ρ > 0. By Theorem 10.74, θ(p,q) = lim

(10.89) φp1,q(0 ↔ ∂ r)

r→∞

φ1 s,p,q(0 ↔ ∂ r). Now,

= lim

lim

r→∞

s→∞

φ1 s,p,q(0 ↔ ∂ r) ≥ φ1 s,p,q(0 ↔ ∂ s), r ≤ s, and therefore, by (10.87), (10.90) θ(p,q) ≥ gq(ρ).

By (10.87) and (10.89), θ(p,q) − gq(ρ) = lim

(10.91) φ1 s,p,q(0 ↔ ∂ r, 0 ↔/ ∂ s)

lim

r→∞

s→∞

φr1,∞(0 ↔ ∂ r, 0 ↔/ ∂ r+1),

= lim

r→∞

where φr1,∞ is deﬁned after (10.85).

For ω ∈ and r ≥ 0, let Gr be the set of vertices x ∈ ∂ r such that 0 is joined to x by an open path of the tree, and write Nr = |Gr|. We claim that (10.92) for k = 1,2,. . ., φp1,q(1 ≤ Nr ≤ k) → 0 as r → ∞, and we prove this as follows. Let k ∈ {1,2,. . .}, and deﬁne the random sequence R(0), R(1), R(2),. . . by R(0) = 0 and

R(i + 1) = min s > R(i) : 1 ≤ Ns ≤ k , i ≥ 0.

The length of the sequence is I + 1 where I = I(ω) = |{r ≥ 1 : 1 ≤ Nr ≤ k}|, and we prove next that

(10.93) φp1,q(I < ∞) = 1.

Let i ≥ 0, and suppose we are given that I(ω) ≥ i. Conditional on R(0), R(1), R(2),. . . , R(i), and on the states of all edges in E R(i), there is a certain (conditional) probability that, for all x ∈ GR(i), x is incident to no vertex in ∂ R(i)+1. By Theorem3.1(a),the appropriate(conditional)probabilitymeasureis a randomcluster measureon a certain graphobtainedfrom T by the deletionand contraction of edgesin E R(i). Since |GR(i)| ≤ k, there are nomore than2k edgesof T joining GR(i) to ∂ R(i)+1 and, by the second inequality of (10.88),

φp1,q(I = i | I ≥ i) ≥ (1 − π)2k. Therefore,

φp1,q(I ≥ i + 1 | I ≥ i) ≤ 1 − (1 − π)2k, i ≥ 0, whence

φp1,q(I ≥ i) ≤ 1 − (1 − π)2k i, i ≥ 0, and, in particular, (10.93) holds. Hence, M = sup{r : 1 ≤ Nr ≤ k} satisﬁes φp1,q(M < ∞) = 1, implying as required that

(10.94) φp1,q(1 ≤ Nr ≤ k) ≤ φp1,q(M ≥ r) → 0 as r → ∞. By a similar argument, φr1,∞(0 ↔ ∂ r, 0 ↔/ ∂ r+1) =

∞

φr1,∞(Nr = l, 0 ↔/ ∂ r+1)

l=1

∞

(1 − ρ)2lφp1,q(Nr = l) by (10.88)

≤

l=1

≤ φp1,q(1 ≤ Nr ≤ k) + (1 − ρ)2k

→ (1 − ρ)2k as r → ∞, by (10.92)

→ 0 as k → ∞.

By (10.90) and (10.91), θ(p,q) = gq(ρ). (b) This is an immediate consequence of part (a), Proposition 10.81, and the deﬁnition of pc(q). (c) Let q ∈ (0,∞). We shall show that φp1,q satisﬁes (10.71) for e ∈ E. As in (10.72), for e = x, y ∈ E,

(10.95) φp1,q(Je | Te)(ξ) = lim ↑V

φ ,1 p,q(Je | [ξ] \e), φp1,q-a.s.

lim

↑V

If ξ ∈/ Ke1, then [ξ] \e ∩ Ke1 = ∅ for large , and thus

p p + q(1 − p)

φ ,1 p,q(Je | [ξ] \e) =

for large ,  ,

![image 1242](<rcm1-1_images/imageFile1242.png>)

by Theorem 3.1. By (10.95),

p p + q(1 − p)

, φp1,q-a.s. on \ Ke1.

(10.96) φp1,q(Je | Te) =

![image 1243](<rcm1-1_images/imageFile1243.png>)

Suppose that φp1,q(Ke1) > 0, let ξ ∈ Ke1, and take = r in the notation of the previous proof. As in that proof, for e ∈ E r,

φ ,1 p,q(Je | [ξ]r) = φr1,∞(Je | [ξ]r),

lim

↑V

where [ξ]r = [ξ] r\e. Let Nr(u) be the number of vertices in ∂ r joined to u by an open path. As in the previous proof,

Nr(x), Nr(y) → ∞ as r → ∞, φp1,q-a.s. on Ke1,

whence, for φp1,q-almost-every ξ ∈ Ke1,

φr1,∞(Je | [ξ]r) − φr1,∞(Je | x, y ↔ ∂ r+1 off e) → 0 as r → ∞. By Theorem 3.1,

φr1,∞(Je | x, y ↔ ∂ r+1 off e) = p, and therefore,

φp1,q(Je | Te) = p, φp1,q-a.s. on Ke1. When combined with (10.96), this implies (10.71), and the claim follows.

(d) Let φ ∈ R1p,q, where p and q are such that θ(p,q) = 0. By the argument in the proof of part (a), φ(0 ↔ ∞) = 0, and therefore φ(Ke1) = 0 for e ∈ E. By (10.71), φ(Je | Te) = π, φ-almost-surely, whence φ = φπ as claimed.

[10.11] (Non-)uniqueness of measures on trees 313

10.11 (Non-)uniqueness of measures on trees

For which p, q is there a unique wired random-cluster measure on the binary tree T? We assume for simplicity that q ∈ [1,∞). By Theorem 10.82, R1p,q = {φπ} whenever p is sufﬁciently small that φp1,q(0 ↔ ∞) = 0. The last holds if and only if

p ≤ κq for q ∈ [1,2], < κq for q ∈ (2,∞),

where κq is given in (10.78). Larger values of p are considered in the following conjecture.

(10.97) Conjecture [167]. We have that |R1p,q| = 1 if : either q ∈ [1,2], or q ∈ (2,∞) and p > q/(q + 1).

When q ∈ (2,∞) and κq ≤ p ≤ q/(q + 1), there exists a continuum of wired random-cluster measures, see [167]. These may be cooked up on the basis of the following two facts:

(i) φπ(0 ↔ ∞) = 0 when p ≤ q/(q + 1), (ii) φp1,q  = φπ when q ∈ (2,∞) and p ≥ κq,

where π = p/[p + q(1 − p)]. The recipe is as follows. Let x be a vertex of T other than its root. The set Rx of x-rays constitutes an inﬁnite binary tree denoted by Tx = (Vx, Ex) with root x (the vertex x has degree 2 in Tx). Let ex denote the unique edge of T with endvertex x and not belonging to Tx, and let Ex′ = Ex ∪ {ex}. Let µx be the measure on ( ,F ) given by:

- (a) the states of edges in Ex′ are independent of those of edges in E \ Ex′ , and have as law the product measure on {0,1}Ex with density π,
- (b) the states of edges in E \ Ex′ have as law the conditional measure of φp1,q given that ex is closed.


That µx ∈ R1p,q may be seen in very much the same way as in the proof of Theorem 10.67(c), under the condition that there exist, φπ-almost-surely, no inﬁnite open clusters. Thus, µx ∈ R1p,q if p ≤ q/(q + 1). If, in addition, q ∈ (2,∞) and p ≥ κq, then φp1,q(0 ↔ ∞) > 0. This implies that

φp1,q(x ↔ ∞ in Tx | ex is closed) > 0,

whence µx  = φp1,q. It is not hard to see that µx  = µy whenever x  = y, subject to the above conditions on p, q. Since V is countably inﬁnite, there exist (at least)

countably inﬁnitely many members of R1p,q. This conclusion may be strengthened by choosing an inﬁnite sequence x =

(xi : i = 1,2,. . .) of vertices such that: for every i, xi is incident to no e ∈ Ex′j with j < i. One performs a construction similar to the above, but with product

measure on each of the sets Exi, i = 1,2,. . .. This results in a probability measure µx belonging to R1p,q and labelled uniquely by the sequence x. There

314 On Other Graphs [10.11]

are uncountably many choices for x, and therefore uncountably many distinct members of R1p,q. For the sake of clarity, we point out that one way to choose a large class of possible x is to take an inﬁnite directed path of T, and to consider the power set of the set of all neighbours of that do not belong to .

Partial progress towards a veriﬁcation of Conjecture 10.97 may be found in [196]. A broader class of equivalence relations has been considered in [160]. (10.98) Theorem [160, 196]. Let q ∈ [1,∞) and let p ≥ 2q/(2q + 1). The set R1p,q comprises the singleton φp1,q only.

The condition of this theorem is not best possible in the case q = 1, and therefore is unlikely to be best possible for q ∈ (1,∞).

There has been extensive study of the Ising model on a tree. It turns out that therearetwocriticalpointsonthebinarytree T. Theﬁrstcriticalpointcorresponds to the random-cluster transition at the point p = κ2 = 32, and the second arises as follows. Consider the Ising model on T with free boundary conditions. There is a critical value of the inverse-temperature at which the corresponding Gibbs state ceases to be extremal. In the parametrization of this chapter, this critical point is given by psg = 2/(1 +

![image 1244](<rcm1-1_images/imageFile1244.png>)

√2), see [49, 188, 189, 250]. This value arises also in the study of a related ‘Edwards–Anderson’spin-glass problem on T, see [89] and Section 11.5. Itmay be seen by a processof spin-ﬂippingthat the spin-glassmodel with ±1 interactionscan be mappedto a ferromagneticIsing modelwith boundary conditions taken uniformly and independently from the spin space {−1,+1}. It turns out that this model has critical value psg also, and for this reason psg is commonly referred to as the ‘spin-glass critical point’.

![image 1245](<rcm1-1_images/imageFile1245.png>)

In summary, for p = 1 − e−β < 32, the Ising model has a unique Gibbs state.

![image 1246](<rcm1-1_images/imageFile1246.png>)

For p ∈ (32, psg), the + Gibbs state differs from the free state, whereas ‘typical’ boundary conditions (in the sense of boundary conditions chosen randomly ac-

![image 1247](<rcm1-1_images/imageFile1247.png>)

cordingto the free state) result in the free measure. When p > psg, the free state is no longeran extremalGibbsstate. This doubletransitionis notevidentin the analysis of this chapter since it is restricted to boundary conditions of ‘unconditioned’ random-cluster-type.

Sketch proof of Theorem 10.98. Note ﬁrst that p ≥ 2q/(2q + 1) if and only if π = p/[p + q(1 − p)] satisﬁes π ≥ 32. Under this condition we may obtain, by a branching-process argument, the φπ-almost-sure existence in T of a (random) set W of vertices such that: (i) every 0-ray passes through some vertex of W, and (ii) every w ∈ W is the root of an inﬁnite open sub-tree of T. The argument then continues rather as in the proof of Theorem 5.33(b). The details may be found in [160, 196].

![image 1248](<rcm1-1_images/imageFile1248.png>)

10.12 On non-amenable graphs

Thepropertiesofinteractingsystemsontreesareoftenquitedifferentfromthoseof lattice systems, fortwo reasons. Firstly, trees have a multiplicity of ‘inﬁnite ends’, and secondly, the surface/volume ratios of boxes are bounded away from 0. The latter property is especially interesting and leads to an important categorization of graphs. Let G = (V, E) be an inﬁnite connected locally ﬁnite graph. We call G amenable if its ‘isoperimetric constant’

(10.99) χ(G) = inf |∂W| |W|

: W ⊆ V, 0 < |W| < ∞

![image 1249](<rcm1-1_images/imageFile1249.png>)

satisﬁes χ(G) = 0. The graph is called non-amenable if χ(G) > 0. It is easily seen that the lattices Ld and the regular m-ary tree Tm satisfy

χ(Ld) = 0, χ(Tm) > 0 for m ≥ 2, so that lattices are amenable, and regular trees of degree 3 or more are not.

It is convenient to make certain assumptions of homogeneity on the graph G = (V, E). An automorphism8 of G is a bijection γ : V → V such that

x, y ∈ E if and only if γ x,γ y ∈ E. A subgroup Ŵ of the automorphism group Aut(G) is said to act transitively on G if, for every pair x, y ∈ V, there exists γ ∈ Ŵ such that γ x = y. We say that Ŵ acts quasi-transitively if V may be partitioned as the ﬁnite union V = mi=1 Vi such that, for every i = 1,2,. . .,m and every pair x, y ∈ Vi, there exists γ ∈ Ŵ such that γ x = y. The graph G is called transitive (respectively, quasi-transitive) if Aut(G) acts transitively (respectively,quasi-transitively). Resultsfortransitivegraphsareusuallyprovable for quasi-transitive graphs also and, for simplicity, we shall usually assume G to be transitive.

For any graph G, the stabilizer S(x) of the vertex x is deﬁned to be the set of automorphisms of G that do not move x,

S(x) = {γ ∈ Aut(G) : γ x = x}.

We write S(x)y for the set of images of y ∈ V under members of S(x),

S(x)y = {γ y : γ ∈ S(x)},

and we call G unimodular9 if |S(x)y| = |S(y)x| whenever x and y belong to the same orbit of Aut(G).

![image 1250](<rcm1-1_images/imageFile1250.png>)

8See Section 4.3 for the basic deﬁnitions associated with the automorphism group Aut(G). 9The terms ‘amenable’ and ‘unimodular’ come from group theory, see [265, 290, 312]. The

assumption of unimodularity is equivalent to requiring that the left and right Haar measures on Aut(G) be the same.

There is a useful class of graphs arising from group theory. Let Ŵ be a ﬁnitely generated group and let S be a symmetric generating set. The associated (right) Cayley graph is the graph G = (V, E) with V = Ŵ and

E = x, y : x, y ∈ Ŵ, xg = y for some g ∈ S .

There are many Cayley graphs of interest to probabilists, including the lattices Ld and the trees Tm. All Cayley graphs are unimodular, see [241, Chapter 7]. One may take Cartesian products of Cayley graphs to obtain further graphs of interest, includingthe well-knownexampleLd ×Tm, which has beenstudied in some depth in the context of percolation, [162].

The graph-property of (non-)amenability ﬁrst became important in probability throughtheworkofKestenonrandomwalks, [205,206]. In[162]itwasshownthat percolation on the non-amenablegraph Ld ×Tm possesses three phases. Pemantle [267] developed a related theory for the contact model on a tree, while Benjamini and Schramm [32] laid down further challenges for non-amenable graphs. There has been a healthy interest since in stochastic models on non-amenable graphs, and a systematic theory has developed. More recent references include [29, 30, 174, 176, 196, 197, 240, 241, 293].

Let G = (V, E) beaninﬁnite, connected,locallyﬁnite, transitivegraph, andlet = {0,1}E. As usual, for F ⊆ E, we write FF for the σ-ﬁeld generated by the

states of edges in F, TF = FE\F, and F for the σ-ﬁeld generated by the ﬁnitedimensional cylinders. The tail σ-ﬁeld is T = F TF where the intersection is over all ﬁnite subsets F of E. A probability measure µ on ( ,F ) is called tail-trivial if µ(A) ∈ {0,1} for all A ∈ T .

The translations of Ld play a special role in considerations of mixing and ergodicity. For graphs G of the above type, this role is played by automorphism subgroups with inﬁnite orbits. Let Ŵ be a subgroup of Aut(G). We say that Ŵ has an inﬁnite orbit if there exists x ∈ V such that the set {γ x : γ ∈ Ŵ} has inﬁnite cardinality. It is easy to see that a group Ŵ of automorphisms has an inﬁnite orbit if and only if every orbit of Ŵ is inﬁnite.

We turn now to random-cluster measures on the graph G = (V, E). Let p ∈ (0,1), and assume for simplicity that q ∈ [1,∞). Let = ( n : n = 1,2,. . .) be an increasing sequence of ﬁnite sets of vertices such that n ↑ V as n → ∞. We concentrate as usual on two extremal random-cluster measures given very much as in Section 10.9, and we specify these informally as follows. Let be a ﬁnite subset of V, and let φ ,p,q be the random-cluster measure on 0 with parameters p, q, as in (4.11) with ξ = 0. By stochastic monotonicity, the limit

φp0,q = lim

φ n,p,q

n→∞

exists, and it is called the ‘free’ random-cluster measure on G. We note as before that the limit measure φp0,q does not depend on the choice of , and that φp0,q is automorphism-invariant.

In deﬁningthe wired measure, we veertowardsthe recipeof Section 10.9rather than the lattice-theoretic (4.11). This amounts in rough terms to the following. Let be a ﬁnite subset of V, and identify the set ∂  as a single vertex. Write φ ,1 p,q for the random-cluster measure with parameters p, q on this new graph, and view φ ,1 p,q as a measure on the inﬁnite measurable pair ( ,F ). As above, the limit

φp1,q = lim

φ1 n,p,q

n→∞

exists and does not depend on the choice of . We call φp1,q the ‘wired’ randomcluster measure on G, and we note that φp1,q is automorphism-invariant.

As pointed out in [240], the method of proof of Theorem 4.19(d) is valid

for general graphs, and implies that the measures φpb,q are tail-trivial. Let Ŵ be a subgroup of Aut(G) with an inﬁnite orbit. By an adaptation of the proof of

Theorem 4.19, the φpb,q are Ŵ-ergodic. Indeed, the φpb,q satisfy the following form of the mixing property. Since Ŵ has an inﬁnite orbit, all its orbits are inﬁnite. For

x ∈ V and y lying in the orbit of x under Ŵ, let γx,y ∈ Ŵ be an automorphism mapping x to y. For x ∈ V and A, B ∈ F ,

φpb,q(A ∩ γx,yB) = φpb,q(A)φpb,q(B), b = 0,1,

(10.100) lim

δ(x,y)→∞

in that, for ǫ > 0, there exists N such that

φpb,q(A ∩ γx,yB) − φpb,q(A)φpb,q(B) < ǫ if δ(x, y) ≥ N, where δ(x, y) denotes the length of the shortest path from x to y.

The measures φpb,q satisfy different ‘one-point speciﬁcations’, namely:

φp0,q(Je | Te) = π + (p − π)1Ke, φp0,q-a.s., φp1,q(Je | Te) = π + (p − π)1K1

e , φp1,q-a.s.,

for e = x, y . Here, as in (10.71), Je is the event that e is open, Te is the σ-ﬁeld generated by states of edges other than e, and π = p/[p+q(1− p)]. In addition,

Ke = {x ↔ y off e}, Ke1 = {x ↔ y off e} ∪ {x ↔ ∞, y ↔ ∞}.

Many questions may be asked about the free and wired measures on a general graph G. We restrict ourselves here to the existence and number I of inﬁnite open clusters. The critical points are deﬁned by

pcb(q) = sup p : φpb,q(I = 0) = 1 , b = 0,1.

By the tail-triviality of the φpb,q,

φpb,q(I = 0) =

1 if p < pcb(q), 0 if p > pcb(q).

We note the elementaryinequality pc1(q) ≤ pc0(q). Itis an openquestionto decide when strict inequality holds here. As in (5.4), we have that pc1(q) = pc0(q) for lattices, and the proof of this may be extended to all amenable graphs, [196]. On the other hand, by Theorem 10.82, pc1(q) < pc0(q) for the regular binary tree T2 when q ∈ (2,∞).

If there exists an inﬁnite open cluster with positive probability, under what further conditions is this cluster almost-surely unique? The property of having a uniqueinﬁnite clusteris notmonotoneinthe conﬁguration: thereexist ω1,ω2 ∈ such that ω1 ≤ ω2 and I(ω1) = 1, I(ω2) ≥ 2. Nevertheless, it turns out that, for transitive unimodular graphs, the set of values of p for which I = 1 is indeed (almost surely) an interval.

The ‘uniqueness critical point’ is given by

pub(q) = inf p : φpb,q(I = 1) = 1 , b = 0,1. and satisﬁes

pcb(q) ≤ pub(q), b = 0,1. Since G is transitive, Aut(G) has an inﬁnite orbit. The event {I = 1} is Aut(G)invariant whence, by the Aut(G)-ergodicity of the φpb,q,

φpb,q(I = 1) = 0, p < pub.

(10.101) Theorem [240]. Let G be an inﬁnite connected locally ﬁnite graph that is transitive and unimodular, and let b ∈ {0,1}. If φpb,q(I = 1) = 1 then φpb′,q(I = 1) = 1 for p′ ≥ p. In particular,

φpb,q(I = 1) = 1, p > pub.

The proof is based upon the following proposition whose proof is omitted from the current work. A probability measure µ on ( ,F ) is called insertion-tolerant if, for all e ∈ E and A ∈ F ,

µ(Ae) > 0 whenever µ(A) > 0,

where Ae is the set of conﬁgurations obtained from members of A by declaring e to be an open edge. Insertion-tolerance is a weak form of ﬁnite-energy, see (3.4). The symbol 0 denotes an arbitary vertex of G called its ‘origin’.

(10.102) Proposition [242]. Let G be an inﬁnite connected locally ﬁnite graph that is transitive and unimodular, and let µ be an Aut(G)-ergodic probability measure on ( ,F ) that is positively associated and insertion-tolerant. Then µ(I = 1) = 1 if and only if

inf

µ(0 ↔ x) > 0.

x∈V

Theorem 10.101 is an immediate consequence, since the φpb,q(0 ↔ x) are non-decreasing in p.

Supposethat G is unimodular. By Theorem10.101and a well knownargument from [261], the free and wired random-cluster measures have (each) three phases: for b = 0,1,

 

0 if p < pcb(q), ∞ if pcb(q) < p < pub(q), 1 if p > pub(q).

φpb,q-a.s.

I =



It is an open problem to obtain necessary and sufﬁcient criteria for the strict inequalities

(10.103) pc1(q) < pu1(q), pc0(q) < pu0(q),

and the reader is referred to [174] for a discussion of this. The Burton–Keane argument, [72, 129], may be adapted to show that equalities hold in (10.103) when G is amenable. On the other hand, the inequalities may be strict, see [174, 240].

It is natural to ask for the value of I when p equals one of the critical values

pcb, pub. The picture is far from complete, and the reader is referred to [29, 30, 33, 167, 174] and Section 10.11 for the current state of knowledge.

## Chapter 11 Graphical Methods for Spin Systems

Summary. Five applications are presented of the random-cluster model to lattice spin-systems, namely the Potts and Ashkin–Teller models, the disordered Potts ferromagnet, the Edwards–Anderson spin-glass model, and the Widom–Rowlinson lattice gas model.

11.1 Random-cluster representations

The interacting systems of lattice statistical mechanics are mostly ‘vertex-models’ in the sense that the conﬁgurations are spin-vectors indexed by the vertices. Such spins may take values in a general state-space, and the nature of the interaction between different vertices is speciﬁed within the Hamiltonian. A substantial technology has been developed for such systems. One of the techniques is to seek a transformation to an ‘edge-model’ that enables the use of geometric arguments in the study of correlations. The standard example of this is the mapping of Section 1.4 linking the Potts model and the random-cluster model. Such arguments are sometimes known as ‘graphical methods’, and some examples are summarized brieﬂy in this chapter.

No attempt is made in this chapter to be encyclopaedic. Instead, we describe ﬁve cases of special interest, namely the Potts and Ashkin–Teller models for a ferromagnet, the disordered Potts model, the Edwards–Anderson model for a spin glass, and the Widom–Rowlinson model for a two-type lattice gas. There is a common theme to these examples. The ﬁrst step in each case is to ﬁnd a corresponding model of random-cluster type, with the property that the original spin system may be obtained by assigning spins to its clusters. It turns out that there exists a unique Gibbs state for the original spin system if and only if the new model has (almost surely) only ﬁnite clusters. The existence or not of an inﬁnite cluster may be studied either directly, or by comparisonwith a known system such as a percolation model.

Accounts of the use of graphical methods for these and other classical models

may be found,forexample,in the work of Alexander[15],Chayesand Machta [93, 94], Graham and Grimmett[142], and in the reviewsof Georgii, Haggstr¨ om, Maes¨ [136], and Haggstr¨ om [169], as¨ well as in the literature listed later in this chapter. The use of random-clustermethodsin quantum spin systems is exempliﬁed in [11, 12, 258].

11.2 The Potts model

The random-cluster model was introduced in part as a means to study the Potts model. No attempt is made here to compress the ensuing theory into a few pages. Instead, we state and prove one theorem concerning a random-cluster analysis of the (non-)uniqueness of Gibbs states for the Potts model.

The Potts model on a ﬁnite graph G = (V, E) has an integer number q ∈ {2,3,. . .} of states and an ‘inverse-temperature’ β ∈ (0,∞). We shall consider the case of zero external-ﬁeld, and we recall the notation of Section 1.3. We write = {1,2,. . .,q}V for the conﬁguration space. For e = x, y ∈ E and σ = (σx : x ∈ V) ∈ , let δe(σ) be deﬁned by the Kronecker delta

1 if σx = σy, 0 otherwise.

δe(σ) = δσx,σy =

The Potts probability measure is deﬁned as

πG,β,q(σ) =

1 ZP

e−βH(σ), σ ∈  ,

![image 1251](<rcm1-1_images/imageFile1251.png>)

where the Hamiltonian H(σ) is given by H(σ) = −

δe(σ),

e= x,y ∈E

and ZP = ZP(G,β,q) is the appropriate normalizing constant.

Consider now the lattice Ld with d ≥ 2. The spin space is the set = {1,2,. . .,q}Zd, and the appropriate σ-ﬁeld G is that generated by the ﬁnitedimensional cylinders of . Let be a ﬁnite box of Ld, which we consider as a graph with edge-set E . For τ ∈ , let τ be the subset of containing all conﬁgurations that agree with τ off \ ∂ . The Potts measure on ‘with boundary condition τ’ is the probability measure on ( ,G) satisfying

(11.1) π ,β,τ q(σ) =

cτ π ,β,q(σ ) if σ ∈ τ , 0 otherwise,

where σ is the partial vector (σx : x ∈  ) comprising spins in , and cτ is the normalizing constant. Of particular interest are the boundary conditions τ ≡ i for

given i ∈ {1,2,. . .,q}, in which case we write π ,β,i q. The symbol U will be used to denote the σ-ﬁeld generated by the spins (σy : y ∈/ \ ∂ ).

(11.2)Deﬁnition. Aprobabilitymeasure π on ( ,G) iscalled a Gibbsstate ofthe q-state Potts model with inverse-temperature β if it satisﬁes the DLR condition:

for all A ∈ G and boxes , π(A | U )(τ) = π ,β,τ q(A) for π-a.e. τ.

The principal question concerning Gibbs states is the following. For which values of the inverse-temperature β does there exist a unique (respectively, a multiplicity of) Gibbs states? It turns out that there is a unique Gibbs state if and only if the corresponding wired random-cluster model possesses (almost surely) no inﬁnite cluster. Prior to the formal statement of this claim, which will be given in a form borrowed from [136, Thm 6.10], the reader is reminded of the weak limits1

π ,β,1 q,

π ,β,q, πβ,1 q = lim

πβ,0 q = lim

↑Zd

↑Zd

given in Theorem 4.91 and the remark immediately following. The measure πβ,0 q is called the ‘free’ Potts measure.

(11.3) Theorem. Let β ∈ (0,∞), q ∈ {2,3,. . .}, and let p = 1 − e−β.

(a) The measures πβ,0 q, πβ,1 q are translation-invariant Gibbs states. (b) [8] The following statements are equivalent:

(i) there exists a unique Gibbs state, (ii) πβ,1 q(σ0 = 1) = q−1,

(iii) the wired random-cluster measure φp1,q satisﬁes φp1,q(0 ↔ ∞) = 0.

We have highlighted the Potts measure πβ,1 q with boundary condition 1. One may construct further measures πβ,i q with boundary condition i ∈ {2,3,. . .,q}. Such measures differ from πβ,1 q only through a re-labelling of the spin values 1,2,. . . ,q.

The main claim of the theorem is that there exists a unique Gibbs state if and

only if φp1,q(0 ↔ ∞) = 0. When φp1,q(0 ↔ ∞) > 0, there exists more than one Gibbs state, but how many? It is easily seen from the theorem that the measures

πβ,i q, i ∈ {1,2,. . .,q}, are then distinct Gibbs states, but do there exist further states? The set of Gibbs states for given β, q is convex, and thus we are asking about the number of extremal Gibbs states. There are three situations to consider. The parameters p and β are related throughout by p = 1 − e−β.

1. Two dimensions (d = 2). It is believed that the πβ,i q are the unique extremal Gibbs states whenever p > pc(q). At the point of a discontinuous phase transition (see Conjecture 6.32), the set of extremal Gibbs states is believed

to be πpi,q for i ∈ {0,1,2,. . . ,q}.

![image 1252](<rcm1-1_images/imageFile1252.png>)

1There is a technical detail here in that π ,β,q is deﬁned on rather than on Zd, but we overlook this.

2. Supercritical phase (d ≥ 3). Suppose p > pc(q). It is believed that the

πβ,i q are the uniqueextremaltranslation-invariantGibbs states. On the other hand, there exist non-translation-invariant Gibbs states (see Theorem 7.89) when β (and hence p) is sufﬁciently large.

3. Critical case (d ≥ 3). Let p = pc(q). By Theorem 11.3, there exists a unique Gibbs state if the phase transition is continuous in the sense that φ1pc,q(0 ↔ ∞) = 0. When q is sufﬁciently large, the transition is discontinuous and there exist exactly q + 1 translation-invariant extremal Gibbs states πβ,i q, i ∈ {0,1,2,. . .,q}, [251]. There is in addition an inﬁnity of non-translation-invariant extremal Gibbs states, [85, 254].

To each vertexof a q-state Potts modelis allocated one of the states 1,2,. . .,q. The so-called‘Pottslattice gas’hasanaugmentedstate space 0,1,2,. . .,q, where the vertices labelled 0 are considered as ‘empty’. The Potts lattice gas may be studied via the so-called ‘asymmetric random-cluster model’, see [15]. A similar augmentation of the state space was introduced for the Ising model by Blume and Capel in a study of ﬁrst-order phase transitions, [50, 79]. This gives rise to a ‘Blume–Capel–Potts model’ which may be studied via a random-cluster representation, see [142].

Proof of Theorem 11.3. (a) The existence of the measures is proved in Theorem 4.91 and the comments immediately thereafter. Their translation-invariance follows from the translation-invariance of φpb,q for b = 0,1, see Theorem 4.19(b), on following the recipes of Section 4.6.

We prove next that πβ,1 q is a Gibbs state, and the same proof is valid for πβ,0 q. For boxes , satisfying ⊆ , let V \ denote the σ-ﬁeld generated by the states of vertices in \ (  \ ∂ ). Let A ∈ G. By the martingale convergence theorem (see [164, Ex. 12.3.9]),

πβ,1 q(A | V \ ), πβ,1 q-a.s. By weak convergence, Theorem 4.91,

πβ,1 q(A | U ) = lim

↑Zd

π1 ′,β,q(A | V \ ),

πβ,1 q(A | V \ ) = lim

′↑Zd

and it is a simple calculation based on the deﬁnition of the ﬁnite-volume Potts measures that

π1 ′,β,q(A | V \ )(τ) = π ,β,τ q(A). Combining the last three equations, we ﬁnd as required that

πβ,1 q(A | U )(τ) = π ,β,τ q(A), πβ,1 q-a.s. (b) We prove ﬁrst that (i) implies (ii). Assume that (i) holds, so that, in particular, πβ,1 q = πβ,i q for i = 2,3,. . .,q. Then,

πβ,1 q(σ0 = 1) = πβ,j q(σ0 = j)

= πβ,1 q(σ0 = j), j = 1,2,. . .,q.

However,

q

πβ,1 q(σ0 = j) = 1,

j=1

and (ii) follows. By Theorem 1.16 applied to with the wired boundary condition,

1 q = (1 − q−1)φ ,1 p,q(0 ↔ ∞).

π ,β,1 q(σ0 = 1) −

![image 1253](<rcm1-1_images/imageFile1253.png>)

Let ↑ Zd and deduce by Theorems 4.91 and 5.11 that

1 q = (1 − q−1)φp1,q(0 ↔ ∞).

πβ,1 q(σ0 = 1) −

![image 1254](<rcm1-1_images/imageFile1254.png>)

Therefore, (ii) and (iii) are equivalent.

Finally, we prove that (iii) implies (i). Assume (iii), and let π be a Gibbs state for the Potts model with parameters β, q. Let A ∈ G be a cylinder event, and let πβ,0 q denote the Potts measure on Ld with the free boundary condition. We claim that

(11.4) π(A) = πβ,0 q(A), which implies (i) since the cylinder events generate G. Let ǫ > 0. We shall prove that (11.5) π ,β,τ q(A) − πβ,0 q(A) < ǫ, for some box and all τ ∈ . Equation (11.4) follows by (π-)averagingover τ and appealing to Deﬁnition 11.2.

We concentrate for the moment on the measure π ,β,τ q. We may couple this measure with a certain random-cluster-type measure in the same manner as described in Section 1.4 for the free measures. For ω ∈ = {0,1}E , let kτ(ω) be the number of open clusters in the graph obtained from ( ,E ) by identifying each of the sets Vi = {x ∈ ∂  : τx = i}, i = 1,2,. . .,q, as a single vertex. Let φ be the random-cluster measure on with the usual cluster-count k(ω) replaced by kτ(ω). Finally, let φ ,τ p,q denote2 φ conditioned on the event

![image 1255](<rcm1-1_images/imageFile1255.png>)

![image 1256](<rcm1-1_images/imageFile1256.png>)

(11.6) Dτ = ω ∈ : Vi ↔/ Vj in , for all distinct i, j ∈ {1,2,. . .,q} .

It is left as an exercise to prove that π ,β,τ q is the law of the spin-vector obtained as follows. If x ∈/ \∂ , assign spin τx to x. For vertices in \∂ , ﬁrst sample ω ∈ according to φ ,τ p,q, and then assign uniformly distributed random spins

![image 1257](<rcm1-1_images/imageFile1257.png>)

2Since kτ (ω) differs from k1(ω) by a constant (depending on τ), we could take φ ,τ p,q to be the wired measure φ ,1 p,q conditioned on Dτ.

to each open cluster of ω subject to the constraint: if x ↔ Vi, then x is assigned spin i.

By positive association, (11.7) φ ,τ p,q ≤st φ ,1 p,q where the latter measure is to be interpreted as its projection onto {0,1}E .

We return to the cylinder event A, and we let ǫ > 0. By the remark after Theorem 4.91, π ,β,0 q ⇒ πβ,0 q as ↑ Zd, and thus we may ﬁnd a box B such that

(11.8) πγ,β,0 q(A) − πβ,0 q(A) < ǫ for all γ ⊇ B.

Let ′ be a box sufﬁciently large that: B ⊆ ′, and A is deﬁned in terms of the vertex-spins within ′. By (iii), we may choose a box such that ′ ⊆ and

(11.9) φp1,q( ′ ↔ ∂ ) < ǫ.

Since φ ,1 p,q ⇒ φp1,q as ↑ Zd, we may ﬁnd a box such that ⊆ and

(11.10) φ ,1 p,q( ′ ↔ ∂ ) < 2ǫ. Let τ ∈ . By (11.7) and (11.10), (11.11) φ ,τ p,q( ′ ↔ ∂ ) < 2ǫ, τ ∈  .

On the event {ω ∈ : ′ ↔/ ∂ }, there exists a connected subgraph Ŵ of \∂ , containing ′ andwithclosedexternaledge-boundary e . LetŴ bethemaximal graph with this property, and let H be the set of all possible outcomes of Ŵ. For γ ∈ H, the event {Ŵ = γ} is measurable on the σ-ﬁeld generated by the states of edges notbelongingto γ. (Thereis a similar step in the proofof Proposition5.30.) The marginal measure on γ of φ ,τ p,q(· | Ŵ = γ) is therefore the free measure φγ,0 p,q and hence, by coupling,

π ,β,τ q(A) −

γ∈H

πγ,β,0 q(A)φ ,τ p,q(Ŵ = γ) ≤ φ ,τ p,q( ′ ↔ ∂ ).

By (11.8) and (11.11),

π ,β,τ q(A) − πβ,0 q(A) < 5ǫ, whence (11.5) holds with an adjusted value of ǫ, and (i) is proved.

11.3 The Ashkin–Teller model

Each vertex may be in either of two states of the Ising model. The Potts modelwas proposed in 1952, and allows a general number q of local states. Nearly ten years earlier, Ashkin and Teller [21] proposed a 4-state model which, with hindsight, may be viewed as an interpolation between the Ising model and the 4-state Potts model. Their model amounts to the following.

Let G = (V, E) be a ﬁnite graph. The set of local spin-values is taken to be {A, B,C, D}, so that the conﬁguration space is = {A, B,C, D}V. Let J1, J2 be edge-interactions satisfying 0 ≤ J1 ≤ J2, and let β ∈ (0,∞). The spins at the endvertices x and y of the edge e = x, y interact according to a function δ given as follows:

δ(A, B) = δ(C, D) = J1, δ(A,C) = δ(A, D) = δ(B,C) = δ(B, D) = J2.

There is symmetry within the pair {A, B} and within the pair {C, D}, but asymmetry between the pairs. The Ashkin–Tellermeasure on G is the probabilitymeasure given by

1 ZAT

e−βH(σ), σ ∈  ,

αG,β(σ) =

![image 1258](<rcm1-1_images/imageFile1258.png>)

where ZAT is the appropriate normalizing constant and

H(σ) =

δ(σx,σy), σ ∈  .

e= x,y : σx =σy

Neighbouring pairs prefer to have the same spin, failing which they prefer to have spins in one of the sets {A, B}, {C, D}, and failing that either of the spins in the other pair. When J1 = 0, the Ashkin–Teller model is equivalent to the Ising model. When J1 = J2, it is equivalent to the 4-state Potts model.

Consider the lattice Ld with d ≥ 2. The spin space is = {A, B,C, D}Zd, and G denotes the σ-ﬁeld of generated by the cylinder events. In order to deﬁneAshkin–Tellermeasuresontheinﬁnite lattice, wefollowthestandardrecipe outlined in the last section around Deﬁnition 11.2. For τ ∈ and a box , one may deﬁne an Ashkin–Teller measure α ,βτ on with boundary condition τ. A probabilitymeasure α on( ,G) is called a Gibbsstate of the Ashkin–Tellermodel with inverse-temperature β if, for any box , the conditional measure on , given the conﬁguration τ off \ ∂ , is α ,βτ .

For what values of β does there exist a unique Gibbs state?

(11.12) Theorem [271]. Consider the Ashkin–Teller model on Ld with d ≥ 2 and 0 < J1 < J2. There exist β1, β2 satisfying 0 < β1 ≤ β2 < ∞ such that the following hold.

(a) There is a unique Gibbs state if β < β1. (b) If β ∈ (β1,β2), there is a multiplicity of Gibbs states each of which is

invariant under the re-labellings A ↔ B and C ↔ D.

(c) If β > β2 then, for each s ∈ {A, B,C, D}, there exists a Gibbs state in which the local state s dominates. That is, for each s there exists a Gibbs state α such that

α(σx = s) > 41, α(σx = t) < 14, x ∈ Zd, t ∈ {A, B,C, D} \ {s}. Furthermore, β1 < β2 if J2/J1 is sufﬁciently large.

![image 1259](<rcm1-1_images/imageFile1259.png>)

![image 1260](<rcm1-1_images/imageFile1260.png>)

It is an open question to decide whether β1 < β2 whenever J1 < J2. Perhaps the answer depends on the choice of lattice.

Theorem 11.12 may be found in [271], and it is proved here via a randomcluster representation following the treatment in [169]. Further results for the Ashkin–Teller model and its random-cluster representation may be found in [93, 273, 289, 321].

The relevant graphical method makes uses the following edge-model. Let G = (V, E) be a ﬁnite graph as before, and take as conﬁguration space the set

= {0,1,2}E. For ω ∈ and i ∈ {0,1,2}, we write ηi(ω) for the set of edges e with ω(e) = i. Let p = (p0, p1, p2) be a vector of non-negativereals with sum 1. The Ashkin–Teller random-cluster measure on G is the probability measure φG,p on given by

1 ZATRC

p0|η0|p1|η1| p2|η2|2k(η1∪η2)+k(η2), ω ∈  ,

φG,p(ω) =

![image 1261](<rcm1-1_images/imageFile1261.png>)

where ηi = ηi(ω) and ZATRC is the appropriate normalizing constant.

Suppose that β ∈ (0,∞), 0 < J1 ≤ J2, and let p = (p1, p1, p2) satisfy (11.13) p0 = e−βJ2, p1 = e−βJ1 − e−βJ2, p2 = 1 − e−βJ1.

We describe next how to couple αG,β and φG,p. Let ω have law φG,p. For each clusterC12 ofthegraph (V,η1(ω)∪η2(ω)), weﬂipafaircointodeterminewhether the spins in C12 are drawn from the pair {A, B} or from the pair {C, D}. Having done this for each C12, we consider the clusters of the graph (V,η2(ω)). For each such cluster C2, we ﬂip a fair coin to determine which of the two possibilities will be allocated to the vertices of C2. Thus, for example, if C2 ⊆ C12 and vertices in C12 aretoreceivespinsfromthepair {A, B},theneithereveryvertexin C2receives spin A, or every vertex receives spin B, each such possibility having (conditional)

probability 21. This recipe results in a random spin-vector σ ∈ {A, B,C, D}V, and it is left as an exercise to check that σ has law αG,β.

![image 1262](<rcm1-1_images/imageFile1262.png>)

The key question in deciding the multiplicity of Gibbs states is whether a weak limit of the φ ,p may possess an inﬁnite cluster of edges each of which has either state 1 or state 2 (respectively, each of which has state 2). We begin the proof of Theorem 11.12 with a lemma. The conﬁguration space = {0,1,2}E may be viewed as a partially ordered set. For probability measures µ1, µ2 on , we write µ1 ≤st µ2 if µ1( f ) ≤ µ2( f ) for all non-decreasing functions f : → R. See Section 2.1.

(11.14)Lemma. Suppose 0 < J1 ≤ J2. Let β ∈ (0,∞), and let p = p(β) satisfy (11.13). The probability measures β = φG,p(β) satisfy (11.15) β1 ≤st β2, 0 < β ≤ β2 < ∞.

Proof. Each β is a probability measure on the partially ordered set . By Theorems 2.1 and 2.33, inequality (11.15) holds if, for v = 1,2 and every e ∈ E,

πβ,e(v,ξ) = β ω(e) ≥ v ω( f ) = ξ( f ) for all f ∈ E \ {e} is increasing (that is, non-decreasing) in β ∈ (0,∞) and ξ ∈ .

For e ∈ E and ξ ∈ , let κ2(e,ξ) (respectively, κ12(e,ξ)) be the number of clusters of the graph (V,η2(ξ) \ {e}) (respectively, (V,η1(ξ) ∪ η2(ξ) \ {e})) that intersect the endvertices of e. It is an easy calculation that

 

p2 γ0p0 + γ1 p1 + p2

if v = 2,

![image 1263](<rcm1-1_images/imageFile1263.png>)

(11.16) πβ,e(v,ξ) =

γ0 p0 γ0p0 + γ1 p1 + p2



1 −

if v = 1,

![image 1264](<rcm1-1_images/imageFile1264.png>)

where (11.17) γ0 = 2κ12(e,ξ)+κ2(e,ξ)−2, γ1 = 2κ12(e,ξ)−1. Note that (11.18) γ0 ≥ γ1 ≥ 1, and, in addition, γ0, γ1, γ0/γ1, and γ0 − γ1 are decreasing functions of ξ.

Now,

1 (11.19) p2 − 1 , γ0 p0 + γ1p1 + p2 γ0 p0 = 1 +

γ0 p0 + γ1p1 + p2 p2 = 1 + (γ0 − γ1)

p0 p2 + γ1

![image 1265](<rcm1-1_images/imageFile1265.png>)

![image 1266](<rcm1-1_images/imageFile1266.png>)

![image 1267](<rcm1-1_images/imageFile1267.png>)

1 γ0 ·

p1 p0 +

p2 p0

γ1 γ0 ·

(11.20) .

![image 1268](<rcm1-1_images/imageFile1268.png>)

![image 1269](<rcm1-1_images/imageFile1269.png>)

![image 1270](<rcm1-1_images/imageFile1270.png>)

![image 1271](<rcm1-1_images/imageFile1271.png>)

![image 1272](<rcm1-1_images/imageFile1272.png>)

![image 1273](<rcm1-1_images/imageFile1273.png>)

3These were proved for the case = {0, 1}E, but similar results are valid in the more general setting when = T E and T is a ﬁnite subset of R. See, for example, [136, Section 4].

It is easily checked from (11.13) that p0, p0/p1, and 1/p2 are decreasing in β. By (11.18), (11.19) is decreasing in β. By the remark after (11.18), (11.19) is decreasing in ξ, and therefore πβ,e(2,ξ) is increasing in β and ξ as required.

Similarly, (11.20) is increasing in β and ξ, and therefore so is πβ,e(1,ξ) in (11.16). We conclude that each πβ,e(v,ξ) is increasing in β and ξ, and (11.15) follows.

Sketch proof of Theorem 11.12. We follow [169]. For ω ∈ {0,1,2}E, a cluster of type 1/2 (respectively, type 2) is a cluster formed by the edges e with ω(e) ∈ {1,2} (respectively, ω(e) = 2). As in the Potts case of the previous section, there is a unique Gibbs state if and only if every weak limit, as ↑ Zd, of φ ,p possesses (almost surely) no inﬁnite cluster of type 1/2. By Lemma 11.14, the last statement about the φ ,p is a decreasing property of β: if it holds when β = β′ then it holds for β ≤ β′. Therefore, there exists a critical value β1 such that there exists a unique (respectively, multiplicity) of Gibbs states when β < β1 (respectively, β > β1).

By (11.16)–(11.17),

πβ,e(1,ξ) ≤ 2p1 + p2 = p∗(β), ξ ∈  , e ∈ E, where

p∗(β) = 2(e−βJ1 − e−βJ2) + 1 − e−βJ1. By Theorems 2.1 and 2.3, the law of the set of edges of type 1/2 in G is dominated by a product measure with density p∗(β). When p∗(β) < pcbond(Ld), no weak limit of φ ,p may possess an inﬁnite cluster of type 1/2. Here, pcbond(Ld) denotes the critical probability of bond percolation on Ld. We deduce that β1 > 0.

Thesame argumentmaybeappliedto theexistence(ornot)of aninﬁnitecluster of type 2. Once again, there exists a critical value β2 marking the onset of the existence of such a cluster, and it is elementary that β1 ≤ β2. By (11.16)–(11.17),

πβ,e(2,ξ) ≥ 14 p2, ξ ∈  , e ∈ E, implyingasabovethat,whenβ islarge,everyweaklimitof φ ,p possesses(almost surely) an inﬁnite cluster of type 2. Therefore, β2 < ∞. Statement (c) is easily seen to follow and, in addition, statement (b) when β1 < β2.

![image 1274](<rcm1-1_images/imageFile1274.png>)

By (11.16),

πβ,e(1,ξ) ≥ 1 − 4p0 = 1 − 4e−βJ2, πβ,e(2,ξ) ≤ p2 = 1 − e−βJ1.

Suppose there exists a non-empty interval I of values of β such that (11.21) 1 − e−βJ1 < pcbond(Ld) < 1 − 4e−βJ2.

If β ∈ I, the edgesof type 1/2 dominate a supercriticalproductmeasure, and those oftype2aredominatedbyasubcriticalproductmeasure. Therefore,β1 ≤ β ≤ β2, and hence I is a sub-interval of [β1,β2], implying that β1 < β2. We may indeed ﬁnd such an interval I if J2/J1 is sufﬁciently large.

11.4 The disordered Potts ferromagnet

All our models have been assumed so far to be homogeneous in the sense that their edge-parameters have been assumed equal. In a ‘disordered’ system, one begins instead with a general family of edge-parameters indexed by the edge-set E. It is potentially a major complication that the ensuing measures may not be automorphism-invariant, and one may not apply techniques such as the ergodic theorem. A degree of statistical homogeneity may be re-introduced by assuming that the edge-parametersare chosen according to some given translation-invariant random ﬁeld. We restrict ourselves for simplicity here to the situation in which this random ﬁeld is a product measure with a given marginal distribution.

The disordered Potts model on a ﬁnite graph G = (V, E) is given as follows. One begins with a family J = (Je : e ∈ E) of ‘random interactions’4. These are independent, identically distributed random variables taking values in the halfopen interval [0,∞) according to a given law ν. Let β ∈ (0,∞) and q ∈ {2,3,. . .}. The correspondingPotts (random)measure on the conﬁgurationspace

= {1,2,. . .,q}V is

1 ZJ

e−βH(σ), σ ∈  ,

(11.22) πJ,q(σ) =

![image 1275](<rcm1-1_images/imageFile1275.png>)

where ZJ is the appropriate (random) normalizing constant and H(σ) = −

Jeδe(σ), δe(σ) = δσx,σy.

e= x,y ∈E

Such a model is ferromagnetic in that the Je are non-negative random variables. The non-ferromagnetic case is much harder, and the reader is referred to Section 11.5 for some partial results of random-cluster type.

The ‘disordered random-cluster model’ is deﬁned similarly on G = (V, E). Let q ∈ (0,∞), and let p = (pe : e ∈ E) be a family of independent, identically distributed random variables chosen from the interval [0,1]. The corresponding random-cluster (random) measure φp,q on = {0,1}E is given as usual by

1 Zp e∈E

peω(e)(1 − pe)1−ω(e) qk(ω), ω ∈  ,

(11.23) φp,q(ω) =

![image 1276](<rcm1-1_images/imageFile1276.png>)

where Zp is the appropriate (random) normalizing constant.

With q, β, and the Je as above, let (11.24) pe = 1 − e−βJe, e ∈ E. The measures φp,q and πJ,q may be coupled as in Section 1.4. As in Theorem 1.16,

1 q = (1 − q−1)φp,q(x ↔ y), x, y ∈ V.

(11.25) πJ,q(σx = σy) −

![image 1277](<rcm1-1_images/imageFile1277.png>)

![image 1278](<rcm1-1_images/imageFile1278.png>)

4Disordered systems were introduced in [143], and early papers include [132, 133].

[11.4] The disordered Potts ferromagnet 331

Consider the lattice Ld with d ≥ 2. In developing the theory of disordered random-cluster measures on Ld, one needs to take care to avoid the use of spatial homogeneity. It turns out that quite a lot of the theory of Chapters 1–4 remains valid in this setting, including the comparison inequalities. When working on a ﬁnite box of the lattice Ld with q ∈ [1,∞), one may therefore pass to the inﬁnite-volume limit as ↑ Zd, as in Section 4.3. Without more ado, we shall use the notation introduced earlier, including that of the inﬁnite-volume randomcluster measures φp0,q, φp1,q.

The disordered Potts model has a random set of Gibbs states, and we seek a condition under which this set comprises (almost surely) a singleton only. As in the previous sections, for given βJ, there is a unique Gibbs state if and only if the corresponding wired random-cluster measure possesses no inﬁnite cluster.

Let I = {ω ∈ : ω possesses an inﬁnite cluster} and consider the probability

φp1,q(I), viewed as a function of β. By the comparison inequalities, φp1,q(I) is non-decreasing in β, and we deﬁne the critical point βc(J) by

βc(J) = sup β > 0 : φp1,q(I) = 0 ,

noting that βc(J) is a random variable. The random variable φp1,q(I) is invariant under lattice-translations, and the invariant σ-ﬁeld of the pe is trivial, whence φp1,q(I) ∈ {0,1}. Therefore, there exists a constant βc ∈ [0,∞] such that

0 if β < βc, 1 if β > βc,

P(βc(J) = βc) = 1, φp1,q(I) =

where P denotes the product measure with marginals ν on the space [0,∞)Ed. A pivotal role is played by the atom of ν at 0,

ν(0) = P(Je = 0).

By (11.24), P(Je = 0) = P(pe = 0). By the comparison inequality (3.22), φp1,q(I) = 0, (P-almost-surely), if 1 − ν(0) < pcbond(Ld). Therefore,

(11.26) βc = ∞ if ν(0) > 1 − pcbond(Ld). The situation is more interesting when ν(0) < 1 − pcbond(Ld). (11.27) Theorem [7]. Let d ≥ 2, and consider the disordered Potts model on Ld with edge-interaction law ν.

(a) If ν(0) > 1 − pcbond(Ld), then βc = ∞. (b) If ν(0) < 1 − pcbond(Ld), there exists βc = βc(ν) ∈ (0,∞) such that: there

exists (P-almost-surely) a unique Gibbs state if β < βc, and (P-almostsurely) a multiplicity of Gibbs states if β > βc.

The literature on disordered Potts models is substantial, see for example [7, 155] and the bibliographiesof [136, Section 9], [169, 259, 260]. Lower and upper bounds for βc may be found at (11.28)–(11.29).

Proof. Part (a) was proved at (11.26). Suppose that ν(0) < 1 − pcbond(Ld). By the earlier remarks, it sufﬁces to prove that 0 < βc < ∞. By the comparison inequality (3.22),

φp1,q(I) ≤ φp(I)

where φp is the product measure on in which edge e is open with probability pe. Therefore,

P[φp1,q(I)] ≤ P[φp(I)] = φP(p)(I), since the average of a product measure is a product measure. Now,

P(pe) = P(1 − e−βJe) → 0 as β ↓ 0, by monotone convergence. Therefore,

(11.28) βc ≥ sup β > 0 : P(1 − e−βJe) < pcbond(Ld) > 0.

We turn to the upper bound for βc. By the other comparison inequality (3.23),

φp1,q(I) ≥ φp′(I) where φp′ is the product measure on in which edge e is open with probability

1 − e−βJe 1 + (q − 1)e−βJe

pe pe + q(1 − pe) =

pe′ =

.

![image 1279](<rcm1-1_images/imageFile1279.png>)

![image 1280](<rcm1-1_images/imageFile1280.png>)

By monotone convergence,

P(pe′) → 1 − ν(0) as β → ∞,

and 1 − ν(0) > pcbond(Ld), by assumption. Arguing as above,

1 − e−βJe 1 + (q − 1)e−βJe

> pcbond(Ld) < ∞,

(11.29) βc ≤ inf β > 0 : P

![image 1281](<rcm1-1_images/imageFile1281.png>)

and the theorem is proved.

11.5 The Edwards–Anderson spin-glass model

The Ising/Potts models with positive edge-interactions Je are termed ‘ferromagnetic’: like spins attract one another, unlike spins repel. The corresponding edgevariables pe = 1 − e−βJe satisfy pe ∈ [0,1), and the random-cluster model is a satisfactory tool for the analysis of the correlation structure. Conversely, when the Je can be of either sign, the model is non-ferromagnetic, and the analysis is relatively difﬁcult and incomplete5. The random-clustermodel plays a role in this situation also, as described in this section in the context of an Ising model with real-valued edge-interactions.

In the last section, the Je were allowed to be random variables taking values in the half-line [0,∞). A model which is especially interesting and relatively poorly understood is the so-called ‘Edwards–Anderson spin-glass model’, [109], in which the Je are independent, identically distributed random variables taking values in R with a symmetric distribution (that is, Je and −Je have the same law). Two natural distributions for the Je are the normal distribution, and the symmetric distribution on the two-point space {−1,1}. There are several beautiful open problems concerning the Edwards–Anderson model. We refer the reader to [260] for an account of the theory, and to [262, 263] for recent results and speculations.

Let G = (V, E) be a ﬁnite graph, and write = {−1,1}V and = {0,1}E for the associated vertex- and edge-conﬁguration spaces6. Let J = (Je : e ∈ E) be a given vector of reals, which may be negative or positive. We shall be interested in the Ising7 measure πβJ = πG,βJ given by

1 ZI

(11.30) e−βH(σ), σ ∈  , H(σ) = −

πβJ(σ) =

![image 1282](<rcm1-1_images/imageFile1282.png>)

1 (11.31) 2 Jeσxσy. The inverse-temperature β ∈ (0,∞) is regarded as the parameter to be varied.

![image 1283](<rcm1-1_images/imageFile1283.png>)

e= x,y ∈E

When Je > 0 (respectively, Je < 0), the spins at the endvertices of the edge e prefer to be equal (respectively, opposite). The usual stochastic orderings of the measures are invalid when some of the Je are negative, and the consequent theory is substantially less developed than that of the ferromagnetic case. This notwithstanding, the measure πβJ may be coupled as follows with a randomcluster-type measure on with edge-parameters (pe : e ∈ E) given by

(11.32) pe = 1 − e−β|Je|, e ∈ E. Let P be the product measure on × given by

φe ,

φx ×

P =

e∈E

x∈V

![image 1284](<rcm1-1_images/imageFile1284.png>)

5See Kasteleyn’s remark about the anti-ferromagnet in Paragraph 12 of the Appendix. 6We take the vertex-spins to be −1 and 1 in order to highlight a symmetry. 7The term ‘Ising’ is normally used in the ferromagnetic case only, but we choose to retain it

in this disordered model.

where

φx(σx = −1) = φx(σx = 1) = 21, x ∈ V,

![image 1285](<rcm1-1_images/imageFile1285.png>)

φe(ω(e) = 1) = 1 − φe(ω(e) = 0) = pe, e ∈ E. Let W = WG ⊆ × be the (non-empty) event (11.33) W = (σ,ω) : Jeσxσy > 0 for all e = x, y with ω(e) = 1 .

That is, W is the set of pairs (σ,ω) ∈ × such that the spins at the endvertices of every open edge e have the same sign (respectively, opposite signs) if Je > 0 (respectively, Je < 0). We now deﬁne the probability measure µ to be P conditioned on W,

(11.34) µ(σ,ω) =

1 P(W)

µ(σ,ω)1W(σ,ω), (σ,ω) ∈ ×  .

![image 1286](<rcm1-1_images/imageFile1286.png>)

Let U = UG ⊆ be the event (11.35) U = ω ∈ : there exists σ ∈ with (σ,ω) ∈ W .

A conﬁguration ω ∈ is called frustrated if ω ∈/ U. It is left as an exercise8 to show that the marginal measure on of µ is the Ising measure (11.30), and the marginal measure on is the random-cluster measure with parameters p = (pe : e ∈ E), q = 2, conditioned on the event U. We write this as

µ(σ) = πβJ(σ), σ ∈  , µ(ω) = φp(ω), ω ∈  ,

(11.36)

![image 1287](<rcm1-1_images/imageFile1287.png>)

where

(11.37) φp(ω) = φG,p(ω) =

![image 1288](<rcm1-1_images/imageFile1288.png>)

![image 1289](<rcm1-1_images/imageFile1289.png>)

1 Z

φp,2(ω)1U(ω), Z =

![image 1290](<rcm1-1_images/imageFile1290.png>)

φp,2(ω).

ω∈U

The conditional measure on of µ is determined as follows, the derivation is

omitted. First, we sample ω ∈ according to the relevant marginal φp. Given ω, the (conditional) law of the random spin σ has as support the set

![image 1291](<rcm1-1_images/imageFile1291.png>)

S(ω) = σ ∈ : (σ,ω) ∈ W ,

which is non-empty since ω ∈ U (µ-almost-surely). Let C be an open cluster of ω, and let x, y be distinct vertices in C. Let ρ be an open path from x to y. Since every edge e of ρ is open, it must be the case that pe > 0, and therefore Je  = 0.

![image 1292](<rcm1-1_images/imageFile1292.png>)

8This coupling may be found in [129] and the present account draws on [259, 260]. The ﬁrst use of a random-cluster representation in this context appears to be in [202].

Let σ ∈ S(ω). By (11.33), σy = ηx,yσx where ηx,y is the product of the signs of the Je for e ∈ ρ. Thus, the relative signs of the spins on C are determined by knowledge of ω. Since there are two possible choices for the spin at any given x, there are two choices for the spin-conﬁguration on C, and we choose between these according to the ﬂip of a fair coin. In summary, we assign spins randomly to V in such a way that: the spins within a cluster satisfy σy = ηx,yσx as above, and the spins of different clusters are independent.

Let ω ∈ . We extend the deﬁnition of ηx,y by setting ηx,y = 0 if x ↔/ y, and we arrive at a proposition which may be viewed as a generalization of Theorem 1.16 to situations in which q = 2 and the Je may be of either sign.

(11.38) Proposition [259]. For any ﬁnite graph G = (V, E),

πβJ(σxσy) = φp(ηx,y), x, y ∈ V.

![image 1293](<rcm1-1_images/imageFile1293.png>)

When Je ≥ 0 forall e ∈ E, thenηx,y = 1{x↔y}, and the conclusionof Theorem 1.16 is retrieved.

We pass now to the inﬁnite-volume limit. Let d ≥ 2, let be a ﬁnite box of Ld, and write = {0,1}E . For τ ∈ , let τ be given as in Section 11.2. We may construct a measure µτ on τ × by adapting the deﬁnition of µ given above. The reference product measure P is given similarly but subject to σx = τx for x ∈ ∂ , and µτ is obtained by conditioning P on the event W = W . The marginal of µτ on τ is an Ising measure with boundary condition τ.

A (EA-)Gibbs state for the Edwards–Anderson model on Ld is deﬁned to be a probability measure π on = {−1,1}Zd satisfying the DLR condition as in Deﬁnition 11.2. The principal problem is to determine, for a given vector J = (Je : e ∈ Ed), the set of values of β for which there exists a unique Gibbs state. Only a limited amount is known about this problem. One of the main difﬁculties is that correlations are not generally monotonic in β, and thus we know no satisfactory deﬁnition of a critical value of β. Nevertheless, for given J we may deﬁne (11.39)

βc(J) = sup β : there is a unique Gibbs state at inverse-temperature β . The following is proved as an application of the random-cluster method.

(11.40) Theorem [259]. Consider the Ising model on Ld with real-valued edgeinteractions J = (Je : e ∈ Ed) and inverse-temperature β. We have that βc(J) ≥ βc(|J|), where the latter is the critical inverse-temperature for the ferromagnetic Ising model with edge-interactions |J| = (|Je| : e ∈ Ed).

Itisanimportantopenproblemtodecidewhetherornotthere isnon-uniqueness of Gibbs states on Ld for large β, [260]. There has been a considerable amount of discussion of and speculation around this question, for an account of which the reader is referred to the work of Newman and Stein [262, 263].

Weconsiderbrieﬂythespecialcaseinwhichthe Jehavethesymmetricdistribution on the two-point space {−1,1}. The quantity βc(J) is a translation-invariant function of a family of independent random variables. Therefore, there exists

a real number βcEA such that P(βc(J) = βcEA) = 1. The theorem implies the uniqueness of Gibbs states for every possible value of the vector J, whenever

0 < β < βc(1) with βc(1) the critical inverse-temperature for the ferromagnetic Ising model with constant edge-interaction 1. The weak inequality βcEA ≥ βc(1) may be strengthened to strict inequality for this case, [100].

Proof of Theorem 11.40. We begin with a discussion of boundary conditions. Let J = (Je : e ∈ Ed) be given, and β ∈ (0,∞). For τ ∈ and a box , write π ,βτ J for the corresponding Ising measure on with boundary condition τ, as in (11.1). Let A be a cylinder event of , and suppose β is such that,

(11.41) for all τ,τ′ ∈ , π ,βτ J(A) − π ,βτ′ J(A) → 0 as ↑ Zd.

Let π, π′ be Gibbs states at inverse-temperature β. We may sample τ according to π, and τ′ according to π′, thereby obtaining from (11.41) and the deﬁnition of a Gibbs state (as in, for example, Deﬁnition 11.2), that π(A) = π′(A). Since the cylinder events generate the requisite σ-ﬁeld of , we deduce that π = π′. It will therefore sufﬁce to prove (11.41) under the assumption that β < βc(|J|), and this will be achieved via a transformation to the random-cluster model.

We construct next the random-clustermeasure on correspondingto the Ising

measure π ,βτ J, and we remind the reader of the ferromagneticcase around(11.6). Let = {0,1}E and

(11.42) Uτ = ω ∈ : there exists σ ∈ τ such that (σ,ω) ∈ Wτ , where Wτ ⊆ τ × is given by (11.43) Wτ = (σ,ω) : Jeσxσy > 0 for all e = x, y ∈ E with ω(e) = 1 .

Let p = (pe : e ∈ Ed) satisfy (11.32). As in Section 11.2 (see the footnote on page 324), we let φ ,τ p be the wired random-cluster measure φ ,1 p,2 conditioned on the event Uτ .

The event Uτ is a decreasing subset of , so that, by positive association,

(11.44) φ ,τ p ≤st φ ,1 p,2. There is a close link between stochastic inequalities and couplings. For ω ∈

, let S(ω) = {x ∈ : x ↔ ∂ }, and G = \ S(ω). We claim that there exists a probability measure κ on × such that:

(i) the ﬁrst marginal is φ ,τ p, and the second marginal is φ ,1 p,2, (ii) the support of κ is the set of pairs (ω0,ω1) satisfying ω0 ≤ ω1,

(iii) for any suitable g, conditional on the event {G(ω1) = g}, the marginal law of {ω0(e) : e ∈ Eg} is the free measure φg,p.

![image 1294](<rcm1-1_images/imageFile1294.png>)

The full proof of this step is omitted, and the reader is referred to [259] and to the closely related proof of Proposition 5.30. The idea is to sample the states ω0(e), ω1(e) of edges recursively, beginning with edges e incident to ∂ . At each stage, one checks the stochastic domination (conditional on the past history of the construction) that is necessary to continue the pointwise ordering.

Let , be boxes such that: A is deﬁned in terms of the spins within , and ⊆ . Let S, G, and κ be given as above. If ω1 ∈ { ↔ / ∂ }, then G(ω1) ⊇ , and we write H for the set of possible values of G on this event. Using the coupling of the Ising and random-cluster measures, together with the remarks above, it follows by conditioning on the event { ↔ / ∂ } that

φ ,1 p,2(G = g)πg,βJ(A) + φ ,1 p,2(  ↔ ∂ )mτ ,

π ,βτ J(A) =

g∈H

for some mτ satisfying 0 ≤ mτ ≤ 1. Similarly,

φ ,1 p,2(G = g)πg,βJ(A) + φ ,1 p,2(  ↔ ∂ )mτ′ .

π ,βτ′ J(A) =

g∈H

By subtraction, (11.45) π ,βτ J(A) − π ,βτ′ J(A) ≤ φ ,1 p,2(  ↔ ∂ ). For β < βc(|J|), the right side of (11.45) approaches 0 as ↑ Zd, and (11.41) follows as required.

11.6 The Widom–Rowlinson lattice gas

Particles of two types, type 1 and type 2 say, are distributed randomly within a bounded measurable subset of Rd in such a way that no 1-particle is within unit distance of any 2-particle. A simple probabilistic model for this physical model is the following, termed the Widom–Rowlinson model after the authors of the paper [319] on the liquid/vapour transition. Let λ ∈ (0,∞). Let 1 and 2 be independent subsets of chosen as spatial Poisson processes9 with intensity λ. Let D be the event

D = |x − y| > 1 for all x ∈ 1, y ∈ 2 ,

and let µ ,λ be the law of the pair ( 1, 2) conditioned on the event D . This measure is well deﬁned since P(D ) > 0 for bounded .

![image 1295](<rcm1-1_images/imageFile1295.png>)

9See [164, Section 6.13] for an introduction to the theory of spatial Poisson processes.

The deﬁnition of the Widom–Rowlinson measure µ ,λ may be extended to the whole of Rd in the usual manner, following. A probability measure on pairs of countable subsets of Rd is called a (WR-)Gibbs state if, conditional on the conﬁguration off any bounded measurable set , the conﬁguration within is that of two independent Poisson processes on conditional on no 1-particle in Rd being within unit distance of any 2-particle.

How many Gibbs states exist for a given value of λ? The following theorem may be proved using random-cluster methods in the continuum.

(11.46) Theorem [285]. Consider the Widom–Rowlinson model on Rd with d ≥ 2. There exist constants λ1, λ2 satisfying 0 < λ1 ≤ λ2 < ∞ such that: there is a unique Gibbs state when λ < λ1, and there exist multiple Gibbs states when λ > λ2.

It is an open problem to show the existence of a single critical value marking the onset of multiple Gibbs states. In advance of the proof, which is sketched at the end of the section, we turn to a lattice version of this model introduced in [232].

Let G = (V, E) be a ﬁnite graph. To each vertex we allocate a ‘type’ from the ‘type-space’ {0,1,2}, and we write V = {0,1,2}V for the ensuing spin space. For σ ∈ , let z(σ) be the number of vertices x with σx = 0. Let λ ∈ (0,∞), and consider the probability measure on V given by

µG,λ(σ) =

1 ZWR

λ−z(σ) if σ ∈ D, 0 otherwise,

![image 1296](<rcm1-1_images/imageFile1296.png>)

where D is the event that, for all x, y ∈ V, x ≁ y whenever σx = 1 and σy = 2, and ZWR is the appropriate normalizing constant.

Consider now the inﬁnite lattice Ld where d ≥ 2, and let = {0,1,2}Zd, endowed with the usual σ-ﬁeld G. We may deﬁne a Gibbs state in the manner given above: a probability measure µ on ( ,G) is called a lattice (WR-)Gibbs state if it satisﬁes the appropriate DLR condition.

(11.47)Theorem[232]. ConsiderthelatticeWidom–RowlinsonmodelonLd with d ≥ 2. There exist constants λ1, λ2 satisfying 0 < λ1 ≤ λ2 < ∞ such that: there is a unique Gibbs state when λ < λ1, and there exist multiple Gibbs states when λ > λ2.

Itis an openproblemto showthe existenceof a single critical valueof λ. Proofs of suchfactshingeusuallyonmonotonicity,butsuch monotonicityis notgenerally valid for this model, see [69]. Progress has been made for certain lattices, [171], but the case of Ld remains unsolved.

The main ingredient in the proof of the latter theorem is a certain ‘site-randomcluster measure’, given as follows for the ﬁnite graph G. The conﬁguration space is V = {0,1}V. Forω ∈ V, Letk(ω)be thenumberofcomponentsin the graph

obtained from G by deleting every vertex x with ω(x) = 0. The site-randomcluster measure ψG,p,q is given by

1 ZSRC x∈V

pω(x)(1 − p)1−ω(x) qk(ω), ω ∈ V,

(11.48) ψG,p,q(ω) =

![image 1297](<rcm1-1_images/imageFile1297.png>)

where p ∈ [0,1], q ∈ (0,∞), and ZSRC is the appropriate normalizing constant. This measure reduceswhen q = 1 to the productmeasureon V otherwise known as site percolation.

At ﬁrst sight, one might guess that the theory of such measures may be developed in much the same manner as that of the usual random-cluster model, but this is false. The problem is that, even for q ∈ [1,∞), the measures ψG,p,q lack the stochastic monotonicitywhich has provedso useful in the othercase. Speciﬁcally, the function k does not satisfy inequality (3.11).

Proof of Theorem 11.47. We follow [136], see also [86]. Let G = (V, E) be a ﬁnite graph, and let q = 2, λ ∈ (0,∞), and p = λ/(1 + λ). We show ﬁrst how to couple µG,λ and ψG,p,q. Let ω be sampled from V according to ψG,p,q. If ω(x) = 0, we set σx = 0. To each vertex y with ω(y) = 1, we allocate a type from the set {1,2}, each value having probability 12, and we do this by allocating a given type to each given cluster of ω, these types being constant within clusters, and independent between clusters. The outcome is a spin vector σ taking values in V, and it is left as an exercise to check that σ has law µG,λ.

![image 1298](<rcm1-1_images/imageFile1298.png>)

Next, we compare ψG,p,q with a productmeasure on V. It is immediate from (11.48) that, for ξ ∈ and x ∈ V,

pq pq + (1 − p)qκ(x,ξ)

ψG,p,q ω(x) = 1 ω(y) = ξ(y) for all y ∈/ V \ {x} =

,

![image 1299](<rcm1-1_images/imageFile1299.png>)

where κ(x,ξ) is the number of open clusters of ξx that contain neighbours of x. [Here, ξx denotes the conﬁguration obtained from ξ by setting the state of x to 0.] If the maximum degree of vertices in G is , then 0 ≤ κ(x,ξ) ≤ , and

p1 ≤ ψG,p,q ω(x) = 1 ω(y) = ξ(y) for all y ∈/ V \ {x} ≤ p2, where

pq pq + (1 − p)

pq pq + 1 − p

p1 =

, p2 =

.

![image 1300](<rcm1-1_images/imageFile1300.png>)

![image 1301](<rcm1-1_images/imageFile1301.png>)

By Theorems 2.1 and 2.3, (11.49) φG,p1 ≤st ψG,p,q ≤st φG,p2 where φG,r is product measure on V with density r.

Consider now a ﬁnite box of Ld, with = 2d. It may be seen as in the case of the Potts model of Section 11.2 that there is a multiplicity of WR-Gibbs

states if and only if the ψ ,p,q have a weak limit (as ↑ Zd) that possesses an inﬁnite cluster with strictly positive probability. By (11.49), this cannot occur if

p2 < pcsite(Ld), but this does indeed occur if p1 > pcsite(Ld). Here, pcsite(Ld) denotes the critical probability of site percolation on Ld, see [154].

Sketch proof of Theorem 11.46. The full proof is not included here, and interested readers are referred to [136, Thm 10.2] for further details10. Rather as in the previous proof, we relate the Widom–Rowlinson model to a type of ‘continuum site-random-cluster measure’. Let be a bounded measurable subset of Rd. For any countable subset of , let N( ) be the union of the closed 1 2-neighbourhoods of the points in , and let k( ) be the number of (topologically) connected components of N( ). Consider now the probability measure π ,λ on the family of countable subsets of given by

![image 1302](<rcm1-1_images/imageFile1302.png>)

![image 1303](<rcm1-1_images/imageFile1303.png>)

1 Z

2k( )π ,λ(d )

π ,λ(d ) =

![image 1304](<rcm1-1_images/imageFile1304.png>)

![image 1305](<rcm1-1_images/imageFile1305.png>)

where π ,λ is the law of a Poisson process on with intensity λ, and Z is a normalizing constant.

It is not hard to verify the following coupling. Let be a random countable subset of with law π ,λ. To each point x ∈ we allocate either type 1 or type 2, each possibility having probability 21. This is done simultaneously for all x ∈ by allocating a random type to each component of N( ), this type being constantwithincomponents,and independentbetweencomponents. The outcome is a conﬁguration ( 1, 2) of two sets of points labelled 1 and 2, respectively, and it may be checked that the law of ( 1, 2) is µ ,λ.

![image 1306](<rcm1-1_images/imageFile1306.png>)

![image 1307](<rcm1-1_images/imageFile1307.png>)

One uses arguments of stochastic domination next, but in the continuum. The methods of Section 2.1 may be adapted to the continuum to obtain a criterion under which π ,λ may be compared to some π ,λ′. It turns out that there exists α = α(d) ∈ (0,∞) such that

![image 1308](<rcm1-1_images/imageFile1308.png>)

(11.50) π ,αλ ≤st π ,λ ≤st π ,2λ for bounded measurable  .

![image 1309](<rcm1-1_images/imageFile1309.png>)

Let πλ be the law of a Poisson process on Rd with intensity λ. It is a central fact of continuumpercolation, see [154, Section 12.10] and [253], that there exists λc ∈ (0,∞) such that the percolation probability

(11.51) ρ(λ) = πλ N( ) possesses an unbounded component satisﬁes

0 if λ < λc, 1 if λ > λc.

ρ(λ) =

It may be seen as in Section 11.2 that there exists a multiplicity of WR-Gibbs states if and only the π ,λ have a weak limit (as ↑ Rd) that allocates strictly positive probability to the occurrence of an unbounded component. By (11.50)–

![image 1310](<rcm1-1_images/imageFile1310.png>)

(11.51), this cannot occur when λ < λ1 = 21λc, but does indeed occur when λ > λ2 = λc/α.

![image 1311](<rcm1-1_images/imageFile1311.png>)

![image 1312](<rcm1-1_images/imageFile1312.png>)

10The proof utilizes arguments of [86, 138].

## Appendix The Origins of FK(G)

The basic theory of the random-cluster model was presented in a series of papers by Kees [Cees] Fortuin and Piet Kasteleyn around 1970, and in the 1971 doctoral thesis of Fortuin. This early work contains several of the principal ingredients of Chapters 2 and 3 of the current book. The impact of the approach within the physics community was attenuated at the time by the combinatorial style and the level of abstraction of these papers.

The random-clustermodel has had substantial impact on the study of Ising and Potts models. It has, in addition, led to the celebrated FKG inequality, [124], of which the history is as follows1. Following a suggestion of Kasteleyn, Fortuin proved an extension of Harris’s positive-correlation inequality, [181, Lemma 4.1], to the random-cluster model, [122]. Kasteleyn spoke of related work during a lecture at the IHES in 1970, with Jean Ginibre in the audience. Ginibre realized subsequently that the inequality could be set in the general context of a probability measure µ on the power set of a ﬁnite set, subject to the condition µ(X ∪ Y)µ(X ∩ Y) ≥ µ(X)µ(Y), and he proceeded to write the ﬁrst draft of the ensuing publication. Meanwhile, Fortuin met Ginibre at the 1970 Les Houches Summer School on ‘Statistical mechanics and quantum ﬁeld theory’.

In a reply dated 23 September 1970 to Ginibre’s ﬁrst draft, Kasteleyn made a number of suggestions, including to extend the domain of the main theorem to a ﬁnite distributive lattice, thereby generalizing the result to include both a totally ordered ﬁnite set and the power set of a ﬁnite set. He proposed the use of the standard result that any ﬁnite distributive lattice is lattice-isomorphic to a sublattice of the power set of some ﬁnite set. The article was re-drafted accordingly. The two Dutch co-authorslater“thoughtitworthwhile todevelopa self-supporting lattice-theoreticproof”oftheprincipalproposition2. Ginibreplacedhisownname third in the list of authors, and the subsequent paper, [124], was published in the

![image 1313](<rcm1-1_images/imageFile1313.png>)

- 1I am indebted to Cees Fortuin and Jean Ginibre for their recollections of the events leading to the formulation and proof of the FKG inequality, and to Frank den Hollander for passing on material from Piet Kasteleyn’s papers.
- 2The quotation is taken from the notes written by Kasteleyn on Ginibre’s second draft.


(ii) As before. The substitution rule is p = p1 + p2 − p1p2.

![image 1314](<rcm1-1_images/imageFile1314.png>)

So far for the facts. Question: do they reﬂect some relation between the three systems? To answer this question we began with the following elementary steps (in which order, I do not rememberexactly; the one I give here will not be far from the actual one).

1. To bring case B somewhat more in line with A and C, go over from J(e) to w(e) = exp(−2β J(e)). Then the substitution rules are

w1 + w2 1 + w1w2 ; (ii) w = w1w2.

(i) w =

![image 1315](<rcm1-1_images/imageFile1315.png>)

2. Introduce new variables, viz. in case A: R∗ = R−1 (conductivity); in case B: w∗ = (1 − w)/(1 + w) = tanh(β J); in case C: p∗ = 1 − p. This reduces the substitution rules to:

(i) (ii)

![image 1316](<rcm1-1_images/imageFile1316.png>)

![image 1317](<rcm1-1_images/imageFile1317.png>)

![image 1318](<rcm1-1_images/imageFile1318.png>)

![image 1319](<rcm1-1_images/imageFile1319.png>)

![image 1320](<rcm1-1_images/imageFile1320.png>)

![image 1321](<rcm1-1_images/imageFile1321.png>)

![image 1322](<rcm1-1_images/imageFile1322.png>)

A R = R1 + R2 R∗ = R∗

1 + R∗

![image 1323](<rcm1-1_images/imageFile1323.png>)

![image 1324](<rcm1-1_images/imageFile1324.png>)

2

![image 1325](<rcm1-1_images/imageFile1325.png>)

![image 1326](<rcm1-1_images/imageFile1326.png>)

![image 1327](<rcm1-1_images/imageFile1327.png>)

![image 1328](<rcm1-1_images/imageFile1328.png>)

![image 1329](<rcm1-1_images/imageFile1329.png>)

w1∗ + w2∗ 1 + w1∗w2∗

w1 + w2 1 + w1w2

![image 1330](<rcm1-1_images/imageFile1330.png>)

![image 1331](<rcm1-1_images/imageFile1331.png>)

w∗ =

B w =

![image 1332](<rcm1-1_images/imageFile1332.png>)

![image 1333](<rcm1-1_images/imageFile1333.png>)

![image 1334](<rcm1-1_images/imageFile1334.png>)

![image 1335](<rcm1-1_images/imageFile1335.png>)

![image 1336](<rcm1-1_images/imageFile1336.png>)

![image 1337](<rcm1-1_images/imageFile1337.png>)

![image 1338](<rcm1-1_images/imageFile1338.png>)

C p = p1p2 p∗ = p1∗ p2∗

![image 1339](<rcm1-1_images/imageFile1339.png>)

![image 1340](<rcm1-1_images/imageFile1340.png>)

3. (Sideline) Note that if G is planar and G∗ is its dual, then the situation

in G corresponds to in G∗ and conversely. So the starred variables can be considered as ‘dual’ to the original ones (note that R∗∗ = R etc).

4. Consider now a q-state Potts model with σ : V → {1,2,. . .,q} and

Je(1 − δσ(e))

H = 2

e∈E

with J(e) ≥ 0 for all e; the factor 2 is inserted for the sake of comparison and a constant term is omitted. Deﬁne w(e) as for the Ising model. For case (i), a simple calculation (summation over σ(v)) shows that the substitution rule is now

w1 + w2 + (q − 2)w1w2 1 + (q − 1)w1w2

w =

.

![image 1341](<rcm1-1_images/imageFile1341.png>)

That for case (ii) is, as in the Ising model, w = w1w2. It takes the same form as for case (i), with w∗ instead of w, if we deﬁne

1 − w 1 + (q − 1)w

w∗ =

.

![image 1342](<rcm1-1_images/imageFile1342.png>)

- 5. Now note that by substituting q = 1 in the last few formulae we get w = w1 + w2 − w1w2, or 1 − w = (1 − w1)(1 − w2) and w∗ = 1 − w. Hence, if we write 1 − w = p, we recover the rules for C. So in this very special sense, the percolation model behaves, just like the Ising model, as a special case of the Potts model.
- 6. At ﬁrst sight the electric network does not seem to ﬁt into the Potts model. It doesso, however,ifwetakeanappropriateformallimit. DeﬁneforthePottsmodel S = q−12(1 − w). In the limit q → 0 (which at this stage is still meaningless, since q is an integer), the substitution rules reduce to


![image 1343](<rcm1-1_images/imageFile1343.png>)

S1S2 S1 + S2 ; (ii) S = S1 + S2

(i) S =

![image 1344](<rcm1-1_images/imageFile1344.png>)

and the duality rule is S∗ = 1/S. In other words, we recover the rules for the network, with S = R−1 (= R∗).

7. So far we had got only a ﬁrst indication about a relationship between the systems A–C and the Potts model. We then wanted to turn to more general situations. We had observed that (for arbitrary G) certain characteristic quantities in A–C, such as

(A) the total current ﬂowing through an electric network when a unit potential

difference is imposed on two arbitrary vertices x and y, (B) the two-spin correlation E[σ(x)σ(y)] of the Ising model, (C) the pair connectivity E[I(x ↔ y)] of the percolation model

can all be written in the form P(X)/Q(X) (where X stands for S = R−1, p = 1 − w, and p, respectively), with P and Q polynomials in the edge variables X(e) that are linear in each variable separately. For the electric network, P and Q are homogeneous in all variables S(e) together (of degree |V| − 2 and |V| − 1, respectively); Q is the generating function of spanning trees of G, and P is the generating function of spanning forests which consist of two trees, with x and y in different trees. For the Ising model, Q is the partition function (which has also a graph-theoreticalinterpretation, viz. in terms of cycles). For the percolation model, Q = 1 identically.

8. From the linearity in the X(e) it follows that P(X) = P(X, G) satisﬁes, for each edge e, the recursion relation

P(X, G) = P1 + X(e)P2,

with P1 and P2 polynomials in all X( f ) with f  = e. This relation holds also for the Potts model with arbitrary q, again with p = 1 − w. A similar relation holds for Q.

9. Now if in the Potts model we have p(e) = 0, i.e. w(e) = 1, for some edge e, this means that J(e) = 0; this is equivalent to having an interaction graph G with the edge e deleted. Similarly, p(e) = 1, w(e) = 0, means that the interaction is inﬁnitely strong; this is equivalent to having an interaction graph with the edge e contracted (i.e. deleted and its end points identiﬁed). If DeG and CeG, respectively, are the graphs thus obtained from G, then obviously,

P(p, DeG) = P1, P(p,CeG) = P1 + P2.

Hence, we can write P(p, G) = P(p, DeG) + p(e){P(p,CeG) − P(p, DeG)}

= [1 − p(e)]P(p, DeG) + p(e)P(p,CeG).

- 10. Iteration of the last step leads directly to the expansion of P and Q in the variables p(e) and 1 − p(e). Since 0 ≤ p(e) ≤ 1, we could interpret the p(e) as probabilities and the entire system as an example (the ﬁrst one we knew) of ‘weighted’ (we would now say ‘dependent’) percolation. The generalization to arbitrary positive q (and even to complex q!) was now obvious. Then the limit q → 0, as described above, could be taken correctly, and what came out was the electric network with all its properties.
- 11. It is the system obtained in this way which — for lack of a more instructive name — we called the random-cluster model. Most people have just called it the Potts model, and of course, it is closely related to the generalized spin model bearing this name. (We referred to the latter model as the Ashkin–Teller–Potts model, because Ashkin and Teller were really the ﬁrst to consider generalizations of the Ising model to more than two spin states; one of these was the 4-state Potts model.) Fortuin and I preferred, however, to distinguish between the two systems, because they are different in principle. It is only in the paper by Edwards and Sokal that the relation between the two was fully established for integral values of q. It is now obviousthat to every function f (σ) of the spin state in the Potts model there corresponds a function F(ω) of the edge state in the random-cluster model such that the expectation of F with respect to the random-cluster measure equals the expectation of f with respect to the Potts measure, and conversely. F and f are transformed into each other via kernels which are nothing but the conditional probabilities of Edwards and Sokal. The relations which Fortuin and I found between spin correlationsin the Ising model and certain connectivityprobabilities in the random-cluster model with q = 2 were special cases.
- 12. After thus having introduced the random-cluster model for ﬁnite graphs, we were prepared to tackle inﬁnite graphs. Fortuin wanted absolutely to treat


these in as general a setting as possible and not restrict himself from the outset to regular lattices, as I had suggested to him. This admittedly makes his papers less accessible, but, in my opinion, also richer than they would have been if he had followed my suggestion. But this is a matter of taste.

So far about history. Looking at the subsequent developments, I am somewhat surprised by the fact that (to my knowledge) no one has given any attention to the domain of q between 0 and 1, not even to the limit in which one recovers the electric network,where life becomesmuch simpler. Of course,the FKGinequality does not hold in this domain, but does that imply that nothing of interest can be done? I admit that Fortuin was the ﬁrst to restrict himself to the region where FKG holds, but that was because the time for his PhD research was limited! In fact, if I remember correctly, some mathematician once published a paper in which a graph-theoretical interpretation was given to the random-cluster model (probably under the name of dichromatic polynomial) for q = −1 (or q = −2, I am not sure).

Then there is the ‘antiferromagnetic’ Potts model, where J(e) is allowed to be negative. If it is, p(e) is also negative, so that a standard probability interpretation is impossible. Thiscase hasnotbeeninvestigatedeither, as farasI know. Still, it is of interest, if only because, for integral positive q, the limit where all J(e) become inﬁnitely negativeleads one into the theory of vertexcolouringswith q colours! In this connection I may point out that for two-dimensional regular lattices the value q = 4 plays a very special role in the random-cluster model: for q < 4 the phase transition is ‘of second order’ (i.e. the percolation probability is continuous), for q > 4 it is ‘of ﬁrst order’. So it may be that there is more to be said about the four-colour problem than we know at present!

![image 1345](<rcm1-1_images/imageFile1345.png>)

Second letter from Piet Kasteleyn to GRG, dated 17 November 1992.

. . . I have been a bit too hasty in my conclusion about the connection between functions f (σ) in the Potts model (PM) and functions F(ω) in the random-cluster model(RCM). WhatI wrote aboutthe ‘transformation’from f to F and vice versa may be formally true, but it is trivial. What is not trivial, is the question whether to each f there corresponds an F depending only on the edge conﬁguration ω, and not (parametrically) on p = (pe : e ∈ E), and vice versa. I do not remember having seen this question discussed in the literature. In one direction there is no problem. If for given f (σ) we deﬁne

f (σ)  → F(ω) =

σ

f (σ)µ(σ | ω),

this F(ω)satisﬁesthe requirementI mentioned,because µ(σ | ω)doesnotdepend on p. However, the map

F(ω)  → f (σ) =

ω

F(ω)µ(ω | σ)

does not satisfy the requirement, µ(ω | σ) depends on pe explicitly.

To analyse this point we can proceed as follows. Using your notation we have

π(σ) = πG,p,q(σ) = Z−1

(1 − pe) + peδσ(e) ,

e∈E

φ(ω) = φG,p,q(ω) = Z−1

(1 − pe)(1 − ω(e)) + peω(e) qk(ω).

e∈E

The expectation w.r.t. π of a function f (σ) = f (σ, G) can be written as

f (σ)Z−1

1 + pe{δσ(e) − 1}

Eπ f =

e∈E

σ

= Z−1

{δσ(e) − 1} .

pe

f (σ)

e∈D

D⊂E e∈D

σ

The expectation w.r.t. φ of a function F(ω) = F(ω, G) can be written as

F(ω)Z−1

{1 − ω(e)} + pe{2ω(e) − 1} qk(ω)

EφF =

e

ω

= Z−1

qk(ω)F(ω)

ω

{2ω(e) − 1}

pe

×

e∈D

D⊂E e∈D

In order that Eπ f = EφF identically in p we must have

{1 − ω(e)} .

e∈E\D

{δσ(e) − 1}

∀D ⊂ E :

f (σ)

e∈D

σ

qk(ω)F(ω)

{2ω(e) − 1}

{1 − ω(e)} . (∗)

=

e∈D

e∈E\D

ω

It follows from what I remarked on µ(σ | ω) that for given f (σ) there is a solution F(ω) of this equation. (It is readily veriﬁed.) Question: is there a solution f (σ) for given F(ω)? The answer is not in general. If, e.g., G contains

the subgraph Kr (the complete graph on r vertices, having 12r(r − 1) edges), and we choose D = the edge-set of this subgraph, then there is no σ such that

![image 1346](<rcm1-1_images/imageFile1346.png>)

e∈D{δσ(e) − 1}  = 0 if r > q. The reason is that it is not possible to have different spin values for every pair of adjacent vertices in D if you have only q different values at your disposal. Hence the l.h.s. of (∗) equals 0 for this D, so that F(ω) has to satisfy the condition

ω

qk(ω)F(ω)

{2ω(e) − 1}

e∈D

{1 − ω(e)} = 0. (∗∗)

e∈E\D

This can be rewritten, if we denote an edge conﬁguration not by ω, but by the set of open edges. Let us denote this by C (your η(ω)). Then

1 if e ∈ C, −1 if e ∈ E \ C,

0 if e ∈ C, 1 if e ∈ E \ C.

2ω(e) − 1 =

1 − ω(e) =

Hence, the l.h.s. of the condition (∗∗) reduces to

qk(C)F(C)(−1)|D∩(E\C)|I{C⊂D} =

qk(C)F(C)(−1)|D\C|

0 =

C⊂E

C⊂D

where C⊂D = C:C⊂D So the condition reads:

(−1)|D\C|qk(C)F(C) = 0.

C⊂D

For q = 2 (Ising model), the existence of a triangle in G already causes a relation (it cannot accommodate 3 unequal pairs of spins). This is, e.g., satisﬁed by F(C) = I{u↔v}, but not by F(C) = I{u↔v↔w}, where u, v, w are vertices.

You may be amused to see what happens in the case q = 1!

My conclusion is that the PM is ‘included’ (in the spirit of this analysis) in the RCM, but that generically the RCM is ‘richer’: there are questions one can ask in the RCM which have no counterpart in the PM. In addition, of course, the RCM makes also sense for q ∈/ N, but the PM — as far as we know (Fortuin and I tried hard!) — not.

![image 1347](<rcm1-1_images/imageFile1347.png>)

Postscript by Cees Fortuin, 11 September 2003.

I remember especially the ﬁrst time he [Piet] told me about his ideas (end of 1966 when I still was doing my military service and he already had invited me to work withhim): weweresittingnexteachotheratthetableinfrontofthewindow,which he used for working sessions, and he explained his ideas (the ABC of the letter) while I was listening. My ﬁrst work was then ‘putting the electrical current of a network into the scheme’. The actual formulating of the model took some time: I guess that it was end 1968/begin 1969 before on my blackboard the formula with 2n appeared (the reformulation of the Ising model); I then went to his ofﬁce and said something like: “I have found what we sought” (but half and half expecting he would say that he already knew!). We walked back to my ofﬁce where he overlooked the blackboard and remarked that this was a special moment(!).

## List of Notation

Graphs and sets:

G = (V, E) 15 Graph with vertex-set V and edge-set E EW 16 Set of edges having both endvertices in W VE 174 Set of vertices incident to edges in the set E Aut(G) 74 Automorphism group of G Gd 133 Dual graph of the planar graph G

x, y 15 Edge joining vertices x and y x ∼ y 15 x is adjacent to y R 18 The real line (−∞,∞) Z 17 The set {. . .,−2,−1,0,1,2,. . .} of integers Z+ 18 The set {0,1,2,. . .} of non-negative integers N 18 The natural numbers Z+ \ {0} Ld 18 The d-dimensional (hyper)cubic lattice Ed 18 The set of edges of Ld EV 18 Subset of edges having both endvertices in V T 159 The triangular lattice

The hexagonal lattice The set of plaquettes of L3

159 169

H

U 164 The upper half-plane xi 17 The ith component of the vertex x ∈ Zd

a,b 18 The box with vertex-set di=1[ai,bi] n 18 The box with vertex-set [−n,n]d

S(L,n) 124 The box [0, L − 1] × [−n,n]d−1 deg(u) 58 The degree of the vertex u deg(W) 43 The maximal degree of a spanning set W of vertices ∂ A 17 The surface of the set A of vertices

eW 17 The edge boundary of W e,δC 170 Edge-set given in terms of a surface δ of plaquettes

∂eD 174 The 1-edge-boundary of the edge-set D ∂extF 147 Set of vertices of VF in inﬁnite paths of the complement

extD 174 The external edge-boundary of the edge-set D intD 174 The internal edge-boundary of the edge-set D v,δC 170 Subset of C given in terms of a surface δ of plaquettes

List of Notation 351

∂+ , ∂− 197 Upper and lower boundaries of rad(D) 110 Radius of a subgraph D of Ld containing 0 δ(x, y) 18 Number of edges in the shortest path from x to y |x| 18 δ(0, x)

x 18 max{|xi| : 1 ≤ i ≤ d}

h(e) 169 The plaquette intersecting the edge e ∈ E3 [H] 170 Subset of R3 lying in some plaquette of H E(H) 169 Set of edges corresponding to the set H of plaquettes

δ 170 The closure or extended interface of a set δ of plaquettes DL,M 201 The set of interfaces δ0 201 The regular interface ∼s 169 s-connectedness for plaquettes

![image 1348](<rcm1-1_images/imageFile1348.png>)

h1,h2 169 The L∞ distance between the centres of plaquettes h1, h2 ins(T) 169 Union of the bounded connected components of Rd \ T out(T) 169 Union of the unbounded connected components of Rd \ T |A| 17 Cardinality of A, or number of vertices of A A △ B 60 Symmetric difference of A and B

Probability notation:

µ(X) 18 Expectation of the random variable X under the measure µ p,q 4 Edge and cluster-weighting parameters

φG,p,q, φp,q 4 Random-cluster measure on G with parameters p, q φG,p, φp 4 Product measure with density p on edges of G ZG(p,q) 4 Random-cluster partition function

λβ,h 7 Ising probability measure πβ,h 7 Potts probability measure

φ ,ξ p,q 38 Random-cluster measure on with boundary condition ξ φpb,q 75 Random-cluster measure on Ld with boundary condition b Wp,q 72 Set of limit-random-cluster measures Rp,q 78 Set of DLR-random-cluster measures UCS 13 Uniform connected graph UST 13 Uniform spanning tree USF 13 Uniform (spanning) forest 1A 15 Indicator function of an event A covp,q 41 Covariance corresponding to φp,q covp 33 Covariance corresponding to µp varp,q 56 Variance corresponding to φp,q ω 15 Typical realization of open and closed edges

15 The space {0,1}E of conﬁgurations F 16 The σ-ﬁeld of generated by the cylinders F 16 The σ-ﬁeld generated by states of edges in E T 16 The σ-ﬁeld generated by states of edges in Ed \ E T 16 The tail σ-ﬁeld

ξ F 27 Set of conﬁgurations that agree with ξ off F

352 List of Notation

ωe, ωe 16 Conﬁguration ω with e declared closed/open ω1 ∨ ω2 20 Maximum conﬁguration of ω1 and ω2 ω1 ∧ ω2 20 Minimum conﬁguration of ω1 and ω2 H(ω1,ω2) 16 Hamming distance between ω1 and ω2 η(ω) 16 The set of edges that are open in ω k(ω) 17 Number of open components in ω I(ω) 79 Number of inﬁnite open clusters in ω A, Ac 16 Complement of event A A B 64 Event that A and B occur ‘disjointly’ B(X) 241 Space of bounded measurable functions from X to R C(X) 233 Space of continuous functions from X to R DX 82 Discontinuity set of the random variable X IA(e) 30 Inﬂuence of the edge e on the event A ≤st 19 Stochastic domination inequality

![image 1349](<rcm1-1_images/imageFile1349.png>)

⇒ 69 Weak convergence

Random-cluster notation:

Cx 17 Open cluster at x C 18 Open cluster C0 at 0 pc(q) 99 Critical value of p under φp,q psd(q) 135 The self-dual point of the random-cluster model on L2 pc(q) 124 Critical point deﬁned via slab connections pc(q) 113 Critical point for polynomial/exponential decay p(q) 197 Critical point for the roughening transition pcbond 329 Critical probability of bond percolation pcsite 340 Critical probability of site percolation ptc(q) 114 Critical point for the time-constant pg(q) 115 Critical point for exponential decay of connectivity η(µ) 114 The time-constant associated with the measure µ θb(p,q) 98 Percolation probability under φpb,q ξ(p,q) 115 Correlation length δe(σ) 7 Indicator function that the endvertices of e have equal spin {A ↔ B} 17 Event that there exist a ∈ A and b ∈ B such that a ↔ b {A ↔/ B} 17 Complement of the event {A ↔ B}

![image 1350](<rcm1-1_images/imageFile1350.png>)

Je 15 Event that e is open; also the indicator function of this event Ke 37 Event that endvertices of e are joined by an open path

not using e

Finally:

a ∨ b 18 Maximum of a and b a ∧ b 18 Minimum of a and b ⌊c⌋ 18 Least integer not less than c ⌈c⌉ 18 Greatest integer not greater than c

δu,v 7 The Kronecker delta λs 171 s-dimensional Lebesgue measure

## References

Abraham, D. B., Newman, C. M.

1. The wetting transition in a random surface model, Journal of Statistical Physics

63 (1991), 1097–1111. Ahlswede, R., Daykin, D. E.

2. An inequality for the weights of two families of sets, their unions and intersections, ZeitschriftfurWahrscheinlichkeitstheorie undVerwandte Gebiete¨ 43 (1978), 183– 185.

Aizenman, M.

3. Geometric analysis of φ4 ﬁelds and Ising models, Communications in Mathemat-

ical Physics 86 (1982), 1–48. Aizenman, M., Barsky, D. J.

4. Sharpnessofthephasetransitioninpercolationmodels, CommunicationsinMath-

ematical Physics 108 (1987), 489–526. Aizenman, M., Barsky, D. J., Fernandez,´ R.

- 5. The phase transition in a general class of Ising-type models is sharp, Journal of Statistical Physics 47 (1987), 343–374. Aizenman, M., Chayes, J. T., Chayes, L., Frohlich,¨ J., Russo, L.
- 6. On a sharp transition from area law to perimeter law in a system of random


surfaces, Communications in Mathematical Physics 92 (1983), 19–69. Aizenman, M., Chayes, J. T., Chayes, L., Newman, C. M.

- 7. The phase boundary in dilute and random Ising and Potts ferromagnets, Journal of Physics A: Mathematical and General 20 (1987), L313–L318.
- 8. Discontinuity of the magnetization in one-dimensional 1/|x − y|2 Ising and Potts


models, Journal of Statistical Physics 50 (1988), 1–40. Aizenman, M., Fernandez,´ R.

9. On the critical behavior of the magnetization in high-dimensional Ising models,

Journal of Statistical Physics 44 (1986), 393–454. Aizenman, M., Grimmett, G. R.

10. Strict monotonicity for critical points in percolation and ferromagnetic models,

Journal of Statistical Physics 63 (1991), 817–835. Aizenman, M., Klein, A., Newman, C. M.

11. Percolation methods for disordered quantum Ising models, Phase Transitions: Mathematics, Physics, Biology, . . . (R. Kotecky,´ ed.), World Scientiﬁc, Singapore, 1992, pp. 129–137.

Aizenman, M., Nachtergaele, B.

12. Geometric aspects of quantum spin systems, Communications in Mathematical

Physics 164 (1994), 17–63. Alexander, K.

- 13. Simultaneous uniqueness of inﬁnite clusters in stationary random labeled graphs, Communications in Mathematical Physics 168 (1995), 39–55.
- 14. Weak mixing in lattice models, Probability Theory and Related Fields 110 (1998), 441–471.
- 15. The asymmetric random cluster model and comparison of Ising and Potts models, Probability Theory and Related Fields 120 (2001), 395–444.
- 16. Power-law corrections to exponential decay of connectivities and correlations in lattice models, Annals of Probability 29 (2001), 92–122.
- 17. Cube-root boundary ﬂuctuations for droplets in random cluster models, Communications in Mathematical Physics 224 (2001), 733–781.
- 18. The single-droplet theorem for random-cluster models, In and Out of Equilibrium (V. Sidoravicius, ed.), Birkhauser,¨ Boston, 2002, pp. 47–73.
- 19. Mixing properties and exponential decay for lattice systems in ﬁnite volumes,


Annals of Probability 32 (2004), 441–487. Alexander, K., Chayes, L.

20. Non-perturbative criteria for Gibbsian uniqueness, Communications in Math-

ematical Physics 189 (1997), 447–464. Ashkin, J., Teller, E.

21. Statistics of two-dimensional lattices with four components, The Physical Review

64 (1943), 178–184. Barlow, R. N., Proschan, F.

- 22. Mathematical Theory of Reliability, Wiley, New York, 1965. Barsky, D. J., Aizenman, M.
- 23. Percolation critical exponents under the triangle condition, Annals of Probability 19 (1991), 1520–1536. Barsky, D. J., Grimmett, G. R., Newman, C. M.
- 24. Percolation in half spaces: equality of critical probabilities and continuity of the percolation probability, Probability Theory and Related Fields 90 (1991), 111– 148.


Batty, C. J. K., Bollmann, H. W.

25. Generalized Holley–Preston inequalities on measure spaces and their products, ZeitschriftfurWahrscheinlichkeitstheorie undVerwandte Gebiete¨ 53 (1980), 157– 174.

Baxter, R. J.

- 26. Exactly Solved Models in Statistical Mechanics, Academic Press, London, 1982. Baxter, R. J., Kelland, S. B., Wu, F. Y.
- 27. Equivalence of the Potts model or Whitney polynomial with an ice-type model,


Journal of Physics A: Mathematical and General 9 (1976), 397–406. Beijeren, H. van

- 28. Interface sharpness in the Ising system, Communications in Mathematical Physics 40 (1975), 1–6. Benjamini, I., Lyons, R., Peres, Y., Schramm, O.
- 29. Group-invariant percolation on graphs, Geometric and Functional Analysis 9


(1999), 29–66.

- 30. Critical percolation on any nonamenable group has no inﬁnite clusters, Annals of Probability 27 (1999), 1347–1356.
- 31. Uniform spanning forests, Annals of Probability 29 (2001), 1–65. Benjamini, I., Schramm, O.
- 32. Percolation beyond Zd, many questions and a few answers, Electronic Commu-


nications in Probability 1 (1996), 71–82.

33. Percolationinthehyperbolicplane, JournaloftheAmericanMathematicalSociety

14 (2001), 487–507. Ben-Or, M., Linial, N.

- 34. Collective coin ﬂipping, Randomness and Computation, Academic Press, New York, 1990, pp. 91–115. Berg, J. van den, Haggstr¨ om,¨ O., Kahn, J.
- 35. Some conditional correlation inequalities for percolation and related processes,


Random Structures and Algorithms 29 (2006), 417–435. Berg, J. van den, Keane, M.

36. On the continuity of the percolation probability function, Particle Systems, Random Media and Large Deviations (R. T. Durrett, ed.), Contemporary Mathematics Series, vol. 26, American Mathematical Society, Providence, RI, 1985, pp. 61–65.

Berg, J. van den, Kesten, H.

37. Inequalities with applications to percolation and reliability, Journal of Applied

Probability 22 (1985), 556–569. Berg, J. van den, Maes, C.

38. Disagreement percolation in the study of Markov ﬁelds, Annals of Probability 22

(1994), 749–763. Bezuidenhout, C. E., Grimmett, G. R., Kesten, H.

39. Strict inequality for critical values of Potts models and random-cluster processes,

Communications in Mathematical Physics 158 (1993), 1–16. Biggs, N. L.

- 40. Algebraic Graph Theory, Cambridge University Press, Cambridge, 1984.
- 41. Interaction Models, London Mathematical Society Lecture Notes, vol. 30, Cambridge University Press, Cambridge, 1977. Billingsley, P.
- 42. Convergence of Probability Measures, Wiley, New York, 1968. Biskup, M.
- 43. Reﬂection positivity of the random-cluster measure invalidated for non-integer q,


Journal of Statistical Physics 92 (1998), 369–375. Biskup, M., Borgs, C., Chayes, J. T., Kotecky,´ R.

44. Gibbs states of graphical representations of the Potts model with external ﬁelds. Probabilistic techniques in equilibrium and nonequilibrium statistical physics, Journal of Mathematical Physics 41 (2000), 1170–1210.

Biskup, M., Chayes, L.

45. Rigorous analysis of discontinuous phase transitions via mean-ﬁeld bounds, Com-

munications in Mathematical Physics 238 (2003), 53–93. Biskup, M., Chayes, L., Crawford, N.

46. Mean-ﬁeld driven ﬁrst-order phase transitions in systems with long-range interactions, Journal of Statistical Physics 119 (2006), 1139–1193.

Biskup, M., Chayes, L., Kotecky,´ R.

47. On the continuity of the magnetization and the energy density for Potts models on two-dimensional graphs (1999).

Bleher, P. M., Ruiz, J., Schonmann, R. H., Shlosman, S., Zagrebnov, V. A.

48. Rigidity of the critical phases on a Cayley tree, Moscow Mathematical Journal 1

(2001), 345–363, 470. Bleher, P. M., Ruiz, J., Zagrebnov, V. A.

49. On the purity of the limiting Gibbs state for the Ising model on the Bethe lattice,

Journal of Statistical Physics 79 (1995), 473–482. Blume, M.

50. Theory of the ﬁrst-order magnetic phase change in UO2, The Physical Review 141 (1966), 517–524.

Blumenthal, R. M., Getoor, R. K.

- 51. Markov Processes and Potential Theory, Academic Press, New York, 1968. Bodineau, T.
- 52. The Wulff construction in three and more dimensions, Communications in Mathematical Physics 207 (1999), 197–229.
- 53. Slab percolation for the Ising model, Probability Theory and Related Fields 132


(2005), 83–118.

54. Translation invariant Gibbs states for the Ising model, Probability Theory and

Related Fields 135 (2006), 153–168. Bodineau, T., Ioffe, D., Velenik, Y.

55. Rigorous probabilistic analysis of equilibrium crystal shapes, Journal of Math-

ematical Physics 41 (2000), 1033–1098. Boel, R. J., Kasteleyn, P. W.

- 56. Correlation-function identities and inequalities for Ising models with pair interactions, Communications in Mathematical Physics 61 (1978), 191–208.
- 57. On a class of inequalities and identities for spin correlation functions of general


Ising models, Physics Letters A 70 (1979), 220–222. Boivin, D.

58. First passage percolation: the stationary case, Probability Theory and Related

Fields 86 (1990), 491–499. Bollobas,´ B.

- 59. Graph Theory, An Introductory Course, Springer, Berlin, 1979.
- 60. The evolution of random graphs, Transactions of the American Mathematical Society 286 (1984), 257–274.
- 61. Random Graphs, Academic Press, London, 1985. Bollobas,´ B., Grimmett, G. R., Janson, S.
- 62. The random-cluster process on the complete graph, Probability Theory and Re-


lated Fields 104 (1996), 283–317. Borgs, C., Chayes, J. T.

63. The covariance matrix of the Potts model: A random-cluster analysis, Journal of Statistical Physics 82 (1996), 1235–1297.

Borgs, C., Chayes, J. T., Frieze, A. M., Kim, J. H., Tetali, E., Vigoda, E., Vu, V. V.

64. Torpid mixing of some MCMC algorithms in statistical physics, Proceedings of the 40th IEEE Symposium on the Foundations of Computer Science (1999), 218–229.

Borgs, C., Kotecky,´ R., Medved’, I.

65. Finite-size effects for the Potts model with weak boundary conditions, Journal of

Statistical Physics 109 (2002), 67–131. Borgs, C., Kotecky,´ R., Miracle-Sole,´ S.

66. Finite-size scaling for the Potts models, Journal of Statistical Physics 62 (1991), 529–552.

Bourgain, J., Kahn, J., Kalai, G., Katznelson, Y., Linial, N.

67. The inﬂuence of variables in product spaces, Israel Journal of Mathematics 77

(1992), 55–64. Bricmont, J., Kuroda, K., Lebowitz, J. L.

68. First order phase transitions in lattice and continuous systems: Extension of Pirogov–Sinaitheory, CommunicationsinMathematicalPhysics 101(1985), 501– 538.

Brightwell, G. R., Haggstr¨ om,¨ O., Winkler, P.

69. Nonmonotonic behavior in hard-core and Widom–Rowlinson models, Journal of

Statistical Physics 94 (1999), 415–435. Broadbent, S. R., Hammersley, J. M.

70. Percolation processes I. Crystals and mazes, Proceedings of the Cambridge Philosophical Society 53 (1957), 629–641.

Brooks, R. L., Smith, C. A. B., Stone, A. H., Tutte, W. T.

71. The dissection of rectangles into squares, Duke Mathematical Journal 7 (1940), 312–340.

Burton, R. M., Keane, M.

- 72. Density and uniqueness in percolation, Communications in Mathematical Physics 121 (1989), 501–505.
- 73. Topologicalandmetricpropertiesofinﬁniteclustersinstationarytwo-dimensional


site percolation, Israel Journal of Mathematics 76 (1991), 299–316. Burton, R. M., Pemantle, R.

- 74. Local characteristics, entropy and limit theorems for spanning trees and domino tilings via transfer-impedances, Annals of Probability 21 (1993), 1329–1371. Camia, F., Newman, C. M.
- 75. Continuum nonsimple loops and 2D critical percolation, Journal of Statistical Physics 116 (2004), 157–173.
- 76. Two-dimensional critical percolation: the full scaling limit, Communications in


Mathematical Physics 268 (2006), 1–38. Campanino, M., Chayes, J. T., Chayes, L.

77. Gaussian ﬂuctuations of connectivities in the subcritical regime of percolation,

Probability Theory and Related Fields 88 (1991), 269–341. Campanino, M., Ioffe, D., Velenik, Y.

78. Ornstein–Zernike theory for the ﬁnite range Ising models above Tc, Probability

Theory and Related Fields 125 (2002), 305–349. Capel, H. W.

79. On the possibility of ﬁrst-order transitions in Ising systems of triplet ions with zero-ﬁeld splitting, Physica 32 (1966), 966–988; 33 (1967), 295–331; 37 (1967), 423–441.

Cardy, J.

80. Critical percolation in ﬁnite geometries, Journal of Physics A: Mathematical and

General 25 (1992), L201. Cerf, R.

81. The Wulff crystal in Ising and percolation models, Ecole d’Ete´ de Probabilites´ de Saint Flour XXXIV–2004 (J. Picard, ed.), Lecture Notes in Mathematics, vol. 1878, Springer, Berlin, 2006.

Cerf, R., Kenyon, R.

82. The low-temperature expansion of the Wulff crystal in the 3D Ising model, Com-

munications in Mathematical Physics 222 (2001), 147–179. Cerf, R., Pisztora, A.´

83. OntheWulffcrystalintheIsingmodel, AnnalsofProbability 28 (2000), 947–1017. 84. Phase coexistence in Ising, Potts and percolation models, Annales de l’Institut

Henri Poincare,´ Probabilites´ et Statistiques 37 (2001), 643–724. Cernˇ y,´ J., Kotecky,´ R.

- 85. Interfaces for random cluster models, Journal of Statistical Physics 111 (2003), 73–106. Chayes, J. T., Chayes, L., Kotecky,´ R.
- 86. The analysis of the Widom–Rowlinson model by stochastic geometric methods,


Communications in Mathematical Physics 172 (1995), 551–569. Chayes, J. T., Chayes, L., Newman, C. M.

87. Bernoulli percolation above threshold: an invasion percolation analysis, Annals

of Probability 15 (1987), 1272–1287. Chayes, J. T., Chayes, L., Schonmann, R. H.

- 88. Exponential decay of connectivities in the two-dimensional Ising model, Journal of Statistical Physics 49 (1987), 433–445. Chayes, J. T., Chayes, L., Sethna, J. P., Thouless, D. J.
- 89. A mean-ﬁeld spin glass with short-range interactions, Communications in Math-


ematical Physics 106 (1986), 41–89. Chayes, L.

90. The density of Peierls contours in d = 2 and the height of the wedding cake,

Journal of Physics A: Mathematical and General 26 (1993), L481–L488. Chayes, L., Kotecky,´ R.

- 91. Intermediate phase for aclassicalcontinuummodel, PhysicalReviewB 54 (1996), 9221–9224. Chayes, L., Lei, H. K.
- 92. Random cluster models on the triangular lattice, Journal of Statistical Physics 122


(2006), 647–670. Chayes, L., Machta, J.

- 93. Graphical representations and cluster algorithms, Part I: discrete spin systems, Physica A 239 (1997), 542–601.
- 94. Graphical representations and cluster algorithms, II, Physica A 254 (1998), 477– 516. Couronne,´ O.
- 95. Poisson approximation for large clusters in the supercritical FK model, Markov Processes and Related Fields 12 (2006), 627–643.


Couronne,´ O., Messikh, R. J.

96. Surface order large deviations for 2d FK-percolation and Potts models, Stochastic

Processes and their Applications 113 (2004), 81–99. Cox, J. T., Gandolﬁ, A., Grifﬁn, P., Kesten, H.

97. GreedylatticeanimalsI:Upperbounds,AdvancesinAppliedProbability 3(1993),

1151–1169. Curie, P.

98. Propri´et´es magn´etiques des corps `a diverses temp´eratures, Thesis, Annales de

Chimie et de Physique, series´ 7 (1895), 289–405. Dembo, A., Zeitouni, O.

99. Large Deviations Techniques and Applications, 2nd edition, Springer, New York, 1998.

De Santis, E.

100. Strict inequality for phase transition between ferromagnetic and frustrated sys-

tems, Electronic Journal of Probability 6 (2001), Paper 6. Deuschel, J.-D., Pisztora, A.´

101. Surface order large deviations for high-density percolation, Probability Theory

and Related Fields 104 (1996), 467–482. Dobrushin, R. L.

- 102. Gibbsian random ﬁelds for lattice systems and pairwise interactions, Functional Analysis and its Applications 2 (1968), 292–301.
- 103. Gibbs state describing coexistence of phases for a three–dimensional Ising model,


Theory of Probability and its Applications 18 (1972), 582–600. Dobrushin, R. L., Kotecky,´ R., Shlosman, S.

104. Wulff Construction. A Global Shape from Local Interaction, Translations of Mathematical Monographs, vol. 104, American Mathematical Society, Providence, RI, 1992.

Domb, C.

105. On Hammersley’s method for one-dimensional covering problems, Disorder in Physical Systems (G. R. Grimmett, D. J. A. Welsh, eds.), Oxford University Press, Oxford, 1990, pp. 33–53.

Doyle, P. G., Snell, J. L.

106. Random Walks and Electric Networks, Carus Mathematical Monographs, vol. 22,

Mathematical Association of America, Washington, DC, 1984. Dudley, R. M.

107. Real Analysis and Probability, Wadsworth and Brooks/Cole, Belmont, California, 1989.

Edwards, R. G., Sokal, A. D.

108. Generalization of the Fortuin–Kasteleyn–Swendsen–Wang representation and

Monte Carlo algorithm, The Physical Review D 38 (1988), 2009–2012. Edwards, S. F., Anderson, P. W.

- 109. Theory of spin glasses, Journal of Physics F: Metal Physics 5 (1975), 965–974. Enter, A. van, Fernandez,´ R., Schonmann, R. H., Shlosman, S.
- 110. Complete analyticity of the 2D Potts model above the critical temperature, Communications in Mathematical Physics 189 (1997), 373–393.


Enter, A. van, Fernandez,´ R., Sokal, A.

111. Regularity properties and pathologies of position-space renormalization-group transformations: scope and limitations of Gibbsian theory, Journal of Statistical Physics 72 (1993), 879–1167.

Essam, J. W., Tsallis, C.

112. The Potts model and ﬂows: I. The pair correlation function, Journal of Physics A:

Mathematical and General 19 (1986), 409–422. Ethier, S. N., Kurtz, T. G.

- 113. Markov Processes, Wiley, New York, 1986. Evans, W., Kenyon, C., Peres, Y., Schulman, L. J.
- 114. Broadcasting on trees and the Ising model, Annals of Applied Probability 10 (2000), 410–433. Falconer, K. J.
- 115. The Geometry of Fractal Sets, Cambridge University Press, Cambridge, 1985. Feder, T., Mihail, M.
- 116. Balanced matroids, Proceedings of the 24th ACM Symposium on the Theory of Computing (1992), 26–38. Fernandez,´ R., Ferrari, P. A., Garcia, N. L.
- 117. Loss network representation for Peierls contours, Annals of Probability 29 (2001), 902–937. Fernandez,´ R., Frohlich,¨ J., Sokal, A. D.
- 118. Random Walks, Critical Phenomena, and Triviality in Quantum Field Theory,


Springer, Berlin, 1992. Fontes, L., Newman, C. M.

119. First passage percolation for random colorings of Zd, Annals of Applied Proba-

bility 3 (1993), 746–762; Erratum 4, 254. Fortuin, C. M.

- 120. On the Random-Cluster Model, Doctoral thesis, University of Leiden, 1971.
- 121. On the random-cluster model. II. The percolation model, Physica 58 (1972), 393– 418.
- 122. On the random-cluster model. III. The simple random-cluster process, Physica 59


(1972), 545–570. Fortuin, C. M., Kasteleyn, P. W.

- 123. Ontherandom-clustermodel.I.Introductionandrelationtoothermodels, Physica 57 (1972), 536–564. Fortuin, C. M., Kasteleyn, P. W., Ginibre, J.
- 124. Correlation inequalities on some partially orderedsets, Communications in Math-


ematical Physics 22 (1971), 89–103. Friedgut, E.

125. Inﬂuences in product spaces: KKL and BKKKL revisited, Combinatorics, Proba-

bility, Computing 13 (2004), 17–29. Friedgut, E., Kalai, G.

126. Every monotone graph property has a sharp threshold, Proceedings of the Amer-

ican Mathematical Society 124 (1996), 2993–3002. Gallavotti, G.

127. The phase separation line in the two-dimensional Ising model, Communications in Mathematical Physics 27 (1972), 103–136.

Gallavotti, G., Miracle-Sole,´ S.

128. Equilibrium states of the Ising model in the two-phase region, Physical Review B 5 (1972), 2555–2559.

Gandolﬁ, A., Keane, M., Newman, C. M.

129. Uniqueness of the inﬁnite component in a random graph with applications to percolation and spin glasses, Probability Theory and Related Fields 92 (1992), 511–527.

Gandolﬁ, A., Keane, M., Russo, L.

130. On the uniqueness of the inﬁnite occupied cluster in dependent two-dimensional

site percolation, Annals of Probability 16 (1988), 1147–1157. Garet, O.

131. Central limit theorems for the Potts model, Mathematical Physics Electronic Jour-

nal 11 (2005), Paper 4. Georgii, H.-O.

- 132. Spontaneous magnetization of randomly dilute ferromagnets, Journal of Statistical Physics 25 (1981), 369–396.
- 133. Ontheferromagneticandthepercolativeregionofrandomspinsystems, Advances in Applied Probability 16 (1984), 732–765.
- 134. Gibbs Measures and Phase Transitions, Walter de Gruyter, Berlin, 1988. Georgii, H.-O., Haggstr¨ om,¨ O.
- 135. Phase transition in continuum Potts models, Communications in Mathematical Physics 181 (1996), 507–528.


Georgii, H.-O., Haggstr¨ om,¨ O., Maes, C.

136. The random geometry of equilibrium phases, Phase Transitions and Critical Phenomena (C. Domb, J. L. Lebowitz, eds.), vol. 18, Academic Press, London, 2000, pp. 1–142,.

Georgii, H.-O., Higuchi, Y.

137. Percolation and number of phases in the two-dimensional Ising model, Journal of

Mathematical Physics 41 (2000), 1153–1169. Giacomin, G., Lebowitz, J. L., Maes, C.

138. Agreement percolation and phase coexistence in some Gibbs systems, Journal of

Statistical Physics 80 (1995), 1379–1403. Gielis, G., Grimmett, G. R.

139. Rigidity of the interface in percolation and random-cluster models, Journal of

Statistical Physics 109 (2002), 1–37. Gobron, T., Merola, I.

140. First-order phase transition in Potts models with ﬁnite-range interactions, Journal

of Statistical Physics 126 (2007), 507–583. Graham, B. T., Grimmett, G. R.

- 141. Inﬂuence and sharp-threshold theorems for monotonic measures, Annals of Probability 34 (2006), 1726–1745.
- 142. Random-cluster representation of the Blume–Capel model, Journal of Statistical


Physics 25 (2006), 283–316. Grifﬁths, R. B., Lebowitz, J. L.

143. Random spin systems: some rigorous results, Journal of Mathematical Physics 9

(1968), 1284–1292.

Grimmett, G. R.

144. A theorem about random ﬁelds, Bulletin of the London Mathematical Society 5

(1973), 81–84.

- 145. The rank functions of large random lattices, Journal of London Mathematical Society 18 (1978), 567–575.
- 146. Unpublished (1991).
- 147. Differential inequalities for Potts and random-cluster processes, Cellular Automata and Cooperative Systems (N. Boccara, E. Goles, S. Mart´ınez, P. Picco, eds.), Kluwer, Dordrecht, 1993, pp. 227–236.
- 148. Potts models and random-cluster processes with many-body interactions, Journal of Statistical Physics 75 (1994), 67–121.
- 149. The random-cluster model, Probability, Statistics and Optimisation (F. P. Kelly, ed.), Wiley, Chichester, 1994, pp. 49–63.
- 150. Percolative problems, Probability and Phase Transition (G. R. Grimmett, ed.), Kluwer, Dordrecht, 1994, pp. 69–86.
- 151. Comparisonanddisjoint-occurrenceinequalitiesforrandom-clustermodels,Journal of Statistical Physics 78 (1995), 1311–1324.
- 152. The stochastic random-cluster process and the uniqueness of random-cluster measures, Annals of Probability 23 (1995), 1461–1510.
- 153. Percolation and disordered systems, Ecole d’Ete´ de Probabilites´ de Saint Flour XXVI–1996 (P. Bernard, ed.), Lecture Notes in Mathematics, vol. 1665, Springer, Berlin, 1997, pp. 153–300.
- 154. Percolation, 2nd edition, Springer, Berlin, 1999.
- 155. Inequalities and entanglements for percolation and random-cluster models, Perplexing Problems in Probability; Festschrift in Honor of Harry Kesten (M. Bramson, R. Durrett, eds.), Birkhauser,¨ Boston, 1999, pp. 91–105.
- 156. The random-cluster model, Probability on Discrete Structures (H. Kesten, ed.), EncyclopaediaofMathematicalSciences, vol.110, Springer, Berlin, 2003, pp.73– 123.
- 157. Flows and ferromagnets, Combinatorics, Complexity, and Chance (G. R. Grimmett, C. J. H. McDiarmid, eds.), Oxford University Press, Oxford, 2007, pp. 130– 143.
- 158. Uniqueness and multiplicity of inﬁnite clusters, Dynamics and Stochastics (F. den Hollander, D. Denteneer, E. Verbitskiy, eds.), Institute of Mathematical Statistics, 2006, pp. 24–36.


Grimmett, G. R., Holroyd, A. E.

159. Entanglement in percolation, Proceedings of the London Mathematical Society

81 (2000), 485–512. Grimmett, G. R., Janson, S.

160. Branching processes, and random-cluster measures on trees, Journal of the Euro-

pean Mathematical Society 7 (2005), 253–281. Grimmett, G. R., Marstrand, J. M.

161. The supercritical phase of percolation is well behaved, Proceedings of the Royal

Society (London), Series A 430 (1990), 439–457. Grimmett, G. R., Newman, C. M.

162. Percolation in ∞ + 1 dimensions, Disorder in Physical Systems (G. R. Grimmett, D. J. A. Welsh, eds.), Oxford University Press, Oxford, 1990, pp. 219–240.

Grimmett, G. R., Piza, M. S. T.

163. Decay of correlations in subcritical Potts and random-cluster models, Communi-

cations in Mathematical Physics 189 (1997), 465–480. Grimmett, G. R., Stirzaker, D. R.

164. Probability and Random Processes, 3rd edition, Oxford University Press, Oxford, 2001.

Grimmett, G. R., Winkler, S. N.

165. Negative association in uniform forests and connected graphs, Random Structures

and Algorithms 24 (2004), 444–460. Haggstr¨ om,¨ O.

- 166. Random-cluster measures and uniform spanning trees, Stochastic Processes and their Applications 59 (1995), 267–275.
- 167. The random-cluster modelonahomogeneous tree, ProbabilityTheoryandRelated Fields 104 (1996), 231–253.
- 168. Almost sure quasilocality fails for the random-cluster model on a tree, Journal of Statistical Physics 84 (1996), 1351–1361.
- 169. Random-cluster representations in the study of phase transitions, Markov Processes and Related Fields 4 (1998), 275–321.
- 170. Positive correlations in the fuzzy Potts model, Annals of Applied Probability 9


(1999), 1149–1159.

171. A monotonicity result for hard-core and Widom–Rowlinson models on certain ddimensional lattices, Electronic Communications in Probability 7 (2002), 67–78. 172. IsthefuzzyPottsmodelGibbsian,Annalesdel’InstitutHenriPoincare,Probabilit´ es´

et Statistiques 39 (2002), 891–917.

173. Finite Markov Chains and Algorithmic Applications, Cambridge University Press, Cambridge, 2002.

Haggstr¨ om,¨ O., Jonasson, J., Lyons, R.

- 174. Explicitisoperimetricconstantsandphasetransitionsintherandom-clustermodel, Annals of Probability 30 (2002), 443–473.
- 175. Coupling and Bernoullicity in random-cluster and Potts models, Bernoulli 8


(2002), 275–294. Haggstr¨ om,¨ O., Peres, Y.

176. Monotonicity and uniqueness for percolation on Cayley graphs: all inﬁnite clusters are born simultaneously, Probability Theory and Related Fields 113 (1999), 273–285.

Hammersley, J. M.

- 177. Percolation processes. Lower bounds for the critical probability, Annals of Mathematical Statistics 28 (1957), 790–795.
- 178. AMonteCarlosolutionofpercolationinacubiclattice, MethodsinComputational Physics, Volume 1 (B. Alder, S. Fernbach, M. Rotenberg, eds.), Academic Press, London, 1963, pp. 281–298.


Hara, T., Slade, G.

- 179. Mean-ﬁeldcriticalbehaviourforpercolationinhighdimensions, Communications in Mathematical Physics 128 (1990), 333–391.
- 180. Thescalinglimitoftheincipientinﬁniteclusterinhigh-dimensionalpercolation.II. Integrated super-Brownian excursion, Journal of Mathematical Physics 41 (2000), 1244–1293.


Harris, T. E.

181. A lower bound for the critical probability in a certain percolation process, Pro-

ceedings of the Cambridge Philosophical Society 56 (1960), 13–20. Higuchi, Y.

182. A sharp transition for the two-dimensional Ising percolation, Probability Theory

and Related Fields 97 (1993), 489–514. Hintermann, D., Kunz, H., Wu, F. Y.

- 183. Exact results for the Potts model in two dimensions, Journal of Statistical Physics 19 (1978), 623–632. Hollander, W. Th. F. den, Keane, M.
- 184. Inequalities of FKG type, Physica 138A (1986), 167–182. Holley, R.
- 185. Remarks on the FKG inequalities, Communications in Mathematical Physics 36


(1974), 227–231. Holley, R., Stroock, D.

186. A martingale approach to inﬁnite systems of interacting particles, Annals of Prob-

ability 4 (1976), 195–228. Hryniv, O.

187. On local behaviour of the phase separation line in the 2D Ising model, Probability

Theory and Related Fields 110 (1998), 91–107. Ioffe, D.

- 188. A note on the extremality of the disordered state for the Ising model on the Bethe lattice, Letters in Mathematical Physics 37 (1996), 137–143.
- 189. A note on the extremality of the disordered state for the Ising model on the Bethe lattice, Trees (B. Chauvin, S. Cohen, A. Roualt, eds.), Birkhauser,¨ Basel, 1996, pp. 3–14.


Ising, E.

190. Beitrag zur Theorie des Ferromagnetismus, Zeitschrift fur Physik¨ 31 (1925), 253–

258. Jagers, P.

- 191. Branching Processes with Biological Applications, Wiley, Chichester, 1975. Janson, S.
- 192. Multicyclic components in a random graph process, Random Structures and Algorithms 4 (1993), 71–84. Janson, S., Knuth, D. E., Łuczak, T., Pittel, B.
- 193. The birth of the giant component, Random Structures and Algorithms 4 (1993), 233–358. Janson, S., Łuczak, T., Rucinski,´ A.
- 194. Random Graphs, Wiley, New York, 2000. Jerrum, M.
- 195. Mathematical foundations of the Markov chain Monte Carlo method, Probabilistic Methods for Algorithmic Discrete Mathematics (M. Habib, C. McDiarmid, J. Ramirez-Alfonsin, B. Reed, eds.), Springer, Berlin, 1998, pp. 116–165.


Jonasson, J.

196. The random cluster model on a general graph and a phase transition characterization of nonamenability, Stochastic Processes and their Applications 79 (1999), 335–354.

Jonasson, J., Steif, J.

197. Amenability and phase transition in the Ising model, Journal of Theoretical Prob-

ability 12 (1999), 549–559. Jossang,¨ P., Jossang,¨ A.

198. Monsieur C. S. M. Pouillet, de l’Acad´emie, qui d´ecouvrit le point “de Curie” en

. . . 1832, http://www.tribunes.com/tribune/art97/jos2f.htm, Science Tribune (1997).

Kahn, J.

- 199. A normal law for matchings, Combinatorica 20 (2000), 339–391. Kahn, J., Kalai, G., Linial, N.
- 200. The inﬂuence of variables on Boolean functions, Proceedings of 29th Symposium on the Foundations of Computer Science, Computer Science Press, 1988, pp. 68– 80.


Kalai, G., Safra, S.

201. Threshold phenomena and inﬂuence, Computational Complexity and Statistical Physics (A. G. Percus, G. Istrate, C. Moore, eds.), Oxford University Press, New York, 2006.

Kasai, J., Okiji, A.

202. Percolation problem describing ±J Ising spin glass system, Progress in Theoret-

ical Physics 79 (1988), 1080–1094. Kasteleyn, P. W., Fortuin, C. M.

203. Phase transitions in lattice systems with random local properties, Journal of the

Physical Society of Japan 26, (1969), 11–14, Supplement. Kemperman, J. H. B.

204. OntheFKG-inequalityformeasuresonapartiallyorderedset, IndagationesMath-

ematicae 39 (1977), 313–331. Kesten, H.

- 205. Symmetric random walks on groups, Transactions of the American Mathematical Society 92 (1959), 336–354.
- 206. Full Banach mean values on countable groups, Mathematica Scandinavica 7 (1959), 146–156.
- 207. The critical probability of bond percolation on the square lattice equals 21, Communications in Mathematical Physics 74 (1980), 41–59.

![image 1351](<rcm1-1_images/imageFile1351.png>)

- 208. On the time constant and path length of ﬁrst-passage percolation, Advances in Applied Probability 12 (1980), 848–863.
- 209. Analyticity properties and power law estimates in percolation theory, Journal of Statistical Physics 25 (1981), 717–756.
- 210. Percolation Theory for Mathematicians, Birkhauser,¨ Boston, 1982.
- 211. Aspects of ﬁrst-passage percolation, Ecole d’Ete´ de Probabilites´ de Saint Flour XIV-1984 (P. L. Hennequin, ed.), Lecture Notes in Mathematics, vol. 1180, Springer, Berlin, 1986, pp. 125–264.


Kesten, H., Schonmann, R. H.

212. Behavior in large dimensions of the Potts and Heisenberg models, Reviews in

Mathematical Physics 1 (1990), 147–182. Kihara, T., Midzuno, Y., Shizume, J.

213. Statistics of two-dimensional lattices with many components, Journal of the Physical Society of Japan 9 (1954), 681–687.

Kim, D., Joseph, R. I.

214. Exact transition temperatures for the Potts model with q states per site for the triangular and honeycomb lattices, Journal of Physics C: Solid State Physics 7

(1974), L167–L169. Kirchhoff, G.

215. Uber¨ die Auﬂ¨osung der Gleichungen, auf welche man bei der Untersuchung der linearen Verteilung galvanischer Strome gefuhrt wird, Annalen der Physik und Chemie 72 (1847), 497–508.

Kotecky,´ R.

- 216. Geometric representations of lattice models and large volume asymptotics, ProbabilityandPhaseTransition(G.R.Grimmett,ed.),Kluwer, Dordrecht,pp.153–176.
- 217. Phase transitions: on a crossroads of probability and analysis, Highlights of Mathematical Physics (A. Fokas, J. Halliwell, T. Kibble, B. Zegarlinski, eds.), American Mathematical Society, Providence, RI, 2002, pp. 191–207.


Kotecky,´ R., Laanait, L., Messager, A., Ruiz, J.

218. The q-state Potts model in the standard Pirogov–Sinai theory: surface tension and

Wilson loops, Journal of Statistical Physics 58 (1990), 199–248. Kotecky,´ R., Preiss, D.

219. Cluster expansion for abstract polymer models, Communications in Mathematical

Physics 103 (1986), 491–498. Kotecky,´ R., Shlosman, S.

220. First order phase transitions in large entropy lattice systems, Communications in

Mathematical Physics 83 (1982), 493–515. Kramers, H. A., Wannier, G. H.

221. Statistics of the two-dimensional ferromagnet, I, II, The Physical Review 60

(1941), 252–276. Krengel, U.

- 222. Ergodic Theorems, Walter de Gruyter, Berlin, 1985. Kuratowski, K.
- 223. Topology, Volume 2, Academic Press, New York, 1968. Laanait, L., Messager, A., Miracle-Sole,´ S., Ruiz, J., Shlosman, S.
- 224. Interfaces in the Potts model I: Pirogov–Sinai theory of the Fortuin–Kasteleyn


representation, Communications in Mathematical Physics 140 (1991), 81–91. Laanait, L., Messager, A., Ruiz, J.

225. Phase coexistence and surface tensions for the Potts model, Communications in

Mathematical Physics 105 (1986), 527–545. Lanford, O. E., Ruelle, D.

226. Observables at inﬁnity and states with short range correlations in statistical me-

chanics, Communications in Mathematical Physics 13 (1969), 194–215. Langlands, R., Pouliot, P., Saint-Aubin, Y.

227. Conformal invariance in two-dimensional percolation, Bulletin of the American

Mathematical Society 30 (1994), 1–61. Lawler, G. F., Schramm, O., Werner, W.

- 228. The dimension of the planar Brownian frontier is 4/3, Mathematics Research Letters 8 (2001), 401–411.
- 229. Values of Brownian intersection exponents III: Two-sided exponents, Annales de l’Institut Henri Poincare,´ Probabilites´ et Statistiques 38 (2002), 109–123.


230. One-arm exponent for critical 2D percolation, Electronic Journal of Probability 7

(2002), Paper 2.

231. Conformal invariance of planar loop-erased random walks and uniform spanning

trees, Annals of Probability 32 (2004), 939–995. Lebowitz, J. L., Gallavotti, G.

232. Phase transitions in binary lattice gases, Journal of Mathematical Physics 12

(1971), 1129–1133. Lebowitz, J. L., Martin-Lof,¨ A.

233. On the uniqueness ofthe equilibrium state for Ising spin systems, Communications

in Mathematical Physics 25 (1972), 276–282. Lieb, E. H.

234. A reﬁnement of Simon’s correlation inequality, Communications in Mathematical

Physics 77 (1980), 127–135. Liggett, T. M.

- 235. Interacting Particle Systems, Springer, Berlin, 1985. Liggett, T. M., Steif, J.
- 236. Stochastic domination: the contact process, Ising models, and FKG measures, Annales de l’Institut Henri Poincare,´ Probabilites´ et Statistiques 42 (2006), 223– 243. Lindvall, T.
- 237. Lectures on the Coupling Method, Wiley, New York, 1992. Luczak, M., Łuczak, T.
- 238. The phase transition in the cluster-scaled model of a random graph, Random


Structures and Algorithms 28 (2006), 215–246. Łuczak, T., Pittel, B., Wierman, J. C.

239. The structure of a random graph at the point of the phase transition, Transactions

of the American Mathematical Society 341 (1994), 721–748. Lyons, R.

240. Phase transitions on nonamenable graphs, Journal of Mathematical Physics 41

(2001), 1099–1126. Lyons, R., Peres, Y.

241. Probability on Trees and Networks, http://mypage.iu.edu/∼rdlyons/

prbtree/prbtree.html, 2009. Lyons, R., Schramm, O.

242. Indistinguishabilityofpercolationclusters,AnnalsofProbability 27(1999),1809– 1836.

MacKay, D. J. C.

243. Information Theory, Inference, and Learning Algorithms, Cambridge University

Press, Cambridge, 2003. Madras, N., Slade, G.

- 244. The Self-Avoiding Walk, Birkhauser,¨ Boston, 1993. Maes, C., Vande Velde, K.
- 245. The fuzzy Potts model, Journal of Physics A: Mathematical and General 28 (1995), 4261–4271.


Magalhaes,˜ A. C. N. de, Essam, J. W.

- 246. The Potts model and ﬂows. II. Many-spin correlation function, Journal of Physics A: Mathematical and General 19 (1986), 1655–1679.
- 247. The Potts model and ﬂows. III. Standard and subgraph break-collapse methods,


Journal of Physics A: Mathematical and General 21 (1988), 473–500. Martin, J.

248. Reconstruction thresholds on regular trees, Discrete Mathematics and Theoretical Computer Science, Proceedings AC (C. Banderier, C. Krattenthaler, eds.), 2003, pp. 191–204.

Martinelli, F.

249. LecturesonGlauberdynamicsfordiscretespinmodels,Ecoled’EtedeProbabilit´ es´ de Saint Flour XXVII–1997 (P. Bernard, ed.), Lecture Notes in Mathematics, vol. 1717, Springer, Berlin, 1999, pp. 93–191.

Martinelli, F., Sinclair, A., Weitz, D.

250. Glauber dynamics on trees: Boundary conditions and mixing time, Communica-

tions in Mathematical Physics 250 (2004), 310–334. Martirosian, D. H.

251. Translation invariant Gibbs states in the q-state Potts model, Communications in

Mathematical Physics 105 (1986), 281–290. McCoy, B. M., Wu, T. T.

252. The two-dimensional Ising model, Harvard University Press, Cambridge, MA,

1973. Meester, R., Roy, R.

- 253. Continuum Percolation, Cambridge University Press, Cambridge, 1996. Messager, A., Miracle-Sole,´ S., Ruiz, J., Shlosman, S.
- 254. Interfaces in the Potts model. II. Antonov’s rule and rigidity of the order disorder interface, Communications in Mathematical Physics 140 (1991), 275–290. Moran, P. A. P.
- 255. An Introduction to Probability Theory, Clarendon Press, Oxford, 1968. Mossel, E.
- 256. Survey: Information ﬂow on trees, Graphs, Morphisms and Statistical Physics (J. Nesetˇ ˇril, P. Winkler, eds.), American Mathematical Society, DIMACS, 2004, pp. 155–170.


Mossel, E., O’Donnell, R., Regev, O., Steif, J., Sudakov, B.

257. Non-interactive correlation distillation, inhomogeneous Markov chains, and the reverse Bonami–Beckner inequality, Israel Journal of Mathematics 154 (2006), 299–336.

Nachtergaele, B.

258. A stochastic geometric approach to quantum spin systems, Probability and Phase

Transition (G. R. Grimmett, ed.), Kluwer, Dordrecht, 1994, pp. 237–246. Newman, C. M.

- 259. Disordered Ising systems and random cluster representations, Probability and Phase Transition (G. R. Grimmett, ed.), Kluwer, Dordrecht, 1994, pp. 247–260.
- 260. Topics in Disordered Systems, Birkhauser,¨ Boston, 1997. Newman, C. M., Schulman, L. S.
- 261. Inﬁnite clusters in percolation models, Journal of Statistical Physics 26 (1981), 613–628.


Newman, C. M., Stein, D. L.

- 262. Short-range spin glasses: results and speculations, Spin Glass Theory (E. Bolthausen, A. Bovier, eds.), Springer, Berlin, 2007, pp. 159–175.
- 263. Short-range spin glasses: selected open problems, Mathematical Statistical Physics (A. Bovier, F. Dunlop, A. van Enter, F. den Hollander, J. Dalibard, eds.), Proceedings of 2005 Les Houches Summer School LXXXIII, Elsevier, 2006, pp. 273–284.


Onsager, L.

264. Crystal statistics, I. A two-dimensional model with an order–disorder transition,

The Physical Review 65 (1944), 117–149. Paterson, A. L. T.

- 265. Amenability, American Mathematical Society, Providence, RI, 1988. Peierls, R.
- 266. On Ising’s model of ferromagnetism, Proceedings of the Cambridge Philosophical


Society 36 (1936), 477–481. Pemantle, R.

- 267. The contact process on trees, Annals of Probability 20 (1992), 2089–2116.
- 268. Towards a theory of negative dependence, Journal of Mathematical Physics 41


(2000), 1371–1390. Petritis, D.

269. Equilibrium statistical mechanics of frustrated spin glasses: a survey of mathematical results, Annales de l’Institut Henri Poincare,´ Physique Theorique´ 84

(1996), 255–288. Pﬁster, C.-E.

- 270. Translation invariant equilibrium states of ferromagnetic abelian lattice systems, Communications in Mathematical Physics 86 (1982), 375–390.
- 271. Phase transitions in the Ashkin–Teller model, Journal of Statistical Physics 29


(1982), 113–116. Pﬁster, C.-E., Vande Velde, K.

272. Almost sure quasilocality in the random cluster model, Journal of Statistical Phy-

sics 79 (1995), 765–774. Pﬁster, C.-E., Velenik, Y.

273. Random-cluster representation for the Ashkin–Teller model, Journal of Statistical

Physics 88 (1997), 1295–1331. Pirogov, S. A., Sina˘ı, Ya. G.

- 274. Phase diagrams of classicallattice systems, Theoretical andMathematical Physics 25 (1975), 1185–1192.
- 275. Phase diagrams of classical lattice systems, continuation, Theoretical and Math-


ematical Physics 26 (1976), 39–49. Pisztora, A.´

276. Surface order large deviations for Ising, Potts and percolation models, Probability

Theory and Related Fields 104 (1996), 427–466. Pittel, B.

277. On tree census and the giant component of sparse random graphs, Random Structures and Algorithms 1 (1990), 311–342.

Potts, R. B.

278. Some generalized order–disorder transformations, Proceedings of the Cambridge

Philosophical Society 48 (1952), 106–109. Preston, C. J.

- 279. Gibbs States on Countable Sets, Cambridge University Press, Cambridge, 1974.
- 280. A generalization of the FKG inequalities, Communications in Mathematical Phys-


ics 36 (1974), 233–241. Procacci, A., Scoppola, B.

281. Convergent expansions for random cluster model with q > 0 on inﬁnite graphs,

Communications on Pure and Applied Analysis 5 (2008), 1145–1178. Propp, J. G., Wilson, D. B.

282. Exact sampling with coupled Markov chains and applications to statistical me-

chanics, Random Structures and Algorithms 9 (1996), 223–252. Reimer, D.

283. Proof of the van den Berg–Kesten conjecture, Combinatorics, Probability, Com-

puting 9 (2000), 27–32. Rohde, S., Schramm, O.

- 284. Basic properties of SLE, Annals of Mathematics 161 (2005), 879–920. Ruelle, D.
- 285. Existence of a phase transition in a continuous classical system, Physical Review


Letters 26 (1971), 303–304. Russo, L.

- 286. A note on percolation, Zeitschrift fur¨ Wahrscheinlichkeitstheorie und Verwandte Gebiete 43 (1978), 39–48.
- 287. Onthecriticalpercolationprobabilities,ZeitschriftfurWahrscheinlichkeitstheorie¨


und Verwandte Gebiete 56 (1981), 229–237. Sakai, A.

288. Lace expansion for the Ising model, Communications in Mathematical Physics

272 (2007), 283–344. Salas, J., Sokal, A. D.

289. Dynamic critical behavior of a Swendsen–Wang-type algorithm for the Ashkin–

Teller model, Journal of Statistical Physics 85 (1996), 297–361. Schlicting, G.

290. Polynomidentit¨aten und Permutationsdarstellungen lokalkompakter Gruppen, In-

ventiones Mathematicae 55 (1979), 97–106. Schneider, R.

291. Convex Bodies: The Brunn–Minkowski Theory, Cambridge University Press,

Cambridge, 1993. Schonmann, R. H.

- 292. Metastability and the Ising model, Documenta Mathematica, Extra volume (G. Fischer, U. Rehmann, eds.), Proceedings of the International Congress of Mathematicians, Berlin 1998, vol. III, pp. 173–181.
- 293. Multiplicity ofphase transitions andmean-ﬁeldcriticality onhighly non-amenable


graphs, Communications in Mathematical Physics 219 (2001), 271–322. Schramm, O.

294. Scaling limits of loop-erased walks and uniform spanning trees, Israel Journal of Mathematics 118 (2000), 221–288.

295. Conformally invariant scaling limits: an overview and collection of open problems, Proceedings of the International Congress of Mathematicians, Madrid (M. Sanz-Sole´ et al., eds.), vol. I, European Mathematical Society, Zurich, 2007, pp. 513–544.

Schramm, O., Shefﬁeld, S.

- 296. Harmonic explorer and its convergence to SLE4, Annals of Probability 33 (2005), 2127–2148.
- 297. Contour lines of the 2D Gaussian free ﬁeld, Acta Mathematica (2009) (to appear). Seppal¨ ainen,¨ T.
- 298. Entropy for translation-invariant random-cluster measures, Annals of Probability 26 (1998), 1139–1178. Sharpe, M.
- 299. General Theory of Markov Processes, Academic Press, San Diego, 1988. Simon, B.
- 300. Correlation inequalities and the decay of correlations in ferromagnets, Commu-


nications in Mathematical Physics 77 (1980), 111–126. Sina˘ı, Y. G.

- 301. Theory of Phase Transitions: Rigorous Results, Pergamon Press, Oxford, 1982. Slade, G.
- 302. Bounds on the self-avoiding walk connective constant, Journal of Fourier Analysis and its Applications, Special Issue: Proceedings of the Conference in Honor of Jean-Pierre Kahane, 1993 (1995), 525–533.
- 303. The lace expansion and its applications, Ecole d’Ete de Probabilit´ es de Saint Flour´ XXXIV-2004 (J. Picard, ed.), Lecture Notes in Mathematics, vol. 1879, Springer, Berlin, 2006.


Smirnov, S.

- 304. Critical percolation in the plane: conformal invariance, Cardy’s formula, scaling limits, Comptes Rendus des Seances´ de l’Academie´ des Sciences. Serie´ I. Mathematique´ 333 (2001), 239–244.
- 305. Critical percolation in the plane. I. Conformal invariance and Cardy’s formula. II. Continuum scaling limit, http://www.unige.ch/∼smirnov/papers/ percol.ps (2001).
- 306. Towards conformal invariance of 2D lattice models, Proceedings of the International Congress of Mathematicians, Madrid, 2006 (M. Sanz-Sole´ et al., eds.), vol. II, European Mathematical Society, Zurich, 2007, pp. 1421–1452.


Smirnov, S., Werner, W.

307. Critical exponents for two-dimensional percolation, Mathematics Research Let-

ters 8 (2001), 729–744. Sokal, A.

308. The multivariate Tutte polynomial (alias Potts model) for graphs and matroids, Surveys in Combinatorics, 2005 (B. S. Webb, ed.), Cambridge University Press, Cambridge, 2005, pp. 173–226.

Stigler, S. M.

309. Stigler’s law of eponymy, Transactions of the New York Academy of Sciences 39

(1980), 147–157; Reprinted in Statistics on the Table, by Stigler, S. M. (1999), Harvard University Press, Cambridge, MA.

Swendsen, R. H., Wang, J. S.

310. Nonuniversal critical dynamics in Monte Carlo simulations, Physical Review Let-

ters 58 (1987), 86–88. Sykes, M. E., Essam, J. W.

311. Exact critical percolation probabilities for site and bond problems in two dimen-

sions, Journal of Mathematical Physics 5 (1964), 1117–1127. Troﬁmov, V. I.

312. Automorphism groups of graphs as topological groups, Mathematical Notes 38

(1985), 717–720. Tutte, W. T.

- 313. Graph Theory, ﬁrst published in 1984, Cambridge University Press, Cambridge, 2001. Welsh, D. J. A.
- 314. Percolation in the random-cluster process, Journal of Physics A: Mathematical


and General 26 (1993), 2471–2483. Welsh, D. J. A., Merino, C.

315. The Potts model and the Tutte polynomial, Journal of Mathematical Physics 41

(2000), 1127–1152. Werner, W.

316. Random planar curves and Schramm–Loewner evolutions, Ecole d’Ete´ de Probabilites´ de Saint Flour XXXII–2002 (J. Picard, ed.), Lecture Notes in Mathematics, vol. 1840, Springer, Berlin, 2004, pp. 107–195.

Whittle, P. W.

- 317. Systems in Stochastic Equilibrium, Wiley, Chichester, 1986.
- 318. Polymer models and generalized Potts–Kasteleyn models, Journal of Statistical


Physics 75 (1994), 1063–1092. Widom, B., Rowlinson, J. S.

319. New model for the study of liquid–vapor phase transition, Journal of Chemical

Physics 52 (1970), 1670–1684. Wilson, R. J.

- 320. Introduction to Graph Theory, Longman, London, 1979. Wiseman, S., Domany, E.
- 321. Cluster method for the Ashkin–Teller model, Physical Review E 48 (1993), 4080–


4090. Wolff, U.

322. Collective Monte Carlo updating for spin systems, Physical Review Letters 62

(1989), 361–364. Wood, De Volson

- 323. Problem 5, American Mathematical Monthly 1 (1894), 99, 211–212. Wu, F. Y.
- 324. The Potts model, Reviews in Modern Physics 54 (1982), 235–268. Wulff, G.
- 325. Zur Frage der Geschwindigkeit des Wachsturms und der Auﬂ¨osung der Krys-


tallﬂ¨achen, Zeitschrift fur¨ Krystallographie und Mineralogie 34 (1901), 449–530. Zahradn´ık, M.

326. An alternate version of Pirogov–Sinai theory, Communications in Mathematical Physics 93, 559–581.

Bollobas,´ B., Riordan, O.

327. Percolation on dual lattices with k-fold symmetry, Random Structures and Algo-

rithms 32 (2008), 463–472. Graham, B. T., Grimmett, G. R.

- 328. Sharp thresholds for the random-cluster and Ising models (2009). Grimmett, G. R.
- 329. Probability on Graphs, http://www.statslab.cam.ac.uk/∼grg/books/


pgs.html, 2009. Werner, W.

330. Percolation et Mod´ele d’Ising, 2009.

## Subject Index

adjacency 15 admissibility 211 alarm clock 226, 232, 254 altitude 210 amenability 315 anti-ferromagnet 333, 347 Ashkin–Teller model 2, 20, 326, 346 A.–T. random-cluster model 327 Gibbs state for A.-T. model 326

automorphism 41, 74, 315, 162 acting transitively 41 a.-invariance 302 a. with inﬁnite orbit 316 group 74, 315

base 210 Blume–Capel(–Potts) model 323 Boel–Kasteleyn inequalities 266 boundary 17

1-edge-b. 174 edge-b. 17 external edge-b. 174 internal edge-b. 174 upper/lower b. 197 vertex-b. 174

boundary conditions 70, 237, 299

free, wired b. c. 71, 301 box 18, 301

crossings on square lattice 137 bubble condition 275 c-plaquette 208 Cardy formula 164 Cayley graph 316

ceiling 208 chessboard estimate 179 chromatic polynomial 347 circuit 17 closed edge 3, 4, 15 closure of set of plaquettes 170 cluster 17 cluster-weighting factor 3 co-connected set 177 comparison inequalities 43, 77 complement 16 complete graph 277 conﬁguration 15

frustrated 334 (in)comparable c. 26 maximum, minimum c. 20 partial order 16

conformal ﬁeld theory 165 connected subgraph 13 connective constant 145 connectivity function 11

exponential decay of c. f. 112 continuous random variable 19 contour 173

compatible c. 177 externally-compatible c. 177 free/wired c. 175

convexity 56 co-rank of subgraph 258 correlation

c./connection theorem 11 c. function 11 c. length 115

coupling 20, 226

c. from the past 227 c. of random-cluster and Potts models

8, 95 critical exponent 273, 275, 296 critical point 99

for uniqueness of inﬁnite cluster 318 Lipschitz continuity of c. p. 99 of complete graph 278 of hexagonal lattice 162 of inhomogeneous square lattice 155 of triangular lattice 162 of square lattice 138 of tree 306 slab critical point 124

cubic lattice 18 Curie point 6 cutset 194, 301 cycle 17 cylinder function, event 15

decreasing event, random variable 16, 19, 236

degree d. of spanning set 43 d. of vertex 58

detailed balance equations 224 dichromatic polynomial 53 discrete Fourier transform 30 disjoint-occurrence property 64 disordered Potts ferromagnet 330 DLR-random-cluster-measure 78, 302 Dobrushin

boundary condition 197 interface 195

edge co-connected set 177 contraction/deletion of e. 37, 346 e.-boundary 17 e.-transitivity 153 in parallel/series 62, 307, 342

edge-negative-association 63 Edwards–Anderson spin-glass model

333 Gibbs state for E.–A. model 335 uniqueness of Gibbs states 335

electrical network 15, 66, 342

parallel/series laws 342 equator 197

equivalence relation 299, 300 measurability of e. r. 302 Erdos–R˝ enyi´ random graph 278, 299 event

A-invariant e. 34 exploration process 165 exponential alarm clock 226, 232 exponential decay

of radius 112, 113, 125 in two dimensions 143

of volume 119 exponential-steepness theorem 36, 49 externally compatible contours 177

Feller process 244, 252 ferromagnetism 7 ﬁnite-energy property 36, 38, 73, 79,

80, 111 positive f. e. 256

ﬁrst-order phase transition 144, 182

in two dimensions 145 FK representation 3 FKG

inequality 25, 341, 347 strong FKG 27 lattice condition/property 25

ﬂow f. polynomial 258 mod-q f. 258

forest 13 four-colour problem 347 free contour 175 frustrated conﬁguration 334

Gaussian free ﬁeld 166 Gibbs sampler 222, 223, 225, 227

coupled 232

Gibbs state 7, 124, 183 for Ashkin–Teller model 326 for Edwards–Anderson model 335 for Potts model 322 for Widom–Rowlinson model 338

Glauber dynamics 6, 222, 224 graph 15

amenable g. 315 Cayley g. 316 complete g. 277 directed g. 257 edge-transitive g. 153

even g. 262 locally ﬁnite g. 74 (quasi-)transitive g. 315 unimodular g. 315 graphical methods 320 Hamiltonian 7 Hammersley–Simon–Lieb inequality

266 Hamming distance 16 harmonic explorer 166 heat-bath algorithm 223, 225 height 210 Heisenberg model 8 hexagonal lattice 154 Holley inequality 20 hull 164 hypercontractivity 30

increasing event, random variable 16,

19, 236 indicator function 15 inﬂuence

i. of edge 30 i. theorem 30

insertion tolerance 38, 318 uniform i.-t. 111

interface 201 extended i. 201 localized i. 218 regular i. 201 semi-extended i. 208 vertical displacement of i. 219 Ising model 1, 6, 57, 115, 138, 195,

223, 260, 273, 343 on tree 314 with real-valued interactions 333

isoperimetric constant 315 Kirchhoff theorem 15, 66 lace expansion 274 large deviations 53, 298 lattice 18, 152

cubic l. 18 hexagonal l. 154 labelled l. 162 square l. 133 triangular l. 154

lattice gas Potts l. g. 323 Widom–Rowlinson l. g. 337

level-set process 232, 234, 241 Lieb inequality 268 limit random-cluster measure 72 local moves 224 localization 218 loop-erased random walk 165

Markov chain 21, 45, 224

reversible M. c. 21, 224 martingale method 241 mass gap 145, 182, 267, 270 mean-ﬁeld

bound 273 theory 276

mixing property 75, 317 mod-q ﬂow 258 monotonic measure 27 Monte Carlo Markov chain 222

n-vector model 8 negative association 63 non-translation-invariant measures 199 normalizing constant 4

O(n) model 8 one-point speciﬁcation 317 open

cluster 17 edge 3, 4, 15

origin 18 of group of standard walls 211 of standard wall 211

parallel/series laws 62, 307, 342 partial order 16, 19, 234 partition function 4, 53

convexity of p. f. 56 path 16 Peierls estimate 181 percolation

model 2, 4, 343 p. probability 98

continuity of p. p. 102 phase transition 98

ﬁrst/second order p. t. 144

in two dimensions 145 Pirogov–Sinai method 182 planar

duality 133, 137 graph 133

plaquette 168, 169 c-plaquette 208 horizontal, vertical p. 201 s-connectivity 168, 169 w-plaquette 208

Poisson random graph 259 polymer 174, 179 positive association 25, 39, 69, 73, 80

strong p.-a. 27 Potts lattice gas 323 Potts model 1, 6, 102, 183, 222, 223,

231, 257, 321 anti-ferromagnetic P. m. 347 disordered P. ferromagnet 330 Gibbs state for P. m. 322 on complete graph 278 on inﬁnite graph 95

pressure 86, 175, 284, 295, 297 convexity of p. 86

probability measure 1-monotonic p. m. 27 A-invariant p. m. 34 automorphism-invariance 302 edge-negative-association 63 ergodicity 74 ﬁnite-energy property 79 invariant p. m. 74 mixing property 75, 317 monotonic p. m. 27 positively associated p. m. 25, 39 strictly positive p. m. 20 tail-triviality 75, 316 translation-invariant p. m. 75

product measure 4, 263 quantum spin systems 321 quasilocality 79

radius 110 exponential decay of r. 112, 113, 125

in two dimensions 143 random graph 4, 278, 299 random interactions 330

random variable continuous r. v. 19 decreasing r. v. 16 increasing r. v. 16 invariant r. v. 74 semicontinuity 68 translation invariance 75

random-cluster measure 4 automorphism invariance 75 box crossings when d = 2 137 comparison inequalities 43, 77 conditional measures 37 differential formulae 41, 199 DLR measure 78 domination by Ising measure 59 ergodicity 75 exponential steepness 49 extremality 75, 80, 302 limit measure 72 mixing property 75, 317 nesting property 70 non-translation-invariant measure 199 parallel/series laws 62, 307 positive association 39 site-r. c. measure 338 tail-triviality 75 uniqueness 107

in two dimensions 138 when q < 1 131 random-cluster model 346

on complete graph 277 critical case 282 critical exponent 296 critical point 278 large deviations 298 largest component 286 pressure 284, 295, 297 subcritical case 281 supercritical case 281

on lattice 67, 70 on non-amenable graph 315

critical point for uniqueness 318 multiplicity of phases 319

on tree 299 critical point 306 (non-)uniqueness of measures 277,

313 percolation probability 307 random-current representation 260, 273

rank (co-)r. of subgraph 258 r.-generating function 53, 258

ray 299 Rayleigh principle 66 reﬂection-positivity 96 Reimer inequality 64 roughening transition 197 Russo formula 33

s-connectedness 168, 169, 175 self-dual point 108, 135 semicontinuity 68, 77 series/parallel laws 62, 307, 342 sharp threshold theorem 34, 42 Simon inequality 265 simultaneous uniqueness 256 site-random-cluster measure 338 slab critical point 124 SLE 15, 164 spanning

s. subgraph 13 s. tree 13 s. vertex-set 43

spin-glass model 333 Gibbs state for E.–A. model 335 on tree 314 uniqueness of Gibbs states 335

splitting set 170 sprinkling lemma 50 square lattice 133 stabilizer 315 standard wall 210

admissible family of s. walls 211 group of s. walls 211

star–triangle transformation 62, 159 Stigler’s Law 6 stochastic Lowner¨ evolution 15, 164 stochastic ordering 19, 68, 71, 80 Strassen theorem 20 subcritical phase 110 supercritical phase 122 susceptibility 273 Swendsen–Wang algorithm 222, 230

switching lemma 264 τ-functional 180 tail

σ-ﬁeld 16, 316 t.-triviality 75, 316 thermodynamic limit 18 Thomson/Dirichlet principle 66 time-constant 114

positive t.-c. 115

transitive edge-t. graph 153 t. action 34, 41 t. graph 41, 315

translation 75 triangle condition 274 triangular lattice 154, 164 Tutte polynomial 53, 257, 258 two-point function 11

uniform connected subgraph (UCS) 13, 64 spanning tree (UST) 2, 3, 13, 65,

165, 166

(spanning) forest (USF) 13, 64 uniqueness

u. of inﬁnite open cluster 123, 318 simultaneous u. 256

u. of random-cluster measure 107 in two dimensions 138 when q < 1 131

unimodularity 315 w-plaquette 208 wall 208

standard w. 210 Whitney polynomial 53, 258 Widom–Rowlinson lattice gas 337

Gibbs state for W.–R. model 338 lattice model 338

wired contour 175 Wulff crystal 122, 126

zero/one-inﬁnite-cluster property 79

c Springer-Verlag 2006

