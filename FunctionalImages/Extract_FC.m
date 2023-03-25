function Extract_FC(subj)
% add path for cifti/gifti functions
addpath(genpath('/oak/stanford/groups/leanew1/users/apines/scripts/PersonalCircuits/scripts/code_nmf_cifti/tool_folder'));

% just spent about 10 hours trying to nancy-drew wb_documentation, and it looks like it's actually easier/more efficient to just take the mni->gifti metric files and manually index them in matlab rather than navigate/verify wb_labrynith 

% set rsfrmi fp
rsfp=['/scratch/users/apines/abcd_images/fmriresults01/derivatives/abcd-hcp-pipeline/' subj '/ses-baselineYear1Arm1/func/' subj '_ses-baselineYear1Arm1_task-rest_p2mm_masked.dtseries.nii'];
% set concatenated fmri fp
cfp=['/scratch/users/apines/abcd_images/fmriresults01/derivatives/abcd-hcp-pipeline/' subj '/ses-baselineYear1Arm1/func/' subj '_ses-baselineYear1Arm1_p2mm_masked_concat.dtseries.nii'];

% circuit ROI fps
% DMN
D1=['~/2021-masks/Medial_amPFC_DefaultModeNetwork_n2_50_n6.nii.gz.shape.gii'];
D2=['~/2021-masks/Left_AG_DefaultModeNetwork_n46_n70_32.nii.gz.shape.gii'];
D3=['~/2021-masks/Right_AG_DefaultModeNetwork_50_n62_26.nii.gz.shape.gii'];
D4=['~/2021-masks/Medial_PCC_DefaultModeNetwork_0_n50_28.nii.gz.shape.gii'];
% Salience
S1=['~/2021-masks/Left_antInsula_Salience_n38_14_n6.nii.gz.shape.gii'];
S2=['~/2021-masks/Right_antInsula_Salience_38_18_2.nii.gz.shape.gii'];
% use coarse Tian to extract amyg
% Attention
A1=['~/2021-masks/Medial_msPFC_Attention_n2_14_52.nii.gz.shape.gii'];
A2=['~/2021-masks/Left_lPFC_Attention_n44_6_32.nii.gz.shape.gii'];
A3=['~/2021-masks/Right_lPFC_Attention_50_10_28.nii.gz.shape.gii'];
A4=['~/2021-masks/Left_aIPL_Attention_n30_n54_40.nii.gz.shape.gii'];
A5=['~/2021-masks/Right_aIPL_Attention_38_n56_48.nii.gz.shape.gii'];
A6=['~/2021-masks/Left_precuneus_Attention_n14_n66_52.nii.gz.shape.gii'];
A7=['~/2021-masks/Right_precuneus_Attention_18_n68_52.nii.gz.shape.gii'];

% load in concatenated timne series
cts=read_cifti(cfp);
% load in single subject parcellation
sspFP=['/scratch/users/apines/abcd_images/derivatives/abcd-hcp-pipeline/' subj '/ses-baselineYear1Arm1/func/SingleParcel_1by1/k18/' subj '/IndividualParcel_Final_sbj1_comp18_alphaS21_1_alphaL2500_vxInfo1_ard0_eta0/final_UV.mat'];
ssp=load(sspFP);
% convert to hard parcellation
fV=[ssp.V{:}];
[~, HardParcel] = max(fV, [], 2);
% 0-indices
indices=sum(fV,2)==0;
% load in S1 Tian atlas
S1=read_cifti('~/Tian_Subcortex_S1_3T_32k.dscalar.nii')
% add subcort indices to network indices so we have 34 uniquely labeled ROIs
HardParcel=HardParcel+max(S1.cdata);
disp('Do not forget you added 16 to all network indices, Adam.') 
% 0-indices to 0-network assignment
HardParcel(indices)=0;
% combine this participants functional networks with subcortical parcellations
S1.cdata(1:59412)=HardParcel;
% temp test
%write_cifti(S1,'~/Tian_Subcortex_S1_3T_32k_wHP.dscalar.nii');

%%%% calculate FC

