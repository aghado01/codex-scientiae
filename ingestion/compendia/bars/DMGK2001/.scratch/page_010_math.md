[Page 10]

In a functional magnetic resonance imaging experiment, a subject is placed in a magnetic resonance scanner and asked to perform a sequence of behavioural tasks while threedimensional images of the subject’s brain are acquired at regular intervals. Concentrated neural ﬁring in the brain gives rise to a localised physiological response that is detectable in the images as a small, localised signal change. An analysis of functional magnetic resonance imaging data attempts to identify and characterise these task-related signal changes amidst a complicated noise process and other nuisance sources of variation; see Genovese (2000) for more details.

We consider two simple experiments in which the subject maintains visual ﬁxation on a cross in the centre of the visual ﬁeld while alternating Ssecond periods of rest and an experimental task. In Experiment 1, S = 8 and the task is to tap the thumb and foreﬁnger together. In Experiment 2, S = 42 and the task is to note the location of a ﬂash of light which appears at a random location in the visual ﬁeld. Figure 3 shows magnetic resonance signal time-courses for the two experiments. The signals are taken from small volumes in the brain that are activated by the respective experimental tasks; the task-related signal changes in response to performing the experimental task are visible in both cases.

(a)

Experiment 1

2000

1950

1900

1850

60

0

10

20

30

40

50

Time (sec)

(b)

Experiment 2

600

500

400

300

0

200

400

Time (sec)

600

800

Fig. 3. Magnetic resonance example. The time-courses show the magnetic resonance signal as a thin dotted line. (a) shows the signal for Experiment 1 measured in one volume element over time in ‘local magnetic resonance units’ that depend on the scanner and pre-processing used. Superimposed on the signal are the Bayesian adaptive regression splines ﬁt, solid line in (a), and the spatially adaptive regression spline ﬁt, dashed line. (b) shows the signal for Experiment 2. Superimposed are the spatially adaptive regression spline ﬁt (dashed line), the Bayesian adaptive regression spline ﬁts using a Po(20) prior (solid line) and a Po(3) prior (dotted line) on the number of knots.

Bayesian adaptive regression splines can be useful in functional magnetic resonance imaging in many di ﬀ erent roles. We discuss two here: (i) a ﬂexible denoiser for magnetic resonance time-courses, where all smooth sources of variation are combined into the function being estimated, and (ii) a component in a semiparametric model that explicitly parameterises the task-related signal changes while treating nuisance variation such as drifts ﬂexibly. The ﬁrst approach can serve as a front-end to spatial and regional analyses and group comparisons, automatically incorporating variations in response shape and magnitude across the replicated task blocks in the experiment. The second approach can serve as a component in a hierarchical model for the data and can be used to characterise
