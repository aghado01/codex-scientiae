[Page 23]

Table 2: Regression summary

|Gauss, Cauchy, Low, Medium, High noise, Gene|true noise scale|data size|method|global mean estimate|global deviation estimate|in-segment deviation est.|log-evidence log P ( y )|rel. log-likelihood ll - E [ ll | ˆ f ] Var [ ll | ˆ f ] 1 / 2|Opt.#segm.|Confidence P ( ˆ k ( - 1 , +1) | y )|
|---|---|---|---|---|---|---|---|---|---|---|
|Name|σ|n|P|ˆ ν|ˆ ρ|ˆ σ|log E|ll - E σ ll|ˆ k|C k ( - 1 , +1)|
|GL|0.10|100|G|-0.01|0.69|0.18|39|4.9|3 | 3|74%(0 | 20)|
|GM|0.32|100|G|-0.03|0.73|0.35|-48|1.2|3 | 3|44%(0 | 29)|
|GH|1.00|100|G|-0.10|1.15|1.03|-156|0.3|3 | 4|13%(10 | 12)|
|CL|0.10|100|C|-0.02|0.58|0.09|-17|1.0|3 | 3|69%(0 | 21)|
|CM|0.32|100|C|-0.09|0.70|0.27|-127|0.8|3 | 3|38%(0 | 27)|
|CL|0.10|100|C|-0.20|0.09|0.86|-234|0.9|3 | 4|12%(11 | 11)|
|GMwC|0.32|100|C|0.00|0.49|0.17|-70|1.5|3 | 3|27%(0 | 26)|
|GMwC|0.32|100|G|0.49|1.24|1.22|-160|2.9|5 | 8|8%(8 | 8)|
|CMwG Gen31|-|769|G|0.55|0.45|0.30|-283|-1.5|15 | 34|| 8) | 6)|
|Gen59|-|483|G|1.05|0.44|0.44|-336|-2.3|1 1|8%(0 6)|


|

|

critical steps for good segmentation is determining the right segment number, which we did by maximizing P ( k | y ). The whole curves shown in Figure 7 give additional insight. A representative selection is presented.

For truly piecewise constant functions with k 0 ≪ n segments and low to medium noise, log P ( k | y ) typically raises rapidly with k till k 0 and thereafter decays approximately linear (black curve). This shows that BPCR certainly does not underestimate k 0 ( P ( k<k 0 | y ) ≈ 0). Although it also does not overestimate k 0 , only P ( k ≥ k 0 | y ) ≈ 1, but P ( k 0 | y )  ≈ 1 due to the following reason: If a segment is broken into two (or more) and assigned (approximately) equal levels, the curve and hence the likelihood does not change. BPCR does not explicitly penalize this, only implicitly by the Bayesian averaging (Bayes factor phenomenon [Goo83, Jay03, Mac03]). This gives very roughly an additive term in the log-likelihood of 1 2 log n for each additional degree of freedom (segment level and boundary). This observation is the core of the Bayesian Information Criterion (BIC) [Sch78, KW95, Wea99].

With increasing noise, the acute maximum become more round (blue curve), i.e. as expected, BPCR becomes less sure about the correct number of segments. This uncertainty gets pronounced under misspeciﬁcation (green curve), and in particular when the true number of segments is far from clear (or nonexistent) like in the genome abberation example (red curve). The pink curve shows that log P ( k | y ) is not necessarily unimodal.

Miscellaneous. Table 2 summarizes the most important quantities of the considered examples.
