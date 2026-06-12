# Repair Manifest — MRA2015 (Pages 11-20)

## DELETE
- [Page N] markers: all occurrences throughout document chunk
- OCR debris after Fig 1.1 (page_012): `0.8`, `(a)`, `(b)`, etc. up to the caption.
- OCR debris after Fig 1.2 (page_014): `SOI`, `-20`, etc. up to the caption.
- OCR debris after Fig 2.1 (page_018): `weight`, `number of weeks`, up to the caption.
- Empty page (page_015): entirely

## FIX_IMAGES
- `images/imageFile2.png` → `images/MRA2015/imageFile2.png`
- `images/imageFile3.png` → `images/MRA2015/imageFile3.png`
- `images/imageFile4.png` → `images/MRA2015/imageFile4.png`

## REPLACE_TABLES

## REPAIR_PROSE
- page_012, Sec 1.1: `( x − κ ) p +` → `$(x - \kappa)_+^p$`
- page_012, Sec 1.1: `value x` → `value $x$`
- page_012, Sec 1.1: `knot κ` → `knot $\kappa$`
- page_012, Sec 1.1: `( κ 1 ,...,κ K κ )` → `$(\kappa_1, \dots, \kappa_{K_\kappa})$`
- page_012, Sec 1.1: `κ j` → `$\kappa_j$`
- page_012, Sec 1.1: `j th` → `$j$th`
- page_012, Sec 1.1: `for p = 1 , 2, and 3.` → `for $p = 1, 2,$ and $3$.`
- page_012, Sec 1.1: `[0 , 1]` → `$[0, 1]$`
- page_013, Sec 1.2: `{ Y t }` → `$\{Y_t\}$`
- page_013, Sec 1.2: `t = 0 , ± 1 , ± 2 , ± 3 ,...` → `$t = 0, \pm 1, \pm 2, \pm 3, \dots$`
- page_013, Sec 1.2: `γ t,s` → `$\gamma_{t,s}$`
- page_013, Sec 1.2: `t,s = 0 , ± 1 , ± 2 , ± 3 ,...` → `$t,s = 0, \pm 1, \pm 2, \pm 3, \dots$`
- page_013, Sec 1.2: `y 1 ,...,y n` → `$y_1, \dots, y_n$`
- page_013, Sec 1.2: `φ 1 and φ 2` → `$\phi_1$ and $\phi_2$`
- page_013, Sec 1.2: `e 1 ,...e n` → `$e_1, \dots, e_n$`
- page_013, Sec 1.2: `σ 2 e` → `$\sigma^2_e$`
- page_014, Sec 1.2: `R > 0` → `$R > 0$`
- page_014, Sec 1.2: `frequency is ω , and Φ is` → `frequency is $\omega$, and $\Phi$ is`
- page_014, Sec 1.2: `1 /ω` → `$1/\omega$`
- page_014, Sec 1.2: `linear in Φ` → `linear in $\Phi$`
- page_014, Sec 1.2: `R = √ A 2 + B 2` → `$R = \sqrt{A^2 + B^2}$`
- page_014, Sec 1.2: `Φ = arctan( − B/A )` → `$\Phi = \arctan(-B/A)$`
- page_014, Sec 1.2: `A = R cos(Φ) and B = − R sin(Φ)` → `$A = R\cos(\Phi)$ and $B = -R\sin(\Phi)$`
- page_014, Sec 1.2: `frequency ω` → `frequency $\omega$`
- page_014, Sec 1.2: `cos(2 πωt ) and sin(2 πωt )` → `$\cos(2\pi\omega t)$ and $\sin(2\pi\omega t)$`
- page_014, Sec 1.2: `the A and B` → `the $A$ and $B$`
- page_016, Sec 2: `function f ( · )` → `function $f(\cdot)$`
- page_016, Sec 2: `assumes that f is` → `assumes that $f$ is`
- page_016, Sec 2.1: `{ (( x 1 ,y 1 ) ,... ( x n ,y n )) }` → `$\{(x_1, y_1), \dots, (x_n, y_n)\}$`
- page_016, Sec 2.1: `p > 0 and { κ j } K κ j =1` → `$p > 0$ and $\{\kappa_j\}_{j=1}^{K_\kappa}$`
- page_016, Sec 2.1: `β = ( β 0 ,...,β p )` → `$\beta = (\beta_0, \dots, \beta_p)$`
- page_016, Sec 2.1: `b = ( b 1 ,...,b K κ )` → `$b = (b_1, \dots, b_{K_\kappa})$`
- page_016, Sec 2.1: `T = [ X,Z ], θ = ( β , b ) , and let y = ( y 1 ,...,y n )` → `$T = [X, Z]$, $\theta = (\beta, b)$, and let $y = (y_1, \dots, y_n)$`
- page_017, Sec 2.1: `ˆ y = T ˆ θ` → `$\hat{y} = T\hat{\theta}$`
- page_017, Sec 2.1: `λ b b` → `$\lambda b^\prime b$`
- page_017, Sec 2.1: `shrinking b towards` → `shrinking $b$ towards`
- page_017, Sec 2.1: `larger λ` → `larger $\lambda$`
- page_017, Sec 2.1: `parameter λ controls` → `parameter $\lambda$ controls`
- page_017, Sec 2.2: `f ( x ) depends linearly on x , i.e., f ( x ) = β 0 + β 1 x` → `$f(x)$ depends linearly on $x$, i.e., $f(x) = \beta_0 + \beta_1 x$`
- page_017, Sec 2.2: `β 0 and β 1` → `$\beta_0$ and $\beta_1$`
- page_017, Sec 2.2: `weight ij` → `$\text{weight}_{ij}$`
- page_017, Sec 2.2: `week j = j` → `$\text{week}_j = j$`
- page_018, Sec 2.2: `the ij are` → `the $\epsilon_{ij}$ are`
- page_018, Sec 2.2: `from N (0 ,σ 2 )` → `from $N(0, \sigma^2_\epsilon)$`
- page_018, Sec 2.2: `intercept α i` → `intercept $\alpha_i$`
- page_018, Sec 2.2: `slope β 1` → `slope $\beta_1$`
- page_018, Sec 2.2: `intercepts, b 1 , . . . , b 48` → `intercepts, $b_1, \dots, b_{48}$`
- page_019, Sec 2.2: `b i iid ∼ N (0 ,σ 2 b )` → `$b_i \stackrel{iid}{\sim} N(0, \sigma^2_b)$`
- page_019, Sec 2.2: `σ 2 b > 0` → `$\sigma^2_b > 0$`
- page_019, Sec 2.2: `b i ’s` → `$b_i$'s`
- page_019, Sec 2.3: `G = σ 2 b I K κ , and R = σ 2 I n where I K κ is a K κ × K κ identity matrix, I n is a n × n identity matrix, and σ 2 b and σ 2 are positive constants` → `$G = \sigma^2_b I_{K_\kappa}$, and $R = \sigma^2_\epsilon I_n$ where $I_{K_\kappa}$ is a $K_\kappa \times K_\kappa$ identity matrix, $I_n$ is an $n \times n$ identity matrix, and $\sigma^2_b$ and $\sigma^2_\epsilon$ are positive constants`
- page_019, Sec 2.3: `( y | b ) and b` → `$(y | b)$ and $b$`
- page_020, Sec 2.3: `respect to β and b` → `respect to $\beta$ and $b$`
- page_020, Sec 2.3: `θ = ( β , b )` → `$\theta = (\beta, b)$`
- page_020, Sec 2.3: `solve for θ and` → `solve for $\theta$ and`
- page_020, Sec 2.3: `BLUP( y ) = X ˆ β + Z ˆ b = T ˆ θ` → `$\text{BLUP}(y) = X\hat{\beta} + Z\hat{b} = T\hat{\theta}$`
- page_020, Sec 2.3: `Dividing (2.5) by σ 2  ` → `Dividing (2.5) by $\sigma^2_\epsilon$`
- page_020, Sec 2.3: `R = σ 2 I n and G = σ 2 λ I n ≡ σ 2 b I K κ with λ = σ 2 /σ 2 b` → `$R = \sigma^2_\epsilon I_n$ and $G = \sigma^2_\epsilon \lambda I_n \equiv \sigma^2_b I_{K_\kappa}$ with $\lambda = \sigma^2_\epsilon / \sigma^2_b$`
- page_020, Sec 2.3: `parameter λ.` → `parameter $\lambda$.`

## REPAIR_MATH
- page_012, Sec 1.1 equation: replace `K _ { \ }` with `K_{\kappa}`.
- page_013, Sec 1.2: `C o v` → `\text{Cov}`
- page_019, Sec 2.3: `\infty` in `p(y, b)` → `\propto`
- page_020, Sec 2.3 equation 2.15: add `\begin{aligned}` for the alignment.
