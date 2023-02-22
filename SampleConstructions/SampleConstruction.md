SampleConstruction
================
Adam
2023-01-25

This .rmd links ndar downloads into a master dataset. Cross-sectional
and temporal precedence datasets are be exported from this file (no
matched imaging groups needed, pooled factor decomposition), while
predictive datasets are exported from SampleConstruction_Ridge.Rmd

``` r
#### LOAD libraries
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
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
### This chunk processes mental health data ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

### LOAD in cbcl data
cbcl=read.delim('~/Downloads/Package_1205735/abcd_cbcl01.txt')
cbcls=read.delim('/Users/panlab/Downloads/Package_1205735/abcd_cbcls01.txt')
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
masterdf<-merge(cbcls,cbcl,by=c('subjectkey','eventname','interview_age','src_subject_id'))
cbcldim<-dim(masterdf)
print(cbcldim)
```

    ## [1] 39767   218

``` r
### LOAD in grades, ∆∆∆ will need to correct for incongruency between tp1 measure (decent granularity) and tp2 measure (high granularity) ∆∆∆
gradesInfoBV=readRDS('~/Downloads/DEAP-data-download-13.rds')
# extract baseline
gradesInfoBV=subset(gradesInfoBV,event_name=='baseline_year_1_arm_1')
gradesInfoBV$Grades<-as.numeric(gradesInfoBV$ksads_back_grades_in_school_p)
# convert ndar value to R
gradesInfoBV$Grades[gradesInfoBV$Grades==-1]=NA
# convert ndar colnames to other ndar colnames
gradesInfoBV$eventname=gradesInfoBV$event_name
gradesInfoBV$subjectkey=gradesInfoBV$src_subject_id
# for tp2, the key is 1 = A's, 2 = B's, 3 = C's, 4 = D's, 5 = F's, -1 = NA
gradesInfoY2=read.delim('~/Downloads/Package_1207225/abcd_saag01.txt')
gradesInfoY2=subset(gradesInfoY2,eventname=='2_year_follow_up_y_arm_1')
gradesInfoY2$sag_grade_type<-as.numeric(gradesInfoY2$sag_grade_type)
# key: 1=100-97,2=96-93,3=92-90,4=89-87,5=86-83,6=82-80,7=79-77,8=76-73,9=72-70,10=69-67,11=66-65,12=0-65,-1=NA,777= no answer
gradesInfoY2$sag_grade_type[gradesInfoY2$sag_grade_type==-1]=NA
gradesInfoY2$sag_grade_type[gradesInfoY2$sag_grade_type==777]=NA
# now convert to be equivalent with timepoint 1 grades measure
ind12=gradesInfoY2$sag_grade_type==12
ind11=gradesInfoY2$sag_grade_type==11
ind10=gradesInfoY2$sag_grade_type==10
ind9=gradesInfoY2$sag_grade_type==9
ind8=gradesInfoY2$sag_grade_type==8
ind7=gradesInfoY2$sag_grade_type==7
ind6=gradesInfoY2$sag_grade_type==6
ind5=gradesInfoY2$sag_grade_type==5
ind4=gradesInfoY2$sag_grade_type==4
ind3=gradesInfoY2$sag_grade_type==3
ind2=gradesInfoY2$sag_grade_type==2
ind1=gradesInfoY2$sag_grade_type==1
#### Set indices to low-res versions
# < 65 becomes failing
gradesInfoY2$sag_grade_type[ind12]=5
# 66-69 = Ds
gradesInfoY2$sag_grade_type[ind11]=4
gradesInfoY2$sag_grade_type[ind10]=4
# 70-79 = Cs
gradesInfoY2$sag_grade_type[ind7]=3
gradesInfoY2$sag_grade_type[ind8]=3
gradesInfoY2$sag_grade_type[ind9]=3
# 80-89 = Bs
gradesInfoY2$sag_grade_type[ind4]=2
gradesInfoY2$sag_grade_type[ind5]=2
gradesInfoY2$sag_grade_type[ind6]=2
# 90+ = As
gradesInfoY2$sag_grade_type[ind1]=1
gradesInfoY2$sag_grade_type[ind2]=1
gradesInfoY2$sag_grade_type[ind3]=1
gradesInfoY2$Grades<-gradesInfoY2$sag_grade_type

###### ∆∆∆∆∆∆∆ create grades info from both of em
NeededColNames=c('subjectkey','eventname','Grades')
gradesInfo<-rbind(gradesInfoBV[,NeededColNames],gradesInfoY2[,NeededColNames])
gradesInfo$Grades<-as.ordered(gradesInfo$Grades)
###### ∆∆∆∆∆∆∆

# merge and count losses
masterdf<-merge(masterdf,gradesInfo,by=c('subjectkey','eventname'))
gradesdim=dim(masterdf)
print(gradesdim)
```

    ## [1] 22289   219

``` r
dif=cbcldim[1]-gradesdim[1]
print(paste0(dif,' rows lost from grades merge, note loss of rows due to no 1 year timepoint'))
```

    ## [1] "17478 rows lost from grades merge, note loss of rows due to no 1 year timepoint"

``` r
### LOAD in ASR data
asr=read.delim('~/Downloads/Package_1207917/pasr01.txt',na.strings=c("","NA"))
masterdf<-merge(masterdf,asr,by=c('subjectkey','eventname','interview_age'))
asrdim=dim(masterdf)
print(asrdim)
```

    ## [1] 22289   364

``` r
dif=gradesdim[1]-asrdim[1]
print(paste0(dif,' rows lost from asr merge'))
```

    ## [1] "0 rows lost from asr merge"

