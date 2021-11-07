# Qlearning_hierarchical_fitting_with_stan_only_beta
 Recovery of noise parameter in a softmax. This is a very basic sanity check - no RL modeling. 

## 01_simulate_data.R 
#### Part A: Simulate 'true' population and individual level parameters.
We start by simulating a single beta parameter from a lognormal distrbution, and then we draw individual parameters from that distrbution.

#### Part B - Simulate the data according to a Qlearning alogrithm 
For each block, and each trial we do the following:
1. Randomly draw two values between 0 and 1 (similar to how Qvalues will look, just without RL)
2. Make selection according to softmax (i.e., chose option A or B)

#### Part C - Convert data frame to a stan compatible format
This has two subparts. 
1. Add missing data using padding. This means that stan will ignore missing data.
2. Convert the data frame to a list with matriceis for each variable

#### Part D - Sanity checks
Here we run on the data frame some sequnitial trial regression analysis as a sanity check
1. see that higher difference between the values of the two options lead to the preference of one over the other.
2. see that the effect we found in the previous step is well correlated with individual beta parameter values.

## 02_model_fit_stan
Here we run mcmc using stan to recover both the population and individual level parameter.
The stan model is located in the 'models'folders.

## 03_compare_parameters 
Here we plot the recovered and true parameters. Below is the results of a simulation with 200 agents 1000 trials each (4 arms, 2 offers each trial).

Posterior distrbutions for population level parameters (dashed lines are the true value):
![Posterior](https://github.com/NitzanShahar/Qlearning_hierarchical_fitting_with_stan_only_softmax/blob/main/graphics/population_level_parameters_1000subjects_2blocks_wtih100trialseach.jpeg)

Individual level correlations between true and recovered parameters (pearson r is also indicated in the upper left corner):

![This is an image](https://github.com/NitzanShahar/Qlearning_hierarchical_fitting_with_stan_only_softmax/blob/main/graphics/group_level_parameters_1000subjects_2blocks_wtih100trialseach.jpeg)

