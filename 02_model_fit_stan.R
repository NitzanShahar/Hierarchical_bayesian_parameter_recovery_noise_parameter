#aim: Hierarchical fit Stan 
#contributor: Nitzan Shahar, 2021


rm(list=ls())

model_name=c('only_softmax')

# fit stan model  --------------------------------------------
library(rstan) 
load('./data/only_softmax_standata.Rdata')
library(parallel)
detectCores()
{
  start_time <- Sys.time()

    rl_fit<- stan(file = './models/only_softmax.stan', 
                data=data_for_stan, 
                iter=2000,
                warmup = 1000,
                chains=1,
                cores =1) 

  end_time <- Sys.time()
  end_time-start_time
}

#save
saveRDS(rl_fit, paste('./data/',model_name,'_RDSfile.rds',sep=""))

pars <- rstan::extract(rl_fit, permuted = TRUE)
save(pars, file=paste('./data/',model_name,'_recovered_parameters.rdata',sep=""))


