# Assign score for DR3/DR4 haplotype SNPs and construct T1D GRS1

setwd("/data/Analysis/shared_projects/GRS1/GRS1_score/")

# load data (these files generated in previous step are used as input)
hla <- read.table("grsT1D1_HLA_output.ped")
SCORE <- read.table("grsT1D1_score_output.profile", header=TRUE)


#####---------------------------------------------------------------------------------------------------#####
## For HLA SNPs
# create genotypes of the two HLA SNPs
hla <- cbind(hla, rs2187668 = paste(hla$V7, hla$V8, sep=""), rs7454108 = paste(hla$V9, hla$V10, sep=""))

# keep only relevant columns
hla <- hla[,c(1:2,11:12)]

# # rename columns not necessary
# names(hla)[names(hla)=="V1"] <- "FID"
# names(hla)[names(hla)=="V2"] <- "IID"

table(hla$rs2187668)
#  CC  TC TT
# 414 239 42
table(hla$rs7454108)
#  CC  CT  TT
#  29 309 357


# code DR3/DR4 genotypes
hla_function <- function(x){
  ifelse(x$rs2187668 == "TC" & x$rs7454108 == "CT", "DR3/DR4",
         ifelse(x$rs2187668 == "TC" & x$rs7454108 != "CT", "DR3/X",
                ifelse(x$rs2187668 != "TC" & x$rs7454108 == "CT", "DR4/X",
                       ifelse(x$rs2187668 == "TT", "DR3/DR3",
                              ifelse(x$rs7454108 == "CC", "DR4/DR4", "DRX/X")))))
}

hla <- cbind(hla, DR_group = hla_function(hla))
table(hla$DR_group)
# DR3/DR3 DR3/DR4 DR3/X DR4/DR4 DR4/X DRX/X
#      42     106   133      29   203   182

# assign weigths to the DR genotypes
hla_weigths <- function(x) {
  ifelse(x$DR_group == "DR3/DR4", 3.87,
         ifelse(x$DR_group == "DR3/X", 1.51,    
                ifelse(x$DR_group == "DR4/X", 1.95,
                       ifelse(x$DR_group == "DR3/DR3", 3.05,
                              ifelse(x$DR_group == "DR4/DR4", 3.09, 0)))))
}

hla <- cbind(hla, WT = hla_weigths(hla))


# add to HLA weights to PLINK SCORE to construct the final T1D1 score
SCORE <- cbind(SCORE, T1D1score= SCORE$SCORESUM + hla$WT)
hist(SCORE$T1D1score)

save(SCORE, hla, file="grsT1D1_calculated.RData")
