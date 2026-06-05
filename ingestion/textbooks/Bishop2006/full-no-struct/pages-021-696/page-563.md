[Page 563]

For example, suppose we have a distribution p ( z 1 ,z 2 ,z 3 ) over three variables, and at step τ of the algorithm we have selected values z ( τ ) 1 ,z ( τ ) 2 and z ( τ ) 3 . We ﬁrst replace z ( τ ) 1 by a new value z ( τ +1) 1 obtained by sampling from the conditional distribution ( τ ) ( τ )

$$
p ( z _ { 1 } | z _ { 2 } ^ { ( \tau ) } , z _ { 3 } ^ { ( \tau ) } ) . \\ \\ ( \tau + 1 ) \, _ { 2 } = 0 .
$$

Next we replace z ( τ ) 2 by a value z ( τ +1) 2 obtained by sampling from the conditional distribution ( τ +1) ( τ )

$$
p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) \\ \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { w i t h s c r { D } } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { w i t h s c r { D } } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } ) } \intertext { p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) }
$$

so that the new value for z 1 is used straight away in subsequent sampling steps. Then we update z 3 with a sample z ( τ +1) 3 drawn from

$$
p ( z _ { 3 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 2 } ^ { ( \tau + 1 ) } )
$$

and so on, cycling through the three variables in turn.

# Gibbs Sampling

$$
G b b s \, & \, S a m p i l i n g \\ & \, 1 . \ \, \text {Initialize } \{ z _ { i } \colon i = 1 , \dots , M \} \\ & \, 2 . \ \, \text {For } \tau = 1 , \dots , T \colon \\ & \, \quad - \, \text {Sample } z _ { 1 } ^ { ( \tau + 1 ) } \sim p ( z _ { 1 } | z _ { 2 } ^ { ( \tau ) } , z _ { 3 } ^ { ( \tau ) } , \dots , z _ { M } ^ { ( \tau ) } ) . \\ & \, \quad - \, \text {Sample } z _ { 2 } ^ { ( \tau + 1 ) } \sim p ( z _ { 2 } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 3 } ^ { ( \tau ) } , \dots , z _ { M } ^ { ( \tau ) } ) . \\ & \quad \vdots \\ & \, - \, \text {Sample } z _ { j } ^ { ( \tau + 1 ) } \sim p ( z _ { j } | z _ { 1 } ^ { ( \tau + 1 ) } , \dots , z _ { j - 1 } ^ { ( \tau + 1 ) } , z _ { j + 1 } ^ { ( \tau ) } , . . , z _ { M } ^ { ( \tau ) } ) . \\ & \quad \vdots \\ & \, - \, \text {Sample } z _ { M } ^ { ( \tau + 1 ) } \sim p ( z _ { M } | z _ { 1 } ^ { ( \tau + 1 ) } , z _ { 2 } ^ { ( \tau + 1 ) } , \dots , z _ { M - 1 } ^ { ( \tau + 1 ) } ) .
$$

![image 41](../images/imageFile41.png)

# Josiah Willard Gibbs 1839–1903

Gibbs spent almost his entire life living in a house built by his father in New Haven, Connecticut. In 1863, Gibbs was granted the ﬁrst PhD in engineering in the United States, and in 1871 he was appointed to mathematical physics in the United

the first chair of mathematical physics in the United States at Yale, a post for which he received no salary because at the time he had no publications. He developed the field of vector analysis and made contributions to crystallography and planetary orbits. His most famous work, entitled On the Equilibrium of Heterogeneous Substances, laid the foundations for the science of physical chemistry.
