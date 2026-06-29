[Page 1]

# Contextual uncertainty in the primate locus coeruleus: Reconciling theory, behavior and physiology through a combined approach

Azriel Ghadooshahy, Ritwik K. Niyogi, Sheeraz Ahmad, Robert Desimone

# Summary

Mounting theoretical and experimental evidence suggests that major ascending modulatory systems including dopamine, norepinephrine, serotonin and acetylcholine play specific computational roles in neural processing beyond their classically attributed roles in mediating non-specific arousal. Indeed, recent computational work has linked activity in the locus coeruleus-norepinephrine (LC-NE) system to statistical properties of the environment in the form of unexpected uncertainty at two distinct timescales (Yu and Dayan, 2005 Dayan and Yu, 2006).

A key feature—and challenge—of modeling the LC-NE system with Bayesian theory is to take into account the observer’s (subjective) beliefs about behavioral context and task demands. Thus, our approach is to construct generative models of behavioral strategy from choice-behavior, reaction time data and pupil diameter measurements that allow us to quantitatively test model-driven hypothesis about task-related LC neuronal activity. We believe that this approach will enable an unprecedented degree of interpretive power and specificity in studying the LC-NE system and its role in cognitive-behavioral control. Moreover, this work is likely to clarify the relationship between LC-NE activity and non-luminance-mediated pupil diameter modulations, which provide a valuable link to human studies and may to be useful as a non-invasive measurement of otherwise hidden internal states related to arousal and cognitive control.

Here we present data from preliminary experimental and modeling efforts. A promising candidate model of behavioral strategy qualitatively captures the biasing effects of contextual priors on choice-behavior and reaction times. In addition, preliminary pupillometric and putative LC recording data reveal complex effects of both withinand between-trial contextual uncertainty.

Start

Cue

Figure 1. Behavioral task and generative model. (Top)   Schematic of the behavioral paradigm, including instructive and feedback periods. Directional cues (oriented gratings) are more difficult for orientations close to vertical and easier further away. A long delay period ensures the engagement of working memory and temporally disassociates cue-related pupil and LC responses from saccade and feedback-related activity. Feedback tones are either positive (1000hz) or negative (400hz) depending on the correctness of the subject’s choice with 100% validity. Statistical contexts are operationalized by the within-block prior probability of drawing from the set of left versus right cues. Neutral blocks are 50/50 and bias blocks are 80/20 for a given direction, and each session is counter balanced to include bias blocks in both directions with the within-session block order randomly chosen day-to-day. (Bottom)   Generative model representing one plausible behavioral strategy. Context ( λ n ) on trial n represents the prior probability of cue direction. On each trial n , cue ( z n ) generates noisy temporal observations x n 0 ,…x n t within the

Delay

1000ms

Targets

deadline

Caplure

Tone

5OOms)

Wat

(ooms)

3OOms

![In this image there is a diagram with some text and icons.](<2509.21340v1/imageFile1.png>)

[Page 2]

Experiment

![The image is a scatter plot graph with four different categories labeled Experiment, Model, and two additional categories labeled Model and Model. The x-axis is labeled Experiment and the y-axis is labeled Time. The data points are represented by blue and red lines. ### Description of the Data Points: - **Experiment**: The x-axis is labeled Experiment and the y-axis is labeled Time. - **Model**: The x-axis is labeled Model and the y-axis is labeled Time. - **Two Additional Categories**: There are two additional categories labeled Model and Model. ### Analysis: 1. **Experiment**: The x-axis is labeled Experiment and the y-axis is labeled Time. 2. **Model**: The x-axis is labeled Model and the y-axis is labeled Time. 3. **Two Additional Categories**: There are two additional](<2509.21340v1/imageFile2.png>)

Model

Figure 2. Candidate model qualitatively captures contextual effects in behavioral data . (Top) In an earlier reaction time version of the task, due to contextual bias, reaction times are slower on improbable/unexpected trials. The generative model captures qualitative differences in reaction times on expected and unexpected switch trials (trials in which cue direction changes from trial n-1 to n ). (Bottom) In an earlier version of the task with nine cue orientations for each side, our model captures the shift in the psychometric function due to contextual bias. Note that the model reaction times are collapsed into “easy”, “medium” and “difficult” categories.

A<s

420s

Contcrt

Conter

Pright) =05

205

5

Onenution

Orientation

Figure 3. Preliminary LC recordings and pupillometry indicate complex effects of withinand between-trial uncertainty.

  (Top)   During neutral blocks that follow biased blocks, cue-related pupil dilations are larger on unexpected ( left ) versus expected ( right ) switch trials around the block boundary but not later in the same block, indicating within-trial sensitivity to contextual switches. ( Middle ) Both putative LC neuronal activity ( left ) and pupil diameter ( right ) demonstrate sensitivity to previous trial outcomes, with LC activation leading pupil dilation. Shown here are responses in both measurements to feedback tones when trial n-1 was incorrect. Both pupil and LC responses to positive, but not negative, feedback tone are enhanced when the previous trial was incorrect. (Bottom) Cue difficulty and cue probability also interact with pupil diameter measurements. Shown here, when trial n-1 was improbable, on trial n the pupil dilates significantly more during the cue and subsequent delay period following the presentation of difficult cues which indicates that pupil dilations may reflect both withinand between-trial uncertainty.

![The image is a line graph that shows the percentage of people who have used the internet in the United States from 2000 to 2010. The x-axis represents the years, while the y-axis shows the percentage of people who have used the internet. The graph is titled Internet Usage in the United States, 2000-2010 and is labeled as U.S. Internet Usage, 2000-2010. The graph has a title at the top, which reads U.S. Internet Usage, 2000-2010. The x-axis is labeled Years, and the y-axis is labeled Percentage of People who have Used the Internet. The graph shows a trend of increasing internet usage over the years. The percentage of people who have used the internet has increased from 2000 to 201](<2509.21340v1/imageFile3.png>)

0 12

0006

002

200

200

300

500

600

900

1000

1100

1200

1300

1400

1500

1600

170o

1800

1900

2000

[Page 3]

![The image depicts a diagram with three main components: a circle labeled a and two other circles connected by lines. The circle labeled a is connected to the two other circles, which are labeled n-1 and n+1. These circles are connected to the line labeled n-1 and the line labeled n+1 respectively. The line labeled n-1 is connected to the line labeled n+1 and the line labeled n+1 respectively. This line is connected to the line labeled n and the line labeled n+1 respectively. The line labeled n is connected to the line labeled n-1 and the line labeled n+1 respectively. This line is connected to the line labeled n and the line labeled n+1 respectively. The line labeled n is connected to the line labeled n-1](<2509.21340v1/imageFile4.png>)

An-1

An

'n+l

2n+1

2n

2n-1

In-1,

Rn-1

Rn

Volatility

Context

(prior probability Right)

Stimulus Cue

Observations

Feedback

[Page 4]

Context

y(t-1)

y(t)

self-transition

2

1

probability

t = trial number

Bo(dz(t)

=

P= cue probability

specific stimulus

2 =

Stimulus

2(t)

9(2)

Observations

y(t+1)

difficulty

7 = cue

k = timestep within

trials

Rt

Bly(t) |Rt,

R = Feedback

B(dzt)(k) | xt(k), Xt(k-1) _)

d = direction (L or R)

Bo(dz(t) =

[Page 5]

# Predicted NE phasic activation

p=.8

z(t)

L

7(2)

y(t)

5

4

1

3

2

NE

L

NE |R

P=.2

z(t) = R

7(2)

3

4

5

6

Timesteps

8

9


