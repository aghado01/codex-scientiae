[Page 15]

Bias,   standard   deviation,   asymptotic   standard   error   and   coverage   probability   for   the   estimates   of   the   components   of   β,   under   Model   3.   The   classical   and   MM -procedures   are   labeled ls and mm,   respectively.

C 0

C 1

C 2

C 3

ls

mm

ls

mm

ls

mm

ls

mm

β 1

bias

- 0.018

- 0.016

- 0.010

- 0.020

0.009

- 0.021

- 2.975

- 0.010

sd

0.201

0.214

0.635

0.215

5.618

0.213

0.317

0.204

as.se

0.199

0.196

0.934

0.215

5.332

0.918

0.289

0.894

cov.prob

0.952

0.910

0.934

0.922

0.940

0.918

0.000

0.894

β 2

bias

0.002

0.003

0.004

− 0.002

− 0.218

0.003

− 3.024

0.002

sd

0.210

0.215

0.709

0.236

5.959

0.227

0.309

0.225

as.se

0.199

0.194

0.634

0.211

5.328

0.211

0.282

0.204

cov.prob

0.930

0.892

0.916

0.912

0.914

0.918

0.000

0.906

Fig. 2. Conﬁdence intervals for β 1, under Model 3, obtained when using the classical least squares and MM -procedures.

intervals,   however,   as   illustrated   in   Table 3 the   MM -method   leads   to   a   lower   probability   coverage   than   the   least   squares   one,   in   particular   when   estimating   β 2.  The   MM -method   developed   in   this   paper   provides   reliable   conﬁdence   intervals   over   the   considered   contamination   settings,   since   their   shape   is   almost   the   same   as   under C 0 and   the   coverage   probability   is   stable.   In   contrast,   even   when   the   coverage   of   the   least   squares   procedure,   under   C 1 and   C 2,   is   close   to   that   obtained   for   clean   samples,   this   stability   is   obtained   at   the   expense   of   enlarging   the   conﬁdence   intervals,   specially   under   C 2.  The   impact   of   high–leverage   points   on   the   bias   of   the   classical   estimators   already   discussed   is   more   evident   when   looking   at   the   conﬁdence   intervals,   since   none   of   them   contain   the   true   value   of   the   parameter.

To   evaluate   the   behavior of   the   additive   component   estimators,   for   j   = 1,   2,   as   in   Boente   et   al.   ( 2020b ),   we   measured   the   performance   of   the   estimator     η j of   η j through   the   integrated   squared   error   ( ise )   and   the   squared   integrated   bias.   We   approximate   these   measures   over   an   equally   spaced   grid   of   points   { t   } M   = 1,   0   ≤ t 1 < ··· < t M ≤ 1 with   M = 1000,   that   is,   if     η j,  is   the   estimate   of   the   function   η j obtained   with   the     -th   sample   (1   ≤     ≤ N = 500),   we   computed ise 1 M η ( t ) η ( t ) 2 and Bias 2 1 M   1 N η ( t ) η ( t )   2 .

$$
\int _ { J, c } ( \int _ { t } ^ { M } \exp ( \int _ { t } ^ { 2 } ( \int _ { s } ) ^ { 2 } ) \quad & \text {and} \quad \beta \text {ias} _ { j } ^ { 2 } = \frac { 1 } { M } \sum _ { s = 1 } ^ { M } \left ( \frac { 1 } { N } \sum _ { \ell = 1 } ^ { N } \widehat { \eta } _ { j, \ell } ( t _ { s } ) - \eta _ { j } ( t _ { s } ) \right ) ^ { 2 } \,.\\ \\ \text {Note that } \text {Bias} _ { j } ^ { 2 } \, \text {approximate } \int _ { 0 } ^ { 1 } \left \{ ( 1 / N ) \sum _ { j = 1 } ^ { N } \widehat { \eta } _ { j, \ell } ( t ) - \eta _ { j } ( t ) \right \} ^ { 2 } \, d t.\, \text {Taking into account that a few large values}
$$

= = = Note   that   Bias 2 j approximate     1 0   ( 1 / N )   N j = 1   η j,  ( t ) − η j ( t )   2 dt.  Taking   into   account   that   a   few   large   values   of   the ise may   have   a   huge   impact   on   its   mean   over   replications   and   to   prevent   us   for   this   distorted   effect,   instead   of   the   mean   integrated   square   error   we   considered   two   measures   less   affected   by   extreme   values:   the   median   of   the ise,   denoted medise and   the   mean   of   the ise obtained   after   trimming   the   5%   largest   values   labeled 5%-mise.  The   obtained   results   for   the ise are   given   in   Table 4,   while   those   regarding   the   squared   integrated   bias   are   summarized   in   Table 5 where   we   report   100   × Bias 2 j.Some   additional   plots   that   complement   the   Tables   reported   here   may   be   found   in   the   supplementary   material   available

Some additional plots that complement the Tables reported here may be found in the supplementary material available on-line.
