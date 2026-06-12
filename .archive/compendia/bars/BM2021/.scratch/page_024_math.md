[Page 24]

The   authors   wish   to   thank   the   Associate   Editor   and   two   anonymous   referees   for   valuable   comments   which   led   to   an   improved   version   of   the   original   paper.   The   research   of   both   authors   was   partially   supported   by   the   Universidad   de   Buenos   Aires   (grant   number   20020170100022BA),   the   FonCyT,   Agencia   Nacional   de   Promoción   de   la   Investigación,   at   Argentina   (grant   number   PICT   2018-00740).   Besides,   the   work   of   Graciela   Boente   was   also   partially   supported   by   the   Ministry   of   Economy,   Industry   and   Competitiveness,   Spain   (MINECO/AEI/FEDER,   UE)   (grant   number   PID2020-116587GB-I00,   CoDyNP),   while   that   of   Alejandra   Martínez   by   the   Universidad   Nacional   de   Luján   (grants   numbers   CD-CBLUJ   301/19,   CD-CBLUJ   204/19   and   RESREC-LUJ   224/19).

From   now   on,   for   any   measure   Q and   class   of   functions   F,   N (  ,   F,   L s ( Q )) and   N [ ] (  ,   F,   L s ( Q )) will   denote   the   covering   and   bracketing   numbers   of   the   class   F with   respect   to   the   distance   in   L s ( Q ),   as   deﬁned,   for   instance,   in   van   der   Vaart   and   Wellner   ( 1996 ).   Furthermore,     G n   F stands   for     G n   F = sup f ∈ F √ n | ( P n − P ) f |,   where   P n stands   for   the   empirical   probability   measure   of   ( Y i,   Z t i,   X t i ) t,   1   ≤ i   ≤ n,   and   P is   the   probability   measure   corresponding   to   ( Y,   Z t,   X t ) t .

A.1.   Proofs   of   Proposition 3.1 and   Theorem 3.2

Lemmas A.1 to   A.5 will   be   needed   to   prove   Proposition 3.1 and   Theorem 3.2.  In   particular,   Lemma A.1,   whose   proof   can   be   found   in   the   supplementary   ﬁle,   regards   the   Fisher-consistency   of   the   proposed   estimators.   Fisher   consistency   guarantees   that   we   are   estimating   the   target   quantities   and   is   a   ﬁrst   step   to   obtain   consistency   results.

Lemma   A.1.   Given   a   ρ -function   ρ satisfying   C1(a),   let   L   : R q + 1 × G p × ( 0,   +∞ )   → R be   the   function   deﬁned   in   ( 11 ).  Then,   under   C2,   we   have   that   for   any   ς > 0

Let   us   state   some   notation   that   will   be   helpful   in   the   sequel.   Given   a   loss   function   ρ : R   → R,   we   deﬁne   the   function   L n : R q + 1 × G p × ( 0,   +∞ )   → R as p

$$
L _ { n } ( a, b, g _ { 1 }, \dots, g _ { p }, \varsigma ) = \frac { 1 } { n } \sum _ { i = 1 } ^ { n } \rho \left ( \frac { Y _ { i } - a - b ^ { \intercal } Z _ { i } - \sum _ { j = 1 } ^ { p } g _ { j } ( X _ { j i } ) } { \varsigma } \right ).\\ \intertext { t h e t h $ L _ { n } $ is the sample version of the function $ I $ defined in ( 1 1 ) }
$$

Note   that   L n is   the   sample   version   of   the   function   L deﬁned   in   ( 11 ).

Recall that S j, 1 ≤ j ≤ p, denotes the linear space spanned by the   centered   B -splines   bases   of   order     j and   size   k j as   deﬁned   in   ( 12 ).   From   now   on,   for   g j ( x )   =   k j − 1 s = 1 c ( j ) s B ( j ) s ( x )   ∈ S j,   1   ≤ j   ≤ p,   and   identifying   the   functions   with   their   coeﬃcients,   we   denote   indistinctly   s n ( a,   b,   g 1,   ...,   g p )   = s n ( a,   b,   c ( 1 ),   ...,   c ( p ) ) as   deﬁned   in   ( 4 ) and   r i ( a,   b,   g 1,   ...,   g p )   = r i ( a,   b,   c ( 1 ),   ...,   c ( p ) ) as   deﬁned   in   ( 3 ) with   c ( j ) = ( c ( j ) 1,   ...,   c ( j ) k j − 1 ) t.To   derive   uniform   results,   Lemma A.2 below   provides   a   bound   to   the   covering   number   of   the   class   of   functions

To derive uniform results, Lemma A.2 below provides a bound to the covering number of the class of functions

$$
\mathcal { F } _ { n } = \left \{ f ( y, z, \mathbf x ) = \rho \left ( \frac { y - a - \mathbf b ^ { T } z - \sum _ { j = 1 } ^ { p } \mathbf c ^ { ( j ) } v ^ { ( j ) } ( \mathbf x _ { j } ) } { \varsigma } \right ), \, a \in \mathbb { R }, \mathbf b \in \mathbb { R } ^ { q }, \mathbf c ^ { ( j ) } \in \mathbb { R } ^ { k - 1 }, \varsigma > 0 \right \} \,,
$$

where   V ( j ) ( t )   = ( B ( j ) 1 ( t ),   ...,   B ( j ) k j − 1 ( t )) t was   deﬁned   in   Section 2.1.  Lemma A.2 is   a   direct   consequence   of   Lemma   S.2.1   in   Boente   et   al.   ( 2020a ) noting   that   the   number   of   parameters   involved   is   q   + K + 1   = q   +   p j = 1 ( k j − 1 )   + 1 and   that   the   class   F n has   envelope   1,   for   that   reason,   its   proof   is   omitted.

Lemma   A.2.   Let   ρ be   a   function   satisfying   C1(a)   and   F n the   class   of   functions   given   in   ( A.1 ).  Then,   for   any   0   <   < 1,   there   exists   some   constant   C > 1 independent   of   n and    ,   such   that

$$
N ( 2 \epsilon, \mathcal { F } _ { n }, L _ { 1 } ( \mathbb { Q } ) ) \leq \left [ C q _ { n } ( 1 6 e ) ^ { q _ { n } } \right ] ^ { q _ { n } - 1 } \right ] ^ { 2 },
$$

where   q n = 2 ( q   +   p j = 1 k j − p   + 4 )   − 1 .