``` r
# load in a DEAP file for rel_family_ID
DEAP=readRDS('~/Downloads/DEAP-data-download-13.rds')
DEAP$subjectkey<-DEAP$src_subject_id
DEAP$eventname=DEAP$event_name
DEAP=DEAP[,c('rel_family_id','subjectkey','eventname')]
masterdf<-merge(masterdf,DEAP,by=c('subjectkey','eventname'))
deapdim=dim(masterdf)
print(deapdim)
```

    ## [1] 22288   365

``` r
dif=asrdim[1]-deapdim[1]
print(paste0(dif,' rows lost from deap familyID merge'))
```

    ## [1] "1 rows lost from deap familyID merge"

``` r
### CLEAN data
# subjectkey as factor
masterdf$subjectkey<-as.factor(masterdf$subjectkey)
# convert cbcl scores to numeric
masterdf$cbcl_scr_syn_totprob_r<-as.numeric(masterdf$cbcl_scr_syn_totprob_r)
masterdf$cbcl_scr_syn_internal_r<-as.numeric(masterdf$cbcl_scr_syn_internal_r)
masterdf$cbcl_scr_syn_external_r<-as.numeric(masterdf$cbcl_scr_syn_external_r)
# remove instances of NA tot probs
masterdf=masterdf[!is.na(masterdf$cbcl_scr_syn_totprob_r),]
newDim=dim(masterdf)
print(paste0(newDim[1],' after removing NAs for totprob_r, ',(deapdim[1]- newDim[1]),' lost after removing'))
```

    ## [1] "19951 after removing NAs for totprob_r, 2337 lost after removing"

``` r
# and for is empty
masterdf=masterdf[!is.empty(masterdf$cbcl_scr_syn_totprob_r),]
newDim2=dim(masterdf)
print(paste0(newDim2[1],' after removing isempty for totprob_r, ',(newDim[1]- newDim2[1]),' lost after removing'))
```

    ## [1] "18935 after removing isempty for totprob_r, 1016 lost after removing"

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
###   This chunk processes cognitive data    ###
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############

#### LOAD in cognitive data
nihCog=read.delim('~/Downloads/Package_1206930/abcd_tbss01.txt')
othCog=read.delim('~/Downloads/Package_1206930/abcd_ps01.txt')
littleMan=read.delim('~/Downloads/Package_1206931/lmtp201.txt')

# merge in
masterdf<-merge(masterdf,nihCog,by=c('subjectkey','eventname','interview_age'))
```

    ## Warning in merge.data.frame(masterdf, nihCog, by = c("subjectkey",
    ## "eventname", : column names 'collection_id.x', 'dataset_id.x',
    ## 'interview_date.x', 'sex.x', 'collection_title.x', 'collection_id.y',
    ## 'dataset_id.y', 'interview_date.y', 'sex.y', 'collection_title.y' are duplicated
    ## in the result

``` r
newDim3=dim(masterdf)
print(paste0(newDim3[1],' after merging nih toolbox, ',(newDim2[1]- newDim3[1]),' lost after removing'))
```

    ## [1] "18935 after merging nih toolbox, 0 lost after removing"

``` r
masterdf<-merge(masterdf,othCog,by=c('subjectkey','eventname','interview_age'))
```

    ## Warning in merge.data.frame(masterdf, othCog, by = c("subjectkey",
    ## "eventname", : column names 'collection_id.x', 'dataset_id.x',
    ## 'interview_date.x', 'sex.x', 'collection_title.x', 'collection_id.y',
    ## 'dataset_id.y', 'src_subject_id.x', 'interview_date.y', 'sex.y',
    ## 'collection_title.y', 'src_subject_id.y' are duplicated in the result

``` r
newDim4=dim(masterdf)
print(paste0(newDim4[1],' after merging other cognitive measures, ',(newDim3[1]- newDim4[1]),' lost after removing'))
```

    ## [1] "18935 after merging other cognitive measures, 0 lost after removing"

``` r
masterdf<-merge(masterdf,littleMan,by=c('subjectkey','eventname','interview_age'))
```

    ## Warning in merge.data.frame(masterdf, littleMan, by = c("subjectkey",
    ## "eventname", : column names 'collection_id.x', 'dataset_id.x',
    ## 'interview_date.x', 'sex.x', 'collection_title.x', 'collection_id.y',
    ## 'dataset_id.y', 'src_subject_id.x', 'interview_date.y', 'sex.y',
    ## 'collection_title.y', 'collection_id.x', 'dataset_id.x', 'src_subject_id.y',
    ## 'interview_date.x', 'sex.x', 'collection_title.x', 'collection_id.y',
    ## 'dataset_id.y', 'interview_date.y', 'sex.y', 'collection_title.y' are duplicated
    ## in the result

``` r
newDim5=dim(masterdf)
print(paste0(newDim5[1],' after merging little man, ',(newDim4[1]- newDim5[1]),' lost after removing'))
```

    ## [1] "18935 after merging little man, 0 lost after removing"

``` r
# clean age
masterdf$interview_age<-as.numeric(masterdf$interview_age)
masterdf$interview_age<-as.numeric(masterdf$interview_age)/12
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
##This chunk preps for cognition factorization##
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

# test for completeness before running PCA. Better move to calculate ONLY in the sample that we are running analyses on (more technically accurate than PC structure slightly misaligned with sample of interest)
# get other vars of interest to check for complete cases
KidVarsOfInt=c('Grades','cbcl_scr_syn_totprob_r','cbcl_scr_syn_external_r','cbcl_scr_syn_internal_r')
# asr columns of interest to gauge completeness of
ColsOfInt=asr[,c(11:141)]
ASRVarsOfInt=colnames(ColsOfInt)

