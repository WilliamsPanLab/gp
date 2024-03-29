library(mgcv)
library(testit)

# load in data
masterdf=readRDS('/oak/stanford/groups/leanew1/users/apines/data/gp/OutDFTmpPrec_FullRetro.rds')

# need to save out reduction in sum of squares, reduction of sum of squares in held-out, deviance explained, AIC, and BIC for all models

# reduction in sum of squares for all models
sumSq_full=rep(0,10000)
sumSq_n_died=rep(0,10000)
sumSq_n_injured=rep(0,10000)
sumSq_n_crime=rep(0,10000)
sumSq_n_friend=rep(0,10000)
sumSq_n_friend_injur=rep(0,10000)
sumSq_n_arrest=rep(0,10000)
sumSq_n_friend_died=rep(0,10000)
sumSq_n_mh=rep(0,10000)
sumSq_n_sib=rep(0,10000)
sumSq_n_victim=rep(0,10000)
sumSq_n_separ=rep(0,10000)
sumSq_n_law=rep(0,10000)
sumSq_n_school=rep(0,10000)
sumSq_n_move=rep(0,10000)
sumSq_n_jail=rep(0,10000)
sumSq_n_step=rep(0,10000)
sumSq_n_new_job=rep(0,10000)
sumSq_n_new_sib=rep(0,10000)
sumSq_n_g=rep(0,10000)
sumSq_n_age=rep(0,10000)
sumSq_n_Grades=rep(0,10000)
sumSq_n_parentPcount=rep(0,10000)
sumSq_n_income=rep(0,10000)
sumSq_n_parental_education=rep(0,10000)
sumSq_n_sex=rep(0,10000)
sumSq_n_race_ethnicity=rep(0,10000)

# reduction in held-out sum of squares for all models
sumSq_heldout_full=rep(0,10000)
sumSq_heldout_n_died=rep(0,10000)
sumSq_heldout_n_injured=rep(0,10000)
sumSq_heldout_n_crime=rep(0,10000)
sumSq_heldout_n_friend=rep(0,10000)
sumSq_heldout_n_friend_injur=rep(0,10000)
sumSq_heldout_n_arrest=rep(0,10000)
sumSq_heldout_n_friend_died=rep(0,10000)
sumSq_heldout_n_mh=rep(0,10000)
sumSq_heldout_n_sib=rep(0,10000)
sumSq_heldout_n_victim=rep(0,10000)
sumSq_heldout_n_separ=rep(0,10000)
sumSq_heldout_n_law=rep(0,10000)
sumSq_heldout_n_school=rep(0,10000)
sumSq_heldout_n_move=rep(0,10000)
sumSq_heldout_n_jail=rep(0,10000)
sumSq_heldout_n_step=rep(0,10000)
sumSq_heldout_n_new_job=rep(0,10000)
sumSq_heldout_n_new_sib=rep(0,10000)
sumSq_heldout_n_g=rep(0,10000)
sumSq_heldout_n_age=rep(0,10000)
sumSq_heldout_n_Grades=rep(0,10000)
sumSq_heldout_n_parentPcount=rep(0,10000)
sumSq_heldout_n_income=rep(0,10000)
sumSq_heldout_n_parental_education=rep(0,10000)
sumSq_heldout_n_sex=rep(0,10000)
sumSq_heldout_n_race_ethnicity=rep(0,10000)

# AIC difference for all models
AIC_full=rep(0,10000)
AIC_n_died=rep(0,10000)
AIC_n_injured=rep(0,10000)
AIC_n_crime=rep(0,10000)
AIC_n_friend=rep(0,10000)
AIC_n_friend_injur=rep(0,10000)
AIC_n_arrest=rep(0,10000)
AIC_n_friend_died=rep(0,10000)
AIC_n_mh=rep(0,10000)
AIC_n_sib=rep(0,10000)
AIC_n_victim=rep(0,10000)
AIC_n_separ=rep(0,10000)
AIC_n_law=rep(0,10000)
AIC_n_school=rep(0,10000)
AIC_n_move=rep(0,10000)
AIC_n_jail=rep(0,10000)
AIC_n_step=rep(0,10000)
AIC_n_new_job=rep(0,10000)
AIC_n_new_sib=rep(0,10000)
AIC_n_g=rep(0,10000)
AIC_n_age=rep(0,10000)
AIC_n_Grades=rep(0,10000)
AIC_n_parentPcount=rep(0,10000)
AIC_n_income=rep(0,10000)
AIC_n_parental_education=rep(0,10000)
AIC_n_sex=rep(0,10000)
AIC_n_race_ethnicity=rep(0,10000)

