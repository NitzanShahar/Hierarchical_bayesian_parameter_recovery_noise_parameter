data {

  //General fixed parameters for the experiment/models
  int<lower = 1> Nsubjects;                                         //number of subjects
  int<lower = 1> Nblocks;                                           //number of blocks
  int<lower = 1> Ntrials;                                           //maximum number of trials per subject (without missing data). Used to form the subject x trials matricies. 
  int<lower = 1> Ntrials_per_subject[Nsubjects];                    //number of trials left for each subject after data omission



  //Behavioral data:
  //each variable being a subject x trial matrix
  //the data is padded in make_standata function so that all subjects will have the same number of trials
  real           Q1[Nsubjects,Ntrials];                   //first Qvalue
  real           Q2[Nsubjects,Ntrials];                   //second Qvalue
  int<lower = 0> action[Nsubjects,Ntrials];               //which offer was selected by the individual
}

transformed data{
  int<lower = 1> Nparameters=1; //number of parameters in the model
  
}

parameters {

  //population level parameters 
  vector         [Nparameters] population_locations; //a vector with the location  for learning rate and noise parameters
  vector<lower=0>[Nparameters] population_scales;    //a vector with scaling for learning rate and noise parameters
  
  //individuals level parameters
  vector<lower=0> [Nsubjects] beta;                //noise parameter
}




model {
  // population level priors 
  population_locations   ~ normal(0,2);
  population_scales      ~ cauchy(0,2);
  

  //indvidual level priors
  beta  ~ lognormal(population_locations[1],population_scales[1]);
  
  
  
  //Likelihood function per subject per trial

  for (subject in 1:Nsubjects){
    vector[2]   Qoffer; //Qvalues for all bandits in the task

      for (trial in 1:Ntrials_per_subject[subject]){
        
        //allocate Qvalues according to offer
          Qoffer[1]=Q1[subject,trial];
          Qoffer[2]=Q2[subject,trial];

        //liklihood function according to a softmax policy and subject's choices
         target +=log_softmax(beta[subject] * Qoffer)[action[subject, trial]];
      } 
    }
}
