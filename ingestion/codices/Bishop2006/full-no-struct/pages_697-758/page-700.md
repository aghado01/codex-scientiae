[Page 700]

For safety reasons, the intensity of the gamma beams is kept relatively weak and so to obtain an accurate measurement of the attenuation, the measured beam intensity is integrated over a speciﬁc time interval. For a ﬁnite integration time, there are random ﬂuctuations in the measured intensity due to the fact that the gamma beams comprise discrete packets of energy called photons. In practice, the integration time is chosen as a compromise between reducing the noise level (which requires a long integration time) and detecting temporal variations in the ﬂow (which requires a short integration time). The oil ﬂow data set is generated using realistic known values for the absorption properties of oil, water, and gas at the two gamma energies used, and with a speciﬁc choice of integration time ( 10 seconds) chosen as characteristic of a typical practical setup.

Each point in the data set is generated independently using the following steps:

- 1. Choose one of the three phase conﬁgurations at random with equal probability.
- 2. Choose three random numbers f 1 , f 2 and f 3 from the uniform distribution over (0 , 1) and deﬁne

$$
f _ { o i l } = \frac { f _ { 1 } } { f _ { 1 } + f _ { 2 } + f _ { 3 } } , \quad f _ { w a t e r } = \frac { f _ { 2 } } { f _ { 1 } + f _ { 2 } + f _ { 3 } } .
$$

This treats the three phases on an equal footing and ensures that the volume fractions add to one.

- 3. For each of the six beam lines, calculate the effective path lengths through oil and water for the given phase conﬁguration.
- 4. Perturb the path lengths using the Poisson distribution based on the known beam intensities and integration time to allow for the effect of photon statistics.

Each point in the data set comprises the 12 path length measurements, together with the fractions of oil and water and a binary label describing the phase conﬁguration. The data set is divided into training, validation, and test sets, each of which comprises 1 , 000 independent data points. Details of the data format are available from the book web site.

In Bishop and James (1993), statistical machine learning techniques were used to predict the volume fractions and also the geometrical conﬁguration of the phases shown in Figure A.2, from the 12 -dimensional vector of measurements. The 12 dimensional observation vectors can also be used to test data visualization algorithms.

This data set has a rich and interesting structure, as follows. For any given conﬁguration there are two degrees of freedom corresponding to the fractions of
