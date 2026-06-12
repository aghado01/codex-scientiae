[Page 82]

fits=matrix(0, nrow=(N-burn+1),ncol=M) for(h in 1:(N-burn+1)){ fits[h,]=-C%*%theta[h,] } ci=apply(fits,2, quantile,c(0.025,0.975)) lines(f, ci[1,],lty=2,lwd=1) lines(f, ci[2,],lty=2,lwd=1)