# only use subjects with both timepoints as complete cases
subjs=unique(masterdf$subjectkey)
for (s in subjs){
  # if there are less than two complete cases of the variables of interest
  if (sum(complete.cases(masterdf[masterdf$subjectkey==s,c(pcVars,KidVarsOfInt,ASRVarsOfInt)]))<2){
    subjs=subjs[subjs!=s]
  }
}
# convert masterdf to df with complete observations for cognition
masterdf=masterdf[masterdf$subjectkey %in% subjs,]

newDim6=dim(masterdf)
print(paste0(newDim6[1],' after retaining only subjs with vars of int at BOTH timepoints, ',(newDim5[1]- newDim6[1]),' lost after removing'))
```

    ## [1] "11452 after retaining only subjs with vars of int at BOTH timepoints, 7483 lost after removing"

``` r
print(dim(masterdf))
```

    ## [1] 11452   597

``` r
### ∆∆∆
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
    masterdf=masterdf[masterdf$subjectkey!=left,] 
    #print(paste0('left ',left))
    # calc index of family
    ind=ind+1   
    # set index of family
    masterdf$id_fam[masterdf$rel_family_id == unique(masterdf$rel_family_id)[f]] = ind
  } 
}
```

    ## Warning in `!=.default`(masterdf$subjectkey, left): longer object length is not
    ## a multiple of shorter object length

    ## Warning in is.na(e1) | is.na(e2): longer object length is not a multiple of
    ## shorter object length

    ## Warning in `!=.default`(masterdf$subjectkey, left): longer object length is not
    ## a multiple of shorter object length

    ## Warning in is.na(e1) | is.na(e2): longer object length is not a multiple of
    ## shorter object length

``` r
# make family ID for those with families represented in ABCD
masterdf$rel_family_id=masterdf$id_fam

newDim7=dim(masterdf)
print(paste0(newDim7[1],' after retaining only one subjs per family, ',(newDim6[1]- newDim7[1]),' lost after removing'))
```

    ## [1] "10101 after retaining only one subjs per family, 1351 lost after removing"

``` r
#       NOW 
# THAT'S WHAT I CALL PCAPREP
#       271
# pea_wiscv_tss, nihtbx_list_uncorrected, and nihtbx_cardsort_uncorrected taken out for lack of longitudinal coverage
pcaDf<-masterdf[,pcVars]
```

``` r
###########∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆##############
###  This chunk runs cognition factorization ###
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
    ## nihtbx_picvocab_uncorrected  0.752  0.189       
    ## nihtbx_flanker_uncorrected   0.205  0.820       
    ## nihtbx_pattern_uncorrected   0.163  0.843       
    ## nihtbx_picture_uncorrected   0.605  0.247       
    ## nihtbx_reading_uncorrected   0.708  0.205  0.171
    ## pea_ravlt_ld                 0.764              
    ## lmt_scr_perc_correct                       0.984
    ## 
    ##                  RC1   RC2   RC3
    ## SS loadings    2.091 1.527 1.012
    ## Proportion Var 0.299 0.218 0.145
    ## Cumulative Var 0.299 0.517 0.662

``` r
# assign scores to subjs
Yextended$g<-y.pca$scores[,1]
# merge in cog data
masterdf$g<-Yextended$g
```

``` r
# save out all timepoints df for bootstrapping both-tp-fits
saveRDS(masterdf,'~/DfWithGrades.rds')
print(dim(masterdf))
```

    ## [1] 10101   600

``` r
# exclude subjs without data for both timepoints
OutDF=masterdf
dimOutDF=dim(OutDF)
OutDFBV=subset(OutDF,eventname=='baseline_year_1_arm_1')
OutDF2Y=subset(OutDF,eventname=='2_year_follow_up_y_arm_1')
# intersection of subjs in both
BothTPsubjs=intersect(OutDFBV$subjectkey,OutDF2Y$subjectkey)
# index out intersection from non tp-split df
OutDF=OutDF[OutDF$subjectkey %in% BothTPsubjs,]
outDf2dim=dim(OutDF)
print(outDf2dim)
```

    ## [1] 10076   600

``` r
dif=dimOutDF[1]-outDf2dim[1]
print(paste0(dif,' rows lost from only using subjs with both timepoints'))
```

    ## [1] "25 rows lost from only using subjs with both timepoints"

``` r
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

# merge
OutDF=merge(OutDF,asr,by=c('subjectkey','eventname','interview_age'))
```

    ## Warning in merge.data.frame(OutDF, asr, by = c("subjectkey", "eventname", :
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x', 'sex.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'sex.y', 'collection_title.y', 'collection_id.x',
    ## 'dataset_id.x', 'src_subject_id.y', 'interview_date.x', 'sex.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'sex.y', 'collection_title.y', 'src_subject_id.y' are
    ## duplicated in the result

``` r
print(dim(OutDF))
```

    ## [1] 10076   746

``` r
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
### merge in for fam income and parent edu
OutDF=merge(OutDF,participantsTSV,by=c('subjectkey'))
```

    ## Warning in merge.data.frame(OutDF, participantsTSV, by = c("subjectkey")):
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x', 'sex.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'sex.y', 'collection_title.y', 'collection_id.x',
    ## 'dataset_id.x', 'src_subject_id.y', 'interview_date.x', 'sex.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'src_subject_id.x',
    ## 'interview_date.y', 'sex.y', 'collection_title.y', 'src_subject_id.y', 'sex.x',
    ## 'sex.y' are duplicated in the result

