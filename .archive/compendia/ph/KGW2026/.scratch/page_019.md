[Page 19]

The types \( \gamma_3 \) and \( \gamma_6 \) cannot connect to themselves, but each is one-step connectable to \( \gamma_7 \). Hence they form the third possible family where \( e_{a,b} \) is not an edge and there exists a unique 2-path \( e_{a,*,b} \)

\[
T_3 = (\gamma_3, \gamma_6, \gamma_7).
\]

Finally, since \( \gamma_7 \) contains non-admissible faces in both relevant positions and is one-step connectable to itself, it may form a minimal cluster without any other type. This gives

\[
T_4 = (\gamma_7).
\]

No other minimal cluster can occur. Indeed, any minimal cluster must be connected under the one-step connectability relation; otherwise it would split into two nonempty subclusters whose boundaries are separately allowable, contradicting minimality. Together with the two nonadmissible-free isolated types \( \gamma_8 \) and \( \gamma_9 \), this proves that the minimal clusters are formed exactly by

\[
T_1 = (\gamma_1, \gamma_4, \gamma_7), \quad T_2 = (\gamma_2, \gamma_5, \gamma_7), \quad T_3 = (\gamma_3, \gamma_6, \gamma_7), \quad T_4 = (\gamma_7), \quad T_5 = (\gamma_9), \quad T_6 = (\gamma_8).
\]

The following corollary will describe the exact combinations of \( \gamma_i \) appeared in the minimal cluster.

Corollary 3.8.1. The minimal clusters in \( \Omega_{N,1}^3 \) are exactly the following \( m \geq 0 \):

- For \( i = 1, 2 \), \( \gamma_7 \)-chains of the form

\[
\gamma_i - (\gamma_7)^m - \gamma_j,
\]

where \( j = i \) if \( m \) is even and \( j = i + 3 \) if \( m \) is odd.

- For \( i = 3 \), \( \gamma_7 \)-chains of the form

\[
\gamma_i - (\gamma_7)^m - \gamma_j,
\]

where \( j = i \) if \( m \geq 2 \) is even and \( j = i + 3 \) if \( m \) is odd.

- Pure \( \gamma_7 \)-clusters trapezohedron and the isolated types \( \gamma_8 \) and \( \gamma_9 \).

Proof. By the classification theorem, every minimal cluster lies in one of the families

\[
(\gamma_i, \gamma_{i+3}, \gamma_7), \quad i = 1, 2, 3,
\]

or is one of the isolated types \( \gamma_7 \), \( \gamma_8 \), \( \gamma_9 \).

By Lemma 3.7, the only way to connect \( \gamma_i \) and \( \gamma_{i+3} \) is through \( \gamma_7 \). Hence every nontrivial minimal cluster in these families is a chain whose endpoints lie in \( \{ \gamma_i, \gamma_{i+3} \} \) and whose intermediate vertices are all \( \gamma_7 \).

Each \( \gamma_7 \)-connection switches the endpoint type. Therefore, if the number \( m \) of intermediate \( \gamma_7 \)-vertices is even, the endpoints coincide, while if \( m \) is odd, the endpoints differ. This yields the stated chains.

Minimality forces the chain to terminate exactly at the first cancellation, so no other configurations occur.

Finally, \( \gamma_8 \) and \( \gamma_9 \) contain no non-admissible faces and are therefore isolated. A cluster consisting only of \( \gamma_7 \) must cancel both types of non-admissible faces which forms trapezohedron \( T_m \).
