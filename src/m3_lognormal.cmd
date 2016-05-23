
model
{
    # priors
    logNormal.mu.min <- 0.1
    logNormal.mu.max <- 4

    logNormal.tau.min <- 0.1
    logNormal.tau.max <- 3

    mu ~ dunif(logNormal.mu.min, logNormal.mu.max)
    tau ~ dunif(logNormal.tau.min, logNormal.tau.max)
    
    for(i in 1:Ntotal)
    {
        y[i] ~ dlnorm(mu,tau)
    }
}

