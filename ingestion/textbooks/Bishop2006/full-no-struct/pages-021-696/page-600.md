[Page 600]

0 €

0

0

X

Fig".. 12.11 Probabilistic PCA visoo,zsbon 01 a portion 0I1he "" !low data setlo< Ihe !irsl 100 (lata »einls, The left..,...nd plot oIIOWS Ihe I'O"leoo< mean proj9c1ions oIlhfI (lata poims on lhe principal subspace. The ,;gtrI·hi\nd plot is obtained by firsl ran<lomly omitting 30% 0I1he variable .aloo. and lhen us>rlg EM 10 MndIe I"" mi...... values. Note I!IaI eac/1 data poinl1hen NoS allea., one missing mea.u,ement but lhoallhe plot i. ""ry ..mia, to lhe ona obtained wit"""l miss.... valL>ll$

subspace to minimize !he squared reoonslruCtioo error in 'oIhich the proje<:tion, are C.,N.

We ean gh'e a ,imple physical analogy for this EM algorithm. which is easily visualized for D = 2 and M = 1. Coo,ider a collectioo nf data point' ,n tWI) dimension', aod let tile u""'-dimensiunal principal subspace be represented by a <ohd rod. Now atlaCh each data point to the nxI via a ,pring oo<:)"ing HooI;:e', law ("umJ energy i, propol1ional 10 ,lie square of lile spring". length). In ll1e E 'tel', we keep the nxI hed and allow the attachment point' tn ,Iide up and <I<,wn ll1e nxI '" a, to minimize ll1e e",,'llY, This cau",. each attachment point (independently) 10 position Itself at the orthogonal pmjeclion of the c~sponding data point onto the nxI. In the M 'tel'. we keep the attachment poiOl' fil<ed and then release tile nxI and allow it to m'>,'e 10 tile minimum energy posilion. 11Ie E and M 'teps are then repeated until a ,uitable c""vergence cri.eri"" is ..,isfled. a. is illuSlrated in Figure 12.12.

# 12.2.3 Bayesian peA

S<J far in OIlr di",""ioo of PeA. we have ",'.nled Ihal tile '"Ine ,II for ,lie dl,nen,ionalit)" of tile principal .ubspace is gi"en, In praclice. ".-e nlmt cOOose a suilable ,..I"" according 10 the application. For ,isuali,a,ion. we ge""",ny choose .\1 = 2. whereas for OIher application, the approrrialC choice for ,1/ ma)" be less dea,. One appmao:h i. 10 pi", the eigen"alue 'peclrum for lhe data set. analog,•." 10 the example in Figure 12.4 for the off_line digits dala SCI, and look to see if lite eige",,,I .... nmurally form two groups comprising a set of ,mall ,'alues separated by a ,ign;flcant gap from a ",t of relativel)" large ,'alues, indicating a natural cholcc f<>r AI, In practice. such a gap i, oflen ''''' seen
