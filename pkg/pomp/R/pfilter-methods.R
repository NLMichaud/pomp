setMethod("$",signature(x="pfilterd.pomp"),function (x,name) slot(x,name))
setMethod("logLik",signature(object="pfilterd.pomp"),function(object,...)object@loglik)
setMethod("eff.sample.size",signature(object="pfilterd.pomp"),function(object,...)object@eff.sample.size)
setMethod("cond.logLik",signature(object="pfilterd.pomp"),function(object,...)object@cond.loglik)

## 'coerce' method: allows for coercion of a "pomp" object to a data-frame
setAs(
      from="pfilterd.pomp",
      to="data.frame",
      def = function (from) {
        pm <- pred.mean(from)
        pv <- pred.var(from)
        fm <- filter.mean(from)
        out <- cbind(
                     as(as(from,"pomp"),"data.frame"),
                     ess=eff.sample.size(from),
                     cond.loglik=cond.logLik(from)
                     )
        if (length(pm)>0)
          out <- cbind(out,pred.mean=t(pm))
        if (length(pv)>0)
          out <- cbind(out,pred.var=t(pv))
        if (length(fm)>0)
          out <- cbind(out,filter.mean=t(fm))
        out
      }
      )

as.data.frame.pfilterd.pomp <- function (x, row.names, optional, ...) as(x,"data.frame")

## extract the prediction means
setMethod(
          "pred.mean",
          "pfilterd.pomp",
          function (object, pars, ...) {
            if (missing(pars)) pars <- rownames(object@pred.mean)
            object@pred.mean[pars,]
          }
          )

## extract the prediction variances
setMethod(
          "pred.var",
          "pfilterd.pomp",
          function (object, pars, ...) {
            if (missing(pars)) pars <- rownames(object@pred.var)
            object@pred.var[pars,]
          }
          )


## extract the filtering means
setMethod(
          "filter.mean",
          "pfilterd.pomp",
          function (object, pars, ...) {
            if (missing(pars)) pars <- rownames(object@filter.mean)
            object@filter.mean[pars,]
          }
          )
