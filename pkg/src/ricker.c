// dear emacs, please treat this as -*- C++ -*-

#include <Rmath.h>

#include "pomp.h"

#define LOG_R       (p[parindex[0]]) // growth rate
#define LOG_SIGMA   (p[parindex[1]]) // process noise level
#define LOG_PHI     (p[parindex[2]]) // measurement scale parameter

#define N           (x[stateindex[0]]) // population size
#define E           (x[stateindex[1]]) // process noise

#define Y           (y[obsindex[0]]) // observed population size

void poisson_dmeasure (double *lik, double *y, double *x, double *p, int give_log,
		       int *obsindex, int *stateindex, int *parindex, int *covindex,
		       int ncovars, double *covars, double t) {
  *lik = dpois(Y,exp(LOG_PHI)*N,give_log);
}

void poisson_rmeasure (double *y, double *x, double *p, 
		       int *obsindex, int *stateindex, int *parindex, int *covindex,
		       int ncovars, double *covars, double t) {
  Y = rpois(exp(LOG_PHI)*N);
}

#undef Y

// Ricker model with log-normal process noise
void ricker_simulator (double *x, const double *p, 
		       const int *stateindex, const int *parindex, const int *covindex,
		       int covdim, const double *covar, 
		       double t, double dt)
{
  double sigma = exp(LOG_SIGMA);
  double e = (sigma > 0.0) ? rnorm(0,sigma) : 0.0;
  N = exp(LOG_R+log(N)-N+e);
  E = e;
}

void ricker_skeleton (double *f, double *x, const double *p, 
		      const int *stateindex, const int *parindex, const int *covindex,
		      int covdim, const double *covar, double t) 
{
  f[0] = exp(LOG_R+log(N)-N);
  f[1] = 0.0;
}

#undef N
#undef E

#undef LOG_R
#undef LOG_SIGMA
#undef LOG_PHI
