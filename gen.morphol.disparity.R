# Author: Patrick Yi Feng Wen
# Date: July 19, 2023


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Arguments:
# @obsShp An n * (p*k) matrix of GPA-aligned shape data, where n is the number 
# of observations, p is the number of landmarks, and k is the dimension.
# @expShp A matrix of the same dimension as obsShp, which contains shape 
# estimated from linear or non-linear regression models.
# @groups A factor specifying the groups among which pairwise comparisons are to
# be made. This is equivalent to the "groups" argument in morphol.disparity. But
# groups here is specified without the "~" sign.
# @iter The number of iterations for obtaining permutation p values.
# @print.progress Whether to show progress bar.


# Output
# $Procrustes.var A numeric vector containing Procrustes variance for each group
# defined by the groups argument.
# $PV.dist A matrix of pairwise absolute difference in Procrustes variance 
# among groups.
# $PV.dist.Pval A matrix of P values for pairwise absolute difference in 
# Procrustes variance
# $random.PV.dist A list of pairwise absolute difference in Procrustes variance
# from the permutation procedure. The first component is identical to PV.dist 
# and all other components are from permuted samples.


################################################################################
gen.morphol.disparity <- function(obsShp, expShp, groups, iter = 99, 
                                  print.progress = F) {
    library(RRPP)

    obsShp <- as.matrix(obsShp)
    expShp <- as.matrix(expShp)
    R <- obsShp - expShp

    d <- rowSums(R^2)
    N <- length(d)

    groups <- as.factor(groups)
    newDf <- data.frame(d = d, groups = groups)

    fit <- RRPP::lm.rrpp(d ~ groups + 0,
        iter = 0, data = newDf,
        print.progress = FALSE
    )
    Q <- fit$LM$QR

    H <- tcrossprod(solve(qr.R(Q)), qr.Q(Q))
    ind <- RRPP:::perm.index(N, iter)
    pv <- sapply(1:(iter + 1), function(j) {
        
        if (print.progress == T) {
            step <- j
            cat("\n\nPerformimg pairwise comparisons of disparity\n")
            pb <- txtProgressBar(
                min = 0, max = iter + 1, initial = 0,
                style = 3
            )
        setTxtProgressBar(pb, step)
        }

        H %*% d[ind[[j]]]
    })

    pvd <- lapply(1:(iter + 1), function(j) {
        as.matrix(dist(matrix(pv[
            ,
            j
        ])))
    })
    for (i in 1:(iter + 1)) {
        dimnames(pvd[[i]]) <- list(
            levels(groups),
            levels(groups)
        )
    }
    p.val <- Reduce("+", lapply(1:(iter + 1), function(j) {
        x <- pvd[[1]]
        y <- pvd[[j]]
        ifelse(y >= x, 1, 0)
    })) / (iter + 1)


    pv.obs <- pv[, 1]
    PV.dist <- pvd[[1]]
    dimnames(PV.dist) <- dimnames(p.val) <- list(
        levels(groups),
        levels(groups)
    )

    out <- list(
        Procrustes.var = pv.obs, PV.dist = PV.dist, PV.dist.Pval = p.val,
        random.PV.dist = pvd
    )
    out
}
################################################################################