``` r
# take out na incomes
OutDF=OutDF[OutDF$income!=777,]
OutDF=OutDF[OutDF$income!=999,]
# race
OutDF=OutDF[OutDF$race_ethnicity!=888,]
OutDF$race_ethnicity<-as.factor(OutDF$race_ethnicity)
# parental edu
OutDF=OutDF[OutDF$parental_education!=888,]
OutDF=OutDF[OutDF$parental_education!=777,]
OutDF$parental_education<-as.ordered(OutDF$parental_education)
dim(OutDF)
```

    ## [1] 9296  763

``` r
#### LOAD in youth life events. Unfortunately this also appears to be missing for most participants, but is populated for slightly more than residential deprivation
yle=read.delim('~/Downloads/Package_1209596/abcd_yle01.txt')
yleColnames=colnames(yle)
yleColDescrip=yle[1,]
# note yle's are labeled ple's in the colnames, but end with a _y extension (ples end with _p extension)

##### Extract purely retrospective, i.e., viable for inclusion in tp1-based predictions
#### Some will need to be retrospective. Use PLE and YLE instances of "not in past year" to get starting point for ACEs (assumed prior to tp1 scan)
# so to reconstruct whether or not this happened before timepoint 1 scan, we will need _past_yr variables
ylePastYearcols=yleColnames[grep('_past_yr',yleColnames)]

# verify with descriptions
# yleColDescrip[grep('_past_yr',yleColnames)]
# remove _past_yr to get list of assayed youth life events
###yles=gsub('_past_yr','',ylePastYearcols)
# this approach does not work because columns are misnamed (idiosyncratic missing characters between past year vs. not past year versions)

# remove "past year?" from column names to boil down to binary variables of interest
yle_No_PastYearcols=yleColnames[-which(yleColnames %in% ylePastYearcols)]

# remove "was this a good or bad experience?", not really true retrospective
goodBad=yle_No_PastYearcols[grep('_fu_',yle_No_PastYearcols)]
yle_No_PastYearcols_No_Goodbad=yle_No_PastYearcols[-which(yle_No_PastYearcols %in% goodBad)]

# remove "how much did this event affect you" for now, not really true retrospective
EvAffect=yle_No_PastYearcols_No_Goodbad[grep('_fu2_',yle_No_PastYearcols_No_Goodbad)]
yle_No_PastYearcols_No_Goodbad_No_EvAff=yle_No_PastYearcols_No_Goodbad[-which(yle_No_PastYearcols_No_Goodbad %in% EvAffect)]
```

``` r
#### make outdf for cross-sectional analyses w/ bootstrapping

# extract just tp1 (really timepoint 1.5, 1-year in) for yle's
yle1=subset(yle,eventname=='1_year_follow_up_y_arm_1')

# need an exception for suicide follow ups (which appear to be blank) and collection ID
yle_No_PastYearcols_No_Goodbad_No_EvAff=yle_No_PastYearcols_No_Goodbad_No_EvAff[-c(43,44,46)]

# for iterative dataset construct
preBVdf=data.frame(as.factor(yle1$subjectkey))
colnames(preBVdf)<-'subjectkey'

# OK, now lets remove instances of these things happening in the past year
for (i in 10:length(yle_No_PastYearcols_No_Goodbad_No_EvAff)){
  # extract column name
  currColName=yle_No_PastYearcols_No_Goodbad_No_EvAff[i]
  # extract corresponding "was this in the past year?" boolean, which is always right after
  currColIndex=grep(currColName,yleColnames)
  # extract vector of values for PTs
  currCol=yle1[,currColIndex]
  # need an exception for le_friend_injur_past_yr_y. Appears to be misnamed without p in ple
  if  (currColName=='ple_friend_injur_y'){
    currColNamePastYear='le_friend_injur_past_yr_y'
  # also need except for ple_injur_past_yr_y, which is actually ple_injur_y_past_yr_y which is also probably a typo
  } else if (currColName=='ple_injur_y'){
    currColNamePastYear='ple_injur_y_past_yr_y'
  }  else {
    # return colname of past year using text in aim to be more robust
    currColNamePastYear=gsub('_y','_past_yr_y',currColName)
  }
  currColIndexPastYear=grep(currColNamePastYear,yleColnames)
  # This turned out to not be robust to heterogeneity in questionnaire
  ## "past year"? immediately proceeds question
  ## currColIndexPastYear=currColIndex+1
  ## extract this vector of values for PTs
  currCol_pastyr=yle1[,currColIndexPastYear]
  # set empties to 0 in follow up question
  currCol_pastyr[is.empty(currCol_pastyr)]=0
  # ple_injur_y and ple_injur_y_yr_y are misnamed, need to build catch specifically for these variables
  if (currColIndex[1]==42){
    # set to correct column
    currColIndex=42
    # re-draw currCol
    currCol=yle1[,currColIndex]
    # re-draw past year
    currColIndexPastYear=currColIndex+1
    # re-draw vector of values for PTs
    currCol_pastyr=yle1[,currColIndexPastYear]
    # set is empty to 0 in follow up question
    currCol_pastyr[is.empty(currCol_pastyr)]=0
    # extract "past year"?
    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
  } else {
    # if past year, subtract instance
    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
  }
  # print out utilized colum names to ensure they match
  print(paste('Variables:',yle[1,currColIndex],yle[1,currColIndexPastYear]))
  # explicitly count instances in past year
  PastYr=as.numeric(currCol)+as.numeric(currCol_pastyr)==2
  # make a plot dataframe for ggplot2
  plotdf=data.frame(as.numeric(yle1[,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]),NotPastYr,as.numeric(PastYr))
  colnames(plotdf)=c('Total','BeforeLastYear','DuringLastYear')
  plotdf<-invisible(melt(plotdf))
  a<-ggplot(plotdf, aes(x=value,fill=variable)) + geom_histogram(position="dodge")+theme_classic()+ggtitle(paste(yle[1,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]))
  print(a)
  # iteratively make a dataframe of yes/no (standard) for cross-sectional DF
  preBVdf$null<-as.numeric(yle1[,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]])
  colnamesMinusNull=head(colnames(preBVdf), -1)
  colnames(preBVdf)<-c(colnamesMinusNull,currColName)
}
```

    ## [1] "Variables: Someone in family died? Did this happen in the past year?"

    ## No id variables; using all as measure variables

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Family member was seriously injured? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Saw crime or accident? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Lost a close friend? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Close friend was seriously sick/injured? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-4.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Negative change in parent's financial situation? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-5.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 18 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Family member had drug and/or alcohol problem? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-6.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: You got seriously sick? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-7.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: You got seriously injured? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-8.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 24 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parents argued more than previously? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-9.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Mother/father figure lost job? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-10.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: One parent was away from home more often? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-11.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Someone in the family was arrested? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-12.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Close friend died? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-13.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Family member had mental/emotional problem? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-14.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Brother or sister left home? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-15.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Was a victim of crime/violence/assault? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-16.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parents separated or divorced? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-17.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parents/caregiver got into trouble with the law? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-18.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Attended a new school? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-19.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Family moved? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-20.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: One of the parents/caregivers went to jail? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-21.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Got new stepmother or stepfather? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-22.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parent/caregiver got a new job? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-23.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Got new brother or sister? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-24.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 21 rows containing non-finite values (stat_bin).

    ## [1] "Variables: You were placed in foster care? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-25.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Saw or heard someone getting hit Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-26.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Your family was homeless? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-27.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parent or caregiver hospitalized? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-28.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Had a lockdown at your school due to concerns about a school shooting or violence? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-29.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Please indicate how instrument was administered: Please indicate how instrument was administered:"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-30.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Saw or heard someone being shot at (but not actually wounded) in your school or neighborhood? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-31.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Do you know someone who has attempted suicide? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-32.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

    ## [1] "Variables: Parent or caregiver deported? Did this happen in the past year?"

    ## No id variables; using all as measure variables

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-33.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 33675 rows containing non-finite values (stat_bin).

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-34.png)<!-- -->

