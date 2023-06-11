SampleConstruction
================
Adam
2023-01-25

This .rmd links ndar downloads into a master dataset. Cross-sectional
and temporal precedence datasets are be exported from this file (no
matched imaging groups needed, pooled factor decomposition).

``` r
#### chunk 1: load libraries
library(rapportools)
```

    ## 
    ## Attaching package: 'rapportools'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     IQR, median, sd, var

    ## The following objects are masked from 'package:base':
    ## 
    ##     max, mean, min, range, sum

``` r
library(reshape2)
library(ggplot2)
library(ggalluvial)
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
####  chunk 2 processes mental health data  ####
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

### LOAD in cbcl data
cbcl=read.delim('~/Downloads/Package_1210940/abcd_cbcl01.txt')
cbcls=read.delim('~/Downloads/Package_1210940/abcd_cbcls01.txt')
# subset timepoints
cbclsBV=subset(cbcls,eventname=='baseline_year_1_arm_1')
cbcls2=subset(cbcls,eventname=='2_year_follow_up_y_arm_1')
# subset timepoints
cbclBV=subset(cbcl,eventname=='baseline_year_1_arm_1')
cbcl2=subset(cbcl,eventname=='2_year_follow_up_y_arm_1')
# merge with other cbcl
cbclsBV=merge(cbclsBV,cbclBV,by=c('subjectkey','eventname'))
cbcls2=merge(cbcls2,cbcl2,by=c('subjectkey','eventname'))

# initialize master df
masterdf<-merge(cbcls,cbcl,by=c('subjectkey','eventname','interview_age','src_subject_id','sex'))
# omit nans and empties for variables of interest (totprobs,int,ext)
masterdf=masterdf[!is.empty(masterdf$cbcl_scr_syn_totprob_r),]
masterdf=masterdf[!is.na(masterdf$cbcl_scr_syn_totprob_r),]
masterdf=masterdf[!is.empty(masterdf$cbcl_scr_syn_internal_r),]
masterdf=masterdf[!is.na(masterdf$cbcl_scr_syn_internal_r),]
masterdf=masterdf[!is.empty(masterdf$cbcl_scr_syn_external_r),]
masterdf=masterdf[!is.na(masterdf$cbcl_scr_syn_external_r),]
# calculate remaining subjs
cbclSubjs=length(unique(masterdf$subjectkey))
# initialize included subjects df
includedSubjects=data.frame(unique(masterdf$subjectkey))
colnames(includedSubjects)<-'subj'
includedSubjects$cbclInclude=1


# check for completeness at both timepoints- subset those timepoints
masterdf=masterdf[masterdf$eventname!='1_year_follow_up_y_arm_1',]
masterdf=masterdf[masterdf$eventname!='3_year_follow_up_y_arm_1',]

# get other vars of interest to check for complete cases
KidVarsOfInt=c('cbcl_scr_syn_totprob_r','cbcl_scr_syn_external_r','cbcl_scr_syn_internal_r')

# only use subjects with both timepoints as complete cases
subjs=unique(masterdf$subjectkey)
for (s in subjs){
  # if there are less than two complete cases of the variables of interest
  if (sum(complete.cases(masterdf[masterdf$subjectkey==s,c(KidVarsOfInt)]))<2){
    subjs=subjs[subjs!=s]
  }
}

# exclude participants without data at both timepoints
cbclSubjs=length(unique(masterdf$subjectkey))
masterdf=masterdf[masterdf$subjectkey %in% subjs,]

# included subjs df
includedSubjects$CBCLBoth=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$CBCLBoth=1

cbclSubjsBoth=length(unique(masterdf$subjectkey))
print(paste0(cbclSubjs-cbclSubjsBoth,' lost due to single-timepoint CBCL completeness'))
```

    ## [1] "3764 lost due to single-timepoint CBCL completeness"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
#### Chunlk 2 processes adult mental health ####
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

### LOAD in ASR data
asr=read.delim('~/Downloads/Package_1210940/pasr01.txt',na.strings=c("","NA"))
# merge
masterdf<-merge(masterdf,asr,by=c('subjectkey','eventname','interview_age','sex'))
# check for populated data at BOTH timepoints
ColsOfInt=asr[,c(11:141)]
ASRVarsOfInt=colnames(ColsOfInt)
# only use subjects with both timepoints as complete cases
subjs=unique(masterdf$subjectkey)
for (s in subjs){
  # if there are less than two complete cases of the variables of interest
  if (sum(complete.cases(masterdf[masterdf$subjectkey==s,c(ASRVarsOfInt)]))<2){
    subjs=subjs[subjs!=s]
  }
}

