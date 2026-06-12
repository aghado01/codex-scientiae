
![The image is a line graph that shows the data for several years, specifically from 1880 to 2020. The x-axis represents the years, while the y-axis shows the number of people in thousands. The graph is titled SOC and is labeled as 2020. The graph has a linear scale of range 0 to 20 on the y-axis, with a minimum of 0 and a maximum of 20 on the x-axis. The graph shows a general trend of decreasing numbers of people over the years, with a sharp decline in the early 1900s and a gradual increase in the late 1920s. There are several key observations: 1. **Initial Decline**: The graph shows a significant decline in the number of people from 1880 to 1900. This decline is followed by a gradual increase in the late](<images/MRA2015/imageFile3.png>)



Figure 1.2: Monthly values of the Southern Osciallation Index (SOI).

where the amplitude of the cosine function (1.3) is $R > 0$, its frequency is $\omega$ , and $\Phi$ is its phase. The period of the wave, $1/\omega$ , is the time it takes to complete a cycle. Model (1.3) is not very convenient in estimation since it is not linear in $\Phi$. Using a Trigonometric identity, model (1.3) can be rewritten as

$$
Y _ { t } = A \cos ( 2 \pi \omega t ) + B \sin ( 2 \pi \omega t ) + e _ { t } ,
$$

where $R = \sqrt{A^2 + B^2}$ and $\Phi = \arctan(-B/A)$, and conversely, $A = R\cos(\Phi)$ and $B = -R\sin(\Phi)$. For a fixed frequency $\omega$ , $\cos(2\pi\omega t)$ and $\sin(2\pi\omega t)$ are used as predictor variables and the $A$ and $B$ are estimated using ordinary least squares. In Chapter 4, we will see how this cosine wave helps motivate spectral analysis.

The thesis is structured as follows: Chapter 2 introduces penalized splines in a Bayesian approach and the core model of the thesis. Chapter 3 covers spatially adaptive nonparamtric regression. In Chapter 4, we discuss spectral time series analysis and define
