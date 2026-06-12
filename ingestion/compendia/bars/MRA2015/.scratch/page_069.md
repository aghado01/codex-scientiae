
# Appendix B

# Code

The notation mt and ms in the following code refers to the K κ and K ι knots, respectively.

# B.1 Bayesian Penalized Splines Code

library(MASS) library(SemiPar) library(MCMCpack) k = 40 data(lidar) x = lidar$range y = lidar$logratio n=length(y) N=10000 degp=1 knots = quantile(unique(x), seq(0,1, length=(k+2))[-c(1,(k+2))]) dimnames(X) = NULL Z = outer(x, knots, "-") Z = Z*(Z>0) Z=Z^degp dimnames(Z) <NULL X=matrix(1,nrow=n, ncol=degp+1) for(p in 1:degp){ X[,p+1]=x^p } C=cbind(X,Z) CT=t(C) B=CT%*%C betav=10000 gamma=matrix(0, nrow=N+1, ncol=k+degp+1) vare=matrix(1, nrow=N+1, ncol=1) varu=matrix(1, nrow=N+1, ncol=1) Au=0
