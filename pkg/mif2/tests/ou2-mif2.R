library(mif2)

pompExample(ou2)

pdf(file="ou2-mif2.pdf")

p.truth <- coef(ou2)
guess2 <- guess1 <- p.truth
guess1[c('x1.0','x2.0','alpha.2','alpha.3')] <- 0.9*guess1[c('x1.0','x2.0','alpha.2','alpha.3')]
guess2[c('x1.0','x2.0','alpha.2','alpha.3')] <- 1.2*guess1[c('x1.0','x2.0','alpha.2','alpha.3')]

set.seed(64857673L)
mif1a <- mif(
             ou2,
             Nmif=100,
             start=guess1,
             pars=c('alpha.2','alpha.3'),ivps=c('x1.0','x2.0'),
             rw.sd=c(
               x1.0=0.5,x2.0=0.5,
               alpha.2=0.1,alpha.3=0.1),
             transform=F,
             Np=1000,
             var.factor=1,
             ic.lag=10,
             cooling.type="hyperbolic",
             cooling.fraction=0.05,
             method="mif2",
             tol=1e-8
             )

mif2a <- mif(ou2,Nmif=100,start=guess1,
             pars=c('alpha.2','alpha.3'),ivps=c('x1.0','x2.0'),
             rw.sd=c(
               x1.0=0.5,x2.0=0.5,
               alpha.2=0.1,alpha.3=0.1),
             transform=F,
             Np=1000,
             var.factor=1,
             ic.lag=10,
             cooling.type="geometric",
             cooling.fraction=0.95^50,
             max.fail=100,
             method="mif",
             tol=1e-8
             )  

plot(c(mif1a,mif2a))

set.seed(64857673L)
mif1b <- mif(
             ou2,
             Nmif=50,
             start=guess1,
             pars=c('alpha.2','alpha.3'),
             ivps=c('x1.0','x2.0'),
             rw.sd=c(
               x1.0=0.5,x2.0=0.5,
               alpha.2=0.1,alpha.3=0.1),
             transform=F,
             Np=1000,
             var.factor=1,
             ic.lag=10,
             cooling.type="hyperbolic",
             cooling.fraction=0.05,
             method="mif2"
             )
mif1b <- continue(mif1b,Nmif=50)

mif2b <- mif(
             ou2,
             Nmif=50,
             start=guess1,
             pars=c('alpha.2','alpha.3'),
             ivps=c('x1.0','x2.0'),
             rw.sd=c(
               x1.0=0.5,x2.0=0.5,
               alpha.2=0.1,alpha.3=0.1),
             transform=F,
             Np=1000,
             var.factor=1,
             ic.lag=10,
             cooling.whatsit=200,
             cooling.type="geometric",
             cooling.factor=0.95,
             max.fail=100,
             method="mif"
             )  
mif2b <- continue(mif2b,Nmif=50)

mif2c <- mif(
             ou2,
             Nmif=50,
             start=guess1,
             pars=c('alpha.2','alpha.3'),
             ivps=c('x1.0','x2.0'),
             rw.sd=c(
               x1.0=0.5,x2.0=0.5,
               alpha.2=0.1,alpha.3=0.1),
             transform=F,
             Np=1000,
             var.factor=1,
             cooling.type="hyperbolic",
             cooling.fraction=0.05,
             max.fail=100,
             method="mif2"
             )  
mif2c <- continue(mif2c,Nmif=50)

plot(c(mif1b,mif2b))
plot(c(mif1a,mif1b))
plot(c(mif2a,mif2b))
plot(c(mif1b,mif2c))

mif3a <- mif2(
              ou2,
              Nmif=50,
              start=guess1,
              perturb.fn=function(params,mifiter,timeno,...){
                pert <- params
                ic.sd <- c(x1.0=0.5,x2.0=0.5)
                par.sd <- c(alpha.2=0.1,alpha.3=0.1)
                frac <- 0.05
                nT <- length(time(ou2))
                theta <- (1-frac)/frac/(50*nT-1)
                sigma <- 1/(1+theta*((mifiter-1)*nT+timeno-1))
                if (timeno==1) {
                  pert[names(ic.sd)] <- rnorm(
                                              n=length(ic.sd),
                                              mean=pert[names(ic.sd)],
                                              sd=ic.sd*sigma
                                              )
                }
                pert[names(par.sd)] <- rnorm(
                                            n=length(par.sd),
                                            mean=pert[names(par.sd)],
                                            sd=par.sd*sigma
                                            )
                pert
              },
              transform=FALSE,
              Np=1000
              )  

dev.off()
