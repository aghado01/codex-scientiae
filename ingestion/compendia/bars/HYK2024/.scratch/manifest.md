# Repair Manifest — HYK2024

## DELETE
- [Page N] markers: all occurrences throughout the document slices (`page_001.md` through `page_015.md`)
- OCR figure coordinates and debris (page_006, lines 6–55)
- OCR figure coordinates and debris (page_007, lines 5–108)
- OCR figure coordinates and debris (page_008, lines 5–145 and lines 150–209)
- OCR figure coordinates and debris (page_015, lines 6–486)

## FIX_IMAGES
- `page_006.md`: `![...](\<images/imageFile1.png\>)` → `![Linear splines with one, two and four knots](images/HYK2024/imageFile1.png)`
- `page_007.md`: `![...](\<images/imageFile2.png\>)` → `![The posterior distributions of knots in three scenarios by EBARS](images/HYK2024/imageFile2.png)`
- `page_008.md`:
  - `![...](\<images/imageFile3.png\>)` → `![Manifold denoise results for two curve scenarios](images/HYK2024/imageFile3.png)`
  - `![...](\<images/imageFile4.png\>)` → `![Manifold denoise results for the Swiss roll](images/HYK2024/imageFile4.png)`
- `page_013.md`: `![...](\<images/imageFile5.png\>)` → `![Curve spline regression](images/HYK2024/imageFile5.png)`
- `page_015.md`: `![...](\<images/imageFile6.png\>)` → `![Surface spline regression](images/HYK2024/imageFile6.png)`

## REPLACE_TABLES
- Table 1 (page_006): Replace splayed Table 1 with standard Markdown pipe table
- Table 2 (page_007): Replace splayed Table 2 with standard Markdown pipe table
- Table 3 (page_009): Replace splayed/merged Table 3 with standard Markdown pipe table
- Table 4 (page_014): Replace splayed Table 4 with standard Markdown pipe table
- Table 5 (page_014): Replace splayed Table 5 with standard Markdown pipe table

## REPAIR_PROSE
- Author blocks (page_001): Convert H1 author headings to clean bold text metadata
- Section headings: Standardize header levels (H2 for major sections, H3 for minor/sub-sections) across all pages
- Spelling / formatting fixes for OCR garbles across prose:
  - `page_003.md`: `n i k i` → `$\binom{n_i}{k_i}$` and `Π` → `$\Pi$`
  - `page_004.md`: `∞ 0` → `$\int_0^\infty$`
  - `page_009.md`: `d = 1` → `$d = 1$`

