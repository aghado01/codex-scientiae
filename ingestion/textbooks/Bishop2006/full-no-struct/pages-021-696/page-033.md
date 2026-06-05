[Page 33]

Figure 1.10 We can derive the sum and product rules of probability by considering two random variables, X , which takes the values { x i } where i = 1 , . . . , M , and Y , which takes the values { y j } where j = 1 , . . . , L . In this illustration we have M = 5 and L = 3 . If we consider a total number N of instances of these variables, then we denote the number of instances where X = x i and Y = y j by n ij , which is the number of points in the corresponding cell of the array. The number of points in column i , corresponding to X = x i , is denoted by c i , and the number of points in row j , corresponding to Y = y j , is denoted by r j .

c

![image 13](../images/imageFile13.png)

i

}

}

y

n

r

j

ij

j

x

i

and the probability of selecting the blue box is 6 / 10 . We write these probabilities as p ( B = r ) = 4 / 10 and p ( B = b ) = 6 / 10 . Note that, by deﬁnition, probabilities must lie in the interval [0 , 1] . Also, if the events are mutually exclusive and if they include all possible outcomes (for instance, in this example the box must be either red or blue), then we see that the probabilities for those events must sum to one.

We can now ask questions such as: “what is the overall probability that the selection procedure will pick an apple?”, or “given that we have chosen an orange, what is the probability that the box we chose was the blue one?”. We can answer questions such as these, and indeed much more complex questions associated with problems in pattern recognition, once we have equipped ourselves with the two elementary rules of probability, known as the sum rule and the product rule . Having obtained these rules, we shall then return to our boxes of fruit example.

In order to derive the rules of probability, consider the slightly more general example shown in Figure 1.10 involving two random variables X and Y (which could for instance be the Box and Fruit variables considered above). We shall suppose that X can take any of the values x i where i = 1 ,...,M , and Y can take the values y j where j = 1 ,...,L . Consider a total of N trials in which we sample both of the variables X and Y , and let the number of such trials in which X = x i and Y = y j be n ij . Also, let the number of trials in which X takes the value x i (irrespective of the value that Y takes) be denoted by c i , and similarly let the number of trials in which Y takes the value y j be denoted by r j .

The probability that X will take the value x i and Y will take the value y j is written p ( X = x i ,Y = y j ) and is called the joint probability of X = x i and Y = y j . It is given by the number of points falling in the cell i , j as a fraction of the total number of points, and hence

$$
p ( X = x _ { i } , Y = y _ { j } ) = \frac { n _ { i j } } { N } .
$$

Here we are implicitly considering the limit N → ∞ . Similarly, the probability that X takes the value x i irrespective of the value of Y is written as p ( X = x i ) and is given by the fraction of the total number of points that fall in column i , so that

$$
p ( X = x _ { i } ) = \frac { c _ { i } } { N } .
$$

Because the number of instances in column i in Figure 1.10 is just the sum of the number of instances in each cell of that column, we have c i = j n ij and therefore,
