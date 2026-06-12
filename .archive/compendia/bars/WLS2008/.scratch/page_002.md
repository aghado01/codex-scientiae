
![The image is a bar chart titled Time (spokes) rate (spikes). The x-axis represents the time in minutes, ranging from 0 to 800, while the y-axis represents the time in seconds, ranging from 0 to 100. The chart is labeled with the title Time (spokes) rate (spikes). The chart shows the time (in minutes) for each time period on the x-axis, and the time (in seconds) for each time period on the y-axis. The time for each time period is represented by a horizontal bar, with the height of the bar corresponding to the corresponding time. The chart shows that the time for the spokes rate (spikes) is significantly higher than the time for the time (ms) for the same time period. This indicates that the spokes rate is higher for the time period compared to the](<images/WLS2008/imageFile2.png>)

106

firing rate (spikes/s)




−200


200

400

600

800

Time (ms)

Figure 1: Histogram and fits using a Gaussian kernel density estimator (dotted line), logspline (thin line), and BARS (thick line). Units are in spiking events per second, the usual units for intensity functions based on neuronal spiking events. The data come from a neuron in inferotemporal cortex recorded during 16 replications (in physiological jargon, 16 trials) of an experiment described by Baker et al. ( 2002 ).

unbiased cross-validation ( Venables and Ripley 2002 ), which smooths the histogram. From a neurophysiological point of view, it is reasonable to expect the intensity function to vary slowly throughout much of its domain, but perhaps rapidly in a relative short interval. In this situation, the kernel density estimate oversmooths the rapid jump in the intensity, while undersmoothing the portion involving slow variation. It would be preferable to use a method of estimating the intensity function that adapts to functional variation across time.