## REPAIR_MATH
- `page_003.md`, Equation (3) (OCR'd as display equation on lines 5–7):
  Raw: `y _ { i } = f ( x _ { i } ) + \epsilon _ { i } , \ \epsilon _ { i } \sim N ( 0 , \sigma ^ { 2 } ) ,`
  Fix: `$$ y_i = f(x_i) + \epsilon_i, \quad \epsilon_i \sim N(0, \sigma^2) \tag{1} $$`
- `page_003.md`, Equation (4) (OCR'd as display equation on lines 19–21):
  Raw: `y = Z \beta + \epsilon , \ \epsilon \sim N _ { m } ( 0 , \sigma ^ { 2 } I _ { m } ) ,`
  Fix: `$$ y = Z\beta + \epsilon, \quad \epsilon \sim N_m(0, \sigma^2 I_m) \tag{2} $$`
- `page_003.md`, Prior formula (OCR'd as display equation on lines 31–33):
  Raw: `\pi ( k ) \, \infty \, \tau ( \mathcal { M } _ { k } ) ^ { 1 - \gamma } , \, \pi ( \xi | k ) = 1 / \tau ( \mathcal { M } _ { k } ) , \ \ 0 \leq \gamma \leq 1 .`
  Fix: `$$ \pi(k) \propto \tau(\mathcal{M}_k)^{1-\gamma}, \quad \pi(\xi|k) = \frac{1}{\tau(\mathcal{M}_k)}, \quad 0 \leq \gamma \leq 1 \tag{3} $$`
- `page_004.md`, Equation (4) (OCR'd as display equation on lines 5–7):
  Raw: `\beta | Z , \sigma \sim N _ { \nu } \left ( 0 , m \sigma ^ { 2 } ( Z ^ { \top } Z ) ^ { - 1 } \right ) , \, \pi ( \sigma ) = 1 / \sigma , \ \sigma > 0 .`
  Fix: `$$ \beta | Z, \sigma \sim N_\nu\left(0, m\sigma^2(Z^\top Z)^{-1}\right), \quad \pi(\sigma) = \frac{1}{\sigma}, \quad \sigma > 0 \tag{4} $$`
- `page_004.md`, Equation (5) (OCR'd as display equation on lines 13–15):
  Raw: `p ( k , \xi , \beta , \sigma | y ) = p ( \beta , \sigma | k , \xi , y ) p ( k , \xi | y ) ,`
  Fix: `$$ p(k, \xi, \beta, \sigma | y) = p(\beta, \sigma | k, \xi, y) p(k, \xi | y) \tag{5} $$`
- `page_004.md`, Lemma 1 equations (OCR'd as display equation on lines 21–23):
  Raw: `p ( y | k , \xi ) \in ( m + 1 ) ^ { - \nu / 2 } a _ { k , \xi } ^ { - m / 2 } , \, p ( k , \xi | y ) \subset ( m + 1 ) ^ { - \nu / 2 } a _ { k , \xi } ^ { - m / 2 } \tau ( \mathcal { M } _ { k } ) ^ { - \gamma } .`
  Fix: `$$ p(y|k,\xi) \propto (m+1)^{-\nu/2} a_{k,\xi}^{-m/2}, \quad p(k,\xi|y) \propto (m+1)^{-\nu/2} a_{k,\xi}^{-m/2} \tau(\mathcal{M}_k)^{-\gamma} \tag{6} $$`
- `page_004.md`, Equation (7) (OCR'd as display equation on lines 35–37):
  Raw: `B I C _ { \gamma } ( k , \xi ) = - 2 \log L ( \hat { \beta } , \hat { \sigma } | y , k , \xi ) + ( \nu + 1 ) \log m + 2 \gamma \log \tau ( \mathcal { M } _ { k } ) , \ \ 0 \leq \gamma \leq 1 , \ \ ( 7 )`
  Fix: `$$ \text{BIC}_\gamma(k,\xi) = -2\log L(\hat{\beta},\hat{\sigma}|y,k,\xi) + (\nu+1)\log m + 2\gamma\log\tau(\mathcal{M}_k), \quad 0\leq \gamma\leq 1 \tag{7} $$`
- `page_004.md`, Lemma 2 equation (OCR'd as display equation on lines 43–45):
  Raw: `\hat { p } ( k , \xi | y ) \, \infty \, m ^ { - ( \nu + 1 ) / 2 } ( \hat { \sigma } ^ { 2 } ) ^ { - m / 2 } \tau ( \mathcal { M } _ { k } ) ^ { - \gamma } .`
  Fix: `$$ \hat{p}(k,\xi|y) \propto m^{-(\nu+1)/2} (\hat{\sigma}^2)^{-m/2} \tau(\mathcal{M}_k)^{-\gamma} \tag{8} $$`
- `page_005.md`, Detailed balance equation (OCR'd as display equation on lines 12–14):
  Raw: `p ( k , \xi | y ) q ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) \alpha ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) = p ( k ^ { \prime } , \xi ^ { \prime } | y ) q ( k , \xi | k ^ { \prime } , \xi ^ { \prime } ) \alpha ( k , \xi | k ^ { \prime } , \xi ^ { \prime } ) ,`
  Fix: `$$ p(k,\xi|y)q(k',\xi'|k,\xi)\alpha(k',\xi'|k,\xi) = p(k',\xi'|y)q(k,\xi|k',\xi')\alpha(k,\xi|k',\xi') \tag{9} $$`
- `page_005.md`, Lemma 3 equations (OCR'd as display equation on lines 20–22):
  Raw: `\alpha ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) & = \min \{ 1 , \ ( m + 1 ) ^ { ( \nu - \nu ^ { \prime } ) / 2 } ( a _ { k , \xi } / a _ { k ^ { \prime } , \xi ^ { \prime } } ) ^ { m / 2 } \} , \\ \hat { \alpha } ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) & = \min \{ 1 , \ m ^ { ( \nu - \nu ^ { \prime } ) / 2 } ( \hat { \sigma } ^ { 2 } / ( \hat { \sigma } ^ { \prime } ) ^ { 2 } ) ^ { m / 2 } \} ,`
  Fix: `$$ \begin{aligned} \alpha(k',\xi'|k,\xi) &= \min\left\{1, ~ (m+1)^{(\nu-\nu')/2}(a_{k,\xi}/a_{k',\xi'})^{m/2}\right\}, \\ \hat{\alpha}(k',\xi'|k,\xi) &= \min\left\{1, ~ m^{(\nu-\nu')/2}(\hat{\sigma}^2/(\hat{\sigma}')^2)^{m/2}\right\} \end{aligned} \tag{10} $$`
- `page_007.md`, Manifold data generation equation (OCR'd as display equation on lines 129–131):
  Raw: `X = W + \epsilon , \ \ X , \epsilon \in \mathbb { R } ^ { D } , \ W \in \mathbb { M } ^ { d } ,`
  Fix: `$$ X = W + \epsilon, \quad X, \epsilon \in \mathbb{R}^D, \ W \in \mathbb{M}^d $$`
- `page_009.md`, GMSD equation (OCR'd as display equation on lines 25–27):
  Raw: `G M S D = \frac { 1 } { m } \sum _ { i = 1 } ^ { m } \text {dist} ( \hat { f } \circ \hat { g } ( x _ { i } ) , \mathbb { M } ^ { d } ) ^ { 2 } ,`
  Fix: `$$ \text{GMSD} = \frac{1}{m} \sum_{i=1}^m \text{dist}\left(\hat{f}\circ\hat{g}(x_i), \mathbb{M}^d\right)^2 $$`
- `page_012.md`, Proof of Lemma 1 equations (OCR'd as display equations):
  - lines 9–11: `$$ p(y|k,\xi) = p(y|Z) = \int_{(0,\infty)} \int_{\mathbb{R}^\nu} p(y|Z,\beta,\sigma) \pi(\beta|Z,\sigma)\pi(\sigma) d\beta d\sigma $$`
  - lines 15–17: `$$ \begin{aligned} p(y|Z,\beta,\sigma) &= \frac{1}{(2\pi\sigma^2)^{m/2}} \exp\left\{-\frac{1}{2\sigma^2}(y-Z\beta)^\top(y-Z\beta)\right\}, \\ \pi(\beta|Z,\sigma) &= \frac{1}{(2\pi m\sigma^2)^{\nu/2}}|Z^\top Z|^{1/2} \exp\left\{-\frac{1}{2m\sigma^2}\beta^\top Z^\top Z\beta\right\} \end{aligned} $$`
  - lines 21–23: `$$ p(y|k,\xi) = \int_0^\infty \frac{1}{(2\pi\sigma^2)^{m/2} (m+1)^{\nu/2}} \exp\left\{-\frac{1}{2\sigma^2} a_{k,\xi}\right\} \pi(\sigma) d\sigma $$`
- `page_012.md`, Proof of Lemma 3 equation (OCR'd as display equation on lines 31–33):
  Raw: `\alpha ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) = \min \left \{ 1 , \, \frac { p ( k ^ { \prime } , \xi ^ { \prime } | y ) q ( k , \xi | k ^ { \prime } , \xi ^ { \prime } ) } { p ( k , \xi | y ) q ( k ^ { \prime } , \xi ^ { \prime } | k , \xi ) } \right \} .`
  Fix: `$$ \alpha(k',\xi'|k,\xi) = \min\left\{1, ~ \frac{p(k',\xi'|y)q(k,\xi|k',\xi')}{p(k,\xi|y)q(k',\xi'|k,\xi)}\right\} $$`
