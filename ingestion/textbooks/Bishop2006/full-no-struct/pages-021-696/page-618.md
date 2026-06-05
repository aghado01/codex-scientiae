[Page 618]

8

.•. '"

'"

FllIu.e 12.21 ?lot ot trle oillkYw <:lata Wllisualiz.ed using PeA on the left and GTM on Itle ngr,t FOf tile GTM model. each <lata poinIls plollfld at tile mean ot its posM'k>< dislribution in .. tent s;>ace, Tile "","ineanty mlhe GTM 1TlOd8I.\_lha sepamlion betwoon the groups of data points to be .....n """. ckl.arfy,

Ch"l'l~f j

S~etioo /.4

The no"liotar mapping is gi,'en by a linear regression model thaI allow, for general IIO/llinearily while being a linear fuoction of tile adapli'-e parameler<, NOIe thaI tilt usual limitation of linear regression models arising from the en"", of dimen,iooalily does 1101 arise in the Contr~1 of lhe GT~I si""'e the "\3nifold generall)' ha< t,,'o di"ltn· sions irrespecti'-e of the dimensionality of the data space, A coo""!",,nce of Illese 11"0 cooices is that the likelihood funclion can be e~pressed analytically in dosed form and can be optimilC<.! efficiently o,ing the EM algorithm\_ The resolting GTM model hIs a lwo-dimensional nonlinear manifold 10 tile dala sel. and by e"alualing the posterior distrilJ",lion (Wer latent space for the data poi"", they can he projectt<J back to the lalent 'JI'K'" for .'isualilalion purposes, Figure 12,21 sl"""s a comparison of the oil data..,1 "isualired wilh lincar PeA and wilh lhe IIO/lhnear GT~I, '''If

TIlt GTM can be seen as a probabilistic "'rsion of an earlier nlOd<l callM the org"nidng ""'p. or SOM (Kohonen. 1982: Kobonen. (995). which also represents a Iwo-dimensiooal IIO/llincar manifoid as a regular array of disc"'le points. The SOM i' somewhat remin;""'nt of the K·trlCan, algorithm in that data points are a.,igr.ed to nearby ProlOl)'j>C '-eclon thaI are lhen subsc<juenlly updale<!. Initially. lhe proIOI)'jl('S are distribuled at random, and during the training process they 'selr organize' so as to aPl'ro~imale a smoolh manifold. Unlike K -mean'. how'e"e.. the SOM is TIOI optimizing any well.ddine<! cost function (Erwin .. al.. 1992) making" difficult to s." the parameters of the model and 10 assess con'-ergence. There i' also no guarantee that the '",If-<>rganilalion' will take place .. this is depen""nl 00 the choice of appropriate paranlttcr "aloC' f,,, any particular data sel.

By OOfItrast, GTM optimize, the log likelihood functioo, and the resolting model define' a probabilily den,ity in dma ,pace, In faeL il corre,ponds to a con,m,incd mi,ture of Gaussian, in which the component.' ,h.re a COnlnlOn ".riance.• nd the mean, are con'trained to lie on a 'mooIh tw-o-diITlCn,iooal n1anifold. This proba-