masterdf=masterdf[masterdf$subjectkey %in% subjs,]

# full losses counted after asr count chunk, but note one participant is probably lost here just from merge
asrSubjs=length(unique(masterdf$subjectkey))
dif=cbclSubjsBoth-asrSubjs
print(paste0(dif,' participants lost from needing ASR at both timepoints'))
```

    ## [1] "4 participants lost from needing ASR at both timepoints"

``` r
# included subjs df
includedSubjects$ASR=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$ASR=1
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
####  Chunk 4   processes family ID   data  ####
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# load in acs file for rel_family_ID
# get family ID from acs
acs=read.delim('~/Downloads/Package_1210940/acspsw03.txt')
acs$subjectkey<-acs$src_subject_id
acs=acs[,c('rel_family_id','subjectkey','eventname')]
# looks like all family IDs are missing from timepoint 1, so exclude for ease
acs=acs[acs$eventname=='baseline_year_1_arm_1',]
# and isolate family ID for ease
acs=data.frame(acs$subjectkey,acs$rel_family_id)
colnames(acs)=c('subjectkey','rel_family_id')
masterdf<-merge(masterdf,acs,by=c('subjectkey'))
# na omitted version
masterdf=masterdf[!is.na(masterdf$rel_family_id),] 
masterdf=masterdf[!is.empty(masterdf$rel_family_id),] 
acsSubjs=length(unique(masterdf$subjectkey))
# add to included subjs DF
includedSubjects$acs=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$acs=1
# print data volume
print(acsSubjs)
```

    ## [1] 8058

``` r
dif=asrSubjs-acsSubjs
print(paste0(dif,' participants lost from ACS merge for family ID'))
```

    ## [1] "1 participants lost from ACS merge for family ID"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
### This  (short)  chunk formats   cbcl data ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

### CLEAN data
# subjectkey as factor
masterdf$subjectkey<-as.factor(masterdf$subjectkey)
# convert cbcl scores to numeric
masterdf$cbcl_scr_syn_totprob_r<-as.numeric(masterdf$cbcl_scr_syn_totprob_r)
masterdf$cbcl_scr_syn_internal_r<-as.numeric(masterdf$cbcl_scr_syn_internal_r)
masterdf$cbcl_scr_syn_external_r<-as.numeric(masterdf$cbcl_scr_syn_external_r)
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
####   Chunk 6 processes cognitive data    ####
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

#### LOAD in cognitive data
nihCog=read.delim('~/Downloads/Package_1210940/abcd_tbss01.txt')
othCog=read.delim('~/Downloads/Package_1210940/abcd_ps01.txt')
littleMan=read.delim('~/Downloads/Package_1210940/lmtp201.txt')

# merge in
masterdf<-merge(masterdf,nihCog,by=c('subjectkey','eventname','interview_age','sex'))
```

    ## Warning in merge.data.frame(masterdf, nihCog, by = c("subjectkey", "eventname",
    ## : column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'interview_date.y',
    ## 'collection_title.y' are duplicated in the result

``` r
newList=length(unique(masterdf$subjectkey))
print(paste0(newList,' after merging nih toolbox, ',(acsSubjs- newList),' lost after merge'))
```

    ## [1] "8058 after merging nih toolbox, 0 lost after merge"

``` r
masterdf<-merge(masterdf,othCog,by=c('subjectkey','eventname','interview_age','sex'))
```

    ## Warning in merge.data.frame(masterdf, othCog, by = c("subjectkey", "eventname",
    ## : column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'collection_title.y', 'src_subject_id.y' are duplicated in
    ## the result

``` r
newList2=length(unique(masterdf$subjectkey))
print(paste0(newList2,' after merging other cognitive measures, ',(newList- newList2),' lost after merge'))
```

    ## [1] "8058 after merging other cognitive measures, 0 lost after merge"

