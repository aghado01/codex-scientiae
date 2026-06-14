[Page 30]

Definition C.1 Let V : (Ω , F ,P ) → B be a Borel random variable with values in the real separable Banach space B . An element E ( V ) ∈ B is called the Pettis integral of V if E ( f ( V )) = f ( E ( V )) for all f ∈ B ∗ .

The following proposition yields a sufficient condition for Pettis integrability.

Proposition C.2 If E ∥ V ∥ < ∞ , then V has a Pettis integral and ∥ E ( V ) ∥ ≤ E ∥ V ∥ .

For the further framework two notions of convergence of random variables with values in a Banach space are important. Let ( V n ) n ∈ be a sequence of independent copies of V and let further S n := n i =1 V n . Analogously as for real valued random variables, we define that ( V n ) n ∈ converges almost surely to V if P (lim n →∞ V n = V ) = 1 . Furthermore, ( V n ) n ∈ converges weakly to V if for all bounded continuous functions ϕ : B → it holds that lim n →∞ E ( ϕ ( V n )) = E ( ϕ ( V )) .

Theorem C.3 (Strong law of large numbers) It holds that ( 1 n S n ) → E ( V ) almost surely iff E ∥ V ∥ < ∞ .

We call a random variable V with values in a Banach space Gaussian if f ( V ) is a real Gaussian random variable with mean zero for each f ∈ B ∗ . The covariance structure of a random variable with values in a Banach space is defined as the set of expectations E [( f ( V ) − E ( f ( V )))( g ( V ) − E ( g ( V )))] for f,g ∈ B ∗ and it determines a Gaussian random variable completely.

# Theorem C.4 (Central limit theorem)

Let B be a Banach space that has type 2. Let further E ( V ) = 0 and E ( ∥ V ∥ 2 ) < ∞ . Then, 1 √ n S n converges weakly to a Gaussian random variable with the same covariance structure as V .

Recall that for 2 ≤ p < ∞ , the L p -spaces are of type 2.

# References

- [1] Atienza, N., Jimenez, M.-J., Soriano-Trigueros, M. Stable topological summaries for analyzing the organization of cells in a packed tissue . Mathematics, 9 (15). https:/doi.org/10.3390/math9151723 .
- [2] Bhattacharya, S., Ghrist, R., Kumar, V. Persistent homology for path planning in uncertain environments . IEEE Transactions on Robotics, 31 (3) (2015), 578–590. https:/doi.org/10.1109/TRO.2015.2412051 .
- [3] Botnan, M., Lesnick, M. Algebraic stability of zigzag persistence modules . Algebraic and Geometric Topology, 18 (6) (2018), 3133–3204. https:/doi.org/10. 2140/agt.2018.18.3133 .
