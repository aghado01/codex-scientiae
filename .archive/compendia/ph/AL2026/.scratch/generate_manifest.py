import os

page_path = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph\AL2026\.scratch\page_049.md"
manifest_path = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph\AL2026\.scratch\manifest_049.md"

with open(page_path, "r", encoding="utf-8") as f:
    lines = f.read().splitlines()

line41 = lines[41]

manifest = f"""# Manifest: Page 049

## REPLACE_TABLES
- FILL_ME_IN

## REPAIR_MATH
- RAW: ```
M ∈ mod k [ P ]
```
  FIX: ```
\( M \in \operatorname{mod} k[P] \)
```
- RAW: ```
M ∼ = L n ⊕ N
```
  FIX: ```
\( M \cong L^n \oplus N \)
```
- RAW: ```
n ≥ 0
```
  FIX: ```
\( n \ge 0 \)
```
- RAW: ```
¯ d M ( L ) : = n
```
  FIX: ```
\( \bar{{d}}_M(L) := n \)
```
- RAW: ```
¯ d M ( L )
```
  FIX: ```
\( \bar{{d}}_M(L) \)
```
- RAW: ```
d M ( L )
```
  FIX: ```
\( d_M(L) \)
```
- RAW: ```
L = i ∈ [ m ] L i
```
  FIX: ```
\( L = \bigoplus_{{i \in [m]}} L_i \)
```
- RAW: ```
m ≥ 1
```
  FIX: ```
\( m \ge 1 \)
```
- RAW: ```
with each L i indecomposable
```
  FIX: ```
with each \( L_i \) indecomposable
```
- RAW: ```
¯ d M ( L ) = min i ∈ [ m ] d M ( L i )
```
  FIX: ```
\( \bar{{d}}_M(L) = \min_{{i \in [m]}} d_M(L_i) \)
```
- RAW: ```
ζ : Z → P
```
  FIX: ```
\( \zeta : Z \to P \)
```
- RAW: ```
with Z a poset
```
  FIX: ```
with \( Z \) a poset
```
- RAW: ```
R : mod k [ P ] → mod k [ Z ]
```
  FIX: ```
\( R : \operatorname{{mod}} k[P] \to \operatorname{{mod}} k[Z] \)
```
- RAW: ```
induced by ζ .
```
  FIX: ```
induced by \( \zeta \).
```
- RAW: ```
interval I of P .
```
  FIX: ```
interval \( I \) of \( P \).
```
- RAW: ```
If ζ essentially covers I ,
```
  FIX: ```
If \( \zeta \) essentially covers \( I \),
```
- RAW: ```
any M ∈ mod A ,
```
  FIX: ```
any \( M \in \operatorname{{mod}} A \),
```
- RAW: ```
Assume that ζ essentially covers I .
```
  FIX: ```
Assume that \( \zeta \) essentially covers \( I \).
```
- RAW: ```
g : = g 1 0 g 3 g 2
```
  FIX: ```
\( g := \left[\\begin{{smallmatrix}} g_1 & 0 \\\\ g_3 & g_2 \\end{{smallmatrix}}\\right] \)
```
- RAW: ```
in k [ P ]
```
  FIX: ```
in \( k[P] \)
```
- RAW: ```
ζ covers g ,
```
  FIX: ```
\( \zeta \) covers \( g \),
```
- RAW: ```
say ζ ( g ′ ) = g
```
  FIX: ```
say \( \zeta(g') = g \)
```
- RAW: ```
for some g ′ in k [ Z ] .
```
  FIX: ```
for some \( g' \) in \( k[Z] \).
```
- RAW: ```
Let g vu (resp. g ′ vu ) be the ( v, u ) -entry of g (resp. g ′ ).
```
  FIX: ```
Let \( g_{{vu}} \) (resp. \( g'_{{vu}} \)) be the \( (v, u) \)-entry of \( g \) (resp. \( g' \)).
```
- RAW: ```
vu Thus we have M ( g i ) = R ( M )( g ′ i ) for all i = 1 , 2 , 3 . Hence
```
  FIX: ```
Thus we have \( M(g_i) = R(M)(g'_i) \) for all \( i = 1, 2, 3 \). Hence
```
- RAW: ```
r : = d M ( V I ) , s : = ¯ d R ( M ) ( R ( V I )) .
```
  FIX: ```
\( r := d_M(V_I) \), \( s := \bar{{d}}_{{R(M)}}(R(V_I)) \).
```
- RAW: ```
r = s .
```
  FIX: ```
\( r = s \).
```
- RAW: ```
M ∼ = V r I ⊕ N
```
  FIX: ```
\( M \cong V_I^r \oplus N \)
```
- RAW: ```
mod k [ P ] ,
```
  FIX: ```
\( \operatorname{{mod}} k[P] \),
```
- RAW: ```
R ( M ) ∼ = R ( V I ) r ⊕ R ( N ) .
```
  FIX: ```
\( R(M) \cong R(V_I)^r \oplus R(N) \).
```
- RAW: ```
r ≤ s .
```
  FIX: ```
\( r \le s \).
```
- RAW: ```
R ( M ) ∼ = R ( V I ) s ⊕ L
```
  FIX: ```
\( R(M) \cong R(V_I)^s \oplus L \)
```
- RAW: ```
mod k [ Z ] .
```
  FIX: ```
\( \operatorname{{mod}} k[Z] \).
```
- RAW: ```
d _ {{ M }} ( V _ {{ I }} ) = \\bar {{ d }} _ {{ R ( M ) }} ( R ( V _ {{ I }} ) ) .
```
  FIX: ```
$$
d _ {{ M }} ( V _ {{ I }} ) = \\bar {{ d }} _ {{ R ( M ) }} ( R ( V _ {{ I }} ) ) .
$$
```
- RAW: ```
d _ {{ M }} ( V _ {{ I }} ) = \\text {{rank}} \\begin{{bmatrix}} M ( g _ {{ 1 }} ) & 0 \\\\ M ( g _ {{ 3 }} ) & M ( g _ {{ 2 }} ) \\end{{bmatrix}} - \\text {{rank}} \\begin{{bmatrix}} M ( g _ {{ 1 }} ) & 0 \\\\ 0 & M ( g _ {{ 2 }} ) \\end{{bmatrix}} ,
```
  FIX: ```
$$
d _ {{ M }} ( V _ {{ I }} ) = \\text {{rank}} \\begin{{bmatrix}} M ( g _ {{ 1 }} ) & 0 \\\\ M ( g _ {{ 3 }} ) & M ( g _ {{ 2 }} ) \\end{{bmatrix}} - \\text {{rank}} \\begin{{bmatrix}} M ( g _ {{ 1 }} ) & 0 \\\\ 0 & M ( g _ {{ 2 }} ) \\end{{bmatrix}} ,
$$
```
- RAW: ```
M ( g _ {{ v u }} ) = M ( \\zeta ( g _ {{ v u }} ^ {{ \\prime }} ) ) = R ( M ) ( g _ {{ v u }} ^ {{ \\prime }} ) .
```
  FIX: ```
$$
M ( g _ {{ v u }} ) = M ( \\zeta ( g _ {{ v u }} ^ {{ \\prime }} ) ) = R ( M ) ( g _ {{ v u }} ^ {{ \\prime }} ) .
$$
```
- RAW: ```
d _ {{ M }} ( V _ {{ I }} ) = \\text {{rank}} \\left [ \\begin{{matrix}} R ( M ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ R ( M ) ( g _ {{ 3 }} ^ {{ \\prime }} ) & R ( M ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{matrix}} R ( M ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( M ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] .
```
  FIX: ```
$$
d _ {{ M }} ( V _ {{ I }} ) = \\text {{rank}} \\left [ \\begin{{matrix}} R ( M ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ R ( M ) ( g _ {{ 3 }} ^ {{ \\prime }} ) & R ( M ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{matrix}} R ( M ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( M ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] .
$$
```
- RAW: ```
d _ {{ V _ {{ I }} }} ( V _ {{ I }} ) = \\text {{rank}} \\left [ \\begin{{matrix}} R ( V _ {{ I }} ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ R ( V _ {{ I }} ) ( g _ {{ 3 }} ^ {{ \\prime }} ) & R ( V _ {{ I }} ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{matrix}} R ( V _ {{ I }} ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( V _ {{ I }} ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] .
```
  FIX: ```
$$
d _ {{ V _ {{ I }} }} ( V _ {{ I }} ) = \\text {{rank}} \\left [ \\begin{{matrix}} R ( V _ {{ I }} ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ R ( V _ {{ I }} ) ( g _ {{ 3 }} ^ {{ \\prime }} ) & R ( V _ {{ I }} ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{matrix}} R ( V _ {{ I }} ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( V _ {{ I }} ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{matrix}} \\right ] .
$$
```
- RAW: ```
r = d _ {{ M }} ( V _ {{ I }} ) = s \\cdot d _ {{ V _ {{ I }} }} ( V _ {{ I }} ) + \\text {{rank}} \\left [ \\begin{{smallmatrix}} L ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ L ( g _ {{ 3 }} ^ {{ \\prime }} ) & L ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{smallmatrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{smallmatrix}} L ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & L ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{smallmatrix}} \\right ]
```
  FIX: ```
$$
r = d _ {{ M }} ( V _ {{ I }} ) = s \\cdot d _ {{ V _ {{ I }} }} ( V _ {{ I }} ) + \\text {{rank}} \\left [ \\begin{{smallmatrix}} L ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ L ( g _ {{ 3 }} ^ {{ \\prime }} ) & L ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{smallmatrix}} \\right ] - \\text {{rank}} \\left [ \\begin{{smallmatrix}} L ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & L ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{smallmatrix}} \\right ]
$$
```

## REPAIR_PROSE
- RAW: ```
{line41}
```
  FIX: ```
\\text {{rank}} \\begin{{bmatrix}} R ( M ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( M ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{bmatrix}} = s \\text {{rank}} \\begin{{bmatrix}} R ( V _ {{ I }} ) ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & R ( V _ {{ I }} ) ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{bmatrix}} + \\text {{rank}} \\begin{{bmatrix}} L ( g _ {{ 1 }} ^ {{ \\prime }} ) & 0 \\\\ 0 & L ( g _ {{ 2 }} ^ {{ \\prime }} ) \\end{{bmatrix}} . \\tag{{4.57}}
```
- RAW: ```
Note that the formula ( 4.57 ) holds also for M = V I . Thus we have
```
  FIX: ```
Note that the formula (4.57) holds also for \( M = V_I \). Thus we have
```
"""

with open(manifest_path, "w", encoding="utf-8") as f:
    f.write(manifest)
print("Manifest written successfully!")
