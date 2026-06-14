[Page 18]

A sequence of the discrete de Rham co-chain complexes can be defined as follows:

$$
A \text { sequence of the discrete de Rham co-chain complexes can be defined as follows: } \\ \\ C ^ { 0 } ( K _ { 0 } ) \xrightarrow { D _ { 0 } ^ { 0 } } C ^ { 1 } ( K _ { 0 } ) \xrightarrow { D _ { 0 } ^ { 0 } } \dots \xrightarrow { D _ { 0 } ^ { - 1 } } C ^ { k _ { 0 } ^ { + 1 } } \xrightarrow { D _ { 0 } ^ { k _ { 0 } ^ { + 1 } } } \widehat { C } ^ { k + 1 } ( K _ { 0 } ) \xrightarrow { D _ { 0 } ^ { k + 1 } } \dots \\ \left | _ { \downarrow 0 , 1 } \right | _ { \downarrow 0 , 1 } & \quad \left | _ { \downarrow 0 , 1 } \right | _ { \downarrow 0 , 1 } \\ C ^ { 0 } ( K _ { 1 } ) \xrightarrow { D _ { 1 } ^ { 0 } } C ^ { 1 } ( K _ { 1 } ) \xrightarrow { D _ { 1 } ^ { 1 } } \dots \xrightarrow { D _ { 1 } ^ { - 1 } } C ^ { k _ { 1 } } ( K _ { 1 } ) \xrightarrow { D _ { 1 } ^ { k _ { 1 } } } \widehat { C } ^ { k + 1 } ( K _ { 1 } ) \xrightarrow { D _ { 1 } ^ { k + 1 } } \dots \\ \left | _ { I _ { 1 , 1 } } \right | _ { \downarrow 0 , 1 } & \quad \left | _ { I _ { 1 , 1 } } \right | _ { \downarrow 0 , 1 } \\ C ^ { 1 } ( K _ { 2 } ) \xrightarrow { D _ { 2 } ^ { 0 } } C ^ { 1 } ( K _ { 2 } ) \xrightarrow { D _ { 2 } ^ { 1 } } \dots \xrightarrow { D _ { 2 } ^ { - 1 } } C ^ { k ^ { - 1 } } \xrightarrow { D _ { 2 } ^ { k ^ { - 1 } } } \widehat { C } ^ { k } ( K _ { 2 } ) \xrightarrow { D _ { 2 } ^ { k ^ { + 1 } } } \widehat { C } ^ { k + 1 } ( K _ { 2 } ) \xrightarrow { D _ { 2 } ^ { k + 1 } } \dots \\ \left | _ { I _ { 2 , 1 } } \right | _ { \downarrow 0 , 1 } & \quad \left | _ { I _ { 2 , 1 } } \right | _ { \downarrow 0 , 1 } \\ \dots & \quad \dots \\ \\ \text {where } D ^ { k } \colon C ^ { k + 1 } ( K _ { i } ) \to C ^ { k } ( K _ { i } ) \text { denotes the discrete differential operator, and } \delta ^ { k } \colon C ^ { k } ( K _ { i } ) \to C ^ { k ^ { - 1 } } ( K _ { i } )
$$

where D k l : C k + 1 ( K l ) → C k ( K l ) denotes the discrete di ff erential operator, and δ k l : C k ( K l ) → C k − 1 ( K l ) denotes the discrete codi ff erential operator on K l .

To define the persistent discrete Hodge Laplacian, we construct the discrete counterparts of ˜ d l , p and ˜ δ l , p in the previous section. k + 1 , n k 1 k k , n k k , n k , n

Denote by δ l , p : C + ( K l ) → C l , p the operator given as δ l , p = δ l + p I l , p , where δ l + p is the previously defined discrete operator for K l + p and I k , n l , p is the discrete harmonic extension operator defined next. Assuming K l , l + p contains few k -cells, the harmonic extension is then constructed by the linear system L k − 1 , n K l , l + p ζ = 0 , and shifting all ⋆ d ζ values in the overlap of supports of K l and K l , l + p to the righthand side and replacing them with a rescaling of ⋆ω based on the k -volume within each support. More specifically, the resulting system is ˜ L k − 1 , n K l , l + p ˜ ζ = − S k − 1 , n δ k ∂ K l ω, where ˜ L k − 1 , n K l , l + p is the Laplace operator applied to a form ˜ ζ defined on K l , l + p \ ∂ K l , and δ k ∂ K l is the boundary codi ff erential operator that uses the values of ω on ∂ K l to evaluate the neighboring ( k − 1)-cells in K l , l + p \ ∂ K l .

The resulting extension operator

$$
I _ { l , p } = \left ( _ { - D _ { K _ { l , l + p } } ^ { k } ( \tilde { L } _ { K _ { l , l + p } } ^ { k , n } ) ^ { - 1 } S ^ { k , n } \delta _ { \partial K _ { l } } ^ { k } } \right ) ,
$$

where Id K l is the identity matrix in K l up to a rescaling in the boundary, provides the combination of ω in K l and d ˜ ζ in K l , l + p \ ∂ K l , when applied to ω. The matrix corresponding to I l , p is dense for rows corresponding to cells in K l , l + p but diagonal for rows corresponding to cells in K l . Note that δ ∂ K l is not necessarily 0 for co-closed ω , but is 0 for co-exact ω. k 1 n

The adjoint operator of δ + , l , p defines D k l , p . In the following, we drop most of the subscripts for clarity. Recall that ( ω, ˜ d η ) = ( ˜ δω,η ) can be discretized as

$$
[ W ] ^ { T } S [ \tilde { D } E ] = [ S ^ { - 1 } D ^ { T } S I _ { l , p } W ] ^ { T } S [ E ]
$$

with W and E as discrete versions of ω and η . Thus, ˜ D = S − 1 I T l , p S D , from which we may recognize the restriction operator as R = S − 1 I T l , p S . This restriction operator can be seen as the L 2 -projection onto the space formed by all harmonic extensions from Ω K n ( M l ) . k k + 1 ˜

Note that in this case, immediately δ l , p δ l = 0 since the extension operator will generate ζ = 0 for any co-exact form ω = δβ on K l as the righthand side of the associated linear system essentially
