library(plyr)   
library(R2jags) #not that you will need jags to be installed on your computer before to be able to install R2jags

initsListM1 = function()
{
    return(list(lambda=runif(1,1,30)))
}

initsListM2 = function()
{
    return(list(size=runif(1,1,100), prob=runif(1,0,1)))
} 

initsListM3 = function()
{
    return(list(mu=runif(1,0.1,4), tau=runif(1,0.1,3)))
}

initsListM4 = function()
{
    return(list(shape=runif(1,0.1,10)))
}

runModels <- function(numRun)
{
    myDataName <- '../data/singleRun.csv'
    myData <- read.csv(myDataName, sep=";", header=T)
    freqs <- count(myData, c('stamp'))
    Ntotal = nrow(freqs)    


    dataList = list(y=freqs$freq, Ntotal=Ntotal)

    nChains = 3
    nIter = 15500
    nThin = 1
    nBurn = 500


    ####### M1

    jagsM1 = jags(model.file="m1_poisson.cmd", data=dataList, inits=initsListM1, parameters=c('lambda'), n.chains=nChains, n.iter=nIter, n.thin=nThin, n.burnin=nBurn)

    m1.lambda <- as.vector(jagsM1$BUGSoutput$sims.list[['lambda']])
    m1.dic <- dic.samples(jagsM1$model, n.iter=1000)

    outputM1 <- paste(as.character(numRun),'_m1.Rdata', sep="")
    save(m1.lambda, m1.dic, file=outputM1, ascii=T)

    ######### M2
    jagsM2 = jags(model.file="m2_negbin.cmd", data=dataList, inits=initsListM2, parameters=c('size','prob'), n.chains=nChains, n.iter=nIter, n.thin=nThin, n.burnin=nBurn)
    m2.size <- as.vector(jagsM2$BUGSoutput$sims.list[['size']])
    m2.prob <- as.vector(jagsM2$BUGSoutput$sims.list[['prob']])
    m2.dic <- dic.samples(jagsM2$model, n.iter=1000)
        
    outputM2 <- paste(as.character(numRun),'_m2.Rdata', sep="")
    save(m2.size, m2.prob, m2.dic, file=outputM2, ascii=T)
    
    ####### M3
    jagsM3 = jags(model.file="m3_lognormal.cmd", data=dataList, inits=initsListM3, parameters=c('mu','tau'), n.chains=nChains, n.iter=nIter, n.thin=nThin, n.burnin=nBurn)

    m3.mu <- as.vector(jagsM3$BUGSoutput$sims.list[['mu']])
    m3.tau <- as.vector(jagsM3$BUGSoutput$sims.list[['tau']])
    m3.dic <- dic.samples(jagsM3$model, n.iter=1000)

    outputM3 <- paste(as.character(numRun),'_m3.Rdata', sep="")
    save(m3.mu, m3.tau, m3.dic, file=outputM3, ascii=T)


    ######## M4
    jagsM4 = jags(model.file="m4_pareto.cmd", data=dataList, inits=initsListM4, parameters=c('shape'), n.chains=nChains, n.iter=nIter, n.thin=nThin, n.burnin=nBurn)

    m4.shape <- as.vector(jagsM4$BUGSoutput$sims.list[['shape']])
    m4.dic <- dic.samples(jagsM4$model, n.iter=1000)

    outputM4 <- paste(as.character(numRun),'_m4.Rdata', sep="")
    save(m4.shape, m4.dic, file=outputM4, ascii=T)

    dicM1 <- sum(m1.dic$deviance) + sum(m1.dic$penalty)
    dicM2 <- sum(m2.dic$deviance) + sum(m2.dic$penalty)
    dicM3 <- sum(m3.dic$deviance) + sum(m3.dic$penalty)
    dicM4 <- sum(m4.dic$deviance) + sum(m4.dic$penalty)
    dicValues <- c(dicM1, dicM2, dicM3, dicM4)
    return(dicValues)
}

runExperiment <- function(numRuns)
{
    dicValues <- mapply(runModels, 0:(numRuns-1))

    dicResult <- data.frame(model='m1',values=dicValues[1,])
    dicResult <- rbind(dicResult, data.frame(model='m2',values=dicValues[2,]))
    dicResult <- rbind(dicResult, data.frame(model='m3',values=dicValues[3,]))
    dicResult <- rbind(dicResult, data.frame(model='m4',values=dicValues[4,]))

    save(dicResult, file='dicResults.Rdata', ascii=T)
}  

loadData <- function(numRuns)
{
    dicResult <- data.frame(model=factor(), values=double())

    for(i in seq(0,numRuns-1))
    {
        m1File <- paste(as.character(i),'_m1.Rdata', sep="")
        load(m1File)
        m2File <- paste(as.character(i),'_m2.Rdata', sep="") 
        load(m2File)
        m3File <- paste(as.character(i),'_m3.Rdata', sep="")
        load(m3File)
        m4File <- paste(as.character(i),'_m4.Rdata', sep="")
        load(m4File)
        
        dicM1 <- sum(m1.dic$deviance) + sum(m1.dic$penalty)
        dicM2 <- sum(m2.dic$deviance) + sum(m2.dic$penalty)
        dicM3 <- sum(m3.dic$deviance) + sum(m3.dic$penalty)
        dicM4 <- sum(m4.dic$deviance) + sum(m4.dic$penalty)

        dicResult <- rbind(dicResult, data.frame(model="m1", values=dicM1))
        dicResult <- rbind(dicResult, data.frame(model="m2", values=dicM2))
        dicResult <- rbind(dicResult, data.frame(model="m3", values=dicM3))
        dicResult <- rbind(dicResult, data.frame(model="m4", values=dicM4))
    }
    return(dicResult)
}

