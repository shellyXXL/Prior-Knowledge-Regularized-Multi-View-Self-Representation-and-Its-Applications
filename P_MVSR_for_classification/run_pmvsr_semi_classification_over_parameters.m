%%%%%  "Prior Knowledge Regularized Multi-View Self-Representation and Its Applications"  published in TNNLS, 2020.
%%%%%   by xiaolin xiao,  shellyxiaolin@gmail.com
clear;
addpath(genpath('.'));

% s = RandStream('mt19937ar','Seed',3);   %%%%%fix the random generator over all competing algorithms to avoid the influence from randomness
% RandStream.setGlobalStream(s);

data='yale_xxl';
label_percent=[0.1];   %,0.2,0.3, ratio of labelled samples
%%%%%%%%%%% Traversing all parameters is time consuming. For different databases, we can corasely tune the parameters, and then test the performance over a small range. 
lamdba_arr=[0.0001, 0.001, 0.01, 0.05,  0.1:0.2:1.9];% 
thresh_arr=0:0.1:1;
semi_classification_function(label_percent, data,lamdba_arr, thresh_arr );


data='Caltech101-20_xxl';
label_percent=[0.1];   %,0.2,0.3, ratio of labelled samples
%%%%%%%%%%% Traversing all parameters is time consuming. For different databases, we can corasely tune the parameters, and then test the performance over a small range. 
lamdba_arr=[0.0001,0.0005, 0.001, 0.01];% 
thresh_arr=0:0.1:1;
semi_classification_function(label_percent, data,lamdba_arr, thresh_arr )



data='scene15_xxl';
label_percent=[0.1];   %,0.2,0.3, ratio of labelled samples
%%%%%%%%%%% Traversing all parameters is time consuming. For different databases, we can corasely tune the parameters, and then test the performance over a small range. 
lamdba_arr=[0.0001, 0.0005, 0.001, 0.01];% 
thresh_arr=0:0.1:1;
semi_classification_function(label_percent, data,lamdba_arr, thresh_arr )



