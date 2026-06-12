[Page 21]

Table 6

Model 1

Model 2

Model 3

Model 4

Model 5

Model 6

ls

l 1

mm

ls

l 1

mm

ls

l 1

mm

ls

l 1

mm

ls l

l 1

mm

l

l 1

mm

mean -

0.001 0.022

0.002

− 0.001

0.018

− 0.002

0.014

0.040

0.011

− 0.001

0.024 −

0.000

0.004

0.022 −

- 0.001

0.008

0.013 −

0.006

C 0 sd

sd

0.058 0.074

0.107

0.064

0.084

0.070

0.183

0.242

0.196

0.049

0.063

0.052

0.123

0.156

0.130

0.059

0.071

0.061

mean

0.010 0.027

0.003

0.007

0.018

− 0.004

0.007

0.046

0.017

0.009

0.024

0.005

0.025

0.018

0.003 −

0.017

0.007 −

0.008

C 1 sd

sd

0.188 0.082

0.069

0.211

0.091

0.076

0.641

0.262

0.207

0.166

0.072

0.064

0.398

0.166

0.139

0.198

0.086

0.070

mean

2.322 0.082

0.012

2.258

0.071

- 0.005

2.348

0.105

0.015

2.326

0.082

0.001

2.448

0.077

0.000

2.244

0.062

- 0.007

C 2

sd

1.586 0.128

0.185

1.928

0.130

0.003

5.161

0.323

0.006

1.326

0.116

0.000

3.263

0.197

0.155

1.530

0.105

0.007

mean

2.988 3.014

0.010

2.995

3.027

− 0.074

3.564

3.580

0.207

1.675

1.647

- 0.000

2.174

2.211

0.001

2.183

2.132

- 0.007

C 3

sd

0.143 0.186

0.231

0.123

0.153

0.074

0.166

0.212

0.207

0.152

0.189

0.053

0.072

0.093

0.133

0.160

0.193

0.064

Table 7 Estimates   and   their   standard   deviations   using   cubic   splines   to   estimate   h ∗.( out )

β ls

β mm

̂ β ( - out ) ls

β

- 0.5750

- 0.5099

- 0.4733

s β

0.1078

0.0149

0.0720

̂

̂

̂

distorted   (see   Fig.   S.19).   Besides, under   C 2,   their   standard   deviations   are,   in   most   cases,   larger   than   those   obtained   with   the   other   two   methods.   Note   that,   however,   their   huge   bias   make   the   estimate   unreliable.   It   should   be   noticed   that   the   high–leverage   points   of   contamination   C 3 also   affect   the   quantile   estimator,   whose   bias   is   in   some   cases   larger   than   that   of   the   classical   procedure.

In   this   section,   we   analyze the   Boston   housing   data   set,   available   in   the   package MASS in R.  These   data   contain   measurements   from   506   different   houses   taken   at   different   locations   in   Boston   Standard   Metropolitan   Statistical   Area   in   1970   collected   by   the   U.S   Census   Service.   Harrinson   and   Rubinfeld   ( 1978 ) considered   their   median   price   values   and   other   thirteen   socio–demographic   variables   to   evaluate   how   marginal   air   pollution   damages   are   revealed   in   the   housing   market.   Following   Ma   and   Yang   ( 2011 ),   we   modeled the   median   value   of   owner-occupied   homes   in   $1000s,   denoted   MEDV,   with   the   following   four   covariates   of   interest

RM:   average   number   of   rooms   per   dwelling;

TAX:   full-value   property-tax   rate   per   $10,000;

PTRATIO:   pupil-teacher   ratio   by   town   school   district;

LSTAT:   proportion   of   population   that   is   of   “lower   status”   in   %.

These   covariates   were   also   considered   in   Wang   and   Yang   ( 2009 ) who   ﬁt   an   additive   model   to   these   data.   Ma   and   Yang   ( 2011 ) considered   a   partially   linear   additive   model   with   a   linear   component   on   the   pupil–teach   ratio.   For   that   reason,   we   also   propose   to   ﬁt   the   model

$$
M E D V = \mu + \beta P R T A I O + \eta _ { 1 } ( R M ) + \eta _ { 2 } ( \log ( T A X ) ) + \eta _ { 3 } ( \log ( L S T A ) ) + \sigma \, \varepsilon \,, \\ \\ \log ( \mu ) = \mu + \beta P R T A I O + \eta _ { 1 } ( R M ) + \eta _ { 2 } ( \log ( T A X ) ) + \eta _ { 3 } ( \log ( L S T A ) ) + \sigma \, \varepsilon \,, \\
$$

where   the   errors   ε are   assumed   to   be   independent,   independent   of   the   covariates,   with   symmetric   distribution   and   scale   1.   With   the   notation   given   in   equation   ( 2 ),   Z = PTRATIO and   X   = ( X 1,   X 2,   X 3 ) t = ( RM,   log ( TAX ),   log ( LSTAT )) t.To   estimate   the   additive   components,   we   use   cubic   B -splines.   When   estimating   η j,   the   knots   are   taken   as   the    /( k   +

1 )   100% quantiles,       = 1,   ...,   k,   of   the   observed   values   of   the   covariate   X j.  Taking   into   account   that   n   = 506,   the   basis   dimension   k varies   between   4   and   14.   Both   the   classical   and   the   robust   BIC criteria   introduced   in   ( 8 ) selected   k   = 5 to   approximate   the   additive   functions.   When   using   the   robust   procedure,   the   loss   functions   and   their   tuning   constants   were   selected   as   in   the   simulation   study.

In   view   of   the   numerical   results   obtained   in   Section 5,   we   only   computed   the   estimators   obtained   through   the   least   squares   and   the   robust   MM -approach,   that   are   labeled with   the   subscripts ls and mm,   respectively.   The   obtained   estimates   of   μ are     μ ls = 39.340 and     μ mm = 37.998,   while   those   of   β can   be   seen   in   the   left   and   center   columns   of   Table 7.  The   ﬁrst   row   reports   the   estimates     β ls and     β mm while   the   second   row   contains   their   estimated   asymptotic   standard   errors.   As   in   Section 5 and   according   to   Theorem 4.1,   for   the   least   squares   approach,       was   computed   as       =   σ 2   A − 1 with     σ the   standard   deviation   of   the   residuals   obtained   from   the   classical   ﬁt   and     A = ( 1 / n )     n i = 1   Z i −   h ∗ ( X i )    Z i −   h ∗ ( X i )   t where     h ∗ minimizes   the   function   ϒ deﬁned   in   ( 18 ).   When   considering   the   MM -estimators,   as   in   the   numerical   study   reported   in   Section 5,   the   estimated   asymptotic   variances   were   calculated   as   the   diagonal   elements   of       =   B − 1   D   B − 1 following   the   description   to   robustly   estimate   h ∗ given   in   Section 4.1.To   have   an   insight   on   the   shape   of   the   estimated   curves,   the   estimators   of   η j,   j   = 1,   2,   3 are   displayed   in   Fig. 7.  The   robust   and   classical   estimators   are   plotted   in   solid   blue   and   dashed   red   lines,   respectively.   As   in   Section 5,   the   reader   is

To have an insight on the shape of the estimated curves, the estimators of η j, j = 1, 2, 3 are displayed in Fig. 7. The robust and classical estimators are plotted in solid blue and dashed red lines, respectively. As in Section 5, the reader is
