# Manifest: Page 041

## REPAIR_MATH
- RAW: ```
E _ { + } [ E _ { + } ^ { Y } [ f ( X ) ] \, g ( Y ) ] = E _ { + } [ f ( X ) g ( Y ) ]
```
  FIX: ```
$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = E_{+} [ f(X) g(Y) ]
$$
```
- RAW: ```
E _ { + } [ E _ { + } ^ { Y } [ f ( X ) ] \, g ( Y ) ] = \inf _ { V \subset \mathbb { C } ^ { Z ^ { d } } } E _ { + } [ ( \gamma _ { V } ^ { Y } f ) ( + ) \, g ( Y ) ] .
```
  FIX: ```
$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = \inf_{V \subset \mathbb{Z}^{d}} E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) ] .
$$
```
- RAW: ```
E _ { + } [ E _ { + } ^ { \gamma } [ f ( X ) ] \, g ( Y ) ] & = \inf _ { V \subset \mathbb { C } ^ { z d } } E _ { + } [ E _ { + } ( [ \gamma _ { V } ^ { \gamma } f ) ( + ) \, g ( Y ) | X ] ] \\ & = \inf _ { V \subset \mathbb { C } ^ { z d } } \inf _ { W \subset \mathbb { C } ^ { z d } } \int E _ { + } [ ( \gamma _ { V } ^ { \gamma } f ) ( + ) \, g ( Y ) | X = x ] \, \gamma _ { W } ( + , d x ) \\ & = \inf _ { V \subset \mathbb { C } ^ { z d } } \int E _ { + } [ ( \gamma _ { V } ^ { \gamma } f ) ( + ) \, g ( Y ) | X = x ] \, \gamma _ { V } ( + , d x ) ,
```
  FIX: ```
$$
\begin{aligned}
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] &= \inf_{V \subset \mathbb{Z}^{d}} E_{+} [ E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X ] ] \\
&= \inf_{V \subset \mathbb{Z}^{d}} \inf_{W \subset \mathbb{Z}^{d}} \int E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X = x ] \, \gamma_{W} (+, dx) \\
&= \inf_{V \subset \mathbb{Z}^{d}} \int E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X = x ] \, \gamma_{V} (+, dx) ,
\end{aligned}
$$
```
- RAW: ```
B u t n o t e t h a t w e h a v e r V s u f c i t i l y l a g t a g ( y ) & = g ( y _ { V } ) \\ & \int E _ { + } [ ( \gamma _ { V } ^ { y } f ) ( + ) g ( Y ) | X = x ] \gamma _ { V } ( + , d x ) \\ & = \sum _ { y \in \{ - 1 , + 1 \} ^ { V } } ( \gamma _ { V } ^ { y } f ) ( + ) g ( y ) \int \prod _ { v \in V } g ( x _ { v } , y _ { v } ) \gamma _ { V } ( + , d x ) \\ & = \int \sum _ { y \in \{ - 1 , + 1 \} ^ { V } } f ( x ) g ( y ) \prod _ { v \in V } g ( x _ { v } , y _ { v } ) \gamma _ { V } ( + , d x ) \\ & = \int f ( x ) E _ { + } [ g ( Y ) | X = x ] \gamma _ { V } ( + , d x ) .
```
  FIX: ```
$$
\begin{aligned}
\int E_{+} [ ( \gamma_{V}^{y} f ) (+) g(Y) \mid X = x ] \gamma_{V} (+, dx) &= \sum_{y \in \{-1, +1\}^{V}} ( \gamma_{V}^{y} f ) (+) g(y) \int \prod_{v \in V} g(x_{v}, y_{v}) \gamma_{V} (+, dx) \\
&= \int \sum_{y \in \{-1, +1\}^{V}} f(x) g(y) \prod_{v \in V} g(x_{v}, y_{v}) \gamma_{V} (+, dx) \\
&= \int f(x) E_{+} [ g(Y) \mid X = x ] \gamma_{V} (+, dx) .
\end{aligned}
$$
```
- RAW: ```
E _ { + } [ E _ { + } ^ { Y } [ f ( X ) ] \, g ( Y ) ] = E _ { + } [ f ( X ) \, E _ { + } [ g ( Y ) | X ] ] = E _ { + } [ f ( X ) g ( Y ) ] ,
```
  FIX: ```
$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = E_{+} [ f(X) \, E_{+} [ g(Y) \mid X ] ] = E_{+} [ f(X) g(Y) ] ,
$$
```
- RAW: ```
P _ { + } ^ { Y } = P _ { + } [ X \in \cdot | Y ] = P _ { - } [ X \in \cdot | Y ] = P _ { - } ^ { Y } \ \ a . s .
```
  FIX: ```
$$
P_{+}^{Y} = P_{+} [ X \in \cdot \mid Y ] = P_{-} [ X \in \cdot \mid Y ] = P_{-}^{Y} \quad \text{a.s.}
$$
```