``` r
#### for year1 visit
# note NO answers recorded to ple_foster_care_past_yr_y. I guess we can't use that variable unless new release has it populated
# ditto, ple_hit_y
# ditto, ple_homeless_y
# ditto, ple_hospitalized_y
# ditto, ple_lockdown_y
# ditto, ple_shot_y
# ditto, ple_suicide_y

# ∆∆ now that these are events stemming from prior to the baseline visit, we can consider them as functionally BV (not for "since" variables, which can be interpreted in a different predictive context)
# ∆∆ BUT this only captures baseline ABCD visit. Now we need to merge two-year FUP life events with the rest of the two years for cross-sectional analyses
OutDFBV=subset(OutDF,eventname=='baseline_year_1_arm_1')
OutDF2Y=subset(OutDF,eventname=='2_year_follow_up_y_arm_1')
# we have one valid reconstruction from code above to merge into bv
OutDFBVyle=merge(OutDFBV,preBVdf,by=c('subjectkey'))
# and now we need to get the two year yles to merge in
yle2=subset(yle,eventname=='2_year_follow_up_y_arm_1')

#### extract same columns of interest - 2 YEAR
# for iterative dataset construct
Y2df=data.frame(as.factor(yle2$subjectkey))
colnames(Y2df)<-'subjectkey'
# OK, now lets extract timepoint 2 values for the same columns
for (i in 10:length(yle_No_PastYearcols_No_Goodbad_No_EvAff)){
  # extract column name
  currColName=yle_No_PastYearcols_No_Goodbad_No_EvAff[i]
  # get variable of interest and plop into loop Y2 dataframe
  Y2df$null<-as.numeric(yle2[,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]])
  colnamesMinusNull=head(colnames(Y2df), -1)
  colnames(Y2df)<-c(colnamesMinusNull,currColName)         
}  
# and now we can merge it in
OutDF2Yyle=merge(OutDF2Y,Y2df,by=c('subjectkey'))
# now we can recombine them
OutDFyle=rbind(OutDFBVyle,OutDF2Yyle)

# so if we use the events recorded that happened prior to the baseline visit, and those that are included at 2 year FUP how much missingness does that imbue?
print(paste0(dim(OutDF)[1]-dim(OutDFyle)[1],' lost from requiring those with yle at both timepoints with full data'))
```

    ## [1] "76 lost from requiring those with yle at both timepoints with full data"

``` r
# gauge consistency of responses across visits: happened at al in past should be reflected at tp 2 if it is at tp1
tmpdf=merge(OutDFBVyle,OutDF2Yyle,by='subjectkey')

# f'in ugh
ggplot(data=tmpdf,aes(x=ple_arrest_y.x,y=ple_arrest_y.y))+geom_point()+geom_jitter()+xlab('Has a family member ever been arrested? timepoint 1')+ylab('Has a family member ever been arrested? timepoint 2')
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](SampleConstruction_files/figure-gfm/unnamed-chunk-10-35.png)<!-- -->

``` r
# find subjects who report yle's at timepoint 1 but not 2
questionableSubjs=as.factor(NULL)
for (i in 10:34){
  # extract column name
  currColName=yle_No_PastYearcols_No_Goodbad_No_EvAff[i]
  currColNamex=paste0(currColName,'.x')
  currColNamey=paste0(currColName,'.y')
  # extract year 1
  y1<-tmpdf[,currColNamex]
  # extract year 2
  y2<-tmpdf[,currColNamey]
  # if x > y, either i don't understand this questionnaire or the kids don't
  questionableSubjs=tmpdf$subjectkey[y1>y2]
  # are these subjs who were interviewer by RA disprop?
  questionableSubjs=c(questionableSubjs,tmpdf$subjectkey[y1>y2])
}

