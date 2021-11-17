#This code plot recovered parameters against the true parameters

rm(list=ls())
model_name =c('only_softmax')
folder_name=c('100agents_200trials_run3/')
load(paste('./data/',folder_name,model_name,'_recovered_parameters.rdata',sep=""))
load(paste('./data/',folder_name,model_name,'_true_parameters.Rdata',sep=""))

library(bayestestR)
library(ggplot2)
library(ggpubr)

#-------------------------------------------------------------------------------------------------------------
# #population level parameters

source('./functions/my_posteriorplot.R')

#location parameter
p1=
my_posteriorplot(x       = pars$population_locations[,1],
                 myxlim  = c(0.5,1.5),
                 my_vline= 1, #true parameter value
                 myxlab  = expression(beta['location']),
                 mycolor = "pink"
                 )


#scale parameter
p2=
my_posteriorplot(x       = pars$population_scales[,1],
                 myxlim  = c(0,1),
                 my_vline= 0.5, #true parameter value
                 myxlab  = expression(beta['location']),
                 mycolor = "pink"
)

                 

pp1=
annotate_figure(ggarrange(p1,p2,nrow=1,ncol=2), 
                top = text_grob("Population Level Parameters (fixed effects)", color = "black", face = "bold", size = 10))

#-------------------------------------------------------------------------------------------------------------
# individual level parameters

    
p1=ggplot(data.frame(x =true.parameters[,'beta'], y =apply(pars$beta, 2, mean)),aes(x=x,y=y))+geom_point()+
    labs(title='',
         subtitle = paste('r=',round(cor(true.parameters[,'beta'], apply(pars$beta, 2, mean)),2)),
         x=expression(beta['true']),
         y=expression(beta['recovered']))+ 
    xlim(0,10)+ylim(0,10)+
    theme_classic()

pp2=
annotate_figure(ggarrange(p1,nrow=1,ncol=1), 
                top = text_grob("Individual Level Parameters (random effects)", color = "black", face = "bold", size = 10))

ggarrange(pp1,pp2,nrow=2,ncol=1)
