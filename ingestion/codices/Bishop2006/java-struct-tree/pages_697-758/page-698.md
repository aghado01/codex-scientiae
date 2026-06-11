[Page 698]

Figure A.1 One hundred examples of the MNIST digits chosen at random from the training set.

![image 172](../../../../../images/imageFile172.png)

![image 173](../../../../../images/imageFile173.png)

![image 174](../../../../../images/imageFile174.png)

![image 175](../../../../../images/imageFile175.png)

![image 176](../../../../../images/imageFile176.png)

![image 177](../../../../../images/imageFile177.png)

![image 178](../../../../../images/imageFile178.png)

![image 179](../../../../../images/imageFile179.png)

![image 180](../../../../../images/imageFile180.png)

![image 181](../../../../../images/imageFile181.png)

![image 182](../../../../../images/imageFile182.png)

![image 183](../../../../../images/imageFile183.png)

![image 184](../../../../../images/imageFile184.png)

![image 185](../../../../../images/imageFile185.png)

![image 186](../../../../../images/imageFile186.png)

![image 187](../../../../../images/imageFile187.png)

![image 188](../../../../../images/imageFile188.png)

![image 189](../../../../../images/imageFile189.png)

![image 190](../../../../../images/imageFile190.png)

![image 191](../../../../../images/imageFile191.png)

![image 192](../../../../../images/imageFile192.png)

![image 193](../../../../../images/imageFile193.png)

![image 194](../../../../../images/imageFile194.png)

![image 195](../../../../../images/imageFile195.png)

![image 196](../../../../../images/imageFile196.png)

![image 197](../../../../../images/imageFile197.png)

![image 198](../../../../../images/imageFile198.png)

![image 199](../../../../../images/imageFile199.png)

![image 200](../../../../../images/imageFile200.png)

![image 201](../../../../../images/imageFile201.png)

![image 202](../../../../../images/imageFile202.png)

![image 203](../../../../../images/imageFile203.png)

![image 204](../../../../../images/imageFile204.png)

![image 205](../../../../../images/imageFile205.png)

![image 206](../../../../../images/imageFile206.png)

![image 207](../../../../../images/imageFile207.png)

![image 208](../../../../../images/imageFile208.png)

![image 209](../../../../../images/imageFile209.png)

![image 210](../../../../../images/imageFile210.png)

![image 211](../../../../../images/imageFile211.png)

![image 212](../../../../../images/imageFile212.png)

![image 213](../../../../../images/imageFile213.png)

![image 214](../../../../../images/imageFile214.png)

![image 215](../../../../../images/imageFile215.png)

![image 216](../../../../../images/imageFile216.png)

![image 217](../../../../../images/imageFile217.png)

![image 218](../../../../../images/imageFile218.png)

![image 219](../../../../../images/imageFile219.png)

![image 220](../../../../../images/imageFile220.png)

![image 221](../../../../../images/imageFile221.png)

![image 222](../../../../../images/imageFile222.png)

![image 223](../../../../../images/imageFile223.png)

![image 224](../../../../../images/imageFile224.png)

![image 225](../../../../../images/imageFile225.png)

![image 226](../../../../../images/imageFile226.png)

![image 227](../../../../../images/imageFile227.png)

![image 228](../../../../../images/imageFile228.png)

![image 229](../../../../../images/imageFile229.png)

![image 230](../../../../../images/imageFile230.png)

![image 231](../../../../../images/imageFile231.png)

![image 232](../../../../../images/imageFile232.png)

![image 233](../../../../../images/imageFile233.png)

![image 234](../../../../../images/imageFile234.png)

![image 235](../../../../../images/imageFile235.png)

![image 236](../../../../../images/imageFile236.png)

![image 237](../../../../../images/imageFile237.png)

![image 238](../../../../../images/imageFile238.png)

![image 239](../../../../../images/imageFile239.png)

![image 240](../../../../../images/imageFile240.png)

![image 241](../../../../../images/imageFile241.png)

![image 242](../../../../../images/imageFile242.png)

![image 243](../../../../../images/imageFile243.png)

![image 244](../../../../../images/imageFile244.png)

![image 245](../../../../../images/imageFile245.png)

![image 246](../../../../../images/imageFile246.png)

![image 247](../../../../../images/imageFile247.png)

![image 248](../../../../../images/imageFile248.png)

![image 249](../../../../../images/imageFile249.png)

![image 250](../../../../../images/imageFile250.png)

![image 251](../../../../../images/imageFile251.png)

![image 252](../../../../../images/imageFile252.png)

![image 253](../../../../../images/imageFile253.png)

![image 254](../../../../../images/imageFile254.png)

![image 255](../../../../../images/imageFile255.png)

![image 256](../../../../../images/imageFile256.png)

![image 257](../../../../../images/imageFile257.png)

![image 258](../../../../../images/imageFile258.png)

![image 259](../../../../../images/imageFile259.png)

![image 260](../../../../../images/imageFile260.png)

![image 261](../../../../../images/imageFile261.png)

![image 262](../../../../../images/imageFile262.png)

![image 263](../../../../../images/imageFile263.png)

![image 264](../../../../../images/imageFile264.png)

![image 265](../../../../../images/imageFile265.png)

![image 266](../../../../../images/imageFile266.png)

![image 267](../../../../../images/imageFile267.png)

![image 268](../../../../../images/imageFile268.png)

![image 269](../../../../../images/imageFile269.png)

![image 270](../../../../../images/imageFile270.png)

![image 271](../../../../../images/imageFile271.png)

Oil Flow

This is a synthetic data set that arose out of a project aimed at measuring noninvasively the proportions of oil, water, and gas in North Sea oil transfer pipelines (Bishop and James, 1993). It is based on the principle of dual-energy gamma densitometry. The ideas is that if a narrow beam of gamma rays is passed through the pipe, the attenuation in the intensity of the beam provides information about the density of material along its path. Thus, for instance, the beam will be attenuated more strongly by oil than by gas.

A single attenuation measurement alone is not sufﬁcient because there are two degrees of freedom corresponding to the fraction of oil and the fraction of water (the fraction of gas is redundant because the three fractions must add to one). To address this, two gamma beams of different energies (in other words different frequencies or wavelengths) are passed through the pipe along the same path, and the attenuation of each is measured. Because the absorbtion properties of different materials vary differently as a function of energy, measurement of the attenuations at the two energies provides two independent pieces of information. Given the known absorbtion properties of oil, water, and gas at the two energies, it is then a simple matter to calculate the average fractions of oil and water (and hence of gas) measured along the path of the gamma beams.

There is a further complication, however, associated with the motion of the materials along the pipe. If the ﬂow velocity is small, then the oil ﬂoats on top of the water with the gas sitting above the oil. This is known as a laminar or stratiﬁed
