
model
{
    # priors
    lambda.min <- 1
    lambda.max <- 30        

    lambda ~ dunif(lambda.min, lambda.max)
    
    for(i in 1:Ntotal)
    {
        y[i] ~ dpois(lambda)
    }
}

