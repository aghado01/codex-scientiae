[Page 41]

Lemma 5.16. Suppose that \(\gamma\) is monotone. Let \(P^{+}\) and \(P^{-}\) be the maximal and minimal element of \(\mathcal{G}(\gamma)\), and let \(P^{y}_{+}\) and \(P^{y}_{-}\) be the maximal and minimal element of \(\mathcal{G}(\gamma^{y})\). Then \(P^{Y}_{+}\) is a version of \(P^{+}[X \in \cdot \mid Y]\) and \(P^{Y}_{-}\) is a version of \(P^{-}[X \in \cdot \mid Y]\).

Proof. Let us prove the result for \(P^{+}\); the conclusion for \(P^{-}\) follows in the same manner. Let \(f, g\) be local increasing functions. It suffices to show that

$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = E_{+} [ f(X) g(Y) ]
$$

for all local increasing functions \(f, g\). By Lemma 5.15

$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = \inf_{V \subset \mathbb{Z}^{d}} E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) ] .
$$

Now note that \((\gamma^{y}_{V} f)(+)\) is a local increasing function of \(y\) by Lemma 5.14. It is easily verified (as \(p_{v} \leq 1/2\) for all \(v\)) that \(E_{+}[h(Y_{V}) \mid X] = E_{+}[h(Y_{V}) \mid X_{V}]\) is an increasing function of \(X_{V}\) for every increasing function \(h\). Thus we obtain using Lemma 5.15

$$
\begin{aligned}
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] &= \inf_{V \subset \mathbb{Z}^{d}} E_{+} [ E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X ] ] \\
&= \inf_{V \subset \mathbb{Z}^{d}} \inf_{W \subset \mathbb{Z}^{d}} \int E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X = x ] \, \gamma_{W} (+, dx) \\
&= \inf_{V \subset \mathbb{Z}^{d}} \int E_{+} [ ( \gamma_{V}^{Y} f ) (+) \, g(Y) \mid X = x ] \, \gamma_{V} (+, dx) ,
\end{aligned}
$$

where the last equality follows as the quantity inside the infimum is decreasing in both \(V\) and \(W\). But note that we have for every \(V\) sufficiently large that \(g(y) = g(y_{V})\)

$$
\begin{aligned}
\int E_{+} [ ( \gamma_{V}^{y} f ) (+) g(Y) \mid X = x ] \gamma_{V} (+, dx) &= \sum_{y \in \{-1, +1\}^{V}} ( \gamma_{V}^{y} f ) (+) g(y) \int \prod_{v \in V} g(x_{v}, y_{v}) \gamma_{V} (+, dx) \\
&= \int \sum_{y \in \{-1, +1\}^{V}} f(x) g(y) \prod_{v \in V} g(x_{v}, y_{v}) \gamma_{V} (+, dx) \\
&= \int f(x) E_{+} [ g(Y) \mid X = x ] \gamma_{V} (+, dx) .
\end{aligned}
$$

Taking the infimum over \(V\), it follows that

$$
E_{+} [ E_{+}^{Y} [ f(X) ] \, g(Y) ] = E_{+} [ f(X) \, E_{+} [ g(Y) \mid X ] ] = E_{+} [ f(X) g(Y) ] ,
$$

and the proof is complete.

We can now easily complete the proof of Theorem 5.12.

Proof of Theorem 5.12. By Lemma 5.15, \(|\mathcal{G}(\gamma)| = 1\) implies \(P^{+} = P^{-}\). But then

$$
P_{+}^{Y} = P_{+} [ X \in \cdot \mid Y ] = P_{-} [ X \in \cdot \mid Y ] = P_{-}^{Y} \quad \text{a.s.}
$$

by Lemma 5.16. Thus \(|\mathcal{G}(\gamma^{Y})| = 1\) a.s. by Lemma 5.15.
