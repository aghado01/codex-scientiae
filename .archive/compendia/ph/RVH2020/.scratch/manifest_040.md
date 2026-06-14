# Manifest: Page 040

## REPLACE_TABLES
- FILL_ME_IN

## REPAIR_PROSE
- RAW: ```
glyph[negationslash]
```
  FIX: ```
```

## REPAIR_MATH
- RAW: ```
( \gamma _ { V } f ) ( - ) \uparrow \mathbf E _ { - } [ f ( X ) ] \ \ a n d \ \ ( \gamma _ { V } f ) ( + ) \downarrow \mathbf E _ { + } [ f ( X ) ] \ \ a s \ \ V \uparrow \mathbb { Z } ^ { d }
```
  FIX: ```
$$
( \gamma _ { V } f ) ( - ) \uparrow \mathbf E _ { - } [ f ( X ) ] \ \ a n d \ \ ( \gamma _ { V } f ) ( + ) \downarrow \mathbf E _ { + } [ f ( X ) ] \ \ a s \ \ V \uparrow \mathbb { Z } ^ { d }
$$
```
- RAW: ```
E _ { - } [ f ( X ) ] \leq E [ f ( X ) ] \leq E _ { + } [ f ( X ) ]
```
  FIX: ```
$$
E _ { - } [ f ( X ) ] \leq E [ f ( X ) ] \leq E _ { + } [ f ( X ) ]
$$
```
- RAW: ```
\lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( - ) = E _ { - } [ f ( X ) ] \ \text { and } \ \lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( + ) = E _ { + } [ f ( X ) ]
```
  FIX: ```
$$
\lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( - ) = E _ { - } [ f ( X ) ] \ \text { and } \ \lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( + ) = E _ { + } [ f ( X ) ]
$$
```
- RAW: ```
E _ { - } [ f ( X ) ] = \lim _ { V \subset \mathbb { Z } ^ { d } } ( \gamma _ { V } f ) ( - ) \leq \lim _ { V \subset \mathbb { Z } ^ { d } } E [ ( \gamma _ { V } f ) ( X ) ] = E [ f ( X ) ]
```
  FIX: ```
$$
E _ { - } [ f ( X ) ] = \lim _ { V \subset \mathbb { Z } ^ { d } } ( \gamma _ { V } f ) ( - ) \leq \lim _ { V \subset \mathbb { Z } ^ { d } } E [ ( \gamma _ { V } f ) ( X ) ] = E [ f ( X ) ]
$$
```
- RAW: ```
\mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \left ( \gamma _ { W } f ) ( X ) ] = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } \gamma _ { W } f g ) ( - ) = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } f g ) ( - ) = \mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \, f ( X ) ]
```
  FIX: ```
$$
\mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \left ( \gamma _ { W } f ) ( X ) ] = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } \gamma _ { W } f g ) ( - ) = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } f g ) ( - ) = \mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \, f ( X ) ]
$$
```
- RAW: ```
A classical consequence of the monotonicity of γ is that it implies that G ( γ ) has a maximal and a minimal element. This substantially simpliﬁes the characterization of uniqueness. The following standard result (see, for example, [5, section 4.3.3]) makes this idea precise. In the sequel, we deﬁne the maximal and minimal conﬁgurations + , − ∈ {− 1 , 1 } Z d as + v = 1 and − v = − 1 for all v ∈ Z d ; moreover, a function f : {− 1 , 1 } Z d → R is said to be local if it depends only on a ﬁnite number of coordinates.
```
  FIX: ```
A classical consequence of the monotonicity of $\gamma$ is that it implies that $\mathcal{G}(\gamma)$ has a maximal and a minimal element. This substantially simplifies the characterization of uniqueness. The following standard result (see, for example, [5, section 4.3.3]) makes this idea precise. In the sequel, we define the maximal and minimal configurations $+ , - \in \{-1, 1\}^{\mathbb{Z}^d}$ as $+_v = 1$ and $-_v = -1$ for all $v \in \mathbb{Z}^d$; moreover, a function $f : \{-1, 1\}^{\mathbb{Z}^d} \to \mathbb{R}$ is said to be local if it depends only on a finite number of coordinates.
```
- RAW: ```
Lemma 5.15. Suppose that γ is monotone. There exist laws P + , P − in G ( γ ) such that
```
  FIX: ```
Lemma 5.15. Suppose that $\gamma$ is monotone. There exist laws $P_+, P_-$ in $\mathcal{G}(\gamma)$ such that
```
- RAW: ```
for every local increasing function f . Moreover,
```
  FIX: ```
for every local increasing function $f$. Moreover,
```
- RAW: ```
for every P in G ( γ ) and local increasing function f . In particular, | G ( γ ) | = 1 iﬀ P + = P − .
```
  FIX: ```
for every $P$ in $\mathcal{G}(\gamma)$ and local increasing function $f$. In particular, $|\mathcal{G}(\gamma)| = 1$ iff $P_+ = P_-$.
```
- RAW: ```
Proof. Let f be a bounded increasing function and let W ⊂ V ⊂⊂ Z d . As γ W f is increasing and γ V = γ V γ W , we readily obtain γ W f ( − ) ≤ γ V f ≤ γ W f ( + ). Thus the net ( γ V f ( − )) V ⊂⊂ Z d is increasing and the net ( γ V f ( + )) V ⊂⊂ Z d is decreasing. Z d
```
  FIX: ```
Proof. Let $f$ be a bounded increasing function and let $W \subset V \Subset \mathbb{Z}^d$. As $\gamma_W f$ is increasing and $\gamma_V = \gamma_V \gamma_W$, we readily obtain $\gamma_W f(-) \leq \gamma_V f \leq \gamma_W f(+)$. Thus the net $(\gamma_V f(-))_{V \Subset \mathbb{Z}^d}$ is increasing and the net $(\gamma_V f(+))_{V \Subset \mathbb{Z}^d}$ is decreasing.
```
- RAW: ```
Now note that {− 1 , 1 } is compact and metrizable (for the product topology). Thus ( γ V ( − , · )) V ⊂⊂ Z d and ( γ V ( + , · )) V ⊂⊂ Z d are precompact for the weak convergence topology. In particular, we can choose a coﬁnal increasing sequence V n ⊂⊂ Z d such that γ V n ( − , · ) → P − and γ V n ( + , · ) → P + weakly for some probability measures P − and P + , respectively. By the above monotonicity, it follows readily that
```
  FIX: ```
Now note that $\{-1, 1\}^{\mathbb{Z}^d}$ is compact and metrizable (for the product topology). Thus $(\gamma_V(-, \cdot))_{V \Subset \mathbb{Z}^d}$ and $(\gamma_V(+, \cdot))_{V \Subset \mathbb{Z}^d}$ are precompact for the weak convergence topology. In particular, we can choose a cofinal increasing sequence $V_n \Subset \mathbb{Z}^d$ such that $\gamma_{V_n}(-, \cdot) \to P_-$ and $\gamma_{V_n}(+, \cdot) \to P_+$ weakly for some probability measures $P_-$ and $P_+$, respectively. By the above monotonicity, it follows readily that
```
- RAW: ```
for every local increasing function f . Moreover, for any measure P in G ( γ ), we have
```
  FIX: ```
for every local increasing function $f$. Moreover, for any measure $P$ in $\mathcal{G}(\gamma)$, we have
```
- RAW: ```
for every local increasing function f , and similarly for the upper bound.
```
  FIX: ```
for every local increasing function $f$, and similarly for the upper bound.
```
- RAW: ```
We now argue that P − and P + are in fact in G ( γ ). To this end, ﬁx any W ⊂⊂ Z d . As W ⊂ V n for all n suﬃciently large (as { V n } is coﬁnal), and as γ W f is local if f is local (by the Markov property of the random ﬁeld), we can write
```
  FIX: ```
We now argue that $P_-$ and $P_+$ are in fact in $\mathcal{G}(\gamma)$. To this end, fix any $W \Subset \mathbb{Z}^d$. As $W \subset V_n$ for all $n$ sufficiently large (as $\{V_n\}$ is cofinal), and as $\gamma_W f$ is local if $f$ is local (by the Markov property of the random field), we can write
```
- RAW: ```
for all local functions f,g . Thus E − [ f ( X ) | X W c ] = ( γ W f )( X ) for all W ⊂⊂ Z d , which implies that P − is in G ( γ ). The conclusion for P + follows identically.
```
  FIX: ```
for all local functions $f, g$. Thus $\mathbf{E}_-[f(X) \mid X_{W^c}] = (\gamma_W f)(X)$ for all $W \Subset \mathbb{Z}^d$, which implies that $P_-$ is in $\mathcal{G}(\gamma)$. The conclusion for $P_+$ follows identically.
```
- RAW: ```
Finally, we argue that | G ( γ ) | = 1 iﬀ P + = P − . If P +   = P − , then evidently | G ( γ ) | ≥ 2. On the other hand, if P + = P − , then the expectation of every local increasing function must coincide for all γ -speciﬁed random ﬁelds. But then all γ -speciﬁed random ﬁelds coincide, as the local increasing functions are measure-determining (the moment generating function E [ e λ 1 X v 1 + ··· + λ m X v m ] determines uniquely the joint law of X v 1 ,...,X v m , and f ( x v 1 ,...,x v m ) = e λ 1 x v 1 + ··· + λ m x v m is local and increasing for every λ 1 ,...,λ m ≥ 0).
```
  FIX: ```
Finally, we argue that $|\mathcal{G}(\gamma)| = 1$ iff $P_+ = P_-$. If $P_+ \neq P_-$, then evidently $|\mathcal{G}(\gamma)| \geq 2$. On the other hand, if $P_+ = P_-$, then the expectation of every local increasing function must coincide for all $\gamma$-specified random fields. But then all $\gamma$-specified random fields coincide, as the local increasing functions are measure-determining (the moment generating function $E[e^{\lambda_1 X_{v_1} + \dots + \lambda_m X_{v_m}}]$ determines uniquely the joint law of $X_{v_1}, \dots, X_{v_m}$, and $f(x_{v_1}, \dots, x_{v_m}) = e^{\lambda_1 x_{v_1} + \dots + \lambda_m x_{v_m}}$ is local and increasing for every $\lambda_1, \dots, \lambda_m \geq 0$).
```
- RAW: ```
We call P + and P − the maximal and minimal elements of G ( γ ). Now recall that if γ is monotone, then so is γ y . Thus G ( γ y ) also has a maximal and a minimal element. The key step in the proof of Theorem 5.12 is the following observation due to F¨llmer [19].
```
  FIX: ```
We call $P_+$ and $P_-$ the maximal and minimal elements of $\mathcal{G}(\gamma)$. Now recall that if $\gamma$ is monotone, then so is $\gamma^y$. Thus $\mathcal{G}(\gamma^y)$ also has a maximal and a minimal element. The key step in the proof of Theorem 5.12 is the following observation due to Föllmer [19].
```
