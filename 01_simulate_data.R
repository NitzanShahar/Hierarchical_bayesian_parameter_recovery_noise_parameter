#This code generate artificial data based on a softmax model. So - this is just a sanity check for recovery of a noise parameter - there is
# no RL modeling here.
#It has four parts:
# a. Generate true parameters based on an hierarchical structure 
# b. simulate data
# c. Convert data to a stan-data format
# d. run some linear regression sanity checks on the code.


rm(list=ls())

model_name =c('only_softmax')
Nsubjects  =10

#-------------------------------------------------------------------------------------------------------------
# Part A: Generate true population and individual level parameters

  #true population level parameters 
  population_locations    =1   #population mean for noise parameter
  population_scales       =0.5 #population sd noise parameter


  #individual parameters 
  beta           = rlnorm(Nsubjects,population_locations[1],population_scales[1])

  #check histograms and sample means
  print(mean(beta))
  hist(beta)
  
  #save
  true.parameters=cbind(subject = seq(1,Nsubjects),
                        beta    = beta)
  save(true.parameters,file=paste('./data/',model_name,'_true_parameters.Rdata',sep=""))
  

  
  
  
  
#-------------------------------------------------------------------------------------------------------------
# Part B: Simulate data based on task values and individual parameters from previous section

#run simulation
  cfg=list(Nblocks             =1,
           Ntrials_perblock    =500)
  
  
source('./models/simulation_only_softmax.R')
df=data.frame()
for (subject in 1:Nsubjects) {
  df=rbind(df, sim.block(subject=subject, parameters=true.parameters[subject,],cfg=cfg))
}

#save
save(df,file=paste('./data/',model_name,'_simdata.Rdata',sep=""))






#-------------------------------------------------------------------------------------------------------------
# Part C: Convert the data to a stan format. 

###adding missing data###
source('./functions/add_missingdata.R')
df=add_missingdata(df,max_precent_of_aborted_trials=0)

#check the percent of missing data for each individual
library(dplyr)  
df%>%group_by(subject)%>%summarise(mean(abort)) 

#take out missing data trials
df<-df[df$abort==0,]



###convert to a standata format ###
  
source('./functions/make_mystandata.R')
data_for_stan<-make_mystandata(data=df, 
                               subject_column     =df$subject,
                               block_column       =df$block,
                               var_toinclude      =c(
                                 'trial',
                                 'Q1',
                                 'Q2',
                                 'action')
                               )

save(data_for_stan,file=paste('./data/',model_name,'_standata.Rdata',sep=""))





#-------------------------------------------------------------------------------------------------------------
# Part D: Run some basic sanity checks using linear / logistic regression
library(dplyr)
library(tidyr)
library(ggplot2)
library(lme4)
library(effects)

#sanity check 1: make sure that a higher Q for offer 2, means a higher chance of taking action 2
model<-glmer(action ~ Qdiff+(Qdiff| subject),data = df%>%mutate(action=(action-1)), family = binomial)
plot(effect('Qdiff',model))


#sanity check 2: plot the influence of Qdiff on selection as a function of true Beta parameter (should be positive association)
plot(ranef(model)$subject[,'Qdiff'],true.parameters[,2])