# need to save out BIC difference
BIC_full=rep(0,10000)
BIC_n_died=rep(0,10000)
BIC_n_injured=rep(0,10000)
BIC_n_crime=rep(0,10000)
BIC_n_friend=rep(0,10000)
BIC_n_friend_injur=rep(0,10000)
BIC_n_arrest=rep(0,10000)
BIC_n_friend_died=rep(0,10000)
BIC_n_mh=rep(0,10000)
BIC_n_sib=rep(0,10000)
BIC_n_victim=rep(0,10000)
BIC_n_separ=rep(0,10000)
BIC_n_law=rep(0,10000)
BIC_n_school=rep(0,10000)
BIC_n_move=rep(0,10000)
BIC_n_jail=rep(0,10000)
BIC_n_step=rep(0,10000)
BIC_n_new_job=rep(0,10000)
BIC_n_new_sib=rep(0,10000)
BIC_n_g=rep(0,10000)
BIC_n_age=rep(0,10000)
BIC_n_Grades=rep(0,10000)
BIC_n_parentPcount=rep(0,10000)
BIC_n_income=rep(0,10000)
BIC_n_parental_education=rep(0,10000)
BIC_n_sex=rep(0,10000)
BIC_n_race_ethnicity=rep(0,10000)

# dev explained for all models
devExplained_full=rep(0,10000)
devExplained_n_died=rep(0,10000)
devExplained_n_injured=rep(0,10000)
devExplained_n_crime=rep(0,10000)
devExplained_n_friend=rep(0,10000)
devExplained_n_friend_injur=rep(0,10000)
devExplained_n_arrest=rep(0,10000)
devExplained_n_friend_died=rep(0,10000)
devExplained_n_mh=rep(0,10000)
devExplained_n_sib=rep(0,10000)
devExplained_n_victim=rep(0,10000)
devExplained_n_separ=rep(0,10000)
devExplained_n_law=rep(0,10000)
devExplained_n_school=rep(0,10000)
devExplained_n_move=rep(0,10000)
devExplained_n_jail=rep(0,10000)
devExplained_n_step=rep(0,10000)
devExplained_n_new_job=rep(0,10000)
devExplained_n_new_sib=rep(0,10000)
devExplained_n_g=rep(0,10000)
devExplained_n_age=rep(0,10000)
devExplained_n_Grades=rep(0,10000)
devExplained_n_parentPcount=rep(0,10000)
devExplained_n_income=rep(0,10000)
devExplained_n_parental_education=rep(0,10000)
devExplained_n_sex=rep(0,10000)
devExplained_n_race_ethnicity=rep(0,10000)


