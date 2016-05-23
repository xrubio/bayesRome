
model
{
    # priors
    pareto.shape.min <- 0.1
    pareto.shape.max <- 10

    shape ~ dunif(pareto.shape.min, pareto.shape.max)
    xm <- 1 
    
    for(i in 1:Ntotal)
    {
        y[i] ~ dpar(shape, xm)
    }
}