%% add parallel labels like you have previously 
% initialize output FC table/struct/vector
FCvec=[];
stringVec={};
% because each network is treated as an ROI, we are going to treat the subcortical labels the same way for a total of 18 cortical networks + 16 subcortical rois for a 34x34 fc matrix, and then remove the diagonal/one triangles
for N=1:34
	% get indices of this network
	NetInds=S1.cdata==N;
	% get time series
	NetworkTS=cts.cdata(NetInds,:);
	% loop over every other network
	for OtherNetNumber=1:N
		% get indices for this OtherNetwork
		ONetInds=S1.cdata==OtherNetNumber;
		% get time series matrix
		OtherNetworkTS=cts.cdata(ONetInds,:);
		% get correlation matrix
		GrayordCoors=corr(OtherNetworkTS',NetworkTS');
		% return average
		a=mean(mean(GrayordCoors));
		% delineate string 
		label=[num2str(N) '_' num2str(OtherNetNumber) '_FC'];
		% plug both in
		FCvec=[FCvec a];
		stringVec=[stringVec label];	
	end
end

% load in circuit ROIs, manually mask
% DMN
rD1=gifti(D1);
rD2=gifti(D2);
rD3=gifti(D3);
rD4=gifti(D4);
% Salience
rS1=gifti(S1);
rS2=gifti(S2);
% Attention
rA1=gifti(A1);
rA2=gifti(A2);
rA3=gifti(A3);
rA4=gifti(A4);
rA5=gifti(A5);
rA6=gifti(A6);
rA7=gifti(A7);
% extract cdata
rD1=rD1.cdata;
rD2=rD2.cdata;
rD3=rD3.cdata;
rD4=rD4.cdata;
rS1=rS1.cdata;
rS2=rS2.cdata;
rA1=rA1.cdata;
rA2=rA2.cdata;
rA3=rA3.cdata;
rA4=rA4.cdata;
rA5=rA5.cdata;
rA6=rA6.cdata;
rA7=rA7.cdata;

% extract indices where > 0 for ROI
rD1=rD1>0;
rD2=rD2>0;
rD3=rD3>0;
rD4=rD4>0;
rS1=rS1>0;
rS2=rS2>0;
rA1=rA1>0;
rA2=rA2>0;
rA3=rA3>0;
rA4=rA4>0;
rA5=rA5>0;
rA6=rA6>0;
rA7=rA7>0;
% now extract amygdalar indices for S3 and S4
rS3=S1.cdata==2;
rS4=S1.cdata==10;

% load in concatenated resting-state TS, overwrite variable name of all-data ts
cts=read_cifti(rsfp);
% DMN circuit score: sum of ROI edges (except 2-3) /5
D1D2=corr(cts.cdata(rD1,:)',cts.cdata(rD2,:)');
D1D3=corr(cts.cdata(rD1,:)',cts.cdata(rD3,:)');
D1D4=corr(cts.cdata(rD1,:)',cts.cdata(rD4,:)');
D2D4=corr(cts.cdata(rD2,:)',cts.cdata(rD4,:)');
D3D4=corr(cts.cdata(rD3,:)',cts.cdata(rD4,:)');
DMNscore=mean([D1D2 D1D3 D1D4 D2D4 D3D4]);
% Salience circuit score: negative sum of S1-S2, S1-S3, and S2-S4 edges /3
S1S2=corr(cts.cdata(rS1,:)',cts.cdata(rS2,:)');
S1S3=corr(cts.cdata(rS1,:)',cts.cdata(rS3,:)');
S2S4=corr(cts.cdata(rS2,:)',cts.cdata(rS4,:)');
%% CHECK/FIX LATER
SalienceScore=mean([S1S2 S1S3 S2S4]);
% Attention circuit score: negative sum of A1-A2, A1-A3, A2-A4, A3-A4, A4-A5, A4-A6, A4-A7 edges /7
A1A2=corr(cts.cdata(rA1,:)',cts.cdata(rA2,:)');
A1A3=corr(cts.cdata(rA1,:)',cts.cdata(rA3,:)');
A2A4=corr(cts.cdata(rA2,:)',cts.cdata(rA4,:)');
A3A5=corr(cts.cdata(rA3,:)',cts.cdata(rA5,:)');
A4A6=corr(cts.cdata(rA4,:)',cts.cdata(rA6,:)');
A5A7=corr(cts.cdata(rA5,:)',cts.cdata(rA7,:)');
Attentionscore=mean([A1A2 A1A3 A2A4 A3A5 A4A6 A5A7]);
% append those to fc and label vectors
FCvec=[FCvec DMNscore SalienceScore Attentionscore];
stringVec=[stringVec 'DMNscore' 'SalienceScore' 'Attentionscore'];
% save out as csv
T=table(FCvec','RowNames',stringVec);
% calc outFP
outFP=['/oak/stanford/groups/leanew1/users/apines/scripts/gp/data/FC_Feats/' subj];
% make out filepath
system(['mkdir ' outFP]);
% write out
writetable(T,[outFP '/FC_Feats.csv')
