
model
{
    # priors
    size.min <- 1
    size.max <- 100

    prob.min <- 0
    prob.max <- 1

    size~ dunif(size.min, size.max)
    prob ~ dunif(prob.min, prob.max)
    
    for(i in 1:Ntotal)
    {
        y[i] ~ dnegbin(prob, size)
    }
}

