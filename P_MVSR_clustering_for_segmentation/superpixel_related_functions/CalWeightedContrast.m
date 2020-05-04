function [Ctr, wCtr ]= CalWeightedContrast(colDistM, posDistM, bgProb,pixelList)
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

%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end