## REPAIR_PROSE
- RAW: ```
Lemma 5.16. Suppose that γ is monotone. Let P + and P − be the maximal and minimal element of G ( γ ) , and let P y + and P y − be the maximal and minimal element of G ( γ y ) . Then P Y + is a version of P + [ X ∈ ·| Y ] and P Y − is a version of P − [ X ∈ ·| Y ] .
```
  FIX: ```
Lemma 5.16. Suppose that \(\gamma\) is monotone. Let \(P^{+}\) and \(P^{-}\) be the maximal and minimal element of \(\mathcal{G}(\gamma)\), and let \(P^{y}_{+}\) and \(P^{y}_{-}\) be the maximal and minimal element of \(\mathcal{G}(\gamma^{y})\). Then \(P^{Y}_{+}\) is a version of \(P^{+}[X \in \cdot \mid Y]\) and \(P^{Y}_{-}\) is a version of \(P^{-}[X \in \cdot \mid Y]\).
```
- RAW: ```
Proof. Let us prove the result for P + ; the conclusion for P − follows in the same manner. Let f,g be local increasing functions. It suﬃces to show that
```
  FIX: ```
Proof. Let us prove the result for \(P^{+}\); the conclusion for \(P^{-}\) follows in the same manner. Let \(f, g\) be local increasing functions. It suffices to show that
```
- RAW: ```
for all local increasing functions f,g . By Lemma 5.15
```
  FIX: ```
for all local increasing functions \(f, g\). By Lemma 5.15
```
- RAW: ```
Now note that ( γ y V f )( + ) is a local increasing function of y by Lemma 5.14. It is easily veriﬁed (as p v ≤ 1 2 for all v ) that E + [ h ( Y V ) | X ] = E + [ h ( Y V ) | X V ] is an increasing function of X V for every increasing function h . Thus we obtain using Lemma 5.15
```
  FIX: ```
Now note that \((\gamma^{y}_{V} f)(+)\) is a local increasing function of \(y\) by Lemma 5.14. It is easily verified (as \(p_{v} \leq 1/2\) for all \(v\)) that \(E_{+}[h(Y_{V}) \mid X] = E_{+}[h(Y_{V}) \mid X_{V}]\) is an increasing function of \(X_{V}\) for every increasing function \(h\). Thus we obtain using Lemma 5.15
```
- RAW: ```
where the last equality follows as the quantity inside the inﬁmum is decreasing in both V and W . But note that we have for every V suﬃciently large that g ( y ) = g ( y V )
```
  FIX: ```
where the last equality follows as the quantity inside the infimum is decreasing in both \(V\) and \(W\). But note that we have for every \(V\) sufficiently large that \(g(y) = g(y_{V})\)
```
- RAW: ```
Taking the inﬁmum over V , it follows that
```
  FIX: ```
Taking the infimum over \(V\), it follows that
```
- RAW: ```
Proof of Theorem 5.12. By Lemma 5.15, | G ( γ ) | = 1 implies P + = P − . But then
```
  FIX: ```
Proof of Theorem 5.12. By Lemma 5.15, \(|\mathcal{G}(\gamma)| = 1\) implies \(P^{+} = P^{-}\). But then
```
- RAW: ```
by Lemma 5.16. Thus | G ( γ Y ) | = 1 a.s. by Lemma 5.15.
```
  FIX: ```
by Lemma 5.16. Thus \(|\mathcal{G}(\gamma^{Y})| = 1\) a.s. by Lemma 5.15.
```
