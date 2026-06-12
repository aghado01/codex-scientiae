[Page 33]

- Figure 1.10 We can derive the sum and product rules of probability by considering two random variables, X, which takes the values {xi} where i = 1, . . . , M, and Y , which takes the values {yj} where j = 1, . . . , L. In this illustration we have M = 5 and L = 3. If we consider a total number N of instances of these variables, then we denote the number


of instances where X = xi and Y = yj by nij, which is the number of points in the corresponding cell of the array. The number of points in column i, corresponding to X = xi, is denoted by ci, and the number of points in row j, corresponding to Y = yj, is denoted by rj.

ci

###### }

| | | | | |
|---|---|---|---|---|
| | | |nij| |
| | | | | |


###### }

yj rj

xi

and the probability of selecting the blue box is 6/10. We write these probabilities as p(B = r) = 4/10 and p(B = b) = 6/10. Note that, by deﬁnition, probabilities must lie in the interval [0,1]. Also, if the events are mutually exclusive and if they include all possible outcomes (for instance, in this example the box must be either red or blue), then we see that the probabilities for those events must sum to one.

We can now ask questions such as: “what is the overall probability that the selection procedure will pick an apple?”, or “given that we have chosen an orange, what is the probability that the box we chose was the blue one?”. We can answer questions such as these, and indeed much more complex questions associated with problems in pattern recognition, once we have equipped ourselves with the two elementary rules of probability, known as the sum rule and the product rule. Having obtained these rules, we shall then return to our boxes of fruit example.

In order to derive the rules of probability, consider the slightly more general example shown in Figure 1.10 involving two random variables X and Y (which could for instance be the Box and Fruit variables considered above). We shall suppose that

- X can take any of the values xi where i = 1,...,M, and Y can take the values yj where j = 1,...,L. Consider a total of N trials in which we sample both of the variables X and Y , and let the number of such trials in which X = xi and Y = yj be nij. Also, let the number of trials in which X takes the value xi (irrespective of the value that Y takes) be denoted by ci, and similarly let the number of trials in which Y takes the value yj be denoted by rj.

The probability that X will take the value xi and Y will take the value yj is written p(X = xi,Y = yj) and is called the joint probability of X = xi and

- Y = yj. It is given by the number of points falling in the cell i,j as a fraction of the total number of points, and hence


nij N

p(X = xi,Y = yj) =

. (1.5) Here we are implicitly considering the limit N → ∞. Similarly, the probability that

- X takes the value xi irrespective of the value of Y is written as p(X = xi) and is given by the fraction of the total number of points that fall in column i, so that


ci N

p(X = xi) =

. (1.6)

Because the number of instances in column i in Figure 1.10 is just the sum of the number of instances in each cell of that column, we have ci = j nij and therefore,