``` r
masterdf<-merge(masterdf,littleMan,by=c('subjectkey','eventname','interview_age','sex'))
```

    ## Warning in merge.data.frame(masterdf, littleMan, by = c("subjectkey",
    ## "eventname", : column names 'collection_id.x', 'dataset_id.x',
    ## 'interview_date.x', 'collection_title.x', 'collection_id.y', 'dataset_id.y',
    ## 'src_subject_id.x', 'interview_date.y', 'collection_title.y',
    ## 'collection_id.x', 'dataset_id.x', 'src_subject_id.y', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'interview_date.y',
    ## 'collection_title.y' are duplicated in the result

``` r
newList3=length(unique(masterdf$subjectkey))
print(paste0(newList3,' after merging little man, ',(newList2 - newList3),' lost after merge'))
```

    ## [1] "8058 after merging little man, 0 lost after merge"

``` r
# clean age
masterdf$interview_age<-as.numeric(masterdf$interview_age)
masterdf$interview_age<-as.numeric(masterdf$interview_age)/12
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
## Chunk 7 preps for cognition factorization ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# use thompson 2019 recreation of non nih-tb measures
ind_pea_ravlt = c(which(names(masterdf)=="pea_ravlt_sd_trial_i_tc"),which(names(masterdf)=="pea_ravlt_sd_trial_ii_tc"),
    which(names(masterdf)=="pea_ravlt_sd_trial_iii_tc"),which(names(masterdf)=="pea_ravlt_sd_trial_iv_tc"),
    which(names(masterdf)=="pea_ravlt_sd_trial_v_tc")); names(masterdf)[ind_pea_ravlt];
```

    ## [1] "pea_ravlt_sd_trial_i_tc"   "pea_ravlt_sd_trial_ii_tc" 
    ## [3] "pea_ravlt_sd_trial_iii_tc" "pea_ravlt_sd_trial_iv_tc" 
    ## [5] "pea_ravlt_sd_trial_v_tc"

``` r
# set numbers to numeric
masterdf$pea_ravlt_sd_trial_i_tc=as.numeric(masterdf$pea_ravlt_sd_trial_i_tc)
masterdf$pea_ravlt_sd_trial_ii_tc=as.numeric(masterdf$pea_ravlt_sd_trial_ii_tc)
masterdf$pea_ravlt_sd_trial_iii_tc=as.numeric(masterdf$pea_ravlt_sd_trial_iii_tc)
masterdf$pea_ravlt_sd_trial_iv_tc=as.numeric(masterdf$pea_ravlt_sd_trial_vi_tc)
masterdf$pea_ravlt_sd_trial_v_tc=as.numeric(masterdf$pea_ravlt_sd_trial_v_tc)

# total correct across trials
masterdf$pea_ravlt_ld = masterdf$pea_ravlt_sd_trial_i_tc + masterdf$pea_ravlt_sd_trial_ii_tc + masterdf$pea_ravlt_sd_trial_iii_tc + masterdf$pea_ravlt_sd_trial_iv_tc + masterdf$pea_ravlt_sd_trial_v_tc

# change to numeric
masterdf$nihtbx_picvocab_uncorrected<-as.numeric(masterdf$nihtbx_picvocab_uncorrected)
masterdf$nihtbx_flanker_uncorrected<-as.numeric(masterdf$nihtbx_flanker_uncorrected)
masterdf$nihtbx_list_uncorrected<-as.numeric(masterdf$nihtbx_list_uncorrected)
masterdf$nihtbx_cardsort_uncorrected<-as.numeric(masterdf$nihtbx_cardsort_uncorrected)
masterdf$nihtbx_pattern_uncorrected<-as.numeric(masterdf$nihtbx_pattern_uncorrected)
masterdf$nihtbx_picture_uncorrected<-as.numeric(masterdf$nihtbx_picture_uncorrected)
masterdf$nihtbx_reading_uncorrected<-as.numeric(masterdf$nihtbx_reading_uncorrected)
masterdf$pea_wiscv_tss<-as.numeric(masterdf$pea_wiscv_tss)
masterdf$lmt_scr_perc_correct<-as.numeric(masterdf$lmt_scr_perc_correct)

# for isolating PCA dataframe
pcVars=c("nihtbx_picvocab_uncorrected","nihtbx_flanker_uncorrected","nihtbx_pattern_uncorrected","nihtbx_picture_uncorrected","nihtbx_reading_uncorrected","pea_ravlt_ld","lmt_scr_perc_correct")

# only use subjects with both timepoints as complete cases
subjs=unique(masterdf$subjectkey)
for (s in subjs){
  # if there are less than two complete cases of the variables of interest
  if (sum(complete.cases(masterdf[masterdf$subjectkey==s,c(pcVars)]))<2){
    subjs=subjs[subjs!=s]
  }
}
# convert masterdf to df with complete observations for cognition
masterdf=masterdf[masterdf$subjectkey %in% subjs,]
newList4=length(unique(masterdf$subjectkey))
print(paste0(newList4,' after retaining only subjs with Cognitive vars of int at BOTH timepoints, ',(newList3- newList4),' lost after removing'))
```

    ## [1] "6580 after retaining only subjs with Cognitive vars of int at BOTH timepoints, 1478 lost after removing"