# garner num subjs for bootstrapping
subjs=unique(masterdf$subjectkey)
numSubjs=length(subjs)
# cut df to just variables of interest to speed stuff up
masterdf=masterdf[,c('cbcl_scr_syn_internal_r.y','cbcl_scr_syn_internal_r.x','ple_died_y.x','ple_injured_y.x','ple_crime_y.x','ple_friend_y.x','ple_friend_injur_y.x','ple_arrest_y.x','ple_friend_died_y.x','ple_mh_y.x','ple_sib_y.x','ple_victim_y.x','ple_separ_y.x','ple_law_y.x','ple_school_y.x','ple_move_y.x','ple_jail_y.x','ple_step_y.x','ple_new_job_y.x','ple_new_sib_y.x','g.x','subjectkey','age.x','Grades.x','parentPcount.x','income.x','parental_education.x','sex.x','race_ethnicity.x')]
# set seed because I'll have to rerun this differently for second 5k
set.seed(1)
# loop over manual bootstrap
for (b in 1:5000){
	print(b)
	# get subjects to include in this bootstrap
	BootSubjs=sample(subjs,numSubjs,replace=T)
	### inefficient but interpretable loop
	# Create an empty dataframe to store the resampled observations
	resampled_df <- data.frame()
	for (j in 1:length(BootSubjs)){
		subject_obs <- masterdf[masterdf$subjectkey == BootSubjs[j], ]
		resampled_df <- rbind(resampled_df, subject_obs)
	}
	# bootstrap sample
	bootSamp=resampled_df
	# held out sample
	heldOut=masterdf[!(masterdf$subjectkey %in% BootSubjs),]
	# fit models
	### full
	fullModel<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predictFull=predict.bam(fullModel,bootSamp)
	sumSq_full[b]=sum((predictFull-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predictFullHeldOut=predict.bam(fullModel,heldOut)
	sumSq_heldout_full[b]=sum((predictFullHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_full[b]=AIC(fullModel)
	# get BIC
	BIC_full[b]=BIC(fullModel)
	# get deviance explained
	devExplained_full[b]=summary(fullModel)$dev.expl

	### died
	Model_n_died<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_died=predict.bam(Model_n_died,bootSamp)
	sumSq_n_died[b]=sum((predict_n_died-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_diedHeldOut=predict.bam(Model_n_died,heldOut)
	sumSq_heldout_n_died[b]=sum((predict_n_diedHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_died[b]=AIC(Model_n_died)
	# get BIC
	BIC_n_died[b]=BIC(Model_n_died)
	# get deviance explained
	devExplained_n_died[b]=summary(Model_n_died)$dev.expl

	### injured
	Model_n_injured<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_injured=predict.bam(Model_n_injured,bootSamp)
	sumSq_n_injured[b]=sum((predict_n_injured-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_injuredHeldOut=predict.bam(Model_n_injured,heldOut)
	sumSq_heldout_n_injured[b]=sum((predict_n_injuredHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_injured[b]=AIC(Model_n_injured)
	# get BIC
	BIC_n_injured[b]=BIC(Model_n_injured)
	# get deviance explained
	devExplained_n_injured[b]=summary(Model_n_injured)$dev.expl

	### crime
	Model_n_crime<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_crime=predict.bam(Model_n_crime,bootSamp)
	sumSq_n_crime[b]=sum((predict_n_crime-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_crimeHeldOut=predict.bam(Model_n_crime,heldOut)
	sumSq_heldout_n_crime[b]=sum((predict_n_crimeHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_crime[b]=AIC(Model_n_crime)
	# get BIC
	BIC_n_crime[b]=BIC(Model_n_crime)
	# get deviance explained
	devExplained_n_crime[b]=summary(Model_n_crime)$dev.expl

	### friend
	Model_n_friend<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_friend=predict.bam(Model_n_friend,bootSamp)
	sumSq_n_friend[b]=sum((predict_n_friend-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_friendHeldOut=predict.bam(Model_n_friend,heldOut)
	sumSq_heldout_n_friend[b]=sum((predict_n_friendHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_friend[b]=AIC(Model_n_friend)
	# get BIC
	BIC_n_friend[b]=BIC(Model_n_friend)
	# get deviance explained
	devExplained_n_friend[b]=summary(Model_n_friend)$dev.expl

	### friend_injured
	Model_n_friend_injured<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_friend_injured=predict.bam(Model_n_friend_injured,bootSamp)
	sumSq_n_friend_injur[b]=sum((predict_n_friend_injured-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_friend_injuredHeldOut=predict.bam(Model_n_friend_injured,heldOut)
	sumSq_heldout_n_friend_injur[b]=sum((predict_n_friend_injuredHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_friend_injur[b]=AIC(Model_n_friend_injured)
	# get BIC
	BIC_n_friend_injur[b]=BIC(Model_n_friend_injured)
	# get deviance explained
	devExplained_n_friend_injur[b]=summary(Model_n_friend_injured)$dev.expl

	### arrest
	Model_n_arrest<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_arrest=predict.bam(Model_n_arrest,bootSamp)
	sumSq_n_arrest[b]=sum((predict_n_arrest-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_arrestHeldOut=predict.bam(Model_n_arrest,heldOut)
	sumSq_heldout_n_arrest[b]=sum((predict_n_arrestHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_arrest[b]=AIC(Model_n_arrest)
	# get BIC
	BIC_n_arrest[b]=BIC(Model_n_arrest)
	# get deviance explained
	devExplained_n_arrest[b]=summary(Model_n_arrest)$dev.expl

	### friend_died
	Model_n_friend_died<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_friend_died=predict.bam(Model_n_friend_died,bootSamp)
	sumSq_n_friend_died[b]=sum((predict_n_friend_died-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_friend_diedHeldOut=predict.bam(Model_n_friend_died,heldOut)
	sumSq_heldout_n_friend_died[b]=sum((predict_n_friend_diedHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_friend_died[b]=AIC(Model_n_friend_died)
	# get BIC
	BIC_n_friend_died[b]=BIC(Model_n_friend_died)
	# get deviance explained
	devExplained_n_friend_died[b]=summary(Model_n_friend_died)$dev.expl

	### mental_health
	Model_n_mh<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_mh=predict.bam(Model_n_mh,bootSamp)
	sumSq_n_mh[b]=sum((predict_n_mh-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_mhHeldOut=predict.bam(Model_n_mh,heldOut)
	sumSq_heldout_n_mh[b]=sum((predict_n_mhHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_mh[b]=AIC(Model_n_mh)
	# get BIC
	BIC_n_mh[b]=BIC(Model_n_mh)
	# get deviance explained
	devExplained_n_mh[b]=summary(Model_n_mh)$dev.expl
	
	### sibling
	Model_n_sib<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_sib=predict.bam(Model_n_sib,bootSamp)
	sumSq_n_sib[b]=sum((predict_n_sib-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_sibHeldOut=predict.bam(Model_n_sib,heldOut)
	sumSq_heldout_n_sib[b]=sum((predict_n_sibHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_sib[b]=AIC(Model_n_sib)
	# get BIC
	BIC_n_sib[b]=BIC(Model_n_sib)
	# get deviance explained
	devExplained_n_sib[b]=summary(Model_n_sib)$dev.expl

	### victim
	Model_n_victim<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_victim=predict.bam(Model_n_victim,bootSamp)
	sumSq_n_victim[b]=sum((predict_n_victim-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_victimHeldOut=predict.bam(Model_n_victim,heldOut)
	sumSq_heldout_n_victim[b]=sum((predict_n_victimHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_victim[b]=AIC(Model_n_victim)
	# get BIC
	BIC_n_victim[b]=BIC(Model_n_victim)
	# get deviance explained
	devExplained_n_victim[b]=summary(Model_n_victim)$dev.expl

	### separation
	Model_n_separ<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_separ=predict.bam(Model_n_separ,bootSamp)
	sumSq_n_separ[b]=sum((predict_n_separ-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_separHeldOut=predict.bam(Model_n_separ,heldOut)
	sumSq_heldout_n_separ[b]=sum((predict_n_separHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_separ[b]=AIC(Model_n_separ)
	# get BIC
	BIC_n_separ[b]=BIC(Model_n_separ)
	# get deviance explained
	devExplained_n_separ[b]=summary(Model_n_separ)$dev.expl

	### law
	Model_n_law<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_law=predict.bam(Model_n_law,bootSamp)
	sumSq_n_law[b]=sum((predict_n_law-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_lawHeldOut=predict.bam(Model_n_law,heldOut)
	sumSq_heldout_n_law[b]=sum((predict_n_lawHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_law[b]=AIC(Model_n_law)
	# get BIC
	BIC_n_law[b]=BIC(Model_n_law)
	# get deviance explained
	devExplained_n_law[b]=summary(Model_n_law)$dev.expl

	### school
	Model_n_school<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_school=predict.bam(Model_n_school,bootSamp)
	sumSq_n_school[b]=sum((predict_n_school-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_schoolHeldOut=predict.bam(Model_n_school,heldOut)
	sumSq_heldout_n_school[b]=sum((predict_n_schoolHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_school[b]=AIC(Model_n_school)
	# get BIC
	BIC_n_school[b]=BIC(Model_n_school)
	# get deviance explained
	devExplained_n_school[b]=summary(Model_n_school)$dev.expl

	### move
	Model_n_move<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_move=predict.bam(Model_n_move,bootSamp)
	sumSq_n_move[b]=sum((predict_n_move-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_moveHeldOut=predict.bam(Model_n_move,heldOut)
	sumSq_heldout_n_move[b]=sum((predict_n_moveHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_move[b]=AIC(Model_n_move)
	# get BIC
	BIC_n_move[b]=BIC(Model_n_move)
	# get deviance explained
	devExplained_n_move[b]=summary(Model_n_move)$dev.expl

	### jail
	Model_n_jail<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_jail=predict.bam(Model_n_jail,bootSamp)
	sumSq_n_jail[b]=sum((predict_n_jail-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_jailHeldOut=predict.bam(Model_n_jail,heldOut)
	sumSq_heldout_n_jail[b]=sum((predict_n_jailHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_jail[b]=AIC(Model_n_jail)
	# get BIC
	BIC_n_jail[b]=BIC(Model_n_jail)
	# get deviance explained
	devExplained_n_jail[b]=summary(Model_n_jail)$dev.expl

	### step
	Model_n_step<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_step=predict.bam(Model_n_step,bootSamp)
	sumSq_n_step[b]=sum((predict_n_step-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_stepHeldOut=predict.bam(Model_n_step,heldOut)
	sumSq_heldout_n_step[b]=sum((predict_n_stepHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_step[b]=AIC(Model_n_step)
	# get BIC
	BIC_n_step[b]=BIC(Model_n_step)
	# get deviance explained
	devExplained_n_step[b]=summary(Model_n_step)$dev.expl

	### new job
	Model_n_job<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_job=predict.bam(Model_n_job,bootSamp)
	sumSq_n_new_job[b]=sum((predict_n_job-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_jobHeldOut=predict.bam(Model_n_job,heldOut)
	sumSq_heldout_n_new_job[b]=sum((predict_n_jobHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_new_job[b]=AIC(Model_n_job)
	# get BIC
	BIC_n_new_job[b]=BIC(Model_n_job)
	# get deviance explained
	devExplained_n_new_job[b]=summary(Model_n_job)$dev.expl

	### new sib
	Model_n_new_sib<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_new_sib=predict.bam(Model_n_new_sib,bootSamp)
	sumSq_n_new_sib[b]=sum((predict_n_new_sib-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_new_sibHeldOut=predict.bam(Model_n_new_sib,heldOut)
	sumSq_heldout_n_new_sib[b]=sum((predict_n_new_sibHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_new_sib[b]=AIC(Model_n_new_sib)
	# get BIC
	BIC_n_new_sib[b]=BIC(Model_n_new_sib)
	# get deviance explained
	devExplained_n_new_sib[b]=summary(Model_n_new_sib)$dev.expl

	### g
	Model_n_g<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_g=predict.bam(Model_n_g,bootSamp)
	sumSq_n_g[b]=sum((predict_n_g-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_gHeldOut=predict.bam(Model_n_g,heldOut)
	sumSq_heldout_n_g[b]=sum((predict_n_gHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_g[b]=AIC(Model_n_g)
	# get BIC
	BIC_n_g[b]=BIC(Model_n_g)
	# get deviance explained
	devExplained_n_g[b]=summary(Model_n_g)$dev.expl

	### age
	Model_n_age<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_age=predict.bam(Model_n_age,bootSamp)
	sumSq_n_age[b]=sum((predict_n_age-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_ageHeldOut=predict.bam(Model_n_age,heldOut)
	sumSq_heldout_n_age[b]=sum((predict_n_ageHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_age[b]=AIC(Model_n_age)
	# get BIC
	BIC_n_age[b]=BIC(Model_n_age)
	# get deviance explained
	devExplained_n_age[b]=summary(Model_n_age)$dev.expl

	### grades
	Model_n_grades<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_grades=predict.bam(Model_n_grades,bootSamp)
	sumSq_n_Grades[b]=sum((predict_n_grades-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_gradesHeldOut=predict.bam(Model_n_grades,heldOut)
	sumSq_heldout_n_Grades[b]=sum((predict_n_gradesHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_Grades[b]=AIC(Model_n_grades)
	# get BIC
	BIC_n_Grades[b]=BIC(Model_n_grades)
	# get deviance explained
	devExplained_n_Grades[b]=summary(Model_n_grades)$dev.expl

	### parentPcount
	Model_n_parentPcount<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_parentPcount=predict.bam(Model_n_parentPcount,bootSamp)
	sumSq_n_parentPcount[b]=sum((predict_n_parentPcount-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_parentPcountHeldOut=predict.bam(Model_n_parentPcount,heldOut)
	sumSq_heldout_n_parentPcount[b]=sum((predict_n_parentPcountHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_parentPcount[b]=AIC(Model_n_parentPcount)
	# get BIC
	BIC_n_parentPcount[b]=BIC(Model_n_parentPcount)
	# get deviance explained
	devExplained_n_parentPcount[b]=summary(Model_n_parentPcount)$dev.expl

	### income
	Model_n_income<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(parental_education.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_income=predict.bam(Model_n_income,bootSamp)
	sumSq_n_income[b]=sum((predict_n_income-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_incomeHeldOut=predict.bam(Model_n_income,heldOut)
	sumSq_heldout_n_income[b]=sum((predict_n_incomeHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_income[b]=AIC(Model_n_income)
	# get BIC
	BIC_n_income[b]=BIC(Model_n_income)
	# get deviance explained
	devExplained_n_income[b]=summary(Model_n_income)$dev.expl

	### parental education
	Model_n_parental_education<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+sex.x+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_parental_education=predict.bam(Model_n_parental_education,bootSamp)
	sumSq_n_parental_education[b]=sum((predict_n_parental_education-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_parental_educationHeldOut=predict.bam(Model_n_parental_education,heldOut)
	sumSq_heldout_n_parental_education[b]=sum((predict_n_parental_educationHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_parental_education[b]=AIC(Model_n_parental_education)
	# get BIC
	BIC_n_parental_education[b]=BIC(Model_n_parental_education)
	# get deviance explained
	devExplained_n_parental_education[b]=summary(Model_n_parental_education)$dev.expl

	### sex
	Model_n_sex<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+race_ethnicity.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_sex=predict.bam(Model_n_sex,bootSamp)
	sumSq_n_sex[b]=sum((predict_n_sex-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_sexHeldOut=predict.bam(Model_n_sex,heldOut)
	sumSq_heldout_n_sex[b]=sum((predict_n_sexHeldOut-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_sex[b]=AIC(Model_n_sex)
	# get BIC
	BIC_n_sex[b]=BIC(Model_n_sex)
	# get deviance explained
	devExplained_n_sex[b]=summary(Model_n_sex)$dev.expl

	### race
	Model_n_race_ethnicity<-bam(cbcl_scr_syn_internal_r.y~cbcl_scr_syn_internal_r.x+ple_died_y.x+ple_injured_y.x+ple_crime_y.x+ple_friend_y.x+ple_friend_injur_y.x+ple_arrest_y.x+ple_friend_died_y.x+ple_mh_y.x+ple_sib_y.x+ple_victim_y.x+ple_separ_y.x+ple_law_y.x+ple_school_y.x+ple_move_y.x+ple_jail_y.x+ple_step_y.x+ple_new_job_y.x+ple_new_sib_y.x+s(g.x,k=4)+s(age.x,k=4)+s(Grades.x,k=4)+s(parentPcount.x,k=4)+s(income.x,k=4)+s(parental_education.x,k=4)+sex.x,data=bootSamp,family=nb())
	# predict to get sum of squares
	predict_n_race_ethnicity<-predict.bam(Model_n_race_ethnicity,bootSamp)
	sumSq_n_race_ethnicity[b]<-sum((predict_n_race_ethnicity-bootSamp$cbcl_scr_syn_internal_r.y)^2)
	# predict held out to get sum of squares on held out
	predict_n_race_ethnicityHeldout=predict.bam(Model_n_race_ethnicity,heldOut)
	sumSq_heldout_n_race_ethnicity[b]<-sum((predict_n_race_ethnicityHeldout-heldOut$cbcl_scr_syn_internal_r.y)^2)
	# get AIC
	AIC_n_race_ethnicity[b]=AIC(Model_n_race_ethnicity)
	# get BIC
	BIC_n_race_ethnicity[b]=BIC(Model_n_race_ethnicity)
	# get deviance explained
	devExplained_n_race_ethnicity[b]=summary(Model_n_race_ethnicity)$dev.expl

	### verify same number of terms in each model (except first because it is full/+1)
	assert((length(fullModel$var.summary)-1)==length(Model_n_died$var.summary))
	assert(length(Model_n_died$var.summary)==length(Model_n_injured$var.summary))
	assert(length(Model_n_injured$var.summary)==length(Model_n_crime$var.summary))
	assert(length(Model_n_crime$var.summary)==length(Model_n_friend$var.summary))
	assert(length(Model_n_friend$var.summary)==length(Model_n_friend_injured$var.summary))
	assert(length(Model_n_friend_injured$var.summary)==length(Model_n_arrest$var.summary))
	assert(length(Model_n_arrest$var.summary)==length(Model_n_friend_died$var.summary))
	assert(length(Model_n_friend_died$var.summary)==length(Model_n_mh$var.summary))
	assert(length(Model_n_mh$var.summary)==length(Model_n_sib$var.summary))
	assert(length(Model_n_sib$var.summary)==length(Model_n_victim$var.summary))
	assert(length(Model_n_victim$var.summary)==length(Model_n_separ$var.summary))
	assert(length(Model_n_separ$var.summary)==length(Model_n_law$var.summary))
	assert(length(Model_n_law$var.summary)==length(Model_n_school$var.summary))
	assert(length(Model_n_school$var.summary)==length(Model_n_move$var.summary))
	assert(length(Model_n_move$var.summary)==length(Model_n_jail$var.summary))
	assert(length(Model_n_jail$var.summary)==length(Model_n_step$var.summary))
	assert(length(Model_n_step$var.summary)==length(Model_n_job$var.summary))
	assert(length(Model_n_job$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_new_sib$var.summary)==length(Model_n_parental_education$var.summary))
	assert(length(Model_n_g$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_age$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_grades$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_parentPcount$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_income$var.summary)==length(Model_n_new_sib$var.summary))
	assert(length(Model_n_parental_education$var.summary)==length(Model_n_sex$var.summary))
	assert(length(Model_n_sex$var.summary)==length(Model_n_race_ethnicity$var.summary))
}
# saveout df of sumSq for plotting
outdf=data.frame(sumSq_full,sumSq_n_died,sumSq_n_injured,sumSq_n_crime,sumSq_n_friend,sumSq_n_friend_injur,sumSq_n_arrest,sumSq_n_friend_died,sumSq_n_mh,sumSq_n_sib,sumSq_n_victim,sumSq_n_separ,sumSq_n_law,sumSq_n_school,sumSq_n_move,sumSq_n_jail,sumSq_n_step,sumSq_n_new_job,sumSq_n_new_sib,sumSq_n_g,sumSq_n_age,sumSq_n_Grades,sumSq_n_parentPcount,sumSq_n_income,sumSq_n_parental_education,sumSq_n_sex,sumSq_n_race_ethnicity)
saveRDS(outdf,'/oak/stanford/groups/leanew1/users/apines/data/gp/TmpPrec_Int_sumSq.rds')
#  saveout df of held-out sumSq for plotting
outdf=data.frame(sumSq_heldout_full,sumSq_heldout_n_died,sumSq_heldout_n_injured,sumSq_heldout_n_crime,sumSq_heldout_n_friend,sumSq_heldout_n_friend_injur,sumSq_heldout_n_arrest,sumSq_heldout_n_friend_died,sumSq_heldout_n_mh,sumSq_heldout_n_sib,sumSq_heldout_n_victim,sumSq_heldout_n_separ,sumSq_heldout_n_law,sumSq_heldout_n_school,sumSq_heldout_n_move,sumSq_heldout_n_jail,sumSq_heldout_n_step,sumSq_heldout_n_new_job,sumSq_heldout_n_new_sib,sumSq_heldout_n_g,sumSq_heldout_n_age,sumSq_heldout_n_Grades,sumSq_heldout_n_parentPcount,sumSq_heldout_n_income,sumSq_heldout_n_parental_education,sumSq_heldout_n_sex,sumSq_heldout_n_race_ethnicity)
saveRDS(outdf,'/oak/stanford/groups/leanew1/users/apines/data/gp/TmpPrec_Int_sumSqHeldout.rds')
# saveout df of dev explained for plotting
outdf=data.frame(devExplained_full,devExplained_n_died,devExplained_n_injured,devExplained_n_crime,devExplained_n_friend,devExplained_n_friend_injur,devExplained_n_arrest,devExplained_n_friend_died,devExplained_n_mh,devExplained_n_sib,devExplained_n_victim,devExplained_n_separ,devExplained_n_law,devExplained_n_school,devExplained_n_move,devExplained_n_jail,devExplained_n_step,devExplained_n_new_job,devExplained_n_new_sib,devExplained_n_g,devExplained_n_age,devExplained_n_Grades,devExplained_n_parentPcount,devExplained_n_income,devExplained_n_parental_education,devExplained_n_sex,devExplained_n_race_ethnicity)
saveRDS(outdf,'/oak/stanford/groups/leanew1/users/apines/data/gp/TmpPrec_Int_DevExplained.rds')
# saveout AIC for plotting
outdf=data.frame(AIC_full,AIC_n_died,AIC_n_injured,AIC_n_crime,AIC_n_friend,AIC_n_friend_injur,AIC_n_arrest,AIC_n_friend_died,AIC_n_mh,AIC_n_sib,AIC_n_victim,AIC_n_separ,AIC_n_law,AIC_n_school,AIC_n_move,AIC_n_jail,AIC_n_step,AIC_n_new_job,AIC_n_new_sib,AIC_n_g,AIC_n_age,AIC_n_Grades,AIC_n_parentPcount,AIC_n_income,AIC_n_parental_education,AIC_n_sex,AIC_n_race_ethnicity)
saveRDS(outdf,'/oak/stanford/groups/leanew1/users/apines/data/gp/TmpPrec_Int_AIC.rds')
# saveout BIC for plotting
outdf=data.frame(BIC_full,BIC_n_died,BIC_n_injured,BIC_n_crime,BIC_n_friend,BIC_n_friend_injur,BIC_n_arrest,BIC_n_friend_died,BIC_n_mh,BIC_n_sib,BIC_n_victim,BIC_n_separ,BIC_n_law,BIC_n_school,BIC_n_move,BIC_n_jail,BIC_n_step,BIC_n_new_job,BIC_n_new_sib,BIC_n_g,BIC_n_age,BIC_n_Grades,BIC_n_parentPcount,BIC_n_income,BIC_n_parental_education,BIC_n_sex,BIC_n_race_ethnicity)
saveRDS(outdf,'/oak/stanford/groups/leanew1/users/apines/data/gp/TmpPrec_Int_BIC.rds')
