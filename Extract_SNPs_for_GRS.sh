#!/bin/bash

# Script for extracting SNPs for T1D GRSs using genotyping data  in vcf or plink format (.bim, .bed and .fam files)
# For this exercise, A list of 30 Type 1 Diabetes risk SNPs (GRS1) were retrieved from (PMID: 26577414)
# Odds Ratio (ORs) for each of the non-HLA SNPs are obtained from T1Dbase (https://www.t1dbase.org). ORs for the DR3/DR4-DQ8 haplotype (captured by rs2187668 and rs7454108) that tags the DR3/DR4-DQ8 region as decribed by Barker et al. (PMID: 18694972) were obatined from (PMID: 25374276) and ORs for the remaining HLA alleles were obtained from Winkler et al. (PMID: 20798335 and 19143813). 
# The 30 SNPs, minor alleles and their respective Odd's rations are saved as a text file named score_GRS1.txt which will be used in downstream analysis. A glimpse of this file is shown below:

head score_GRS1.txt
##SNP	A1	WT
#rs2187668	NA	NA
#rs7454108	NA	NA
#rs1264813	T	0.43
#rs2395029	T	0.92
#rs3129889	A	2.7
#rs2476601	A	0.67
#rs689	T	0.56
#rs12722495	T	0.46
#rs2292239	T	0.3


# load modules needed
module load plink2/1.90beta3

# Directories
GWAS_DIR=/data/Genotyping/2020-06-09/Output/
OUTPUT_DIR=/data/1000_genome/shared_project/plink_files/GRS1/
INPUT_VCF=$(GWAS_DIR)merged_dbsnp142_updated.vcf.gz                           ## use this as input if the genotyped data is in vcf format

#Extract GRS1 SNPs (using a list of SNP IDs as a single column file)
plink --noweb --bfile $INPUT_VCF --extract 30_GRS1.txt --make-bed --out $(OUTPUT_DIR)grsT1D1


# Score file
SCORE_FILE_GRS1=${OUTPUT_DIR}score_GRS1.txt

# Input files for creating GRS
INPUT_FILE=$(OUTPUT_DIR)grsT1D1 

# Output data
OUT_FILE_GRS1=${OUTPUT_DIR}grsT1D1_score
OUT_FILE_HLA=${OUTPUT_DIR}grsT1D1_HLA

###PLINK1.9 ANALYSIS
# T1D score of 28 SNPS without DR3/DR4 genotypes
plink --bfile $INPUT_FILE --score $SCORE_FILE_GRS1 header sum --out $OUT_FILE_GRS1 --noweb

# Extracting genotypes for 2 HLA SNPs tagging DR3/DR4-DQ8 haplotype
plink --bfile $INPUT_FILE --snps rs2187668,rs7454108 --tab --recode --out $OUT_FILE_HLA --noweb