``` r
print(dim(masterdf))
```

    ## [1] 13160   591

``` r
# populated included subjs df
includedSubjects$CogBoth=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$CogBoth=1
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
###  Chunk 8 preps by selecting 1 per family ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
# finish cleaning data for sherlock runs: one family member per family to facilitate random sample
masterdf$id_fam = NULL
# default value of family size (# of children in abcd study)
masterdf$fam_size = 1

# counter index
ind=0

# set each instance of multiple family members to a family ID, as ind
set.seed(1)
for(f in 1:length(unique(masterdf$rel_family_id))){
  # calculate family size
  famsize=sum(masterdf$rel_family_id == unique(masterdf$rel_family_id)[f]) / 2
  masterdf$fam_size[masterdf$rel_family_id == unique(masterdf$rel_family_id)[f]] = famsize
  # note that each  person is represented twice at this point:
  # divide by 2 to take number of visits to number of people, if there's more than 2x visits per family ID, izza family
  # this logic gets hairy. Starting from outside in: > 1 is family size >1, /2 is divided by 2 for two visits, [f] is unique familyID, rel_family_id is place in column of masterdf
  if(famsize>1){
    # remove one from instances where family-id = this relative family id (sequence for siblings, 1:size(Family))
    #print(paste0('family size ',famsize))
    # keep one sib
    kept=sample(seq(1,famsize),1)
    #print(paste0('kept ',kept))
    # use to select one subject id
    famIDs=unique(masterdf$subjectkey[masterdf$rel_family_id == unique(masterdf$rel_family_id)[f]])
    # chosen sib
    keeper=famIDs[kept]
    left=famIDs[-c(kept)]
    # leave rest
    masterdf=masterdf[!masterdf$subjectkey %in% left,] 
    # calc index of family
    ind=ind+1   
    # set index of family
    masterdf$id_fam[masterdf$rel_family_id == unique(masterdf$rel_family_id)[f]] = ind
  } 
}

# make family ID for those with families represented in ABCD
masterdf$rel_family_id=masterdf$id_fam

newList5=length(unique(masterdf$subjectkey))
print(paste0(newList5,' after retaining only one subjs per family, ',(newList4- newList5),' lost after removing'))
```

    ## [1] "5709 after retaining only one subjs per family, 871 lost after removing"

``` r
# included subjects DF to track subj loss
includedSubjects$OnePerFamily=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$OnePerFamily=1

# pea_wiscv_tss, nihtbx_list_uncorrected, and nihtbx_cardsort_uncorrected taken out for lack of longitudinal coverage
pcaDf<-masterdf[,pcVars]
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
### Chunk 9: it runs cognition factorization ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# derive pcs
Y = as.matrix(scale(pcaDf[complete.cases(pcaDf[,pcVars]),pcVars]))
# equiv for binding scores to IDs and eventnames
pcVarsAndIDs=c("nihtbx_picvocab_uncorrected","nihtbx_flanker_uncorrected","nihtbx_pattern_uncorrected","nihtbx_picture_uncorrected","nihtbx_reading_uncorrected","pea_ravlt_ld","lmt_scr_perc_correct","subjectkey","eventname")
Yextended=masterdf[complete.cases(masterdf[,pcVarsAndIDs]),pcVarsAndIDs]
ncomp = 3
y.pca = psych::principal(Y, rotate="varimax", nfactors=ncomp, scores=TRUE)
y.pca$loadings
```

    ## 
    ## Loadings:
    ##                             RC1    RC2    RC3   
    ## nihtbx_picvocab_uncorrected  0.752  0.186  0.106
    ## nihtbx_flanker_uncorrected   0.205  0.823       
    ## nihtbx_pattern_uncorrected   0.168  0.844       
    ## nihtbx_picture_uncorrected   0.608  0.248       
    ## nihtbx_reading_uncorrected   0.710  0.205  0.189
    ## pea_ravlt_ld                 0.765              
    ## lmt_scr_perc_correct                       0.980
    ## 
    ##                RC1   RC2   RC3
    ## SS loadings    2.1 1.535 1.016
    ## Proportion Var 0.3 0.219 0.145
    ## Cumulative Var 0.3 0.519 0.664

