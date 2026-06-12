
gamma_prop=Z_gamma%*%b_gamma[i+1,] D_gamma_prop=diag(c(exp(gamma_prop))) log_proposal_curr=-0.5*(t(b_gamma[i,]-b_gamma_max)%*%(-H)%*%(b_gamma[i,]-b_gamma_max)) log_proposal_prop=-0.5*(t(b_gamma[i+1,]-b_gamma_max)%*%(-H)%*%(b_gamma[i+1,]-b_gamma_max)) log_lik_gamma_curr=0.5*(sum(gamma)tau[i+1]*xi[1,i+1]*t(b)%*%D_gamma%*%b-tau[i+1]*xi[1,i+1]*xi[2,i+1]*(t(b_gamma[i,])%*%b_gamma[i,])) log_lik_gamma_prop=0.5*(sum(gamma_prop)tau[i+1]*xi[1,i+1]*t(b)%*%D_gamma_prop%*%b-tau[i+1]*xi[1,i+1]*xi[2,i+1]*(t(b_gamma[i+1,])%*%b_gamma[i+1,])) M_H_ratio=log_lik_gamma_prop+log_proposal_curr-log_lik_gamma_curr-log_proposal_prop alpha[i]=min(c(1,exp(M_H_ratio))) u=runif(1) if(u > alpha[i]){ b_gamma[i+1,] = b_gamma[i,] } } #mean(alpha) burnin=2000 theta_post=apply(theta[burnin:N,], 2, mean) BAPS_fit=T%*%theta_post #Plots############################ plot(t,y,type="n") # lines(t,sin(t)+2*exp(-30*t^2), lty=1) #lines(t,func) lines(x,BAPS_fit,lty=2,col=’red’) #Credible Intervals################# burn=2000 theta1=theta[burn:N,] fits=matrix(0, nrow=(N-burn+1),ncol=n) for(b in 1:(N-burn+1)){ fits[b,]=T%*%theta1[b,] } ci=apply(fits,2, quantile,c(0.025,0.975)) lines(t, ci[1,], lty=4,lwd=1) lines(t, ci[2,], lty=4,lwd=1)

# B.3 BAPS Code (Whittle estimate)

# B.3.1 Non-Adaptive Whittle

library(TSA)
