[Page 587]

![image 124](../../../../../images/imageFile124.png)

11.1. I'rindpall.:"l11pon~nt Anal~·.i. 567

FIIIUr. 1:1:.5 An ",>gi",,1 ~mpIe Irom lI>e 011·_ digils data ...ttOll"1her with its PeA re<:onstnxlions oblair...:! by 'e1aio"li!Xl ,If j)<incipal ~n1S 10< various val,," 01 ,If. As ,II increason !tie re<:onst,uctiOfI ~s more ao::urate and woukl ~ portee! when .-If K D ~ 28 x 28 ~ ."-1.

where we ha"e made moe of the relation

###### x "

= L,-, (x'",)u;

(12.21)

which follow. from the completene" of the {u,I, Thi. represent. a contpre"ioo "f the data >ct. Ilttau>e for each data poim we ha,.. repla«d the V·dimensiooal "o<:lor x" Wilh an ,I[.din>en,ional "o<:tor having componem, (x~'" _ X'",). 11Ie 'mailer the "alue of M. the greater the degree of comp.-e",ion. Example. of PeA ,""on't""tioos of data points for the digits data set are shown in Figure 12.5

Anolher application of priocipal compcmenl analy,i. i' to data pre-processing. In thi' case, lhe goal is nO! dimensionality redUC1ion but rather the tmn,formmion of a data sel in or<k' to standa'lli'.e eenain of ilS pmpenies. This can be in'portanl in allowing .ubsequent pallem ,""ognition algorithm. 10 be applied successfully 10 the data >ct. Typically. il is done wilen the original "ariable. are mea,ured in "arioos dif. ferent unil' or !la"e significantly difTerent ,'ariabilil}'. For instance in the Old Faithful data sel. the time betv.-een eruption. i. typicany an order of magni1Ude greater than lhe dUrali"" of.n erupt;,,". When W'e applied the ".nlCans algorill"" 10 thi< data set, ".-e first made a separ.te linear re-sealing of the individual "anable' socb thm each "ariable had zero mean and unit "ariance. llUs is known as slllNlardiv·.,g the dota. and the cO\'anance matrix for lhe 'lando,di/,ed dala has components

AI''''''''/;'\' A

Seer/on 9.1

(12,22)

where <1, is the ,'anaoceof:c,. This i< known as the(",,,el,,,;,,,, matri.' oftheoriginal dota and ha' the propeny thai if t""o rompooent, X; and x, ofthe data are perfee1ly correl.ted. then Ai _ I.•nd if they a.-e uocorrelated. then Ai _ O.

11",,'1""', using PeA we can make a It>Of'e subst.mial nonnalizat;oo of the data to gi\'C it zero mean and unit co'·ariance. so that different "anables become derorrelate<l To do this. we first ""rile the ei8Cn"cclor equation (12, 17) in the form

su= UL (12.23)
