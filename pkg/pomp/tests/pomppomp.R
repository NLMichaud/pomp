library(pomp)

pompExample(ricker)
y1 <- obs(simulate(ricker,seed=1066L))
r2 <- pomp(ricker,measurement.model=y~pois(lambda=N*phi))
coef(r2) <- coef(ricker)
y2 <- obs(simulate(r2,seed=1066L))
max(abs(y1-y2))
r3 <- pomp(
           ricker,
           dmeasure="_ricker_poisson_dmeasure",
           PACKAGE="pomp",
           paramnames=c("r","sigma","phi"),
           statenames=c("N","e"),
           obsnames=c("y")
           )
coef(r3) <- coef(r2)
y3 <- obs(simulate(r3,seed=1066L))
max(abs(y1-y3))
r4 <- pomp(
           r2,
           rmeasure="_ricker_poisson_rmeasure",
           PACKAGE="pomp",
           paramnames=c("r","sigma","phi"),
           statenames=c("N","e"),
           obsnames=c("y")
           )
coef(r4) <- coef(r2)
y4 <- obs(simulate(r4,seed=1066L))
max(abs(y1-y4))
