# Manifest: Page 025

## REPAIR_MATH
- RAW: ```
h ( Z ) \colon = \lim _ { n \to \infty } \frac { H ( Z ^ { B _ { n } } ) } { | B _ { n } | } = H ( Z ^ { q } | Z ^ { \prec q } ) ,
```
  FIX: ```
$$
h ( Z ) \colon = \lim _ { n \to \infty } \frac { H ( Z ^ { B _ { n } } ) } { | B _ { n } | } = H ( Z ^ { q } | Z ^ { \prec q } ) ,
$$
```
- RAW: ```
\lim _ { n \to \infty } H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots ; X _ { - n } ^ { < v } , X _ { - n - 1 } , X _ { - n - 2 } , \dots ) = H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots )
```
  FIX: ```
$$
\lim _ { n \to \infty } H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots ; X _ { - n } ^ { < v } , X _ { - n - 1 } , X _ { - n - 2 } , \dots ) = H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots )
$$
```
- RAW: ```
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } , \\ h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } ,
```
  FIX: ```
$$
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } , \\ h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } ,
$$
```
- RAW: ```
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
```
  FIX: ```
$$
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$
```
- RAW: ```
H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) - H ( Y _ { 0 } ^ { v } | X _ { - k } , Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
```
  FIX: ```
$$
H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) - H ( Y _ { 0 } ^ { v } | X _ { - k } , Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$
```
- RAW: ```
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) & = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ) \\ & = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
```
  FIX: ```
$$
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) & = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ) \\ & = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
$$
```
- RAW: ```
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k + 1 } ^ { < v } , X _ { - k } , \dots ) & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) \\ & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
```
  FIX: ```
$$
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k + 1 } ^ { < v } , X _ { - k } , \dots ) & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) \\ & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
$$
```

- RAW: ```
Let ( Z q ) q ∈ Z 2 be a translation-invariant random ﬁeld such that Z q takes values in a ﬁnite set. In this setting, the entropy rate (or ‘speciﬁc entropy’) h ( Z ) can be expressed in terms of the lexicographic order ≺ on Z 2 [18, 10]:
```
  FIX: ```
Let \( ( Z _ { q } ) _ { q \in \mathbb { Z } ^ { 2 } } \) be a translation-invariant random ﬁeld such that \( Z _ { q } \) takes values in a ﬁnite set. In this setting, the entropy rate (or ‘speciﬁc entropy’) \( h ( Z ) \) can be expressed in terms of the lexicographic order \( \prec \) on \( \mathbb { Z } ^ { 2 } \) [18, 10]:
```

- RAW: ```
where B n is the centered box in Z 2 with radius n and Z B n = { Z q : q ∈ B n } , Z ≺ q = { Z u : u ≺ q } . The random ﬁeld analogue to the above entropy identity was obtained by Conze [10, eq. (20)]: if Z q = ( X v k ,Y v k ) for q = ( k,v ) ∈ Z 2 take values in a ﬁnite set, then
```
  FIX: ```
where \( B _ { n } \) is the centered box in \( \mathbb { Z } ^ { 2 } \) with radius \( n \) and \( Z ^ { B _ { n } } = \{ Z _ { q } : q \in B _ { n } \} \), \( Z ^ { \prec q } = \{ Z _ { u } : u \prec q \} \). The random ﬁeld analogue to the above entropy identity was obtained by Conze [10, eq. (20)]: if \( Z _ { q } = ( X _ { k } ^ { v } , Y _ { k } ^ { v } ) \) for \( q = ( k , v ) \in \mathbb { Z } ^ { 2 } \) take values in a ﬁnite set, then
```

- RAW: ```
for any v ∈ Z . The proof of Proposition 4.7 follows from this identity.
```
  FIX: ```
for any \( v \in \mathbb { Z } \). The proof of Proposition 4.7 follows from this identity.
```

## REPAIR_PROSE

- RAW: ```
conditional entropy rates . If we deﬁne
```
  FIX: ```
conditional entropy rates. If we deﬁne
```
