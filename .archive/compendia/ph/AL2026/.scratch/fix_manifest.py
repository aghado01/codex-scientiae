import os

manifest_path = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph\AL2026\.scratch\manifest_051.md"

with open(manifest_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

item1 = "".join(lines[3:11])
item2 = "".join(lines[11:19])
item3 = "".join(lines[19:27])

raw4 = "".join(lines[27:30])
fix4 = "  FIX: ```\nFILL_ME_IN\n```\n"

raw5 = "".join(lines[35:38])
fix5 = "  FIX: ```\nFILL_ME_IN\n```\n"

new_repairs = r"""- RAW: ```
d M ( V I ) = dim Hom A ( M, τV I ) − dim Hom A ( M, E I ) + dim Hom A ( M, V I )
```
  FIX: ```
\( d_M(V_I) = \dim \operatorname{Hom}_A(M, \tau V_I) - \dim \operatorname{Hom}_A(M, E_I) + \dim \operatorname{Hom}_A(M, V_I) \)
```
- RAW: ```
= rank E I ( α ) − rank V I ( α ) − rank ( τV I )( α )
```
  FIX: ```
\( = \operatorname{rank} E_I(\alpha) - \operatorname{rank} V_I(\alpha) - \operatorname{rank} (\tau V_I)(\alpha) \)
```
- RAW: ```
because i ∈ [ m ] (dim( τV I )( x i ) − dim E I ( x i )+dim V I ( x i )) = 0 by the exactness of the almost split sequence.
```
  FIX: ```
because \( \sum_{i \in [m]} (\dim (\tau V_I)(x_i) - \dim E_I(x_i) + \dim V_I(x_i)) = 0 \) by the exactness of the almost split sequence.
```
- RAW: ```
d M ( V I ) = dim Hom A ( M, P a ) − dim Hom A ( M, rad P a )
```
  FIX: ```
\( d_M(V_I) = \dim \operatorname{Hom}_A(M, P_a) - \dim \operatorname{Hom}_A(M, \operatorname{rad} P_a) \)
```
- RAW: ```
= rank V ⇑ a ( α ) − rank V ↑ a ( α ) + n M,I .
```
  FIX: ```
\( = \operatorname{rank} V_{\Uparrow a}(\alpha) - \operatorname{rank} V_{\uparrow a}(\alpha) + n_{M,I} \).
```
- RAW: ```
and E I = E 1 ⊕ E 2 , where
```
  FIX: ```
and \( E_I = E_1 \oplus E_2 \), where
```
"""

new_prose = r"""## REPAIR_PROSE
- RAW: ```
Case 1. By ( Asashiba et al. 2022 , Theorem 17 (2.6)) (the dual of Theorem 3.3 ) and Lemma 2.10 , we have
```
  FIX: ```
Case 1. By (Asashiba et al. 2022, Theorem 17 (2.6)) (the dual of Theorem 3.3) and Lemma 2.10, we have
```
- RAW: ```
Case 2. In this case, we have V I = V ↑ a ∼ = P a , rad P a = V ⇑ a , and V I /V ⇑ a ∼ = V { a } . By ( Asashiba et al. 2022 , Theorem 17 (2.5)), we have
```
  FIX: ```
Case 2. In this case, we have \( V_I = V_{\uparrow a} \simeq P_a \), \( \operatorname{rad} P_a = V_{\Uparrow a} \), and \( V_I / V_{\Uparrow a} \simeq V_{\{a\}} \). By (Asashiba et al. 2022, Theorem 17 (2.5)), we have
```
- RAW: ```
For convenience, P ( α ) in ( 5.61 ) is called a presentation matrix of M . We now exhibit an example of the application of Theorem 5.1 .
```
  FIX: ```
For convenience, \( P(\alpha) \) in (5.61) is called a presentation matrix of \( M \). We now exhibit an example of the application of Theorem 5.1.
```
- RAW: ```
Example 5.2. Let P = G 4 , 2 and I ∈ I be as in Example 3.37 . Then each term of the almost split sequence 0 → τV I → E I → V I → 0 ending in V I is given as follows:
```
  FIX: ```
Example 5.2. Let \( P = G_{4,2} \) and \( I \in \mathcal{I} \) be as in Example 3.37. Then each term of the almost split sequence \( 0 \to \tau V_I \to E_I \to V_I \to 0 \) ending in \( V_I \) is given as follows:
```
"""

manifest_content = f"# Manifest: Page 051\n\n## REPLACE_TABLES\n{raw4}{fix4}{raw5}{fix5}\n## REPAIR_MATH\n{item1}{item2}{item3}{new_repairs}\n{new_prose}"

with open(manifest_path, 'w', encoding='utf-8') as f:
    f.write(manifest_content)

print("Done")