``` r
# assign scores to subjs
Yextended$g<-y.pca$scores[,1]
# merge in cog data
masterdf$g<-Yextended$g
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
## Chunk 10 subjects with data at both timepoints##
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# exclude subjs without data for both timepoints
OutDFsubjects=length(unique(masterdf$subjectkey))
OutDFBV=subset(masterdf,eventname=='baseline_year_1_arm_1')
OutDF2Y=subset(masterdf,eventname=='2_year_follow_up_y_arm_1')
# intersection of subjs in both
BothTPsubjs=intersect(OutDFBV$subjectkey,OutDF2Y$subjectkey)
Different=setdiff(unique(masterdf$subjectkey),BothTPsubjs)
# print sanity check subjs lost to another check of both tps populated
newList6=length(unique(BothTPsubjs))
dif=newList5-newList6
print(paste0(dif,' rows lost from only using subjs with both timepoints'))
```

    ## [1] "0 rows lost from only using subjs with both timepoints"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
## Chunk 11 handles adult p factor            ##
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# make count version of adult P
ASRdfNum<-as.data.frame(lapply(asr[-1,11:141],as.numeric))
ASRtotal=rowSums(ASRdfNum)
# and subtract reverse score items because they were included in sum above, and modeling "happiness" as symmetric to "symptoms" seems like a strong assumption
# reverse scored = face validity AND loading in expected direction
ASRtotal=ASRtotal-ASRdfNum$asr_q02_p
ASRtotal=ASRtotal-ASRdfNum$asr_q04_p
ASRtotal=ASRtotal-ASRdfNum$asr_q15_p
ASRtotal=ASRtotal-ASRdfNum$asr_q73_p
ASRtotal=ASRtotal-ASRdfNum$asr_q80_p
ASRtotal=ASRtotal-ASRdfNum$asr_q88_p
ASRtotal=ASRtotal-ASRdfNum$asr_q106_p
ASRtotal=ASRtotal-ASRdfNum$asr_q109_p
ASRtotal=ASRtotal-ASRdfNum$asr_q123_p

# merge in (first row is colnames)
asr$parentPcount=c(NA,ASRtotal)
# fix asr age for merge
asr$interview_age=as.numeric(asr$interview_age)/12
```

    ## Warning: NAs introduced by coercion

``` r
# set subjectkey to factor for merge
asr$subjectkey<-as.factor(asr$subjectkey)

# ensure none are missing
paste0(length(unique(masterdf$subjectkey)))
```

    ## [1] "5709"

``` r
# collapse to just variables of interest to prevent duplicate variables
asr=asr[,c('parentPcount','subjectkey','eventname','interview_age')]
# merge
masterdf=merge(masterdf,asr,by=c('subjectkey','eventname','interview_age'))
```

    ## Warning in merge.data.frame(masterdf, asr, by = c("subjectkey", "eventname", :
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'collection_title.y', 'collection_id.x', 'dataset_id.x',
    ## 'src_subject_id.y', 'interview_date.x', 'collection_title.x',
    ## 'collection_id.y', 'dataset_id.y', 'interview_date.y', 'collection_title.y' are
    ## duplicated in the result

``` r
# ensure none are missing
paste0(length(unique(masterdf$subjectkey)))
```

    ## [1] "5709"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
## Chunk 12 Handles participants TSV          ##
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

### LOAD in ParticipantsTSV for parent income and edu background
# ordained sample split
participantsTSV=read.delim('~/Downloads/participants.tsv',sep="\t")
participantsTSV$subjectkey<-participantsTSV$participant_id
# reformat participant IDs so they match everything else
participantsTSV$subjectkey<-gsub('sub-','',participantsTSV$subjectkey)
participantsTSV$subjectkey<-as.factor(gsub('NDARINV','NDAR_INV',participantsTSV$subjectkey))
participantsTSV$eventname=participantsTSV$session_id
### issue where subjects are repeated. Rows are not identical either.
# query. get table of subject ids
b=table(as.factor(participantsTSV$participant_id))
# report subj ids used more than once and times used
bdf=data.frame(b[b>1])
SubjsRepeated=bdf$Var1
# well some rows with the same participant IDs have different sites, can't use that unless it makes sense
dimB4repRem=dim(participantsTSV)
# remove repeated subjs
participantsTSV=participantsTSV[!participantsTSV$participant_id %in% SubjsRepeated,]
dif=dimB4repRem[1]-dim(participantsTSV)[1]
print(paste0(dif/2,' Participants lost from ambiguously repeated pt ids in participants.tsv'))
```

    ## [1] "44 Participants lost from ambiguously repeated pt ids in participants.tsv"

