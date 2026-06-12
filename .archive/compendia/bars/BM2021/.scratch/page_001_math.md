[Page 1]

Contents lists available at ScienceDirect

www.elsevier.com/locate/csda

Graciela Boente a, ∗,   Alejandra   Mercedes Martínez b

Article   history: Received   7   August   2021 Received   in   revised   form   28   July   2022 Accepted   2   September   2022 Available   online   7   September   2022

2022

Keywords: B -splines Partially   linear   additive   models Robust   estimation

Robust estimation

Partially   linear   additive   models   generalize   linear   regression   models   by   assuming   that   the   relationship   between   the   response   and   a   set   of   explanatory   variables   is   linear   on   some   of   the   covariates,   while   the   other   ones   enter   into   the   model   through   unknown   univariate   smooth   functions.   The   harmful   effect   of   outliers   either   in   the   residuals   or   in   the   covariates   involved   in   the   linear   component   has   been   described   in   the   situation   of   partially   linear   models,   that   is,   when   only   one   nonparametric   component   is   involved.   When   dealing   with   additive   components,   the   problem   of   providing   reliable   estimators   when   atypical   data   arise   is   of   practical   importance   motivating   the   need   of   robust   procedures.   Based   on   this   fact,   a   family   of   robust   estimators   for   partially   linear   additive   models   that   combines   B splines   with   robust   linear   MM -regression   estimators   is   proposed.   Under   mild   assumptions,   consistency   results   and   rates   of   convergence   for   the   proposed   estimators   are   derived.   Furthermore,   the   asymptotic   normality   for   the   linear   regression   estimators   is   obtained.   A   Monte   Carlo   study   is   carried   out   to   compare,   under   different   models   and   contamination   schemes,   the   performance   of   the   robust   MM -proposal   based   on   B -splines   with   its   classical   counterpart   and   also   with   a   quantile   approach.   The   obtained   results   show   the   beneﬁts   of   using   the   robust   MM -approach.   The   analysis   of   a   real   data   set   illustrates   the   usefulness   of   the   proposed   method.

© 2022 Elsevier B.V. All rights reserved.

Different   approaches   have   been   considered   in   the   literature   to   deal   with   the   well-known   “curse   of   dimensionality” of   fully   nonparametric   regression   models.   Among   others,   we   can   mention   additive,   single–index,   varying   coeﬃcient   and   partial   linear   models.   Speciﬁcally,   partial   linear   models   allow   the   response   variable   to   depend   linearly   on   some   covariates,   while   the   others   are   modeled in   a   fully   non-parametric   way.   More   precisely,   in   such   models   we   deal   with   observations   ( Y i,   Z t i,   X t i ) t independent   and   identically   distributed   (i.i.d.)   with   the   same   distribution   as   ( Y,   Z t,   X t ) t where   Y ∈ R,   Z   ∈ R q and   X   ∈ R p.  The   response   and   covariates   are   related   through

$$
Y = m ( Z, \mathbf X ) + \sigma \, \varepsilon = \beta ^ { \tau } Z + \eta ( \mathbf X ) + \sigma \, \varepsilon \,,
$$

* Corresponding   author   at:   Departamento   de   Matemática   and   Instituto   de   Cálculo,   FCEyN,   UBA,   Ciudad   Universitaria,   Pabellón   0   + ∞,   Buenos   Aires,   C1428EHA,   Argentina.

E-mail addresses: gboente@dm.uba.ar (G. Boente), ale_m_martinez@hotmail.com (A.M. Martínez).
