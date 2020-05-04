function [Ctr, wCtr,Ctr_distribution,wCtr_distribution ]= CalWeightedContrast(colDistM, posDistM, bgProb,pixelList,distribution)
% Calculate background probability weighted contrast

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

spaSigma = 0.4;     %sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);

%bgProb weighted contrast

% %%% temp
% pixelN=zeros(length(pixelList),1);
% for i=1:length(pixelList)
%   pixelN(i,1)=length(pixelList{i});
% end
% pixels=sum(pixelN)/length(pixelList);
% pixelN=pixelN./pixels;
%%%%end temp
% Ctr = colDistM .* posWeight * pixelN;
% wCtr = colDistM .* posWeight * pixelN.* bgProb;
Ctr = colDistM .* posWeight * ones(length(colDistM),1);
wCtr = colDistM .* posWeight * bgProb;
% k=6;
% wCtr = colDistM .* posWeight * exp(- bgProb * k);
wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

Ctr_distribution=colDistM .* posWeight * (distribution);
Ctr_distribution = (Ctr_distribution - min(Ctr_distribution)) / (max(Ctr_distribution) - min(Ctr_distribution) + eps);

% temp=[bgProb,distribution];
% temp=min(temp,[],2);
wCtr_distribution=colDistM .* posWeight * (bgProb.*distribution);
wCtr_distribution = (wCtr_distribution - min(wCtr_distribution)) / (max(wCtr_distribution) - min(wCtr_distribution) + eps);


%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end

if removeLowVals
    thresh = graythresh(Ctr_distribution);  %automatic threshold
    Ctr_distribution(Ctr_distribution < thresh) = 0;
end

if removeLowVals
    thresh = graythresh(wCtr_distribution);  %automatic threshold
    wCtr_distribution(wCtr_distribution < thresh) = 0;
end