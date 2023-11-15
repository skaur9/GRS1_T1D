# Create Density plot of GRS1 scores comparing distribution between cases and controls)

library(tidyverse)
library(gplots)

data=read.table("GRS1_score_dk3a.txt", h=T)

Cases=data %>% filter(PHENO==2) %>%
select(IID, GRS1_Score)

Controls=data %>% filter(PHENO==1) %>%
select(IID, GRS1_Score)

dim(Cases)
#[1] 2847    2

 dim(Controls)
#[1] 1982    2


summary(Cases)
#  IID              GRS1_Score   
# Length:2847        Min.   : 6.61  
# Class :character   1st Qu.:14.10  
# Mode  :character   Median :15.18  
#                    Mean   :15.04  
#                    3rd Qu.:16.14  
#                    Max.   :18.77 
      
summary(Controls)
 #    IID              GRS1_Score   
 #Length:1982        Min.   : 5.71  
 #Class :character   1st Qu.:11.11  
 #Mode  :character   Median :12.56  
 #                   Mean   :12.42  
 #                   3rd Qu.:13.93  
 #                   Max.   :17.89



######## Plot combined with colors
pdf("density_plot_GRS1_dk3a.pdf", h=6, w=6)
plot(density(Cases$GRS1_Score), col="red", ylab="Frequency Density", xlab="GRS1", main="", xlim=c(5,20), cex=0.8)
lines(density(Controls$GRS1_Score), col = "blue")
legend("topleft", c("T1D (2847)","Controls (1982)"), lty = c(1,1), col = c("red","blue"), cex=0.8)
dev.off()