``` r
# well some rows with the same participant IDs have different sites, can't use that unless it makes sense\
dimB4repRem=dim(participantsTSV)
# remove repeated subjs
participantsTSV=participantsTSV[!participantsTSV$participant_id %in% SubjsRepeated,]
# remove eventname column from participants tsv, not informative and causes problems down the road
participantsTSV = participantsTSV[,!(names(participantsTSV) %in% 'eventname')]
# convert sex to M/F in particpants tsv
participantsTSV$sex[participantsTSV$sex==1]="M"
participantsTSV$sex[participantsTSV$sex==2]="F"

# take out na incomes
participantsTSV=participantsTSV[participantsTSV$income!=777,]
participantsTSV=participantsTSV[participantsTSV$income!=999,]
# race
participantsTSV=participantsTSV[participantsTSV$race_ethnicity!=888,]
participantsTSV$race_ethnicity<-as.factor(participantsTSV$race_ethnicity)
# parental edu
participantsTSV=participantsTSV[participantsTSV$parental_education!=888,]
participantsTSV=participantsTSV[participantsTSV$parental_education!=777,]
participantsTSV$parental_education<-as.ordered(participantsTSV$parental_education)

#########################
#########################
#########################
#########################
### merge in for fam income and parent edu
masterdf=merge(masterdf,participantsTSV,by=c('subjectkey','sex'))
```

    ## Warning in merge.data.frame(masterdf, participantsTSV, by = c("subjectkey", :
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'collection_title.y', 'collection_id.x', 'dataset_id.x',
    ## 'src_subject_id.y', 'interview_date.x', 'collection_title.x',
    ## 'collection_id.y', 'dataset_id.y', 'interview_date.y', 'collection_title.y' are
    ## duplicated in the result

``` r
# this dataframe is now your working data frame for all figure RMDs
saveRDS(masterdf,'~/gp_masterdf.rds')
####################
#########################
#########################
#########################

# new merge and count
participantsTSVSubjs=length(unique(masterdf$subjectkey))
# add to included subjs DF
includedSubjects$pTSV=0
includedSubjects[includedSubjects$subj %in% unique(masterdf$subjectkey),]$pTSV=1

print(paste0(newList6-participantsTSVSubjs,' participants lost after needing complete data in participantstsv'))
```

    ## [1] "469 participants lost after needing complete data in participantstsv"

``` r
paste0(participantsTSVSubjs,' remain')
```

    ## [1] "5240 remain"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
#### Chunk 13 plots data missingness       #####
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# melt the plot df to get in proper format
plotdf=melt(includedSubjects)
```

    ## Using subj as id variables

``` r
plotdf$value<-as.factor(plotdf$value)
plotdf$subj<-as.factor(plotdf$subj)
# merge in raceEth of each subj
raceEth=participantsTSV$race_ethnicity
subjectsInPtsv=participantsTSV$subjectkey
infoDf=data.frame(raceEth,subjectsInPtsv)
colnames(infoDf)<-c('RaceEthn','subj')
test=merge(plotdf,infoDf,by='subj')
# overwrite race with "empty" if missing after each checkpoint
test$RaceEthn<-factor(test$RaceEthn,levels=c(1,2,3,4,5,6),labels=c("White","Black","Hispanic","Asian","Other","Missing"))
test$RaceEthn[test$value==0]="Missing"

my_colors <- c("red", "orange", "yellow", "green", "blue", "gray")

ggplot(test, aes(x = variable, stratum = RaceEthn, alluvium = subj)) +
  geom_stratum(aes(fill = RaceEthn)) +
  geom_flow(aes(fill = RaceEthn)) +
  scale_fill_manual(values = my_colors) +
  theme_bw(base_size = 35)