# and if we exclude subjs with inconsistent timepoint-to-timepoint answers 
OutDFyle=OutDFyle[!OutDFyle$subjectkey %in% questionableSubjs,]
print(paste0(dim(OutDF)[1]-dim(OutDFyle)[1],' lost from requiring those with yle at both timepoints with full data, and kids who inconsistently report yles'))
```

    ## [1] "880 lost from requiring those with yle at both timepoints with full data, and kids who inconsistently report yles"

``` r
print(dim(OutDFyle))
```

    ## [1] 8416  797

``` r
##############
### LOAD IN PLE'S TOO SUCKAAAA SHRINK THAT SAMPLE SIZE
##############

# ple QC
#### LOAD in youth life events. Unfortunately this also appears to be missing for most participants, but is populated for slightly more than residential deprivation
ple=read.delim('~/Downloads/Package_1209596/abcd_ple01.txt')
pleColnames=colnames(ple)
pleColDescrip=ple[1,]
# note yle's are labeled ple's in the colnames, but end with a _y extension (ples end with _p extension)

##### Extract purely retrospective, i.e., viable for inclusion in tp1-based predictions
#### Some will need to be retrospective. Use PLE and YLE instances of "not in past year" to get starting point for ACEs (assumed prior to tp1 scan)
# so to reconstruct whether or not this happened before timepoint 1 scan, we will need _past_yr variables
plePastYearcols=pleColnames[grep('_past_yr',pleColnames)]

# remove "past year?" from column names to boil down to binary variables of interest
ple_No_PastYearcols=pleColnames[-which(pleColnames %in% plePastYearcols)]

# remove "was this a good or bad experience?", not really true retrospective
goodBad=ple_No_PastYearcols[grep('_fu_',ple_No_PastYearcols)]
ple_No_PastYearcols_No_Goodbad=ple_No_PastYearcols[-which(ple_No_PastYearcols %in% goodBad)]

# remove "how much did this event affect you" for now, not really true retrospective
EvAffect=ple_No_PastYearcols_No_Goodbad[grep('_fu2_',ple_No_PastYearcols_No_Goodbad)]
ple_No_PastYearcols_No_Goodbad_No_EvAff=ple_No_PastYearcols_No_Goodbad[-which(ple_No_PastYearcols_No_Goodbad %in% EvAffect)]

# remove remaining instances of undesireable columns (unpopulated, misnamed)
ple_No_PastYearcols_No_Goodbad_No_EvAff=ple_No_PastYearcols_No_Goodbad_No_EvAff[-c(13,21)]

# now loop through to look for inconsistency b/w timepoints
timepoint1PLE=subset(ple,eventname=='1_year_follow_up_y_arm_1')
timepoint2PLE=subset(ple,eventname=='2_year_follow_up_y_arm_1')
# make merged PLE
tmpdf=merge(timepoint1PLE,timepoint2PLE,by='subjectkey')
# and merged ple + yle for each timepoint to eval correspondence between parent/child
BVboth=merge(OutDFBVyle,timepoint1PLE,by='subjectkey')
```

    ## Warning in merge.data.frame(OutDFBVyle, timepoint1PLE, by = "subjectkey"):
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'interview_date.y',
    ## 'collection_title.y' are duplicated in the result

``` r
Y2both=merge(OutDF2Yyle,timepoint2PLE,by='subjectkey')
```

    ## Warning in merge.data.frame(OutDF2Yyle, timepoint2PLE, by = "subjectkey"):
    ## column names 'collection_id.x', 'dataset_id.x', 'interview_date.x',
    ## 'collection_title.x', 'collection_id.y', 'dataset_id.y', 'interview_date.y',
    ## 'collection_title.y' are duplicated in the result

``` r
# loop over to get another estimate of questionable reliability
ple_based_questionableSubjs=as.factor(NULL)
# starts with 11 instead of 10 because 10 is "select language" here
for (i in 11:34){
  # extract column name
  currColName=ple_No_PastYearcols_No_Goodbad_No_EvAff[i]
  currColNamex=paste0(currColName,'.x')
  currColNamey=paste0(currColName,'.y')
  # extract year 1
  y1<-as.numeric(tmpdf[,currColNamex])
  # extract year 2
  y2<-as.numeric(tmpdf[,currColNamey])
  # if x > y, either i don't understand this questionnaire or the kids don't
  ple_based_questionableSubjs=tmpdf$subjectkey[y1>y2]
  # are these subjs who were interviewer by RA disprop?
  ple_based_questionableSubjs=c(ple_based_questionableSubjs,tmpdf$subjectkey[y1>y2])
  # consistent subjs are those that aren't questionable
  goodsubjs=tmpdf$subjectkey[!tmpdf$subjectkey %in% ple_based_questionableSubjs]
  #### ∆∆∆ now see if they are discordant with their own child's answers
    # find corresponding column name in yle - in theory it's replacing the _p with _y but both dataframes have typos in column names
    currColName_y=gsub('.{1}$', 'y', currColName)
    # extract columns
    # extract year 1 - parent SR
    p_y1<-as.numeric(BVboth[,currColName])
    # youth
    y_y1<-as.numeric(BVboth[,currColName_y])
    # extract year 2 - parent SR
    p_y2<-as.numeric(Y2both[,currColName])
    # youth
    y_y2<-as.numeric(Y2both[,currColName_y])
    # discordant timepoint 1?
    Discordant_tp1=BVboth$subjectkey[p_y1!=y_y1]
    # discordant timepoint 2
    Discordant_tp2=Y2both$subjectkey[p_y2!=y_y2]
    Discordantsubjs=unique(c(Discordant_tp1,Discordant_tp2))
    ple_based_questionableSubjs=c(ple_based_questionableSubjs,Discordantsubjs)
}


