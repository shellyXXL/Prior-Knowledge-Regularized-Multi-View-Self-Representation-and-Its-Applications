function [simM,spaSimM,bgSpaSimM]= CalWeightedSimilarity(colDistM, posDistM, bgProb,pixelList,adjcMatrix)
% Calculate background probability weighted contrast

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

% adjcMatrix_nn = LinkNNAndBoundary(adjcMatrix, bdIds);
% colDistM(adjcMatrix_nn == 0) = Inf;
%adjcMatrix = (adjcMatrix * adjcMatrix + adjcMatrix) > 0;
adjcMatrix = double(adjcMatrix);
colDistM(adjcMatrix == 0) = Inf;


spaSigma = 0.4;     %sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);


colDistSigma=10;
colWeightMatrix = exp(-colDistM.^2 ./ (2 * colDistSigma * colDistSigma));

spNum = size(colWeightMatrix, 1);
if any(1 ~= colWeightMatrix(1:spNum+1:end))
    error('Diagonal elements in the weight matrix should be 1');
end
tolSim=sum(colWeightMatrix,2);
tolSimCount=sum(adjcMatrix,2);
simM=tolSim./tolSimCount;

weightedColWeightMatrix=colWeightMatrix.*posWeight;
tolSpaSim=sum(weightedColWeightMatrix,2);
spaSimM=tolSpaSim./tolSimCount;



bgSpaSimM=spaSimM.* (1-bgProb);


%bgProb weighted contrast

% Ctr = colDistM .* posWeight * ones(length(colDistM),1);
% wCtr = colDistM .* posWeight * bgProb;
% wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

%post-processing for cleaner fg cue
% removeLowVals = true;
% if removeLowVals
%     thresh = graythresh(wCtr);  %automatic threshold
%     wCtr(wCtr < thresh) = 0;
% end