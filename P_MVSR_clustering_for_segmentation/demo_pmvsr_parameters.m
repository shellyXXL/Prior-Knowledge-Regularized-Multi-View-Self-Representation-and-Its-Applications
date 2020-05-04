%%%%%  "Prior Knowledge Regularized Multi-View Self-Representation and Its Applications"  published in TNNLS, 2020.
%%%%%   by xiaolin xiao,  shellyxiaolin@gmail.com
%%%%% Note 1. the extracted features using Fh segmentation is provided in the "superpixel_related_functions" folder.  (only four image examples from BSDS500)
%%%%%      2. if more examples are needed, please use the functions in the  "superpixel_related_functions" folder. (related to superpixels and their features)
%%%%%      3. the segmentation results (label matrices) with 2-40 segments are saved in results_labels. 

clc,clear
addpath(genpath('.'));

data_name='fh3';  %%%%%%%%%%%%%%%% FH superpixels, can also use SLIC superpixels
lambda_arr=0.1;   %%%%%%%%%%%%%%%% parameter lambda in Eq.5
features=3;    %%%%%%%%% three kinds of features, RGBhist, LBPhist, HoG
layers=[4];   %%%%%%%%%%%%% number of linked layers, better than 3 
thresh=[0.2];  %%%%%%%%%%%%% 0~1 with step 0.1
prior='adj';   %%%%%%%%%%%%%% or spa, corresponding to different priors
pmvsr_parameters_function(data_name,lambda_arr, features,layers,thresh,prior);


    
    