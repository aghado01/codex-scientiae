<a id="ch-8"></a>

# 8. Dynamics of Random-Cluster Models

## Table of Contents

- [Time-evolution of the random-cluster model](#sec-8-8-1)
- [Glauber dynamics](#sec-8-8-2)
- [Gibbs sampler](#sec-8-8-3)
- [Coupling from the past](#sec-8-8-4)
- [Swendsen–Wang dynamics](#sec-8-8-5)
- [Coupled dynamics on a finite graph](#sec-8-8-6)
- [Box dynamics with boundary conditions](#sec-8-8-7)
- [Coupled dynamics on the infinite lattice](#sec-8-8-8)
- [Simultaneous uniqueness](#sec-8-8-9)


Summary. Onemayassociatetime-dynamicswiththerandom-clustermodel in a variety of natural ways. Amongst Glauber-type processes, the Gibbs sampler is especially useful and is well suited to the construction of a ‘coupling from the past’ algorithm resulting in a sample with the randomcluster measure as its (exact) law. In the Swendsen–Wang algorithm, one interleaves transitions of the random-cluster model and the associated Potts model. The random-cluster model for different values of $p$ may be coupled together via a certain Markov process on a more general state space. This provides a mechanism for studying the ‘equilibrium’ model.

<a id="sec-8-1"></a>

## 8.1 Time-evolution of the random-cluster model

The random-cluster model as studied so far is random in space but not in time. Therearea variety of ways of introducing time-dynamics into the model,and some good reasons for so doing. The principal reason is that, in our 3 + 1 dimensional universe, the time-evolution of processes is fundamental. It entails the concepts of equilibrium and convergence,of metastability, and of chaos. A rigorous theory of time-evolution in statistical mechanics is one of the major achievements of modern probability theory with which the names Dobrushin, Spitzer, and Liggett are easily associated.

There is an interplay between the time-dynamics of an ergodic system and its equilibrium measure. The equilibrium is determined by the dynamics, and thus, in models where the equilibrium may itself be hard of access, the dynamics may allow an entrance. Such difficulties arise commonly in applications of Bayesian statistics, in situations where one wishes to sample from a posterior distribution µ having complex structure. One way of doing this is to construct a Markov chain with invariant measure µ, and to follow the evolution of this chain as it approaches equilibrium. The consequent field of ‘Monte Carlo Markov chains’ is nowestablished as a key area of modernstatistics. Similarly, the dynamicaltheory of the random-clustermodelallows an insight into the equilibrium random-cluster

[8.1] Time-evolution of the random-cluster model 223

measures. It provides in addition a mechanism for studying the way in which the system ‘relaxes’ to its equilibrium. We note that the simulation of a Markov chain can, after some time, result in samples whose distribution is close to the invariant measure µ. Such samples will in general have laws which differ from µ, and it can be a difficult theoretical problem to obtain a useful estimate of the distance between the actual sample and µ.

Considerfirst the random-clustermodelon a finite graph G with givenvaluesof p and q. Perhaps the most obvioustype of dynamic is a so-called Glauber process in which single edges change their states at rates chosen in such a way that the equilibrium measure is the random-cluster measure on G. These are the spin-flip processes which, in the context of the Ising model and related systems, have been studied in many works including Liggett’s book [235]. There is a difficulty in constructing such a process on an infinite graph, since the natural speed functions are not continuous in the product topology.

There is a special Glauber process, termed the ‘Gibbs sampler’ or ‘heat-bath algorithm’, which we describe in Section 8.3 in discrete time. This is particularly suited to the exposition in Section 8.4 of the method of ‘coupling from the past’. This beautiful approach to simulation results in a sample having the exact target distribution, unlike the approximate samples produced by Monte Carlo Markov chains. The random-cluster model is a natural application for the method when q ∈ [1,∞), since φG,p,$q$ is monotonic: the model has ‘smallest’ and ‘largest’ configurations, and the target measure is attained at the moment of coalescence of the two trajectories beginning respectively at these extremes.

The speed of convergence of Glauber processes has been studied in detail for Ising and related models, and it turns out that the rate of convergenceto the unique invariant measure can be very slow. This occurs for example if the graph is a large box of a lattice with, say, + boundary conditions, the initial configuration has − everywhere in the interior, and the temperature is low. The process remains for a long time close to the − state; then it senses the boundary, and converges duly to the + state. There is an alternative dynamic for the Ising (and Potts) model, termed Swendsen–Wang dynamics, which converges rather faster to the unique equilibrium so long as the temperature is different from its critical value. This method proceeds by a progressive coupling of the Ising/Potts system with the random-cluster model, and by interleaving a Markovian transition for these two systems in turn. It is described in Section 8.5.

The remaining sections of this chapter are devoted to an exposition of Glauber dynamics on finite and infinite graphs, implemented in such a way as to highlight the effect of varying the parameter p. We begin in Section 8.6 with the case of a finite graph, and proceed in Sections 8.7–8.8 to a process on the infinite lattice which incorporatesin a monotonemannera time-evolvingrandom-clusterprocess for every value of $p$ ∈ (0,1). The unique invariant measure of this composite Markov process may be viewed as a coupling of random-cluster measures on the lattice for different values of p. One consequence of this approach is a proof of the left-continuity of the percolation probability for random-cluster models with

224 Dynamics of Random-Cluster Models [8.2]

q ∈ [1,∞), see Theorem 5.16. It leads in Section 8.9 to an open question of ‘simultaneous uniqueness’ of infinite open clusters.

<a id="sec-8-2"></a>

## 8.2 Glauber dynamics

Let G = (V, E) be a finite graph, with \Omega = \{0,1\}^E as usual. Let p ∈ (0,1) and $q$ ∈ (0,∞). We shall construct a reversible Markov chain in continuous time having as unique invariant measure the random-cluster measure φp,q on . A feature of the Glauber dynamics of this section is that the set of permissible jumps comprises exactly those in which the state of a single edge, e say, changes. To this end, we recall first the notation of (1.25). For ω ∈ and e ∈ E, let $\omega_e$ and $\omega_e$ be the configurationsobtainedby ‘switching e on’ and‘switching e off’, respectively.

Let X = (Xt : t ≥ 0) be a continuous-time Markov chain, [164, Chapter 6], on the state space with generator Q = (qω,ω′ : ω,ω′ ∈ ) satisfying (8.1) qωe,$\omega_e$ = p, qωe,$\omega_e$ = (1 − p)qD(e,$\omega_e$), ω ∈ , e ∈ E,

where D(e,ξ) is the indicator function of the event that the endvertices of e are joined by no open path of ξ. Equations (8.1) specify the rates at which single edges are acquired or lost by the present configuration. We set qω,ξ = 0 if ω and ξ differ on two or more edges, and we choose the diagonal elements qω,ω in such a way that Q, when viewed as a matrix, has row-sums zero, that is,

qω,ξ, ω ∈ .

qω,ω = −

ξ: ξ =ω

Note that X proceeds by transitions in which single edges change their states, it is not permissible for two or more edge-states to change simultaneously. We say in this regard that X proceeds by ‘local moves’.

![image 1008](../Images/imageFile1008.png)

![image 1009](../Images/imageFile1009.png)

We call a Markov chain on a Glauber process if it proceeds by local moves and has a generator Q satisfying (8.3), see [235, p. 191]. We have concentrated

[8.3] Gibbs sampler 225

here on continuous-time processes, but Glauber processes may be constructed in discrete time also.

Two extensions of this dynamical structure which have proved useful are as follows. The evolution may be specified in terms of a so-called graphical representation, constructed via a family of independent Poisson processes. This allows a natural coupling of the measures φp,q for different p and q. Such couplings are monotone in p when q ∈ [1,∞). One may similarly couple the unconditional measure φp,q(·) and the conditioned measure φp,q(· | A). Such couplings permit probabilistic interpretations of differences of the form φp′,q(B | A) − φp,q(B) when q ∈ [1,∞), p ≤ p′, and A and B are increasing, and this can be useful in particular calculations, see [39, 151, 152].

One needs to be more careful when G is an infinite graph. In this case, one may construct a Glauber process on a finite subgraph H of G, and then pass to the thermodynamic limit as H ↑ G. Such a limit may be justified when q ∈ [1,∞) using the positiveassociation of random-clustermeasures, [152]. We shall discuss such limits in Section 8.8 in the more general context of ‘coupled dynamics’. For a reason which will emerge later, we will give the details for the Gibbs sampler of Section 8.3, rather than for the Glauber process of (8.1). The latter case may however be treated in an essentially identical manner.

Note that the generator (8.1) of the Markov chain given above depends on the random variable D(e,$\omega_e$), and that this randomvariable is ‘non-local’in the sense that it is not everywhere continuous in ω. It is this feature of non-locality which leads to an interesting complication when the graph is infinite, linked in part to the 0/1-infinite-cluster property introduced before Theorem 4.31. Further discussion may be found in [152, 272].

<a id="sec-8-3"></a>

## 8.3 Gibbs sampler

Once again we take G = (V, E) to be a finite graph, and we let p ∈ (0,1) and $q$ ∈ (0,∞). We consider in this section a special Glauber process termed the Gibbs sampler (or heat-bath algorithm). This is a Markov chain X on the state space \Omega = \{0,1\}^E which proceedsby local moves. Its basic rule is as follows. We choose an edge e at random, and we set the state of e according to the conditional measure of ω(e) given the current states of the other edges. This may be done in either discrete or continuous time, we give the details for continuous time here and shall return to the case of discrete time in Section 8.4.

![image 1010](../Images/imageFile1010.png)

![image 1011](../Images/imageFile1011.png)

226 Dynamics of Random-Cluster Models [8.3]

for ω ∈ and e ∈ E. Thus, each edge is selected at rate 1, and the state of that edge is changed according to the correct conditional measure. It is evident that the detailed balance equations (8.2) hold as before, whence X is reversible with respect to φp,q. By irreducibility, φp,$q$ is the unique invariantmeasure of the chain and thus, in particular, Xt ⇒ φp,q as t → ∞.

![image 1012](../Images/imageFile1012.png)

![image 1013](../Images/imageFile1013.png)

The state of e is unchanged if the appropriate inequality is false. It is easily checked that this rule generates a Markov chain which satisfies (8.4) and proceeds by local moves. This version of such a chain has two attractive properties. First, it is a neat way of implementing the Gibbs sampler in practice since it requires only two random mechanisms: one that samples edges at random, and a second that produces uniformly distributed random variables.

![image 1014](../Images/imageFile1014.png)

![image 1015](../Images/imageFile1015.png)

Let U(e) = (Uj(e) : j = 1,2,. . .), e ∈ E, be independent families of independent random variables each having the uniform distribution on [0,1]. Let

Xi = (Xti : t ≥ 0), i = 1,2, be Markov processes on constructed as follows. The process Xi evolves according to the above rules, with parameters pi, qi, and using the value Uj(e) at the jth ring of the alarm clock at the edge e. By (8.5)– (8.6), if X01 ≤ X02, then Xt1 ≤ Xt2 for all t ≥ 0. We have therefore constructed a coupling which preserves ordering between processes with different parameters p, q, and with different initial configurations. The key to this ordering is the fact that the coupled processes utilize the same variables Uj(e). This discussion will be developed in the next section.

[8.4] Coupling from the past 227

<a id="sec-8-4"></a>

## 8.4 Coupling from the past

When performing simulations of the random-cluster model, one is required to sample from the probability measure φp,q. The Glauber processes of the last two sections certainly converge weakly to φp,q as t → ∞, but this is not as good as having a sample with the exact distribution. The Propp–Wilson approach to sampling termed ‘coupling from the past’, [282], provides a mechanism for obtaining samples with the correct distribution, and is in addition especially well suited to the random-cluster model when q ∈ [1,∞). We describe this here. Some illustrations of the method in practice may be found in [173, 195, 243].

![image 1016](../Images/imageFile1016.png)

![image 1017](../Images/imageFile1017.png)

![image 1018](../Images/imageFile1018.png)

![image 1019](../Images/imageFile1019.png)

![image 1020](../Images/imageFile1020.png)

![image 1021](../Images/imageFile1021.png)

228 Dynamics of Random-Cluster Models [8.4]

As in (8.6), when q ∈ [1,∞), φp,q($\omega_e$) φp,q($\omega_e$) + φp,q($\omega_e$) ≥

φp,q(ξe) φp,q(ξe) + φp,q(ξe)

, ω ≤ ξ,

![image 1022](../Images/imageFile1022.png)

![image 1023](../Images/imageFile1023.png)

implying that ω(e) ≤ ξ(e), and hence (8.8) ψ(ω,e,u) ≤ ψ(ξ,e,u), ω ≤ ξ. Let Zν = (Znν : n = 0,1,2,. . .) be the Markov chain constructed via (8.7) with initial state Z0 = ν. By (8.8), (8.9) Znω ≤ Znξ for all n, if ω ≤ ξ and $q$ ∈ [1,∞), which is to say that the coupling is monotone in the initial state: if one such chain starts below another, then it remains below for all time.

Instead of running the chain Z ‘forwards’ in time in order to approximate the invariant measure φp,q, we shall run it ‘backwards’ in time in a certain special manner which results in a sample with the exact target distribution. Let W = (W(ω) : ω ∈ ) be a vector of random variables such that each W(ω) has the law of Z1 conditional on Z0 = ω,

P(W(ω) = ξ) = πω,ξ, ω,ξ ∈ .

Following the scheme described above, we may take W(ω) = ψ(ω,e,U) where e and U are chosen uniformly at random. Let W−m, m = 1,2,. . ., be independent random vectors distributed as W, that is, W−m(·) = ψ(·,em,Um) where the set {(em,Um) : m = 1,2,. . .} comprises independent pairs of independent uniformly-distributed random variables. We construct a sequence Y−n, n = 1,2,. . ., of random maps from to by the following inductive procedure. First, we define Y0 : → to be the identity mapping. Having found Y0,Y−1,Y−2,. . .,Y−m for m = 0,1,2,. . ., we define

Y−m−1(ω) = Y−m(W−m−1(ω)).

That is, Y−m−1(ω) is obtained from ω by passing in one step to W−m−1(ω), and thenapplyingY−m tothisnewstate. Theexactdependencestructureofthisscheme is an important ingredient of its analysis.

We terminate the process Y at the earliest time M of coalescence,

(8.10) M = min m : Y−m(·) is a constant function .

By the definition of M, the value Y−M = Y−M(ω) does not depend on the choice of ω. The process of coalescence is illustrated in Figure 8.1. We prove next that Y−M has law φp,q.

230 Dynamics of Random-Cluster Models [8.5]

We extend the notation prior to (8.10) as follows. Let (Y−s,−t : 0 ≤ t ≤ s) be functions mapping to given by:

(i) Y−t,−t is the identity map, for t = 0,1,2,. . . , (ii) Y−s,−t(ω) = Y−s+1,−t(W−s(ω)), for t = 0,1,. . .,s − 1.

The map Y−s,−t depends only on the set {(em,Um, W−m) : t < m ≤ s} of random variables. Therefore, the maps Y−kL,−(k−1)L, k = 1,2,. . ., are independent and identically distributed. Since each is a constant function with some fixed positive probability, there exists almost surely a (random) integer K such that Y−KL,−(K−1)L is a constant function. It follows that M ≤ K L, whence P(M < ∞) = 1.

Let C be chosen randomly from with law φp,q, and write Cm = Y−m(C). Since the law of C is the unique invariant measure φp,q of the Gibbs sampler, Cm has law φp,q for all m = 0,1,2,. . . . By the definition of M,

Y−M = Cm on the event {M ≤ m}. For ω ∈ and m = 0,1,2,. . . ,

P(Y−M = ω) = P(Y−M = ω, M ≤ m) + P(Y−M = ω, M > m)

= P(Cm = ω, M ≤ m) + P(Y−M = ω, M > m) ≤ φp,q(ω) + P(M > m),

and similarly,

φp,q(ω) = P(Cm = ω) ≤ P(Y−M = ω) + P(M > m). We combine these two inequalities to obtain that

P(Y−M = ω) − φp,q(ω) ≤ P(M > m), ω ∈ , and we let m → ∞ to obtain the result.

<a id="sec-8-5"></a>

## 8.5 Swendsen–Wang dynamics

It is a major target of statistical physics to understand the time-evolution of disordered systems, and a prime example lies in the study of the Ising model. A multiplicity of types of dynamics have been proposed. The majority of these share a property of ‘locality’ in the sense that the evolution involves changes to the states of vertices in close proximity to one another, perhaps single spinflips or spin-exchanges. The state space is generally large, of size 2N where N is the number of vertices, and the Hamiltonian may have complicated structure. When subjected to ‘local dynamics’, the process may approach equilibrium quite

[8.5] Swendsen–Wang dynamics 231

slowly2. Other forms of dynamics are ‘non-local’ in that they permit large moves around the state space relatively unconstrained by neighbourly relations, and such processes can approach equilibrium faster. The random-cluster model has played a role in the development of a simple but attractive system of non-local dynamics proposed by Swendsen and Wang [310] and described as follows for the Potts model with q states.

As usual, G = (V, E) is a finite graph, typically a large box in Zd, and we let q ∈ {2,3,. . .}. Consider a q-state Potts model on G, with state space = {1,2,. . .,q}V and parameter β ∈ (0,∞). The corresponding random-cluster model has state space \Omega = \{0,1\}^E and parameter $p$ = 1 − e−β. The Swendsen– Wang evolution for the Potts model is as follows.

Suppose that, at some time n, we have obtained a configuration σn ∈ . We construct σn+1 as follows.

I. Let ωn ∈ be given by: for all $e = \langle x, y \rangle$ ∈ E, if σn(x) = σn(y), let ωn(e) = 0, if σn(x) = σn(y), let ωn(e) =

1 with probability $p$, 0 otherwise,

different edges receiving independent states. The edge-configuration ωn is carried forward to the next stage.

II. To each cluster C of the graph (V,η(ωn)) we assign an integer chosen uniformly at random from the set {1,2,. . .,q}, different clusters receiving independent labels. Let σn+1(x) be the value thus assigned to the cluster containing the vertex x.

(8.13) Theorem [310]. The Markov chain σ = (σn : n = 0,1,2,. . . ) has as unique invariant measure the q-state Potts measure on with parameter β.

Proof. There is a strictly positive probability that ωn(e) = 0 for all e ∈ E. Therefore, P(σn+1 = σ | σn = σ′) > 0 for all σ,σ′ ∈ , so that the chain is irreducible. The invariance of φp,$q$ is a consequence of Theorem 1.13.

The Swendsen–Wangalgorithmgeneratesa Markovchain (σn : n = 0,1,. . .). It is generally the case that this chain converges to the equilibrium Potts measure faster than time-evolutions defined via local dynamics. This is especially evident in the ‘high β’ (or ‘low temperature’) phase, for the following reason. Consider for example the simulation of an Ising model on a finite box with free boundary conditions, and suppose that the initial state is +1 at all vertices. If β is large, local dynamics result in samples that remain close to the ‘+ phase’ for a very long time. Only after a long delay will the process achieve an average magnetization close to 0. Swendsen–Wang dynamics, on the other hand, can achieve large jumps in average magnetization eveninasinglestep,since the spin allocated to agivenlarge

![image 1024](../Images/imageFile1024.png)

2See [249, 292] for accounts of recent work of relevance.

232 Dynamics of Random-Cluster Models [8.6]

cluster of the corresponding random-cluster model is equally likely to be either of the two possibilities. A rigorous analysis of rates of convergence is however incomplete. It turns out that, at the critical point, Swendsen–Wang dynamics approach equilibrium only slowly, [64]. A further discussion may be found in [136].

Algorithms of Swendsen–Wang type have been described for other statistical mechanicalmodelswithgraphicalrepresentationsofrandom-cluster-type,see[93, 94]. Related work may be found in [322].

<a id="sec-8-6"></a>

## 8.6 Coupled dynamics on a finite graph

Let G = (V, E) be a graph, possible infinite. Associated with G there is a family φG,p,q of random-cluster measures indexed by the parameters p ∈ [0,1] and $q$ ∈ (0,∞); we defer a discussion of boundary conditions to the next section. It has proved fruitful to couple these measures, for fixed q, by finding a family (Zq(e) : e ∈ E) of random variables taking values in [0,1] whose ‘level-sets’ are governed by the φG,p,q. It might be the case for example that, for any given p ∈ (0,1), the configuration (Zp,q(e) : e ∈ E) given by

Zp,q(e) =

1 if Zq(e) ≤ p, 0 otherwise,

has law φG,p,q. Such a coupling has been valuable in the study of percolation theory (that is, when $q$ = 1), where one may simply take a family of independent random variables Z(e) with the uniform distribution on the interval [0,1], see [154, 178]. The picture for random-cluster measures is more complex owing to the dependence structure of the process. Such a coupling has been explored in detail in [152] but we choose here to follow a minor variant which might be termed a ‘coupled Gibbs sampler’. We shall assume for the moment that G is finite, returning in the next two sections to the case of an infinite graph G.

Let G = (V, E) be finite, and let q ∈ [1,∞). Let X = [0,1]E, and let B be the Borel σ-field of subsets of X, that is, the σ-field generated by the open subsets. We shall construct a Markov process Z = (Zt : t ≥ 0) on the state space X, and we do this via a so-called graphical construction. We shall consider the states of edges chosen at random as time passes, and to this end we provide ourselves with a family of independent Poisson processes termed ‘alarm clocks’. For each arrival-time of these processes, we shall require a uniformly distributed random variable.

- (a) For each edge e ∈ E, let A(e) = (An(e) : n = 1,2,. . .) be the (increasing) sequence of arrival times of a Poisson process with intensity 1.
- (b) Let (αn(e) : e ∈ E, n = 1,2,. . .) be a family of independent random variables each of which is uniformly distributed on the interval [0,1].

[8.6] Coupled dynamics on a finite graph 235

the aboveconstructionmaybeextendedinorderto coupletogetherrandom-cluster processes with differentvalues of p and differentvalues of q ∈ [1,∞). Secondly, some of the arguments of this section may be re-cast in the ‘non-FKG’ case when q ∈ (0,1).

It is noted that the level-set processes are reversible, unlike the process Z. Proof of Theorem 8.24. (a) We begin with a calculation involving the function F defined in (8.14). Let e ∈ E, ν ∈ X, and let γ = pν ∈ . We claim that (8.26) F(e,ν) > p if and only if γ = pν ∈ De,

where De ⊆ is the set of configurations in which the endvertices of e are joined by no open path of E \ {e}. This may be seen from (8.14) by noting that: F(e,ν) > p if and only if, for every π ∈ Pe, there exists an edge f ∈ π such that ν( f ) > p.

The projected process pZ changes its value only when Z changes its value. Assume that Zt = ν and pZt = pν = γ. Let γ′ ∈ . By the discussion around (8.16)–(8.18), the rate at which pZ jumps subsequently to the new state γ′ depends only on:

(i) the arrival-times of the Poisson processes A(e) subsequent to t, (ii) the associated values of the random variables α, and

(iii) the set Fν = {e ∈ E : F(e,ν) > p} of edges.

By (8.26), Fν = {e ∈ E : γ ∈ De}, which depends on γ only and not further on ν. It follows that pZ = ( pZt : t ≥ 0) is a time-homogeneous Markov chain on . This argument is expanded in the following computation of the jump rates.

Let Q = (qγ,ω : γ,ω ∈ ) denote the generator of the process pZ. Since Z proceeds by local moves,

qγ,ω = 0 if H(γ,ω) ≥ 2,

![image 1025](../Images/imageFile1025.png)

![image 1026](../Images/imageFile1026.png)

![image 1027](../Images/imageFile1027.png)

![image 1028](../Images/imageFile1028.png)

![image 1029](../Images/imageFile1029.png)

![image 1030](../Images/imageFile1030.png)

if γ ∈/ De,

![image 1031](../Images/imageFile1031.png)

We turn now to the proof of Theorem 8.19, which is preceeded by a lemma. The product space X = [0,1]E is equipped with the Borel σ-field B. An event A ∈ B is called increasing if it has the property that ν′ ∈ A whenever there exists ν ∈ A such that ν ≤ ν′, and it is called decreasing if its complement is increasing. For ζ ∈ X, let Zζ = (Ztζ : t ≥ 0) denote the above Markov process with initial state Z0 = ζ.

(8.31) Lemma. (a) If ζ ≤ ν then Ztζ ≤ Ztν for all t. (b) Let E be an increasing event in B. The function gb(t) = P(Ztb ∈ E) is

non-decreasing in t if b = 0, and is non-increasing if b = 1.

Proof of Lemma 8.31. (a) This follows from the transition rules (8.15)–(8.16) together with the fact that F(e,ν) is non-decreasing in ν. (b) Using conditional expectation,

gb(s + t) = P P(Zsb+t ∈ E | Zsb) , b = 0,1.

By the time-homogeneity of the processes (A,α), the fact that 0 ≤ Zsb ≤ 1, and part (a),

gb(s + t) ≥ gb(t) if b = 0, ≤ gb(t) if b = 1.

Proof of Theorem 8.19. In order to prove the existence of a unique invariant probability measure µ, we shall prove that Zt converges weakly as t → ∞, and we shall write µ for the weak limit. By Lemma 8.31(a),

(8.32) Zt0 ≤ Ztν ≤ Zt1, t ≥ 0, ν ∈ X.

By Lemma 8.31(b), Ztb is stochastically increasing in t if b = 0, and stochastically decreasing if b = 1. It therefore suffices to show that

(8.33) Zt1 − Zt0 ⇒ 0 as t → ∞. Let ǫ > 0, and write E = {k/N : k = 1,2,. . ., N − 1} where N is a positive integer satisfying N−1 < ǫ. Then

P |Zt1(e) − Zt0(e)| > ǫ for some e ∈ E ≤

Now,

P Zt0(e) < $p$ < Zt1(e) .

e∈E p∈E

P Zt0(e) < $p$ < Zt1(e) ≤ P( pZt0(e) = 1) − P( pZt1(e) = 1)

→ 0 as t → ∞

by the ergodicity of the Markov chain pZ, see Theorem 8.24.

<a id="sec-8-7"></a>

## 8.7 Box dynamics with boundary conditions

In the last section, we constructed a Markov process Z on the state space X = [0,1]E for a finite edge-set E. In moving to an infinite graph, we shall require a discussion of boundaryconditions. Let d ≥ 1 and X = [0,1]Ed, a compactmetric space when equipped with the Borel σ-field B generated by the open sets.

Since our target is to study processes on the lattice Ld = (Zd,Ed), we shall assume for convenience that our finite graphs are boxes in this lattice. Let be such a box. For ζ ∈ X, let

(8.34) Xζ = ν ∈ X : ν(e) = ζ(e) for e ∈/ E .

As in (8.14), we define F : Ed × X → R by

ν( f ), $e = \langle x, y \rangle$ ∈ Ed, ν ∈ X,

(8.35) F(e,ν) = inf

max

f ∈π

π∈Pe

where Pe is the (infinite) set of all (finite) paths of Ed \ {e} that join x to y.

238 Dynamics of Random-Cluster Models [8.7]

Let q ∈ [1,∞). We provide ourselves4 with a family of independent Poisson processes A(e) = (An(e) : n = 1,2,. . .), e ∈ Ed, with intensity 1, and an associated collection (αn(e) : e ∈ Ed, n = 1,2,. . .) of independent random variables with the uniform distribution on [0,1]. Let ζ ∈ X. The above variables maybeusedasinthelastsectiontoconstructafamilyofcoupledMarkovprocesses

Zζ = (Z ,ζ t : t ≥ 0) taking values in Xζ and indexed by the pair , ζ. The process Zζ has generator Sζ given by (8.17)–(8.18) for ν ∈ Xζ and with F = F(e,ν) given in (8.35).

As in Lemma 8.31(a),

(8.36) Z ,ζ t ≤ Z ,ν t, ζ ≤ ν, t ≥ 0.

For ν,ζ ∈ X and a box , we denote by (ν,ζ) [= (ν,ζ) ∈ X] the composite configurationthat agrees with ν on E and with ζ off E . We sometimes suppress the subscript when using this notation. For example, the expression Z ,(ν,ζ)t denotes the value of the process on the box at time t, with initial value (ν,ζ) . Finally, with p, p given as in (8.20)–(8.21), we write ϒp for the set of all ζ ∈ X with the property that p[(1,ζ) ] has at most one infinite cluster.

(8.37) Theorem. Let ζ ∈ X and let be a box of Ld. The Markov process Z(ν,ζ) = (Z ,(ν,ζ)t : t ≥ 0), viewed as a process on (X,B), has a unique invariant measure µζ and, in particular, Z ,(ν,ζ)t ⇒ µζ as t → ∞.

We turnasbeforetothe projectedprocesses pZζ and pZζ . Acomplication arises in the case of the first of these, depending on whether or not ζ ∈ ϒp . (8.38) Theorem. Let p ∈ (0,1), ζ ∈ X, and let be a box of Ld.

(a) The process pZζ = ( pZ ,ζ t : t ≥ 0) is a Markov chain on the state

space pXζ with unique invariant measure φ , ppζ,q, and it is reversible with respect to this measure. Furthermore,

p1Z ,ζ t ≤ p2 Z ,ζ t for t ≥ 0, if p1 ≤ p2. (8.39)

(b) Assume that ζ ∈ ϒp . Statement (a) is valid with the operator p replaced throughout by p.

We note two further facts for future use. First, there is a sample-path monotonicity of the graphical representation which will enable us to pass to the limit of the processes Zζ as ↑ Zd. Secondly, if ν and ζ are members of X that are close

to one another, then so are Z ,(ν,tb) and Z ,(ζ,tb), for b ∈ {0,1}. These observations are made formal as follows.

![image 1032](../Images/imageFile1032.png)

4We make the same assumption as in the footnote on page 233.

### (8.40) Lemma.

(a) Let and be boxes satisfying ⊆ . Then:

Z ,(ζ,t0) ≤ Z ,(ζ,t0), ζ ∈ X, t ≥ 0, (8.41) Z ,(ζ,t1) ≥ Z ,(ζ,t1), ζ ∈ X, t ≥ 0. (8.42)

(b) Let be a box, b ∈ {0,1}, and ν,ζ ∈ X. Then:

Z ,(ν,tb)(e) − Z ,(ζ,tb)(e) ≤ max

|ν( f ) − ζ( f )| , t ≥ 0, e ∈ E . (8.43)

f ∈E

Proof of Theorem 8.38. (a) The projected process ( pZ ,ζ t : t ≥ 0) takes values in the state space pζ = pXζ . The proof now follows that of Theorem 8.24(b), the key observation being that (8.30) remains valid with De the set of all configurationsin \Omega = \{0,1\}^Ed such that the endverticesof e are joined by no open path of Ed \ {e}. (b) The claim will follow as in Theorem 8.24(a) once we have proved (8.26) for ν ∈ ϒp . We are thus required to show that:

(8.44) for ν ∈ ϒp , F(e,ν) > p if and only if γ = pν ∈ De.

Let e ∈ E and ν ∈ X. If F(e,ν) > p, then pν ∈ De. Suppose conversely that ν ∈ ϒp and pν ∈ De. By the definition (8.20) of pν, the function µ : Pe → [0,1] given by

µ(π) = max

ν( f ), π ∈ Pe,

f ∈π

satisfies

µ(π) > p, π ∈ Pe. By (8.35), F(e,ν) ≥ p. Suppose F(e,ν) = p. There exists an infinite sequence (πn : n = 1,2,. . .) of distinct paths in Pe such that µ(πn) > p and µ(πn) → p as n → ∞. Let E be the set of edges belonging to infinitely many of the paths πn. Now,

ν( f ) ≤ lim

µ(πn) = p, f ∈ E, so that pν( f ) = 1 for f ∈ E.

n→∞

Write $e = \langle x, y \rangle$ , and let C(x) (respectively, C(y)) denote the set of vertices of Ld joined to x (respectively, y) by paths comprising edges f with pν( f ) = 1. By a counting argument, we have that x (respectively, y) lies in some infinite path of E, and therefore |C(x)| = |C(y)| = ∞. Since ν ∈ ϒp , pν has at most one infinite cluster. Therefore, C(x) = C(y), whence pν ∈/ De, a contradiction. This proves that F(e,ν) > p, as required for (8.44).

Proof of Theorem 8.37. This follows the proof of Theorem 8.19, with Theorem 8.38 used in place of Theorem 8.24.

Proof ofLemma 8.40. (a)We shallconsider(8.41), inequality(8.42)beingexactly analogous. Certainly,

0 = Z ,(ζ,t0)(e) ≤ Z ,(ζ,t0)(e), e ∈ Ed \ E .

Let e ∈ E , and note that Z ,(ζ,00)(e) = Z ,(ζ,00)(e), since ⊆ . It suffices to check that, at each ring of the alarm clock on the edge e, the process Z ,(ζ,·0)(e) cannot jump above Z ,(ζ,·0)(e). As in Lemma 8.31(a), this is a consequence of the transition rules (8.15)–(8.16) on noting that F(e,ν) is non-decreasing in ν. (b) Let b ∈ {0,1} and ν,ζ ∈ X. It suffices to show that

Z ,(ν,tb)( f ) − Z ,(ζ,tb)( f )

(8.45) Mt = max

f ∈E

is a non-increasingfunction of t. Now, Mt is constant except when an alarm clock rings. Suppose that AN(e) = T for some N ≥ 1 and e ∈ E . It is enough to show that

(8.46) Z ,(ν,Tb)(e) − Z ,(ζ,Tb)(e) ≤ MT−. By (8.35),

F(e,ξ) − F(e,ξ′) ≤ max f ∈Ed

and (8.46) follows by (8.16).

|ξ( f ) − ξ′( f )| , ξ,ξ′ ∈ X,

<a id="sec-8-8"></a>

## 8.8 Coupled dynamics on the infinite lattice

The reader is reminded of the assumption that q ∈ [1,∞). We have constructed two Markov processes Zb = (Z ,b t : t ≥ 0) on the state space X = [0,1]Ed, indexed by the finite box and the boundary condition b ∈ {0,1}. Similar processes may be constructedon the infinite lattice Ld by passing to limits ‘pathwise’, and exploiting the monotonicity in of the processes Zb .

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

The state space X = [0,1]Ed is a compactmetric space equippedwith the Borel σ-field B generated by the open sets. Let B(X) denote the space of bounded measurable functions from X to R, and C(X) the space of continuous functions.

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

where the projections p and $p$ are defined in (8.20)–(8.21). Note the apparent reversal of boundary conditions in (8.55).

![image 1033](../Images/imageFile1033.png)

5A possible alternative to the methodology of this section might be the ‘martingale method’ described in [186, 235]. For general accounts of the theory of Markov processes, the reader may consult the books [51, 113, 235, 299].

### (8.56) Theorem.

- (a) Let b ∈ {0,1} and $p$ ∈ (0,1). The process Lbp is a Markov process on the state space \Omega = \{0,1\}^Ed, with as unique invariant measure the randomcluster measure φpb,q on Ld. The process Lbp is reversible with respect to φpb,q.
- (b) The measures φpb,q, b = 0,1, are ‘level-set’ measures of the invariant measure µ of Theorem 8.53 in the sense that, for A ∈ F ,

φp0,q(A) = µ {ζ : pζ ∈ A} , φp1,q(A) = µ {ζ : pζ ∈ A} . (8.57) We make several remarks before proving the above theorems. First, the invari-

ant measures φp0,q and φp1,q of Theorem 8.56 are identical if and only if $p$ ∈/ Dq, where Dq is that of Theorem 4.63.

Secondly, with µ as in Theorem 8.53, and e ∈ Ed, let J : [0,1] → [0,1] be given by (8.58) J(x) = µ {ζ ∈ X : ζ(e) = x} , x ∈ [0,1].

Thus, J is the atomic component of the marginal measure of µ at the edge e and, by translation-invariance, it does not depend on the choice of e. We recall from (4.61) the edge-densities

hb(p,q) = φpb,q(e is open), b = 0,1. (8.59) Proposition. It is the case that

J(p) = h1(p,q) − h0(p,q), p ∈ (0,1).

We deduce by Theorem 4.63 that p ∈ Dq if and only if J(p) = 0, thereby providing a representation of Dq in terms of atoms of the weak limit µ. This may be used to prove the left-continuity of the percolation probability θ0(·,q). See Theorem 5.16(a), the proof of which is included at the end of the current section.

As discussed after Theorem 4.63, it is believed that there exists Q = Q(d) such that

∅ if $q$ < Q, {pc(q)} if $q$ > Q,

Dq =

and it is a first-rate challenge to prove this. The above results provide some incomplete probabilistic justification for such a claim, as follows. The set Dq is the set of atoms of the one-dimensional marginal measure of µ. Such atoms arise presumablythroughanaccumulationofedges ehavingthesamevalue Ztb(e). Two edges e and f acquirethe same state in the process Z by way of transitionsat some time T for which, say, the alarm clock at e rings and F = F(e, ZT−) = ZT−( f ). Discounting events with probability zero, this can occur only when the new state

at e is at the (unique) atom of the function He,ν in (8.18), where ν = ZT−. The size of this atom is

F F + q(1 − F)

F −

![image 1034](../Images/imageFile1034.png)

which is an increasing function of q. This is evidence that the number of pairs e, f of edges having the same state increases with q.

Finally, we describe the transition rulesof the projected processes L0p and L1p. It turns out that the transition mechanismsof these two chains differin an interesting but ultimately unimportant regard. It is convenient to summarize the following discussion by writing down the two infinitesimal generators.

Let $e = \langle x, y \rangle$ ∈ Ed. As in (8.35), let Pe be the set of all paths of Ed \ {e} that join x to y. Let Qe be the set of all pairs α = (α1,α2,. . .), β = (β1,β2,. . . ) of vertex-disjointsemi-infinite paths (where αi and βj are the vertices of these paths) with α1 = x and β1 = y; we require αi = βj for all i, j. Thus Qe comprises pairs (α,β) of paths and, for ω ∈ , we call an element (α,β) of Qe open if all the edges of both α and β are open.

For b = 0,1, let Gb be the linear operator, with domain a suitable subset of C( ), given by (8.60)

![image 1035](../Images/imageFile1035.png)

![image 1036](../Images/imageFile1036.png)

Note that Gbg is well defined for all cylinder functions g, since the infinite sum in (8.60) may then be written as a finite sum. However, Gbg is not generally continuous when q ∈ (1,∞), even for cylinder functions g. For example, let q ∈ (1,∞), let g be the indicator function of the event that a given edge e is open, and let ω be a configuration satisfying:

(a) ω(e) = 1, (b) no path in Pe is open in ω, (c) some pair (α,β) in Qe is open in ω.

Then Gbg(ω) = −qω,ωb e. However, qω,ωb e is discontinuous at ω for b = 0,1 since, for every finite box , there exists ρ ∈ agreeing with ω on E such that

which implies (8.75). We deduce as required that λ = F(e,ν). (b) Let $e = \langle x, y \rangle$ ∈ Ed. Suppose ν ∈ X0 and ν ↑ ν as ↑ Zd. We prove first that the increasing limit

(8.76) λ = lim

↑Zd

F(e,ν )

satisfies (8.77) λ ≥ G(e,ν). Let δ ∈ (0,1), and suppose G(e,ν) > δ; we shall deduce that λ > δ, thus obtaining (8.77).

A finite set S of edges of Ld is called a cutset (for e) if: (i) e ∈/ S,

(ii) every path in Pe contains at least one edge of S, (iii) S is minimal with the two properties above, in the sense that no strict subset

of S satisfies (i) and (ii). We claim that: (8.78) there exists a cutset S with ν( f ) > δ for all f ∈ S, and we prove this as follows. First, we write G(e,ν) = min{A, B} where (8.79) $$ A = F(e, \nu) = \inf*{\pi \in P_e} \max*{f \in \pi} \nu(f), \quad B = \inf*{\pi \in Q_e} \sup*{f \in \pi} \nu(f). $$

Since G(e,ν) > δ, we have that A, B > δ. For w ∈ Zd, let Cw(ν) denote the set of vertices of Ld that are connected to w by paths π of Ld satisfying:

(a) π does not contain the edge e, and (b) every edge f of π satisfies ν( f ) ≤ δ.

If x ∈ Cy(ν), then there exists π ∈ Pe with ν( f ) ≤ δ for all f ∈ π, which contradicts the fact that A > δ. Therefore x ∈/ Cy(ν). Furthermore, either Cx(ν) or Cy(ν) (or both) is finite, since if both were infinite, then there would exist π = (α,β) ∈ Qe with ν( f ) ≤ δ for all f in α and β, thereby contradicting the fact that B > δ. We may suppose without loss of generality that Cx(ν) is finite, and we let R be the subset of Ed \ {e} containing all edges g with exactly one endvertex in Cx(ν). Certainly ν(g) > δ for all g ∈ R, and additionally every path in Pe contains some edge of R. However, R may fail to be minimal with the last property, in which case we replace R by a subset S ⊆ R that is minimal. The set S is the required cutset, and (8.78) is proved.

Since S is finite and ν( f ) > δ for all f ∈ S, for all large and all f ∈ S, ν ( f ) > δ,

Proof of Lemma 8.69. (i) By (8.35), p ≤ F(e,ν) if and only if every π ∈ Pe contains some edge f with ν( f ) ≥ p, which is to say that pν ∈ De0. (ii) Suppose that $p$ < G(e,ν). For π ∈ Pe ∪Qe, there exists an edge f ∈ π such that ν( f ) > p. Therefore, pν ∈ De1.

Suppose conversely that pν ∈ De1. It is elementary that p ≤ G(e,ν). Suppose in addition that $p$ = G(e,ν), and we shall derive a contradiction. Let $e = \langle x, y \rangle$ , and let Cx(ν) (respectively, Cy(ν)) be the set of vertices attainable from x (respectively, y) along open paths of pν not using e. Since pν ∈ De1, Cx(ν) and Cy(ν) are disjoint. We shall prove that Cx(ν) (and similarly Cy(ν)) is infinite. Since $p$ = G(e,ν), there exists an infinite sequence (αn : n = 1,2,. . .) of distinct (finite or infinite) paths of Ed \ {e} with endvertex x such that

ν( f ) ↓ p as n → ∞.

(8.81) sup

f ∈αn

If |Cx(ν)| < ∞, there exists some edge g = e, having exactly one endvertex in Cx(ν), and belonging to infinitely many of the paths αn. By (8.81), any such g has ν(g) ≤ p, in contradiction of the definition of Cx(ν). Therefore Cx(ν) (and similarly Cy(ν)) is infinite.

Since Cx(ν) and Cy(ν) are disjoint and infinite, there exists π = (α,β) ∈ Qe

such that ν( f ) ≤ p for f ∈ α ∪β, in contradiction of the assumption pν ∈ De1. The proof is complete.

Proof of Theorem 8.52. Let b ∈ {0,1}. The transitions of the process (Ztb : t ≥ 0) are given in terms of families of independent doubly-stochastic Poisson

processes. In order that Ztb be a Markov process, it suffices therefore to prove that the conditional distribution of (Zsb+t : t ≥ 0), given (Zub : 0 ≤ u ≤ s), depends only on Zsb.

Here is an informal proof. We have that Zsb+t = lim ↑Zd Z ,b s+t, where the processes Z ,b s+t are given in terms of a graphical representation of compound Poisson processes. It follows that, given (Z ,b u, Zub : 0 ≤ u ≤ s, ⊆ Zd), (Zsb+t : t ≥ 0) has law depending only on the family (Z ,b s : ⊆ Zd). Write ζ = Z ,b s and ζ = lim ↑Zd ζ = Zsb. We need to show that the (conditional) law of (Zsb+t : t ≥ 0) does not depend on the family (ζ : ⊆ Zd) further than on its limit ζ. Lemma 8.40(b) is used for this.

Let s,t ≥ 0 and ν ∈ X. Denote by Y ,(ν,sb+)t the state (in Xb ) at time s + t obtained from the evolution rules given prior to (8.36), starting at time s in state (ν,b) = (ν,b) .

Suppose that b = 0, so that ζ ↑ ζ as → Zd. Let ǫ > 0 and let be a finite box. There exists a box ′ such that ′ ⊇ and

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

exist for any increasing event A ∈ B. The space X is compact, and the increasing events are convergence-determining, and therefore Zt0 and Zt1 converge weakly as t → ∞. It suffices to show that

Zt1 − Zt0 ⇒ 0 as t → ∞.

Since we are working with the product topology on X, it will be enough to show that, for ǫ > 0 and f ∈ Ed,

(8.83) P |Zt1( f ) − Zt0( f )| > ǫ → 0 as t → ∞.

Let D = Dq be as in Theorem 4.63, and let ǫ > 0. Pick a finite subset E of D = (0,1)\D such that every interval of the form (δ,δ +ǫ) contains some point of E, as δ ranges over [0,1 − ǫ). By Theorem 4.63,

![image 1037](../Images/imageFile1037.png)

In order to show that

φp0,q(A) = ψp0(A), φp1,q(A) = ψp1(A),

for all p and any increasing cylinderevent A, it suffices to show that ψp0(A) is leftcontinuous in p, and ψp1(A) is right-continuous (the conclusion will then follow by Proposition 4.28). We confine ourselves to the case of ψp0(A), since the other case is exactly similar.

Let p ∈ (0,1), and let A ∈ F be an increasing cylinder event. Let

Bp = {ζ ∈ X : pζ ∈ A}, Cp = {ζ ∈ X : pζ ∈ A},

be the correspondingevents in B, and note from the definitions of p and $p$ that Bp is decreasing and open, and that Cp is decreasing and closed. Furthermore, Cp−ǫ ⊆ Bp for ǫ > 0, and

(8.87) Bp \ Cp−ǫ → ∅ as ǫ ↓ 0.

By stochastic monotonicity, the limit limt→∞ P(Zt1 ∈ Bp) exists and, by weak convergence (see Theorem 8.53),

P(Zt1 ∈ Bp) ≥ µ(Bp). We claim further that P(Zt1 ∈ Bp) ≤ µ(Bp) for all t, whence (8.88) P(Zt1 ∈ Bp) → µ(Bp) as t → ∞. Suppose on the contrary that

lim

t→∞

P(ZT1 ∈ Bp) > µ(Bp) + η for some T and η > 0.

Now Zt1 ≤st ZT1 for t ≥ T, and hence

P(Zt1 ∈ Cp−ǫ) > µ(Cp−ǫ) + 21η for some ǫ > 0 and all t ≥ T, by (8.87). Since Cp−ǫ is closed, this contradicts the fact that Zt1 ⇒ µ.

![image 1038](../Images/imageFile1038.png)

The sets Bp and Bp−h are open, and Bp\Bp−h → ∅ ash ↓ 0. Henceψp0−h(A) → ψp0(A) as h ↓ 0.

In the corresponding argument for ψp1(A), the set Bp is replaced by the decreasing closed event Cp, and the difference Bp \ Bp−h is replaced by Cp+h \Cp.

We prove finally that L0p,t is reversible with respect to φp0,q; the argument is similar for L1p,t. Let f and g be increasing non-negative cylinder functions mapping to R, and let U ,0 t (respectively, Ut0) be the transition semigroup of the process pZ ,1 t (respectively, L0p,t = pZt1). For ⊆ ,

f (η)U ,0 tg(η) ≤ f (η)U ,0 tg(η) ≤ f (η)Ut0g(η), η ∈ , by Lemmas 8.31 and 8.40. Therefore,

φ ,0 p,q f (η)U ,0 tg(η) ≤ φ ,0 p,q f (η)U ,0 tg(η) ≤ φp0,q f (η)Ut0g(η) , ⊆ ,

since φ ,0 p,q ≤st φp0,q. Let ↑ Zd and ↑ Zd, and deduce by the monotone convergence theorem that

(8.89) φ ,0 p,q f (η)U ,0 tg(η) → φp0,q f (η)Ut0g(η) as ↑ Zd. The leftside of(8.89)isunchangedwhen f and g are exchanged,by the reversibility of pZ ,1 t, see Theorem 8.38. Therefore, the right side is unchanged by this exchange, implying the required reversibility (see [235, p. 91]). (b) It suffices to prove (8.57) for increasing cylinder events A, since such events generate F . For such A, (8.57) follows from (8.88) in the case of φp0,q, and similarly for φp1,q. Proof of Proposition 8.59. This is a consequence of Theorem 8.56(b). (8.90) Proposition. Let q ∈ (1,∞) and $p$ ∈ (0,1). The Markov processes L0p and L1p are not Feller processes.

Proof. For simplicity we take d = 2 and b = 0; a similar argument is valid for d > 2 and/or b = 1. Let e be the edge with endvertices (0,0) and (1,0), and let Je be the indicator function of the event that e is open. We shall show that the function Us0Je : → R is not continuous for sufficiently small positive values

lim ↑Zd K ,b t, a limit which exists by the usual monotonicity. We claim that there exist ǫ, η > 0, independent of the value of n, such that

(8.91) P Kη1(e) = 1, Kη0(e) = 0 > ǫ. Inequality (8.91) implies that

P(Kη1(e) = 1) − P(Kη0(e) = 1) > ǫ,

irrespective of the value of n, and therefore that the semigroup Us0 is not Feller.

In order to prove (8.91), we use a percolation argument. Let η > 0. As in Section 8.6, we consider a family of rate-1 alarm clocks indexed by E2. For each edge f , we set Bf = 0 if thealarm clockat f doesnotringduringthe time-interval [0,η], and Bf = 1 otherwise. Thus, (Bf : f ∈ E2) is a family of independent Bernoulli variables with common parameter 1 −e−η. Choose η sufficiently small such that

1 − e−η < 41,

![image 1039](../Images/imageFile1039.png)

noting that 14 is less than the critical probability of bond percolation on the square lattice (see Chapter6 and [154]). Routine percolationargumentsmay now be used

![image 1040](../Images/imageFile1040.png)

to obtain the existence of ǫ′ > 0 such that, for all boxes containing [−2n,2n]2,

P K ,1 t ∈/ De, K ,0 t ∈ De, for all t ∈ [0,η] Gη > ǫ′ P-a.s.,

where Gη is the σ-field generated by the ringing times of the alarm clock at e up to time t, together with the associated values of α (in the language of Section 8.6).

Supposethatthe alarmclockat e ringsonceonlyduringthe time-interval[0,η], at the random time T, say. By (8.72)–(8.73), there exists ǫ′′ = ǫ′′(p,q) > 0 such that: there is (conditional) probability at least ǫ′′ that, for all ⊇ [−2n,2n]2, the edge e is declared closed at time T in the lower process K ,0 T but not in the upper process K ,1 T. The conditioning here is over all values of the doubly-stochastic Poisson processes indexed by edges other than e. Therefore,

P K ,η1 (e) = 1, K ,η0 (e) = 0 > ǫ′ǫ′′ηe−η,

for all containing [−2n,2n]2. Let ↑ Zd to obtain (8.91) with an appropriate value of ǫ.

Proof of Theorem 5.16(a). This was deferred from Section 5.2. We follow the argument of [36] as reported in [154]. For p ∈ (0,1] and ζ ∈ X, we say that an edgee is p-openif pζ(e) = 1, whichis to say thatζ(e) < p. LetCp = Cp(ζ)be the p-open cluster of Ld containing the origin, and note that Cp′ ⊆ Cp if $p$′ ≤ p.

By Theorem 8.56(b),

θ0(p,q) = µ(|Cp| = ∞),

[8.9] Simultaneous uniqueness 255

where µ is given in Theorem 8.53. Therefore,

(8.92)

θ0(p,q) − θ0(p−,q) = lim p′↑p

µ |Cp| = ∞, |Cp′| < ∞

= µ |Cp| = ∞, |Cp′| < ∞ for all p′ < p .

Assume that $p$ > pc(q), and suppose |Cp| = ∞. If pc(q) < α < p, there exists (almostsurely)anα-openinfinitecluster Iα,andfurthermore Iα is(almostsurely)a subgraph of Cp, by the 0/1-infinite-cluster property of the 0-boundary-condition random-cluster measures. Therefore, there exists a p-open path π joining the origin to some vertex of Iα. Such a path π has finite length and each edge e in π satisfies ζ(e) < p, whence β = max{ζ(e) : e ∈ π} satisfies β < p. If p′ satisfies p′ ≥ α and β < p′ < p then there exists a p′-open path joining the origin to some vertex of Iα, so that |Cp′| = ∞. However, p′ < p, implying that the event on the right side of (8.92) has probability zero.

<a id="sec-8-9"></a>

## 8.9 Simultaneous uniqueness

One of the key facts for supercritical percolation is the (almost-sure) uniqueness of the infinite open cluster, which may be stated in the following form. Let φp be the percolation (product) measure on \Omega = \{0,1\}^Ed where d ≥ 2. We have that:

(8.93) for all p ∈ [0,1], φp has the 0/1-infinite-cluster property.

Ithasbeenaskedwhetherornotthereexistsauniqueinfinite clustersimultaneously for all values of p. This question may be formulated as follows. First, we couple together the percolation processes for different values of $p$ by defining

1 if U(e) < p, 0 otherwise,

ηp(e) =

where the U(e), e ∈ Ed, are independentand uniformly distributed on the interval [0,1]. Let I(ω) be the number of infinite open clusters in a configuration ω ∈

. It is proved in [13] that there exists a deterministic non-decreasing function i : [0,1] → {0,1} such that (8.94) P I(ηp) = i(p) for all p ∈ [0,1] = 1, a statement to which we refer as ‘simultaneous uniqueness’. By (8.93) and the definition of the critical probability pc,

0 if $p$ < pc, 1 if $p$ > pc.

i(p) =

It is an open question to prove the conjecture that i(pc) = 0 irrespective of the number d of dimensions. See the discussion in [154, Section 8.2].

Simultaneous uniqueness may be conjectured for the random-cluster model also, using the coupling of the last section.

256 Dynamics of Random-Cluster Models [8.9]

(8.95) Conjecture (Simultaneous uniqueness). Let q ∈ [1,∞), and consider the coupling µ of the random-cluster measures φpb,q on Ld with parameter q. There exist non-decreasing functions iq,iq′ : [0,1] → {0,1} such that

µ I( pζ) = iq(p) and I( pζ) = iq′ (p), for all p ∈ [0,1] = 1.

It must be the case that iq(p) = iq′ (p) for $p$ = pc(q). Here is a sufficient condition for simultaneous uniqueness. For r ∈ (0,1) and a box , let E (r) be the subset of the configuration space X containing all ν with ν(e) < r for all e ∈ E . Thus, E (r) is the event that every edge in E is open in the configuration rν. By [13, Thm 1.8], it suffices to show that µ has a property termed ‘positive finite energy’. This is in turn implied by:

![image 1041](../Images/imageFile1041.png)

|E |

, µ-a.s.

