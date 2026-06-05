[Page 589]

![image 126](../../../../../images/imageFile126.png)

12.1. I'<incipal Cl)m..."n~nt Anal}'s;, 569

A comparison 01 pro:ipal compoMnt analysis ....111 Fisha(s linaar

- Fig"", 12.7
- Fig"", 12.8 Visualilatlon 01 !he oill'low <lata lIet obtained try projoecting the <lata onto the lirst two prin. cipal compone<1ts. The <ed, blue, and 9r&en points corre-spond to !he 'IamiNI(, 't>omogenoous', and '8nnula~ flow oonligurations ",specriveIy.


###### "

.".,..,'~'"-.~.•••....'_','~.•~''''

discriminant 101 """", <*man""'"

#### ':r-'---~+·_..-:--'~-J

ality r&duclion. Here too data in two dimansions, belonging to two classes sIIOWI1 in red and blue. is to be PfOI"Cled onto a s.ingle di· mension. PCA c/>xlsas the direc· tion 01 maximum varia""e. sIIOWI1 try tha ma9""ta Co""'. wt11ch leads to strong class overlap. whereas !he Fisl>ef IiMar diSCfOrnillant takes accoun1 <:A too class labels and leads to a projection onto the g<ean CUM! giving much t>etler class separation

.,

~,

."

.,':----;!---;-"

_.S 0 3

12.1.4 peA for high-dimensional data

In some application. of pliTlCipal component analysis. the number of data points is smaller than t!>c dimensionality of troe data 'pace. FOI" example. ",e might want to apply PeA to a data <el of a few hundred images, each of ,,'hich rorrespoOOs to a "eetor in a 'pace of poIentially .....ml million dimensiOlls (COITesponding tn thfl'e enlour "alues for each of the pi.",ls in troe image), NOIe that in a D-<limen,ional space a set of jY points. ",'here N < D. defines a linear subspa::e ",hose dimensi"nality is at ""'st N - 1, and SO there is linle point in applying PeA for ,'alue< of M thaI"'" greater than N - I, Indeed, if "'e pelf"",, PeA we will find that at least D - N + I of the eigen".lues art lero. eorrespnnding tQ eigenvectors aloog ",hose direclioos the data <el has 10m varianee. Funhem>ore. typical algOl"ithm, for finding the eigen,'eet""ofa D x D matrix ha"eacomputatiooal eosl thm scales likeO(D~J. aOO so for appliealions such as the image e,ample. a direc' application of PeA will be computatiooally infe,,-sibJe.

W. can resoh'e this problem as foIl",",'" Fir;l. let usdefine X to be the (N " DJ·
