#This code plot recovered parameters against the true parameters


rm(list=ls())
model_name=c('only_softmax')

load(paste('./data/',model_name,'_recovered_parameters.rdata',sep=""))
load(paste('./data/',model_name,'_true_parameters.Rdata',sep=""))


library(ggplot2)
library(ggpubr)

#-------------------------------------------------------------------------------------------------------------
# #population level parameters



p1= ggplot(data.frame(x=pars$population_locations[,1]),aes(x=x))+geom_density(alpha = .5,fill="pink")+ 
        geom_vline(xintercept = 1, linetype="dotted",color = "blue", size=1.5)+
        xlim(0.5,1.5)+ xlab(expression(beta['location']))+ theme_classic()


p2= ggplot(data.frame(x=pars$population_scales[,1]),aes(x=x))+geom_density(alpha = .5,fill="pink")+ 
        geom_vline(xintercept = .5 , linetype="dotted",color = "blue", size=1.5)+
        xlim(0,1)+  xlab(expression(beta['scale']))+ theme_classic()


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

annotate_figure(ggarrange(p1,nrow=1,ncol=1), 
                top = text_grob("Individual Level Parameters (random effects)", color = "black", face = "bold", size = 10))