```

![](SampleConstruction_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
#### Chunk 14 plots  missingness as pie charts #
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

# can overlay two pie charts: starting raceEth Comp and Ending. Tuck into area that is pink now
startingdf=test[test$variable=='cbclInclude',]
startingdf=startingdf[startingdf$value==1,]
endingdf=test[test$variable=='pTSV',]
endingdf=endingdf[endingdf$value==1,]
# now tabulate them to get in proper plotting format
startingdfTab=tabulate(startingdf$RaceEthn)
endingdfTab=tabulate(endingdf$RaceEthn)
# starting df: adding 0 for placeholder for missing category (consistent coloration)
startingdf=data.frame(c(startingdfTab,0),factor(c("White","Black","Hispanic","Asian","Other","Missing"),levels=c("White","Black","Hispanic","Asian","Other","Missing")))
colnames(startingdf)<-c('value','RaceEthnicity')
ggplot(startingdf, aes(x="", y=value, fill=RaceEthnicity)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)+ggtitle('Before Exclusions')+
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank(),panel.background = element_blank(),
        plot.title = element_text(size = 40),
        legend.text = element_text(size=40),legend.title = element_text(size=40))
```

![](SampleConstruction_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
# plot df is both with race labels
endingdf=data.frame(c(endingdfTab,0),factor(c("White","Black","Hispanic","Asian","Other","Missing"),levels=c("White","Black","Hispanic","Asian","Other","Missing")))
colnames(endingdf)<-c('value','RaceEthnicity')
ggplot(endingdf, aes(x="", y=value, fill=RaceEthnicity)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)+ggtitle('After Exclusions')+
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank(),panel.background = element_blank(),
        plot.title = element_text(size = 40),
        legend.text = element_text(size=40),legend.title = element_text(size=40))
```

![](SampleConstruction_files/figure-gfm/unnamed-chunk-14-2.png)<!-- -->

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##################
#### Chunk 15 loads in ksads data for a supplement #
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##################

# now making an alternate version with KSADS for child-reported-p-proxy. Note that I wanted to get child-identified gender from ksads, but values are missing for every single observation
ksads_y=read.delim('~/Downloads/Package_1216656/abcd_ksad501.txt')
# convert src_subject_id to subjectkey
ksads_y$subjectkey=ksads_y$src_subject_id
# and age to numeric for merging later
ksads_y$interview_age<-as.numeric(ksads_y$interview_age)/12
```

    ## Warning: NAs introduced by coercion

``` r
# remove timepoints .5 and 1.5
ksads_y=ksads_y[ksads_y$eventname!='1_year_follow_up_y_arm_1',]
ksads_y=ksads_y[ksads_y$eventname!='3_year_follow_up_y_arm_1',]
# Extract the first row of the ksads_y data frame (true column names)
first_row <- ksads_y[1, ]
# Get the column indices that contain ', Present'
present_cols <- grep(', Present', first_row)
# now select for those that specify symptoms
symptom_cols <- grep('Symptom', first_row)
# get intersection
present_symptom_cols=intersect(present_cols,symptom_cols)
# count empties
ksads_y$empties<-0
for (i in present_symptom_cols){
  # add an empty count for each subject where this one symptom is missing
  ksads_y$empties=ksads_y$empties+as.numeric(is.empty(ksads_y[,i]))
}
# omit empties
ksads_y_rem=ksads_y[ksads_y$empties<1,] 
# omit subjects without data at both timepoints
ksadsy_subjects=length(unique(ksads_y_rem$subjectkey))
OutDFBV=subset(ksads_y_rem,eventname=='baseline_year_1_arm_1')
OutDF2Y=subset(ksads_y_rem,eventname=='2_year_follow_up_y_arm_1')
# intersection of subjs in both
BothTPsubjs=intersect(OutDFBV$subjectkey,OutDF2Y$subjectkey)
MissingTPsubjs=setdiff(unique(masterdf$subjectkey),BothTPsubjs)
# only include subjects with data at both timepoints
ksads_y_rem=ksads_y_rem[ksads_y_rem$subjectkey %in% BothTPsubjs,]
# deal with numeric codes
ksads_y_rem[ksads_y_rem=="555"]=NA
ksads_y_rem[ksads_y_rem=="888"]=NA
ksads_y_rem[ksads_y_rem=="999"]=NA 

# Loop through the present_cols and convert each column to numeric
for (col_index in present_symptom_cols) {
  ksads_y_rem[[col_index]] <- as.numeric(ksads_y_rem[[col_index]])
}

# get a count of endorsed, present symptoms. use grep to select for colnames that have ", Present" in them
ksads_y_rem$totcount_y=rowSums(ksads_y_rem[present_symptom_cols],na.rm = T)

### merge in for child-reported p equivalent
masterdf2=merge(masterdf,ksads_y_rem,by=c('subjectkey','sex','interview_age','eventname'))
```

    ## Warning in merge.data.frame(masterdf, ksads_y_rem, by = c("subjectkey", :
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'collection_title.y', 'collection_id.x', 'dataset_id.x',
    ## 'src_subject_id.y', 'interview_date.x', 'collection_title.x',
    ## 'collection_id.y', 'dataset_id.y', 'src_subject_id.x', 'interview_date.y',
    ## 'collection_title.y', 'src_subject_id.y' are duplicated in the result

