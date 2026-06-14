[Page 35]

ﬁltrations; see Section 2. We choose to focus solely on 1-dimensional homological features since they relate to periodicity in the underlying time series, which is the deﬁning characteristic of our signals.

Denote the family of persistence diagrams created from SNR i for i = 1 , 5 by D SNR i , and let f SNR i be their global probability densities. Our goal is to verify that SNR 1 and SNR 5 EEG have the same underlying dynamics. A sensible strategy is to select a quantity created from persistence diagrams that is robust to noise, approximate its distribution for SNR i using D SNR i , and then compare the two empirical distributions. To this end, we start by approximating f SNR i with the kernel density estimators ˆ f SNR i ( Z ) := 10 − 2 D ∈ D SNR i K σ ( Z, D ) . For each ﬁxed i = 1 , 5 the persistence diagrams D ∈ D SNR i are the 100 diagrams of each SNR i case. For the noise likelihood model related to the lower part of a persistence diagram, D , we use Eq. (5.1) as the cardinality distribution. Given that features with higher persistence generally describe global topology that is more resilient to noise, and relying on these kernels ˆ f SNR i , we take S = 1 , 000 sample persistence diagrams and compute their bottleneck distance W ∞ ( ∅ ,S j i ) = max ( b,d ) ∈ S j i d − b, where S j i is the j th sample persistence ( j = 1 ,...,S ) diagram distributed according to ˆ f SNR i , i = 1 , 5. These distances create empirical distributions, one for each SNR i EEG denoted by F SNR i . We formally proceed with hypothesis testing

$$
H _ { 0 } \colon F _ { S N R _ { 1 } } = F _ { S N R _ { 5 } } \ v s \ H _ { 1 } \colon F _ { S N R _ { 1 } } \neq F _ { S N R _ { 5 } } .
$$

glyph[negationslash]

Failure to reject H 0 in this case is evidence that D SNR 1 and D SNR 5 have similar behavior for the features less aﬀected by noise, which in turn implies that SNR 1 and SNR 5 have similar underlying dynamics. Finally, we compare these distributions with a two-sided Kolmogorov-Smirnov (KS) Test (Simard, 2011) that yields a p − value=0.72.

| |KS-Test P-value|Time (s)|
|---|---|---|
|KDE MP 0 .|0 . 72|0 . 047|
|PI L ∞ 6 .|15 × 10 −|0 . 042|
|PL L ∞ 0 .|0 . 79|0 . 048|


Table 2: The p-values and run times for each method (KDE, PI, and PL) used for the hypothesis test of Eq. (4).

| |Sample MAD|
|---|---|
|SNR 1|1.040|
|SNR 5|1.035|


Table 3: The sample MADs for SNR 1 and SNR 5 computed by taking the means of the distributions in Fig 11(e) and Fig 11(f), repsectively.

For the sake of comparison to other TDA methods, we also compute persistence images (PIs) with resolution 50 × 50 and spread 0 . 2 using the ramp function to produce weights, (Adams et al., 2017), and persistence landscapes (PLs) from D SNR i , (Bubenik, 2015). We examine the L ∞ -norm as a summary for each of these vectorizations (the L ∞ -norm of the ﬁrst landscape in particular for PLs) since this measurement is also associated with high persistence features. After computing L ∞ -norms for each of the PIs and PLs obtained from D SNR i , we resample each L ∞ empirical distribution 1,000 times to create bootstrapped distributions with size matching those of the W ∞
