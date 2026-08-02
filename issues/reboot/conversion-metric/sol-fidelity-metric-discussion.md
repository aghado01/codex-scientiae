Hamming distance assumes two already synchronized streams of equal length.

For canonical character streams \(P\) and \(O\),

\[
h(P,O)=\frac{1}{n}\sum\_{i=1}^{n}[P_i\neq O_i]
\]

answers a precise question:

> What fraction of corresponding serialized characters differ?

That is legitimate artifact fidelity. It requires no semantic weighting. But a single deletion near the beginning shifts every subsequent character and can make an almost-correct document appear almost entirely wrong. Hamming permits substitutions only; edit distance adds insertions and deletions precisely to handle this problem. [This distinction is standard in the sequence-distance literature.](https://arxiv.org/abs/2211.12496)

I would therefore retain the Hamming idea in this form:

1. Canonicalize both manuscripts.
2. Use hashes and exact substrings to establish synchronization.
3. Align the remaining streams.
4. Report separately:

\[
\text{substitution rate}=\frac{S}{N}
\]

\[
\text{indel rate}=\frac{I+D}{N}
\]

\[
\text{character error rate}=\frac{S+I+D}{N}
\]

The substitution component is essentially aligned relative Hamming distance. The complete expression is oracle-relative Levenshtein character error rate.

I would also compute it at two resolutions:

- **Character error rate:** literal serialized-artifact fidelity.
- **Token error rate:** canonical lexical fidelity, treating `\theta` as one token rather than six characters.

That distinction matters:

- `\theta` → `\vartheta` is one lexical substitution but several character edits.
- `+` → `-` is one character and one token substitution, despite potentially reversing the mathematics.
- Removing a `$` may create a small character error but a large boundary error.

Character distance is not wrong; it is deliberately indifferent to significance. It should sit beside exact math-expression hashes and relation/boundary measures rather than being asked to express all of fidelity.

Also, Hamming distance between the **cryptographic hashes** would not work. Avalanche behavior makes two nearly identical documents’ hashes appear unrelated. Hash the documents to test exact equality; calculate Hamming/edit distance on the canonical streams themselves.

On Landauer: philosophically adjacent, but technically no—and my earlier proviso was unnecessarily stated.

If \(C^\*\) is the minimum repair cost, deleting all of \(P\) and inserting all of \(O\) is always an available repair script. Therefore:

\[
C^\*(P\rightarrow O)
\leq
C(P\rightarrow\varnothing)+C(\varnothing\rightarrow O)
\]

automatically. If a substitution is priced above deletion plus insertion,

\[
c(a\rightarrow b)>
c(a\rightarrow\epsilon)+c(\epsilon\rightarrow b),
\]

the optimizer simply will not use that substitution. It is a dominated operation. The relevant mathematical idea is shortest-path closure or the triangle inequality, not thermodynamic irreversibility.

There is nevertheless a lovely Landauer resonance. Landauer’s 1961 argument concerns logically irreversible many-to-one operations such as resetting an unknown bit: the operation destroys distinctions between possible prior states, with a minimum heat cost of \(k_BT\ln 2\) for a maximally unknown bit under the paper’s assumptions. [Landauer’s original paper](https://www.dna.caltech.edu/courses/cs191/paperscs191/landauer1961.pdf) explicitly frames erasure as “RESTORE TO ONE” and derives the entropy/heat cost.

Our delete-and-rebuild baseline also discards one state and constructs another, but its “cost” is symbolic repair work, not physical energy. The closer theoretical connection is actually **description length**:

\[
\text{relative repair burden}
=
\frac{L(\text{edit script transforming }P\text{ into }O)}
{L(\text{script rebuilding }O)}
\]

Relative Hamming is then the simplest special case: fixed alignment, only substitutions, and one unit per differing character. Levenshtein expands the repair language to insertions and deletions; manuscript-aware edit distance expands it further to boundaries and mathematical relations.

So a very principled ladder emerges:

> hash equality → aligned relative Hamming → character/token edit distance → manuscript-grammar repair distance.

> Relative Hamming similarity is the zero-phase slice of a hyperbolic amplitude/phase representation.

After deterministically aligning the canonical streams, let:

- \(N_O\): oracle token mass
- \(N_P\): pdfdig token mass
- \(M\): exactly matched token mass

Define precision and recall:

\[
p=\frac{M}{N_P},
\qquad
r=\frac{M}{N_O}.
\]

Now change coordinates:

\[
A=\sqrt{pr}=\frac{M}{\sqrt{N_PN_O}}
\]

\[
\eta=\frac{1}{2}\log\frac{p}{r}
=\frac{1}{2}\log\frac{N_O}{N_P}.
\]

Here:

- \(A\) is the **fidelity amplitude**: normalized exact overlap.
- \(\eta\) is a signed **hyperbolic phase**, or rapidity: whether pdfdig underproduced or overproduced material.

The inverse is:

\[
p=Ae^\eta,
\qquad
r=Ae^{-\eta}.
\]

Writing

\[
x=\frac{p+r}{2}=A\cosh\eta,
\qquad
y=\frac{p-r}{2}=A\sinh\eta
\]

gives

\[
x^2-y^2=A^2.
\]

So equal-amplitude results lie on hyperbolae; with multiple error dimensions this naturally generalizes to a hyperboloid.

The interpretation is nice:

- Exact transfer: \(A=1,\eta=0\).
- Same-length substitutions: \(A<1,\eta=0\).
- Missing material: \(\eta>0\).
- Duplicated or hallucinated material: \(\eta<0\).
- Equal amounts of missing and extra material: \(\eta=0\), but \(A\) falls.

Ordinary \(F_1\) collapses these two coordinates:

\[
F_1=\frac{A}{\cosh\eta}.
\]

So amplitude and hyperbolic phase actually retain information that a single \(F_1\) score discards.

For equal-length, position-locked streams,

\[
M=N-d_H,
\]

and therefore:

\[
A=1-\frac{d_H}{N},
\qquad
\eta=0.
\]

That is precisely why relative Hamming can be understood as the zero-phase case.

There is also a second kind of phase: positional phase. If the alignment pairs oracle position \(i\) with output position \(j(i)\), define a local displacement field:

\[
\phi(i)=j(i)-i.
\]

Then:

- substitution: amplitude defect without phase slip;
- insertion: positive phase jump;
- deletion: negative phase jump;
- global offset: nearly constant nonzero phase;
- reordering: discontinuous or non-monotone phase;
- exact run: unit amplitude and constant zero phase.

This is arguably even closer to the physical signal analogy. Hamming assumes \(\phi(i)=0\) everywhere. Sequence alignment estimates a piecewise phase field.

I would therefore give every fidelity channel its own state:

```text
channel          amplitude A    hyperbolic phase η    positional phase
prose characters
math tokens
math relations
manuscript boundaries
references/captions
```

The math-token channel might have high amplitude while the math-relation channel is low, exposing correct lexical recovery but broken subscript or fraction assembly. A document with all the right tokens but incorrect `$...$` placement would have strong lexical amplitude and poor boundary phase.

This produces something much more informative than one distance:

\[
\mathcal F_c=(A_c,\eta_c,\phi_c(i))
\]

for each channel \(c\).

I would initially retain this as a product of small hyperbolic state spaces rather than forcing everything onto one grand hyperboloid. Once the channels are empirically stable, they could be embedded into a higher-dimensional hyperboloid whose radius represents total repair burden and whose direction represents the composition of the errors.

fidelity may be better represented as **coherence magnitude plus signed displacement**, with scalar similarity merely a projection of that richer object.
