library(pomp)

pompExample(ricker)

pdf(file="skeleton.pdf")
pdf.options(useDingbats=FALSE)

ricker <- simulate(ricker,seed=366829807L)
x <- states(ricker)
p <- parmat(coef(ricker),3)
p["r",] <- exp(c(1,2,4))
f <- skeleton(ricker,x=x,params=p,t=time(ricker))
plot(range(x[1,]),range(f[1,,]),type='n',
     xlab=expression(N[t]),ylab=expression(N[t+1]))
points(x[1,],f[1,1,],col='red',pch=16)
points(x[1,],f[1,2,],col='blue',pch=16)
points(x[1,],f[1,3,],col='green',pch=16)
legend("topright",bty='n',col=c("red","blue","green"),
       legend=sapply(p["r",],function(x)bquote(log(r)==.(round(log(x),1)))),
         pch=16)

## non-autonomous case

pompExample(euler.sir)
euler.sir <- simulate(euler.sir,seed=266045243L)
x <- states(euler.sir)
p <- parmat(coef(euler.sir),nrep=3)
p["beta2",2:3] <- exp(c(3,5))  ## try different values of one of the seasonality parameters
## compute the skeleton at each point
f <- skeleton(euler.sir,x=x,params=p,t=time(euler.sir))
## verify that the skeleton varies with time
matplot(time(euler.sir),t(f["I",,]),type='l',lty=1)

## use deSolve to compute a deterministic trajectorxy
t <- time(euler.sir)
x <- trajectory(euler.sir,params=p)
## evaluate skeleton at each point along it
f <- skeleton(euler.sir,x=x,params=p,t=t)
f2 <- apply(x,c(1,2),function(xx)predict(smooth.spline(t,xx),deriv=1)$y)
f2 <- aperm(f2,c(2,3,1))
plot(f,f2,type='n')
matpoints(t(f["S",,]),t(f2["S",,]))
matpoints(t(f["S",,]),t(f2["S",,]))
abline(a=0,b=1)

for (i in 1:3) {
  for (j in 1:3) {
    stopifnot(all(signif(coef(lm(f2[i,j,]~f[i,j,]))[2],3)==1))
  }
}


pomp.skeleton <- function(times,y,p,more) {
# Turns a skeleton function from a 'pomp' object into the right hand
# side of and ODE for use in CollocInfer
  skeleton(more$pomp.obj,x=y,params=p,t=times)
}

x <- states(ricker)
p <- parmat(coef(ricker),nrep=3)
p["r",]<- exp(c(1,2,4))

f <- skeleton(ricker,x=x,params=p,t=time(ricker))
g <- pomp.skeleton(time(ricker),x,p,list(pomp.obj=ricker))

stopifnot(identical(f,g))

dev.off()