``` r
# new merge and count
ksadsSubjs=length(unique(masterdf2$subjectkey))
# add to included subjs DF
includedSubjects$ksads=0
includedSubjects[includedSubjects$subj %in% unique(masterdf2$subjectkey),]$ksads=1

# melt the plot df to get in proper format
plotdf=melt(includedSubjects)
```

    ## Using subj as id variables

``` r
plotdf$value<-as.factor(plotdf$value)
plotdf$subj<-as.factor(plotdf$subj)
# merge in raceEth of each subj
raceEth=participantsTSV$race_ethnicity
subjectsInPtsv=participantsTSV$subjectkey
infoDf=data.frame(raceEth,subjectsInPtsv)
colnames(infoDf)<-c('RaceEthn','subj')
test=merge(plotdf,infoDf,by='subj')
# overwrite race with "empty" if missing after each checkpoint
test$RaceEthn<-factor(test$RaceEthn,levels=c(1,2,3,4,5,6),labels=c("White","Black","Hispanic","Asian","Other","Missing"))
test$RaceEthn[test$value==0]="Missing"

my_colors <- c("red", "orange", "yellow", "green", "blue", "gray")

ggplot(test, aes(x = variable, stratum = RaceEthn, alluvium = subj)) +
  geom_stratum(aes(fill = RaceEthn)) +
  geom_flow(aes(fill = RaceEthn)) +
  scale_fill_manual(values = my_colors) +
  theme_bw(base_size = 35)
```

![](SampleConstruction_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
#########################
#########################
#########################
#########################
# this dataframe is now your working data frame for fig4 sensititvity analyses
saveRDS(masterdf2,'~/gp_masterdf2.rds')
####################
#########################
#########################
#########################
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆################################
#### Chunk 16 prepares data for analysis of temporal precedence ##
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆################################

variablesOfInterest=c('cbcl_scr_syn_totprob_r','cbcl_scr_syn_external_r','cbcl_scr_syn_internal_r','g','subjectkey','interview_age','parentPcount','income','sex','race_ethnicity','matched_group','eventname')
# eliminate rows with NAs and ensure none without two-timepoint data
# variables of interest redux
masterdf=masterdf[,c(variablesOfInterest)]
# na omitted version
masterdf=masterdf[rowSums(is.na(masterdf)) == 0, ] 
print(dim(masterdf))
```

    ## [1] 10480    12

``` r
# and two-timepoint check
twoTPsubjs=names(table(masterdf$subjectkey)[table(masterdf$subjectkey)>1])
masterdf=masterdf[masterdf$subj %in% twoTPsubjs,]

# now set subsets to use for temporal precedence analyses 
df1=masterdf[masterdf$eventname=='baseline_year_1_arm_1',]
df2=masterdf[masterdf$eventname=='2_year_follow_up_y_arm_1',]
subsetOfBoth=merge(df1,df2,by='subjectkey')
subsetOfBoth=subsetOfBoth$subjectkey

# convert to one row per subj for temporal precedence analyses
OutDFTmpPrec<-merge(df1,df2,by='subjectkey')
print(dim(OutDFTmpPrec))
```

    ## [1] 5240   23

``` r
# save it out
saveRDS(OutDFTmpPrec,'~/OutDFTmpPrec.rds')
```