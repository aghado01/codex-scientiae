[Page 17]













100













100

Figure 5: [GH: high Gaussian noise] data (blue), PCR (black), BP (red), and variance 1 / 2 (green).

Figure 6: [GH: high Gaussian noise] data with Bayesian regression ± 1 std.deviation.

jump at the ﬁrst and a small jump at the second boundary. For n we chose 100, i.e. f 1 ..f 25 = − 1, f 26 ..f 50 = +1, and f 51 ..f 100 = 0. Data y t was obtained by adding independent Gaussian/Cauchy noise of same scale σ for all t . We considered low σ =0 . 1, medium σ =0 . 32, and high σ =1 noise, resulting in an easy, medium, and hard regression problem (Figures 1-14). We applied our regression algorithm to these 6 data sets (named GL,GM,GH,CL,CM,CH), where we modeled noise and prior as Gaussian or Cauchy with hyper-parameters also estimated by the Algorithms in Table 1. Table 2 contains these and other scalar summaries, like the evidence, likelihood, MAP segment number ˆ k and their probability.

Three segment Gaussian with low noise. Regression for low Gaussian noise ( σ =0 . 1) is very easy. Figure 1 shows the data points (1 ,y 1 ) ,.., (100 ,y 100 ) together with the estimated segment boundaries and levels, i.e. the Piecewise Constant Regression (PCR) curve (black). The red curve (with the two spikes) is the posterior probability that a boundary (break point BP) is at t . It is deﬁned as B t := ˆ k p =1 B pt . Our Bayesian regressor (BPCR) is virtually sure that the boundaries are at t 1 =25 ( B 25 = 100%) and t 2 =50 ( B 25 =99 . 9994%). The segment levels ˆ µ 1 = − 0 . 98 ≈− 1, ˆ µ 2 =0 . 97 ≈ 1, ˆ µ 3 = 0 . 01 ≈ 0 are determined with high accuracy i.e. with low deviation (green curve) σ/ √ 25=2% for the ﬁrst two and σ/ √ 50 ≈ 1 . 4% for the last segment. The Bayesian regression (BR) curve ˆ µ t is identical to PCR.

Three segment Gaussian with medium noise. Little changes for medium Gaussian noise ( σ =0 . 32). Figure 2 shows that the number and location of boundaries is still correctly determined, but the posterior probability of the second boundary location (red curve) starts to get a little broader ( B 50 =87%). The regression curve in Figure 3 is still essentially piecewise constant. At t =50 there is a small kink and the error band gets a little wider, as can better be seen in the (kink of the) green
