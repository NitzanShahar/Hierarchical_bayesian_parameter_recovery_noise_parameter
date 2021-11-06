#### simulate Rescorla-Wagner block for participant ----
sim.block = function(subject,parameters,cfg){ 
  
  print(paste('subject',subject))

#pre-allocation of variables and parameters
  
  #set learning rate and noise parameters
  beta  = parameters['beta']

  #task variables
  Nblocks            = cfg$Nblocks
  Ntrials_perblock   = cfg$Ntrials_perblock
  df                 = data.frame()

#main simulation section where the agent will make choice according to a Qlearning algorithm

for (block in 1:Nblocks){
  
  for (trial in 1:Ntrials_perblock){

    Qval=runif(2)
    p         = exp(beta*Qval) / sum(exp(beta*Qval))
    action    = sample(1:2,1,prob=p)
    
    #save trial's data
      dfnew=data.frame(
            subject              = subject,
            block                = block,
            trial                = trial,
            first_trial_in_block = (trial==1)*1,
            action               = action,
            Q1                   = Qval[1],
            Q2                   = Qval[2],
            Qdiff                = Qval[2]-Qval[1]
            )
      
      #bind to the overall df
      df=rbind(df,dfnew)
       
  }
}     
  return (df)
}



# 
# 
# #### simulate Rescorla-Wagner block for participant ----
# sim.block = function(subject,parameters,cfg){ 
#   
#   print(paste('subject',subject))
#   
#   #pre-allocation of variables and parameters
#   
#   #set learning rate and noise parameters
#   beta  = parameters['beta']
#   
#   #task variables
#   Ntrials            = cfg$Ntrials
#   df                 = data.frame()
#   
#   #main simulation section where the agent will make choice according to a Qlearning algorithm
#   
#   for (trial in 1:Ntrials){
#     
#     Qval      = runif(2)
#     p         = exp(beta*Qval) / sum(exp(beta*Qval))
#     action    = sample(1:2,1,prob=p)
#     
#     #save trial's data
#     dfnew=data.frame(
#       subject              = subject,
#       trial                = trial,
#       action               = action,
#       Q1                   = Qval[1],
#       Q2                   = Qval[2],
#       Qdiff                = Qval[2]-Qval[1]
#     )
#     
#     #bind to the overall df
#     df=rbind(df,dfnew)
#     
#     
#   }     
#   return (df)
# }