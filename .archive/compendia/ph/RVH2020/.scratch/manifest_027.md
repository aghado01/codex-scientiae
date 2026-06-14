# Manifest: Page 027

## REPAIR_MATH
- RAW: ```
v ^ { < v } ] = P [ X _ { t } \in A | Y _ { t } \ \ Y _ { t } \ Y ^ { < v } ] | =
```
  FIX: ```
$$
v ^ { < v } ] = P [ X _ { t } \in A | Y _ { t } \ \ Y _ { t } \ Y ^ { < v } ] | =
$$
```
- RAW: ```
& \text {E} | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \text {P} [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | = \\ & \text {E} | P [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ] - \text {P} [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } ] |
```
  FIX: ```
$$
& \text {E} | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \text {P} [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | = \\ & \text {E} | P [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ] - \text {P} [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } ] |
$$
```
- RAW: ```
0 & = \lim _ { k \to \infty } \mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | \\ & = \mathbf E | \mathbf P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { - k } ) ] - \mathbf P [ X _ { 0 } \in A | y _ { _ { - } } ^ { v } ] | ,
```
  FIX: ```
$$
0 & = \lim _ { k \to \infty } \mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | \\ & = \mathbf E | \mathbf P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { - k } ) ] - \mathbf P [ X _ { 0 } \in A | y _ { _ { - } } ^ { v } ] | ,
$$
```
- RAW: ```
E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee X _ { - k } ) ] - P [ X _ { 0 } \in A | \bigcap _ { v } y _ { - } ^ { v } ] | = 0 .
```
  FIX: ```
$$
E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee X _ { - k } ) ] - P [ X _ { 0 } \in A | \bigcap _ { v } y _ { - } ^ { v } ] | = 0 .
$$
```
- RAW: ```
\bigcap _ { v } y _ { - } ^ { v } = y _ { - } \colon = \sigma \{ Y _ { - 1 } , Y _ { - 2 } , \dots \} \mod P
```
  FIX: ```
$$
\bigcap _ { v } y _ { - } ^ { v } = y _ { - } \colon = \sigma \{ Y _ { - 1 } , Y _ { - 2 } , \dots \} \mod P
$$
```
- RAW: ```
& \lim _ { k \to \infty } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \\ & = E | P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { - } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | \\ & \leq E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | = 0 ,
```
  FIX: ```
$$
& \lim _ { k \to \infty } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \\ & = E | P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { - } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | \\ & \leq E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | = 0 ,
$$
```
- RAW: ```
E | P [ X _ { 0 } \in A | V _ { v } \cap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { _ { - } k } ) ] - P [ X _ { 0 } \in A | V _ { v } \mathcal { Y } _ { _ { - } } ^ { v } ] | = 0 .
```
  FIX: ```
$$
E | P [ X _ { 0 } \in A | V _ { v } \cap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { _ { - } k } ) ] - P [ X _ { 0 } \in A | V _ { v } \mathcal { Y } _ { _ { - } } ^ { v } ] | = 0 .
$$
```
- RAW: ```
\bigvee _ { v } \bigcap _ { k } ( y _ { - } ^ { v } \vee x _ { - k } ) = \bigcap _ { k } \bigvee _ { v } ( y _ { - } ^ { v } \vee x _ { - k } ) \mod P ,
```
  FIX: ```
$$
\bigvee _ { v } \bigcap _ { k } ( y _ { - } ^ { v } \vee x _ { - k } ) = \bigcap _ { k } \bigvee _ { v } ( y _ { - } ^ { v } \vee x _ { - k } ) \mod P ,
$$
```

## REPAIR_PROSE
- RAW: ```
Remark 4.10. It is evident that the intermediate ﬁlter reduces to the ﬁlter if we let v → ∞ ; thus Conjecture 4.1 would be established for translation-invariant models if the limits as k → ∞ and v → ∞ could be exchanged in Theorem 4.5. Similarly, we could aim to obtain the conclusion of Conjecture 4.1 for the prediction ﬁlter by letting v → −∞ . However, we do not know how to establish the validity of Theorem 4.5 in either limit.
```
  FIX: ```
Remark 4.10. It is evident that the intermediate ﬁlter reduces to the ﬁlter if we let \( v \to \infty \); thus Conjecture 4.1 would be established for translation-invariant models if the limits as \( k \to \infty \) and \( v \to \infty \) could be exchanged in Theorem 4.5. Similarly, we could aim to obtain the conclusion of Conjecture 4.1 for the prediction ﬁlter by letting \( v \to -\infty \). However, we do not know how to establish the validity of Theorem 4.5 in either limit.
```
- RAW: ```
as in the proof of Proposition 4.7. Letting k → ∞ and using Theorem 4.5 yields
```
  FIX: ```
as in the proof of Proposition 4.7. Letting \( k \to \infty \) and using Theorem 4.5 yields
```
- RAW: ```
  where we deﬁned the σ -ﬁelds X k = σ { X k ,X k − 1 ,... } and Y v − = σ { Y <v 0 ,Y − 1 ,Y − 2 ,... } . Now let us attempt to take the limit as v → −∞ . This yields

.
```
  FIX: ```
where we deﬁned the \( \sigma \)-ﬁelds \( \mathcal{X}_{-k} = \sigma\{X_{-k}, X_{-k-1}, \dots\} \) and \( \mathcal{Y}_-^v = \sigma\{Y_0^{<v}, Y_{-1}, Y_{-2}, \dots\} \). Now let us attempt to take the limit as \( v \to -\infty \). This yields
```
- RAW: ```
(the notation F = G mod P indicates that the P -completions of the σ -ﬁelds F and G coincide). Indeed, if this is the case, then we obtain by Jensen’s inequality
```
  FIX: ```
(the notation \( \mathcal{F} = \mathcal{G} \mod P \) indicates that the \( P \)-completions of the \( \sigma \)-ﬁelds \( \mathcal{F} \) and \( \mathcal{G} \) coincide). Indeed, if this is the case, then we obtain by Jensen’s inequality
```
- RAW: ```
where we used k,v ( Y v − ∨ X − k ) ⊇ k ( Y − ∨ X − k ) ⊇ Y − . Similarly, let us take . This yields

Similarly, let us take v →∞ . This yields
```
  FIX: ```
where we used \( \bigcap_{k,v} (\mathcal{Y}_-^v \vee \mathcal{X}_{-k}) \supseteq \bigcap_k (\mathcal{Y}_- \vee \mathcal{X}_{-k}) \supseteq \mathcal{Y}_- \). Similarly, let us take \( v \to \infty \). This yields
```
- RAW: ```
the remainder of the argument proceeding in the same manner as for v → −∞ .
```
  FIX: ```
the remainder of the argument proceeding in the same manner as for \( v \to -\infty \).
```