# combine with questionable subjs on the basis of tp1 ysr and tp2 ysr not matching
questionableSubjs=unique(c(questionableSubjs,ple_based_questionableSubjs))


OutDFyle2=OutDFyle[!OutDFyle$subjectkey %in% questionableSubjs,]
print(paste0(dim(OutDFyle2)[1]-dim(OutDFyle2)[1],' lost from cross-referncing parent report of childs life events and removing inconsistents'))
```

    ## [1] "0 lost from cross-referncing parent report of childs life events and removing inconsistents"

``` r
print(dim(OutDFyle2))
```

    ## [1] 7342  797

``` r
# save ouput
saveRDS(OutDFyle2,'~/OutDfxc.rds')
```

``` r
##### make outdf FULL retrospective for temporal precedence analyses
## for iterative dataset construct
#preBVdf=data.frame(as.factor(yle1$subjectkey))
#colnames(preBVdf)<-'subjectkey'
#
## OK, now lets remove instances of these things happening in the past year
#for (i in 10:length(yle_No_PastYearcols_No_Goodbad_No_EvAff)){
#  # extract column name
#  currColName=yle_No_PastYearcols_No_Goodbad_No_EvAff[i]
#  # extract corresponding "was this in the past year?" boolean, which is always right after
#  currColIndex=grep(currColName,yleColnames)
#  # extract vector of values for PTs
#  currCol=yle1[,currColIndex]
#  # need an exception for le_friend_injur_past_yr_y. Appears to be misnamed without p in ple
#  if  (currColName=='ple_friend_injur_y'){
#    currColNamePastYear='le_friend_injur_past_yr_y'
#  # also need except for ple_injur_past_yr_y, which is actually ple_injur_y_past_yr_y which is also probably a typo
#  } else if (currColName=='ple_injur_y'){
#    currColNamePastYear='ple_injur_y_past_yr_y'
#  }  else {
#    # return colname of past year using text in aim to be more robust
#    currColNamePastYear=gsub('_y','_past_yr_y',currColName)
#  }
#  currColIndexPastYear=grep(currColNamePastYear,yleColnames)
#  # This turned out to not be robust to heterogeneity in questionnaire
#  ## "past year"? immediately proceeds question
#  ## currColIndexPastYear=currColIndex+1
#  ## extract this vector of values for PTs
#  currCol_pastyr=yle1[,currColIndexPastYear]
#  # set empties to 0 in follow up question
#  currCol_pastyr[is.empty(currCol_pastyr)]=0
#  # ple_injur_y and ple_injur_y_yr_y are misnamed, need to build catch specifically for these variables
#  if (currColIndex[1]==42){
#    # set to correct column
#    currColIndex=42
#    # re-draw currCol
#    currCol=yle1[,currColIndex]
#    # re-draw past year
#    currColIndexPastYear=currColIndex+1
#    # re-draw vector of values for PTs
#    currCol_pastyr=yle1[,currColIndexPastYear]
#    # set is empty to 0 in follow up question
#    currCol_pastyr[is.empty(currCol_pastyr)]=0
#    # extract "past year"?
#    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
#  } else {
#    # if past year, subtract instance
#    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
#  }
#  # print out utilized colum names to ensure they match
#  print(paste('Variables:',yle[1,currColIndex],yle[1,currColIndexPastYear]))
#  # explicitly count instances in past year
#  PastYr=as.numeric(currCol)+as.numeric(currCol_pastyr)==2
#  # make a plot dataframe for ggplot2
#  plotdf=data.frame(as.numeric(yle1[,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]),NotPastYr,as.numeric(PastYr))
#  colnames(plotdf)=c('Total','BeforeLastYear','DuringLastYear')
#  plotdf<-invisible(melt(plotdf))
#  a<-ggplot(plotdf, aes(x=value,fill=variable)) + geom_histogram(position="dodge")+theme_classic()+ggtitle(paste(yle[1,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]))
#  print(a)
#  # iteratively make a dataframe of yes/no (standard)
#  preBVdf$null<-NotPastYr
#  colnamesMinusNull=head(colnames(preBVdf), -1)
#  colnames(preBVdf)<-c(colnamesMinusNull,currColName)
#}
#
##### for year1 visit
## note NO answers recorded to ple_foster_care_past_yr_y. I guess we can't use that variable unless new release has it populated
## ditto, ple_hit_y
## ditto, ple_homeless_y
## ditto, ple_hospitalized_y
## ditto, ple_lockdown_y
## ditto, ple_shot_y
## ditto, ple_suicide_y
#
## now that these are events stemming from prior to the baseline visit, we can consider them as functionally BV (not for "since" variables, which can be interpreted in a diffferent predictive context)
## no event name gen. or merging for pure prediction DF, might need to go to ridgePrep
##preBVdf$eventname='baseline_year_1_arm_1'
#OutDFyle=merge(OutDF,preBVdf,by=c('subjectkey'))
#print(dim(OutDFyle))
#print(dim(OutDF))
#
## convert to one row per subj for temporal precedence analyses
#OutDFBV=subset(OutDFyle,eventname=='baseline_year_1_arm_1')
#OutDF2Y=subset(OutDFyle,eventname=='2_year_follow_up_y_arm_1')
#OutDFTmpPrec<-merge(OutDFyle,OutDF2Y,by='subjectkey')
#print(dim(OutDFTmpPrec))
#
#saveRDS(OutDFTmpPrec,'~/OutDFTmpPrec_FullRetro.rds')
```

``` r
#### make outdf retrospective PLUS for temporal precedence analyses (includes YLE's that happened before tp2 measurement. Sep. measure)
# for iterative dataset construct
#preBVdf=data.frame(as.factor(yle1$subjectkey))
#colnames(preBVdf)<-'subjectkey'
#
## OK, now lets remove instances of these things happening in the past year
#for (i in 10:length(yle_No_PastYearcols_No_Goodbad_No_EvAff)){
#  # extract column name
#  currColName=yle_No_PastYearcols_No_Goodbad_No_EvAff[i]
#  # make a "w/in past year" column 
#  currColName_winYear=paste0(currColName,'_past')
#  # extract corresponding "was this in the past year?" boolean, which is always right after
#  currColIndex=grep(currColName,yleColnames)
#  # extract vector of values for PTs
#  currCol=yle1[,currColIndex]
#  # need an exception for le_friend_injur_past_yr_y. Appears to be misnamed without p in ple
#  if  (currColName=='ple_friend_injur_y'){
#    currColNamePastYear='le_friend_injur_past_yr_y'
#  # also need except for ple_injur_past_yr_y, which is actually ple_injur_y_past_yr_y which is also probably a typo
#  } else if (currColName=='ple_injur_y'){
#    currColNamePastYear='ple_injur_y_past_yr_y'
#  }  else {
#    # return colname of past year using text in aim to be more robust
#    currColNamePastYear=gsub('_y','_past_yr_y',currColName)
#  }
#  currColIndexPastYear=grep(currColNamePastYear,yleColnames)
#  # This turned out to not be robust to heterogeneity in questionnaire
#  ## "past year"? immediately proceeds question
#  ## currColIndexPastYear=currColIndex+1
#  ## extract this vector of values for PTs
#  currCol_pastyr=yle1[,currColIndexPastYear]
#  # set empties to 0 in follow up question
#  currCol_pastyr[is.empty(currCol_pastyr)]=0
#  # ple_injur_y and ple_injur_y_yr_y are misnamed, need to build catch specifically for these variables
#  if (currColIndex[1]==42){
#    # set to correct column
#    currColIndex=42
#    # re-draw currCol
#    currCol=yle1[,currColIndex]
#    # re-draw past year
#    currColIndexPastYear=currColIndex+1
#    # re-draw vector of values for PTs
#    currCol_pastyr=yle1[,currColIndexPastYear]
#    # set is empty to 0 in follow up question
#    currCol_pastyr[is.empty(currCol_pastyr)]=0
#    # extract "past year"?
#    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
#  } else {
#    # if past year, subtract instance
#    NotPastYr=as.numeric(currCol)-as.numeric(currCol_pastyr)
#  }
#  # print out utilized colum names to ensure they match
#  print(paste('Variables:',yle[1,currColIndex],yle[1,currColIndexPastYear]))
#  # explicitly count instances in past year
#  PastYr=as.numeric(currCol)+as.numeric(currCol_pastyr)==2
#  # make a plot dataframe for ggplot2
#  plotdf=data.frame(as.numeric(yle1[,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]),NotPastYr,as.numeric(PastYr))
#  colnames(plotdf)=c('Total','BeforeLastYear','DuringLastYear')
#  plotdf<-invisible(melt(plotdf))
#  a<-ggplot(plotdf, aes(x=value,fill=variable)) + geom_histogram(position="dodge")+theme_classic()+ggtitle(paste(yle[1,yle_No_PastYearcols_No_Goodbad_No_EvAff[i]]))
#  print(a)
#  # iteratively make a dataframe of yes/no (standard) for cross-sectional DF
#  preBVdf$null<-as.numeric(PastYr)
#  colnamesMinusNull=head(colnames(preBVdf), -1)
#  colnames(preBVdf)<-c(colnamesMinusNull,currColName)
#}
#
##### for year1 visit
## note NO answers recorded to ple_foster_care_past_yr_y. I guess we can't use that variable unless new release has it populated
## ditto, ple_hit_y
## ditto, ple_homeless_y
## ditto, ple_hospitalized_y
## ditto, ple_lockdown_y
## ditto, ple_shot_y
## ditto, ple_suicide_y
#
## now that these are events stemming from prior to the baseline visit, we can consider them as functionally BV (not for "since" variables, which can be interpreted in a diffferent predictive context)
## no event name gen. or merging for pure prediction DF, might need to go to ridgePrep
##preBVdf$eventname='baseline_year_1_arm_1'
#OutDFyle=merge(OutDF,preBVdf,by=c('subjectkey'))
#print(dim(OutDFyle))
#print(dim(OutDF))
#
## convert to one row per subj for temporal precedence analyses
#OutDFBV=subset(OutDFyle,eventname=='baseline_year_1_arm_1')
#OutDF2Y=subset(OutDFyle,eventname=='2_year_follow_up_y_arm_1')
#OutDFTmpPrec<-merge(OutDFyle,OutDF2Y,by='subjectkey')
#print(dim(OutDFTmpPrec))
#
#saveRDS(OutDFTmpPrec,'~/OutDFTmpPrec_FullRetro.rds')
```